import 'package:flutter/material.dart';
import 'package:moya/data/models/blog_model.dart';
// Servis yolunu kontrol et
import 'package:moya/data/services/blog_service.dart';
import 'package:moya/presentation/screens/blog/widgets/recommendation_card.dart';

class ReadMoreSection extends StatelessWidget {
  final String currentPostId;

  const ReadMoreSection({super.key, required this.currentPostId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Okumaya Devam Et",
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Tümünü Gör", style: TextStyle(color: theme.colorScheme.primary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Bloc yerine doğrudan StreamBuilder kullanıyoruz
        StreamBuilder<List<BlogModel>>(
          stream: BlogService.getBlogsStream(), // Senin yazdığın servis metodu
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Bir hata oluştu");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox.shrink();
            }

            // Mevcut yazıyı listeden filtrele
            final otherPosts = snapshot.data!
                .where((post) => post.id != currentPostId)
                .toList();

            return SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: otherPosts.length,
                itemBuilder: (context, index) {
                  return RecommendationCard(post: otherPosts[index]);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}