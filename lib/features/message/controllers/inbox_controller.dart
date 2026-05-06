// Lokasi: lib/features/message/controllers/inbox_controller.dart

import 'package:get/get.dart';
import 'package:sidesa_mobile/features/auth/data/auth_repository.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/message_repository.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/services/pusher_service.dart'; 

class InboxController extends GetxController {
  final MessageRepository _repo = MessageRepository();
  final AuthRepository _authRepo = AuthRepository();
  final PusherService _pusherService = Get.find<PusherService>();

  var inboxList = <MessageModel>[].obs;
  var isLoading = true.obs;
  var currentUserId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchCurrentUser();
    await fetchInbox();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final user = await _authRepo.getProfile();
      currentUserId.value = user.id;
    } catch (e) {
      print("Gagal mengambil data user");
    }
  }

  Future<void> fetchInbox() async {
    try {
      // Kita matikan indikator loading kalau ini cuma auto-refresh dari background
      if (inboxList.isEmpty) isLoading.value = true; 
      
      final data = await _repo.getInbox();
      inboxList.assignAll(data.map((e) => MessageModel.fromJson(e)).toList());
    } catch (e) {
      SnackbarHelper.error(title: "Error", message: "Gagal memuat pesan.");
    } finally {
      isLoading.value = false;
    }
  }

  UserModel? getOpponent(MessageModel msg) {
    if (msg.senderId == currentUserId.value) {
      return msg.receiver;
    } else {
      return msg.sender;
    }
  }
}