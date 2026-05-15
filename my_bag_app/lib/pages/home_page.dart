import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import '../services/auth_service.dart';
import '../shared/widgets/app_drawer.dart'; // Drawer එක අමතක කළේ නැහැ දැන්

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      // 1. කලින් තිබුණු විදිහටම AppBar එක සහ Logout Button එක
      appBar: AppBar(
        title: const Text("THARU BAGS", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),

      // 2. ඔබ කිව්ව අමතක වුණු Drawer එක මෙන්න
      drawer: const AppDrawer(),

      // 3. Admin ට විතරක් පේන ප්ලස් බොත්තම
      floatingActionButton: uid == null 
        ? null 
        : StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                if (userData['role'] == 'admin') {
                  return FloatingActionButton(
                    onPressed: () {
                      // මෙතැනදී බෑග් වර්ග එකතු කරන පිටුවට යමු
                      print("Admin Page එකට යන්න සූදානම්");
                    },
                    backgroundColor: Colors.brown,
                    child: const Icon(Icons.add, color: Colors.white),
                  );
                }
              }
              return const SizedBox();
            },
          ),

      // 4. බෑග් වර්ග පෙන්වන ප්‍රධාන Grid එක
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("තවම බෑග් වර්ග එකතු කර නැත."));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var category = snapshot.data!.docs[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // පින්තූරයක් තිබේ නම් එය පෙන්වීමට (පසුව සකස් කරමු)
                    const Icon(Icons.shopping_bag, size: 50, color: Colors.brown),
                    const SizedBox(height: 10),
                    Text(
                      category['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}