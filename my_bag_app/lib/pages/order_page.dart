import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Riverpod import කරන්න
import '../providers/bag_provider.dart'; // 2. අපි හදපු provider එක import කරන්න
import '../shared/validators/form_validators.dart'; // 3. FormValidators import කරන්න
import 'bill_page.dart'; // 2. BillPage එක import කරන්න
import '../shared/widgets/app_drawer.dart'; // Drawer එක import කරන්න
import '../providers/order_provider.dart'; // 4. OrderProvider එක import කරන්න

// StatefulWidget වෙනුවට ConsumerStatefulWidget පාවිච්චි කරමු
class OrderPage extends ConsumerStatefulWidget {
  // මේ variables දෙක අලුතින් එක් කරන්න
  final String? selectedBag;
  final double? price;

  const OrderPage({super.key, this.selectedBag, this.price});

  @override
  ConsumerState<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  // 3. පාරිභෝගික නම ලබාගන්නා Controller එක
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bagNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final List<String> bagTypes = [
    'School Bag',
    'Hand Bag',
    'Travel Bag',
    'Lunch Bag',
  ];

  final _formKey = GlobalKey<FormState>(); // Form එකේ තත්ත්වය පරීක්ෂා කිරීමට

  @override
  void initState() {
    super.initState();
    // පිටතින් එන අගය Riverpod state එකට ලබා දීම
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedBag != null) {
        ref.read(selectedBagProvider.notifier).state = widget.selectedBag!;
      }
    });
  }

  @override
  void dispose() {
    _nameController
        .dispose(); // ඇප් එකේ මෙම පේජ් එක වසා දැමූ විට මතකය (Memory) නිදහස් කිරීමට
    _bagNameController.dispose(); // තවත් Controller එකක් dispose කරන්න
    _contactController.dispose(); // තවත් Controller එකක් dispose කරන්න
    _addressController.dispose(); // තවත් Controller එකක් dispose කරන්න
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

                const SizedBox(height: 20),

                // දුරකථන අංකය සඳහා TextField එක
                TextFormField(
                  controller:
                      _contactController, // දුරකථන අංකයට Controller එකක් assign කරන්න
                  keyboardType: TextInputType
                      .phone, // අංක ටයිප් කිරීමට පහසු Keyboard එකක් එයි
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: FormValidators
                      .validatePhone, // දුරකථන අංකය validate කරන්න
                ),

                const SizedBox(height: 20),

                // ලිපිනය සඳහා TextField එක
                TextFormField(
                  controller: _addressController,
                  maxLines: 2, // පේළි කිහිපයක ලිපිනය ලිවීමට
                  decoration: const InputDecoration(
                    labelText: 'Delivery Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'කරුණාකර ලිපිනය ඇතුළත් කරන්න';
                    return null;
                  },
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
                    onPressed: () async {
                      // 1. මුලින්ම Form එක Validate කරන්න
                      if (_formKey.currentState!.validate()) {
                        try {
                          // 2. දත්ත සකසා ගන්න
                          final newOrder = {
                            'name': _nameController.text.trim(),
                            'bagName': widget.selectedBag ?? selectedBag,
                            'phone': _contactController.text.trim(),
                            'address': _addressController.text.trim(),
                          };

                          // 3. SQLite වලට දත්ත යවන්න
                          await ref
                              .read(orderProvider.notifier)
                              .addOrder(newOrder);

                          // 4. සාර්ථක නම් Dialog එක පෙන්වන්න
                          _showSuccessDialog();

                          // 5. Bill Page එකට යෑම
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BillPage(
                                customerName: _nameController.text,
                                bagType: widget.selectedBag ?? selectedBag,
                                contact:
                                    int.tryParse(_contactController.text) ??
                                    0, // දෝෂ මඟහරවයි
                                address: _addressController.text,
                              ),
                            ),
                          );
                        } catch (e) {
                          // යම් දෝෂයක් ආවොත් ටර්මිනල් එකේ පෙන්වයි
                          print("Error placing order: $e");
                        }
                      } else {
                        print("Form is not valid");
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
  // ... initState එක මෙතැන තිබේ ...

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text(
          "ඔබේ ඇණවුම සාර්ථකව ලැබුණා!\nඅපි ඉක්මනින්ම ඔබව අමතන්නම්.",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog එක වසන්න
              Navigator.pop(context); // ආපසු Home Page එකට යන්න
            },
            child: const Text("ස්තූතියි"),
          ),
        ],
      ),
    );
  }
}
