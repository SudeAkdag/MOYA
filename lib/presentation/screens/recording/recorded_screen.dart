import 'package:flutter/material.dart';
import 'package:moya/data/services/blog_service.dart';
import 'package:moya/presentation/screens/recording/widgets/saved_blog_tile.dart';
import 'package:moya/presentation/screens/recording/widgets/saved_placeholder.dart'; // EmptyStateView burada sanırım
import '../../../../data/models/blog_model.dart';


class RecordedScreen extends StatelessWidget {
  const RecordedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Kaydedilenler",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: theme.colorScheme.primary,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "Bloglar"),
              Tab(text: "Egzersizler"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- 1. SEKMELİ BLOGLAR LİSTESİ ---
            StreamBuilder<List<BlogModel>>(
              stream: BlogService.getSavedBlogsStream(), // Servisteki metodun
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final savedBlogs = snapshot.data ?? [];

                // Eğer liste boşsa senin widget'ını gösteriyoruz
                if (savedBlogs.isEmpty) {
                  return const EmptyStateView(
                    message: "Kaydedilmiş Blog Yazısı Bulunmuyor",
                    icon: Icons.article_outlined,
                  );
                }

                // Veri varsa listeliyoruz
                // RecordedScreen içindeki ListView kısmı:
return ListView.builder(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  itemCount: savedBlogs.length,
  itemBuilder: (context, index) {
    // BURAYI DEĞİŞTİRDİK
    return SavedBlogTile(post: savedBlogs[index]); 
  },
);
              },
            ),

            // --- 2. SEKMELİ EGZERSİZLER (Şimdilik Boş) ---
            const EmptyStateView(
              message: "Kaydedilmiş Egzersiz Bulunmuyor",
              icon: Icons.fitness_center_outlined,
            ),
          ],
        ),
      ),
    );
  }
}