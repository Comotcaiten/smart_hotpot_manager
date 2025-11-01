class Restaurant {
  String id;
  String name;
  String gmail;
  String pass;
  DateTime createAt;
  DateTime updateAt;

  Restaurant({
    required this.id,
    required this.name,
    required this.gmail,
    required this.pass,
    required this.createAt,
    required this.updateAt,
  });

  factory Restaurant.fromMap(Map<String, dynamic> data) {
    return Restaurant(
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
      'id': id,
      'name': name,
      'gmail': gmail,
      'pass': pass,
      'create_at': createAt,
      'update_at': updateAt,
    };
  }
}
