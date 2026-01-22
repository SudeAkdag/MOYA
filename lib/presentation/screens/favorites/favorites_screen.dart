import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // 3 Kategori: Blog, Egzersiz, Müzik
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Favorilerim"),
          bottom: const TabBar(
            labelColor: AppColors.primaryGreen,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryGreen,
            tabs: [
              Tab(text: "Bloglar"),
              Tab(text: "Egzersizler"),
              Tab(text: "Müzikler"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text("Favori Blog Yazıları")),
            Center(child: Text("Favori Egzersizler")),
            Center(child: Text("Favori Müzikler")),
          ],
        ),
      ),
    );
  }
}