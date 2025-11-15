// lib/models/order_item.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Hàm helper
DateTime _timestampToDateTime(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  }
  return DateTime.now();
}

class OrderItem {
  String id;
  String orderId;
  String productId;
  double price; 
  int quantity;
  String note;
  DateTime createAt;
  DateTime updateAt;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.note,
    required this.createAt,
    required this.updateAt,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      id: data['id'] ?? '',
      orderId: data['order_id'] ?? '',
      productId: data['product_id'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 0,
      note: data['note'] ?? '',
      createAt: _timestampToDateTime(data['create_at']), // <-- SỬA
      updateAt: _timestampToDateTime(data['update_at']), // <-- SỬA
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'price': price,
      'quantity': quantity,
      'note': note,
      'create_at': createAt,
      'update_at': updateAt,
    };
  }
}