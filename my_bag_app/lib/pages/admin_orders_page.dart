import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/order_provider.dart';

class AdminOrdersPage extends ConsumerWidget {
  const AdminOrdersPage({super.key});

  // 💡 කෙලින්ම Firestore එකෙන් Role එක ඇඩ්මින්ද කියලා බලන සරල function එකක්
  Future<bool> _checkIsAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists && doc.data() != null) {
      return doc.data()!['role'] == 'admin';
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: _checkIsAdmin(),
      builder: (context, snapshot) {
        // 1. Firestore එකෙන් දත්ත එනකම් Loading එකක් පෙන්වනවා
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.brown)),
          );
        }

        // 2. ඇඩ්මින් කෙනෙක් නෙවෙයි නම් හෝ Error එකක් ආවොත් Access Denied Screen එක පෙන්වනවා
        if (snapshot.hasError || snapshot.data == false) {
          return Scaffold(
            appBar: AppBar(title: const Text("Access Denied"), backgroundColor: Colors.red),
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

        // 3. 👑 ඇඩ්මින් කෙනෙක් කියලා 100% තහවුරු වුණොත් විතරක් ඕඩර්ස් ටික පෙන්වනවා
        final ordersAsync = ref.watch(orderProvider);

        return Scaffold(
          appBar: AppBar(
            title: const Text("ලැබුණු ඇණවුම්"),
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
          ),
          body: ordersAsync.when(
            data: (orders) {
              if (orders.isEmpty) {
                return const Center(child: Text("තවමත් ඇණවුම් කිසිවක් ලැබී නැත."));
              }
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(order['customerName'] ?? 'No Name'),
                      subtitle: Text("මුදල: රු. ${order['totalPrice'] ?? '0'}"),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.brown)),
            error: (err, stack) => Center(child: Text("දත්ත ලබා ගැනීමේදී දෝෂයක්: $err")),
          ),
        );
      },
    );
  }
}