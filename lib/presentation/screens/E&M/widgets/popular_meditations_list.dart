import 'package:flutter/material.dart';

class PopularMeditationsList extends StatelessWidget {
  const PopularMeditationsList({super.key});

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
