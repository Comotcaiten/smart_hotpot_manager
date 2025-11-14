import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_hotpot_manager/models/account.dart';
import 'package:smart_hotpot_manager/widgets/modal_app.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference _accounts = FirebaseFirestore.instance.collection(
    'accounts',
  );

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
  Future<void> register(Account account, String? restaurantId) async {
    // 1. Tạo user trong Firebase Auth
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: account.gmail,
      password: account.pass,
    );

    // final now = DateTime.now();

    // 2. Lưu thông tin vào Firestore
    account.id = cred.user!.uid;

    if (account.role != RoleAccount.admin) {
      account.restaurantId = restaurantId!;
    } else {
      account.restaurantId = account.id;
    }

    final res = await _db.collection('accounts').doc(account.id).set({
      ...account.toMap(),
      // 'create_at': now,
      // 'update_at': now,
    });

    return res;
  }

  // Đăng nhập
  Future<Account?> login(String gmail, String pass) async {
    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: gmail,
      password: pass,
    );

    // Lấy dữ liệu từ Firestore
    final doc = await _db.collection('accounts').doc(cred.user!.uid).get();
    if (doc.exists) {
      return Account.fromMap(doc.data()!);
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
  Future<Account?> getAccout() async {
    final user = currentUser;
    // print("user: ${user}");
    if (user == null) return null;

    final docSnap = await _accounts.doc(user.uid).get();

    if (!docSnap.exists || docSnap.data() == null) return null;

    return Account.fromMap(docSnap.data() as Map<String, dynamic>);
  }

  Stream<List<InfoDropdown>> get roleNamesStream {
    return FirebaseFirestore.instance
        .collection('roles')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.where((doc) => doc['id'] != 'admin').map((doc) {
                return InfoDropdown(id: doc['id'], name: doc['name']);
              }).toList(),
        );
  }

  Future<String> getIdRestaurant() async {
    final restaurant = await getAccout();
    return restaurant!.restaurantId;
  }

  // Staff
  // Đăng ký tài khoản staff
  Future<UserCredential> registerStaff(Account staff) async {
    final secondaryAuth = await _getSecondaryAuth();
    final cred = await secondaryAuth.createUserWithEmailAndPassword(
      email: staff.gmail,
      password: staff.pass,
    );
    await secondaryAuth
        .signOut(); // dùng secondaryAuth để không ảnh hưởng đến currentUser chính

    // 2. Lấy nhà hàng hiện tại
    final restaurant = await getAccout();

    // 3. Cập nhật thông tin staff
    staff.id = cred.user!.uid;
    staff.restaurantId = restaurant!.id;

    // 4. Lưu vào Firestore
    await _accounts.doc(staff.id).set({...staff.toMap()});

    return cred;
  }

  Stream<List<Account>> getAllStaffsByRestaurant(String? restaurantId) {
    return _accounts
        .where('restaurant_id', isEqualTo: restaurantId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Account.fromMap(doc.data() as Map<String, dynamic>))
              .where(
                (acc) => acc.role.toString() != RoleAccount.admin.toString(),
              )
              .toList();
        });
  }

  // Xóa tài khoản staff
  Future<void> deleteStaffAccount(Account staff) async {
    // 1. Xóa trong Firestore
    _accounts.doc(staff.id).delete();

    // 2. Xóa tài khoản Auth
    final secondaryAuth = await _getSecondaryAuth();

    // Đăng nhập bằng tài khoản staff (cần biết pass)
    UserCredential cred = await secondaryAuth.signInWithEmailAndPassword(
      email: staff.gmail,
      password: staff.pass,
    );

    await cred.user!.delete(); // Xóa user trong Firebase Auth
    await secondaryAuth.signOut(); // Đăng xuất khỏi secondary app
  }

  // Cập nhật tài khoản staff
  Future<void> updateStaffAccount({required String oldPass, required Account newStaff}) async {
    // 1. Cập nhật trong Firebase Auth nếu có thay đổi email/pass
    final secondaryAuth = await _getSecondaryAuth();

    // Đăng nhập vào tài khoản staff cũ
    UserCredential cred = await secondaryAuth.signInWithEmailAndPassword(
      email: newStaff.gmail,
      password: oldPass,
    );

    // Cập nhật nếu có thay đổi, newStaff.pass == new password
    if (newStaff.pass.isNotEmpty &&
        newStaff.pass != oldPass) {
      await cred.user!.updatePassword(newStaff.pass);
    }

    await secondaryAuth.signOut();
    // 2. Cập nhật thông tin trong Firestore
    await _accounts.doc(newStaff.id).update(newStaff.toMap());
  }
}
