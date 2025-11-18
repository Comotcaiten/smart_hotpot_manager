import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/product.dart';
import 'package:smart_hotpot_manager/services/auth_service.dart';
import 'package:smart_hotpot_manager/services/category_service.dart';
import 'package:smart_hotpot_manager/services/product_service.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/modal_app.dart';
import 'package:smart_hotpot_manager/widgets/section_custom.dart';
import 'package:smart_hotpot_manager/widgets/table_widget.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  // Service
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  final _authService = AuthService();

  // Controllers
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageLinkController = TextEditingController();
  String? _selectedCategoryId;

  // Map để tra cứu tên Category
  Map<String, String> _categoryNameMap = {};

  @override
  void initState() {
    super.initState();
    _loadCategoryNames();
  }

  // Tải danh sách category 1 lần để tra cứu
  Future<void> _loadCategoryNames() async {
    final res = await _authService.getAccout();
    final categories = await _categoryService
        .getAllCategories(res!.restaurantId)
        .first;
    setState(() {
      _categoryNameMap = {for (var cat in categories) cat.id: cat.name};
    });
  }

  Future<void> _saveProduct({Product? product}) async {
    // Validate
    final res = await _authService.getAccout();

    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _imageLinkController.text.isEmpty ||
        _selectedCategoryId == null) {
      print(
        "${_nameController.text} , ${_priceController.text} , ${_imageLinkController.text} , ${_selectedCategoryId.toString()}",
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng điền đầy đủ thông tin (Tên, Giá, Danh mục)"),
          backgroundColor: Colors.red,
        ),
      );

      Navigator.pop(context);
      return;
    }

    final now = DateTime.now();

    if (product == null) {
      // Thêm mới
      final newProduct = Product(
        restaurantId: res!.restaurantId,
        id: "",
        name: _nameController.text.trim(),
        price: int.tryParse(_priceController.text.trim()) ?? 0,
        categoryId: _selectedCategoryId!,
        delete: false,
        imageUrl: _imageLinkController.text.trim(),
        createAt: now,
        updateAt: now,
      );

      await _productService.addProduct(newProduct);
    } else {
      // Cập nhật
      await _productService.updateProduct(
        Product(
          restaurantId: product.restaurantId,
          id: product.id,
          name: _nameController.text.trim(),
          price: int.tryParse(_priceController.text.trim()) ?? 0,
          categoryId: _selectedCategoryId!,
          delete: product.delete,
          imageUrl: _imageLinkController.text.trim(),
          createAt: product.createAt,
          updateAt: now,
        ),
      );
    }

    if (!mounted) return;

    _nameController.clear();
    _priceController.clear();
    _imageLinkController.clear();
    _selectedCategoryId = null;

    String notification = product == null
        ? "Thêm sản phẩm thành công!"
        : "Chỉnh sửa thành công";

    Navigator.pop(context); // đóng modal

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(notification), backgroundColor: Colors.green),
    );
  }

  Future<void> _deleteProduct({Product? product}) async {
    String notification;

    if (product == null) {
      notification = "Không thể xóa sản phẩm";
    } else {
      await _productService.deleteProduct(product.id);
      notification = "Xóa thành công sản phẩm ${product.name}";
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
    return FutureBuilder(
      future: _authService.getAccout(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
          return const Center(child: Text('Không tìm thấy nhà hàng.'));
        }

        final restaurantId = asyncSnapshot.data!;
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
                title: "Quản lý Sản phẩm",
                subtitle: "Thêm, sửa, xóa món ăn",
                icon: AppIcon(
                  size: 46,
                  icon: Icons.restaurant_menu,
                  colors: [Colors.green, Colors.black],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Thêm sản phẩm"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _openAddProductModal(
                      restaurantId: restaurantId.restaurantId,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildProductTable(restaurantId: restaurantId.restaurantId),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductTable({required String restaurantId}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        return StreamBuilder<List<Product>>(
          stream: _productService.getAllProducts(restaurantId),
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
                child: Center(
                  child: Text("Lỗi tải sản phẩm: ${snapshot.error}"),
                ),
              );
            }
            // ---------------

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text("Chưa có sản phẩm nào được thêm.")),
              );
            }

            final products = snapshot.data!;

            // Nếu màn hình rộng (>=1280px) → hiển thị bảng
            if (isWide) {
              return BaseTable(
                columnWidths: const {
                  0: FlexColumnWidth(3), // Tên
                  1: FlexColumnWidth(2), // Giá
                  2: FlexColumnWidth(2), // Danh mục
                  3: FlexColumnWidth(2), // Trạng thái
                  4: FlexColumnWidth(1.5), // Thao tác
                },
                buildHeaderRow: const TableRow(
                  children: [
                    HeaderCellWidgetText(content: "Tên sản phẩm"),
                    HeaderCellWidgetText(content: "Giá"),
                    HeaderCellWidgetText(content: "Danh mục"),
                    HeaderCellWidgetText(
                      content: "Trạng thái",
                      align: TextAlign.left,
                    ),
                    HeaderCellWidgetText(
                      content: "Thao tác",
                      align: TextAlign.center,
                    ),
                  ],
                ),
                buildDataRow: products.map((prod) {
                  // Lấy tên danh mục từ Map đã tải
                  final categoryName =
                      _categoryNameMap[prod.categoryId] ?? "Không rõ";

                  return TableRow(
                    children: [
                      DataCellWidgetText(content: prod.name),
                      DataCellWidgetText(content: "${prod.price} VNĐ"),
                      DataCellWidgetText(content: categoryName),
                      DataCellWidgetBadge(
                        statusKey: !prod.delete ? "show" : "hide",
                        options: {
                          "show": BadgeColorData(text: "Hiển thị", color: Colors.green),
                          "hide": BadgeColorData(text: "Ẩn", color: Colors.redAccent),
                        },
                      ),

                      DataCellWidgetAction(
                        editAction: () async {
                          _openAddProductModal(
                            product: prod,
                            restaurantId: restaurantId,
                          );
                        },
                        deleteAction: () async {
                          _deleteProduct(product: prod);
                        },
                      ),
                    ],
                  );
                }).toList(),
              );
            } else {
              return Column(
                children: products.map((cat) {
                  return ModelInfoSection(
                    titles: {'name': 'Tên:', 'price': 'Giá:'},
                    contents: cat.toMap(),
                    editAction: () async {
                      _openAddProductModal(
                        product: cat,
                        restaurantId: restaurantId,
                      );
                    },
                    deleteAction: () async {
                      _deleteProduct(product: cat);
                    },
                  );
                }).toList(),
              );
            }
          },
        );
      },
    );
  }

  // Modal để thêm/sửa sản phẩm
  void _openAddProductModal({Product? product, required String restaurantId}) {
    // Đặt giá trị ban đầu cho modal
    _nameController.text = product?.name ?? '';
    _priceController.text = product?.price.toString() ?? '';
    _imageLinkController.text = product?.imageUrl ?? '';
    _selectedCategoryId = product?.categoryId;

    showDialog(
      context: context,
      builder: (context) => ModalForm(
        title: product == null ? "Thêm sản phẩm" : "Sủa sản phẩm",
        fields: [
          FormFieldDataText(
            label: "Tên sản phẩm",
            hintText: "VD: Lẩu Thái",
            controller: _nameController,
            validator: (value) => value!.isEmpty ? "Không được để trống" : null,
          ),

          FormFieldDataText(
            label: "Link hình ảnh",
            hintText: "VD: https://example.com/image.jpg",
            controller: _imageLinkController,
            validator: (value) => value!.isEmpty ? "Không được để trống" : null,
          ),
          FormFieldDataText(
            label: "Giá tiền",
            hintText: "VD: 50000",
            controller: _priceController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Không được để trống";
              }
              if (int.tryParse(value) == null) {
                return "Phải là một con số";
              }
              if (int.parse(value) < 0) {
                return "Phải lớn hơn hoặc bằng 0";
              }
              return null;
            },
          ),
          FormFieldDataDropDown(
            label: "Danh mục",
            hintText: "Chọn danh mục",
            stream: _categoryService.getAllCategories(restaurantId),
            selectedValue: _selectedCategoryId,
            onChanged: (value) => {_selectedCategoryId = value.toString()},
            validator: (value) =>
                value == null ? "Vui lòng chọn danh mục" : null,
          ),
        ],
        onSubmit: () async {
          _saveProduct(product: product);
        },
      ),
    );
  }
}
