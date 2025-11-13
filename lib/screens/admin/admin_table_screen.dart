// lib/screens/admin/admin_table_screen.dart

import 'package:flutter/material.dart';
// Sửa imports
import 'package:smart_hotpot_manager/models/table.dart';
import 'package:smart_hotpot_manager/services/table_service.dart';
// Giữ lại các widget UI
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/section_custom.dart';
import 'package:smart_hotpot_manager/widgets/table_widget.dart';
// SỬA: Import ModalForm
import 'package:smart_hotpot_manager/widgets/modal_app.dart';

class AdminTableScreen extends StatefulWidget {
  const AdminTableScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminTableScreenState();
}

// SỬA: Tạo một class nhỏ để bọc Enum cho ModalForm
// ModalForm của bạn yêu cầu 'item.id' và 'item.name'
class _StatusDisplay {
  final StatusTable status;
  final String name;
  _StatusDisplay(this.status, this.name);
  
  // 'id' sẽ là giá trị được lưu (tên của enum)
  String get id => status.name;
}

class _AdminTableScreenState extends State<AdminTableScreen> {
  // Sửa Service
  final TableService _tableService = TableService();

  // Sửa Controllers cho Bàn
  final _nameController = TextEditingController();
  final _passController = TextEditingController();
  
  // Biến này sẽ được FormFieldDataDropDown quản lý
  String? _selectedStatusName;

  Future<void> _saveTable({TableModel? table}) async {
    // Validate (đã được ModalForm xử lý)
    
    // Lấy StatusTable từ tên (string) đã chọn
    final status = StatusTable.values.firstWhere(
      (e) => e.name == _selectedStatusName,
      orElse: () => StatusTable.empty,
    );

    final now = DateTime.now();
    
    // Lưu context trước khi gọi await
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    if (table == null) {
      // Thêm mới
      final newTable = TableModel(
        restaurantId: "R001",
        id: "", // id sẽ được gán tự động
        name: _nameController.text.trim(),
        pass: _passController.text.trim(),
        status: status, // Dùng status đã chuyển đổi
        createAt: now,
        updateAt: now,
      );
      await _tableService.addTable(newTable); 
    } else {
      // Cập nhật
      await _tableService.updateTable( 
        TableModel(
          restaurantId: table.restaurantId,
          id: table.id,
          name: _nameController.text.trim(),
          pass: _passController.text.trim(),
          status: status, // Dùng status đã chuyển đổi
          createAt: table.createAt, // Giữ ngày tạo
          updateAt: now, // Cập nhật
        ),
      );
    }

    _nameController.clear();
    _passController.clear();
    _selectedStatusName = null;

    String notification =
        table == null ? "Thêm bàn thành công!" : "Chỉnh sửa thành công";

    nav.pop(); // đóng modal

    messenger.showSnackBar(SnackBar(
      content: Text(notification),
      backgroundColor: Colors.green,
    ));
  }

  Future<void> _deleteTable({TableModel? table}) async { // Sửa
    String notification;

    if (table == null) {
      notification = "Không thể xóa bàn";
    } else {
      await _tableService.deleteTable(table.id); // Sửa
      notification = "Xóa thành công ${table.name}"; // Sửa
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderIconLead(
            title: "Quản lý Bàn", // Sửa
            subtitle: "Thêm, sửa, xóa bàn và trạng thái", // Sửa
            icon: AppIcon(
              size: 46,
              icon: Icons.table_restaurant_rounded, // Sửa
              colors: [Colors.purple, Colors.black], // Sửa
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Thêm bàn mới"), // Sửa
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _openAddTableModal(); // Sửa
              },
            ),
          ),
          const SizedBox(height: 16),
          // SỬA: Thêm Expanded để fix lỗi layout
          _buildTable()
        ],
      ),
    );
  }

  // Xây dựng bảng Bàn
  Widget _buildTable() { 
    // ... (Hàm này giữ nguyên, không thay đổi) ...
    // ... (Bạn có thể dán code _buildTable từ file cũ của bạn vào đây) ...
    return StreamBuilder<List<TableModel>>( // Sửa
      stream: _tableService.getAllTables(), // Sửa
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
            child: Center(child: Text("Lỗi tải dữ liệu bàn: ${snapshot.error}")),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Text("Chưa có bàn nào được thêm.")), // Sửa
          );
        }
        final tables = snapshot.data!;
        return BaseTable(
          columnWidths: const { 
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(1.5),
          },
          buildHeaderRow: const TableRow(
            children: [ 
              HeaderCellWidgetText(content: "Tên bàn"),
              HeaderCellWidgetText(content: "Mật khẩu"),
              HeaderCellWidgetText(content: "Trạng thái", align: TextAlign.left),
              HeaderCellWidgetText(
                content: "Thao tác",
                align: TextAlign.center,
              ),
            ],
          ),
          buildDataRow: tables.map((table) { 
            return TableRow(
              children: [
                DataCellWidgetText(content: table.name), 
                DataCellWidgetText(content: table.pass), 
                DataCellWidgetBadge(
                  option_1: "Trống", 
                  option_2: "Có khách",
                  inStock: table.status == StatusTable.empty,
                ),
                DataCellWidgetAction(
                  editAction: () async {
                    _openAddTableModal(table: table); 
                  },
                  deleteAction: () async {
                    _deleteTable(table: table); 
                  },
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  // SỬA: Toàn bộ hàm này để dùng ModalForm
  void _openAddTableModal({TableModel? table}) {
    // Đặt giá trị ban đầu cho modal
    _nameController.text = table?.name ?? '';
    _passController.text = table?.pass ?? '';
    _selectedStatusName = table?.status.name; // Lưu tên của enum (String)

    // Tạo danh sách các lựa chọn trạng thái
    final statusOptions = StatusTable.values.map((status) {
      // Dùng model để lấy tên Tiếng Việt
      String text = TableModel(
              id: '', restaurantId: '', name: '', pass: '',
              status: status, createAt: DateTime.now(), updateAt: DateTime.now())
          .statusString;
      // Trả về class _StatusDisplay
      return _StatusDisplay(status, text);
    }).toList();
    
    // Tạo 1 stream từ danh sách tĩnh này
    final statusStream = Stream.value(statusOptions);

    showDialog(
      context: context,
      builder: (context) {
        return ModalForm(
          title: table == null ? "Thêm bàn mới" : "Chỉnh sửa bàn",
          
          // Danh sách các trường (Text và Dropdown)
          fields: [
            // 1. Tên bàn
            FormFieldDataText(
              label: "Tên bàn",
              hintText: "VD: Bàn 1",
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập tên bàn";
                }
                return null;
              },
            ),
            
            // 2. Mật khẩu
            FormFieldDataText(
              label: "Mật khẩu",
              hintText: "VD: 123456",
              controller: _passController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập mật khẩu";
                }
                return null;
              },
            ),
            
            // 3. Trạng thái (Dropdown)
            FormFieldDataDropDown(
              label: "Trạng thái",
              hintText: "Chọn trạng thái",
              stream: statusStream, // Truyền stream
              selectedValue: _selectedStatusName, // Truyền giá trị đã chọn
              onChanged: (value) {
                // Cập nhật giá trị khi người dùng chọn
                _selectedStatusName = value.toString();
              },
              validator: (value) {
                if (value == null) {
                  return "Vui lòng chọn trạng thái";
                }
                return null;
              },
            ),
          ],
          
          // Hàm được gọi khi nhấn "Lưu"
          onSubmit: () async {
            _saveTable(table: table);
          },
        );
      },
    );
  }
}