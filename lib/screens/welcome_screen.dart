import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/restaurant.dart';
import 'package:smart_hotpot_manager/services/auth_service.dart';
import 'package:smart_hotpot_manager/utils/app_routes.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/button_custom.dart';
import 'package:smart_hotpot_manager/widgets/title_app_bar.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomeHomeState();
}

class _WelcomeHomeState extends State<WelcomeScreen> {
  final _authService = AuthService();

  // @override
  // void initState() {
  //   super.initState();
  //   _checkIfLoggedIn();
  // }

  // TODO: Kiểm tra xem người dùng có đang đăng nhập hay không
  Future<void> _handleLogin(RoleAccount selectRole) async {
    // Lấy user hiện tại
    final user = _authService.currentUser;

    // Nếu user đang đăng nhập
    if (user != null) {
      // Lấy thông tin từ Firestore nếu cần
      final doc = await _authService.getRestaurantById(user.uid);
      if (!mounted) return;

      if (doc!.role == selectRole) {
        // Tùy role mà điều hướng sang màn hình tương ứng
        if (doc.role == RoleAccount.admin) {
          Navigator.of(
            context,
          ).pushNamed(AppRoutes.DASHBOARD, arguments: selectRole);
        }
      } else {
        _authService.logout();

        if (!mounted) return;

        Navigator.of(context).pushNamed(AppRoutes.LOGIN, arguments: selectRole);
      }
    } else {
      Navigator.of(context).pushNamed(AppRoutes.LOGIN, arguments: selectRole);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        title: "Smart Hotpot Manager",
        subtitle: "Welcome Page",
      ),
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
          onPressed: () {
            _handleLogin(RoleAccount.admin);
          },
        ),

        const SizedBox(height: 16),

        ButonRoleCustom(
          title: "Đăng nhập Nhân viên",
          subtitle: "Nhân viên - Xử lý đơn hàng",
          color: Colors.blueAccent,
          onPressed: () {
            _handleLogin(RoleAccount.staff);
          },
        ),

        const SizedBox(height: 16),

        ButonRoleCustom(
          title: "Bàn Khách Hàng",
          subtitle: "Tablet - Menu đặt món",
          color: Colors.deepOrange,
          onPressed: () {
            _handleLogin(RoleAccount.table);
          },
        ),

        const SizedBox(height: 28),
      ],
    );
  }
}
