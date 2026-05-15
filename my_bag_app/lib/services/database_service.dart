import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class DatabaseService { 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. කලින් තිබුණු දත්ත යවන function එක (Future)
  Future<void> uploadCategory() async { 
    final newCategory = CategoryModel(
      id: 'school-bags-01',
      name: 'School Bags',
      imageUrl: 'https://example.com/bag-image.jpg',
    );

    try {
      await _firestore.collection('categories').doc(newCategory.id).set(newCategory.toMap());
      print("Success: Category Uploaded!");
    } catch (e) {
      print("Error: $e");
    }
  }

  // ---------------------------------------------------------
  // 2. අලුතින් එකතු කරන දත්ත කියවන function එක (Stream)
  // ---------------------------------------------------------
  Stream<List<CategoryModel>> getCategories() {
    // categories කියන collection එක දෙස බලා සිටින්න (snapshots)
    return _firestore.collection('categories').snapshots().map((snapshot) {
      // ලැබෙන හැම ලේඛනයක්ම (Document) CategoryModel එකක් බවට හරවන්න
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CategoryModel(
          id: doc.id,
          name: data['name'] ?? 'No Name',
          imageUrl: data['imageUrl'] ?? '',
        );
      }).toList(); // ඒ ඔක්කොම List එකක් විදිහට එවන්න
    });
  }
}