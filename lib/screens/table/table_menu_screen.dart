// lib/screens/customer/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_hotpot_manager/services/cart_service.dart';
// Import services
import 'package:smart_hotpot_manager/services/product_service.dart';
import 'package:smart_hotpot_manager/services/category_service.dart';
// Import models
import 'package:smart_hotpot_manager/models/product.dart';
import 'package:smart_hotpot_manager/models/category.dart';
// Import widgets
import 'package:smart_hotpot_manager/widgets/customer_menu_card.dart'; 
import 'package:smart_hotpot_manager/widgets/badge.dart'; 

class CustomerMenuScreen extends StatefulWidget {
  const CustomerMenuScreen({super.key});

  @override
  State<CustomerMenuScreen> createState() => _CustomerMenuScreenState();
}

class _CustomerMenuScreenState extends State<CustomerMenuScreen> {
  // Lấy service từ Provider
  late ProductService _productService;
  late CategoryService _categoryService;
  
  late Stream<List<Product>> _productsStream;
  late Future<List<Category>> _categoriesFuture;
  
  String? _selectedCategoryId; // null = "Tất cả"

  @override
  void initState() {
    super.initState();
    // Lấy service mà không cần 'listen'
    _productService = Provider.of<ProductService>(context, listen: false);
    _categoryService = Provider.of<CategoryService>(context, listen: false);
    
    _productsStream = _productService.getAllProducts();
    _categoriesFuture = _categoryService.getAllCategories().first;
  }

  // Hàm lọc lại stream (lọc phía client)
  void _filterProducts(String? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      // Stream vẫn là getAllProducts(), chúng ta sẽ lọc trong StreamBuilder
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          buildFilterBar(),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _productsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Lỗi khi tải dữ liệu'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có món ăn nào'));
                }
                
                // Lọc danh sách ở đây
                final allItems = snapshot.data!;
                final filteredItems;
                if (_selectedCategoryId == null) {
                  filteredItems = allItems;
                } else {
                  filteredItems = allItems
                      .where((item) => item.categoryId == _selectedCategoryId)
                      .toList();
                }

                return buildMenuGrid(filteredItems);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Lấy totalAmount từ Order thật sau khi ăn xong
          Navigator.of(context).pushNamed('/payment', arguments: 0.0);
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.payment),
        label: const Text("Thanh Toán"),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text('Menu Quán Lẩu', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      actions: [
        // Widget Giỏ hàng tự cập nhật
        Consumer<CartProvider>(
          builder: (ctx, cart, child) => CartBadge(
            value: cart.itemCount.toString(),
            child: child!,
          ),
          child: TextButton.icon(
            onPressed: () { 
              Navigator.of(context).pushNamed('/cart');
            },
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            label: const Text('Giỏ hàng', style: TextStyle(color: Colors.black)),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget buildFilterBar() {
    return FutureBuilder<List<Category>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox(height: 60);

        final categories = snapshot.data!;
        
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1, // +1 cho nút "Tất cả"
            itemBuilder: (context, index) {
              // Xử lý nút "Tất cả"
              if (index == 0) {
                final isSelected = _selectedCategoryId == null;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: const Text('Tất cả'),
                    avatar: Icon(Icons.all_inclusive, size: 18, color: isSelected ? Colors.white : Colors.black87),
                    selected: isSelected,
                    onSelected: (bool selected) { _filterProducts(null); },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.black87,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                  ),
                );
              }
              
              // Các nút danh mục khác
              final category = categories[index - 1];
              final isSelected = _selectedCategoryId == category.id;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FilterChip(
                  label: Text(category.name),
                  selected: isSelected,
                  onSelected: (bool selected) { _filterProducts(category.id); },
                  backgroundColor: Colors.white,
                  selectedColor: Colors.black87,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildMenuGrid(List<Product> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        mainAxisExtent: 280, // Giảm chiều cao 1 chút
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 20.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return CustomerMenuItemCard(product: items[index]);
      },
    );
  }
}