// lib/widgets/staff_order_card.dart
import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/order_item.dart';
import 'package:smart_hotpot_manager/models/product.dart';
import 'package:smart_hotpot_manager/services/order_service.dart';
import 'package:smart_hotpot_manager/services/product_service.dart';
import '../models/order.dart';
import 'order_status_tag.dart';

class StaffOrderCard extends StatelessWidget {
  final Order order;
  final OrderService _orderService = OrderService();
  final ProductService _productService = ProductService();
  final void Function(StatusOrder newStatus)? onStatusChanged;

  StaffOrderCard({super.key, required this.order, this.onStatusChanged});

  @override
  Widget build(BuildContext context) {
    // Quyết định màu viền cho thẻ
    final bool isPriority =
        false; // nếu muốn, có thể thêm trường priority vào model Order
    final Color borderColor = isPriority ? Colors.red : Colors.grey.shade300;
    final double borderWidth = isPriority ? 2.0 : 1.0;

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
                    FutureBuilder(
                      future: _orderService.getTableById(order.tableId),
                      builder: (context, asyncSnapshot) {
                        final tableName = asyncSnapshot.data?.name ?? "Không có bàn";
                        return Text(
                          "Bàn ${tableName}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                              overflow: TextOverflow.ellipsis,
                        
                        );
                      }
                    ),
                    Text(
                      "${order.createAt.hour}:${order.createAt.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                OrderStatusTag(status: order.status),
              ],
            ),
            const Divider(height: 24),

            // --- Mã đơn ---
            Text(
              "Mã đơn: ${order.id}",
                maxLines: 1,
                  overflow: TextOverflow.ellipsis,

              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            // --- Danh sách món ăn ---
            StreamBuilder(
              stream: _orderService.getOrderItems(order.id),
              builder: (context, asyncSnapshot) {
                Map<String, Product> productCache = {};
                final items = asyncSnapshot.data ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items.map((item) {
                    final product = productCache[item.productId];
                    return FutureBuilder(
                      future: product != null
                          ? Future.value(product)
                          : _productService
                                .getProductByDocId(item.productId)
                                .first,
                      builder: (context, snap) {
                        if (snap.hasData && product == null) {
                          productCache[item.productId] = snap.data!;
                        }
                        final name = snap.hasData
                            ? snap.data!.name
                            : item.productId;
                        return _buildOrderItemRowWithName(item, name);
                      },
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 16),

            // --- Nút hành động ---
            _buildActionButton(context, order.status),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemRowWithName(OrderItem item, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Chip(
            label: Text(
              "x${item.quantity}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            visualDensity: VisualDensity.compact,
            backgroundColor: Colors.grey.shade200,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? item.productId,
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.note.isNotEmpty)
                  Text(
                    item.note,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, StatusOrder status) {
    switch (status) {
      case StatusOrder.pending:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text("Bắt đầu chuẩn bị"),
            onPressed: () {
              if (onStatusChanged != null)
                onStatusChanged!(StatusOrder.preparing);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A1A),
              foregroundColor: Colors.white,
            ),
          ),
        );
      case StatusOrder.preparing:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check_circle),
            label: const Text("Hoàn thành"),
            onPressed: () {
              if (onStatusChanged != null)
                onStatusChanged!(StatusOrder.complete);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        );
      case StatusOrder.complete:
      case StatusOrder.served:
        return Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.check, color: Colors.green, size: 16),
            label: const Text(
              "Đã phục vụ",
              style: TextStyle(color: Colors.green),
            ),
            onPressed: () {
              if (onStatusChanged != null)
                onStatusChanged!(StatusOrder.served);
            },
          ),
        );
      case StatusOrder.paid:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
