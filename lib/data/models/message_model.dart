import 'user_model.dart';

class MessageModel {
  final int id;
  final int senderId;
  final int receiverId;
  final String? message;
  final String? attachment;
  final bool isRead;
  final String createdAt;
  final UserModel? sender;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.message,
    this.attachment,
    required this.isRead,
    required this.createdAt,
    this.sender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      message: json['message'],
      attachment: json['attachment'],
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: json['created_at'] ?? '',
      sender: json['sender'] != null ? UserModel.fromJson({'data': {'user': json['sender']}}) : null,
    );
  }
}