import 'package:flutter/material.dart';
import '../../../../data/models/blog_model.dart';
import 'widgets/blog_app_bar.dart';
import 'widgets/blog_content_body.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogModel post;
  const BlogDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          BlogAppBar(post: post), // Üst kısım (Resim)
          SliverToBoxAdapter(
            child: BlogContentBody(post: post), // Alt kısım (Yazı)
          ),
        ],
      ),
    );
  }
}