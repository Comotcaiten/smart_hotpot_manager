// lib/screens/customer/payment_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy tổng tiền được truyền từ CartScreen
    final totalAmount = ModalRoute.of(context)!.settings.arguments as double;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh Toán Hóa Đơn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tổng số tiền cần thanh toán:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(totalAmount),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 40),
            const Text(
              'Vui lòng chọn phương thức thanh toán:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            // Nút Tiền mặt
            ElevatedButton.icon(
              icon: const Icon(Icons.money),
              label: const Text('Thanh Toán Tiền Mặt'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _handlePayment(context, 'Tiền mặt');
              },
            ),
            const SizedBox(height: 16),
            
            // Nút Ngân hàng
            ElevatedButton.icon(
              icon: const Icon(Icons.credit_card),
              label: const Text('Quét Mã / Chuyển khoản'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _handlePayment(context, 'Ngân hàng');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handlePayment(BuildContext context, String method) {
    // 
    // --- XỬ LÝ DATABASE ---
    // Đây là nơi bạn cập nhật trạng thái Order thành 'paid'
    // Ví dụ: _orderService.updateOrderStatus(orderId, StatusOrder.paid);
    //
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thanh toán bằng $method! Cảm ơn quý khách!')),
    );
    
    // Quay về màn hình Menu
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}