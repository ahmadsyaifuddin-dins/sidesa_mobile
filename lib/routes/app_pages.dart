import 'package:get/get.dart';
import 'app_routes.dart';
import '../features/auth/views/login_view.dart'; // Import View

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
    ),
    // Nanti Dashboard disini
  ];
}