import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/restaurant.dart';
import 'package:smart_hotpot_manager/services/auth_service.dart';
import 'package:smart_hotpot_manager/utils/utils.dart';
import 'package:smart_hotpot_manager/widgets/button_custom.dart';
import 'package:smart_hotpot_manager/widgets/field_custom.dart';
import 'package:smart_hotpot_manager/widgets/title_app_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _gmailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _isLoading = false;

  final _authServices = AuthService();

  // // Regex pattern
  // final _nameRegex = RegExp(r'^[a-zA-ZÀ-ỹ0-9\s]+$'); // không ký tự đặc biệt
  // final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<void> _registerRestaurant() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      _gmailController.text = _gmailController.text.trim();
      _passController.text = _passController.text.trim();

      // Tạo đối tượng Restaurant model
      final restaurant = Restaurant(
        id: '',
        name: _nameController.text.trim(),
        gmail: _gmailController.text.trim(),
        pass: _passController.text.trim(),
        role: RoleAccount.admin,
        createAt: DateTime.now(),
        updateAt: DateTime.now(),
      );

      await _authServices.register(restaurant);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đăng ký thành công!')));

      Navigator.of(
        context,
      ).pushReplacementNamed(AppRoutes.LOGIN, arguments: RoleAccount.admin);
      
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Đăng ký thất bại';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email này đã được đăng ký!';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Mật khẩu quá yếu, vui lòng đặt mật khẩu mạnh hơn!';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Email không hợp lệ!';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
    finally {
      setState(() => _isLoading = false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        title: "Smart Hotpot Manager",
        subtitle: "Đăng ký tài khoản Restaurant",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Tên nhà hàng",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Vui lòng nhập tên nhà hàng";
                      }
                      if (!RegexPattern.nameRegex.hasMatch(value.trim())) {
                        return "Tên không được chứa ký tự đặc biệt hoặc số";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _gmailController,
                    decoration: const InputDecoration(
                      labelText: "Gmail",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng nhập Gmail";
                      }
                      if (!RegexPattern.emailRegex.hasMatch(value.trim())) {
                        return "Định dạng Gmail không hợp lệ";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  PasswordField(
                    controller: _passController,
                    labelText: "Mật khẩu",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng nhập mật khẩu";
                      }
                      if (value.length < 8) {
                        return "Mật khẩu phải có ít nhất 8 ký tự";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  PasswordField(
                    controller: _confirmPassController,
                    labelText: "Xác nhận mật khẩu",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng xác nhận mật khẩu";
                      }
                      if (value != _passController.text) {
                        return "Mật khẩu xác nhận không khớp";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),
                  
                  _isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            ExpandedButtonIcon(
                              onPressed: _registerRestaurant,
                              label: "Đăng nhập",
                              icon: const Icon(Icons.save, color: Colors.white),
                              backgroundColor: Colors.blueAccent,
                            ),

                            const SizedBox(height: 16),

                            ExpandedButtonIcon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                              label: "Thoát",
                              backgroundColor: Colors.redAccent,
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

