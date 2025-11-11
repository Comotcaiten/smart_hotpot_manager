// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/category.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/section.dart';
import 'package:smart_hotpot_manager/widgets/table_widget.dart';

class ProductCategoryUI extends StatelessWidget {
  const ProductCategoryUI({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesRow = sampleCategories.asMap().entries.map((entry) {
      final i = entry.key;
      final category = entry.value;
      return categoryDataRow(
        category.name,
        category.amount,
        category.delete,
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
            title: "Quản lý Danh mục",
            subtitle: "Thêm, sửa, xóa danh mục món ăn",
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
            buildDataRow: categoriesRow,
          ),

          SizedBox(height: 10),

          // use list sectionObjectAdmin when it ouput on moblie
          // SectionObjectAdmin(titles: ["Tên món", "Danh mục", "qqqqqqqqqqqqqqqqqqqqqqqqqqqq"]),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return const TableRow(
      children: [
        HeaderCellWidget(content: "Tên danh mục"),
        HeaderCellWidget(content: "Số lượng"),
        HeaderCellWidget(content: "Trạng Thái"),
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

class SectionObjectAdmin extends StatelessWidget {
  final List<String> titles;

  const SectionObjectAdmin({super.key, required this.titles});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Row(

        children: [
          //png
          const SizedBox(width: 12),
          Container(
            color: Colors.blue,
            child: Column(

              children: [
                for (int i = 0; i < titles.length; i++)
                  Text(
                    titles[i],
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final List<Category> sampleCategories = [
  Category(
    restaurantId: 'r1',
    id: 'c1',
    name: 'Nước lẩu',
    icon: 'assets/icons/appetizer.png',
    amount: '15',
    delete: false,
  ),
  Category(
    restaurantId: 'r1',
    id: 'c2',
    name: 'Thịt',
    icon: 'assets/icons/main_course.png',
    amount: '25',
    delete: false,
  ),
  Category(
    restaurantId: 'r1',
    id: 'c3',
    name: 'Rau củ',
    icon: 'assets/icons/dessert.png',
    amount: '10',
    delete: true,
  ),
  Category(
    restaurantId: 'r1',
    id: 'c4',
    name: 'Hải sản',
    icon: 'assets/icons/seafood.png',
    amount: '20',
    delete: false,
  ),
  
];
