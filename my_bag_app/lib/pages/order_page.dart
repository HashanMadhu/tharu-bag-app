import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Riverpod import කරන්න
import '../providers/bag_provider.dart'; // 2. අපි හදපු provider එක import කරන්න
import '../shared/validators/form_validators.dart'; // 3. FormValidators import කරන්න
import 'bill_page.dart'; // 2. BillPage එක import කරන්න
import '../shared/widgets/app_drawer.dart'; // Drawer එක import කරන්න

// StatefulWidget වෙනුවට ConsumerStatefulWidget පාවිච්චි කරමු
class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({super.key});

  @override
  ConsumerState<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  final List<String> bagTypes = [
    'School Bag',
    'Hand Bag',
    'Travel Bag',
    'Lunch Bag',
  ];

  final _formKey = GlobalKey<FormState>(); // Form එකේ තත්ත්වය පරීක්ෂා කිරීමට

  // 3. පාරිභෝගික නම ලබාගන්නා Controller එක
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController
        .dispose(); // ඇප් එකේ මෙම පේජ් එක වසා දැමූ විට මතකය (Memory) නිදහස් කිරීමට
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedBag = ref.watch(selectedBagProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Your Order'),
        backgroundColor: Colors.brown,
      ),
      drawer: const AppDrawer(), // Drawer එක සෑම පිටුවකටම එකතු කරන්න
      
      // // මෙන්න මේ කොටස අලුතින් එකතු කරන්න
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       // මෙනුවේ ඉහළ කොටස (Header)
      //       const DrawerHeader(
      //         decoration: BoxDecoration(color: Colors.brown),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             // ලෝගෝව පෙන්වන කොටස (Asset Image එකක් පාවිච්චි කරමු)
      //             const CircleAvatar(
      //               radius: 40,
      //               backgroundColor: Colors.white,
      //               backgroundImage: AssetImage(
      //                 'assets/bag_logo.png',
      //               ), // ඔබේ ලෝගෝවේ පාර (Path)
      //             ),
      //             const SizedBox(height: 10),
      //             const Text(
      //               'Tharu Bag Center',
      //               style: TextStyle(color: Colors.white),
      //             ),
      //           ],
      //         ),
      //       ),

      //       // මෙනු අයිතම (Menu Items)
      //       ListTile(
      //         leading: const Icon(Icons.home),
      //         title: const Text('Home'),
      //         onTap: () {
      //           Navigator.pop(context); // Drawer එක වසා දැමීමට
      //           // 2. Home Page එකට යන්න (කලින් පිටු සියල්ල ඉවත් කර)
      //           Navigator.of(context).popUntil((route) => route.isFirst);
      //         },
      //       ),

      //       ListTile(
      //         leading: const Icon(Icons.shopping_cart),
      //         title: const Text('Orders'),
      //         onTap: () {
      //           // පසුව Order History පෙන්වන පේජ් එකකට යාමට හැක
      //           Navigator.pop(context);
      //           Navigator.of(context).popUntil(
      //             (route) => route.isFirst,
      //           ); // orders page එකට යාමට 
      //         },
      //       ),

      //       ListTile(
      //         leading: const Icon(Icons.history),
      //         title: const Text('Order History'),
      //         onTap: () {
      //           // පසුව ඉතිහාසය පෙන්වන පේජ් එකකට යාමට හැක
      //           Navigator.pop(context);
      //         },
      //       ),
      //       const Divider(), // ඉරක් ඇඳීමට
      //       ListTile(
      //         leading: const Icon(Icons.contact_phone),
      //         title: const Text('Contact Us'),
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //     ],
      //   ),
      // ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // 1. Padding එකට පසුව Form එක මෙතැනට දමන්න
          key: _formKey, // මෙය කලින් පියවරේදී හැදූ GlobalKey එකයි
          child: SingleChildScrollView(
            // 2. Scroll කිරීමට මෙය එකතු කරන්න
            child: Column(
              children: [
                // --- පවතින Dropdown කොටස ---
                DropdownButtonFormField<String>(
                  value: selectedBag.isEmpty ? null : selectedBag,
                  decoration: const InputDecoration(
                    labelText: 'Select Bag Type',
                  ),
                  items: bagTypes
                      .map(
                        (bag) => DropdownMenuItem(value: bag, child: Text(bag)),
                      )
                      .toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      ref.read(selectedBagProvider.notifier).state = newValue;
                    }
                  },
                ),
                const SizedBox(height: 30),

                if (selectedBag.isNotEmpty)
                  Text(
                    'You selected: $selectedBag',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                const SizedBox(height: 30),

                // --- පවතින පින්තූර පෙන්වන කොටස (Container) ---
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown.shade200),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: selectedBag.isEmpty
                      ? const Center(
                          child: Text("Please select a bag to see the image"),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            selectedBag == 'School Bag'
                                ? 'https://m.media-amazon.com/images/I/81+m10G+XhL._AC_SL1500_.jpg'
                                : selectedBag == 'Hand Bag'
                                ? 'https://m.media-amazon.com/images/I/71mJ0u8B+SL._AC_UY1100_.jpg'
                                : 'https://m.media-amazon.com/images/I/71vunL6tG1L._AC_SL1500_.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                ),

                const SizedBox(height: 30),

                // --- අලුතින් එක් කරන කොටස: Customer Name Field ---
                TextFormField(
                  controller: _nameController, // Controller එක assign කරන්න
                  decoration: const InputDecoration(
                    labelText: 'Customer Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: FormValidators
                      .validateName, // FormValidators එකේ validateName function එක භාවිතා කරන්න
                ),

                const SizedBox(height: 30),

                // --- අලුතින් එක් කරන කොටස: Confirm Order Button ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // සියල්ල නිවැරදි නම් BillPage එකට දත්ත යවමු
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BillPage(
                              customerName: _nameController.text, // ටයිප් කළ නම
                              bagType: selectedBag, // තෝරාගත් බෑග් එක
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Confirm Order',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
