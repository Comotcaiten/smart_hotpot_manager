import 'package:smart_hotpot_manager/models/restaurant.dart';

enum StatusTable {inUse, empty, set}

class Table {
  String restaurantId;
  String id;
  String name;
  String pass;
  StatusTable status;
  RoleAccount role;
  DateTime createAt;
  DateTime updateAt;

  String get statusString => status.name;

  Table({
    required this.restaurantId,
    required this.id,
    required this.name,
    required this.pass,
    this.role = RoleAccount.table,
    required this.status,
    required this.createAt,
    required this.updateAt,
  });

  factory Table.fromMap(Map<String, dynamic> data) {
    return Table(
      restaurantId: data['restaurant_id'] ?? '',
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      pass: data['pass'] ?? '',
      role: RoleAccount.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => RoleAccount.table,
      ),
      status: data['status'] ?? StatusTable.empty.name,
      createAt: (data['create_at'] as DateTime),
      updateAt: (data['update_at'] as DateTime),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurant_id': restaurantId,
      'id': id,
      'name': name,
      'pass': pass,
      'role': role.name,
      'status': status,
      'create_at': createAt,
      'update_at': updateAt,
    };
  }
}
