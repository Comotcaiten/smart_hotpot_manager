import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_hotpot_manager/models/staff.dart';
import 'package:smart_hotpot_manager/services/auth_service.dart';

class StaffService {

  final AuthService _authService = AuthService();

  final CollectionReference staffs =
      FirebaseFirestore.instance.collection('staff');

  // CREATE
  Future<void> addStaff(Staff staff) async {
    // 1. Tạo tài khoản nhân viên trong Firebase Auth
    final cred = await _authService.registerStaff(staff);

    // 2. Lấy nhà hàng hiện tại
    final restaurant = await _authService.getRestaurant();
    if (restaurant == null) throw Exception("Không tìm thấy nhà hàng.");

    // 3. Cập nhật thông tin staff
    staff.id = cred.user!.uid;
    staff.restaurantId = restaurant.id;

    // 4. Lưu vào Firestore
    await staffs.doc(staff.id).set({
      ...staff.toMap(),
    });
  }


  // READ (lọc theo restaurantId)
  Future<String> getIdRestaurant() async {
    final restaurant = await _authService.getRestaurant();
    if (restaurant == null) return "";
    return restaurant.id;
  }
  
  Stream<List<Staff>> getAllStaffsByRestaurant(String? restaurantId) {
    return staffs
        .where('restaurant_id', isEqualTo: restaurantId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Staff.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // UPDATE
  Future<void> updateStaff(String oldPass, Staff newStaff) async {
    // 1. Cập nhật trong Firebase Auth nếu có thay đổi email/pass
    await _authService.updateStaffAccount(
      email: newStaff.gmail,
      oldPassword: oldPass,
      newPassword: newStaff.pass != oldPass ? newStaff.pass : null,
    );

    // 2. Cập nhật thông tin trong Firestore
    await staffs.doc(newStaff.id).update(newStaff.toMap());
  }

  // DELETE
  Future<void> deleteStaff(Staff staff) async {
    // 1. Xóa trong Firestore
    await staffs.doc(staff.id).delete();

    // 2. Xóa tài khoản Auth
    await _authService.deleteStaffAccount(staff.gmail, staff.pass);
  }
}
