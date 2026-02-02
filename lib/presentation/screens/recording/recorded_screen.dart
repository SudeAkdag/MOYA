import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/recording/widgets/saved_placeholder.dart';
// Yeni oluşturduğun widget'ı buraya import etmeyi unutma


class RecordedScreen extends StatelessWidget {
  const RecordedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mevcut temanın renklerine erişiyoruz
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2, // Bloglar ve Egzersizler için 2 sekme
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Kaydedilenler",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelColor: theme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: theme.primaryColor,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "Bloglar"),
              Tab(text: "Egzersizler"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Merkezi widget'ımızı kullanıyoruz
            EmptyStateView(
              message: "Kaydedilmiş Blog Yazısı Bulunmuyor",
              icon: Icons.article_outlined,
            ),
            EmptyStateView(
              message: "Kaydedilmiş Egzersiz Bulunmuyor",
              icon: Icons.fitness_center_outlined,
            ),
          ],
        ),
      ),
    );
  }
}