// import 'package:cloud_firestore/cloud_firestore.dart';

enum RoleAccount { none, admin, staff, table }

class Account {
  String id;
  String restaurantId;
  String name;
  String gmail;
  String pass;
  RoleAccount role;
  // DateTime createAt;
  // DateTime updateAt;

  Account({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.gmail,
    required this.pass,
    this.role = RoleAccount.admin,
    // required this.createAt,
    // required this.updateAt,
  });

  factory Account.fromMap(Map<String, dynamic> data) {
    return Account(
      id: data['id'] ?? '',
      restaurantId: data['restaurant_id'] ?? '',
      name: data['name'] ?? '',
      gmail: data['gmail'] ?? '',
      pass: data['pass'] ?? '',
      role: RoleAccount.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => RoleAccount.none,
      ),
      // createAt: (data['create_at'] as Timestamp).toDate(),
      // updateAt: (data['update_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'name': name,
      'gmail': gmail,
      'pass': pass,
      'role': role.name,
      // 'create_at': createAt,
      // 'update_at': updateAt,
    };
  }
}
