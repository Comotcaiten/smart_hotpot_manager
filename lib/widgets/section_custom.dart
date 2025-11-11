// section.dart
import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';

class SectionHeaderIconLead extends StatelessWidget {
  final String title;
  final String subtitle;
  final double iconSize;

  final AppIcon? icon;

  const SectionHeaderIconLead({
    super.key,
    required this.title,
    required this.subtitle,
    this.iconSize = 40,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon ?? const SizedBox(width: 1),
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

class ModelInfoSection  extends StatelessWidget {
  final Map<String, String> titles; // key: fieldName, value: title hiển thị
  final Map<String, dynamic> contents; // key: fieldName, value: dữ liệu thực tế

  const ModelInfoSection({
    super.key,
    required this.titles,
    required this.contents,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in titles.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  SizedBox(
                    width: 100,
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Dữ liệu
                  Expanded(
                    child: Text(
                      '${contents[entry.key] ?? '-'}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                      ),
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