import 'package:flutter/material.dart';
import 'order_page.dart';
import '../shared/widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key}); // Const constructor එකක් එක් කරන්න

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("THARU BAGS"),
        // backgroundColor මෙහිදී අවශ්‍ය නැත, මන්ද අපි main.dart හි theme එක සකසා ඇති බැවිනි
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        // පේජ් එක scroll කිරීමට හැකිවන පරිදි (overflow වැළැක්වීමට)
        // පේජ් එක scroll කිරීමට හැකිවන පරිදි (overflow වැළැක්වීමට)
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.brown[50], // Theme එකට ගැළපෙන වර්ණය
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/bag_logo.png',
                height: 200,
                width: 200,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.shopping_bag,
                    size: 100,
                    color: Colors.brown,
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "අපේ බෑග් වර්ග:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildBagIcon(Icons.shopping_bag, Colors.brown),
                buildBagIcon(Icons.backpack, Colors.blue),
                buildBagIcon(Icons.work, Colors.green),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "දුරකථන: 074 259 9932",
              style: TextStyle(
                fontSize: 18,
                color: Colors.brown[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderPage()),
                  ),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text("ඇණවුම් කරන්න"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // ඇමතුම් ලබාගැනීම පසුව සැකසිය හැක
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget buildBagIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 40),
    );
  }
}
