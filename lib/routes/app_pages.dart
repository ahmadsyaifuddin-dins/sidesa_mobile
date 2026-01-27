import 'package:get/get.dart';
import 'app_routes.dart';
import '../features/auth/views/login_view.dart';
import '../features/dashboard/views/dashboard_view.dart';
import '../features/splash/views/splash_view.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH; 

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
    ),
  ];
}