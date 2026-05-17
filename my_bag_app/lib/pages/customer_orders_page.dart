import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerOrdersPage extends StatelessWidget {
  const CustomerOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 දැනට ලොග් වෙලා ඉන්න කස්ටමර්ගේ Email එක ලබා ගැනීම
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("මගේ ඇණවුම් (My Orders)"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      // 💡 StreamBuilder එකක් හරහා Firestore එකෙන් මේ කස්ටමර්ගේ ඕඩර්ස් විතරක් සජීවීව කියවීම
      body: StreamBuilder<QuerySnapshot>(
        // 💡 .orderBy කොටස අයින් කරලා සරල කේතයක් පාවිච්චි කළා (Composite Index Error එක මඟහරවා ගැනීමට)
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('customerEmail', isEqualTo: currentUserEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.brown),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("ඔබ තවමත් කිසිදු ඇණවුමක් සිදු කර නැත."),
            );
          }

          // 💡 1. Firestore එකෙන් ආපු Documents ටික ලිස්ට් එකකට ගන්නවා
          final orderDocs = snapshot.data!.docs;

          // 💡 2. අලුත්ම ඕඩර් එක උඩටම එන විදිහට Dart වලින්ම (Locally) Sort කරගන්නවා
          orderDocs.sort((a, b) {
            final Timestamp? aDate = a['orderDate'] as Timestamp?;
            final Timestamp? bDate = b['orderDate'] as Timestamp?;
            if (aDate == null || bDate == null) return 0;
            return bDate.compareTo(aDate); // අලුත් ඒවා උඩට (Descending)
          });

          return ListView.builder(
            itemCount: orderDocs.length,
            itemBuilder: (context, index) {
              final order = orderDocs[index].data() as Map<String, dynamic>;
              final String status = order['status'] ?? 'Pending';

              // Status එක අනුව පාට වෙනස් කිරීම
              Color statusColor = Colors.orange;
              if (status == 'Processing') statusColor = Colors.blue;
              if (status == 'Delivered') statusColor = Colors.green;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 2,
                child: ListTile(
                  leading: Icon(Icons.backpack, color: statusColor, size: 35),
                  title: Text(
                    order['bagType'] ?? 'Unknown Bag',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("ලිපිනය: ${order['address'] ?? ''}"),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
