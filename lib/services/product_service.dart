// lib/services/product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
// Sử dụng file product.dart gốc của bạn
import 'package:smart_hotpot_manager/models/product.dart'; 

class ProductService {
  // Collection "products"
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  // CREATE
  Future<void> addProduct(Product product) async {
    final docRef = await products.add(product.toMap());
    // Cập nhật ID cho document
    await products.doc(docRef.id).update({'id': docRef.id});
  }

  // READ
  Stream<List<Product>> getAllProducts(String restaurantId) {
    return products.where("restaurantId", isEqualTo: restaurantId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<Product?> getProductByDocId(String id) {
    return products.doc(id).snapshots().map((doc) {
      if (doc.exists) {
        return Product.fromMap(doc.data()! as Map<String, dynamic>);
      }
      return null;
    });
  }

  // UPDATE
  Future<void> updateProduct(Product product) async {
    await products.doc(product.id).update(product.toMap());
  }

  // DELETE
  Future<void> deleteProduct(String id) async {
    await products.doc(id).delete();
  }
}