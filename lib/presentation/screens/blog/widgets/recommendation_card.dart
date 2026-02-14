import 'package:flutter/material.dart';
import '../../../../data/models/blog_model.dart';
import '../blog_detail_screen.dart'; // BlogDetailScreen'in bulunduğu yolu kontrol et

class RecommendationCard extends StatelessWidget {
  final BlogModel post;
  const RecommendationCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () {
        // Detay sayfasından başka bir detay sayfasına geçerken 
        // yığın (stack) oluşturmamak için pushReplacement kullanıyoruz.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlogDetailScreen(post: post),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Küçük Resim
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                post.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                // İnternet hatalarına karşı koruma
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  width: double.infinity,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.broken_image, color: theme.hintColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.category.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}