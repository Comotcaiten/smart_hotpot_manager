import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/section.dart';

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Widget? icon; // icon tuỳ biến

  const TitleAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,

      flexibleSpace: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SectionHeaderIconLead(
                    title: title,
                    subtitle: subtitle,
                    child: icon ?? const AppIcon(size: 46),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(height: 1, color: Colors.grey.shade300),
          ),
        ],
      ),

      toolbarHeight: 80,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
