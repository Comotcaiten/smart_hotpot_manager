import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/account.dart';
import 'package:smart_hotpot_manager/services/auth_service.dart';
import 'package:smart_hotpot_manager/utils/utils.dart';

class AuthGuard {
  final AuthService _authService = AuthService();

  /// Kiểm tra đăng nhập và quyền truy cập
  Future<bool> checkAccess(BuildContext context, RoleAccount requiredRole) async {
    final user = _authService.currentUser;

    // Nếu chưa đăng nhập → chuyển sang login
    if (user == null) {
      redirectToLogin(context, requiredRole);
      return false;
    }

    // Lấy dữ liệu user từ Firestore
    final restaurant = await _authService.getAccout();
    if (restaurant == null) {
      redirectToLogin(context, requiredRole);
      return false;
    }

    // Nếu role khớp -> cho phép truy cập
    if (restaurant.role == requiredRole) {
      return true;
    }

    // Nếu role không khớp -> đăng xuất và chuyển sang WelcomeScreen
    await _authService.logout();
    redirectToWelcome(context);
    return false;
  }

  void redirectToLogin(BuildContext context, RoleAccount role) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.LOGIN,
        (route) => false,
        arguments: role,
      );
    });
  }

  void redirectToWelcome(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.WELCOME,
        (route) => false,
      );
    });
  }
}
