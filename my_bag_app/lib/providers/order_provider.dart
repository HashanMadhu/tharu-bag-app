// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // ඇණවුම් ලැයිස්තුව කළමනාකරණය කරන පන්තිය
// class OrderNotifier extends StateNotifier<List<Map<String, dynamic>>> {
//   OrderNotifier() : super([]);

//   // අලුත් ඇණවුමක් එකතු කරන function එක
//   void addOrder(Map<String, dynamic> order) {
//     state = [...state, order];
//   }

//   // අවශ්‍ය නම් ඇණවුමක් ඉවත් කිරීමට (Delete)
//   void removeOrder(int index) {
//     state = [
//       for (int i = 0; i < state.length; i++)
//         if (i != index) state[i],
//     ];
//   }
// }

// // ඇප් එක පුරා පාවිච්චි කළ හැකි Provider එක
// final orderProvider = StateNotifierProvider<OrderNotifier, List<Map<String, dynamic>>>((ref) {
//   return OrderNotifier();
// });

import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod import කරන්න
import '../services/db_helper.dart'; // DatabaseHelper import කරන්න
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import කරන්න
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth import කරන්න

class OrderNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  OrderNotifier() : super([]) {
    _loadOrders(); // ඇප් එක පටන් ගන්නා විටම පරණ දත්ත ලෝඩ් කරන්න
  }

  // 1. SQLite වල ඇති දත්ත කියවා මතකයට (State) ලබා ගැනීම
  Future<void> _loadOrders() async {
    final orders = await DatabaseHelper.instance.queryAllOrders();
    state = orders;
  }

  // 2. අලුත් ඇණවුමක් SQLite වල සේව් කර මතකයට එකතු කිරීම
  Future<void> addOrder(Map<String, dynamic> order) async {
    await DatabaseHelper.instance.insertOrder(order);
    await _loadOrders(); // නැවත Load කිරීමෙන් UI එක Update වේ
  }

  // 3. ඇණවුමක් SQLite වලින් මැකීම
  Future<void> removeOrder(int id) async {
    await DatabaseHelper.instance.deleteOrder(id);
    await _loadOrders(); // නැවත Load කිරීමෙන් UI එක Update වේ
  }
}

// final orderProvider =
//     StateNotifierProvider<OrderNotifier, List<Map<String, dynamic>>>((ref) {
//       return OrderNotifier();
//     });

// ⭐ Firestore එකේ 'orders' collection එක සජීවීව බලාගන්නා StreamProvider එක
final orderProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection('orders')
      .orderBy('orderDate', descending: true) // අලුත්ම ඕඩර්ස් උඩටම එන්න
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          // Document එකේ දත්ත සමඟ එහි ID එකත් එකතු කරලා Map එකක් හදනවා
          var data = doc.data();
          data['id'] =
              doc.id; // Firestore Document ID එක (Delete කරන්න ඕන වෙනවා)
          return data;
        }).toList();
      });
});

// 2. ⭐ දැනට Log වෙලා ඉන්න User ඇඩ්මින් කෙනෙක්ද කියලා බලන Provider එක
final adminCheckProvider = FutureProvider<bool>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  
  if (user == null) {
    print("DEBUG: User කෙනෙක් Log වෙලා නැහැ!");
    return false; 
  }
  
  print("DEBUG: දැනට ඉන්න User ගේ UID එක: ${user.uid}");

  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      print("DEBUG: Firestore එකෙන් ආපු දත්ත: $data");
      
      bool isAdmin = data.containsKey('role') && data['role'] == 'admin';
      print("DEBUG: මේ User ඇඩ්මින් කෙනෙක්ද?: $isAdmin");
      return isAdmin;
    } else {
      print("DEBUG: Firestore එකේ මේ UID එකෙන් Document එකක් නැහැ!");
    }
  } catch (e) {
    print("DEBUG: Firestore Error එකක් ආවා: $e");
  }
  return false; 
});