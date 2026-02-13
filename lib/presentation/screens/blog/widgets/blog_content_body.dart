
import 'package:flutter/material.dart';
import 'package:moya/data/models/blog_model.dart';



class BlogContentBody extends StatelessWidget {
  final BlogModel post;
  const BlogContentBody({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      transform: Matrix4.translationValues(0, -30, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       
          const SizedBox(height: 16),
          Text(
            post.title,
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          const Divider(height: 40),
          Text(
            post.content,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.8),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}