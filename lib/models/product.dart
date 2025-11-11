// lib/models/product.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Hàm helper để chuyển đổi Timestamp từ Firestore một cách an toàn (Không đổi là bị lỗi không nhận dạng được DateTime)
DateTime _timestampToDateTime(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  } else if (timestamp is Map) {
    // Đôi khi nó có thể là một Map, tùy thuộc vào cách dữ liệu được ghi
    return Timestamp(timestamp['_seconds'], timestamp['_nanoseconds']).toDate();
  }
  // Mặc định trả về thời gian hiện tại nếu không nhận dạng được
  return DateTime.now();
}

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
      createAt: _timestampToDateTime(data['create_at']), 
      updateAt: _timestampToDateTime(data['update_at']),
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