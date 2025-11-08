import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final double size;

  final IconData icon;

 final List<Color>? colors;

  const AppIcon({    super.key,
    this.size = 80,
    this.icon = Icons.restaurant_menu,
    this.colors,});

  @override
  Widget build(BuildContext context) {

    double radius = size / 4;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors ?? [
            Color(0xFFFF7A00),
            Color(0xFFFF2D55),
          ],
        ),
      ),
      child: Icon(
        icon,
        size: size * 0.5,
        color: Colors.white,
      ),
    );
  }
}
