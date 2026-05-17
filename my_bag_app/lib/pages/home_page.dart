import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_bag_app/pages/order_page.dart';
import 'login_page.dart';
import 'admin_add_category.dart';
import '../services/auth_service.dart';
import '../shared/widgets/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAdmin = false; // දැනට ලොග් වී ඉන්නේ Admin ද කියා තබා ගැනීමට
  String? uid;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  // පරිශීලකයා Admin ද නැද්ද කියා මුලින්ම පරික්ෂා කිරීම
  void _checkAdminStatus() async {
    uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (userDoc.exists && userDoc.data() != null) {
        var userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          isAdmin = userData['role'] == 'admin';
        });
      }
    }
  }

  // බෑග් වර්ගය Firestore එකෙන් මැකීමේ Function එක
  void _deleteCategory(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(docId)
          .delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("බෑග් වර්ගය සාර්ථකව මකා දැමුවා!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // මකා දැමීමට පෙර Admin ගෙන් ස්ථිරවම අහන Pop-up Dialog Box එක
  void _showDeleteDialog(String docId, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Bag Type"),
        content: Text("ඔබට ස්ථිරවම '$name' බෑග් වර්ගය මකා දැමීමට අවශ්‍යද?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCategory(docId); // Delete Function එක Call කිරීම
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("THARU BAGS", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Colors.white),
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
      drawer: const AppDrawer(),

      // Admin නම් පමණක් FloatingActionButton එක පෙන්වීම
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminAddCategoryPage(),
                  ),
                ).then(
                  (_) => _checkAdminStatus(),
                ); // ආපසු එද්දී නැවත Check කිරීම
              },
              backgroundColor: Colors.brown,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,

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
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var category = snapshot.data!.docs[index];
              String docId = category.id; // Firestore Document ID එක ගැනීම
              String name = category['name'] ?? 'No Name';
              double price = (category['price'] ?? 0.0).toDouble();
              String imageUrl = category['imageUrl'] ?? '';

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                clipBehavior: Clip.antiAlias,
                // ⭐ මෙන්න මෙතැනට InkWell එකක් එකතු කළා, එතකොට Card එක ක්ලික් කරන්න පුළුවන්!
                child: InkWell(
                  onTap: () {
                    // බෑග් එක ක්ලික් කළ විට OrderPage එකට දත්ත රැගෙන යාම
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderPage(selectedBag: name, price: price),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // පින්තූරය පෙන්වන කොටස
                          Expanded(
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    // ⭐ වැරදි ලින්ක් එකක් ආවොත් ඇප් එක බේරගන්න errorBuilder එකක් දැම්මා:
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        color: Colors.grey[100],
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.broken_image,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "ලින්ක් එක වැරදියි!",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: double.infinity,
                                    color: Colors.grey[100],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          // විස්තර පෙන්වන කොටස
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Rs. ${price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Delete Button එක (Admin ට විතරයි පේන්නේ)
                      if (isAdmin)
                        Positioned(
                          top: 5,
                          right: 5,
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteDialog(docId, name),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
