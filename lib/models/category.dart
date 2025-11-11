class Category {
  String restaurantId;
  String id;
  String name;
  String description;
  bool delete;

  Category({
    required this.restaurantId,
    required this.id,
    required this.name,
    required this.description,
    required this.delete,
  });

  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      restaurantId: data['restaurantId'],
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      delete: data['delete'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'id': id,
      'name': name,
      'description': description,
      'delete': delete,
    };
  }
}
