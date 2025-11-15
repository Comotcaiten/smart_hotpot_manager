import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/order.dart';
import 'package:smart_hotpot_manager/models/order_item.dart';
import 'package:smart_hotpot_manager/models/product.dart';
import 'package:smart_hotpot_manager/services/order_service.dart';

// Đây là một item trong giỏ hàng (trước khi gửi đi)
class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  final OrderService _orderService = OrderService();

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;
  
  int get totalItemCount {
    int total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity;
    });
    return total;
  }

  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      // Tăng số lượng
      _items.update(
        product.id,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      // Thêm mới
      _items.putIfAbsent(
        product.id,
        () => CartItem(product: product, quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Gửi đơn hàng
  Future<void> submitOrder({
    required String tableId,
    required String restaurantId,
  }) async {
    if (_items.isEmpty) return; // Không làm gì nếu giỏ hàng rỗng

    final now = DateTime.now();

    // 1. Tạo đối tượng Order
    Order newOrder = Order(
      id: '', // Service sẽ tự gán
      restaurantId: restaurantId,
      tableId: tableId,
      status: StatusOrder.pending, // Trạng thái chờ
      totalAmount: totalPrice,
      createAt: now,
      updateAt: now,
    );

    // 2. Tạo danh sách OrderItem
    List<OrderItem> orderItemsList = _items.values.map((cartItem) {
      return OrderItem(
        id: '', // Service sẽ tự gán
        orderId: '', // Service sẽ tự gán
        productId: cartItem.product.id,
        price: cartItem.product.price.toDouble(),
        quantity: cartItem.quantity,
        note: '', // Bạn có thể thêm trường nhập note sau
        createAt: now,
        updateAt: now,
      );
    }).toList();

    // 3. Gọi service
    try {
      await _orderService.addOrder(newOrder, orderItemsList);
      // Xóa giỏ hàng sau khi gửi thành công
      clearCart();
    } catch (e) {
      // Xử lý lỗi (ví dụ: hiển thị thông báo)
      print('Lỗi khi gửi đơn hàng: $e');
      rethrow; // Ném lỗi ra để UI có thể bắt
    }
  }
}