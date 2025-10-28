lib/
├── main.dart
├── common/             # Widgets, constants, utils dùng chung
│   ├── widgets/
│   └── constants/
├── data/
│   ├── models/         # Các file model: user.dart, food.dart, order.dart...
│   └── services/       # Các dịch vụ: auth_service.dart, database_service.dart...
├── features/           # Phân chia theo vai trò hoặc tính năng
│   ├── admin/
│   │   ├── screens/
│   │   └── widgets/
│   ├── staff/
│   │   ├── screens/
│   │   └── widgets/
│   └── table/
│       ├── screens/
│       └── widgets/
└── auth/               # Màn hình, logic đăng nhập, đăng ký
    ├── screens/
    └── widgets/