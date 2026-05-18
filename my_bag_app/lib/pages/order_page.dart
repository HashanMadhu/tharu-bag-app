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

  String _currentImageUrl = '';
  double _currentPrice = 0.0;
  int _quantity = 1; // 💡 බෑග් ප්‍රමාණය තබා ගැනීමට (Default = 1)
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedBag != null) {
        ref.read(selectedBagProvider.notifier).state = widget.selectedBag!;
      }
    });
    if (widget.price != null) {
      _currentPrice = widget.price!;
    }
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
    final selectedBagName = ref.watch(selectedBagProvider);
    // 💡 මුළු මුදල ගණනය කිරීම (Price x Quantity)
    double totalPrice = _currentPrice * _quantity;

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
                // --- 🛠️ StreamBuilder හරහා Firestore Categories කියවීම ---
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.brown),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No bags available in store');
                    }

                    final docs = snapshot.data!.docs;

                    if (_isInitialLoad && widget.selectedBag != null) {
                      for (var doc in docs) {
                        var data = doc.data() as Map<String, dynamic>;
                        if (data['name'] == widget.selectedBag) {
                          String rawUrl = data['imageUrl'] ?? '';
                          _currentImageUrl =
                              (rawUrl.contains('ibb.co') &&
                                  !rawUrl.endsWith('.jpg') &&
                                  !rawUrl.endsWith('.png'))
                              ? '$rawUrl/image.png'
                              : rawUrl;
                          _currentPrice = (data['price'] ?? 0.0).toDouble();
                          break;
                        }
                      }
                      _isInitialLoad = false;
                    }

                    String? selectedDropdownValue;
                    if (selectedBagName.isNotEmpty &&
                        docs.any(
                          (doc) =>
                              (doc.data() as Map<String, dynamic>)['name'] ==
                              selectedBagName,
                        )) {
                      selectedDropdownValue = selectedBagName;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                      ), // 👈 උඩින් 16 ක ඉඩක් ලබා දුන්නා, එතකොට ලේබල් එක කැපෙන්නේ නැහැ
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: selectedDropdownValue,
                        decoration: const InputDecoration(
                          labelText: 'Select Bag Type',
                          border: OutlineInputBorder(),
                        ),
                        hint: const Text("Choose a bag"),
                        items: docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return DropdownMenuItem<String>(
                            value: data['name'],
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Text(
                                "${data['name']} - Rs. ${data['price']}",
                                maxLines: 2,
                                overflow: TextOverflow.visible,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newBagName) {
                          if (newBagName != null) {
                            final selectedDoc = docs.firstWhere(
                              (doc) =>
                                  (doc.data()
                                      as Map<String, dynamic>)['name'] ==
                                  newBagName,
                            );
                            final selectedData =
                                selectedDoc.data() as Map<String, dynamic>;

                            setState(() {
                              ref.read(selectedBagProvider.notifier).state =
                                  newBagName;
                              String rawUrl = selectedData['imageUrl'] ?? '';
                              _currentImageUrl =
                                  (rawUrl.contains('ibb.co') &&
                                      !rawUrl.endsWith('.jpg') &&
                                      !rawUrl.endsWith('.png'))
                                  ? '$rawUrl/image.png'
                                  : rawUrl;
                              _currentPrice = (selectedData['price'] ?? 0.0)
                                  .toDouble();
                            });
                          }
                        },
                        validator: (value) =>
                            value == null ? 'Please select a bag type' : null,
                      ),
                    ); // 👈 Padding නිමාව
                  },
                ),

                const SizedBox(height: 20),

                // --- 🛍️ Quantity (ප්‍රමාණය) තෝරන කොටස ---
                if (selectedBagName.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Quantity:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          // ➖ අඩු කරන බටන් එක
                          IconButton(
                            onPressed: _quantity > 1
                                ? () => setState(() => _quantity--)
                                : null,
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.brown,
                              size: 30,
                            ),
                          ),
                          // 🔢 ප්‍රමාණය පෙන්වන Text එක
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // ➕ වැඩි කරන බටන් එක
                          IconButton(
                            onPressed: () => setState(() => _quantity++),
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.brown,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // --- 💵 මුළු මුදල (Total Price) පෙන්වන කොටස ---
                  Card(
                    color: Colors.brown.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Amount:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Rs. ${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // --- 🖼️ පින්තූර සජීවීව පෙන්වන කොටස ---
                // --- 🖼️ පින්තූර සජීවීව පෙන්වන කොටස ---
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown.shade200),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors
                        .grey[50], // 💡 පින්තූරය contain වෙද්දී දෙපැත්තේ ඉතිරි වන ඉඩ මේ background එකෙන් වැහෙයි
                  ),
                  child: _currentImageUrl.isNotEmpty
                      ? Image.network(
                          _currentImageUrl,
                          key: ValueKey(_currentImageUrl),
                          fit: BoxFit
                              .contain, // 👈 ❌ BoxFit.cover වෙනුවට BoxFit.contain දාන්න
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text("Please select a bag to view image"),
                        ),
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
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.brown,
                              ),
                            ),
                          );

                          // 👑 2. Database (Firestore) එකට යන දත්ත වලට Quantity සහ Total Price එකතු කිරීම
                          final orderData = {
                            'customerEmail':
                                FirebaseAuth.instance.currentUser?.email ??
                                'No Email',
                            'customerName': _nameController.text.trim(),
                            'bagType': selectedBagName,
                            'price': _currentPrice, // තනි බෑගයක මිල
                            'quantity':
                                _quantity, // 👈 දත්ත ගබඩාවට යන බෑග් ප්‍රමාණය
                            'totalPrice':
                                totalPrice, // 👈 දත්ත ගබඩාවට යන මුළු මුදල (Price x Quantity)
                            'contact':
                                int.tryParse(_contactController.text.trim()) ??
                                0,
                            'address': _addressController.text.trim(),
                            'orderDate': Timestamp.now(),
                            'status': 'Pending',
                          };

                          await FirebaseFirestore.instance
                              .collection('orders')
                              .add(orderData);

                          if (context.mounted)
                            Navigator.pop(context); // Loading close

                          _showSuccessDialog();

                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BillPage(
                                  customerName: _nameController.text,
                                  bagType: selectedBagName,
                                  contact:
                                      int.tryParse(_contactController.text) ??
                                      0,
                                  address: _addressController.text,
                                  quantity: _quantity,
                                  totalPrice: totalPrice,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) Navigator.pop(context);
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
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("ස්තූතියි"),
          ),
        ],
      ),
    );
  }
}
