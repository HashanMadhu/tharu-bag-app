import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_bag_app/pages/customer_orders_page.dart';
import 'package:my_bag_app/pages/login_page.dart';
import 'package:my_bag_app/pages/about_us_page.dart';
import 'package:my_bag_app/pages/profile_page.dart';
import '../../pages/order_page.dart';
import '../../pages/home_page.dart';
import '../../pages/admin_orders_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

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
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.brown),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/bag_logo.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'Tharu Bag Center',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Home Button
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),

          // Profile Button
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),

          // Place Order Button
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Place Order'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderPage()),
              );
            },
          ),

          // My Orders Button
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('My Orders'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomerOrdersPage(),
                ),
              );
            },
          ),

          // 🎯 FutureBuilder එකක් හරහා ඇඩ්මින් බොත්තම පාලනය කිරීම + StreamBuilder Badge
          FutureBuilder<bool>(
            future: _checkIsAdmin(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where(
                        'status',
                        isEqualTo: 'Pending',
                      ) // 🔔 අලුත් ඇණවුම් විතරක් ගණනය කරයි
                      .snapshots(),
                  builder: (context, orderSnapshot) {
                    int pendingCount = 0;
                    if (orderSnapshot.hasData) {
                      pendingCount = orderSnapshot.data!.docs.length;
                    }

                    return Column(
                      children: [
                        const Divider(),
                        ListTile(
                          leading: Stack(
                            children: [
                              const Icon(
                                Icons.admin_panel_settings,
                                color: Colors.brown,
                                size: 28,
                              ),
                              // 🔴 අලුත් ඕඩර්ස් තියෙනවා නම් විතරක් රතු Badge එක පෙන්වයි
                              if (pendingCount > 0)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      '$pendingCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          title: const Text('Received Orders'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminOrdersPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),

          const Divider(),

          // About Us Button
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),

          const Divider(),

          // Log Out Button
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              Navigator.pop(context);

              try {
                await FirebaseAuth.instance.signOut();
                print("User successfully logged out from Firebase");

                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                }
              } catch (e) {
                print("Error during logout: $e");
              }
            },
          ),
        ],
      ),
    );
  }
}
