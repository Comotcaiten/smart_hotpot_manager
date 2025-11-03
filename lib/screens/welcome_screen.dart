import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEFE8),
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 6),
                blurRadius: 18,
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon App
              AppIcon(),
              
              const SizedBox(height: 20),

              // App name
              const Text(
                "Smart Hotpot Manager",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),
              const Text(
                "Ứng dụng Quản lý Quán Lẩu Thông Minh",
                style: TextStyle(fontSize: 15, color: Colors.black54),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Buttons
              RoleButton(
                title: "Đăng nhập Admin",
                subtitle: "Chủ quán - Quản lý toàn bộ hệ thống",
                colors: [Colors.purpleAccent, Colors.deepPurple],
              ),

              const SizedBox(height: 16),

              RoleButton(
                title: "Đăng nhập Nhân viên",
                subtitle: "Nhân viên - Xử lý đơn hàng",
                colors: [Colors.blueAccent, Colors.blue],
              ),

              const SizedBox(height: 16),

              RoleButton(
                title: "Bàn Khách Hàng",
                subtitle: "Tablet - Menu đặt món",
                colors: [Colors.deepOrange, Colors.red],
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Color> colors;
  final BoxDecoration? decoration;

  const RoleButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.colors,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: decoration ?? BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}