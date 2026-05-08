import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';

class AdminOrdersPage extends ConsumerWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider එකෙන් Orders ලිස්ට් එක ලබා ගැනීම
    final orders = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ලැබුණු ඇණවුම්"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text("තවමත් ඇණවුම් කිසිවක් ලැබී නැත."),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: CircleAvatar(
                      backgroundColor: Colors.brown[100],
                      child: const Icon(Icons.shopping_basket, color: Colors.brown),
                    ),
                    title: Text(
                      "පාරිභෝගිකයා: ${order['name']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("බෑග් වර්ගය: ${order['bagName']}"),
                          Text("දුරකථනය: ${order['phone']}"),
                          Text("ලිපිනය: ${order['address']}"),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            ),
    );
  }
}