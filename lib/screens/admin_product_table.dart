// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ProductTableUI extends StatelessWidget {
  const ProductTableUI({super.key});

  @override
  Widget build(BuildContext context) {
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
          const Text(
            "Quản lý Menu",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Thêm, sửa, xóa món ăn",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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

          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.2),
              3: FlexColumnWidth(1.4),
              4: FlexColumnWidth(1),
            },
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey.shade300),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildHeaderRow(),

              // Fake sample data
              _buildDataRow("Lẩu Thái", "Nước lẩu", "150,000đ", true),
              _buildDataRow("Lẩu Kim Chi", "Nước lẩu", "150,000đ", true),
              _buildDataRow(
                "Bò Mỹ",
                "Thịt",
                "180,000đ",
                true,
                highlighted: true,
              ),
              _buildDataRow("Hải Sản Tươi", "Hải sản", "200,000đ", false),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return const TableRow(
      children: [
        _headerCell(text: "Tên món"),
        _headerCell(text: "Danh mục"),
        _headerCell(text: "Giá"),
        _headerCell(text: "Trạng thái"),
        _headerCell(text: "Thao tác", align: TextAlign.center),
      ],
    );
  }

  TableRow _buildDataRow(
    String name,
    String category,
    String price,
    bool inStock, {
    bool highlighted = false,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: highlighted ? Colors.grey.shade100 : Colors.transparent,
      ),
      children: [
        _cell(name),
        _cell(category),
        _cell(price),
        _badge(inStock),
        _actions(),
      ],
    );
  }
}

// ---------------------------------------

class _headerCell extends StatelessWidget {
  const _headerCell({super.key, required this.text, this.align});
  final String? text;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text ?? "",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        textAlign: align ?? TextAlign.left,
      ),
    );
  }
}

class _cell extends StatelessWidget {
  final String text;
  const _cell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}

Widget _badge(bool inStock) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: inStock ? Colors.black : Colors.red.shade400,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        inStock ? "Còn hàng" : "Hết hàng",
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ),
  );
}

Widget _actions() {
  return Container(
    // color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(Icons.edit_outlined, color: Colors.black),
        Icon(Icons.delete_outline, color: Colors.red),
      ],
    ),
  );
}
