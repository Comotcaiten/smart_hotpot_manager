import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/firebase_options.dart';
import 'package:smart_hotpot_manager/screens/admin_dashboard_screen.dart';
import 'package:smart_hotpot_manager/screens/login_screen.dart';
import 'package:smart_hotpot_manager/screens/register_screen.dart';
import 'package:smart_hotpot_manager/screens/staff_home_screen.dart';
import 'package:smart_hotpot_manager/screens/welcome_screen.dart';
import 'package:smart_hotpot_manager/screens/table/table_menu_screen.dart';
import 'package:smart_hotpot_manager/utils/app_routes.dart';
// import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Hopot Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      routes: <String, WidgetBuilder> {
        AppRoutes.WELCOME: (BuildContext context) => WelcomeScreen(),
        AppRoutes.LOGIN: (BuildContext context) => LoginScreen(),
        AppRoutes.REGISTER: (BuildContext context) => RegisterScreen(),
        AppRoutes.DASHBOARD: (BuildContext context) => AdminDashboardScreen(),
        AppRoutes.STAFF_HOME: (BuildContext context) => StaffHomeScreen(),
        AppRoutes.TABLE_MENU: (BuildContext context) => const CustomerMenuScreen(),
      },
    );
  }
}