import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_hotpot_manager/providers/cart_provider.dart';

class CartWidget extends StatefulWidget {
  final String tableId;
  final String restaurantId;
  final VoidCallback onOrderSubmitted; // <-- THÊM CALLBACK

  const CartWidget({
    super.key,
    required this.tableId,
    required this.restaurantId,
    required this.onOrderSubmitted, // <-- THÊM VÀO CONSTRUCTOR
  });

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  bool _isLoading = false;

  String formatCurrency(double amount) {
    final formatter = NumberFormat.decimalPattern('vi_VN');
    return '${formatter.format(amount)}đ';
  }

  void _submitOrder(CartProvider cart) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      await cart.submitOrder(
        tableId: widget.tableId,
        restaurantId: widget.restaurantId,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã gửi đơn hàng thành công!'),
            backgroundColor: Colors.green,
          ),
        );

        // GỌI CALLBACK ĐỂ BÁO CHO MENUSCREEN
        widget.onOrderSubmitted();

        Navigator.of(context).pop(); // Pop không cần giá trị
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: Không thể gửi đơn hàng. ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items.values.toList();

    return Drawer(
      width: 400,
      child: Column(
        children: [
          AppBar(
            title: Text('Giỏ hàng (${cart.totalItemCount})'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(), // Đóng Drawer
              )
            ],
          ),
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
                    child: Text(
                      'Giỏ hàng của bạn đang trống.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, i) =>
                        _buildCartItemTile(cart, cartItems[i]),
                  ),
          ),
          if (cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: -2,
                    offset: const Offset(0, -2),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng cộng:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatCurrency(cart.totalPrice),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            icon: const Icon(Icons.send),
                            label: const Text('Gửi đơn hàng'),
                            onPressed: () => _submitOrder(cart),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.deepOrange,
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildCartItemTile(CartProvider cart, CartItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text('${item.product.price ~/ 1000}k'),
          backgroundColor: Colors.deepOrange.shade100,
        ),
        title: Text(item.product.name),
        subtitle: Text(formatCurrency(item.product.price * (item.quantity * 1.0))),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, size: 18),
              onPressed: () => cart.removeSingleItem(item.product.id),
            ),
            Text(
              '${item.quantity}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 18),
              onPressed: () => cart.addItem(item.product),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
              onPressed: () => cart.removeItem(item.product.id),
            ),
          ],
        ),
      ),
    );
  }
}