import 'package:flutter/material.dart';
import 'order_page.dart';
import '../shared/widgets/app_drawer.dart';
import '../models/bag_model.dart';
import '../services/database_service.dart'; // 1. DatabaseService එක import කරන්න
import '../models/category_model.dart'; // CategoryModel එක import කරන්න

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("THARU BAGS")),
      drawer: const AppDrawer(),

      //For testing to connect to Firebase and upload a category (මෙතැනට FloatingActionButton එකක් එක් කරලා තියෙන්නේ)
      // 2. මෙන්න මෙතැනට FloatingActionButton එක එකතු කළා
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     // DatabaseService එකේ function එක call කිරීම
      //     await DatabaseService().uploadCategory();

      //     // සාර්ථක වුණාම පණිවිඩයක් පෙන්වන්න
      //     if (context.mounted) {
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(content: Text('Firebase එකට දත්ත යැව්වා!')),
      //       );
      //     }
      //   },
      //   backgroundColor: Colors.brown,
      //   child: const Icon(Icons.cloud_upload, color: Colors.white),
      // ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.brown[50],
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

            // GridView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   padding: const EdgeInsets.all(15),
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     childAspectRatio: 0.8,
            //     crossAxisSpacing: 15,
            //     mainAxisSpacing: 15,
            //   ),
            //   itemCount: tharuBags.length,
            //   itemBuilder: (context, index) {
            //     final bag = tharuBags[index];
            //     return Container(
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(15),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.grey.withOpacity(0.1),
            //             blurRadius: 5,
            //           ),
            //         ],
            //       ),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Image.asset(bag.imagePath, height: 80),
            //           const SizedBox(height: 10),
            //           Text(
            //             bag.name,
            //             style: const TextStyle(fontWeight: FontWeight.bold),
            //           ),
            //           Text(
            //             "Rs. ${bag.price}",
            //             style: const TextStyle(color: Colors.brown),
            //           ),
            //           const SizedBox(height: 10),
            //           ElevatedButton(
            //             onPressed: () {
            //               Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) => OrderPage(
            //                     selectedBag: bag.name,
            //                     price: bag.price,
            //                   ),
            //                 ),
            //               );
            //             },
            //             style: ElevatedButton.styleFrom(
            //               padding: const EdgeInsets.symmetric(horizontal: 10),
            //               minimumSize: const Size(80, 30),
            //             ),
            //             child: const Text(
            //               "Select",
            //               style: TextStyle(fontSize: 12),
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),
            StreamBuilder<List<CategoryModel>>(
              stream: DatabaseService()
                  .getCategories(), // අපි හදපු Stream එකට සම්බන්ධ වීම
              builder: (context, snapshot) {
                // 1. දත්ත එනකම් තවම බලාගෙන ඉන්නවා නම් (Loading)
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. මොකක් හරි Error එකක් ආවොත්
                if (snapshot.hasError) {
                  return Center(
                    child: Text("වැරදීමක් වුණා: ${snapshot.error}"),
                  );
                }

                // 3. දත්ත සාර්ථකව ලැබුණා නම්
                final categories = snapshot.data ?? [];

                if (categories.isEmpty) {
                  return const Center(
                    child: Text("තවම බෑග් වර්ග ඇතුළත් කර නැත."),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: categories
                      .length, // දැන් අපි ගන්නේ Firebase එකේ තියෙන ගණන
                  itemBuilder: (context, index) {
                    final category = categories[index];
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
                          // දැනට අපේ රූපය වැඩ කරන්නේ නැති නිසා Icon එකක් පෙන්වමු
                          const Icon(
                            Icons.shopping_bag,
                            size: 50,
                            color: Colors.brown,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            category.name, // Firebase එකේ නම
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // පසුව අපිට මෙය OrderPage එකට සම්බන්ධ කළ හැක
                            },
                            child: const Text("View Items"),
                          ),
                        ],
                      ),
                    );
                  },
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
