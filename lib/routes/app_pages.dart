import 'package:get/get.dart';
import 'app_routes.dart';
import '../features/auth/views/login_view.dart';
// Import Dashboard View
import '../features/dashboard/views/dashboard_view.dart'; 

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
    ),
    // --- Tambahkan Ini ---
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
    ),
  ];
}