// lib/services/customer_order_service.dart
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:smart_hotpot_manager/models/order.dart';
import 'package:smart_hotpot_manager/models/order_item.dart';

class CustomerOrderService {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  // Hàm tạo đơn hàng (Order) và các món (OrderItem)
  // Dùng Batch Write để đảm bảo cả hai được tạo cùng lúc
  Future<void> createOrder(Order newOrder, List<OrderItem> items) async {
    final batch = FirebaseFirestore.instance.batch();

    // 1. Tạo document cho Order
    final orderRef = orders.doc();
    newOrder.id = orderRef.id;
    batch.set(orderRef, newOrder.toMap());

    // 2. Tạo subcollection 'order_items' cho từng món
    for (var item in items) {
      item.orderId = orderRef.id;
      // Tạo ID mới cho mỗi order_item
      final itemRef = orderRef.collection('order_items').doc(); 
      item.id = itemRef.id;
      batch.set(itemRef, item.toMap());
    }

    // 3. Gửi toàn bộ lên server
    await batch.commit();
  }
}