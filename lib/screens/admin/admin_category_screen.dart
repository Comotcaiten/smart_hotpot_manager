import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/category.dart';
import 'package:smart_hotpot_manager/services/auth_service.dart';
import 'package:smart_hotpot_manager/services/category_service.dart';
import 'package:smart_hotpot_manager/widgets/section_custom.dart';
import 'package:smart_hotpot_manager/widgets/table_widget.dart';
import 'package:smart_hotpot_manager/widgets/modal_app.dart';

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Services
  final _authService = AuthService();
  final CategoryService categoryService = CategoryService();

  Future<void> _saveCategory({Category? category}) async {
    final res = await _authService.getAccout();

    if (category == null) {
      // Thêm mới
      final category = Category(
        restaurantId: res!.restaurantId,
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

    String notification = category == null
        ? "Thêm danh mục thành công!"
        : "Chỉnh sửa thành công";

    Navigator.pop(context); // đóng modal

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(notification), backgroundColor: Colors.green),
    );
  }

  Future<void> _deleteCategory({Category? category}) async {
    String notification;

    if (category == null) {
      notification = "Không thể xóa danh mục";
    } else {
      await categoryService.deleteCategory(category.id);

      notification = "Xóa thành công danh mục ${category.id}";
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
            title: "Quản lý Danh mục",
            subtitle: "Thêm, sửa, xóa danh mục món ăn",
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

          _buildCategoryViews(),
        ],
      ),
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
          FormFieldDataText(
            label: "Tên danh mục",
            hintText: "VD: Nước lẩu",
            controller: _nameController,
          ),
          FormFieldDataText(
            label: "Mô tả",
            hintText: "VD: Các loại nước lẩu đặc biệt",
            controller: _descriptionController,
          ),
        ],
        onSubmit: () async {
          _saveCategory(category: category);
        },
      ),
    );
  }

  Widget _buildCategoryViews() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        return FutureBuilder(
          future: _authService.getAccout(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
              return const Center(child: Text('Không tìm thấy nhà hàng.'));
            }

            final restaurantId = asyncSnapshot.data!.restaurantId;
            return StreamBuilder<List<Category>>(

              stream: categoryService.getAllCategories(restaurantId),
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
                    child: Center(child: Text("Chưa có danh mục nào được thêm.")),
                  );
                }
            
                final categories = snapshot.data!;
            
                // Nếu màn hình rộng (>=1280px) → hiển thị bảng
                if (isWide) {
                  return BaseTable(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(6),
                      2: FlexColumnWidth(4),
                    },
                    buildHeaderRow: const TableRow(
                      children: [
                        HeaderCellWidgetText(content: "Tên danh mục"),
                        HeaderCellWidgetText(content: "Mô tả"),
                        HeaderCellWidgetText(
                          content: "Thao tác",
                          align: TextAlign.center,
                        ),
                      ],
                    ),
                    buildDataRow: categories.map((cat) {
                      return TableRow(
                        children: [
                          DataCellWidgetText(content: cat.name),
                          DataCellWidgetText(content: cat.description),
                          DataCellWidgetAction(
                            editAction: () => _openAddCategoryModal(category: cat),
                            deleteAction: () => _deleteCategory(category: cat),
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
                          'name':'Tên:',
                          'description': 'Mô tả:'
                        }, 
                        contents: cat.toMap(),
                        editAction: () => _openAddCategoryModal(category: cat),
                        deleteAction: () => _deleteCategory(category: cat),
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

