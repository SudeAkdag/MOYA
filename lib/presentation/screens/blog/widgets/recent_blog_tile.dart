import 'package:flutter/material.dart';
import '../../../../data/models/blog_model.dart';

class RecentBlogTile extends StatelessWidget {
  final BlogModel post;
  const RecentBlogTile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(post.imageUrl, width: 85, height: 85, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.category, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary)),
                const SizedBox(height: 4),
                Text(post.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 2),
                const SizedBox(height: 4),
                Text("${post.author} • ${post.readTime}", style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border, size: 22)),
        ],
      ),
    );
  }
}