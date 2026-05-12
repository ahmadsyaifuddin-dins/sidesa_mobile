import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/config/api_config.dart';

class PostCardAttachment extends StatelessWidget {
  final String attachmentPath;

  const PostCardAttachment({super.key, required this.attachmentPath});

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Get.to(
      () => Scaffold(
        backgroundColor: Colors.black, 
        appBar: AppBar(backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white), elevation: 0),
        body: Center(
          child: InteractiveViewer(
            panEnabled: true, minScale: 0.5, maxScale: 4.0, 
            child: Image.network(imageUrl, fit: BoxFit.contain, width: double.infinity, height: double.infinity),
          ),
        ),
      ),
      fullscreenDialog: true,
      transition: Transition.fadeIn, 
    );
  }

  @override
  Widget build(BuildContext context) {
    final String fullUrl = "${ApiConfig.baseHost}/$attachmentPath";

    return GestureDetector(
      onTap: () => _showFullScreenImage(context, fullUrl),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          fullUrl,
          width: double.infinity, fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(height: 150, color: Colors.grey.shade200, child: const Icon(Icons.broken_image))
        ),
      ),
    );
  }
}