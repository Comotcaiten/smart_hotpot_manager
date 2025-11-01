class Staff {
  String restaurantId;
  String id;
  String name;
  String gmail;
  String pass;
  DateTime createAt;
  DateTime updateAt;

  Staff({
    required this.restaurantId,
    required this.id,
    required this.name,
    required this.gmail,
    required this.pass,
    required this.createAt,
    required this.updateAt,
  });

  factory Staff.fromMap(Map<String, dynamic> data) {
    return Staff(
      restaurantId: data['restaurant_id'] ?? '',
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      gmail: data['gmail'] ?? '',
      pass: data['pass'] ?? '',
      createAt: (data['create_at'] as DateTime),
      updateAt: (data['update_at'] as DateTime),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurant_id': restaurantId,
      'id': id,
      'name': name,
      'gmail': gmail,
      'pass': pass,
      'create_at': createAt,
      'update_at': updateAt,
    };
  }
}
