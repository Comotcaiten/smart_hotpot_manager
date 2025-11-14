import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:smart_hotpot_manager/models/account.dart';
import 'package:smart_hotpot_manager/models/table.dart';
import 'package:smart_hotpot_manager/models/category.dart';
import 'package:smart_hotpot_manager/models/product.dart';
import 'package:smart_hotpot_manager/services/category_service.dart';
import 'package:smart_hotpot_manager/services/product_service.dart';
import 'package:smart_hotpot_manager/services/table_service.dart';
// import 'package:smart_hotpot_manager/providers/cart_provider.dart';
import 'package:smart_hotpot_manager/widgets/table_app_bar_actions.dart';
import 'package:smart_hotpot_manager/widgets/cart_widget.dart';
import 'package:smart_hotpot_manager/widgets/product_card.dart';

class MenuScreen extends StatefulWidget {
  final TableModel table;
  final Account account;
  const MenuScreen({super.key, required this.table, required this.account});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final CategoryService _categoryService = CategoryService();
  final ProductService _productService = ProductService();
  final TableService _tableService = TableService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedCategoryId = 'all';
  bool _isExiting = false;
  bool _orderHasBeenSent = false;

  final Map<String, IconData> iconMap = {
    'default': Icons.dining,
    'nuoc_lau': Icons.local_fire_department_outlined,
    'thit': Icons.kebab_dining,
    'hai_san': Icons.set_meal,
    'rau_cu': Icons.eco,
  };

  IconData _getIconFromName(String name) {
    if (name.toLowerCase().contains('lẩu')) return iconMap['nuoc_lau']!;
    if (name.toLowerCase().contains('thịt')) return iconMap['thit']!;
    if (name.toLowerCase().contains('hải sản')) return iconMap['hai_san']!;
    if (name.toLowerCase().contains('rau')) return iconMap['rau_cu']!;
    return iconMap['default']!;
  }

  @override
  void initState() {
    super.initState();
    _claimTable();
  }

  Future<void> _claimTable() async {
    TableModel updatedTable = TableModel(
      id: widget.table.id,
      restaurantId: widget.table.restaurantId,
      name: widget.table.name,
      seats: widget.table.seats,
      status: StatusTable.inUse,
    );
    try {
      await _tableService.updateTable(updatedTable);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Lỗi: Không thể chọn bàn. $e'),
            backgroundColor: Colors.red),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _handleExit() async {
    if (_isExiting) return;

    setState(() {
      _isExiting = true;
    });

    try {
      if (_orderHasBeenSent) {
        if (mounted) Navigator.pop(context);
        return;
      }

      TableModel updatedTable = TableModel(
        id: widget.table.id,
        restaurantId: widget.account.restaurantId,
        name: widget.table.name,
        seats: widget.table.seats,
        status: StatusTable.empty,
      );
      await _tableService.updateTable(updatedTable);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExiting = false;
        });
      }
    }
  }
  
  // --- THÊM HÀM NÀY ---
  // Callback này sẽ được CartWidget gọi khi gửi đơn thành công
  void _onOrderSubmitted() {
    setState(() {
      _orderHasBeenSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.fastfood, color: Colors.white),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Menu Quán Lẩu'),
            Text(
              'Bàn ${widget.table.name}',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey),
            ),
          ],
        ),
        actions: [Container()],
        elevation: 0,
        backgroundColor: Colors.white,
      ),

      // SỬA DÒNG NÀY: Truyền callback vào
      endDrawer: CartWidget(
        tableId: widget.table.id,
        restaurantId: widget.account.restaurantId,
        onOrderSubmitted: _onOrderSubmitted, // <-- TRUYỀN CALLBACK
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.white,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TableAppBarActions(
                    // SỬA HÀM NÀY: Bỏ async/await
                    onCartPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    onExitPressed: _handleExit,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: const Color(0xFFF9F9F9),
                  child: Column(
                    children: [
                      _buildCategoryFilter(),
                      Expanded(
                        child: StreamBuilder<List<Product>>(
                          stream: _productService
                              .getAllProducts(widget.account.restaurantId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                      'Lỗi tải sản phẩm: ${snapshot.error}'));
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('Chưa có sản phẩm nào.'));
                            }

                            final products = snapshot.data!;
                            final filteredProducts =
                                _selectedCategoryId == 'all'
                                    ? products
                                    : products
                                        .where((p) =>
                                            p.categoryId ==
                                            _selectedCategoryId)
                                        .toList();

                            if (filteredProducts.isEmpty) {
                              return const Center(
                                  child: Text(
                                      'Không có sản phẩm trong danh mục này.'));
                            }

                            return LayoutBuilder(
                              builder: (context, constraints) {
                                int crossAxisCount =
                                    (constraints.maxWidth / 350).floor();
                                if (crossAxisCount < 1) crossAxisCount = 1;
                                if (crossAxisCount > 3) crossAxisCount = 3;

                                return GridView.builder(
                                  padding: const EdgeInsets.all(16.0),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.8,
                                  ),
                                  itemCount: filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    return ProductCard(
                                        product: filteredProducts[index]);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isExiting)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text('Đang xử lý...',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      color: Colors.white,
      child: StreamBuilder<List<Category>>(
        stream: _categoryService.getAllCategories(widget.account.restaurantId),
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LinearProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải danh mục"));
          }

          final categories = snapshot.data ?? [];

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildFilterChip(
                  id: 'all',
                  label: 'Tất cả',
                  icon: Icons.menu_book,
                ),
                ...categories.map((category) {
                  return _buildFilterChip(
                    id: category.id,
                    label: category.name,
                    icon: _getIconFromName(category.name),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(
      {required String id, required String label, required IconData icon}) {
    final isSelected = _selectedCategoryId == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        avatar: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.black54,
          size: 18,
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          if (selected) {
            setState(() {
              _selectedCategoryId = id;
            });
          }
        },
        selectedColor: Colors.deepOrange,
        pressElevation: 0,
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
        ),
        checkmarkColor: Colors.white,
      ),
    );
  }
}