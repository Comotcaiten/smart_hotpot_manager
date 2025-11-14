// lib/screens/staff/staff_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/responsitories/staff_order_repository.dart';
import '../../widgets/staff_order_card.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  // 1. Khởi tạo repository
  final StaffOrderRepository _repository = StaffOrderRepository();
  late Future<List<StaffOrder>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    // 2. Gọi hàm lấy dữ liệu khi màn hình khởi tạo
    _ordersFuture = _repository.getOrders();
  }

  // Hàm xây dựng AppBar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Giao diện Nhân viên",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.grey.shade200,
      actions: [
        // Chú thích trạng thái
        _statusLegendItem(Colors.orange, "Chờ"),
        _statusLegendItem(Colors.blue.shade700, "Đang làm"),
        // Nút đăng xuất
        TextButton.icon(
          icon: const Icon(Icons.exit_to_app, color: Colors.black54),
          label: const Text(
            "Đăng xuất",
            style: TextStyle(color: Colors.black54),
          ),
          onPressed: () { /* TODO: Xử lý đăng xuất */ },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // Widget nhỏ cho chú thích trên AppBar
  Widget _statusLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.black87)),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.grey.shade100, // Màu nền xám nhạt
        // Nút ? ở góc
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.help_outline),
        ),
        // 3. Dùng FutureBuilder để chờ dữ liệu
        body: FutureBuilder<List<StaffOrder>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            // Trạng thái đang tải
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // Trạng thái lỗi
            if (snapshot.hasError) {
              return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
            }
            // Trạng thái không có dữ liệu
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Không có đơn hàng nào."));
            }
      
            // 4. Tải dữ liệu thành công -> Phân loại dữ liệu
            final allOrders = snapshot.data!;
            final pendingOrders = allOrders
                .where((o) => o.status == OrderStatus.pending)
                .toList();
            final preparingOrders = allOrders
                .where((o) => o.status == OrderStatus.preparing)
                .toList();
            final completedOrders = allOrders
                .where((o) => o.status == OrderStatus.completed)
                .toList();
      
            // 5. Xây dựng layout 3 cột (dùng Row + Expanded)
            // Bọc trong SingleChildScrollView để cuộn ngang trên màn hình nhỏ
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                // Đặt chiều rộng tối thiểu cho toàn bộ khu vực
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width), 
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderColumn(
                      "Chờ xử lý (${pendingOrders.length})",
                      pendingOrders,
                    ),
                    _buildOrderColumn(
                      "Đang chuẩn bị (${preparingOrders.length})",
                      preparingOrders,
                    ),
                    _buildOrderColumn(
                      "Đã hoàn thành (${completedOrders.length})",
                      completedOrders,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget xây dựng một cột (ví dụ: cột "Chờ xử lý")
  Widget _buildOrderColumn(String title, List<StaffOrder> orders) {
    return Container(
      width: 320, // Đặt chiều rộng cố định cho mỗi cột
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề cột
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          // Danh sách các thẻ đơn hàng
          ListView.builder(
            itemCount: orders.length,
            shrinkWrap: true, // Quan trọng: để ListView vừa với nội dung
            physics: const NeverScrollableScrollPhysics(), // Để cuộn bằng SingleChildScrollView cha
            itemBuilder: (context, index) {
              return StaffOrderCard(order: orders[index]);
            },
          ),
        ],
      ),
    );
  }
}