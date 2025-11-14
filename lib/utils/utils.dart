class AppRoutes {
  static const String WELCOME = '/welcome';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String DASHBOARD = '/dashboard';
  static const String STAFF_HOME = '/staff_home';
  static const String TABLE = '/table';
  static const String MENU = '/menu';
}

// Regex pattern
class RegexPattern {
  static final nameRegex = RegExp(r'^[a-zA-ZÀ-ỹ0-9\s]+$'); // không ký tự đặc biệt
  static final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
}