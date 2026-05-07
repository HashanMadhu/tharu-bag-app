import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod package එක import කිරීම

void main() {
  runApp(
    const ProviderScope( // Riverpod එකේ ProviderScope එකෙන් app එක wrap කිරීම
      child: TharuBagApp(),
    ),
  );
}

class TharuBagApp extends StatelessWidget {
  const TharuBagApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tharu Bag Center',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: HomePage(), // වෙනම Class එකක් ලෙස මෙතැනට ලබා දෙන්න
    );
  }
}
