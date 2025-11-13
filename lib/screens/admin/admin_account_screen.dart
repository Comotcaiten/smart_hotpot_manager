// lib/screens/admin/admin_account_screen.dart

import 'package:flutter/material.dart';
// Sửa imports
import 'package:smart_hotpot_manager/models/staff.dart';
import 'package:smart_hotpot_manager/models/restaurant.dart'; // Cần cho RoleAccount
import 'package:smart_hotpot_manager/services/account_service.dart';
// Giữ lại các widget UI
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/section_custom.dart';
import 'package:smart_hotpot_manager/widgets/table_widget.dart';
import 'package:smart_hotpot_manager/widgets/modal_app.dart';

class AdminAccountScreen extends StatefulWidget {
  const AdminAccountScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminAccountScreenState();
}

// Class helper để ModalForm hiển thị Enum RoleAccount
class _RoleDisplay {
  final RoleAccount role;
  final String name;
  _RoleDisplay(this.role, this.name);
  
  String get id => role.name; // 'id' là tên của enum (VD: "admin")
}

class _AdminAccountScreenState extends State<AdminAccountScreen> {
  // Sửa Service
  final AccountService _accountService = AccountService();

  // Sửa Controllers
  final _nameController = TextEditingController();
  final _gmailController = TextEditingController();
  final _passController = TextEditingController();
  String? _selectedRoleName; // Biến trạng thái cho modal

  Future<void> _saveAccount({Staff? staff}) async {
    // Validate (đã được ModalForm xử lý)
    
    // Lấy RoleAccount từ tên (string) đã chọn
    final role = RoleAccount.values.firstWhere(
      (e) => e.name == _selectedRoleName, // So sánh "table" == "table"
      orElse: () => RoleAccount.staff, // Sẽ không chạy vào đây nữa
    );

    final now = DateTime.now();
    
    // SỬA: Lưu context trước khi gọi await
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    if (staff == null) {
      // Thêm mới
      final newStaff = Staff(
        restaurantId: "R001", // TODO: Lấy ID nhà hàng thật
        id: "", 
        name: _nameController.text.trim(),
        gmail: _gmailController.text.trim(),
        pass: _passController.text.trim(), // TODO: Cần mã hóa mật khẩu
        role: role, // <-- Dùng `role` đã được tìm đúng
        createAt: now,
        updateAt: now,
      );
      await _accountService.addAccount(newStaff); 
    } else {
      // Cập nhật
      await _accountService.updateAccount( 
        Staff(
          restaurantId: staff.restaurantId,
          id: staff.id,
          name: _nameController.text.trim(),
          gmail: _gmailController.text.trim(),
          pass: _passController.text.trim().isNotEmpty 
                ? _passController.text.trim() 
                : staff.pass, 
          role: role, // <-- Dùng `role` đã được tìm đúng
          createAt: staff.createAt, 
          updateAt: now, 
        ),
      );
    }

    _nameController.clear();
    _gmailController.clear();
    _passController.clear();
    _selectedRoleName = null;

    String notification =
        staff == null ? "Thêm tài khoản thành công!" : "Chỉnh sửa thành công";

    nav.pop(); // đóng modal

    messenger.showSnackBar(SnackBar(
      content: Text(notification),
      backgroundColor: Colors.green,
    ));
  }

  Future<void> _deleteAccount({Staff? staff}) async { 
    String notification;

    if (staff == null) {
      notification = "Không thể xóa tài khoản";
    } else {
      await _accountService.deleteAccount(staff.id); 
      notification = "Xóa thành công ${staff.name}"; 
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
            title: "Quản lý Tài khoản", 
            subtitle: "Thêm, sửa, xóa tài khoản nhân viên", 
            icon: AppIcon(
              size: 46,
              icon: Icons.people_alt_rounded, 
              colors: [Colors.teal, Colors.black], 
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Thêm tài khoản"), 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _openAddAccountModal(); 
              },
            ),
          ),
          const SizedBox(height: 16),
          // SỬA: Thêm Expanded để fix lỗi layout
          _buildAccountTable()
        ],
      ),
    );
  }

  // Xây dựng bảng Tài khoản
  Widget _buildAccountTable() { 
    return StreamBuilder<List<Staff>>( 
      stream: _accountService.getAllAccounts(), 
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
            child: Center(child: Text("Chưa có tài khoản nào.")), 
          );
        }

        final accounts = snapshot.data!; 

        return BaseTable(
          columnWidths: const { 
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(1.5),
            3: FlexColumnWidth(1.5),
          },
          buildHeaderRow: const TableRow(
            children: [ 
              HeaderCellWidgetText(content: "Tên"),
              HeaderCellWidgetText(content: "Gmail"),
              HeaderCellWidgetText(content: "Vai trò", align: TextAlign.left),
              HeaderCellWidgetText(
                content: "Thao tác",
                align: TextAlign.center,
              ),
            ],
          ),
          buildDataRow: accounts.map((account) { 
            // SỬA: Sửa lại logic cho DataCellWidgetBadge
            String roleName;
            bool inStock; // inStock = true (màu đen), false (màu đỏ)
            
            switch(account.role) {
              case RoleAccount.admin:
                roleName = "Admin";
                inStock = true; // Màu đen
                break;
              case RoleAccount.staff:
                roleName = "Staff";
                inStock = false; // Màu đỏ
                break;
              case RoleAccount.table:
                roleName = "Table";
                inStock = false; // Màu đỏ
                break;
              default:
                roleName = "None";
                inStock = false;
            }

            return TableRow(
              children: [
                DataCellWidgetText(content: account.name), 
                DataCellWidgetText(content: account.gmail), 
                DataCellWidgetBadge(
                  option_1: roleName, 
                  option_2: roleName,
                  inStock: inStock,
                ),
                DataCellWidgetAction(
                  editAction: () async {
                    _openAddAccountModal(staff: account); 
                  },
                  deleteAction: () async {
                    _deleteAccount(staff: account); 
                  },
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  // SỬA: Dùng ModalForm
  void _openAddAccountModal({Staff? staff}) {
    // Đặt giá trị ban đầu cho modal
    _nameController.text = staff?.name ?? '';
    _gmailController.text = staff?.gmail ?? '';
    _passController.text = ''; 
    _selectedRoleName = staff?.role.name; 

    final roleOptions = [
      _RoleDisplay(RoleAccount.admin, "Admin"),
      _RoleDisplay(RoleAccount.staff, "Staff"),
      _RoleDisplay(RoleAccount.table, "Table"),
    ];
    
    final roleStream = Stream.value(roleOptions);

    showDialog(
      context: context,
      builder: (context) {
        return ModalForm(
          title: staff == null ? "Thêm tài khoản" : "Chỉnh sửa tài khoản",
          
          fields: [
            // 1. Tên
            FormFieldDataText(
              label: "Tên nhân viên",
              hintText: "VD: Nguyễn Văn A",
              controller: _nameController,
              validator: (value) => (value == null || value.isEmpty) ? "Vui lòng nhập tên" : null,
            ),
            
            // 2. Gmail
            FormFieldDataText(
              label: "Gmail",
              hintText: "VD: email@gmail.com",
              controller: _gmailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => (value == null || value.isEmpty) ? "Vui lòng nhập gmail" : null,
            ),
            
            // 3. Mật khẩu
            FormFieldDataText(
              label: staff == null ? "Mật khẩu" : "Mật khẩu mới (Bỏ trống nếu không đổi)",
              hintText: "******",
              controller: _passController,
              keyboardType: TextInputType.visiblePassword,
              validator: (value) => (staff == null && (value == null || value.isEmpty)) 
                ? "Vui lòng nhập mật khẩu" 
                : null,
            ),
            
            // 4. Vai trò (Dropdown)
            // SỬA: Ép kiểu <dynamic> để khớp với `modal_app.dart`
            FormFieldDataDropDown<dynamic>(
              label: "Vai trò",
              hintText: "Chọn vai trò",
              stream: roleStream as Stream<List<dynamic>>, // SỬA: ép kiểu stream
              selectedValue: _selectedRoleName, 
              onChanged: (value) {
                // SỬA: Cập nhật `_selectedRoleName`
                _selectedRoleName = value.toString();
              },
              validator: (value) {
                // SỬA: Cập nhật `_selectedRoleName` TRƯỚC KHI validate
                _selectedRoleName = value?.toString();
                return (value == null) ? "Vui lòng chọn vai trò" : null;
              }
            ),
          ],
          
          onSubmit: () async {
            _saveAccount(staff: staff);
          },
        );
      },
    );
  }
}