import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mevcut temanın renklerine erişiyoruz
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Favorilerim"),
          bottom: TabBar(
            // ARTIK SABİT RENK DEĞİL, TEMANIN ANA RENGİNİ KULLANIYORUZ
            labelColor: theme.primaryColor, 
            unselectedLabelColor: Colors.grey,
            indicatorColor: theme.primaryColor,
            tabs: const [
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