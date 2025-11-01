class OrderItem {
  String id;
  String orderId;
  double price;
  int quantity;
  String note;
  DateTime createAt;
  DateTime updateAt;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.price,
    required this.quantity,
    required this.note,
    required this.createAt,
    required this.updateAt,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      id: data['id'] ?? '',
      orderId: data['order_id'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 0,
      note: data['note'] ?? '',
      createAt: (data['create_at'] as DateTime),
      updateAt: (data['update_at'] as DateTime),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'price': price,
      'quantity': quantity,
      'note': note,
      'create_at': createAt,
      'update_at': updateAt,
    };
  }
}
