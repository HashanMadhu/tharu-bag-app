import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bag_provider.dart';
import '../shared/validators/form_validators.dart';
import 'bill_page.dart';
import '../shared/widgets/app_drawer.dart';
import '../providers/order_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPage extends ConsumerStatefulWidget {
  final String? selectedBag;
  final double? price;

  const OrderPage({super.key, this.selectedBag, this.price});

  @override
  ConsumerState<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bagNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedBag != null) {
        ref.read(selectedBagProvider.notifier).state = widget.selectedBag!;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bagNameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedBag = ref.watch(selectedBagProvider);
    final dbBagsAsync = ref.watch(dbBagTypesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Place Your Order',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // --- 🛠️ Dropdown කොටස ---
                dbBagsAsync.when(
                  data: (bagTypes) {
                    if (widget.selectedBag != null &&
                        !bagTypes.contains(widget.selectedBag)) {
                      bagTypes.add(widget.selectedBag!);
                    }

                    return DropdownButtonFormField<String>(
                      value: selectedBag.isEmpty ? null : selectedBag,
                      decoration: const InputDecoration(
                        labelText: 'Select Bag Type',
                      ),
                      items: bagTypes
                          .map(
                            (bag) =>
                                DropdownMenuItem(value: bag, child: Text(bag)),
                          )
                          .toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          ref.read(selectedBagProvider.notifier).state =
                              newValue;
                        }
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Colors.brown),
                  ),
                  error: (err, stack) => Text('Error loading bags: $err'),
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

                // --- 🖼️ පින්තූර පෙන්වන කොටස ---
                Column(
                  children: [
                    // Container(
                    //   height: 200,
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.brown.shade200),
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: selectedBag.isEmpty
                    //       ? const Center(child: Text("Please select a bag"))
                    //       : Image.network(
                    //           selectedBag == 'School Bag'
                    //               ? 'https://img.freepik.com/free-photo/blue-school-backpack-isolated-white-background_185193-164390.jpg?w=500'
                    //               : selectedBag == 'Hand Bag'
                    //               ? 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=500'
                    //               : selectedBag == 'Travel Bag'
                    //               ? 'https://images.unsplash.com/photo-1547949003-9792a18a2601?w=500'
                    //               : selectedBag == 'Lunch Bag'
                    //               ? 'https://images.unsplash.com/photo-1621605815971-fbc98d665033?w=500'
                    //               : 'https://via.placeholder.com/500x300?text=No+Image',
                    //           key: ValueKey(selectedBag),
                    //           fit: BoxFit.cover,
                    //           loadingBuilder: (context, child, progress) {
                    //             if (progress == null) return child;
                    //             return const Center(
                    //               child: CircularProgressIndicator(
                    //                 color: Colors.brown,
                    //               ),
                    //             );
                    //           },
                    //           errorBuilder: (context, error, stackTrace) {
                    //             return const Center(
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Icon(
                    //                     Icons.broken_image,
                    //                     size: 50,
                    //                     color: Colors.grey,
                    //                   ),
                    //                   SizedBox(height: 8),
                    //                   Text(
                    //                     "Check Internet Connection",
                    //                     style: TextStyle(fontSize: 12),
                    //                   ),
                    //                 ],
                    //               ),
                    //             );
                    //           },
                    //         ),
                    // ),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.brown.shade200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: selectedBag.isEmpty
                          ? const Center(child: Text("Please select a bag"))
                          : Image.network(
                              // 💡 Hardcode කරපු ලින්ක්ස් වෙනුවට කෙලින්ම ඔයා දෙන URL එක පෙන්වනවා:
                              selectedBag, // 👀 ඔයා Dropdown එකෙන් තෝරන අගය කෙලින්ම URL එකක් නම් මෙතනට 'selectedBag' දෙන්න පුළුවන්
                              key: ValueKey(selectedBag),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Invalid Image URL / Check Connection",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Current Selection: '$selectedBag'",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // --- 👤 Customer Name Field ---
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Customer Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: FormValidators.validateName,
                ),

                const SizedBox(height: 20),

                // --- 📞 Mobile Number Field ---
                TextFormField(
                  controller: _contactController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: FormValidators.validatePhone,
                ),

                const SizedBox(height: 20),

                // --- 📍 Delivery Address Field ---
                TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Delivery Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'කරුණාකර ලිපිනය ඇතුළත් කරන්න';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // --- 🛒 Confirm Order Button ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          // 1. Loading Indicator එක පෙන්වීම
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.brown,
                              ),
                            ),
                          );

                          // 2. Firestore එකට යන දත්ත (AdminOrdersPage එකේ Keys වලට ගැළපෙන ලෙස)
                          final orderData = {
                            'customerEmail':
                                FirebaseAuth.instance.currentUser?.email ??
                                'No Email', // 👈 මේ පේළිය එකතු කරන්න
                            'customerName': _nameController.text.trim(),
                            'bagType': widget.selectedBag ?? selectedBag,
                            'contact':
                                int.tryParse(_contactController.text.trim()) ??
                                0,
                            'address': _addressController.text.trim(),
                            'orderDate': Timestamp.now(),
                            'status': 'Pending',
                          };

                          // 3. Cloud Firestore එකට සේව් කිරීම
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .add(orderData);

                          // Loading Dialog එක වසා දැමීම
                          if (context.mounted) Navigator.pop(context);

                          // 4. Success Dialog එක පෙන්වීම
                          _showSuccessDialog();

                          // 5. Bill Page එකට Navigate කිරීම
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BillPage(
                                  customerName: _nameController.text,
                                  bagType: widget.selectedBag ?? selectedBag,
                                  contact:
                                      int.tryParse(_contactController.text) ??
                                      0,
                                  address: _addressController.text,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted)
                            Navigator.pop(context); // Loading එක වහන්න
                          print("Error saving order: $e");
                        }
                      }
                    },
                    child: const Text(
                      'Confirm Order',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
