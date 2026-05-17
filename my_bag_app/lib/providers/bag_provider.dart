import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// මෙය අපේ "පෙට්ටිය" වගෙයි. මෙහි බෑග් එකේ නම (String) ගබඩා කර තිබෙනවා.
// ආරම්භයේදී කිසිවක් තෝරා නැති නිසා අපි මෙය empty string ('') එකක් ලෙස තබමු.
final selectedBagProvider = StateProvider<String>((ref) {
  return ''; 
});

//Database එකෙන් බෑග් ලිස්ට් එකම ගන්නවා.
final dbBagTypesProvider = StreamProvider<List<String>>((ref) {
  return FirebaseFirestore.instance
      .collection('categories')
      .snapshots()
      .map((snapshot) {
        // හැම Document එකකම තියෙන 'name' එක විතරක් අරන් List එකක් හදනවා
        return snapshot.docs
            .map((doc) => doc['name'] as String)
            .toList();
      });
});