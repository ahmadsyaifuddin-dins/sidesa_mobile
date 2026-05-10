import 'package:get/get.dart';
import 'package:sidesa_mobile/features/message/message/views/chat_room_view.dart';
import 'package:sidesa_mobile/features/message/message/views/contact_view.dart';
import 'package:sidesa_mobile/features/profile/views/user_profile_view.dart';
import 'package:sidesa_mobile/features/surat/views/detail_surat_view.dart';
import 'package:sidesa_mobile/features/timeline/views/create_post_view.dart';
import 'package:sidesa_mobile/features/timeline/views/post_detail_view.dart';

// 1. IMPORT BUAT SURAT VIEW DI SINI
import 'package:sidesa_mobile/features/buat_surat/views/buat_surat_view.dart';

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
      fullscreenDialog: true, 
    ),
    GetPage(
      name: Routes.POST_DETAIL,
      page: () => const PostDetailView(),
      transition: Transition.rightToLeft, 
    ),
    GetPage(name: Routes.DETAIL_ADUAN, page: () => const DetailAduanView()),
    // (Note: Aku hapus 1 baris DetailAduanView yang double di sini)
    
    GetPage(name: Routes.DETAIL_SURAT, page: () => const DetailSuratView()),
    
    // 2. DAFTARKAN RUTE BUAT SURAT DI SINI
    GetPage(
      name: Routes.BUAT_SURAT,
      page: () => const BuatSuratView(),
      transition: Transition.rightToLeft, // Animasi masuk dari kanan ke kiri
    ),

    GetPage(
      name: Routes.CONTACT,
      page: () => const ContactView(),
      transition: Transition.downToUp, 
    ),
    GetPage(
      name: Routes.CHAT_ROOM,
      page: () => const ChatRoomView(),
      transition: Transition.rightToLeft, 
    ),
    GetPage(
      name: Routes.USER_PROFILE,
      page: () => const UserProfileView(),
      transition: Transition.rightToLeft,
    ),
  ];
}