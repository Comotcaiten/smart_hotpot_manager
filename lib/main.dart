import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/screens/admin_product_category.dart';
// Import file chứa màn hình, không phải import class App
// import 'package:smart_hotpot_manager/responsitories/product_responsitories.dart';
// import 'package:smart_hotpot_manager/widgets/menu_item_card.dart';
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
      title: 'Smart Hotpot Manager',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          primary: Colors.black87, // Màu nút chính
        ),
      ),
      home: MyPage(),
    );
  }
}

///Test để hiển thị giao diện muốn xem
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
      body: ProductCategoryUI(), ///Đổi phần này để xem giao diện muốn test
    );
  }
}