import 'package:flutter_riverpod/flutter_riverpod.dart';

// මෙය අපේ "පෙට්ටිය" වගෙයි. මෙහි බෑග් එකේ නම (String) ගබඩා කර තිබෙනවා.
// ආරම්භයේදී කිසිවක් තෝරා නැති නිසා අපි මෙය empty string ('') එකක් ලෙස තබමු.
final selectedBagProvider = StateProvider<String>((ref) {
  return ''; 
});