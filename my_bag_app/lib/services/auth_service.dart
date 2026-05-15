import 'package:firebase_auth/firebase_auth.dart'; // 1. Firebase Authentication package එක import කිරීම
import 'package:cloud_firestore/cloud_firestore.dart'; // 1. Firestore package එක import කිරීම

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db =
      FirebaseFirestore.instance; // 2. Firestore සම්බන්ධය හැදුවා

  // ලියාපදිංචි වීමේදී Firestore එකටත් දත්ත යවනවා
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // 3. පරිශීලකයා ලියාපදිංචි වුණු ගමන් Firestore එකේ 'users' කියලා තැනක සේව් කරනවා
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'role': 'user', // හැමෝම මුලින් 'user' වෙන්නේ
        });
      }
      return user;
    } catch (e) {
      print("Register Error: ${e.toString()}");
      return null;
    }
  }

  // Login වීම (පරණ විදිහමයි)
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Login Error: ${e.toString()}");
      return null;
    }
  }

  // Logout වීම (පරණ විදිහමයි)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
