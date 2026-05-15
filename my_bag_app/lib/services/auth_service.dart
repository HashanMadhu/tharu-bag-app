import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Firebase Auth එක හඳුන්වා දීම
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. Register පියවර (නව පරිශීලකයෙකු සෑදීම)
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("Register Error: ${e.toString()}");
      return null;
    }
  }

  // 2. Login පියවර (ඇතුල් වීම)
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("Login Error: ${e.toString()}");
      return null;
    }
  }

  // 3. Logout පියවර (ඉවත් වීම)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}