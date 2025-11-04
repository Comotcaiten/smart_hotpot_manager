import 'package:flutter/material.dart';
// Import file chứa màn hình, không phải import class App
// import 'package:smart_hotpot_manager/responsitories/product_responsitories.dart';
import 'package:smart_hotpot_manager/screen/table/menu_screen.dart';
// import 'package:smart_hotpot_manager/widgets/menu_item_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Hotpot Manager',
      
      // 1. CHUYỂN THEME TỪ FILE KIA SANG ĐÂY
      // Theme này sẽ áp dụng cho TOÀN BỘ ứng dụng
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F9F9), 
        fontFamily: 'Roboto', 
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          primary: Colors.black87, // Màu nút chính
        ),
      ),
      
      // 2. THÊM INITIALROUTE VÀ SỬA ROUTES
      initialRoute: '/', // Route mặc định khi mở ứng dụng
      routes: {
        // Thêm một route '/' để làm trang chủ
        '/': (context) => const HomeScreen(), 
        // Sửa route '/product' để trỏ thẳng đến MenuScreen
        '/Menu': (context) => const MenuScreen(), //của staff
        // Bạn có thể thêm các route khác ở đây, ví dụ:
        // '/cart': (context) => const CartScreen(),
      },
    );
  }
}

// 3. TẠO MỘT TRANG CHỦ ĐƠN GIẢN (VÍ DỤ)
// Trang này dùng để điều hướng đến trang menu của bạn
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang Chủ'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Điều hướng đến trang Menu Lẩu
            Navigator.pushNamed(context, '/Menu');
          },
          child: const Text('Xem Menu Sản Phẩm'),
        ),
      ),
    );
  }
}