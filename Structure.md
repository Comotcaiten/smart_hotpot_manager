lib/
│
├─ models/               ← class Product, Category, Order, ...
│
├─ services/             ← Firebase API gọi trực tiếp RealtimeDB/Firestore
│   ├─ product_service.dart
│   ├─ order_service.dart
│   └─ auth_service.dart
│
├─ repositories/         ← xử lý logic CRUD, mapping models
│   ├─ product_repository.dart
│   ├─ order_repository.dart
│   └─ table_repository.dart
│
├─ controllers/          ← điều khiển UI: GetX / Provider / BLoC
│   ├─ admin_controller.dart
│   ├─ staff_controller.dart
│   └─ table_controller.dart
│
├─ screens/              ← UI: phong cách tách chức năng
│   ├─ admin/
│   ├─ staff/
│   └─ table/
│
├─ widgets/              ← button, card UI tái sử dụng
│
└─ main.dart