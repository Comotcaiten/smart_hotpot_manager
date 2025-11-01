class Product {
  String restaurantId;
  String id;
  String name;
  int price;
  String categoryId;
  bool delete;
  String imageUrl;
  DateTime createAt;
  DateTime updateAt;

  Product({
    required this.restaurantId,
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.delete,
    required this.imageUrl,
    required this.createAt,
    required this.updateAt,
  });

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      restaurantId: data['restaurantId'],
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
      categoryId: data['category_id'] ?? '',
      delete: data['delete'] ?? false,
      imageUrl: data['image_url'] ?? '',
      createAt: (data['create_at'] as DateTime),
      updateAt: (data['update_at'] as DateTime),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'id': id,
      'name': name,
      'price': price,
      'category_id': categoryId,
      'delete': delete,
      'image_url': imageUrl,
      'create_at': createAt,
      'update_at': updateAt,
    };
  }
}
