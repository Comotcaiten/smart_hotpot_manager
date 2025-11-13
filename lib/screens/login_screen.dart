import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_hotpot_manager/models/restaurant.dart';
import 'package:smart_hotpot_manager/models/staff.dart';
import 'package:smart_hotpot_manager/services/auth_service.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/button_custom.dart';
import 'package:smart_hotpot_manager/widgets/field_custom.dart';
import 'package:smart_hotpot_manager/widgets/title_app_bar.dart';
import 'package:smart_hotpot_manager/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _gmailController = TextEditingController();
  final _passController = TextEditingController();
  final _restaurantIdController = TextEditingController();
  final _roleIdController = TextEditingController();

  bool _isLoading = false;

  final _authServices = AuthService();

  Future<void> _loginStaff() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final Staff? staff = await _authServices.loginStaff(
        _gmailController.text.trim(),
        _passController.text.trim(),
      );

      if (staff?.role != RoleAccount.staff) {
        throw Exception('Tài khoản này không có quyền đăng nhập Staff.');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đăng nhập thành công!')));

      Navigator.pushNamed(context, AppRoutes.DASHBOARD);

    } on FirebaseAuthException catch (e) {
      String message = 'Đăng nhập thất bại';
      if (e.code == 'user-not-found') {
        message = 'Không tìm thấy tài khoản với email này';
      } else if (e.code == 'wrong-password') {
        message = 'Sai mật khẩu, vui lòng thử lại';
      } else if (e.code == 'invalid-email') {
        message = 'Email không hợp lệ';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false); 
    }
  }

  Future<void> _loginAdmin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final Restaurant? restaurant = await _authServices.login(
        _gmailController.text.trim(),
        _passController.text.trim(),
      );

      if (restaurant?.role != RoleAccount.admin) {
        throw Exception('Tài khoản này không có quyền đăng nhập Admin.');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đăng nhập thành công!')));

      Navigator.pushNamed(context, AppRoutes.DASHBOARD);

    } on FirebaseAuthException catch (e) {
      String message = 'Đăng nhập thất bại';
      if (e.code == 'user-not-found') {
        message = 'Không tìm thấy tài khoản với email này';
      } else if (e.code == 'wrong-password') {
        message = 'Sai mật khẩu, vui lòng thử lại';
      } else if (e.code == 'invalid-email') {
        message = 'Email không hợp lệ';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final role =
        ModalRoute.of(context)?.settings.arguments as RoleAccount? ??
        RoleAccount.none;

    if (role == RoleAccount.none) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Navigator.of(context).pop(),
      );
      return const Scaffold(
        body: Center(child: Text('No arguments provided. Returning...')),
      );
    }

    return Scaffold(
      appBar: TitleAppBar(title: "Smart Hotpot Manager", subtitle: "Đăng nhập"),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(16.0),
            child: _buildLoginForm(role),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(RoleAccount role) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(),
          const SizedBox(height: 20),

          Text(
            'Đăng nhập với tư cách ${role.name}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 32),

          if (role == RoleAccount.staff || role == RoleAccount.table) ...[
            TextField(
              controller: _restaurantIdController,
              decoration: InputDecoration(
                labelText: "Mã quán",
                prefixIcon: const Icon(Icons.qr_code),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
          ],

          if (role == RoleAccount.table) ...[
            TextField(
              controller: _roleIdController,
              decoration: InputDecoration(
                labelText: "Mã bàn",
                prefixIcon: const Icon(Icons.qr_code),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
          ],

          if (role == RoleAccount.admin || role == RoleAccount.staff) ...[
            TextFormField(
              controller: _gmailController,
              decoration: const InputDecoration(
                labelText: "Gmail",
                prefixIcon: Icon(Icons.mail),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return "Vui lòng nhập Gmail";
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return "Gmail không hợp lệ";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],

          PasswordField(
            controller: _passController,
            labelText: "Mật khẩu",
            prefixIcon: Icon(Icons.lock),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Vui lòng nhập mật khẩu";
              }
              if (value.length < 8) return "Mật khẩu phải có ít nhất 8 ký tự";
              return null;
            },
          ),

          const SizedBox(height: 24),

          _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    ExpandedButtonIcon(
                      onPressed: () async {
                        if (role == RoleAccount.admin) {
                          await _loginAdmin();
                        } 
                        else if (role == RoleAccount.staff) {
                          await _loginStaff();
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Role này chưa hỗ trợ đăng nhập'),
                            ),
                          );
                        }
                      },
                      label: "Đăng nhập",
                      icon: const Icon(Icons.login, color: Colors.white),
                      backgroundColor: Colors.blueAccent,
                    ),
                    const SizedBox(height: 16),

                    ExpandedButtonIcon(
                      onPressed: () => Navigator.pop(context),
                      label: "Thoát",
                      icon: const Icon(Icons.exit_to_app, color: Colors.white),
                      backgroundColor: Colors.redAccent,
                    ),
                  ],
                ),

          if (role == RoleAccount.admin) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Chưa có tài khoản? "),
                TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.REGISTER, arguments: role);
                  },
                  child: const Text("Đăng ký ngay"),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
