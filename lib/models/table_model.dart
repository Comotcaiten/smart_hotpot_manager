enum StatusTable {inUse, empty, set}

class TableModel {
  String restaurantId;
  String id;
  String name;
  String pass;
  StatusTable status;
  DateTime createAt;
  DateTime updateAt;

  String get statusString => status.name;

  TableModel({
    required this.restaurantId,
    required this.id,
    required this.name,
    required this.pass,
    required this.status,
    required this.createAt,
    required this.updateAt,
  });

  factory TableModel.fromMap(Map<String, dynamic> data) {
    return TableModel(
      restaurantId: data['restaurant_id'] ?? '',
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      pass: data['pass'] ?? '',
      status: data['status'] ?? StatusTable.empty.name,
      createAt: (data['create_at'] as DateTime),
      updateAt: (data['update_at'] as DateTime),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurant_id': restaurantId,
      'id': id,
      'name': name,
      'pass': pass,
      'status': status,
      'create_at': createAt,
      'update_at': updateAt,
    };
  }
}
