// lib/screens/admin/admin_account_screen.dart

import 'package:flutter/material.dart';
// Sửa imports
import 'package:smart_hotpot_manager/models/staff.dart';
import 'package:smart_hotpot_manager/models/restaurant.dart';
import 'package:smart_hotpot_manager/services/account_service.dart';
// Giữ lại các widget UI
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/section_custom.dart';
import 'package:smart_hotpot_manager/widgets/table_widget.dart';
// SỬA: Import ModalForm
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
      (e) => e.name == _selectedRoleName,
      orElse: () => RoleAccount.staff, // Mặc định là staff
    );

    final now = DateTime.now();
    
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
        role: role,
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
                ? _passController.text.trim() // Cập nhật pass mới (nếu có)
                : staff.pass, // Giữ pass cũ (nếu trống)
          role: role,
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
            title: "Quản lý Tài khoản", // Sửa
            subtitle: "Thêm, sửa, xóa tài khoản nhân viên", // Sửa
            icon: AppIcon(
              size: 46,
              icon: Icons.people_alt_rounded, // Sửa
              colors: [Colors.teal, Colors.black], // Sửa
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Thêm tài khoản"), // Sửa
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _openAddAccountModal(); // Sửa
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildAccountTable()
        ],
      ),
    );
  }

  // Xây dựng bảng Tài khoản
  Widget _buildAccountTable() { // Sửa
    return StreamBuilder<List<Staff>>( // Sửa
      stream: _accountService.getAllAccounts(), // Sửa
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
            child: Center(child: Text("Chưa có tài khoản nào.")), // Sửa
          );
        }

        final accounts = snapshot.data!; // Sửa

        return BaseTable(
          columnWidths: const { // Sửa (Tên, Gmail, Vai trò, Thao tác)
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(1.5),
            3: FlexColumnWidth(1.5),
          },
          buildHeaderRow: const TableRow(
            children: [ // Sửa
              HeaderCellWidgetText(content: "Tên"),
              HeaderCellWidgetText(content: "Gmail"),
              HeaderCellWidgetText(content: "Vai trò", align: TextAlign.left),
              HeaderCellWidgetText(
                content: "Thao tác",
                align: TextAlign.center,
              ),
            ],
          ),
          buildDataRow: accounts.map((account) { // Sửa
            return TableRow(
              children: [
                DataCellWidgetText(content: account.name), // Sửa
                DataCellWidgetText(content: account.gmail), // Sửa
                DataCellWidgetBadge(
                  option_1: "Admin", 
                  option_2: "Staff",
                  // Admin thì màu đen (inStock=true)
                  inStock: account.role == RoleAccount.admin,
                ),
                DataCellWidgetAction(
                  editAction: () async {
                    _openAddAccountModal(staff: account); // Sửa
                  },
                  deleteAction: () async {
                    _deleteAccount(staff: account); // Sửa
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
    _passController.text = ''; // Mật khẩu luôn trống khi sửa
    _selectedRoleName = staff?.role.name; 

    // Tạo danh sách các lựa chọn vai trò
    final roleOptions = [
      _RoleDisplay(RoleAccount.admin, "Admin"),
      _RoleDisplay(RoleAccount.staff, "Staff"),
    ];
    
    // Tạo 1 stream từ danh sách tĩnh
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
              // Chỉ bắt buộc khi tạo mới
              validator: (value) => (staff == null && (value == null || value.isEmpty)) 
                ? "Vui lòng nhập mật khẩu" 
                : null,
            ),
            
            // 4. Vai trò (Dropdown)
            FormFieldDataDropDown(
              label: "Vai trò",
              hintText: "Chọn vai trò",
              stream: roleStream, 
              selectedValue: _selectedRoleName, 
              onChanged: (value) {
                _selectedRoleName = value.toString();
              },
              validator: (value) => (value == null) ? "Vui lòng chọn vai trò" : null,
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