// Lokasi: lib/core/services/pusher_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sidesa_mobile/data/models/message_model.dart';
import 'package:sidesa_mobile/data/repositories/message_repository.dart';
import 'package:sidesa_mobile/features/auth/data/auth_repository.dart';
import 'package:sidesa_mobile/features/message/controllers/inbox_controller.dart';
import '../config/api_config.dart';

class PusherService extends GetxService with WidgetsBindingObserver {
  late PusherChannelsClient pusher;
  final _storage = const FlutterSecureStorage();
  final String _reverbAppKey = "cqz8bkfmz42ckehd1iej";
  final Map<String, PrivateChannel> _activeChannels = {};
  PresenceChannel? myPresenceChannel;

  // Radar Global Online & Typing
  final RxSet<int> onlineUserIds = <int>{}.obs;
  final RxInt userTypingToMe = 0.obs;

  // SISTEM RADAR REACTIVE BARU (GetX Event Bus)
  final Rx<MessageModel?> incomingMessage = Rx<MessageModel?>(null);
  final Rx<List<int>> readMessageIds = Rx<List<int>>([]);
  final Rx<List<int>> deliveredMessageIds = Rx<List<int>>([]);

  // MEMORI PENCEGAH RACE CONDITION (Bug Centang 1)
  final Set<int> confirmedReadIds = {};
  final Set<int> confirmedDeliveredIds = {};

  // 1. PASANG CCTV DI onInit
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this); // Mengaktifkan detektor layar saat aplikasi dibuka
  }

  Future<PusherService> init() async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      if (token == null) return this;

      String rawHost = ApiConfig.baseUrl.replaceAll('http://', '').split(':').first;

      final options = PusherChannelsOptions.fromHost(
        scheme: 'ws', host: rawHost, port: 8080, key: _reverbAppKey,
        shouldSupplyMetadataQueries: true, metadata: PusherChannelsOptionsMetadata.byDefault(),
      );

      pusher = PusherChannelsClient.websocket(
        options: options,
        connectionErrorHandler: (error, trace, refresh) => refresh(),
      );

      pusher.onConnectionEstablished.listen((_) {
        _joinPresenceChannel();
        _initTrueGlobalRadar();
      });

      pusher.connect();
    } catch (e) {}
    return this;
  }

  Future<void> _initTrueGlobalRadar() async {
    try {
      final user = await AuthRepository().getProfile();
      final channelName = 'chat.${user.id}';
     
      // 📡 1. RADAR PESAN MASUK
      subscribeToPrivateChannel(
        channelName: channelName,
        eventName: 'App\\Events\\MessageSent',
        onEvent: (data) {
          if (data['message'] != null) {
            final msg = MessageModel.fromJson(data['message']);
            incomingMessage.value = msg; // Pemicu Otomatis ChatRoom
            incomingMessage.refresh();
           
            // Lapor Delivered ke Server
            try { MessageRepository().markAsDelivered(msg.senderId); } catch (e) {}
            if (Get.isRegistered<InboxController>()) Get.find<InboxController>().fetchInbox();
          }
        }
      );

      // 📡 2. RADAR CENTANG BIRU
      subscribeToPrivateChannel(
        channelName: channelName,
        eventName: 'App\\Events\\MessageRead',
        onEvent: (data) {
          if (data['message_ids'] != null) {
            List<int> ids = (data['message_ids'] as List).map((e) => int.parse(e.toString())).toList();
            confirmedReadIds.addAll(ids); // Simpan di memori anti-bug
            readMessageIds.value = ids; // Pemicu Otomatis ChatRoom
            readMessageIds.refresh();
            if (Get.isRegistered<InboxController>()) Get.find<InboxController>().fetchInbox();
          }
        }
      );

      // 📡 3. RADAR CENTANG 2 ABU
      subscribeToPrivateChannel(
        channelName: channelName,
        eventName: 'App\\Events\\MessageDelivered',
        onEvent: (data) {
          if (data['message_ids'] != null) {
            List<int> ids = (data['message_ids'] as List).map((e) => int.parse(e.toString())).toList();
            confirmedDeliveredIds.addAll(ids); // Simpan di memori anti-bug
            deliveredMessageIds.value = ids; // Pemicu Otomatis ChatRoom
            deliveredMessageIds.refresh();
            if (Get.isRegistered<InboxController>()) Get.find<InboxController>().fetchInbox();
          }
        }
      );
    } catch (e) {}
  }

  Future<void> subscribeToPrivateChannel({required String channelName, required String eventName, required Function(Map<String, dynamic>) onEvent}) async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) return;

    PrivateChannel? channel = _activeChannels[channelName] as PrivateChannel?;
    if (channel == null) {
      final authDelegate = EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
        authorizationEndpoint: Uri.parse("${ApiConfig.baseHost}/api/broadcasting/auth"),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );
      channel = pusher.privateChannel("private-$channelName", authorizationDelegate: authDelegate);
      _activeChannels[channelName] = channel;
      channel.subscribe();
    }

    channel.bind(eventName).listen((event) {
      if (event.data != null) onEvent(jsonDecode(event.data!));
    });
  }
 
  Future<void> _joinPresenceChannel() async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) return;
    final authorizationDelegate = EndpointAuthorizableChannelTokenAuthorizationDelegate.forPresenceChannel(
      authorizationEndpoint: Uri.parse("${ApiConfig.baseHost}/api/broadcasting/auth"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    final channel = pusher.presenceChannel("presence-sidesa.presence", authorizationDelegate: authorizationDelegate);
    channel.subscribe();
    myPresenceChannel = channel;
    channel.bind('client-typing').listen((event) {
      if (event.data != null) {
        try {
          final data = (event.data.runtimeType == String) ? jsonDecode(event.data!) : event.data;
          userTypingToMe.value = int.parse(data['from_id'].toString());
          userTypingToMe.refresh();
        } catch(e) {}
      }
    });
    channel.bind('pusher:subscription_succeeded').listen((event) {
      if (event.data != null) {
        try {
          final data = jsonDecode(event.data!);
          final members = data['presence']['hash'] as Map<String, dynamic>;
          onlineUserIds.clear();
          for (var key in members.keys) { onlineUserIds.add(int.parse(key)); }
          onlineUserIds.refresh();
        } catch(e) {}
      }
    });
    channel.bind('pusher:member_added').listen((event) {
      if (event.data != null) {
        try {
          final data = jsonDecode(event.data!);
          onlineUserIds.add(int.parse(data['user_id'].toString()));
          onlineUserIds.refresh();
        } catch(e) {}
      }
    });
    channel.bind('pusher:member_removed').listen((event) {
      if (event.data != null) {
        try {
          final data = jsonDecode(event.data!);
          onlineUserIds.remove(int.parse(data['user_id'].toString()));
          onlineUserIds.refresh();
        } catch(e) {}
      }
    });
  }

  void sendWhisperTyping(int myId, int opponentId) {
    if (myPresenceChannel != null) {
      myPresenceChannel!.trigger(eventName: 'client-typing', data: {'from_id': myId, 'to_id': opponentId});
    }
  }

  void unsubscribe(String channelName) {
    if (_activeChannels.containsKey(channelName)) {
      _activeChannels[channelName]?.unsubscribe();
      _activeChannels.remove(channelName);
    }
  }

  // 2. FUNGSI AJAIB: MENDETEKSI PERUBAHAN LAYAR
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Jika aplikasi di-minimize (paused) atau ditutup (detached)
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Lapor ke Laravel kalau user ini sedang offline sekarang!
      MessageRepository().updateLastSeen();
    }
  }

  @override
  void onClose() {
    // 3. CABUT CCTV SAAT SERVICE MATI
    WidgetsBinding.instance.removeObserver(this); 
    pusher.disconnect();
    super.onClose();
  }
}