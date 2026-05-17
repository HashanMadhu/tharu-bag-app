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

  // 💡 තෝරාගත් බෑගයේ Image URL එක සහ මිල (Price) තබා ගැනීමට ලෝකල් Variables දෙකක්
  String _currentImageUrl = '';
  double _currentPrice = 0.0;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedBag != null) {
        ref.read(selectedBagProvider.notifier).state = widget.selectedBag!;
      }
    });
    // මුලින්ම ආපු මිල ඇතුළත් කරගැනීම
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

                    // 💡 මුල්ම වතාවට පේජ් එකට එද්දී HomePage එකෙන් ආපු බෑග් එකේ දත්ත හොයාගැනීම
                    if (_isInitialLoad && widget.selectedBag != null) {
                      for (var doc in docs) {
                        var data = doc.data() as Map<String, dynamic>;
                        if (data['name'] == widget.selectedBag) {
                          // ImgBB වෙබ් ලින්ක් එක Direct Image Link එකක් බවට හැරවීම (.jpg එකතු කිරීම)
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

                    return DropdownButtonFormField<String>(
                      isExpanded: true, // මේකෙන් මුළු පළලම හරියට බෙදාගන්නවා.
                      // 👑 ප්‍රධාන Value එක විදිහට String (බෑග් එකේ නම) විතරක් දෙනවා. එතකොට Error එක එන්නේ නැහැ!
                      value: selectedBagName.isEmpty ? null : selectedBagName,
                      decoration: const InputDecoration(
                        labelText: 'Select Bag Type',
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text("Choose a bag"),
                      items: docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return DropdownMenuItem<String>(
                          value: data['name'],
                          // 💡 මෙන්න මේ විදිහට වෙනස් කරන්න හෂාන්:
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              "${data['name']} - Rs. ${data['price']}",
                              maxLines:
                                  2, // 👈 ඉඩ මදි වුනොත් පේළි දෙකකට ලස්සනට බෙදෙනවා
                              overflow: TextOverflow
                                  .visible, // 👈 මිල කැපිලා තිත් තිත් වැටෙන එක නතර කරනවා
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newBagName) {
                        if (newBagName != null) {
                          // 💡 ලිස්ට් එක ඇතුළෙන් සිලෙක්ට් කරපු බෑග් එකට අදාළ මුළු දත්ත Map එක සොයා ගැනීම
                          final selectedDoc = docs.firstWhere(
                            (doc) =>
                                (doc.data() as Map<String, dynamic>)['name'] ==
                                newBagName,
                          );
                          final selectedData =
                              selectedDoc.data() as Map<String, dynamic>;

                          setState(() {
                            // 1. Riverpod state එක update කරනවා
                            ref.read(selectedBagProvider.notifier).state =
                                newBagName;

                            // 2. සජීවීව Image URL එක සකසා ගන්නවා
                            String rawUrl = selectedData['imageUrl'] ?? '';
                            _currentImageUrl =
                                (rawUrl.contains('ibb.co') &&
                                    !rawUrl.endsWith('.jpg') &&
                                    !rawUrl.endsWith('.png'))
                                ? '$rawUrl/image.png'
                                : rawUrl;

                            // 3. මිල Update කරනවා
                            _currentPrice = (selectedData['price'] ?? 0.0)
                                .toDouble();
                          });
                        }
                      },
                      validator: (value) =>
                          value == null ? 'Please select a bag type' : null,
                    );
                  },
                ),

                const SizedBox(height: 20),

                if (selectedBagName.isNotEmpty)
                  Text(
                    'You selected: $selectedBagName (Rs. ${_currentPrice.toStringAsFixed(2)})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),

                const SizedBox(height: 20),

                // --- 🖼️ පින්තූර සජීවීව පෙන්වන කොටස ---
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown.shade200),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[50],
                  ),
                  child: _currentImageUrl.isNotEmpty
                      ? Image.network(
                          _currentImageUrl, // 👈 වෙනස් කරන සැනින් පින්තූරය මෙතනින් ලෝඩ් වෙනවා
                          key: ValueKey(_currentImageUrl),
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

                          // 2. Firestore එකට යන දත්ත
                          final orderData = {
                            'customerEmail':
                                FirebaseAuth.instance.currentUser?.email ??
                                'No Email',
                            'customerName': _nameController.text.trim(),
                            'bagType': selectedBagName, // 💡 තෝරාගත් බෑගයේ නම
                            'price': _currentPrice, // 💡 තෝරාගත් බෑගයේ සැබෑ මිල
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
                                  bagType: selectedBagName,
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
              Navigator.pop(context); // Dialog එක వසන්න
              Navigator.pop(context); // ආපසු Home Page එකට යන්න
            },
            child: const Text("ස්තූතියි"),
          ),
        ],
      ),
    );
  }
}
