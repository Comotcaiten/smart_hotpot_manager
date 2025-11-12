import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_hotpot_manager/models/restaurant.dart';
import 'package:smart_hotpot_manager/utils/app_routes.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference _restaurants = FirebaseFirestore.instance.collection('restaurants');

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
  Future<Restaurant?> getRestaurantById(String uid) async {
    final docRef = _restaurants.doc(uid);
    
    final docSnap = await docRef.get();

    return Restaurant.fromMap(docSnap.data() as Map<String, dynamic>);
  }
}
