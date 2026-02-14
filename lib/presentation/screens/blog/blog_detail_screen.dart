import 'package:flutter/material.dart';
import 'package:moya/data/models/blog_model.dart';
import 'widgets/blog_app_bar.dart';
import 'widgets/blog_content_body.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogModel post;
  const BlogDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Arka plan rengini temanın ana rengine bağladık
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          BlogAppBar(post: post),
          SliverToBoxAdapter(
            child: BlogContentBody(post: post),
          ),
        ],
      ),
    );
  }
}