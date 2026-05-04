import 'dart:convert';
import 'package:get/get.dart';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class PusherService extends GetxService {
  late PusherChannelsClient pusher;
  final _storage = const FlutterSecureStorage();
  
  // Pastikan ini sesuai dengan REVERB_APP_KEY di file .env Laravel kamu
  final String _reverbAppKey = "cqz8bkfmz42ckehd1iej"; 

  final Map<String, PrivateChannel> _activeChannels = {};

  Future<PusherService> init() async {
    print("🚀 Inisialisasi WebSocket Reverb via dart_pusher_channels (v1.2.3)...");
    try {
      String? token = await _storage.read(key: 'auth_token');
      if (token == null) return this; 

      // Ambil IP server dari ApiConfig.baseUrl
      String rawHost = ApiConfig.baseUrl.replaceAll('http://', '').split(':').first;

      final options = PusherChannelsOptions.fromHost(
        scheme: 'ws', 
        host: rawHost,
        port: 8080,
        key: _reverbAppKey,
        shouldSupplyMetadataQueries: true,
        metadata: PusherChannelsOptionsMetadata.byDefault(),
      );

      pusher = PusherChannelsClient.websocket(
        options: options,
        connectionErrorHandler: (error, trace, refresh) {
          print("❌ Reverb Connection Error: $error");
          refresh(); // Auto-reconnect jika putus
        },
      );

      pusher.onConnectionEstablished.listen((_) {
        print("✅ Reverb Berhasil Terhubung ke IP: $rawHost!");
      });

      pusher.connect();

    } catch (e) {
      print("❌ Gagal inisialisasi Reverb: $e");
    }
    return this;
  }

  Future<void> subscribeToPrivateChannel({
    required String channelName,
    required String eventName,
    required Function(Map<String, dynamic>) onEvent,
  }) async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) return;

    final authorizationDelegate = EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
      authorizationEndpoint: Uri.parse("${ApiConfig.baseHost}/broadcasting/auth"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final channel = pusher.privateChannel(
      "private-$channelName", 
      authorizationDelegate: authorizationDelegate,
    );

    _activeChannels[channelName] = channel;

    // FIX 2: Di versi 1.2.3 cukup menggunakan subscribe()
    channel.subscribe();

    channel.bind(eventName).listen((event) {
      if (event.data != null) {
        final Map<String, dynamic> decodedData = jsonDecode(event.data!);
        onEvent(decodedData);
      }
    });

    print("🎧 Subscribed ke Channel: private-$channelName | Menunggu Event: $eventName");
  }

  void unsubscribe(String channelName) {
    if (_activeChannels.containsKey(channelName)) {
      _activeChannels[channelName]?.unsubscribe();
      _activeChannels.remove(channelName);
      print("🔇 Unsubscribed dari: private-$channelName");
    }
  }
  
  @override
  void onClose() {
    pusher.disconnect();
    super.onClose();
  }
}