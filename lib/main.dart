import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/screens/admin_product_table.dart';
// import 'package:flutter/services.dart';
import 'package:smart_hotpot_manager/widgets/title_app_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
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
      appBar: const TitleAppBar(
        title: "Admin Dashboard",
        subtitle: "Quản lý quán lẩu",
      ),
      body: ProductTableUI(),
    );
  }
}
