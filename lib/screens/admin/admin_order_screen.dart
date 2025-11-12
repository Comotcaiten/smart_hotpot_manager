// lib/screens/admin/admin_order_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import để format tiền và giờ
// Sửa import
import 'package:smart_hotpot_manager/models/order.dart';
import 'package:smart_hotpot_manager/models/table_model.dart';
import 'package:smart_hotpot_manager/services/order_service.dart';
import 'package:smart_hotpot_manager/services/table_service.dart';
// Giữ lại các widget
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/section_custom.dart';
import 'package:smart_hotpot_manager/widgets/table_widget.dart';
// import 'package:smart_hotpot_manager/widgets/modal_app.dart'; // Không dùng modal này

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  // Sửa Service
  final OrderService _orderService = OrderService();
  final TableService _tableService = TableService(); // Cần để lấy tên bàn

  // Map để tra cứu tên Bàn (tableId -> tableName)
  Map<String, String> _tableNameMap = {};

  // Xóa controllers
  // final _nameController = TextEditingController();
  // final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTableNames(); // Tải tên các bàn khi khởi động
  }

  // Hàm mới: Tải tên các bàn để hiển thị
  Future<void> _loadTableNames() async {
    final tables = await _tableService.getAllTables().first;
    setState(() {
      _tableNameMap = {for (var table in tables) table.id: table.name};
    });
  }

  // Xóa hàm _saveCategory (Admin không tạo đơn hàng)

  // Sửa hàm _deleteCategory
  Future<void> _deleteOrder({Order? order}) async {
    String notification;

    if (order == null) {
      notification = "Không thể xóa đơn hàng";
    } else {
      await _orderService.deleteOrder(order.id); // Sửa
      notification = "Xóa thành công đơn hàng ${order.id}"; // Sửa
    }

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(
      content: Text(notification),
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
        crossAxisAlignment: CrossAxisAlignment.start, // Sửa: bỏ MainAxisAlignment
        children: [
          SectionHeaderIconLead(
            title: "Tất cả đơn hàng", // Sửa
            subtitle: "Quản lý và theo dõi đơn hàng", // Sửa
            icon: AppIcon(
              size: 46,
              icon: Icons.receipt_long_rounded, // Sửa
              colors: [Colors.orange, Colors.black], // Sửa
            ),
          ),
          const SizedBox(height: 16),
          _buildOrderTable()
        ],
      ),
    );
  }

  Widget _buildOrderTable() { // Sửa
    // Định dạng tiền tệ và thời gian
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    final timeFormat = DateFormat('HH:mm');

    return StreamBuilder<List<Order>>( // Sửa
      stream: _orderService.getAllOrders(), // Sửa
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
            child: Center(child: Text("Chưa có đơn hàng nào.")), // Sửa
          );
        }

        final orders = snapshot.data!; // Sửa

        return BaseTable(
          // Sửa: 6 cột
          columnWidths: const { 
            0: FlexColumnWidth(2), // Mã đơn
            1: FlexColumnWidth(1.5), // Bàn
            2: FlexColumnWidth(2), // Trạng thái
            3: FlexColumnWidth(1.5), // Thời gian
            4: FlexColumnWidth(2), // Tổng tiền
            5: FlexColumnWidth(1.5), // Thao tác
          },
          buildHeaderRow: const TableRow(
            children: [ // Sửa: 6 cột
              HeaderCellWidgetText(content: "Mã đơn"),
              HeaderCellWidgetText(content: "Bàn"),
              HeaderCellWidgetText(content: "Trạng thái", align: TextAlign.left),
              HeaderCellWidgetText(content: "Thời gian"),
              HeaderCellWidgetText(content: "Tổng tiền"),
              HeaderCellWidgetText(
                content: "Thao tác",
                align: TextAlign.center,
              ),
            ],
          ),
          buildDataRow: orders.map((order) { // Sửa
            // Lấy tên bàn từ Map
            final tableName = _tableNameMap[order.tableId] ?? "N/A";
            
            // Logic cho màu Badge: 
            // Giả sử "Đã thanh toán" là `inStock: true` (màu đen)
            // Các trạng thái còn lại là `inStock: false` (màu đỏ)
            bool isPaid = order.status == StatusOrder.paid;

            return TableRow(
              children: [
                DataCellWidgetText(content: order.id), // Sửa
                DataCellWidgetText(content: tableName), // Sửa
                // Tái sử dụng DataCellWidgetBadge của bạn
                DataCellWidgetBadge(
                  option_1: order.statusString, // Hiển thị "Đang chuẩn bị", v.v.
                  option_2: " ", // Bắt buộc phải có (dựa trên lỗi trước)
                  inStock: isPaid,
                ),
                DataCellWidgetText(content: timeFormat.format(order.createAt)), // Sửa
                DataCellWidgetText(content: currencyFormat.format(order.totalAmount)), // Sửa
                // Tái sử dụng DataCellWidgetAction của bạn
                DataCellWidgetAction(
                  editAction: () async {
                    // "Edit" -> Mở modal đổi trạng thái
                    _openUpdateStatusModal(order: order);
                  },
                  deleteAction: () async {
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

  // Hàm mới: Mở modal để Cập nhật trạng thái
  // (Không thể dùng ModalForm của bạn vì nó không hỗ trợ Dropdown)
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
                initialValue: newSelectedStatus,
                decoration: const InputDecoration(
                  labelText: "Trạng thái mới",
                ),
                items: StatusOrder.values.map((StatusOrder status) {
                  // Dùng statusString để hiển thị Tiếng Việt
                  return DropdownMenuItem<StatusOrder>(
                    value: status,
                    child: Text(Order( // Tạo instance tạm để lấy string
                       id: '', restaurantId: '', tableId: '', status: status, 
                      totalAmount: 0, createAt: DateTime.now(), updateAt: DateTime.now()
                    ).statusString),
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
                    final nav = Navigator.of(context);
                    final messenger = ScaffoldMessenger.of(context);
                    
                    await _orderService.updateOrderStatus(order.id, newSelectedStatus);
                    
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