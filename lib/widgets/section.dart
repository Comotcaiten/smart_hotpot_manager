// section.dart
import 'package:flutter/material.dart';

class SectionHeaderIconLead extends StatelessWidget {
  final String title;
  final String subtitle;
  final double iconSize;

  final Widget? child;

  const SectionHeaderIconLead({
    super.key,
    required this.title,
    required this.subtitle,
    this.iconSize = 40,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        child ?? const SizedBox(width: 1),
        const SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }
}
