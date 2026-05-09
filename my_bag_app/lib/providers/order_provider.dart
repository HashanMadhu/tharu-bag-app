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

final orderProvider =
    StateNotifierProvider<OrderNotifier, List<Map<String, dynamic>>>((ref) {
      return OrderNotifier(); 
    });
