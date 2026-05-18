import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_bag_app/pages/customer_orders_page.dart';
// 💡 ඔයාගේ Profile Page එක තියෙන තැන අනුව මේ import එක හරියටම හදාගන්න
// import 'package:my_bag_app/pages/profile_page.dart';
// 💡 ඔයාගේ Login Page එක තියෙන තැන අනුව මේ import එක හරියටම හදාගන්න
// import 'package:my_bag_app/pages/login_page.dart';
import 'package:my_bag_app/pages/login_page.dart';

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
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.brown),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/bag_logo.png'),
                ),
                const SizedBox(height: 10),
                const Text(
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

          // ⭐ 1. Profile Button (අලුතින් එකතු කළා)
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.pop(context); // Drawer එක වහන්න
              // 💡 ඔයා Profile Page එක හැදුවාම මෙතන Uncomment කරලා ඒ පිටුවට Navigate කරන්න
              /*
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
              */
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

          // About Us Button
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(),

          // ⭐ 2. Log Out Button (යාවත්කාලීන කරන ලදී)
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              // 1. ප්‍රථමයෙන් Drawer එක වසා දමන්න
              Navigator.pop(context);

              try {
                // 2. Firebase එකෙන් සාර්ථකව Sign Out කිරීම
                await FirebaseAuth.instance.signOut();
                print("User successfully logged out from Firebase");

                // 3. 💡 වැදගත්ම කොටස:
                // Context එක තවමත් Active ද කියලා බලා (Mounted ද කියා බලා),
                // පැරණි පිටු ඔක්කොම මතකයෙන් අයින් කරලා කෙලින්ම LoginPage එකට සාර්ථකව රැගෙන යාම.
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
