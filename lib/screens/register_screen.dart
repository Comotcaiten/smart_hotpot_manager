import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/screens/welcome_screen.dart';
import 'package:smart_hotpot_manager/utils/app_routes.dart';
import 'package:smart_hotpot_manager/widgets/title_app_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _nameController = TextEditingController();
  final _gmailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    // Nhận role từ trang Welcome
    final role = ModalRoute.of(context)?.settings.arguments as RoleAccount? ?? RoleAccount.none;
    
    if (role != RoleAccount.admin) {
     // If arguments are null, pop the current route
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
      return Scaffold(
        body: Center(
          child: Text('Your role dont have permision to enter this screen. Returning...'),
        ),
      );
    }

    return Scaffold(
      appBar: TitleAppBar(title: "Smart Hotpot Manager", subtitle: "Register"),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(16.0),
            child: _buildConatinerButtons(role),
          ),
        ),
      ),
    );
  }

  Widget _buildConatinerButtons(RoleAccount role) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        const SizedBox(height: 16),

        // App name
        const Text(
          "Đăng ký tài khoản Admin",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Name
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.mail),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập name';
                  }
                  return null;
                },
              ),

              /// Gmail
              const SizedBox(height: 16),

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
                  return null;
                },
              ),

              /// Password
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
                  return null;
                },
              ),

              /// Confirm Password
              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmPassController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập password';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () { Navigator.pop(context); },
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Đăng ký',
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
        ),

        SizedBox(height: 16,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("I have an account?", style: TextStyle(color: Colors.black),),
            const SizedBox(width: 4,),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.LOGIN, arguments: role);
              }, 
              child: Text("Login")
            )
          ],
        )
      ],
    );
  }

}