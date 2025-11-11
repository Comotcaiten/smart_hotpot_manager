import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/screens/login_screen.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/button_custom.dart';
import 'package:smart_hotpot_manager/widgets/title_app_bar.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomeHomeState();
}

class _WelcomeHomeState extends State<WelcomeScreen> {
  void _openLoginScreen() async {
    Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));

    // Navigator.push(context, MaterialPageRoute(builder: (c) => ProductTableUI()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(title: "Welcome Screen", subtitle: "subtitle"),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(32),
            child: _buildMainLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildMainLayout(BuildContext context) {
    return Column(
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
          ButonRoleCustom(
            title: "Đăng nhập Admin",
            subtitle: "Chủ quán - Quản lý toàn bộ hệ thống",
            color: Colors.deepPurple,
            onPressed: _openLoginScreen,
          ),

          const SizedBox(height: 16),

          ButonRoleCustom(
            title: "Đăng nhập Nhân viên",
            subtitle: "Nhân viên - Xử lý đơn hàng",
            color: Colors.blueAccent,
            onPressed: () {},
          ),

          const SizedBox(height: 16),

          ButonRoleCustom(
            title: "Bàn Khách Hàng",
            subtitle: "Tablet - Menu đặt món",
            color: Colors.deepOrange,
            onPressed: () {},
          ),

          const SizedBox(height: 28),
        ],
    );
  }
}
