// import 'package:flutter/material.dart'; // Flutter Material package එක import කිරීම
// import 'package:url_launcher/url_launcher.dart'; // url_launcher package එක import කිරීම

// // දෙවැනි පිටුව
// // මුලින්ම StatefulWidget එක නිර්මාණය කරමු
// class OrderPage extends StatefulWidget {
//   @override
//   _OrderPageState createState() => _OrderPageState();
// }

// class _OrderPageState extends State<OrderPage> {
//   final TextEditingController _nameController = TextEditingController();

//   // 1. පියවර: මෙන්න Logic එක තිබිය යුතු තැන (Variable & Function)
//   String selectedBagType = 'School Bag';

//   String getBagImage(String type) {
//     switch (type) {
//       case 'School Bag':
//         return 'assets/school_bag.png';
//       case 'Travel Bag':
//         return 'assets/travel_bag.png';
//       case 'Hand Bag':
//         return 'assets/hand_bag.png';
//       case 'Lunch Bag':
//         return 'assets/lunch_bag.png';
//       default:
//         return 'assets/bag_logo.png';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("ඇණවුම් පෝරමය"),
//         backgroundColor: Colors.orange,
//       ),
//       body: SingleChildScrollView(
//         // Screen එක Scroll කිරීමට හැකි වීමට (Keyboard එක ආ විට වැදගත් වේ)
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             // පින්තූරය පෙන්වන තැන
//             Container(
//               height: 200,
//               width: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(color: Colors.orange.shade100),
//               ),
//               child: Image.asset(
//                 getBagImage(selectedBagType), // Logic එක මෙතැනට සම්බන්ධ වේ
//                 fit: BoxFit.contain,
//               ),
//             ),

//             SizedBox(height: 20),

//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 labelText: "ඔබේ නම",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.person),
//               ),
//             ),

//             SizedBox(height: 20),

//             // Dropdown එක
//             DropdownButtonFormField<String>(
//               value: selectedBagType,
//               decoration: InputDecoration(
//                 labelText: "බෑග් වර්ගය තෝරන්න",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.category),
//               ),
//               items: ['School Bag', 'Travel Bag', 'Hand Bag', 'Lunch Bag']
//                   .map(
//                     (String value) =>
//                         DropdownMenuItem(value: value, child: Text(value)),
//                   )
//                   .toList(),
//               onChanged: (String? newValue) {
//                 // 2. පියවර: තිරය Refresh කිරීමට setState භාවිතා කිරීම
//                 setState(() {
//                   selectedBagType = newValue!;
//                 });
//               },
//             ),

//             SizedBox(height: 20),

//             TextField(
//               keyboardType: TextInputType.phone,
//               decoration: InputDecoration(
//                 labelText: "දුරකථන අංකය",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.phone),
//               ),
//             ),

//             SizedBox(height: 30),

//             ElevatedButton(
//               onPressed: () async {
//                 String name = _nameController.text;
//                 String myNumber = "94742599932";
//                 String message =
//                     "Tharu Bag Center - නව ඇණවුමක්!\n\n"
//                     "පාරිභෝගික නම: $name\n"
//                     "බෑග් වර්ගය: $selectedBagType";

//                 var whatsappUrl =
//                     "https://wa.me/$myNumber?text=${Uri.encodeComponent(message)}";
//                 Uri uri = Uri.parse(whatsappUrl);

//                 if (name.isNotEmpty) {
//                   if (await canLaunchUrl(uri)) {
//                     await launchUrl(uri, mode: LaunchMode.externalApplication);
//                   }
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('කරුණාකර ඔබේ නම ඇතුළත් කරන්න')),
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 minimumSize: Size(double.infinity, 50),
//               ),
//               child: Text(
//                 "තහවුරු කරන්න",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Riverpod import කරන්න
import '../providers/bag_provider.dart'; // 2. අපි හදපු provider එක import කරන්න
import '../shared/validators/form_validators.dart'; // 3. FormValidators import කරන්න

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

  @override
  Widget build(BuildContext context) {
    final selectedBag = ref.watch(selectedBagProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Place Your Order')),
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
                  decoration: const InputDecoration(
                    labelText: 'Customer Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: FormValidators
                      .validateName, // FormValidators එකේ validateName function එක භාවිතා කරන්න
                ),

                const SizedBox(height: 15),

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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Order...')),
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
