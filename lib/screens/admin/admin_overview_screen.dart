// lib/screens/admin/admin_overview_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Import các model và service THẬT
import 'package:smart_hotpot_manager/models/order.dart';
import 'package:smart_hotpot_manager/models/table.dart';
import 'package:smart_hotpot_manager/services/order_service.dart';
import 'package:smart_hotpot_manager/services/table_service.dart';
// Import các widget UI
// (Hãy chắc chắn rằng bạn đã tạo file summary_card.dart từ lượt trước)
import 'package:smart_hotpot_manager/widgets/summary_card.dart'; 
// import 'package:smart_hotpot_manager/widgets/section_custom.dart';
import 'package:smart_hotpot_manager/widgets/table_widget.dart';

class AdminOverviewScreen extends StatefulWidget {
  const AdminOverviewScreen({super.key});

  @override
  State<AdminOverviewScreen> createState() => _AdminOverviewScreenState();
}

class _AdminOverviewScreenState extends State<AdminOverviewScreen> {
  // Dùng các service thật
  final OrderService _orderService = OrderService();
  final TableService _tableService = TableService();

  // Dùng Future.wait để tải đồng thời 2 nguồn dữ liệu
  late Future<Map<String, dynamic>> _dataFuture;

  // Map để tra cứu tên Bàn
  Map<String, String> _tableNameMap = {};

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  // Hàm tải dữ liệu từ 2 service
  Future<Map<String, dynamic>> _loadData() async {
    // Dùng .first để lấy dữ liệu 1 lần từ Stream
    final allOrders = await _orderService.getAllOrders().first;
    final allTables = await _tableService.getAllTables().first;

    // Tải map tên bàn để tra cứu
    _tableNameMap = {for (var table in allTables) table.id: table.name};
    
    return {
      'orders': allOrders, // Đây là List<Order>
      'tables': allTables, // Đây là List<TableModel>
    };
  }
  
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
  final timeFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text("Không có dữ liệu tổng quan."));
        }

        // Lấy dữ liệu đã tải
        // Code này sẽ đọc List<Order>, không phải List<RecentOrder>
        final allOrders = snapshot.data!['orders'] as List<Order>; 
        final allTables = snapshot.data!['tables'] as List<TableModel>;

        // Xây dựng giao diện
        // Bỏ Column đi để nó hoạt động bên trong SingleChildScrollView của file cha
        return Column(
          children: [
            // 1. Hàng 4 thẻ thống kê
            _buildSummaryRow(allOrders, allTables),
            const SizedBox(height: 24),
            // 2. Bảng đơn hàng gần đây
            _buildRecentOrdersTable(allOrders),
          ],
        );
      },
    );
  }

  // Widget cho 4 thẻ thống kê (Tính toán dữ liệu thật)
  Widget _buildSummaryRow(List<Order> allOrders, List<TableModel> allTables) {
    
    // --- TÍNH TOÁN DỮ LIỆU BẠN YÊU CẦU ---
    
    // 1. Tổng doanh thu từ những order đã thanh toán
    double totalRevenue = allOrders
        .where((order) => order.status == StatusOrder.paid)
        .fold(0.0, (sum, order) => sum + order.totalAmount);

    // 2. Đơn hàng đang xử lý (Chưa xử lý = pending hoặc preparing)
    int processingOrders = allOrders
        .where((order) => 
            order.status == StatusOrder.pending || 
            order.status == StatusOrder.preparing)
        .length;

    // 3. Bàn đang sử dụng
    int tablesInUse = allTables
        .where((table) => table.status == StatusTable.inUse)
        .length;
    int totalTables = allTables.length;

    // 4. Tăng trưởng (Giữ nguyên)
    String growth = "+15%"; 
    
    // ------------------------------------

    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: "Tổng doanh thu", // Đã thanh toán
            value: currencyFormat.format(totalRevenue),
            icon: Icons.attach_money,
            iconColor: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SummaryCard(
            title: "Đơn hàng đang xử lý",
            value: processingOrders.toString(),
            icon: Icons.shopping_cart_outlined,
            iconColor: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SummaryCard(
            title: "Bàn đang sử dụng",
            value: "$tablesInUse/$totalTables",
            icon: Icons.people_alt_outlined,
            iconColor: Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SummaryCard(
            title: "Tăng trưởng",
            value: growth,
            icon: Icons.trending_up,
            iconColor: Colors.purple,
          ),
        ),
      ],
    );
  }

  // Widget cho bảng (Tái sử dụng các widget của bạn)
  Widget _buildRecentOrdersTable(List<Order> orders) {
    // Chỉ lấy 3 đơn hàng mới nhất
    final recentOrders = orders.take(3).toList();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Đơn hàng gần đây",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Theo dõi đơn hàng trong thời gian thực",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Bảng (Tái sử dụng BaseTable của bạn)
          BaseTable(
            columnWidths: const {
              0: FlexColumnWidth(1.5), // Mã đơn
              1: FlexColumnWidth(1.5), // Bàn
              2: FlexColumnWidth(2),   // Trạng thái
              3: FlexColumnWidth(1.5), // Thời gian
              4: FlexColumnWidth(2),   // Tổng tiền
            },
            buildHeaderRow: const TableRow(
              children: [
                HeaderCellWidgetText(content: "Mã đơn"),
                HeaderCellWidgetText(content: "Bàn"),
                HeaderCellWidgetText(content: "Trạng thái"),
                HeaderCellWidgetText(content: "Thời gian"),
                HeaderCellWidgetText(content: "Tổng tiền"),
              ],
            ),
            buildDataRow: recentOrders.map((order) {
              // Lấy tên bàn từ Map
              final tableName = _tableNameMap[order.tableId] ?? "N/A";

              // Logic cho Badge
              bool isInStock = order.status == StatusOrder.complete || 
                                 order.status == StatusOrder.served ||
                                 order.status == StatusOrder.paid;
              String option1 = order.statusString; 
              String option2 = order.statusString; 

              return TableRow(
                children: [
                  DataCellWidgetText(content: order.id),
                  DataCellWidgetText(content: tableName),
                  DataCellWidgetBadge(
                    option_1: option1,
                    option_2: option2,
                    inStock: isInStock,
                  ),
                  DataCellWidgetText(content: timeFormat.format(order.createAt)),
                  DataCellWidgetText(
                    content: currencyFormat.format(order.totalAmount),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}