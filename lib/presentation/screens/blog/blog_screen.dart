import 'package:flutter/material.dart';
import '../../../../data/models/blog_model.dart';
import 'widgets/blog_card.dart';
import 'widgets/category_selector.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  // Veri listesi (Gerçek projede burası Repository'den gelir)
  static final List<BlogModel> blogPosts = [
    BlogModel(
      title: 'Kaygı ile Başa Çıkmanın Yolları',
      category: 'PSİKOLOJİ',
      description: 'Günlük hayatta karşılaştığımız stres faktörlerini yönetmek...',
      imageUrl: 'https://picsum.photos/400/200',
      date: '12 Ekim 2023',
   
    ),
    BlogModel(
      title: 'Doğru Nefes Teknikleri',
      category: 'NEFES',
      description: 'Zihninizi sakinleştirmek için temel teknikler...',
      imageUrl: 'https://picsum.photos/400/201',
      date: '10 Ekim 2023',
    
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Blog'), centerTitle: true),
      body: Column(
        children: [
          _buildSearchBar(theme),
          const CategorySelector(),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: blogPosts.length,
              itemBuilder: (context, index) => BlogCard(post: blogPosts[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Ara...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}