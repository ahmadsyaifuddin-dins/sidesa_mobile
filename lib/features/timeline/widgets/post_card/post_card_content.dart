import 'package:flutter/material.dart';

class PostCardContent extends StatelessWidget {
  final String content;

  const PostCardContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content, 
      style: const TextStyle(fontSize: 14, height: 1.4)
    );
  }
}