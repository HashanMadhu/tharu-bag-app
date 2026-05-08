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
          ? const Center(child: Text("තවමත් ඇණවුම් කිසිවක් ලැබී නැත."))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: CircleAvatar(
                      backgroundColor: Colors.brown[100],
                      child: const Icon(
                        Icons.shopping_basket,
                        color: Colors.brown,
                      ),
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
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Delete කිරීමට පෙර තහවුරු කරගැනීමට (Confirmation) Dialog එකක් පෙන්වමු
                        _showDeleteDialog(context, ref, index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ඇණවුම ඉවත් කරන්නද?"),
        content: const Text(
          "මෙම ඇණවුම පද්ධතියෙන් ස්ථිරවම ඉවත් කිරීමට ඔබට අවශ්‍යද?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("නැත"),
          ),
          TextButton(
            onPressed: () {
              // Provider එක හරහා ඇණවුම ඉවත් කිරීම
              ref.read(orderProvider.notifier).removeOrder(index);
              Navigator.pop(context);

              // සාර්ථකව ඉවත් වූ බව පෙන්වීමට
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("ඇණවුම සාර්ථකව ඉවත් කළා")),
              );
            },
            child: const Text(
              "ඔව්, ඉවත් කරන්න",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
