import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/account.dart';
import 'package:smart_hotpot_manager/services/auth_service.dart';
import 'package:smart_hotpot_manager/utils/utils.dart';
import 'package:smart_hotpot_manager/widgets/modal_app.dart';
import 'package:smart_hotpot_manager/widgets/section_custom.dart';
import 'package:smart_hotpot_manager/widgets/table_widget.dart';

class AdminAccountcreen extends StatefulWidget {
  const AdminAccountcreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminAccountcreenState();
}

class _AdminAccountcreenState extends State<AdminAccountcreen> {

  // Controller
  final _nameController = TextEditingController();
  final _gmailController = TextEditingController();
  final _passContoller = TextEditingController();
  String? _selectedRole;

  // Services
  final _authService = AuthService();

  Future<void> _saveStaff({Account? account, String? oldPass}) async {
    final roleEnum = RoleAccount.values.firstWhere(
      (role) => role.name == _selectedRole,
      orElse: () => RoleAccount.staff, // giá trị mặc định nếu không khớp
    );

    if (account == null) {
      // Thêm mới

      final data = Account(
        restaurantId: "restaurantId", 
        id: "id", 
        name: _nameController.text.trim(), 
        gmail: _gmailController.text.trim(), 
        pass: _passContoller.text.trim(),
        role: roleEnum);

      await _authService.registerStaff(data);
    }
    else {
      // Cập nhập
      await _authService.updateStaffAccount(oldPass: oldPass!, newStaff: Account(
        restaurantId: account.restaurantId, 
        id: account.id, 
        name: _nameController.text.trim(), 
        gmail: account.gmail, 
        pass: _passContoller.text.trim(),
        role: roleEnum,
        ),
      );
    }

    _nameController.clear();
    _gmailController.clear();
    _passContoller.clear();

    String notification = account == null
        ? "Thêm danh mục thành công!"
        : "Chỉnh sửa thành công";
    Navigator.pop(context); // đóng modal

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(notification), backgroundColor: Colors.green),
    );

  }

  Future<void> _deleteAccount({Account? account}) async {
    String notification;

    if (account == null) {
      notification = "Không thể xóa danh mục";
    } else {
      await _authService.deleteStaffAccount(account);

      notification = "Xóa thành công staff ${account.id}";
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(notification), backgroundColor: Colors.red),
    );
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderIconLead(
            title: "Quản lý staff",
            subtitle: "Thêm, sửa, xóa staff",
          ),
          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Thêm staff"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {_openSaveModal();},
            ),
          ),

          const SizedBox(height: 16),

          _buildViews(),
        ],
      ),
    );
  }


  void _openSaveModal({Account? account}) {

    _nameController.text = account?.name ?? "";
    _gmailController.text = account?.gmail ?? "";
    _passContoller.text = account?.pass ?? "";

    final oldPass = _passContoller.text;
    
    _selectedRole = account?.role.name.toString();

    showDialog(
      context: context,
      builder: (context) => ModalForm(
        title: account == null ? "Thêm account" : "Chỉnh sửa account",
        fields: [

          if(account != null) ...[
            FormFieldDataText(
              controller: TextEditingController(),
              label: "Mã nhân viên",
              hintText: account.id.toString(),
              disable: true,
            ),
          ],

          FormFieldDataText(
            label: "Tên",
            hintText: "VD: Nguyễn Văn A",
            controller: _nameController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Vui lòng nhập tên";
              }
              if (!RegexPattern.nameRegex.hasMatch(value.trim())) {
                return "Định dạng tên không hợp lệ";
              }
              return null;
            },
          ),
          FormFieldDataText(
            label: "Gamil",
            hintText: "VD: nguyenvana@gmail.com",
            controller: _gmailController,
            keyboardType: TextInputType.emailAddress,
            disable: account != null, 
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Vui lòng nhập Gmail";
              }
              if (!RegexPattern.emailRegex.hasMatch(value.trim())) {
                return "Định dạng Gmail không hợp lệ";
              }
              return null;
            },
          ),
          FormFieldDataText(
            label: "Password",
            hintText: "VD: 1234567890",
            controller: _passContoller,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Vui lòng nhập mật khẩu";
              }
              if (value.length < 8) {
                return "Mật khẩu phải có ít nhất 8 ký tự";
              }
              return null;
            },
          ),
          FormFieldDataDropDown(
            label: "Vai trò",
            hintText: "Chọn vai trò",
            stream: _authService.roleNamesStream,
            selectedValue: _selectedRole,
            onChanged: (value) => {
              _selectedRole = value.toString(),
            },
            validator: (value) => value == null ? "Vui lòng chọn danh mục" : null,
          ),
        ],
        onSubmit: () async {_saveStaff(account: account, oldPass: oldPass);},
      ),
    );
  }

  Widget _buildViews() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        return FutureBuilder<String>(
          future: _authService.getIdRestaurant(),
          builder: (context, asyncSnapshot) {

            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
              return const Center(child: Text('Không tìm thấy nhà hàng.'));
            }

            final restaurantId = asyncSnapshot.data!;

            return StreamBuilder<List<Account>>(
              stream: _authService.getAllStaffsByRestaurant(restaurantId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
            
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text("Chưa có tài khoản nào được thêm.")),
                  );
                }
            
                final categories = snapshot.data!;
            
                // Nếu màn hình rộng (>=1280px) → hiển thị bảng
                if (isWide) {
                  return BaseTable(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(6),
                      3: FlexColumnWidth(4),
                      4: FlexColumnWidth(2),
                      5: FlexColumnWidth(4),
                    },
                    buildHeaderRow: const TableRow(
                      children: [
                        HeaderCellWidgetText(content: "ID:"),
                        HeaderCellWidgetText(content: "Tên"),
                        HeaderCellWidgetText(content: "Gmail"),
                        HeaderCellWidgetText(content: "Role"),
                        HeaderCellWidgetText(
                          content: "Thao tác",
                          align: TextAlign.center,
                        ),
                      ],
                    ),
                    buildDataRow: categories.map((cat) {
                      return TableRow(
                        children: [
                          DataCellWidgetText(content: cat.id),
                          DataCellWidgetText(content: cat.name),
                          DataCellWidgetText(content: cat.gmail),
                          DataCellWidgetText(content: cat.role.name),
                          DataCellWidgetAction(
                            editAction: () => _openSaveModal(account: cat),
                            deleteAction: () => _deleteAccount(account: cat),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                } else {
                  return Column(
                    children: categories.map((cat) {
                      return ModelInfoSection(
                        titles: {
                          'id':'Mã nhân viên:',
                          'name':'Tên:',
                          'gmail': 'Gmail:',
                          'role': "Role"
                        }, 
                        contents: cat.toMap(),
                        editAction: () => _openSaveModal(account: cat),
                        deleteAction: () => _deleteAccount(account: cat),
                      );
                   }).toList(),
                  );
                }
              },
            );
          }
        );
      },
    );
  }

}
