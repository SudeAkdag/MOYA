import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/E&M/category_detail_screen.dart';
 // Yeni oluşturduğumuz detay sayfasını import et
import '../meditation_screen_new.dart'; // Genel liste sayfanın yolu

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<Map<String, dynamic>> categories = [
      {
        'icon': Icons.school_rounded,
        'label': "Odaklanma",
        'color': const Color(0xFF64B5F6)
      },
      {
        'icon': Icons.bedtime_rounded,
        'label': "Uykuya Hazırlık", // Firebase'deki kategori adıyla birebir aynı olmalı
        'color': const Color(0xFF9575CD)
      },
      {
        'icon': Icons.wb_sunny_rounded,
        'label': "Sabah Enerjisi",
        'color': const Color(0xFFFFB74D)
      },
      {
        'icon': Icons.more_horiz_rounded,
        'label': "Diğer",
        'color': Colors.blueGrey
      },
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 110,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: categories.length,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemBuilder: (context, index) {
            final category = categories[index];
            final Color baseColor = category['color'];
            final String label = category['label'] as String;

            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  if (label == "Diğer") {
                    // "Diğer"e tıklandığında tüm meditasyonların olduğu sayfaya gider
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MeditationScreenNew(),
                      ),
                    );
                  } else {
                    // Belirli bir kategoriye tıklandığında o kategoriye özel sayfaya gider
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailScreen(categoryName: label),
                      ),
                    );
                  }
                },
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: baseColor.withOpacity(isDark ? 0.15 : 0.1),
                        border: Border.all(
                          color: baseColor.withOpacity(0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          if (isDark)
                            BoxShadow(
                              color: baseColor.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                            )
                        ],
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        color: isDark ? baseColor : baseColor.withOpacity(0.9),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}