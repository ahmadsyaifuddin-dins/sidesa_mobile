import 'user_model.dart';

class PostModel {
  final int id;
  final int userId;
  final String type; // 'pengumuman' atau 'aspirasi'
  final String content;
  final String? attachment;
  final bool isPinned;
  final int commentsCount;
  final String createdAt;
  final UserModel? user; // Relasi ke pembuat postingan

  PostModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.content,
    this.attachment,
    required this.isPinned,
    required this.commentsCount,
    required this.createdAt,
    this.user,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      type: json['type'] ?? 'aspirasi',
      content: json['content'] ?? '',
      attachment: json['attachment'],
      isPinned: json['is_pinned'] == 1 || json['is_pinned'] == true,
      commentsCount: json['comments_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      user: json['user'] != null ? UserModel.fromJson({'data': {'user': json['user']}}) : null,
    );
  }
}