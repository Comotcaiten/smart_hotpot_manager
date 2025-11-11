import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/category.dart';
import 'package:smart_hotpot_manager/services/category_service.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/section_custom.dart';
import 'package:smart_hotpot_manager/widgets/table_widget.dart';
import 'package:smart_hotpot_manager/widgets/title_app_bar.dart';
import 'package:smart_hotpot_manager/widgets/modal_app.dart';

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
  // fire store

  final CategoryService categoryService = CategoryService();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _saveCategory({Category? category}) async {

    if (category == null) {
      // Thêm mới
      final category = Category(
        restaurantId: "R001",
        id: "", // id sẽ được gán tự động trong Firestore
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        delete: false,
      );

      await categoryService.addCategory(category);

    } else {
      // Cập nhật
      await categoryService.updateCategory(
        Category(
          restaurantId: category.restaurantId,
          id: category.id,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          delete: category.delete,
        ),
      );
    }

    if (!mounted) return;

    _nameController.clear();
    _descriptionController.clear();

    Navigator.pop(context); // đóng modal

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Thêm danh mục thành công!")));
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
              onPressed: () {
                _openAddCategoryModal();
              },
            ),
          ),

          const SizedBox(height: 16),

          _buildCategoryTable(),
        ],
      ),
    );
  }

  Widget _buildCategoryTable() {
    return StreamBuilder<List<Category>>(
      stream: categoryService.getAllCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Text("Chưa có danh mục nào được thêm.")),
          );
        }

        final categories = snapshot.data!;

        return BaseTable(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(8),
            2: FlexColumnWidth(2),
          },
          buildHeaderRow: const TableRow(
            children: [
              HeaderCellWidgetText(content: "Tên danh mục"),
              HeaderCellWidgetText(content: "Mô tả"),
              // HeaderCellWidget(content: "Trạng thái", align: TextAlign.center),
              HeaderCellWidgetText(
                content: "Thao tác",
                align: TextAlign.center,
              ),
            ],
          ),
          buildDataRow: categories.map((cat) {
            return TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade50),
              children: [
                DataCellWidgetText(content: cat.name),
                DataCellWidgetText(content: cat.description),
                // DataCellWidget(
                //   content: cat.delete ? "Ẩn" : "Hiển thị",
                // ),
                DataCellWidgetAction(
                  editAction: () async {
                    _openAddCategoryModal(category: cat);
                  },
                  deleteAction: () async {
                    categoryService.deleteCategory(cat.id);
                  },
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  void _openAddCategoryModal({Category? category}) {
    _nameController.text = category?.name ?? '';
    _descriptionController.text = category?.description ?? '';
    showDialog(
      context: context,
      builder: (context) => ModalForm(
        title: category == null ? "Thêm danh mục" : "Chỉnh sửa danh mục",
        fields: [
          FormFieldData(
            label: "Tên danh mục",
            hintText: "VD: Nước lẩu",
            controller: _nameController,
          ),
          FormFieldData(
            label: "Mô tả",
            hintText: "VD: Các loại nước lẩu đặc biệt",
            controller: _descriptionController,
            isRequired: false,
          ),
        ],  
        onSubmit: () async {_saveCategory(category: category);},
      ),
    );
  }
}
