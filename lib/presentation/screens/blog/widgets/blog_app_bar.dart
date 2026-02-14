import 'package:flutter/material.dart';
import 'package:moya/data/models/blog_model.dart';

class BlogAppBar extends StatelessWidget {
  final BlogModel post;
  const BlogAppBar({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      elevation: 0,
      // AppBar arka planı, scroll edildiğinde temanın scaffold rengine bürünür
      backgroundColor: theme.scaffoldBackgroundColor,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black26,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(post.imageUrl, fit: BoxFit.cover),
            // Resimden içeriğe yumuşak geçiş sağlayan gradyan katmanı
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    theme.scaffoldBackgroundColor, // Temandaki ana koyu renk
                    theme.scaffoldBackgroundColor.withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.25, 0.6],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}