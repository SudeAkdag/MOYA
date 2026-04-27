import 'package:flutter/material.dart';
import 'package:moya/data/services/blog_service.dart';
import 'package:moya/presentation/screens/recording/widgets/saved_blog_tile.dart';
import 'package:moya/presentation/screens/recording/widgets/saved_placeholder.dart'; 
import '../../../../data/models/blog_model.dart';

class RecordedScreen extends StatelessWidget {
  // Nisa branch'inden gelen zorunlu (required) menu fonksiyonu
  final VoidCallback onMenuTap; 
  final VoidCallback? onBack; // Geri butonu için

  const RecordedScreen({
    super.key, 
    required this.onMenuTap,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool canPop = Navigator.canPop(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () {
              if (canPop) {
                Navigator.pop(context);
              } else if (onBack != null) {
                onBack!();
              }
            },
          ),
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
              stream: BlogService.getSavedBlogsStream(), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final savedBlogs = snapshot.data ?? [];

                if (savedBlogs.isEmpty) {
                  return const EmptyStateView(
                    message: "Kaydedilmiş Blog Yazısı Bulunmuyor",
                    icon: Icons.article_outlined,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: savedBlogs.length,
                  itemBuilder: (context, index) {
                    return SavedBlogTile(post: savedBlogs[index]); 
                  },
                );
              },
            ),

            // --- 2. SEKMELİ EGZERSİZLER ---
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