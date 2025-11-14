import 'package:cloud_firestore/cloud_firestore.dart';

enum StatusTable { inUse, empty, set }

class TableModel {
  final String restaurantId;
  final String id;
  final String name;
  final StatusTable status;
  final int seats; // số chỗ ngồi
  // final DateTime createAt;
  // final DateTime updateAt;

  TableModel({
    required this.restaurantId,
    required this.id,
    required this.name,
    required this.status,
    required this.seats,
    // required this.createAt,
    // required this.updateAt,
  });

  // Hiển thị trạng thái tiếng Việt
  String get statusLabel {
    switch (status) {
      case StatusTable.inUse:
        return "Đang sử dụng";
      case StatusTable.empty:
        return "Còn trống";
      case StatusTable.set:
        return "Đã đặt";
    }
  }

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

  // Parse Firestore map → model
  factory TableModel.fromMap(Map<String, dynamic> data) {
    StatusTable parseStatus(String? name) {
      return StatusTable.values.firstWhere(
        (e) => e.name == name,
        orElse: () => StatusTable.empty,
      );
    }

    return TableModel(
      restaurantId: data['restaurant_id'] ?? '',
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      status: parseStatus(data['status']),
      seats: (data['seats'] ?? 0) is int
          ? data['seats']
          : int.tryParse(data['seats'].toString()) ?? 0,
      // createAt: (data['create_at'] is Timestamp)
      //     ? (data['create_at'] as Timestamp).toDate()
      //     : DateTime.now(),
      // updateAt: (data['update_at'] is Timestamp)
      //     ? (data['update_at'] as Timestamp).toDate()
      //     : DateTime.now(),
    );
  }

  // Convert model → Firestore map
  Map<String, dynamic> toMap() {
    return {
      'restaurant_id': restaurantId,
      'id': id,
      'name': name,
      'status': status.name,
      'seats': seats,
      // dùng Timestamp thay vì DateTime
      // 'create_at': Timestamp.fromDate(createAt),
      // 'update_at': Timestamp.fromDate(updateAt),
    };
  }
}
