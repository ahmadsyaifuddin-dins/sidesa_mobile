import 'package:get/get.dart';
import 'package:sidesa_mobile/features/surat/views/detail_surat_view.dart';
import 'package:sidesa_mobile/features/timeline/views/create_post_view.dart';
import 'app_routes.dart';
import '../features/auth/views/login_view.dart';
import '../features/dashboard/views/dashboard_view.dart';
import '../features/splash/views/splash_view.dart';
import '../features/aduan/views/detail_aduan_view.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => const SplashView()),
    GetPage(name: Routes.LOGIN, page: () => const LoginView()),
    GetPage(name: Routes.DASHBOARD, page: () => const DashboardView()),
    GetPage(
      name: Routes.CREATE_POST,
      page: () => const CreatePostView(),
      fullscreenDialog: true, // Membuat animasinya muncul dari bawah ke atas (khas form input)
    ),
    GetPage(name: Routes.DETAIL_ADUAN, page: () => const DetailAduanView()),
    GetPage(name: Routes.DETAIL_ADUAN, page: () => const DetailAduanView()),
    GetPage(name: Routes.DETAIL_SURAT, page: () => const DetailSuratView()),
  ];
}
