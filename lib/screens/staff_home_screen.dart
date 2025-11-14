// lib/screens/staff_home_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/order.dart';
import 'package:smart_hotpot_manager/services/order_service.dart';
import 'package:smart_hotpot_manager/services/auth_service.dart';
import 'package:smart_hotpot_manager/widgets/staff_order_card.dart';
import 'package:smart_hotpot_manager/widgets/title_app_bar.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService();

  late String restaurantId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleAppBar(
        title: "Smart Hotpot Manager",
        subtitle: "Staff Dashboard",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8.0),
            _buildStatusLegend(),
            SizedBox(height: 8.0),
            FutureBuilder(
              future: _authService.getAccout(),
              builder: (context, snapshotAcc) {
                if (snapshotAcc.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshotAcc.hasData || snapshotAcc.data == null) {
                  return const Center(child: Text("Không tìm thấy nhà hàng."));
                }

                restaurantId = snapshotAcc.data!.restaurantId;

                return StreamBuilder<List<Order>>(
                  stream: _orderService.getAllOrders(restaurantId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Lỗi tải dữ liệu: ${snapshot.error}"),
                      );
                    }

                    final orders = snapshot.data ?? [];
                    if (orders.isEmpty) {
                      return const Center(
                        child: Text("Không có đơn hàng nào."),
                      );
                    }

                    // Phân loại đơn
                    final pending = orders
                        .where((o) => o.status == StatusOrder.pending)
                        .toList();
                    final preparing = orders
                        .where((o) => o.status == StatusOrder.preparing)
                        .toList();
                    final completed = orders
                        .where((o) => o.status == StatusOrder.complete)
                        .toList();

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 1090;
                        final columns = [
                          _buildOrderColumn("Chờ xử lý", pending),
                          _buildOrderColumn("Đang chuẩn bị", preparing),
                          _buildOrderColumn("Hoàn thành", completed),
                        ];

                        return SingleChildScrollView(
                          child: Center(
                            child: isWide
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: columns,
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: columns,
                                  ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderColumn(String title, List<Order> orders) {
    return Container(
      width: 320,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title (${orders.length})".toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
    overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          ListView.builder(
            itemCount: orders.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              final order = orders[i];
              return StaffOrderCard(
                order: order,
                onStatusChanged: (newStatus) {
                  _orderService.updateOrderStatus(order.id, newStatus);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusLegend() {
    Widget legendItem(Color color, String text) => Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.black87)),
        const SizedBox(width: 16),
      ],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        legendItem(Colors.orange, "Chờ xử lý"),
        legendItem(Colors.blue.shade700, "Đang chuẩn bị"),
        legendItem(Colors.green.shade700, "Hoàn thành"),
      ],
    );
  }
}
