class Category {
  String restaurantId;
  String id;
  String name;
  String icon;
  bool delete;

  Category({
    required this.restaurantId,
    required this.id,
    required this.name,
    required this.icon,
    required this.delete,
  });

  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      restaurantId: data['restaurantId'],
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      icon: data['icon'] ?? '',
      delete: data['delete'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'id': id,
      'name': name,
      'icon': icon,
      'delete': delete,
    };
  }
}
