// lib/screens/admin/admin_order_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:smart_hotpot_manager/models/order.dart';
import 'package:smart_hotpot_manager/models/order_item.dart';
import 'package:smart_hotpot_manager/services/order_service.dart';
import 'package:smart_hotpot_manager/services/table_service.dart'; 
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/section_custom.dart';
// <-- SỬA: Thêm import này
import 'package:smart_hotpot_manager/widgets/table_widget.dart'; 

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  // Services
  final OrderService _orderService = OrderService();
  final TableService _tableService = TableService(); 

  Map<String, String> _tableNameMap = {};

  @override
  void initState() {
    super.initState();
    _loadTableNames();
  }

  Future<void> _loadTableNames() async {
    final tables = await _tableService.getAllTables().first;
    setState(() {
      _tableNameMap = {for (var table in tables) table.id: table.name};
    });
  }
  
  Future<void> _deleteOrder({required Order order}) async {
    await _orderService.deleteOrder(order.id);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(
      content: Text("Xóa thành công đơn hàng ${order.id}"),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainLayout();
  }

  Widget _buildMainLayout() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderIconLead(
            title: "Quản lý Đơn hàng",
            subtitle: "Xem và cập nhật trạng thái đơn hàng",
            icon: AppIcon(
              size: 46,
              icon: Icons.receipt_long_rounded, 
              colors: [Colors.orange, Colors.black],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: _buildOrderTable()),
        ],
      ),
    );
  }

  // Bảng hiển thị danh sách các Đơn hàng
  Widget _buildOrderTable() {
    return StreamBuilder<List<Order>>(
      stream: _orderService.getAllOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
           return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}")),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Text("Chưa có đơn hàng nào.")),
          );
        }

        final orders = snapshot.data!;
        final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

        return BaseTable(
          columnWidths: const { 
            0: FlexColumnWidth(2), // Bàn
            1: FlexColumnWidth(2), // Tổng tiền
            2: FlexColumnWidth(2), // Trạng thái
            3: FlexColumnWidth(2.5), // Thao tác
          },
          buildHeaderRow: const TableRow(
            children: [ 
              HeaderCellWidgetText(content: "Bàn"),
              HeaderCellWidgetText(content: "Tổng tiền"),
              HeaderCellWidgetText(content: "Trạng thái", align: TextAlign.left),
              HeaderCellWidgetText(
                content: "Thao tác",
                align: TextAlign.center,
              ),
            ],
          ),
          buildDataRow: orders.map((order) {
            final tableName = _tableNameMap[order.tableId] ?? "Bàn đã xóa";
           
            // Logic cho Badge
            // Giả sử 'inStock' = true (màu đen) cho trạng thái "đã thanh toán"
            // và 'inStock' = false (màu đỏ) cho các trạng thái còn lại
            bool isPaid = order.status == StatusOrder.paid;

            return TableRow(
              children: [
                DataCellWidgetText(content: tableName),
                DataCellWidgetText(content: currencyFormat.format(order.totalAmount)),
                
                // <-- SỬA: Sử dụng DataCellWidgetBadge với các tham số TỒN TẠI
                DataCellWidgetBadge(
                  option_1: order.statusString, // Tên trạng thái (VD: Chờ xử lý)
                  option_2: " ", // Phải có option_2 (dựa trên lỗi)
                  inStock: isPaid, // Dùng logic bool
                ),

                // <-- SỬA: Chỉ dùng 2 tham số TỒN TẠI
                DataCellWidgetAction(
                  editAction: () {
                    // "Edit" -> Mở modal đổi trạng thái
                    _openUpdateStatusModal(order: order);
                  },
                  deleteAction: () {
                    // "Delete" -> Gọi hàm xóa
                    _deleteOrder(order: order);
                  },
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }


  // Modal (popup) để XEM CHI TIẾT các món trong đơn
  void _openViewItemsModal({required Order order}) {
    // (Hàm này giữ nguyên như code trước)
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Chi tiết đơn hàng: ${order.id}"),
          content: SizedBox(
            width: 400, 
            child: StreamBuilder<List<OrderItem>>(
              stream: _orderService.getOrderItems(order.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data!;
                final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(
                        "${item.quantity} x ${currencyFormat.format(item.price)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: item.note.isNotEmpty
                          ? Text("Ghi chú: ${item.note}")
                          : null,
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Đóng"),
            )
          ],
        );
      },
    );
  }

  // Modal (popup) để CẬP NHẬT TRẠNG THÁI
  void _openUpdateStatusModal({required Order order}) {
    StatusOrder newSelectedStatus = order.status; 

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text("Đổi trạng thái (Đơn: ${order.id})"),
              content: DropdownButtonFormField<StatusOrder>(
                // SỬA: Dùng `initialValue` thay vì `value`
                initialValue: newSelectedStatus,
                decoration: const InputDecoration(
                  labelText: "Trạng thái mới",
                ),
                items: StatusOrder.values.map((StatusOrder status) {
                  // Tạo một Order tạm để lấy statusString tiếng Việt
                  final tempOrder = Order(
                      id: '', restaurantId: '', tableId: '', status: status, 
                      totalAmount: 0, createAt: DateTime.now(), updateAt: DateTime.now()
                  );
                  return DropdownMenuItem<StatusOrder>(
                    value: status,
                    child: Text(tempOrder.statusString),
                  );
                }).toList(),
                onChanged: (StatusOrder? newValue) {
                  setModalState(() {
                    if (newValue != null) {
                      newSelectedStatus = newValue;
                    }
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Hủy"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Dùng context trước khi await
                    final nav = Navigator.of(context);
                    final messenger = ScaffoldMessenger.of(context);
                    
                    await _orderService.updateOrderStatus(order.id, newSelectedStatus);
                    
                    // SỬA: Đã lưu context, không còn lỗi async gap
                    nav.pop(); // Đóng modal
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text("Đã cập nhật trạng thái!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text("Lưu"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}