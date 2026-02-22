import 'package:flutter/material.dart';
import '../../../../data/models/blog_model.dart';
import '../../../../data/services/blog_service.dart';
import 'widgets/blog_card.dart'; 
import 'widgets/category_selector.dart';
import 'widgets/recent_blog_tile.dart';

class BlogScreen extends StatefulWidget {
  final void Function() onMenuTap;
  const BlogScreen({super.key, required this.onMenuTap});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  String selectedCategory = "Tümü";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Arka planı MainWrapper'dan devralması için şeffaf veya null bırakıyoruz
      backgroundColor: Colors.transparent, 
      appBar: AppBar(
        // BAŞLIĞI TAM ORTALIYORUZ
        centerTitle: true, 
        title: Text(
          'Bilgi ve Farkındalık',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black, // Temaya göre theme.colorScheme.onSurface de olabilir
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // SOL ÜST MENÜ BUTONU
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: widget.onMenuTap, // MainWrapper'daki drawer'ı tetikler
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<List<BlogModel>>(
        stream: BlogService.getBlogsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Hata oluştu!"));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final allPosts = snapshot.data!;
          if (allPosts.isEmpty) return const Center(child: Text("Henüz blog eklenmemiş."));

          // Filtreleme mantığı
          final filteredPosts = selectedCategory == "Tümü"
              ? allPosts
              : allPosts.where((post) => 
                  post.category.trim().toLowerCase() == selectedCategory.trim().toLowerCase()).toList();

          final featuredPost = allPosts.firstWhere(
            (p) => p.isFeatured, 
            orElse: () => allPosts.first,
          );

          return CustomScrollView(
            slivers: [
              // Kategori Seçici
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CategorySelector(
                    onCategorySelected: (category) {
                      setState(() => selectedCategory = category);
                    },
                  ),
                ),
              ),
              
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text("Haftanın Makalesi", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BlogCard(post: featuredPost), 
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Son Yazılar", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      TextButton(onPressed: () {}, child: const Text("Tümünü gör")),
                    ],
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => RecentBlogTile(post: filteredPosts[index]),
                  childCount: filteredPosts.length,
                ),
              ),
              
              // Alt barın içeriği kapatmaması için güvenli boşluk
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }
}