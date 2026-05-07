import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'order_page.dart';
import '../shared/widgets/app_drawer.dart'; // AppDrawer එක import කරන්න

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("THARU BAGS"), backgroundColor: Colors.blue),
      drawer: const AppDrawer(), // මේ පේළිය සෑම පිටුවකටම එකතු කරන්න
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
