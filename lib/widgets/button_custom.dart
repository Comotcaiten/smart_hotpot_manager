import 'package:flutter/material.dart';

class ButonRoleCustom extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color color;
  final BoxDecoration? decoration;
  final VoidCallback onPressed;

  const ButonRoleCustom({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    this.decoration,
    required this.onPressed,
  });

  @override
  State<StatefulWidget> createState() => _ButtonCustomRoleState();
}

class _ButtonCustomRoleState extends State<ButonRoleCustom> {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: widget.onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: widget.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.subtitle,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
