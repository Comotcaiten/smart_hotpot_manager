// lib/models/order.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// --- BẮT BUỘC PHẢI CÓ CÁC HÀM HELPER NÀY ---
DateTime _timestampToDateTime(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  }
  return DateTime.now(); // Trả về an toàn nếu dữ liệu null
}

StatusOrder _stringToStatus(String? statusName) {
  return StatusOrder.values.firstWhere(
    (e) => e.name == statusName,
    orElse: () => StatusOrder.pending, // Mặc định
  );
}
// ------------------------------------------

enum StatusOrder { pending, preparing, complete, served, paid }

class Order {
  String id;
  String restaurantId;
  String tableId;
  StatusOrder status; // Pending / Preparing / ...
  double totalAmount;
  DateTime createAt;
  DateTime updateAt;

  // Sửa lại getter để hiển thị tiếng Việt
  String get statusString {
    switch (status) {
      case StatusOrder.pending:
        return "Chờ xử lý";
      case StatusOrder.preparing:
        return "Đang chuẩn bị";
      case StatusOrder.complete:
        return "Hoàn thành";
      case StatusOrder.served:
        return "Đã phục vụ";
      case StatusOrder.paid:
        return "Đã thanh toán";
      default:
        return "Không rõ";
    }
  }

  Order({
    required this.id,
    required this.restaurantId,
    required this.tableId,
    required this.status,
    required this.totalAmount,
    required this.createAt,
    required this.updateAt,
  });

  factory Order.fromMap(Map<String, dynamic> data) {
    return Order(
      id: data['id'] ?? '',
      restaurantId: data['restaurant_id'] ?? '',
      tableId: data['table_id'] ?? '',
      // <-- SỬA: Đọc status từ String
      status: _stringToStatus(data['status']),
      totalAmount: (data['total_amount'] ?? 0).toDouble(),
      // <-- SỬA: Chuyển đổi Timestamp an toàn
      createAt: _timestampToDateTime(data['create_at']),
      updateAt: _timestampToDateTime(data['update_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'table_id': tableId,
      // <-- SỬA: Lưu status dưới dạng String
      'status': status.name,
      'total_amount': totalAmount,
      'create_at': createAt,
      'update_at': updateAt,
    };
  }
}