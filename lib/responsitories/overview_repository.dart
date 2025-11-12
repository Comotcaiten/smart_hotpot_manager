// lib/repositories/overview_repository.dart
import 'package:flutter/material.dart';
// Import model Order có sẵn của bạn
import 'package:smart_hotpot_manager/models/order.dart'; 

// --- MODEL DỮ LIỆU GIẢ ---
// (Sau này bạn có thể thay thế bằng model từ DB)

// Model cho 4 thẻ thống kê
class OverviewSummary {
  final double totalRevenue;
  final int processingOrders;
  final int tablesInUse;
  final int totalTables;
  final double growthPercentage;

  OverviewSummary({
    required this.totalRevenue,
    required this.processingOrders,
    required this.tablesInUse,
    required this.totalTables,
    required this.growthPercentage,
  });
}

// Model cho bảng "Đơn hàng gần đây"
// (Chúng ta cần một model riêng vì nó có 'itemsSummary')
class RecentOrder {
  final String id;
  final String tableName;
  final String itemsSummary; // VD: "Lẩu Thái x1, Bò Mỹ x2..."
  final StatusOrder status;
  final String time;
  final double totalAmount;

  RecentOrder({
    required this.id,
    required this.tableName,
    required this.itemsSummary,
    required this.status,
    required this.time,
    required this.totalAmount,
  });
}

// --- REPOSITORY ---

class OverviewRepository {

  // ===================================================================
  // SAU NÀY KẾT NỐI DATABASE
  // ===================================================================
  // Bạn sẽ thay thế 2 hàm get...() này bằng logic gọi Service thật
  // ===================================================================

  Future<OverviewSummary> getSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockSummary;
  }
  
  Future<List<RecentOrder>> getRecentOrders() async {
     await Future.delayed(const Duration(milliseconds: 500));
    return _mockRecentOrders;
  }

  // --- DỮ LIỆU GIẢ (MOCK DATA) ---
  
  final OverviewSummary _mockSummary = OverviewSummary(
    totalRevenue: 12450000,
    processingOrders: 8,
    tablesInUse: 12,
    totalTables: 20,
    growthPercentage: 15,
  );

  final List<RecentOrder> _mockRecentOrders = [
    RecentOrder(
      id: "ORD001",
      tableName: "Bàn 1",
      itemsSummary: "Lẩu Thái x1, Bò Mỹ x2...",
      status: StatusOrder.preparing, // Đang chuẩn bị
      time: "10:30",
      totalAmount: 450000,
    ),
    RecentOrder(
      id: "ORD002",
      tableName: "Bàn 3",
      itemsSummary: "Lẩu Kim Chi x1, Hải sản x1",
      status: StatusOrder.complete, // Hoàn thành
      time: "10:15",
      totalAmount: 320000,
    ),
    RecentOrder(
      id: "ORD003",
      tableName: "Bàn 4",
      itemsSummary: "Lẩu Thái x2, Bò Mỹ x3...",
      status: StatusOrder.preparing, // Đang chuẩn bị
      time: "10:45",
      totalAmount: 680000,
    ),
  ];
}