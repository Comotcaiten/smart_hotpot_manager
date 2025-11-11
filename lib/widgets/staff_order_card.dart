// lib/widgets/staff_order_card.dart
import 'package:flutter/material.dart';
import '../responsitories/staff_order_repository.dart';
import 'order_status_tag.dart';

class StaffOrderCard extends StatelessWidget {
  final StaffOrder order;
  const StaffOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Quyết định màu viền cho thẻ
    final Color borderColor = order.isPriority ? Colors.red : Colors.grey.shade300;
    final double borderWidth = order.isPriority ? 2.0 : 1.0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor, width: borderWidth),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Hàng đầu tiên: Tên bàn, thời gian, tag ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.tableName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      order.time,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (order.isPriority)
                      const Chip(
                        label: Text("Ưu tiên"),
                        backgroundColor: Colors.red,
                        labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                        padding: EdgeInsets.zero,
                      ),
                    const SizedBox(width: 8),
                    OrderStatusTag(status: order.status),
                  ],
                )
              ],
            ),
            const Divider(height: 24),

            // --- Mã đơn ---
            Text(
              "Mã đơn: ${order.id}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            // --- Danh sách món ăn ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.items.map((item) => _buildOrderItemRow(item)).toList(),
            ),
            const SizedBox(height: 16),

            // --- Nút hành động ---
            _buildActionButton(context, order.status),
          ],
        ),
      ),
    );
  }

  // Widget cho một hàng món ăn (ví dụ: x1 Lẩu Thái)
  Widget _buildOrderItemRow(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Chip(
            label: Text("x${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
            visualDensity: VisualDensity.compact,
            backgroundColor: Colors.grey.shade200,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontSize: 16)),
                if (item.note != null && item.note!.isNotEmpty)
                  Text(
                    item.note!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget quyết định hiển thị nút nào (Bắt đầu, Hoàn thành, Đã phục vụ)
  Widget _buildActionButton(BuildContext context, OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text("Bắt đầu chuẩn bị"),
            onPressed: () { /* TODO: Xử lý cập nhật trạng thái */ },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A1A), // Màu đen
              foregroundColor: Colors.white,
            ),
          ),
        );
      case OrderStatus.preparing:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check_circle),
            label: const Text("Hoàn thành"),
            onPressed: () { /* TODO: Xử lý cập nhật trạng thái */ },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Màu xanh
              foregroundColor: Colors.white,
            ),
          ),
        );
      case OrderStatus.completed:
        return Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.check, color: Colors.green, size: 16),
            label: const Text(
              "Đã phục vụ",
              style: TextStyle(color: Colors.green),
            ),
            onPressed: () { /* TODO: Xử lý ẩn đơn hàng */ },
          ),
        );
    }
  }
}