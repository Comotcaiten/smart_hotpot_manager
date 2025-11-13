// lib/screens/customer/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_hotpot_manager/services/cart_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ Hàng Của Bạn'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.itemCount == 0
                ? const Center(child: Text('Giỏ hàng của bạn đang trống.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: cart.itemsList.length,
                    itemBuilder: (ctx, i) {
                      final item = cart.itemsList[i];
                      return _buildCartItemTile(context, cart, item, currencyFormat);
                    },
                  ),
          ),
          
          if (cart.itemCount > 0)
            _buildTotalSection(context, cart, currencyFormat),
        ],
      ),
    );
  }

  Widget _buildCartItemTile(BuildContext context, CartProvider cart, CartItem item, NumberFormat format) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: Image.network(
                item.product.imageUrl.isNotEmpty 
                  ? item.product.imageUrl
                  : 'https://via.placeholder.com/100',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(format.format(item.totalPrice)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () {
                      cart.decrementItem(item.product.id);
                    },
                  ),
                  Text(
                    '${item.quantity}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                    onPressed: () {
                      cart.addItem(item.product);
                    },
                  ),
                ],
              ),
            ),
            // Ô Ghi chú
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: TextField(
                controller: item.noteController, // Dùng controller từ CartItem
                decoration: const InputDecoration(
                  hintText: 'Thêm ghi chú (ví dụ: không cay, ít hành...)',
                  isDense: true,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection(BuildContext context, CartProvider cart, NumberFormat format) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng cộng',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  format.format(cart.totalAmount),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send_rounded),
                label: const Text('Xác Nhận Gửi Đơn Hàng'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  final total = cart.totalAmount; // Lưu tổng tiền
                  try {
                    await cart.confirmOrder();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã gửi đơn hàng đến bếp!'), backgroundColor: Colors.green),
                    );
                    // Đóng giỏ hàng VÀ Mở màn hình thanh toán
                    Navigator.of(context).popAndPushNamed('/payment', arguments: total);
                  } catch (e) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gửi đơn thất bại: $e'), backgroundColor: Colors.red),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}