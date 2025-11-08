import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/product.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/section.dart';
import 'package:smart_hotpot_manager/widgets/table_widget.dart';

class ProductTableUI extends StatelessWidget {
  const ProductTableUI({super.key});

  @override
  Widget build(BuildContext context) {
    final productRows = sampleProducts.asMap().entries.map((entry) {
      final i = entry.key;
      final product = entry.value;
      return productDataRow(
        product.name,
        product.categoryId,
        '${product.price} đ',
        !product.delete,
        highlighted: i.isEven, // xen kẽ màu
      );
    }).toList();

    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
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
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 16),

          BaseTable(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.2),
              3: FlexColumnWidth(1.4),
              4: FlexColumnWidth(1),
            },
            buildHeaderRow: _buildHeaderRow(),
            buildDataRow: productRows,
          ),

          SizedBox(height: 10),

          // TODO: use list sectionObjectAdmin when it ouput on moblie
          // for (int i = 0; i < sampleProducts.length; i++)
          // ModelInfoSection(
          //   titles: {
          //     'name': 'Tên sản phẩm',
          //     'price': 'Giá',
          //     'category': 'Danh mục',
          //   },
          //   contents: sampleProducts[i].toMap()
          // ),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return const TableRow(
      children: [
        HeaderCellWidget(content: "Tên món"),
        HeaderCellWidget(content: "Danh mục"),
        HeaderCellWidget(content: "Giá"),
        HeaderCellWidget(content: "Trạng thái"),
        HeaderCellWidget(content: "Thao tác", align: TextAlign.center),
      ],
    );
  }
}

// ---------------------------------------

// Widget _badge(bool inStock) {
//   return Align(
//     alignment: Alignment.centerLeft,
//     child: Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: inStock ? Colors.black : Colors.red.shade400,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         inStock ? "Còn hàng" : "Hết hàng",
//         style: const TextStyle(color: Colors.white, fontSize: 12),
//       ),
//     ),
//   );
// }

// Widget _actions() {
//   return Container(
//     // color: Colors.white,
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Icon(Icons.edit_outlined, color: Colors.black),
//         Icon(Icons.delete_outline, color: Colors.red),
//       ],
//     ),
//   );
// }


final List<Product> sampleProducts = [
  Product(
    restaurantId: 'res001',
    id: 'p001',
    name: 'Lẩu Thái Hải Sản',
    price: 199000,
    categoryId: 'cate_lau',
    delete: false,
    imageUrl: 'https://example.com/images/lau-thai.jpg',
    createAt: DateTime.now().subtract(const Duration(days: 10)),
    updateAt: DateTime.now(),
  ),
  Product(
    restaurantId: 'res001',
    id: 'p002',
    name: 'Bò Mỹ Cuộn Nấm',
    price: 159000,
    categoryId: 'cate_thit',
    delete: false,
    imageUrl: 'https://example.com/images/bo-cuon-nam.jpg',
    createAt: DateTime.now().subtract(const Duration(days: 8)),
    updateAt: DateTime.now(),
  ),
  Product(
    restaurantId: 'res001',
    id: 'p003',
    name: 'Gà Sốt Cay',
    price: 129000,
    categoryId: 'cate_ga',
    delete: false,
    imageUrl: 'https://example.com/images/ga-sot-cay.jpg',
    createAt: DateTime.now().subtract(const Duration(days: 5)),
    updateAt: DateTime.now(),
  ),
  Product(
    restaurantId: 'res001',
    id: 'p004',
    name: 'Mì Udon Bò',
    price: 89000,
    categoryId: 'cate_mi',
    delete: false,
    imageUrl: 'https://example.com/images/mi-udon-bo.jpg',
    createAt: DateTime.now().subtract(const Duration(days: 2)),
    updateAt: DateTime.now(),
  ),
  Product(
    restaurantId: 'res001',
    id: 'p005',
    name: 'Trà Sữa Matcha',
    price: 49000,
    categoryId: 'cate_drink',
    delete: false,
    imageUrl: 'https://example.com/images/tra-sua-matcha.jpg',
    createAt: DateTime.now().subtract(const Duration(days: 1)),
    updateAt: DateTime.now(),
  ),
];