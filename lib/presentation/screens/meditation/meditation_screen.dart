import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/breathing/breathing_screen.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const _Header(),
          const _FeaturedCard(),
          const _TwoCardsGrid(),
          const _SectionHeader(title: "Kategoriler"),
          const _CategoriesList(),
          const _SectionHeader(title: "Popüler Meditasyonlar"),
          const _PopularMeditationsList(),
          const SliverToBoxAdapter(child: SizedBox(height: 120)), // Navigasyon çubuğu için boşluk
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 90,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: theme.scaffoldBackgroundColor.withOpacity(0.85),
            padding: EdgeInsets.only(left: 24, right: 24, top: topPadding, bottom: 10),
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Hoş Geldin",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Zihnini Özgür Bırak",
                      style: theme.textTheme.headlineSmall,
                    ),
                  ],
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: theme.colorScheme.onBackground.withOpacity(0.1)),
                  ),
                  child: Icon(Icons.notifications, color: theme.colorScheme.onSurface, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Container(
            height: 240,
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.onBackground.withOpacity(0.05)),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuDb3WgufuxI9_vas7klPz4AruC9Y-8kqGAThestgHgSVVYH757JbT8mRxyYzjZwzIPEBcVl54XL4iwuA2Ug4LCBjL5DZnbE_UY-kXZaf05RL9RAyUC-yZHKg3CdKN1VkPh_mMjvYoj3kHP_LS5jJSix75q6HEwpPvFra5ut2vf5A_MGR95z9UlBV4ADqs0TTJQfvPY2V3_X4tXfeJNIMC-HgA_3YQAyb43xV_enrud5JTD93REilkMmRSP1NTGlQ_46TomZYHXaVSB6",
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.scaffoldBackgroundColor,
                        theme.scaffoldBackgroundColor.withOpacity(0.7),
                        Colors.transparent
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 14),
                            const SizedBox(width: 6),
                            Text("Sana Özel Öneri", style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onBackground)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text("10 dk Odaklanma", style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 6),
                      Text(
                        "Sınav öncesi zihnini toparlamak için ideal bir seri.",
                        style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.7)),
                        maxLines: 2,
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.play_circle, color: theme.colorScheme.onPrimary, size: 22),
                        label: Text("Hemen Başla", style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TwoCardsGrid extends StatelessWidget {
  const _TwoCardsGrid();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildListDelegate([
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BreathingScreen()),
              );
            },
            child: const _SmallCard(
              title: "Nefes\nEgzersizleri",
              icon: Icons.air,
              imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCFtbal5YrjiXvO8see1DK3HkaA9Gl5AOLsa9d7PnBapTVwCrSVwYoego0j3gLmVREoNVMigzPK0Fm39V4Hz7tF28K8bRDDg38n9w4_VelQI67QfFVNulIdY75nxO2qFCGBu6Hl9Q84KYz4nzfe-w9PtSC4sEmR-eJcA04pzsf4VZ0rCVOsXP9eQtT1xBWFmCOTXQJNt-exMuAFwNfQuIi7UGuz_vVwFKRPuTiTeo2HaYAZd79XKUJyB7zJiDSZcri8Cop0-u0XH9h1",
            ),
          ),
          const _SmallCard(
            title: "Meditasyon\nSeansları",
            icon: Icons.self_improvement,
            imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCkRaVdm927JcpwWo3aaUb1DpyCQ9BAiGQDLq3g9gSlGbOnTBqcUgIqlHQKs-ZTl2_gTWjXSANISbYETiS3F6w-yl0iXxg9lyFsT5RTPEas-sf8iS4d1QrqRbfxj90Wc5uv-fW0_fPaIRjpI1opml0uSyDEFIp9xPY3MgZK0gXv7HKXc4uHnUsj_T4-LCyNQrCcKnQlCbzqsYOtR2OEVbtZLDkzWpPzAPDXxSYXtnDAHyB4RVNcAHALQt1DLUQakzYSG27TMithkBFk",
          ),
        ]),
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  const _SmallCard({required this.title, required this.icon, required this.imageUrl});
  final String title;
  final IconData icon;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: theme.colorScheme.onBackground.withOpacity(0.1))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover, opacity: const AlwaysStoppedAnimation(0.6)),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.onBackground.withOpacity(0.05),
                      border: Border.all(color: theme.colorScheme.onBackground.withOpacity(0.1)),
                      ),
                      child: Center(child: Icon(icon, color: theme.colorScheme.onBackground))),
                  const SizedBox(height: 12),
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(height: 1.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: theme.textTheme.headlineSmall),
            Text("Tümü", style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}

class _CategoriesList extends StatelessWidget {
  const _CategoriesList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = [
      {'icon': Icons.school, 'label': "Sınav Kaygısı", 'color': theme.colorScheme.primaryContainer},
      {'icon': Icons.bedtime, 'label': "Uykuya Hazırlık", 'color': theme.colorScheme.secondaryContainer},
      {'icon': Icons.wb_sunny, 'label': "Sabah Enerjisi", 'color': theme.colorScheme.tertiaryContainer},
      {'icon': Icons.more_horiz, 'label': "Diğer", 'color': theme.colorScheme.surfaceVariant},
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemBuilder: (context, index) {
            final category = categories[index];
            final color = category['color'] as Color;
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.2),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Icon(category['icon'] as IconData, color: color, size: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(category['label'] as String, style: theme.textTheme.bodySmall),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PopularMeditationsList extends StatelessWidget {
  const _PopularMeditationsList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final popular = [
      {
        'title': "Derin Uyku Rehberi",
        'subtitle': "Dr. Ayşe Yılmaz • 15k görüntüleme",
        'duration': "15:00",
        'image': "https://lh3.googleusercontent.com/aida-public/AB6AXuCkRaVdm927JcpwWo3aaUb1DpyCQ9BAiGQDLq3g9gSlGbOnTBqcUgIqlHQKs-ZTl2_gTWjXSANISbYETiS3F6w-yl0iXxg9lyFsT5RTPEas-sf8iS4d1QrqRbfxj90Wc5uv-fW0_fPaIRjpI1opml0uSyDEFIp9xPY3MgZK0gXv7HKXc4uHnUsj_T4-LCyNQrCcKnQlCbzqsYOtR2OEVbtZLDkzWpPzAPDXxSYXtnDAHyB4RVNcAHALQt1DLUQakzYSG27TMithkBFk"
      },
      {
        'title': "Final Haftası Sakinliği",
        'subtitle': "Mindful Kampüs • 5k görüntüleme",
        'duration': "08:30",
        'image': "https://lh3.googleusercontent.com/aida-public/AB6AXuCFtbal5YrjiXvO8see1DK3HkaA9Gl5AOLsa9d7PnBapTVwCrSVwYoego0j3gLmVREoNVMigzPK0Fm39V4Hz7tF28K8bRDDg38n9w4_VelQI67QfFVNulIdY75nxO2qFCGBu6Hl9Q84KYz4nzfe-w9PtSC4sEmR-eJcA04pzsf4VZ0rCVOsXP9eQtT1xBWFmCOTXQJNt-exMuAFwNfQuIi7UGuz_vVwFKRPuTiTeo2HaYAZd79XKUJyB7zJiDSZcri8Cop0-u0XH9h1"
      }
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: popular.length,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemBuilder: (context, index) {
            final item = popular[index];
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 144,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(item['image']!, fit: BoxFit.cover),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(item['duration']!, style: theme.textTheme.labelSmall),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(item['title']!, style: theme.textTheme.titleMedium, maxLines: 1),
                    const SizedBox(height: 4),
                    Text(item['subtitle']!, style: theme.textTheme.bodySmall),
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