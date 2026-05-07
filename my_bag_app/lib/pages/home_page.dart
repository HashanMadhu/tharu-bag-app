import 'package:flutter/material.dart';
import 'order_page.dart';
import '../shared/widgets/app_drawer.dart';
import '../models/bag_model.dart';

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

                //Body එක ඇතුළත Column එකේ අයිකන තිබුණු තැනට මෙය දමන්න:
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ElevatedButton.icon(
            //       onPressed: () => Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => const OrderPage()),
            //       ),
            //       icon: const Icon(Icons.add_shopping_cart),
            //       label: const Text("ඇණවුම් කරන්න"),
            //       style: ElevatedButton.styleFrom(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 20,
            //           vertical: 12,
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 20),
            //     // ඇමතුම් ලබාගැනීම පසුව සැකසිය හැක
            //   ],
            // ),
            // Body එක ඇතුළත Column එකේ අයිකන තිබුණු තැනට මෙය දමන්න:
            GridView.builder(
              shrinkWrap:
                  true, // GridView එකේ height එක content එකට අනුව සකසන්න
              physics:
                  const NeverScrollableScrollPhysics(), // පිටුව scroll වීමට ඉඩ දීමට
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // පේළියකට අයිතම 2 බැගින්
                childAspectRatio: 0.8, // කොටුවල හැඩය
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: tharuBags.length,
              itemBuilder: (context, index) {
                final bag = tharuBags[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(bag.imagePath, height: 80),
                      const SizedBox(height: 10),
                      Text(
                        bag.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Rs. ${bag.price}",
                        style: const TextStyle(color: Colors.brown),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderPage(
                                selectedBag: bag.name, // බෑගයේ නම යවනවා
                                price: bag.price, // මිල යවනවා
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          minimumSize: const Size(80, 30),
                        ),
                        child: const Text(
                          "Select",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
