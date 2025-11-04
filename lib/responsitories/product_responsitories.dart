import 'package:flutter/material.dart'; // Cần cho Icon

// ------- PHẦN 1: MODELS TẠM THỜI -------
// (Sau này bạn có thể di chuyển 2 class/enum này vào thư mục models/)

enum ItemCategory {
  soup, // Nước lẩu
  meat, // Thịt
  seafood, // Hải sản
  vegetable, // Rau củ
}

class MenuItem {
  final String imageUrl;
  final String title;
  final String description;
  final String price;
  final ItemCategory category; 

  MenuItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.category, 
  });
}

// ------- PHẦN 2: LỚP REPOSITORY -------

class MenuRepository {
  // 
  // ===================================================================
  // HÀM QUAN TRỌNG: SAU NÀY KẾT NỐI DATABASE
  // ===================================================================
  // Hiện tại, chúng ta dùng dữ liệu giả (mock data) bên dưới.
  // Sau này, bạn sẽ xóa _mockMenuItems và thay hàm getMenuItems()
  // bằng code gọi Service (ví dụ: _productService.getProducts())
  //
  Future<List<MenuItem>> getMenuItems() async {
    // Giả lập độ trễ mạng khi gọi database
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMenuItems;
  }
  // ===================================================================
  // 

  // ------- PHẦN 3: DỮ LIỆU GIẢ (MOCK DATA) -------
  // (Toàn bộ danh sách menuItems của bạn được chuyển vào đây)
  final List<MenuItem> _mockMenuItems = [
    MenuItem(
      imageUrl: 'https://static.vecteezy.com/system/resources/previews/025/341/524/large_2x/stock-of-a-chinese-hot-pot-also-known-as-a-steamboat-is-a-dish-foodgraphy-generative-ai-photo.jpg',
      title: 'Lẩu Thái',
      description: 'Nước lẩu cay chua đặc trưng Thái Lan',
      price: '150,000đ',
      category: ItemCategory.soup,
    ),
    MenuItem(
      imageUrl: 'https://sieungon.com/wp-content/uploads/2018/01/mon-canh-kim-chi.jpg',
      title: 'Lẩu Kim Chi',
      description: 'Nước lẩu kim chi cay nồng Hàn Quốc',
      price: '150,000đ',
      category: ItemCategory.soup,
    ),
    MenuItem(
      imageUrl: 'https://gofood.vn/upload/r/ba-chi-1.jpg',
      title: 'Bò Mỹ',
      description: 'Thịt bò Mỹ cao cấp, thái mỏng',
      price: '180,000đ',
      category: ItemCategory.meat,
    ),
    MenuItem(
      imageUrl: 'https://file.hstatic.net/200000356095/file/z4182969190997_b6ee144fa78aaf42470ee0d5c25ce427_e2d5c34020a04f0e89d61fc44cde3e12.jpg',
      title: 'Bò Úc',
      description: 'Thịt bò Úc thượng hạng',
      price: '200,000đ',
      category: ItemCategory.meat,
    ),
    MenuItem(
      imageUrl: 'https://bccaqua.com.vn/wp-content/uploads/2024/06/nuoi-tom-hum-3.jpg',
      title: 'Tôm Hùm',
      description: 'Tôm hùm tươi sống bắt tại bể',
      price: '450,000đ',
      category: ItemCategory.seafood,
    ),
    MenuItem(
      imageUrl: 'https://viettrungfood.vn/wp-content/uploads/2022/08/1-1-19.jpg',
      title: 'Ba Chỉ Heo',
      description: 'Ba chỉ heo tươi ngon',
      price: '120,000đ',
      category: ItemCategory.meat,
    ),
    MenuItem(
      imageUrl: 'https://photo-baomoi.bmcdn.me/w700_r1/2025_10_29_94_53614036/65b6cb0fad4644181d57.jpg',
      title: 'Rau Tổng Hợp',
      description: 'Rau cải, nấm, ngô...',
      price: '60,000đ',
      category: ItemCategory.vegetable,
    ),
  ];
}