import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_hotpot_manager/screens/welcome_screen.dart';
import 'package:smart_hotpot_manager/widgets/app_icon.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyPageState();
  
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            SectionHeader(
            title: "Admin Dashboard", 
            subtitle: "Quản lý quán lẩu",
            child: AppIcon(size: 40,),
            )
          ],
        ),
      ),
      body: WelcomeScreen(),
    );
  }

}

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double iconSize;

  final Widget? child;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.iconSize = 40,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child ?? const SizedBox(width: 1,),

        const SizedBox(width: 16),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
