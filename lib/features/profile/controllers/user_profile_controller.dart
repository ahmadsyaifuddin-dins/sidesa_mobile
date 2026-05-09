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
      bool isCurrentlyOnline = onlineIds.contains(user.id);
      
      if (isOnline.value == true && isCurrentlyOnline == false) {
        user.lastSeenAt = DateTime.now().toString(); 
      }
      
      isOnline.value = isCurrentlyOnline;
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

  String getLastSeen() {
    if (user.lastSeenAt == null || user.lastSeenAt!.isEmpty) return 'Belum diketahui';
    try {
      final date = DateTime.parse(user.lastSeenAt!).toLocal();
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
}