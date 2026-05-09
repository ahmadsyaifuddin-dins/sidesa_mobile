// Lokasi: lib/features/profile/user_profile_controller.dart

import 'package:get/get.dart';
import '../../../core/services/pusher_service.dart';
import '../../../data/models/user_model.dart';

class UserProfileController extends GetxController {
  late UserModel user;
  final PusherService _pusherService = Get.find<PusherService>();
  
  var isOnline = false.obs;

  @override
  void onInit() {
    super.onInit();
    user = Get.arguments as UserModel;
    
    isOnline.value = _pusherService.onlineUserIds.contains(user.id);
    
    ever(_pusherService.onlineUserIds, (Set<int> onlineIds) {
      isOnline.value = onlineIds.contains(user.id);
    });
  }

  String getLastSeen() {
    String? finalLastSeen = _pusherService.userLastSeenMap[user.id];
    
    finalLastSeen ??= user.lastSeenAt;

    if (finalLastSeen == null || finalLastSeen.isEmpty) return 'Belum diketahui';
    
    try {
      final date = DateTime.parse(finalLastSeen).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);

      final timeStr = "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

      if (diff.inDays == 0 && now.day == date.day) {
        return "Hari ini pukul $timeStr";
      } else if (diff.inDays == 1 || (diff.inDays == 0 && now.day != date.day)) {
        return "Kemarin pukul $timeStr";
      } else {
        return "${date.day}/${date.month}/${date.year} pukul $timeStr";
      }
    } catch (e) {
      return 'Belum diketahui';
    }
  }

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