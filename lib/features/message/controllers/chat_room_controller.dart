// Lokasi: lib/features/message/controllers/chat_room_controller.dart

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sidesa_mobile/features/auth/data/auth_repository.dart';
import 'package:sidesa_mobile/features/message/controllers/inbox_controller.dart';
import 'package:sidesa_mobile/routes/app_routes.dart';

import '../../../data/models/message_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/message_repository.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/services/pusher_service.dart';

class ChatRoomController extends GetxController {
  final MessageRepository _repo = MessageRepository();
  final AuthRepository _authRepo = AuthRepository();
  final PusherService _pusherService = Get.find<PusherService>();
 
  late UserModel opponent;
  var currentUserId = 0.obs;

  var messages = <MessageModel>[].obs;
  var isLoading = true.obs;
  var isSending = false.obs;
 
  // Status Indicator Variables
  var isOpponentOnline = false.obs;
  var isOpponentTyping = false.obs;
  Timer? _typingTimer;
  DateTime? _lastTypingTime;

  // MEMORI PENANGKAL BUG 1 CENTANG (RACE CONDITION)
  final Set<int> _confirmedReadIds = {};
  final Set<int> _confirmedDeliveredIds = {};

  final TextEditingController messageC = TextEditingController();
  final ScrollController scrollController = ScrollController();
  var selectedImage = Rxn<File>();

  String get chatChannelName => 'chat.${currentUserId.value}';

  @override
  void onInit() {
    super.onInit();
    opponent = Get.arguments as UserModel;
    _initializeData();
    messageC.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (messageC.text.isNotEmpty) {
      final now = DateTime.now();
      if (_lastTypingTime == null || now.difference(_lastTypingTime!).inSeconds >= 1) {
        _lastTypingTime = now;
        _pusherService.sendWhisperTyping(currentUserId.value, opponent.id);
      }
    }
  }

  Future<void> _initializeData() async {
    try {
      final user = await _authRepo.getProfile();
      currentUserId.value = user.id;
     
      // Langsung laporkan pesan telah dibaca saat pertama kali buka chat
      _repo.markAsRead(opponent.id);

      await fetchMessages();
      _listenToRealtimeMessages();

      isOpponentOnline.value = _pusherService.onlineUserIds.contains(opponent.id);
      ever(_pusherService.onlineUserIds, (Set<int> onlineIds) {
        isOpponentOnline.value = onlineIds.contains(opponent.id);
      });

      ever(_pusherService.userTypingToMe, (int typingUserId) {
        if (typingUserId == opponent.id) {
          isOpponentTyping.value = true;
         
          _typingTimer?.cancel();
          _typingTimer = Timer(const Duration(seconds: 2), () {
            isOpponentTyping.value = false;
            _pusherService.userTypingToMe.value = 0; 
          });
        }
      });
    } catch (e) {}
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      final data = await _repo.getConversation(opponent.id);
      messages.assignAll(data.map((e) => MessageModel.fromJson(e)).toList());
      _scrollToBottom();
    } catch (e) {
      SnackbarHelper.error(title: "Error", message: "Gagal memuat obrolan.");
    } finally {
      isLoading.value = false;
    }
  }

  // --- FUNGSI MEMANTAU WEBSOCKET REALTIME ---
  void _listenToRealtimeMessages() {
   
    // 📡 1. RADAR PESAN MASUK
    _pusherService.subscribeToPrivateChannel(
      channelName: chatChannelName,
      eventName: 'App\\Events\\MessageSent',
      onEvent: (data) {
        if (data['message'] != null) {
          final incomingMsg = MessageModel.fromJson(data['message']);

          if (incomingMsg.senderId == opponent.id) {
            messages.add(incomingMsg);
            _scrollToBottom();        
           
            if (Get.currentRoute == Routes.CHAT_ROOM) {
               _repo.markAsRead(opponent.id);
            }
            
          } else {
            SnackbarHelper.success(
              title: "Pesan Baru",
              message: "Pesan dari ${incomingMsg.sender?.name ?? 'Seseorang'}",
            );
          }
        }
      },
    );

    // 📡 2. RADAR CENTANG BIRU (Pesan kita dibaca lawan)
    _pusherService.subscribeToPrivateChannel(
      channelName: chatChannelName,
      eventName: 'App\\Events\\MessageRead',
      onEvent: (data) {
        if (data['message_ids'] != null) {
          List<int> readIds = (data['message_ids'] as List).map((e) => int.parse(e.toString())).toList();
          _confirmedReadIds.addAll(readIds); // Simpan ke memori jaga-jaga!

          bool isUpdated = false;
          for (int i = 0; i < messages.length; i++) {
            if (readIds.contains(messages[i].id) && messages[i].status != 'read') {
              messages[i].status = 'read'; 
              isUpdated = true;
            }
          }

          if (isUpdated) {
            messages.refresh(); 
          }
        }
      },
    );

    // 📡 3. RADAR DELIVERED (Pesan sampai ke HP lawan tapi belum dibaca)
    _pusherService.subscribeToPrivateChannel(
      channelName: chatChannelName,
      eventName: 'App\\Events\\MessageDelivered',
      onEvent: (data) {
        if (data['message_ids'] != null) {
          List<int> deliveredIds = (data['message_ids'] as List).map((e) => int.parse(e.toString())).toList();
          _confirmedDeliveredIds.addAll(deliveredIds); // Simpan ke memori jaga-jaga!

          bool isUpdated = false;
          for (int i = 0; i < messages.length; i++) {
            if (deliveredIds.contains(messages[i].id) && messages[i].status == 'sent') {
              messages[i].status = 'delivered'; 
              isUpdated = true;
            }
          }

          if (isUpdated) {
            messages.refresh();
          }
        }
      },
    );
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void cancelImage() {
    selectedImage.value = null;
  }

  Future<void> sendMessage() async {
    if (messageC.text.trim().isEmpty && selectedImage.value == null) return;

    try {
      isSending.value = true;
      final newMsgData = await _repo.sendMessage(
        opponent.id,
        messageC.text.trim(),
        attachmentFile: selectedImage.value
      );
     
      final newMsg = MessageModel.fromJson(newMsgData);
      
      // PENANGKAL BUG 1 CENTANG (RACE CONDITION)
      // Ngecek apakah lawan udah terlanjur ngebaca pesannya saat HP kita masih loading API?
      if (_confirmedReadIds.contains(newMsg.id)) {
        newMsg.status = 'read';
      } else if (_confirmedDeliveredIds.contains(newMsg.id)) {
        newMsg.status = 'delivered';
      }

      messages.add(newMsg);
     
      messageC.clear();
      cancelImage();
      _scrollToBottom();
    } catch (e) {
      SnackbarHelper.error(title: "Gagal Kirim", message: e.toString());
    } finally {
      isSending.value = false;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 300,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageC.dispose();
    scrollController.dispose();
    _typingTimer?.cancel();
    if (Get.isRegistered<InboxController>()) {
      Get.find<InboxController>().fetchInbox();
    }
   
    super.onClose();
  }
}