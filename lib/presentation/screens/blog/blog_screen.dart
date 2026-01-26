import 'package:flutter/material.dart';
import '../../../../data/models/blog_model.dart';
import 'widgets/blog_card.dart'; 
import 'widgets/category_selector.dart';
import 'widgets/recent_blog_tile.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  static final List<BlogModel> blogPosts = [
    BlogModel(
      title: 'Gelecek Kaygısıyla Bilimsel Baş Etme Yolları',
      author: 'Dr. Öğr. Selin K.',
      category: 'PSİKOLOJİ',
      description: 'Günlük hayatta karşılaştığımız stres faktörlerini yönetmek...',
      imageUrl: 'https://picsum.photos/400/200',
      readTime: '5 dk okuma',
      date: '12 Ekim 2023',
      isFeatured: true,
    ),
    BlogModel(
      title: 'Kaliteli Uyku İçin 5 İpucu',
      author: 'Psk. Öğr. Damla Y.',
      category: 'UYKU HİJYENİ',
      description: 'Uyku kalitenizi artırmak için yapılması gerekenler...',
      imageUrl: 'https://picsum.photos/400/201',
      readTime: '4 dk okuma',
      date: '10 Ekim 2023',
    ),
    BlogModel(
      title: 'Dijital Detoks ve Zihin Sağlığı',
      author: 'Psk. Öğr. Elif K.',
      category: 'FARKINDALIK',
      description: 'Zihinsel sağlığınızı korumak için dijital alışkanlıklar...',
      imageUrl: 'https://picsum.photos/400/202',
      readTime: '3 dk okuma',
      date: '08 Ekim 2023',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final featuredPost = blogPosts.firstWhere((p) => p.isFeatured, orElse: () => blogPosts.first);

    return Scaffold(
      appBar: AppBar(title: const Text('Bilgi ve Farkındalık'), centerTitle: false),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: CategorySelector()),
          
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
              (context, index) => RecentBlogTile(post: blogPosts[index]),
              childCount: blogPosts.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}