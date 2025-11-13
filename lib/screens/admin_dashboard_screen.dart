import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/screens/admin/admin_category_screen.dart';
import 'package:smart_hotpot_manager/screens/admin/admin_product_screen.dart';
import 'package:smart_hotpot_manager/screens/admin/admin_staff_screen.dart';
import 'package:smart_hotpot_manager/screens/admin/admin_table_screen.dart';
import 'package:smart_hotpot_manager/screens/admin/admin_order_screen.dart';
import 'package:smart_hotpot_manager/screens/admin/admin_overview_screen.dart';
import 'package:smart_hotpot_manager/widgets/title_app_bar.dart';

enum AdminView { overview, categories, menu, table, account, order }

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  AdminView _select = AdminView.overview;

  Widget _buildSelectedView() {
    switch (_select) {
      case AdminView.menu:
        return const AdminProductScreen();
      case AdminView.categories:
        return const AdminCategoryScreen();
      case AdminView.overview:
        return const AdminOverviewScreen();
      case AdminView.table:
        return const AdminTableScreen();
      case AdminView.account:
        return const AdminStaffScreen();
      case AdminView.order:
        return const AdminOrderScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        title: "Smart Hotpot Manager",
        subtitle: "Admin Dashboard",
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          CupertinoSlidingSegmentedControl<AdminView>(
            groupValue: _select,
            thumbColor: Colors.white,
            backgroundColor: Colors.grey.shade200,
            onValueChanged: (value) {
              if (value != null) {
                setState(() {
                  _select = value;
                });
              }
            },
            children: const {
              AdminView.overview: SegmentText(content: "Overview"),
              AdminView.categories: SegmentText(content: "Danh mục"),
              AdminView.menu: SegmentText(content: "Menu"),
              AdminView.table: SegmentText(content: "Table"),
              AdminView.order: SegmentText(content: "Order"),
              AdminView.account: SegmentText(content: "Staff"),
            },
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildSelectedView(),
            ),
          ),
        ],
      ),
    );
  }
}

class SegmentText extends StatelessWidget {
  final String content;
  const SegmentText({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        content,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }
}