import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/order_provider.dart';

class AdminOrdersPage extends ConsumerWidget {
  const AdminOrdersPage({super.key});

  // 🔐 ඇඩ්මින් කෙනෙක්දැයි පරීක්ෂා කිරීම
  Future<bool> _checkIsAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.exists && doc.data() != null && doc.data()!['role'] == 'admin';
  }

  // 🔄 1. ඕඩර් එකේ Status එක අප්ඩේට් කරන Function එක
  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'status': newStatus},
      );
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  // 🗑️ 2. ඕඩර් එක Delete කරන Function එක
  Future<void> _deleteOrder(BuildContext context, String orderId) async {
    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("ඇණවුම මකා දැමීම"),
            content: const Text(
              "ඔබට මෙම ඇණවුම සම්පූර්ණයෙන්ම මකා දැමීමට අවශ්‍යද?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("නැත", style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("ඔව්", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      try {
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .delete();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("ඇණවුම සාර්ථකව මකා දැමුවා!"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print("Error deleting order: $e");
      }
    }
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
              child: Text(
                "ඔබට මෙම පිටුව බැලීමට අවසර නැත!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

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
                  final String orderId = order['id'] ?? '';
                  final String currentStatus = order['status'] ?? 'Pending';

                  // 💡 Firestore එකෙන් අලුත් දත්ත කියවා ගැනීම සහ Fallback යෙදීම
                  final double price = (order['price'] ?? 0.0).toDouble();
                  final int quantity =
                      order['quantity'] ?? 1; // පරණ දත්ත නම් default 1 පෙන්වයි
                  final double totalPrice =
                      (order['totalPrice'] ?? (price * quantity)).toDouble();

                  // දිනය සකසා ගැනීම
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
                          // --- 👤 Customer Name & Delete Button ---
                          Row(
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
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => _deleteOrder(context, orderId),
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
                              Expanded(
                                child: Text(
                                  order['bagType'] ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // --- 🔢 🌟 අලුතින් එකතු කළ කොටස: Quantity & Unit Price ---
                          Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // 💡 පේළි 2ක් ආවොත් අයිකන් එක උඩින් තියාගන්න
                            children: [
                              const Icon(
                                Icons.shopping_basket_outlined,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              // 💡 Expanded එකක් ඇතුළේ Text.rich පාවිච්චි කිරීමෙන් Overflow එක සම්පූර්ණයෙන්ම නැති වේ
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: "ප්‍රමාණය (Quantity): ",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "$quantity",
                                        style: const TextStyle(
                                          color: Colors.brown,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "  (Rs. ${price.toStringAsFixed(2)} බැගින්)",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                          fontWeight: FontWeight
                                              .normal, // තද අකුරු නොවන ලෙස
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // --- 💵 🌟 අලුතින් එකතු කළ කොටස: Total Price ---
                          Row(
                            children: [
                              const Icon(
                                Icons.payments_outlined,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "මුළු මුදල (Total Amount): ",
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                          const SizedBox(height: 10),
                          const Divider(),

                          // --- 🔄 Status Dropdown Editable Section ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "තත්ත්වය වෙනස් කරන්න (Status):",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DropdownButton<String>(
                                value:
                                    [
                                      'Pending',
                                      'Processing',
                                      'Delivered',
                                    ].contains(currentStatus)
                                    ? currentStatus
                                    : 'Pending',
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.brown,
                                ),
                                underline: Container(),
                                style: const TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold,
                                ),
                                items:
                                    <String>[
                                      'Pending',
                                      'Processing',
                                      'Delivered',
                                    ].map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null &&
                                      newValue != currentStatus) {
                                    _updateOrderStatus(orderId, newValue);
                                  }
                                },
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
