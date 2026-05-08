import 'package:flutter_riverpod/flutter_riverpod.dart';

// ඇණවුම් ලැයිස්තුව කළමනාකරණය කරන පන්තිය
class OrderNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  OrderNotifier() : super([]);

  // අලුත් ඇණවුමක් එකතු කරන function එක
  void addOrder(Map<String, dynamic> order) {
    state = [...state, order];
  }

  // අවශ්‍ය නම් ඇණවුමක් ඉවත් කිරීමට (Delete)
  void removeOrder(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }
}

// ඇප් එක පුරා පාවිච්චි කළ හැකි Provider එක
final orderProvider = StateNotifierProvider<OrderNotifier, List<Map<String, dynamic>>>((ref) {
  return OrderNotifier();
});