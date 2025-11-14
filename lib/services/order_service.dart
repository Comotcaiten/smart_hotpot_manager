// lib/services/order_service.dart
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

// <-- SỬA: Thêm 2 import này
import 'package:smart_hotpot_manager/models/order.dart';
import 'package:smart_hotpot_manager/models/order_item.dart';
import 'package:smart_hotpot_manager/models/table.dart';

class OrderService {
  final CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  final CollectionReference orderItems = FirebaseFirestore.instance.collection('order_items');

  // READ: Lấy tất cả Order (cho Admin, Staff)
  Stream<List<Order>> getAllOrders(String restaurantId) {
    // Sắp xếp theo thời gian tạo mới nhất
    return orders.where("restaurant_id", isEqualTo: restaurantId).orderBy('create_at', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Nhờ import ở trên, Dart biết 'Order.fromMap' sẽ trả về 'Order'
        return Order.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
  
  // READ: Lấy OrderItem của 1 Order cụ thể
  Stream<List<OrderItem>> getOrderItems(String orderId) {
    return orderItems.where('order_id', isEqualTo: orderId).snapshots().map((snapshot) {
       return snapshot.docs.map((doc) {
        return OrderItem.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // READ: Lấy table name của order
  Future<TableModel?> getTableById(String tableId) async {
    final snap = await FirebaseFirestore.instance
        .collection('tables')
        .doc(tableId)
        .get();
    if (!snap.exists) return null;
    return TableModel.fromMap(snap.data() as Map<String, dynamic>);
  }


  // UPDATE: Cập nhật trạng thái của một Order
  Future<void> updateOrderStatus(String orderId, StatusOrder newStatus) async {
    await orders.doc(orderId).update({
      'status': newStatus.name, // Lưu tên của enum (String)
      'update_at': DateTime.now(),
    });
  }

  // DELETE: Xóa một Order
  Future<void> deleteOrder(String id) async {
    await orders.doc(id).delete();
  }
}