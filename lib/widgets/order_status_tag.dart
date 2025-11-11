// lib/widgets/order_status_tag.dart
import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/responsitories/staff_order_repository.dart';// Import để dùng enum

class OrderStatusTag extends StatelessWidget {
  final OrderStatus status;
  const OrderStatusTag({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    String text;
    Color backgroundColor;
    Color textColor = Colors.white; // Mặc định chữ trắng

    switch (status) {
      case OrderStatus.pending:
        text = "Chờ xử lý";
        backgroundColor = Colors.orange;
        break;
      case OrderStatus.preparing:
        text = "Đang chuẩn bị";
        backgroundColor = Colors.blue.shade700;
        break;
      case OrderStatus.completed:
        text = "Hoàn thành";
        backgroundColor = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}