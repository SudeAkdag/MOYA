import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/E&M/widgets/breathing_screen/breathing_screen.dart';
import 'small_meditation_card.dart';

class TwoCardsGrid extends StatelessWidget {
  const TwoCardsGrid({super.key});

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
            child: const SmallMeditationCard(
              title: "Nefes\nEgzersizleri",
              icon: Icons.air,
              imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCFtbal5YrjiXvO8see1DK3HkaA9Gl5AOLsa9d7PnBapTVwCrSVwYoego0j3gLmVREoNVMigzPK0Fm39V4Hz7tF28K8bRDDg38n9w4_VelQI67QfFVNulIdY75nxO2qFCGBu6Hl9Q84KYz4nzfe-w9PtSC4sEmR-eJcA04pzsf4VZ0rCVOsXP9eQtT1xBWFmCOTXQJNt-exMuAFwNfQuIi7UGuz_vVwFKRPuTiTeo2HaYAZd79XKUJyB7zJiDSZcri8Cop0-u0XH9h1",
            ),
          ),
          const SmallMeditationCard(
            title: "Meditasyon\nSeansları",
            icon: Icons.self_improvement,
            imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCkRaVdm927JcpwWo3aaUb1DpyCQ9BAiGQDLq3g9gSlGbOnTBqcUgIqlHQKs-ZTl2_gTWjXSANISbYETiS3F6w-yl0iXxg9lyFsT5RTPEas-sf8iS4d1QrqRbfxj90Wc5uv-fW0_fPaIRjpI1opml0uSyDEFIp9xPY3MgZK0gXv7HKXc4uHnUsj_T4-LCyNQrCcKnQlCbzqsYOtR2OEVbtZLDkzWpPzAPDXxSYXtnDAHyB4RVNcAHALQt1DLUQakzYSG27TMithkBFk",
          ),
        ]),
      ),
    );
  }
}
