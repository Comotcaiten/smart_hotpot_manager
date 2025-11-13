import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/staff.dart';
import 'package:smart_hotpot_manager/services/staff_services.dart';
import 'package:smart_hotpot_manager/utils/utils.dart';
import 'package:smart_hotpot_manager/widgets/modal_app.dart';
import 'package:smart_hotpot_manager/widgets/section_custom.dart';
import 'package:smart_hotpot_manager/widgets/table_widget.dart';

class AdminStaffScreen extends StatefulWidget {
  const AdminStaffScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminStaffScreenState();
}

class _AdminStaffScreenState extends State<AdminStaffScreen> {
  final StaffService _staffService = StaffService();

  final _nameController = TextEditingController();
  final _gmailController = TextEditingController();
  final _passContoller = TextEditingController();

  Future<String> setIdRestaurant() async {
    String? restaurantId = await _staffService.getIdRestaurant();
    return restaurantId;
  }

  Future<void> _saveStaff({Staff? staff, String? oldPass}) async {
    if (staff == null) {
      // Thêm mới
      final data = Staff(
        restaurantId: "restaurantId", 
        id: "id", 
        name: _nameController.text.trim(), 
        gmail: _gmailController.text.trim(), 
        pass: _passContoller.text.trim());

      await _staffService.addStaff(data);
    }
    else {
      // Cập nhập
      await _staffService.updateStaff(oldPass!, Staff(
        restaurantId: staff.restaurantId, 
        id: staff.id, 
        name: _nameController.text.trim(), 
        gmail: staff.gmail, 
        pass: _passContoller.text.trim()));
    }

    _notification(staff);

  }

  Future<void> _deleteStaff({Staff? staff}) async {
    String notification;

    if (staff == null) {
      notification = "Không thể xóa danh mục";
    } else {
      await _staffService.deleteStaff(staff);

      notification = "Xóa thành công staff ${staff.id}";
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(notification), backgroundColor: Colors.red),
    );
  }

  Future<void> _notification(Staff? staff) async {
    _nameController.clear();
    _gmailController.clear();
    _passContoller.clear();

    String notification = staff == null
        ? "Thêm danh mục thành công!"
        : "Chỉnh sửa thành công";
    Navigator.pop(context); // đóng modal

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(notification), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(Object context) {
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

  void _openSaveModal({Staff? staff}) {

    _nameController.text = staff?.name ?? "";
    _gmailController.text = staff?.gmail ?? "";
    _passContoller.text = staff?.pass ?? "";

    final oldPass = _passContoller.text;

    showDialog(
      context: context,
      builder: (context) => ModalForm(
        title: staff == null ? "Thêm staff" : "Chỉnh sửa staff",
        fields: [

          if(staff != null) ...[
            FormFieldDataText(
              controller: TextEditingController(),
              label: "Mã nhân viên",
              hintText: staff.id.toString(),
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
            disable: staff != null, 
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
        ],
        onSubmit: () async {_saveStaff(staff: staff, oldPass: oldPass);},
      ),
    );
  }

  Widget _buildViews() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        return FutureBuilder<String>(
          future: _staffService.getIdRestaurant(),
          builder: (context, asyncSnapshot) {

            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
              return const Center(child: Text('Không tìm thấy nhà hàng.'));
            }

            final restaurantId = asyncSnapshot.data!;

            return StreamBuilder<List<Staff>>(
              stream: _staffService.getAllStaffsByRestaurant(restaurantId),
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
                      4: FlexColumnWidth(4),
                    },
                    buildHeaderRow: const TableRow(
                      children: [
                        HeaderCellWidgetText(content: "ID:"),
                        HeaderCellWidgetText(content: "Tên"),
                        HeaderCellWidgetText(content: "Gmail"),
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
                          DataCellWidgetAction(
                            editAction: () => _openSaveModal(staff: cat),
                            deleteAction: () => {_deleteStaff(staff: cat)},
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
                          'gmail': 'Gmail:'
                        }, 
                        contents: cat.toMap(),
                        editAction: () => _openSaveModal(staff: cat),
                        deleteAction: () => {},
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
