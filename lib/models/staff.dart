import 'package:smart_hotpot_manager/models/restaurant.dart';

class Staff {
  String restaurantId;
  String id;
  String name;
  String gmail;
  String pass;
  RoleAccount role;

  Staff({
    required this.restaurantId,
    required this.id,
    required this.name,
    required this.gmail,
    required this.pass,
    this.role = RoleAccount.staff,
  });

  factory Staff.fromMap(Map<String, dynamic> data) {
    return Staff(
      restaurantId: data['restaurant_id'] ?? '',
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      gmail: data['gmail'] ?? '',
      pass: data['pass'] ?? '',
      role: RoleAccount.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => RoleAccount.staff,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurant_id': restaurantId,
      'id': id,
      'name': name,
      'gmail': gmail,
      'pass': pass,
      'role': role.name,
    };
  }
}
