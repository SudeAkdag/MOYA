import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/E&M/meditation_screen_new.dart';
import 'package:moya/presentation/screens/E&M/widgets/categories_list.dart';
import 'package:moya/presentation/screens/E&M/widgets/featured_meditation_card.dart';
import 'package:moya/presentation/screens/E&M/widgets/popular_meditations_list.dart';
import 'package:moya/presentation/screens/E&M/widgets/section_header.dart';
import 'package:moya/presentation/screens/E&M/widgets/two_cards_grid.dart';

class MeditationScreen extends StatelessWidget {
  final VoidCallback onMenuTap;

  const MeditationScreen({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    // Temadan renkleri ve stilleri alıyoruz
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // Arka plan artık sabit değil, temadan geliyor
      backgroundColor: theme.scaffoldBackgroundColor, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Egzersiz ve Meditasyon",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            // Başlık rengi temaya göre otomatik (siyah veya beyaz) değişir
            color: theme.appBarTheme.titleTextStyle?.color ?? (isDark ? Colors.white : Colors.black),
          ),
        ),
        leading: IconButton(
          // İkon rengini temadaki ikon rengine bağladık
          icon: Icon(Icons.menu, color: theme.iconTheme.color),
          onPressed: onMenuTap,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          
          // Önemli: Alt widget'ların (FeaturedMeditationCard vb.) 
          // kendi içlerinde Theme.of(context) kullandığından emin olmalısın.
          const FeaturedMeditationCard(),
          
          const TwoCardsGrid(),
          
          const SectionHeader(title: "Kategoriler"),
          const CategoriesList(),

          SectionHeader(
            title: "Popüler Meditasyonlar",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MeditationScreenNew()),
              );
            },
          ),
          const PopularMeditationsList(),
          
          const SliverToBoxAdapter(child: SizedBox(height: 120)), 
        ],
      ),
    );
  }
}