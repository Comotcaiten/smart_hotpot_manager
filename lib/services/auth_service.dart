import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_hotpot_manager/models/restaurant.dart';
import 'package:smart_hotpot_manager/models/staff.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference _restaurants = FirebaseFirestore.instance.collection('restaurants');

  // Tạo FirebaseApp phụ cho việc đăng ký Staff
  Future<FirebaseAuth> _getSecondaryAuth() async {
    FirebaseApp? secondaryApp;

    try {
      secondaryApp = Firebase.app('Secondary');
    } catch (e) {
      secondaryApp = await Firebase.initializeApp(
        name: 'Secondary',
        options: Firebase.app().options,
      );
    }

    return FirebaseAuth.instanceFor(app: secondaryApp);
  }

  // Đăng ký tài khoản mới
  Future<void> register(Restaurant restaurant) async {
    // 1. Tạo user trong Firebase Auth
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: restaurant.gmail,
      password: restaurant.pass,
    );

    final now = DateTime.now();

    // 2. Lưu thông tin vào Firestore
    restaurant.id = cred.user!.uid;
    final res = await _db.collection('restaurants').doc(restaurant.id).set({
      ...restaurant.toMap(),
      'create_at': now,
      'update_at': now,
    });

    return res;
  }

  // Đăng nhập
  Future<Restaurant?> login(String gmail, String pass) async {
    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: gmail,
      password: pass,
    );

    // Lấy dữ liệu từ Firestore
    final doc = await _db.collection('restaurants').doc(cred.user!.uid).get();
    if (doc.exists) {
      return Restaurant.fromMap(doc.data()!);
    }
    return null;
  }

  // Đăng xuất
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Kiểm tra user hiện tại
  User? get currentUser => _auth.currentUser;

  // Get Restaurant
  Future<Restaurant?> getRestaurant() async {
    final user = currentUser;
    if (user == null) return null;

    final docSnap = await _restaurants.doc(user.uid).get();
    
    if (!docSnap.exists || docSnap.data() == null) return null;

    return Restaurant.fromMap(docSnap.data() as Map<String, dynamic>);
  }

  // Staff
  // Đăng ký tài khoản staff
  Future<UserCredential> registerStaff(Staff staff) async {
    final secondaryAuth = await _getSecondaryAuth();
    final cred = await secondaryAuth.createUserWithEmailAndPassword(
      email: staff.gmail,
      password: staff.pass,
    );
    await secondaryAuth.signOut(); // dùng secondaryAuth để không ảnh hưởng đến currentUser chính
    return cred;
  }

  Future<Staff?> loginStaff(String gmail, String pass) async {
    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: gmail,
      password: pass,
    );

    // Lấy dữ liệu từ Firestore
    final doc = await _db.collection('staffs').doc(cred.user!.uid).get();
    if (doc.exists) {
      return Staff.fromMap(doc.data()!);
    }
    return null;
  }
  
  // Xóa tài khoản staff
  Future<void> deleteStaffAccount(String gmail, String password) async {
    final secondaryAuth = await _getSecondaryAuth();

    // Đăng nhập bằng tài khoản staff (cần biết pass)
    UserCredential cred = await secondaryAuth.signInWithEmailAndPassword(
      email: gmail,
      password: password,
    );

    await cred.user!.delete(); // Xóa user trong Firebase Auth
    await secondaryAuth.signOut(); // Đăng xuất khỏi secondary app
  }
  // Cập nhật tài khoản staff
  Future<void> updateStaffAccount({
    required String email,
    required String oldPassword,
    String? newPassword,
  }) async {
    final secondaryAuth = await _getSecondaryAuth();

    // Đăng nhập vào tài khoản staff cũ
    UserCredential cred = await secondaryAuth.signInWithEmailAndPassword(
      email: email,
      password: oldPassword,
    );

    // Cập nhật nếu có thay đổi

    if (newPassword != null && newPassword.isNotEmpty && newPassword != oldPassword) {
      await cred.user!.updatePassword(newPassword);
    }

    await secondaryAuth.signOut();
  }

}
