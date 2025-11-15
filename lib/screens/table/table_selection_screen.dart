import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/account.dart';
import 'package:smart_hotpot_manager/models/table.dart';
import 'package:smart_hotpot_manager/services/table_service.dart';
import 'package:smart_hotpot_manager/services/auth_service.dart'; // <-- THÊM
import 'package:smart_hotpot_manager/widgets/table_card.dart';
import 'package:smart_hotpot_manager/widgets/title_app_bar.dart';
import 'menu_screen.dart';

class TableSelectionScreen extends StatefulWidget {
  const TableSelectionScreen({super.key});

  @override
  State<TableSelectionScreen> createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends State<TableSelectionScreen> {
  final TableService _tableService = TableService();
  final AuthService _authService = AuthService(); // <-- THÊM
  Account? _account;

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Account) {
      setState(() {
        _account = args;
      });
    }
  }

  // SỬA LẠI HÀM NÀY
  void _onTableSelected(
      BuildContext context, TableModel table, Account account) async {
    // Không cho click nếu đang xử lý
    if (_isLoading) return;

    if (table.status == StatusTable.empty) {
      setState(() {
        _isLoading = true;
      });

      // CHỈ ĐIỀU HƯỚNG
      // MenuScreen sẽ chịu trách nhiệm cập nhật trạng thái "inUse"
      // Chúng ta 'await' để biết khi nào MenuScreen quay lại
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuScreen(table: table, account: account),
        ),
      );

      // Khi MenuScreen đóng, chúng ta tắt loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Thông báo bàn đã được sử dụng (logic này giữ nguyên)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Bàn ${table.name} đang được sử dụng, vui lòng chọn bàn khác.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_account == null) {
      // ... (Phần xử lý lỗi giữ nguyên)
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Lỗi: Không tìm thấy thông tin nhà hàng."),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Quay lại"),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: TitleAppBar(title: "SmartHotpotManager", subtitle: "Chọn bàn"),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ... (Phần chú thích giữ nguyên)
                Row(
                  children: [
                    _buildLegendItem(Colors.green, 'Bàn trống'),
                    const SizedBox(width: 16),
                    _buildLegendItem(Colors.pink.shade300, 'Đang sử dụng'),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Lưới các bàn
                StreamBuilder<List<TableModel>>(
                  stream: _tableService.getAllTables(_account!.restaurantId),
                  builder: (context, snapshot) {
                    // ... (StreamBuilder giữ nguyên)
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Lỗi tải dữ liệu: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Chưa có bàn nào được tạo.'));
                    }

                    final tables = snapshot.data!;

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount =
                            (constraints.maxWidth / 180).floor();
                        if (crossAxisCount < 2) crossAxisCount = 2;
                        if (crossAxisCount > 5) crossAxisCount = 5;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: tables.length,
                          itemBuilder: (context, index) {
                            final table = tables[index];
                            return TableCard(
                              table: table,
                              onTap: () =>
                                  _onTableSelected(context, table, _account!),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text('Đang xử lý...',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    // ... (Hàm này giữ nguyên)
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}