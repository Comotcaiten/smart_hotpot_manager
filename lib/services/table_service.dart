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
  Future<void> deleteTable(String id) async {
    await tables.doc(id).delete();
  }
}
