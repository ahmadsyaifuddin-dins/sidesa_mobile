// Lokasi: lib/data/models/comment_model.dart

import 'user_model.dart';

class CommentModel {
  final int id;
  final int postId;
  final int userId;
  final int? parentId;
  final String content;
  final String createdAt;
  final UserModel? user;
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    this.parentId,
    required this.content,
    required this.createdAt,
    this.user,
    this.replies = const [],
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      postId: json['post_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      parentId: json['parent_id'],
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      
      // Map rekursif untuk balasan komentar (replies)
      replies: json['replies'] != null 
          ? (json['replies'] as List).map((e) => CommentModel.fromJson(e)).toList() 
          : [],
    );
  }
}