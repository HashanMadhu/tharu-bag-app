import 'package:flutter/material.dart';

void main() {
  runApp(MyFirstApp());
}

class MyFirstApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("THARU BAGS"), backgroundColor: Colors.blue),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // පින්තූරය සහ සාදරයෙන් පිළිගනිමු යන කොටස සහිත Container එක
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
                  Image.network(
                    'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=300&q=80',
                    height: 120,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "THARU BAGS වෙත සාදරයෙන් පිළිගනිමු!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
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
                  onPressed: () => print("Ordering..."),
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
      ),
    );
  }

  // බෑග් අයිකන සඳහා පොදු Widget එකක් (Code එක කෙටි කිරීමට)
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
