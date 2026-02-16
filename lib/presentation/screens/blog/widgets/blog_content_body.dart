import 'package:flutter/material.dart';
import 'package:moya/data/models/blog_model.dart';
import 'package:moya/presentation/screens/blog/widgets/read_more_section.dart';

class BlogContentBody extends StatelessWidget {
  final BlogModel post;
  const BlogContentBody({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      transform: Matrix4.translationValues(0, -40, 0),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40), 

          // Kategori ve Okuma Süresi
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  post.category.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                post.readTime,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          
          // Makale Başlığı
          Text(
            post.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 15),

          // Giriş/Özet Metni - İKİ YANA YASLANDI
          Text(
            post.description,
            textAlign: TextAlign.justify, // Satır sonlarını düzeltir
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.6,
            ),
          ),
          
          const SizedBox(height: 20),
          const Divider(thickness: 0.8), 
          const SizedBox(height: 20),
          
          // Ana İçerik Metni - İKİ YANA YASLANDI
          Text(
            post.content,
            textAlign: TextAlign.justify, // Satır sonlarını düzeltir
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6, // Okunabilirliği artırmak için biraz artırıldı
              fontSize: 16,
            ),
          ),
          
          const SizedBox(height: 30),
          
          _buildAuthorCard(theme),
          const SizedBox(height: 20),
          ReadMoreSection(currentPostId: post.id ?? ''),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildAuthorCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            child: Icon(Icons.person, color: theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.author, 
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.chevron_right, color: theme.hintColor, size: 20),
        ],
      ),
    );
  }
}