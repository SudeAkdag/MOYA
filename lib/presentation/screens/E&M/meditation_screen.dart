import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/E&M/widgets/categories_list.dart';
import 'package:moya/presentation/screens/E&M/widgets/featured_meditation_card.dart';
import 'package:moya/presentation/screens/E&M/widgets/meditation_header.dart';
import 'package:moya/presentation/screens/E&M/widgets/popular_meditations_list.dart';
import 'package:moya/presentation/screens/E&M/widgets/section_header.dart';
import 'package:moya/presentation/screens/E&M/widgets/two_cards_grid.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          MeditationHeader(),
          FeaturedMeditationCard(),
          TwoCardsGrid(),
          SectionHeader(title: "Kategoriler"),
          CategoriesList(),
          SectionHeader(title: "Popüler Meditasyonlar"),
          PopularMeditationsList(),
          SliverToBoxAdapter(child: SizedBox(height: 120)), // Navigasyon çubuğu için boşluk
        ],
      ),
    );
  }
}