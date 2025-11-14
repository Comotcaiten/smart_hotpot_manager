import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/responsitories/staff_order_repository.dart';
import 'package:smart_hotpot_manager/widgets/staff_order_card.dart';
import 'package:smart_hotpot_manager/widgets/title_app_bar.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  final StaffOrderRepository _repository = StaffOrderRepository();
  late Future<List<StaffOrder>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _repository.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleAppBar(
        title: "Smart Hotpot Manager",
        subtitle: "Staff Dashboard",
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 1090;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 12),
                _buildStatusLegend(),
                const SizedBox(height: 12),
                Expanded(
                  child: FutureBuilder<List<StaffOrder>>(
                    future: _ordersFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                            child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
                      }

                      final orders = snapshot.data ?? [];
                      if (orders.isEmpty) {
                        return const Center(child: Text("Không có đơn hàng nào."));
                      }

                      // Phân loại đơn
                      final pending = orders
                          .where((o) => o.status == OrderStatus.pending)
                          .toList();
                      final preparing = orders
                          .where((o) => o.status == OrderStatus.preparing)
                          .toList();
                      final completed = orders
                          .where((o) => o.status == OrderStatus.completed)
                          .toList();

                      final columns = [
                        _buildOrderColumn("Chờ xử lý", pending),
                        _buildOrderColumn("Đang chuẩn bị", preparing),
                        _buildOrderColumn("Đã hoàn thành", completed),
                      ];

                      return SingleChildScrollView(
                        child: Center(
                          child: isWide
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: columns,
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: columns,
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderColumn(String title, List<StaffOrder> orders) {
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
          ),
          const SizedBox(height: 8),
          ListView.builder(
            itemCount: orders.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) => StaffOrderCard(order: orders[i]),
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
              decoration:
                  BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(color: Colors.black87)),
            const SizedBox(width: 16),
          ],
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        legendItem(Colors.orange, "Chờ"),
        legendItem(Colors.blue.shade700, "Đang làm"),
      ],
    );
  }
}
