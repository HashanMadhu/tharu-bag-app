import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod package එක import කිරීම
import 'package:google_fonts/google_fonts.dart'; // Google Fonts package එක import කිරීම
import 'package:my_bag_app/pages/order_page.dart';
import 'pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Core package එක import කිරීම
import 'firebase_options.dart'; // 2. අර හැදුණු options file එක Import කරන්න

// void main() {
//   runApp(
//     const ProviderScope(
//       // Riverpod එකේ ProviderScope එකෙන් app එක wrap කිරීම
//       child: TharuBagApp(),
//     ),
//   );
// }

// class TharuBagApp extends StatelessWidget {
//   const TharuBagApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Tharu Bag Center',

//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.brown,
//           primary: Colors.brown,
//         ),
//         textTheme: GoogleFonts.poppinsTextTheme(
//           Theme.of(context).textTheme,
//         ), // Google Fonts එකෙන් Poppins font එක set කිරීම

//         appBarTheme: const AppBarTheme(
//           backgroundColor:
//               Colors.brown, // AppBar එකේ background color එක set කිරීම
//           foregroundColor:
//               Colors.white, // AppBar එකේ text සහ icons වල වර්ණය set කිරීම
//           centerTitle: true, // AppBar එකේ title එක center කිරීම
//           elevation:
//               2, // AppBar එකට subtle shadow එකක් ලබා දීමට elevation එක set කිරීම
//         ),
//       ),
//       home: const HomePage(),    // ඇප් එක පටන් ගන්නා විට පෙන්විය යුතු පිටුව
//     );
//   }
// }

void main() async {
  // 1. Widgets පද්ධතිය සූදානම් බව සහතික කිරීම
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Firebase සම්බන්ධ කිරීම (අනිවාර්යයෙන්ම await තිබිය යුතුයි)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Riverpod වලට අදාළ ProviderScope එක ඇතුළත ඔබේ ඇප් එක රන් කරන්න
  runApp(
    const ProviderScope(
      child: TharuBagApp(), // මෙතැන නම නිවැරදි කළා
    ),
  );
}

// ඔබ දැනටමත් සාදා ඇති Class එක
class TharuBagApp extends StatelessWidget {
  const TharuBagApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tharu Bag Center',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          primary: Colors.brown,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const HomePage(),
    );
  }
}
