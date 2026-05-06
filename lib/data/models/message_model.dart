// Lokasi: lib/data/models/message_model.dart

import 'user_model.dart';

class MessageModel {
  final int id;
  final int senderId;
  final int receiverId;
  final String? message;
  final String? attachment;
  String status;
  final String createdAt;
  final UserModel? sender;
  final UserModel? receiver;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.message,
    this.attachment,
    required this.status,
    required this.createdAt,
    this.sender,
    this.receiver,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      senderId: json['sender_id'] != null ? int.tryParse(json['sender_id'].toString()) ?? 0 : 0,
      receiverId: json['receiver_id'] != null ? int.tryParse(json['receiver_id'].toString()) ?? 0 : 0,
      
      message: json['message'],
      attachment: json['attachment'],
      status: json['status'] ?? 'sent',
      createdAt: json['created_at'] ?? '',
      sender: json['sender'] != null ? UserModel.fromJson(json['sender']) : null,
      receiver: json['receiver'] != null ? UserModel.fromJson(json['receiver']) : null,
    );
  }
}