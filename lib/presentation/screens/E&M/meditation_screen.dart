import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/E&M/widgets/categories_list.dart';
import 'package:moya/presentation/screens/E&M/widgets/featured_meditation_card.dart';
import 'package:moya/presentation/screens/E&M/widgets/popular_meditations_list.dart';
import 'package:moya/presentation/screens/E&M/widgets/section_header.dart';
import 'package:moya/presentation/screens/E&M/widgets/two_cards_grid.dart';

class MeditationScreen extends StatelessWidget {
  // MainWrapper'daki drawer'ı açmak için gerekli fonksiyon
  final VoidCallback onMenuTap;

  const MeditationScreen({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sol üst köşeye side bar butonunu ekleyen AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: onMenuTap, // MainWrapper'daki drawer'ı tetikler
        ),
      ),
      // AppBar'ın içeriği aşağı itmemesi ve şeffaf kalması için
      extendBodyBehindAppBar: true, 
      body: CustomScrollView(
        slivers: [
          // Başlık Bölümü: Aşağı çekildi ve ortalandı
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0, bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hoş Geldin",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Zihnini Özgür Bırak",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Orijinal içerik widget'ları
          const FeaturedMeditationCard(),
          const TwoCardsGrid(),
          const SectionHeader(title: "Kategoriler"),
          const CategoriesList(),
          const SectionHeader(title: "Popüler Meditasyonlar"),
          const PopularMeditationsList(),
          // Alt barın içeriği kapatmaması için güvenli boşluk
          const SliverToBoxAdapter(child: SizedBox(height: 120)), 
        ],
      ),
    );
  }
}
