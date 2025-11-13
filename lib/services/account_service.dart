// lib/services/account_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_hotpot_manager/models/staff.dart';

class AccountService {
  // Đặt tên collection là 'staffs' (số nhiều của model 'Staff')
  final CollectionReference staffs =
      FirebaseFirestore.instance.collection('staffs');

  // CREATE: Thêm tài khoản
  Future<void> addAccount(Staff staff) async {
    final docRef = await staffs.add(staff.toMap());
    await staffs.doc(docRef.id).update({'id': docRef.id});
  }

  // READ: Lấy tất cả tài khoản
  Stream<List<Staff>> getAllAccounts() {
    return staffs.orderBy('name').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Staff.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // UPDATE: Cập nhật tài khoản
  Future<void> updateAccount(Staff staff) async {
    await staffs.doc(staff.id).update(staff.toMap());
  }

  // DELETE: Xóa tài khoản
  Future<void> deleteAccount(String id) async {
    await staffs.doc(id).delete();
  }
}