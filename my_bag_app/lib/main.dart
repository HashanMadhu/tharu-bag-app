// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyFirstApp());
// }

// class MyFirstApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: Text("THARU BAGS"), backgroundColor: Colors.blue),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // පින්තූරය සහ සාදරයෙන් පිළිගනිමු යන කොටස සහිත Container එක
//             Container(
//               padding: EdgeInsets.all(20),
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               decoration: BoxDecoration(
//                 color: Colors.orange[50],
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Image.network(
//                     'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=300&q=80',
//                     height: 120,
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "THARU BAGS වෙත සාදරයෙන් පිළිගනිමු!",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 30),

//             Text(
//               "අපේ බෑග් වර්ග:",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),

//             SizedBox(height: 20),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 buildBagIcon(Icons.shopping_bag, Colors.brown),
//                 buildBagIcon(Icons.backpack, Colors.blue),
//                 buildBagIcon(Icons.work, Colors.green),
//               ],
//             ),

//             SizedBox(height: 30),

//             Text(
//               "ඔබට අවශ්‍ය බෑගය තෝරන්න",
//               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             ),

//             Text(
//               "දුරකථන: 074 259 9932",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.blue,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             SizedBox(height: 20),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => OrderPage()),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                   ),
//                   child: Text("ඇණවුම් කරන්න"),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () => print("Calling..."),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     foregroundColor: Colors.white,
//                   ),
//                   child: Text("අප අමතන්න"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // බෑග් අයිකන සඳහා පොදු Widget එකක් (Code එක කෙටි කිරීමට)
//   Widget buildBagIcon(IconData icon, Color color) {
//     return Container(
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Icon(icon, color: color, size: 40),
//     );
//   }
// }

// class OrderPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("ඇණවුම් පෝරමය"),
//         backgroundColor: Colors.orange,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.assignment, size: 100, color: Colors.orange),
//             SizedBox(height: 20),
//             Text(
//               "මෙහිදී ඔබේ ඇණවුම ලබා දිය හැකිය!",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyFirstApp());
}

class MyFirstApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // වෙනම Class එකක් ලෙස මෙතැනට ලබා දෙන්න
    );
  }
}

// මුල් පිටුව සඳහා වෙනම Class එකක්
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("THARU BAGS"), backgroundColor: Colors.blue),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/bag_logo.png',
                  height: 200, // පින්තූරයේ උස
                  width: 200, // පින්තූරයේ පළල
                ),
              ],
            ),
          ),
          SizedBox(height: 30),

          Text(
            "අපේ බෑග් වර්ග:",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildBagIcon(Icons.shopping_bag, Colors.brown),
              buildBagIcon(Icons.backpack, Colors.blue),
              buildBagIcon(Icons.work, Colors.green),
            ],
          ),
          SizedBox(height: 30),
          Text(
            "ඔබට අවශ්‍ය බෑගය තෝරන්න",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          Text(
            "දුරකථන: 074 259 9932",
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderPage()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text("ඇණවුම් කරන්න"),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => print("Calling..."),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text("අප අමතන්න"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBagIcon(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 40),
    );
  }
}

// දෙවැනි පිටුව
final TextEditingController _nameController = TextEditingController();

class OrderPage extends StatelessWidget {
  @override
  String selectedBagType = 'School Bag'; // Default එක ලෙස එකක් තෝරා තබමු
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ඇණවුම් පෝරමය"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            // නම ලබා ගැනීමට
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "ඔබේ නම",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            SizedBox(height: 20),

            // බෑග් වර්ගය තෝරාගැනීමට
            DropdownButtonFormField<String>(
              value: selectedBagType,
              decoration: InputDecoration(
                labelText: "බෑග් වර්ගය තෝරන්න",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items:
                  <String>[
                    'School Bag',
                    'Travel Bag',
                    'Hand Bag',
                    'Lunch Bag',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                selectedBagType = newValue!;
              },
            ),

            SizedBox(height: 20),

            // දුරකථන අංකය ලබා ගැනීමට
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "දුරකථන අංකය",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              // onPressed: () {
              //   // පණිවිඩය පෙන්වන කොටස
              //   String name = _nameController.text;
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text('ස්තූතියි $name, ඔබේ ඇණවුම සාර්ථකව ලැබුණා!'),
              //       backgroundColor:
              //           Colors.green, // සාර්ථක පණිවිඩයක් නිසා කොළ පාට යොදමු
              //       duration: Duration(seconds: 3), // තත්පර 3ක් පෙන්වන්න
              //       behavior: SnackBarBehavior
              //           .floating, // තිරයේ පාවෙන ආකාරයට පෙන්වීමට
              //     ),
              //   );
              // },
              onPressed: () async {
                String name = _nameController.text;
                // ජාත්‍යන්තර ක්‍රමයට අංකය (94 සමඟ)
                String myNumber = "94742599932";
                String message =
                    "Tharu Bag Center - නව ඇණවුමක්!\n\n"
                    "පාරිභෝගික නම: $name\n"
                    "බෑග් වර්ගය: $selectedBagType";

                // WhatsApp පණිවිඩය සඳහා ලින්ක් එක
                var whatsappUrl =
                    "https://wa.me/$myNumber?text=${Uri.encodeComponent(message)}";
                Uri uri = Uri.parse(whatsappUrl);

                if (name.isNotEmpty) {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('WhatsApp විවෘත කළ නොහැකි විය')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('කරුණාකර ඔබේ නම ඇතුළත් කරන්න')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                "තහවුරු කරන්න",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
