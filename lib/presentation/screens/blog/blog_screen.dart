import 'package:flutter/material.dart';

import '../../../../data/services/blog_service.dart';
import 'widgets/blog_card.dart'; 
import 'widgets/category_selector.dart';
import 'widgets/recent_blog_tile.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  String selectedCategory = "Tümü";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredPosts = selectedCategory == "Tümü"
        ? BlogService.blogPosts 
        : BlogService.blogPosts.where((post) => 
            post.category.toUpperCase() == selectedCategory.toUpperCase()).toList();

    final featuredPost = BlogService.blogPosts.firstWhere(
      (p) => p.isFeatured, 
      orElse: () => BlogService.blogPosts.first
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Bilgi ve Farkındalık'), centerTitle: false),
      body: CustomScrollView(
        slivers: [
          // Kategori Çubuğu
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
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }
}