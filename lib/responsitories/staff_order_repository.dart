// lib/repositories/staff_order_repository.dart
import 'package:flutter/material.dart';

// --- PHẦN 1: MODELS TẠM THỜI ---
// (Sau này bạn có thể chuyển 3 class/enum này vào thư mục /models/ của bạn)

// Enum để định nghĩa các trạng thái
enum OrderStatus { pending, preparing, completed }

// Model cho một món trong đơn
class OrderItem {
  final String name;
  final int quantity;
  final String? note; // Ghi chú (có thể có hoặc không)

  OrderItem({required this.name, required this.quantity, this.note});
}

// Model cho một đơn hàng
class StaffOrder {
  final String id;
  final String tableName;
  final String time;
  final OrderStatus status;
  final List<OrderItem> items;
  final bool isPriority; // Đánh dấu đơn ưu tiên

  StaffOrder({
    required this.id,
    required this.tableName,
    required this.time,
    required this.status,
    required this.items,
    this.isPriority = false,
  });
}

// --- PHẦN 2: REPOSITORY VỚI DỮ LIỆU GIẢ ---

class StaffOrderRepository {
  // 
  // ===================================================================
  // SAU NÀY KẾT NỐI DATABASE
  // ===================================================================
  // Bạn sẽ thay thế hàm getOrders() này để gọi Firebase/API thật.
  // Miễn là nó trả về đúng `Future<List<StaffOrder>>`,
  // toàn bộ giao diện sẽ tự động cập nhật mà không cần sửa file khác.
  //
  Future<List<StaffOrder>> getOrders() async {
    // Giả lập độ trễ mạng khi gọi DB
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockOrders;
  }
  // ===================================================================
  // 

  // Dữ liệu giả (mock data) dựa trên hình ảnh của bạn
  final List<StaffOrder> _mockOrders = [
    // --- Đơn Chờ xử lý 1 ---
    StaffOrder(
      id: "ORD001",
      tableName: "Bàn 1",
      time: "10:30",
      status: OrderStatus.pending,
      items: [
        OrderItem(quantity: 1, name: "Lẩu Thái"),
        OrderItem(quantity: 2, name: "Bò Mỹ", note: "Ghi chú: Không hành"),
        OrderItem(quantity: 1, name: "Rau củ tổng hợp"),
      ],
    ),
    // --- Đơn Chờ xử lý 2 (Ưu tiên) ---
    StaffOrder(
      id: "ORD002",
      tableName: "Bàn 4",
      time: "10:35",
      status: OrderStatus.pending,
      isPriority: true, // Đơn này có viền đỏ
      items: [
        OrderItem(quantity: 2, name: "Lẩu Kim Chi", note: "Ghi chú: Cay nồng"),
        OrderItem(quantity: 1, name: "Hải sản tươi"),
        OrderItem(quantity: 2, name: "Nấm các loại"),
      ],
    ),
    // --- Đơn Đang chuẩn bị ---
    StaffOrder(
      id: "ORD003",
      tableName: "Bàn 7",
      time: "10:25",
      status: OrderStatus.preparing,
      items: [
        OrderItem(quantity: 1, name: "Lẩu Thái"),
        OrderItem(quantity: 1, name: "Rau củ"),
      ],
    ),
    // --- Đơn Đã hoàn thành ---
    StaffOrder(
      id: "ORD004",
      tableName: "Bàn 3",
      time: "10:15",
      status: OrderStatus.completed,
      items: [
        OrderItem(quantity: 3, name: "Bò Mỹ"),
        OrderItem(quantity: 1, name: "Hải sản", note: "Ghi chú: Tươi sống"),
      ],
    ),
  ];
}