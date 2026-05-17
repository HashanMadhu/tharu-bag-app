import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAddCategoryPage extends StatefulWidget {
  const AdminAddCategoryPage({super.key});

  @override
  State<AdminAddCategoryPage> createState() => _AdminAddCategoryPageState();
}

class _AdminAddCategoryPageState extends State<AdminAddCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  bool _isLoading = false;

  void _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await FirebaseFirestore.instance.collection('categories').add({
          'name': _nameController.text.trim(),
          'price': double.parse(_priceController.text.trim()),
          // ලින්ක් එක හිස් නම් හිස් text එකක් (Empty String) ලෙස සේව් වේ
          'imageUrl': _imageUrlController.text.trim(),
          'createdAt': Timestamp.now(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("බෑග් වර්ගය සාර්ථකව ඇතුළත් කළා!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${e.toString()}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Bag Type",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "නව බෑග් වර්ගයක් ඇතුළත් කරන්න",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 25),

              // 1. Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Bag Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag, color: Colors.brown),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return "කරුණාකර බෑග් වර්ගයේ නම ඇතුළත් කරන්න";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 2. Price
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price (LKR)",
                  prefixText: "Rs. ",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money, color: Colors.brown),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return "කරුණාකර මිල ඇතුළත් කරන්න";
                  if (double.tryParse(value) == null)
                    return "කරුණාකර නිවැරදි මිලක් ඇතුළත් කරන්න";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 3. Image URL (මෙය දැන් Optional වේ)
              TextFormField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: "Image URL (Optional - අවශ්‍ය නම් පමණක්)",
                  hintText: "https://example.com/image.jpg",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link, color: Colors.brown),
                ),
                // Validator එකක් නැත -> හිස්ව තබා සේව් කළ හැක
              ),
              const SizedBox(height: 35),

              // 4. Save Button
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveCategory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                        ),
                        child: const Text(
                          "Save Bag Type",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
