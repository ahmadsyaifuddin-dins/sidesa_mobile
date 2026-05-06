import 'package:get/get.dart';
import '../../../../core/services/pusher_service.dart';
import '../../../../data/models/user_model.dart';

class UserProfileController extends GetxController {
  late UserModel user;
  final PusherService _pusherService = Get.find<PusherService>();
  
  var isOnline = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Menerima data user yang dilempar dari halaman sebelumnya
    user = Get.arguments as UserModel;
    
    // Cek status online saat ini
    isOnline.value = _pusherService.onlineUserIds.contains(user.id);
    
    // Pantau terus secara real-time
    ever(_pusherService.onlineUserIds, (Set<int> onlineIds) {
      isOnline.value = onlineIds.contains(user.id);
    });
  }

  // Format tanggal bergabung
  String getJoinedDate() {
    if (user.createdAt.isEmpty) return 'Tidak diketahui';
    try {
      final date = DateTime.parse(user.createdAt).toLocal();
      final months = ['', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
      return "${date.day} ${months[date.month]} ${date.year}";
    } catch (e) {
      return 'Tidak diketahui';
    }
  }
}