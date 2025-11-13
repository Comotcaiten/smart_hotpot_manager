// lib/models/product.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String restaurantId;
  String id;
  String name;
  int price;
  String categoryId;
  bool delete;
  String imageUrl;
  DateTime createAt;
  DateTime updateAt;

  Product({
    required this.restaurantId,
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.delete,
    required this.imageUrl,
    required this.createAt,
    required this.updateAt,
  });

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      restaurantId: data['restaurantId'] ?? '',
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      price: (data['price'] ?? 0) as int,
      categoryId: data['category_id'] ?? '',
      delete: data['delete'] ?? false,
      imageUrl: data['image_url'] ?? '',
      createAt: (data['create_at'] as Timestamp).toDate(), 
      updateAt: (data['update_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'id': id,
      'name': name,
      'price': price,
      'category_id': categoryId,
      'delete': delete,
      'image_url': imageUrl,
      // Firestore sẽ tự động chuyển DateTime thành Timestamp khi ghi
      'create_at': createAt,
      'update_at': updateAt,
    };
  }
}