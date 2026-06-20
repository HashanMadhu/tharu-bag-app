import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerOrdersPage extends StatelessWidget {
  const CustomerOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 1. Email වෙනුවට ලොග් වුණු යූසර්ගේ UID එක ලබා ගැනීම
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("මගේ ඇණවුම් (My Orders)"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<QuerySnapshot>(
        // 💡 2. Firestore Query එක 'uid' එකෙන් ෆිල්ටර් වන ලෙස වෙනස් කිරීම (Rules වලට ගැලපෙන ලෙස)
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('uid', isEqualTo: currentUserId)
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

          final orderDocs = snapshot.data!.docs;

          // අලුත් ඒවා උඩට එන සේ Sort කිරීම
          orderDocs.sort((a, b) {
            final Timestamp? aDate = a['orderDate'] as Timestamp?;
            final Timestamp? bDate = b['orderDate'] as Timestamp?;
            if (aDate == null || bDate == null) return 0;
            return bDate.compareTo(aDate);
          });

          return ListView.builder(
            itemCount: orderDocs.length,
            itemBuilder: (context, index) {
              final order = orderDocs[index].data() as Map<String, dynamic>;
              final String status = order['status'] ?? 'Pending';

              // Firestore එකෙන් අලුත් දත්ත කියවා ගැනීම සහ Fallback යෙදීම
              final double price = (order['price'] ?? 0.0).toDouble();
              final int quantity = order['quantity'] ?? 1;
              final double totalPrice =
                  (order['totalPrice'] ?? (price * quantity)).toDouble();

              // Status එක අනුව පාට තෝරාගැනීම
              Color statusColor = Colors.orange;
              if (status == 'Processing') statusColor = Colors.blue;
              if (status == 'Delivered') statusColor = Colors.green;

              // දිනය සහ වේලාව සකසා ගැනීම
              final Timestamp? timestamp = order['orderDate'] as Timestamp?;
              String formattedDate = 'No Date';
              if (timestamp != null) {
                final date = timestamp.toDate();
                formattedDate =
                    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                // 💡 මෙතන තිබ්බ Duplicate child එක අයින් කරලා කෝඩ් එක පිළිවෙලක් කලා
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              order['bagType'] ?? 'Unknown Bag',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
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
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.shopping_basket_outlined,
                            color: Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "ප්‍රමාණය (Quantity): ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "$quantity",
                            style: const TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "  (Rs. ${price.toStringAsFixed(2)} බැගින්)",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.payments_outlined,
                            color: Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "මුළු මුදල (Total Amount): ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Rs. ${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.grey, size: 18),
                          const SizedBox(width: 10),
                          const Text(
                            "දුරකථන අංකය: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "0${order['contact'] ?? ''}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "ලිපිනය: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              order['address'] ?? 'ලිපිනයක් නොමැත',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "ඇණවුම් කළ දිනය: ",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
