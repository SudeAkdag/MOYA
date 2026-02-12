import 'package:flutter/material.dart';
import '../../../../data/models/blog_model.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogModel post;
  const BlogDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Üst Kapak Resmi
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(post.imageUrl, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.category.toUpperCase(), 
                       style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(post.title, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(child: Text(post.author[0])),
                      const SizedBox(width: 10),
                      Text("${post.author} • ${post.date}", style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const Divider(height: 40),
                  // Arkadaşının Araştırma Metni (icerik)
                  Text(post.content, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}