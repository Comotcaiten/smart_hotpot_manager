// lib/screens/table/menu_screen.dart

import 'package:flutter/material.dart';
// Import tất cả model, data, và repository từ 1 file
import 'package:smart_hotpot_manager/responsitories/product_responsitories.dart';
import 'package:smart_hotpot_manager/widgets/menu_item_card.dart';     

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedFilterIndex = 0;
  
  // Màn hình này không chứa dữ liệu, nó gọi Repository
  final MenuRepository _menuRepository = MenuRepository();
  late Future<List<MenuItem>> _menuItemsFuture;

  // Dữ liệu filter (có thể giữ ở đây vì nó là của UI)
  final List<Map<String, dynamic>> filters = [
    {'icon': Icons.all_inclusive, 'label': 'Tất cả', 'category': null},
    {'icon': Icons.local_fire_department_outlined, 'label': 'Nước lẩu', 'category': ItemCategory.soup},
    {'icon': Icons.kebab_dining_outlined, 'label': 'Thịt', 'category': ItemCategory.meat},
    {'icon': Icons.set_meal_outlined, 'label': 'Hải sản', 'category': ItemCategory.seafood},
    {'icon': Icons.eco_outlined, 'label': 'Rau củ', 'category': ItemCategory.vegetable},
  ];

  @override
  void initState() {
    super.initState();
    // Gọi hàm lấy dữ liệu khi màn hình khởi tạo
    _menuItemsFuture = _menuRepository.getMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          buildFilterBar(),
          // Dùng FutureBuilder để xử lý việc tải dữ liệu
          Expanded(
            child: FutureBuilder<List<MenuItem>>(
              future: _menuItemsFuture,
              builder: (context, snapshot) {
                // Trạng thái đang tải
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                // Trạng thái có lỗi
                if (snapshot.hasError) {
                  return const Center(child: Text('Lỗi khi tải dữ liệu'));
                }
                
                // Trạng thái không có dữ liệu
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có món ăn nào'));
                }

                // Trạng thái THÀNH CÔNG: Lấy dữ liệu
                final allItems = snapshot.data!;

                // 5. Logic lọc
                final selectedCategory = filters[_selectedFilterIndex]['category'];
                final List<MenuItem> filteredItems;

                if (selectedCategory == null) {
                  filteredItems = allItems;
                } else {
                  filteredItems = allItems
                      .where((item) => item.category == selectedCategory)
                      .toList();
                }

                // Trả về lưới (grid) với dữ liệu đã lọc
                return buildMenuGrid(filteredItems);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.help_outline),
      ),
    );
  }

  // Widget cho AppBar (Giữ nguyên)
  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.grey[200],
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Menu Quán Lẩu', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
          Text('Bản số 5', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () { /* Navigator.pushNamed(context, '/cart'); */ },
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
          label: const Text('Giỏ hàng', style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Thoát', style: TextStyle(color: Colors.black)),
        ),
        const SizedBox(width: 2),
      ],
    );
  }

  // Widget cho thanh Filter (Giữ nguyên)
  Widget buildFilterBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final bool isSelected = _selectedFilterIndex == index;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FilterChip(
              label: Text(filter['label']),
              avatar: Icon(filter['icon'], size: 18, color: isSelected ? Colors.white : Colors.black87),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _selectedFilterIndex = index;
                  }
                });
              },
              backgroundColor: Colors.white,
              selectedColor: Colors.black87,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w500),
              shape: StadiumBorder(side: BorderSide(color: Colors.grey[300]!)),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  // Widget cho lưới menu (Giữ nguyên)
  Widget buildMenuGrid(List<MenuItem> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy món ăn nào.', style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,//Chỉnh chiều rộng tối đa của mỗi card
        mainAxisExtent: 300,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 0.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return MenuItemCard(item: items[index]);
      },
    );
  }
}