import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_bag_app/pages/customer_orders_page.dart';
import 'package:my_bag_app/pages/login_page.dart';
import 'package:my_bag_app/pages/about_us_page.dart'; // 🎯 1. About Us පිටුවේ Import එක මෙතනට එකතු කළා
import 'package:my_bag_app/pages/profile_page.dart'; // 💡 Profile Page එකේ Import එක මෙතනට එකතු කළා
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
              // 💡 Profile Page එක හැදුවාම මෙතන Navigate කරන්න පුළුවන්
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

          // FutureBuilder එකක් හරහා ඇඩ්මින් බොත්තම පාලනය කිරීම
          FutureBuilder<bool>(
            future: _checkIsAdmin(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return Column(
                  children: [
                    const Divider(),
                    ListTile(
                      leading: const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.brown,
                      ),
                      title: const Text('ලැබුණු ඇණවුම් (Admin Only)'),
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
              }
              return const SizedBox.shrink();
            },
          ),

          const Divider(),

          // ⭐ 2. About Us Button (යාවත්කාලීන කරන ලදී)
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.pop(context); // Drawer එක වහන්න
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUsPage(),
                ), // 🎯 AboutUsPage එකට Navigate කිරීම
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
