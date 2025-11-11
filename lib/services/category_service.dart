import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_hotpot_manager/models/category.dart';

class CategoryService {
  final CollectionReference categorys =
      FirebaseFirestore.instance.collection('categorys');

  // CREATE
  Future<void> addCategory(Category category) async {
    final docRef = await categorys.add(category.toMap());
    await categorys.doc(docRef.id).update({'id': docRef.id});
  }

  // READ (tùy chọn)
  Stream<List<Category>> getAllCategories() {
    return categorys.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Category.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // UPDATE
  Future<void> updateCategory(Category category) async {
    await categorys.doc(category.id).update(category.toMap());
  }

  // DELETE
  Future<void> deleteCategory(String id) async {
    await categorys.doc(id).delete();
  }
}
