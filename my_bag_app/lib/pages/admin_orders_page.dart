import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/order_provider.dart';

class AdminOrdersPage extends ConsumerWidget {
  const AdminOrdersPage({super.key});

  Future<bool> _checkIsAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.exists && doc.data() != null && doc.data()!['role'] == 'admin';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: _checkIsAdmin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.brown)),
          );
        }

        if (snapshot.hasError || snapshot.data == false) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Access Denied"),
              backgroundColor: Colors.red,
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 80, color: Colors.red),
                  SizedBox(height: 15),
                  Text(
                    "ඔබට මෙම පිටුව බැලීමට අවසර නැත!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }

        // 👑 ඇඩ්මින් නම් ඕඩර්ස් ලිස්ට් එක පෙන්වීම
        final ordersAsync = ref.watch(orderProvider);

        return Scaffold(
          appBar: AppBar(
            title: const Text("ලැබුණු ඇණවුම් (Admin)"),
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
          ),
          backgroundColor: Colors.grey[100],
          body: ordersAsync.when(
            data: (orders) {
              if (orders.isEmpty) {
                return const Center(
                  child: Text("තවමත් ඇණවුම් කිසිවක් ලැබී නැත."),
                );
              }
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];

                  // 💡 intl පැකේජ් එක නැතුව Flutter වලින්ම දිනය සකසා ගැනීම:
                  final Timestamp? timestamp = order['orderDate'] as Timestamp?;
                  String formattedDate = 'No Date';
                  if (timestamp != null) {
                    final date = timestamp.toDate();
                    formattedDate =
                        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- 👤 Customer Name & Status ---
                          Row(
                            // 💡 MainAxisAlignment.between වෙනුවට නිවැරදි වචනය වන spaceBetween යෙදුවා
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order['customerName'] ?? 'නමක් නොමැත',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              Chip(
                                label: Text(
                                  order['status'] ?? 'Pending',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: Colors.orange,
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 5),

                          // --- 🎒 Bag Type ---
                          Row(
                            children: [
                              const Icon(Icons.backpack, color: Colors.grey),
                              const SizedBox(width: 10),
                              const Text(
                                "ඇණවුම් කළ බෑගය: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                order['bagType'] ?? 'Unknown',
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // --- 📞 Contact Number ---
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.grey),
                              const SizedBox(width: 10),
                              const Text(
                                "දුරකථන අංකය: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("0${order['contact'] ?? ''}"),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // --- 📍 Delivery Address ---
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey),
                              const SizedBox(width: 10),
                              const Text(
                                "ලිපිනය: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  order['address'] ?? 'ලිපිනයක් නොමැත',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // --- 📅 Order Date ---
                          Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.grey),
                              const SizedBox(width: 10),
                              const Text(
                                "දිනය සහ වේලාව: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
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
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.brown),
            ),
            error: (err, stack) =>
                Center(child: Text("දත්ත ලබා ගැනීමේදී දෝෂයක්: $err")),
          ),
        );
      },
    );
  }
}
