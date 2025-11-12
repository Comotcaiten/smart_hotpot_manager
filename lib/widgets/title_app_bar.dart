import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/section_custom.dart';

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final AppIcon? icon; // icon tuỳ biến

  const TitleAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return  AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: isMobile,
      
        flexibleSpace: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SectionHeaderIconLead(
                        title: title,
                        subtitle: subtitle,
                        icon: !isMobile ? icon ?? AppIcon(size: 46) : null,
                      ),
                    ),
                  ),
                ),
      
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: (){}, 
                    child: Text("Đăng xuất"),
                  ),
                ),
              ],
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
