// lib/models/table_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';



StatusTable _stringToStatus(String? statusName) {
  return StatusTable.values.firstWhere(
    (e) => e.name == statusName,
    orElse: () => StatusTable.empty,
  );
}

enum StatusTable { inUse, empty, set }

class TableModel {
  String restaurantId;
  String id;
  String name;
  String pass;
  StatusTable status;
  DateTime createAt;
  DateTime updateAt;

  // Giữ nguyên getter của bạn
  String get statusString {
     switch (status) {
      case StatusTable.inUse:
        return "Đang sử dụng";
      case StatusTable.empty:
        return "Còn trống";
      case StatusTable.set:
        return "Đã đặt";
      default:
        return "Không rõ";
    }
  }

  TableModel({
    required this.restaurantId,
    required this.id,
    required this.name,
    required this.pass,
    required this.status,
    required this.createAt,
    required this.updateAt,
  });

  factory TableModel.fromMap(Map<String, dynamic> data) {
    return TableModel(
      restaurantId: data['restaurant_id'] ?? '',
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      pass: data['pass'] ?? '',
      // <-- SỬA: Đọc status từ String
      status: _stringToStatus(data['status']),
      // <-- SỬA: Chuyển đổi Timestamp an toàn
      createAt: (data['create_at'] as Timestamp).toDate(),
      updateAt: (data['update_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurant_id': restaurantId,
      'id': id,
      'name': name,
      'pass': pass,
      'status': status.name,
      'create_at': createAt,
      'update_at': updateAt,
    };
  }
}