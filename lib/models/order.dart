enum StatusOrder {pending, preparing, complete, served, paid}

class Order {
  String id;
  String restaurantId;
  String tableId;
  StatusOrder status; // Pending / Preparing / ...
  double totalAmount;
  DateTime createAt;
  DateTime updateAt;

  String get statusString => status.name;

  Order({
    required this.id,
    required this.restaurantId,
    required this.tableId,
    required this.status,
    required this.totalAmount,
    required this.createAt,
    required this.updateAt,
  });

  factory Order.fromMap(Map<String, dynamic> data) {
    return Order(
      id: data['id'] ?? '',
      restaurantId: data['restaurant_id'] ?? '',
      tableId: data['table_id'] ?? '',
      status: data['status'] ?? StatusOrder.pending.name,
      totalAmount: (data['total_amount'] ?? 0).toDouble(),
      createAt: (data['create_at'] as DateTime),
      updateAt: (data['update_at'] as DateTime),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'table_id': tableId,
      'status': status,
      'total_amount': totalAmount,
      'create_at': createAt,
      'update_at': updateAt,
    };
  }
}
