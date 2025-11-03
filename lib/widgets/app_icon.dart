import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final double size;

  const AppIcon({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {

    double radius = size / 4;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF7A00),
            Color(0xFFFF2D55),
          ],
        ),
      ),
      child: Icon(
        Icons.restaurant_menu,
        size: size * 0.5,
        color: Colors.white,
      ),
    );
  }
}
