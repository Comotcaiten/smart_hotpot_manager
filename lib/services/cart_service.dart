// lib/providers/cart_provider.dart
import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/product.dart';
import 'package:smart_hotpot_manager/models/order.dart';
import 'package:smart_hotpot_manager/models/order_item.dart';
import 'package:smart_hotpot_manager/services/customer_order_service.dart'; // (Tạo ở file tiếp theo)

// Model nội bộ cho một món hàng trong giỏ
class CartItem {
  final Product product;
  int quantity;
  String note;
  final TextEditingController noteController = TextEditingController();

  CartItem({required this.product, this.quantity = 1, this.note = ''}) {
    noteController.text = note;
    noteController.addListener(() {
      note = noteController.text;
    });
  }

  double get totalPrice => (product.price * quantity).toDouble();

  // Chuyển CartItem (UI) thành OrderItem (Model DB)
  OrderItem toOrderItem() {
    final now = DateTime.now();
    return OrderItem(
      id: '', // Sẽ được service gán
      orderId: '', // Sẽ được service gán
      productId: product.id,
      productName: product.name,
      price: product.price.toDouble(),
      quantity: quantity,
      note: note,
      createAt: now,
      updateAt: now,
    );
  }
}

// Provider chính
class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  final CustomerOrderService _orderService = CustomerOrderService();
  String _currentTableId = "table_id_001"; // TODO: Lấy ID bàn thật

  Map<String, CartItem> get items => {..._items};
  List<CartItem> get itemsList => _items.values.toList();
  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  // Thêm 1 món (click nhiều lần)
  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (existing) => CartItem(
                product: existing.product,
                quantity: existing.quantity + 1,
                note: existing.note,
              )..noteController.text = existing.note);
    } else {
      _items.putIfAbsent(product.id, () => CartItem(product: product));
    }
    notifyListeners(); // Thông báo cho UI cập nhật
  }

  // Giảm 1 món
  void decrementItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      final existing = _items[productId]!;
      _items.update(
          productId,
          (existing) => CartItem(
                product: existing.product,
                quantity: existing.quantity - 1,
                note: existing.note,
              )..noteController.text = existing.note);
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // Gửi đơn hàng (bấm nút Đồng ý)
  Future<void> confirmOrder() async {
    if (_items.isEmpty) return;

    final now = DateTime.now();
    
    // 1. Tạo đối tượng Order
    final newOrder = Order(
      id: '', // Sẽ được service gán
      restaurantId: "R001", // TODO: Lấy restaurantId thật
      tableId: _currentTableId,
      status: StatusOrder.pending, // Trạng thái đầu tiên
      totalAmount: totalAmount,
      createAt: now,
      updateAt: now,
    );

    // 2. Tạo danh sách OrderItem
    final List<OrderItem> orderItems = _items.values.map((cartItem) {
      return cartItem.toOrderItem();
    }).toList();

    // 3. Gọi service để lưu vào DB
    try {
      await _orderService.createOrder(newOrder, orderItems);
      _items.clear();
      notifyListeners();
    } catch (e) {
      // Xử lý lỗi nếu gửi thất bại
      print("Lỗi khi gửi đơn hàng: $e");
      rethrow; 
    }
  }
}