import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  void _register() async {
    // 1. Password දෙක සමානදැයි බැලීම
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Password දෙක සමාන නැත!")));
      return;
    }

    // ඊමේල් හෝ පාස්වර්ඩ් හිස්දැයි බැලීම
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("කරුණාකර සියලුම විස්තර ඇතුළත් කරන්න!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. AuthService හරහා Register වීම
      final user = await AuthService().registerWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (user != null && mounted) {
        // Register වීම සාර්ථක නම් LoginPage එකට යන්න
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("ලියාපදිංචි වීම සාර්ථකයි! කරුණාකර ලොග් වන්න."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);

      // 🎯 Firebase Error Code එක අනුව සිංහලෙන් මැසේජ් පෙන්වීම
      String errorMessage = "ලියාපදිංචි වීම අසාර්ථකයි!";

      if (e.code == 'email-already-in-use') {
        errorMessage = "මෙම ඊමේල් ලිපිනය දැනටමත් ලියාපදිංචි කර ඇත!";
      } else if (e.code == 'weak-password') {
        errorMessage =
            "මුද්‍රිත මුරපදය (Password) දුර්වලයි! අවම අකුරු 6ක් දාන්න.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "ඇතුළත් කළ ඊමේල් ලිපිනය නිවැරදි නැත!";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        // Screen එක මදි වුණොත් Scroll කරන්න පුළුවන් වෙන්න
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password (අවම අකුරු 6ක්)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                        ),
                        child: const Text(
                          "Register Now",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
