import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/category.dart';
import 'package:smart_hotpot_manager/services/category_service.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/section.dart';
import 'package:smart_hotpot_manager/widgets/title_app_bar.dart';

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {

  // fire store

  final CategoryService firestoreService = CategoryService();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _openAddCategory() {
    _showDialogBuilder(context);
  }

Future<void> _saveCategory() async {
  final category = Category(
    restaurantId: "R001",
    id: "", // id sẽ được gán tự động trong Firestore
    name: _nameController.text.trim(),
    description: _descriptionController.text.trim(),
    delete: false,
  );

  await firestoreService.addCategory(category);

  _nameController.clear();
  _descriptionController.clear();
  
  if (!mounted) return;

  Navigator.pop(context); // đóng modal

  // ScaffoldMessenger.of(context).showSnackBar(
  //   const SnackBar(content: Text("Thêm danh mục thành công!")),
  // );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        title: "Admin Category Dashboard",
        subtitle: "subtitle",
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(32),
            child: _buildMainLayout(),
          ),
        ),
      ),
    );
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
            title: "Quản lý Menu",
            subtitle: "Thêm, sửa, xóa món ăn",
            icon: AppIcon(
              size: 46,
              icon: Icons.food_bank_rounded,
              colors: [Colors.blue, Colors.black],
            ),
          ),
          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Thêm món mới"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _openAddCategory,
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _showDialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Thêm danh mục"),
            IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))
          ],
        ),
        content: Container(
          width: 500,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tên danh mục", style: TextStyle()),
              SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  // labelText: 'Tên danh mục',
                  hintText: "VD: Nước lẩu",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              Text("Mô tả"),
              SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  // labelText: 'Mô tả',
                  hintText: "VD: Các loại nước lẩu đặc biệt",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              // Xử lý lưu dữ liệu
              _saveCategory();

              print("Press Add");
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.black),
            ),
            child: const Text("Thêm danh mục", style: TextStyle(color: Colors.white, fontSize: 16),),
          ),
        ],
      ),
    );
  }
}
