import 'package:flutter/material.dart';

class TableAppBarActions extends StatelessWidget {
  final VoidCallback onCartPressed;
  final VoidCallback onExitPressed;

  const TableAppBarActions({
    super.key,
    required this.onCartPressed,
    required this.onExitPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Thêm khung viền như bạn yêu cầu
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300), // Khung viền
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nút Giỏ hàng
          TextButton.icon(
            onPressed: onCartPressed,
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
            label: const Text('Giỏ hàng', style: TextStyle(color: Colors.black87)),
          ),

          // Vạch ngăn cách cho đẹp mắt
          const VerticalDivider(width: 1, indent: 12, endIndent: 12),

          // Nút Thoát
          TextButton(
            onPressed: onExitPressed,
            child: const Text('Thoát', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(width: 8), // Thêm chút đệm
        ],
      ),
    );
  }
}