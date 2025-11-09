class Category {
  String restaurantId;
  String id;
  String name;
  String icon;
  String amount;
  bool delete;

  Category({
    required this.restaurantId,
    required this.id,
    required this.name,
    required this.icon,
    required this.amount,
    required this.delete,
  });

  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      restaurantId: data['restaurantId'],
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      amount: data['amount'] ?? '',
      icon: data['icon'] ?? '',
      delete: data['delete'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'id': id,
      'name': name,
      'amount': amount,
      'icon': icon,
      'delete': delete,
    };
  }
}
