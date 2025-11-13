// // lib/screens/admin/admin_table_screen.dart

// import 'package:flutter/material.dart';
// // Sửa imports
// import 'package:smart_hotpot_manager/models/table.dart';
// import 'package:smart_hotpot_manager/services/table_service.dart';
// // Giữ lại các widget UI
// import 'package:smart_hotpot_manager/widgets/app_icon.dart';
// import 'package:smart_hotpot_manager/widgets/section_custom.dart';
// import 'package:smart_hotpot_manager/widgets/table_widget.dart';

// class AdminTableScreen extends StatefulWidget {
//   const AdminTableScreen({super.key});

//   @override
//   State<StatefulWidget> createState() => _AdminTableScreenState();
// }

// class _AdminTableScreenState extends State<AdminTableScreen> {
//   // Sửa Service
//   final TableService _tableService = TableService();

//   // Sửa Controllers cho Bàn
//   final _nameController = TextEditingController();
//   final _passController = TextEditingController();
//   StatusTable _selectedStatus = StatusTable.empty; // Biến trạng thái cho modal

//   Future<void> _saveTable({TableModel? table}) async {
//     // Validate
//     if (_nameController.text.isEmpty || _passController.text.isEmpty) {
//        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text("Vui lòng điền đầy đủ Tên bàn và Mật khẩu"),
//         backgroundColor: Colors.red,
//       ));
//       return;
//     }

//     final now = DateTime.now();

//     if (table == null) {
//       // Thêm mới
//       final newTable = TableModel(
//         restaurantId: "R001",
//         id: "", // id sẽ được gán tự động
//         name: _nameController.text.trim(),
//         pass: _passController.text.trim(),
//         status: _selectedStatus,
//         createAt: now,
//         updateAt: now,
//       );
//       await _tableService.addTable(newTable); // Sửa hàm
//     } else {
//       // Cập nhật
//       await _tableService.updateTable( // Sửa hàm
//         TableModel(
//           restaurantId: table.restaurantId,
//           id: table.id,
//           name: _nameController.text.trim(),
//           pass: _passController.text.trim(),
//           status: _selectedStatus,
//           createAt: table.createAt, // Giữ ngày tạo
//           updateAt: now, // Cập nhật
//         ),
//       );
//     }

//     if (!mounted) return;

//     _nameController.clear();
//     _passController.clear();

//     String notification =
//         table == null ? "Thêm bàn thành công!" : "Chỉnh sửa thành công";

//     Navigator.pop(context); // đóng modal

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(
//       content: Text(notification),
//       backgroundColor: Colors.green,
//     ));
//   }

//   Future<void> _deleteTable({TableModel? table}) async { // Sửa
//     String notification;

//     if (table == null) {
//       notification = "Không thể xóa bàn";
//     } else {
//       await _tableService.deleteTable(table.id); // Sửa
//       notification = "Xóa thành công ${table.name}"; // Sửa
//     }

//     if (!mounted) return;

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(
//       content: Text(notification),
//       backgroundColor: Colors.red,
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildMainLayout();
//   }

//   Widget _buildMainLayout() {
//     return Container(
//       margin: const EdgeInsets.all(24),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SectionHeaderIconLead(
//             title: "Quản lý Bàn", // Sửa
//             subtitle: "Thêm, sửa, xóa bàn và trạng thái", // Sửa
//             icon: AppIcon(
//               size: 46,
//               icon: Icons.table_restaurant_rounded, // Sửa
//               colors: [Colors.purple, Colors.black], // Sửa
//             ),
//           ),
//           const SizedBox(height: 16),
//           Align(
//             alignment: Alignment.centerRight,
//             child: ElevatedButton.icon(
//               icon: const Icon(Icons.add, size: 18),
//               label: const Text("Thêm bàn mới"), // Sửa
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: () {
//                 _openAddTableModal(); // Sửa
//               },
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildTable(), // Sửa
//         ],
//       ),
//     );
//   }

//   // Xây dựng bảng Bàn
//   Widget _buildTable() { // Sửa
//     return StreamBuilder<List<TableModel>>( // Sửa
//       stream: _tableService.getAllTables(), // Sửa
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Padding(
//             padding: EdgeInsets.all(16),
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (snapshot.hasError) {
//            return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Center(child: Text("Lỗi tải dữ liệu bàn: ${snapshot.error}")),
//           );
//         }

//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Padding(
//             padding: EdgeInsets.all(16),
//             child: Center(child: Text("Chưa có bàn nào được thêm.")), // Sửa
//           );
//         }

//         final tables = snapshot.data!; // Sửa

//         return BaseTable(
//           columnWidths: const { // Sửa (Tên, Pass, Trạng thái, Thao tác)
//             0: FlexColumnWidth(2),
//             1: FlexColumnWidth(2),
//             2: FlexColumnWidth(2),
//             3: FlexColumnWidth(1.5),
//           },
//           buildHeaderRow: const TableRow(
//             children: [ // Sửa
//               HeaderCellWidgetText(content: "Tên bàn"),
//               HeaderCellWidgetText(content: "Mật khẩu"),
//               HeaderCellWidgetText(content: "Trạng thái", align: TextAlign.left),
//               HeaderCellWidgetText(
//                 content: "Thao tác",
//                 align: TextAlign.center,
//               ),
//             ],
//           ),
//           buildDataRow: tables.map((table) { // Sửa
//             return TableRow(
//               children: [
//                 DataCellWidgetText(content: table.name), // Sửa
//                 DataCellWidgetText(content: table.pass), // Sửa
//                 // Dùng Badge để hiển thị trạng thái
//                 DataCellWidgetBadge(
//                   option_1: "Trống", 
//                   option_2: "Có khách",
//                   // Trống thì màu đen (inStock=true), ngược lại màu đỏ
//                   inStock: table.status == StatusTable.empty,
//                 ),
//                 DataCellWidgetAction(
//                   editAction: () async {
//                     _openAddTableModal(table: table); // Sửa
//                   },
//                   deleteAction: () async {
//                     _deleteTable(table: table); // Sửa
//                   },
//                 ),
//               ],
//             );
//           }).toList(),
//         );
//       },
//     );
//   }

//   // Modal (popup) để thêm/sửa Bàn
//   void _openAddTableModal({TableModel? table}) {
//     // Đặt giá trị ban đầu cho modal
//     _nameController.text = table?.name ?? '';
//     _passController.text = table?.pass ?? '';
//     _selectedStatus = table?.status ?? StatusTable.empty;

//     final formKey = GlobalKey<FormState>();

//     showDialog(
//       context: context,
//       builder: (context) {
//         // Dùng StatefulBuilder để Dropdown có thể cập nhật trạng thái riêng
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return AlertDialog(
//               title: Text(table == null ? "Thêm bàn mới" : "Chỉnh sửa bàn"),
//               content: Form(
//                 key: formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // 1. Tên bàn
//                       TextFormField(
//                         controller: _nameController,
//                         decoration: const InputDecoration(
//                           labelText: "Tên bàn",
//                           hintText: "VD: Bàn 1",
//                         ),
//                         validator: (value) =>
//                             value!.isEmpty ? "Không được để trống" : null,
//                       ),
//                       const SizedBox(height: 16),
                      
//                       // 2. Mật khẩu
//                       TextFormField(
//                         controller: _passController,
//                         decoration: const InputDecoration(
//                           labelText: "Mật khẩu (cho nhân viên)",
//                           hintText: "VD: 123456",
//                         ),
//                         validator: (value) =>
//                             value!.isEmpty ? "Không được để trống" : null,
//                       ),
//                       const SizedBox(height: 16),

//                       // 3. Dropdown Trạng thái
//                       DropdownButtonFormField<StatusTable>(
//                         value: _selectedStatus,
//                         decoration: const InputDecoration(
//                           labelText: "Trạng thái ban đầu",
//                         ),
//                         // Lấy tất cả giá trị từ enum StatusTable
//                         items: StatusTable.values.map((StatusTable status) {
//                           String text;
//                           switch (status) {
//                             case StatusTable.empty:
//                               text = "Trống";
//                               break;
//                             case StatusTable.inUse:
//                               text = "Đang sử dụng";
//                               break;
//                             case StatusTable.set:
//                               text = "Đã đặt";
//                               break;
//                           }
//                           return DropdownMenuItem<StatusTable>(
//                             value: status,
//                             child: Text(text),
//                           );
//                         }).toList(),
//                         onChanged: (StatusTable? newValue) {
//                           setModalState(() {
//                             if (newValue != null) {
//                               _selectedStatus = newValue;
//                             }
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
// actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("Hủy"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (formKey.currentState!.validate()) {
//                       _saveTable(table: table); // Sửa
//                     }
//                   },
//                   child: const Text("Lưu"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }