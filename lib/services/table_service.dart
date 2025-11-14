import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_hotpot_manager/models/table.dart';

class TableService {
  final CollectionReference tables =
      FirebaseFirestore.instance.collection('tables');

  // CREATE
  Future<void> addTable(TableModel table) async {
    final docRef = await tables.add(table.toMap());
    await tables.doc(docRef.id).update({'id': docRef.id});
  }

  // READ (tùy chọn)
  Stream<List<TableModel>> getAllTables(String restaurantId) {

    print(restaurantId);
    final data = tables.where("restaurant_id", isEqualTo: restaurantId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TableModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
    print("Data ${data.first}");
    return data;
  }

  // UPDATE
  Future<void> updateTable(TableModel table) async {
    await tables.doc(table.id).update(table.toMap());
  }

  // DELETE
  Future<void> deleteTable(String tableId) async {
    final tableRef = FirebaseFirestore.instance.collection('tables').doc(tableId);

    // 1. Lấy tất cả Order thuộc table này
    final orderSnap = await FirebaseFirestore.instance
        .collection('orders')
        .where('table_id', isEqualTo: tableId)
        .get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    // 2. Với mỗi Order xóa order_items trong sub-collection
    for (var orderDoc in orderSnap.docs) {
      final orderRef = orderDoc.reference;

      // Lấy các orrder_item trong sub-collection
      final itemsSnap = await orderRef.collection('order_items').get();

      // Xóa tất cả item
      for (var itemDoc in itemsSnap.docs) {
        batch.delete(itemDoc.reference);
      }

      // Xóa Order chính
      batch.delete(orderRef);
    }

    // 3. Xóa Table
    batch.delete(tableRef);

    // 4. Commit tất cả
    await batch.commit();
  }

}
