// import 'package:cloud_firestore/cloud_firestore.dart';

// enum Account {none, admin, staff, table}
// class Restaurant {
//   String id;
//   String restaurantId;
//   String name;
//   String gmail;
//   String pass;
//   RoleAccount role;
//   // DateTime createAt;
//   // DateTime updateAt;

//   Restaurant({
//     required this.id,
//     required this.restaurantId,
//     required this.name,
//     required this.gmail,
//     required this.pass,
//     this.role = RoleAccount.admin,
//     // required this.createAt,
//     // required this.updateAt,
//   });

//   factory Restaurant.fromMap(Map<String, dynamic> data) {
//     return Restaurant(
//       id: data['id'] ?? '',
//       name: data['name'] ?? '',
//       gmail: data['gmail'] ?? '',
//       pass: data['pass'] ?? '',
//       role: RoleAccount.values.firstWhere(
//         (e) => e.name == data['role'],
//         orElse: () => RoleAccount.admin,
//       ),
//       // createAt: (data['create_at'] as Timestamp).toDate(),
//       // updateAt: (data['update_at'] as Timestamp).toDate(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'gmail': gmail,
//       'pass': pass,
//       'role': role.name,
//       // 'create_at': createAt,
//       // 'update_at': updateAt,
//     };
//   }
// }
