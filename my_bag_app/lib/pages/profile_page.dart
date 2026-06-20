import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // දැනට ලොග් වෙලා ඉන්න යූසර්ගේ විස්තර Firebase Auth එකෙන් ගන්නවා
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- Profile Icon ---
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.brown.shade100,
              child: const Icon(Icons.person, size: 70, color: Colors.brown),
            ),
            const SizedBox(height: 20),

            // --- User Email ---
            Text(
              user?.email ?? 'No Email Found',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
