// lib/widgets/badge.dart
import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({
    super.key,
    required this.child,
    required this.value,
    this.color,
  });

  final Widget child;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        if (value != '0') // Chỉ hiển thị nếu có hàng
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color ?? Colors.red,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          )
      ],
    );
  }
}