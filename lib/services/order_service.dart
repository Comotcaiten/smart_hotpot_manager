// lib/services/order_service.dart
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

// <-- SỬA: Thêm 2 import này
import 'package:smart_hotpot_manager/models/order.dart';
import 'package:smart_hotpot_manager/models/order_item.dart';
import 'package:smart_hotpot_manager/models/table.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference orders = FirebaseFirestore.instance.collection(
    'orders',
  );
  final CollectionReference orderItems = FirebaseFirestore.instance.collection(
    'order_items',
  );

  Future<void> addOrder(Order order, List<OrderItem> items) async {
    // 1. Tạo document Order
    final docRef = await orders.add(order.toMap());
    await orders.doc(docRef.id).update({'id': docRef.id});

    // 2. Dùng batch write để thêm tất cả OrderItems
    final batch = _db.batch();

    for (var item in items) {
      // Set orderId cho từng item
      item.orderId = docRef.id;

      // Tạo một DocumentReference mới cho mỗi item trong sub-collection
      final itemDocRef = orders.doc(docRef.id).collection('order_items').doc();

      // Thêm ID của chính nó vào dữ liệu
      item.id = itemDocRef.id;

      batch.set(itemDocRef, item.toMap());
    }

    // 3. Commit batch
    await batch.commit();
  }

  // READ: Lấy tất cả Order (cho Admin, Staff)
  Stream<List<Order>> getAllOrders(String restaurantId) {
    // Sắp xếp theo thời gian tạo mới nhất
    return orders
        .where("restaurant_id", isEqualTo: restaurantId)
        .orderBy('create_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            // Nhờ import ở trên, Dart biết 'Order.fromMap' sẽ trả về 'Order'
            return Order.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
        });
  }

  // READ: Lấy OrderItem của 1 Order cụ thể
  Stream<List<OrderItem>> getOrderItems(String orderId) {
    return orderItems.where('order_id', isEqualTo: orderId).snapshots().map((
      snapshot,
    ) {
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
  Future<void> deleteOrder(String orderId) async {
    final orderRef = orders.doc(orderId);

    // 1. Lấy OrderItems trong sub-collection
    final itemsSnap = await orderRef.collection("order_items").get();

    WriteBatch batch = _db.batch();

    // 2. Xóa tất cả order_items trong sub-collection
    for (var doc in itemsSnap.docs) {
      batch.delete(doc.reference);
    }

    // 3. Xóa Order chính
    batch.delete(orderRef);

    // 4. Commit tất cả
    await batch.commit();
  }

}
