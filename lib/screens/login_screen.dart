import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/screens/admin_category_screen.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';
import 'package:smart_hotpot_manager/widgets/title_app_bar.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _gmailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(title: "Login Screen", subtitle: "subtitle"),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(16.0),
            child: _buildConatinerButtons(context),
          ),
        ),
      ),
    );
  }

  Widget _buildConatinerButtons(BuildContext context) {
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

        _buildForm(context),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _gmailController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Gmail',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.mail),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập gmail';
                }
                // if (double.tryParse(value) == null) {
                //   return 'Số tiền không hợp lệ';
                // }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            TextFormField(
              controller: _passController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.password),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập password';
                }
                // if (double.tryParse(value) == null) {
                //   return 'Số tiền không hợp lệ';
                // }
                return null;
              },
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminCategoryScreen()));
                },
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Đăng nhập',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                label: const Text(
                  'Thoát',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ),
          ],
      ),
    );
  }
}
