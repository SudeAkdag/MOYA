import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPlaying = false;

  // Pacer state
  String _pacerText = "Hazır";
  String _pacerSubText = "Başlamak için dokun";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        setState(() {}); // Redraw on animation change
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        children: [
          const SizedBox(height: 24),
          _buildPacer(),
          const SizedBox(height: 48),
          _buildControls(),
          const SizedBox(height: 48),
          _buildTechniquesList(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onBackground),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("Nefes Egzersizleri", style: theme.textTheme.titleLarge),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.bar_chart, color: theme.colorScheme.onBackground, size: 28),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildPacer() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor.withOpacity(0.1), width: 1),
                ),
              ),
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
                ),
              ),
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.surface, theme.scaffoldBackgroundColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.15),
                      blurRadius: 60,
                      spreadRadius: 20,
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.spa_outlined, color: primaryColor.withOpacity(0.8), size: 40),
                  const SizedBox(height: 12),
                  Text(_pacerText, style: theme.textTheme.displaySmall),
                  const SizedBox(height: 4),
                  Text(_pacerSubText, style: TextStyle(fontSize: 14, color: primaryColor.withOpacity(0.8))),
                ],
              ),
              SizedBox(
                width: 220,
                height: 220,
                child: Transform.rotate(
                  angle: -math.pi / 2,
                  child: CircularProgressIndicator(
                    value: 0.25, // Static for now
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    backgroundColor: theme.colorScheme.surface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Text("SÜRE", style: theme.textTheme.labelSmall),
            const SizedBox(height: 4),
            Text("05:00", style: theme.textTheme.titleLarge),
          ],
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isPlaying = !_isPlaying;
              if (_isPlaying) {
                _controller.repeat();
                _pacerText = "Nefes Al";
                _pacerSubText = "";
              } else {
                _controller.stop();
                _pacerText = "Durdu";
                _pacerSubText = "Devam etmek için dokun";
              }
            });
          },
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: theme.colorScheme.onPrimary,
              size: 44,
            ),
          ),
        ),
        Column(
          children: [
            Text("MOD", style: theme.textTheme.labelSmall),
            const SizedBox(height: 4),
            Text("Kutu", style: theme.textTheme.titleLarge),
          ],
        ),
      ],
    );
  }

  Widget _buildTechniquesList() {
    final theme = Theme.of(context);
    final cardColors = [
      theme.colorScheme.primaryContainer,
      theme.colorScheme.secondaryContainer,
      theme.colorScheme.tertiaryContainer,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 16),
          child: Text("Teknikler", style: theme.textTheme.headlineSmall),
        ),
        _buildTechniqueCard("Kutu Nefesi (4-4-4-4)", "Sınav öncesi zihni toparla", "5 dk", "Odaklanma", cardColors[0], "https://lh3.googleusercontent.com/aida-public/AB6AXuCFtbal5YrjiXvO8see1DK3HkaA9Gl5AOLsa9d7PnBapTVwCrSVwYoego0j3gLmVREoNVMigzPK0Fm39V4Hz7tF28K8bRDDg38n9w4_VelQI67QfFVNulIdY75nxO2qFCGBu6Hl9Q84KYz4nzfe-w9PtSC4sEmR-eJcA04pzsf4VZ0rCVOsXP9eQtT1xBWFmCOTXQJNt-exMuAFwNfQuIi7UGuz_vVwFKRPuTiTeo2HaYAZd79XKUJyB7zJiDSZcri8Cop0-u0XH9h1"),
        const SizedBox(height: 12),
        _buildTechniqueCard("4-7-8 Tekniği", "Hızlıca uykuya dalış", "3 dk", "Uyku", cardColors[1], "https://lh3.googleusercontent.com/aida-public/AB6AXuCkRaVdm927JcpwWo3aaUb1DpyCQ9BAiGQDLq3g9gSlGbOnTBqcUgIqlHQKs-ZTl2_gTWjXSANISbYETiS3F6w-yl0iXxg9lyFsT5RTPEas-sf8iS4d1QrqRbfxj90Wc5uv-fW0_fPaIRjpI1opml0uSyDEFIp9xPY3MgZK0gXv7HKXc4uHnUsj_T4-LCyNQrCcKnQlCbzqsYOtR2OEVbtZLDkzWpPzAPDXxSYXtnDAHyB4RVNcAHALQt1DLUQakzYSG27TMithkBFk"),
        const SizedBox(height: 12),
        _buildTechniqueCard("Sakinleştirici Nefes", "Anksiyete ve stres anı", "2 dk", "Panik", cardColors[2], "https://lh3.googleusercontent.com/aida-public/AB6AXuDb3WgufuxI9_vas7klPz4AruC9Y-8kqGAThestgHgSVVYH757JbT8mRxyYzjZwzIPEBcVl54XL4iwuA2Ug4LCBjL5DZnbE_UY-kXZaf05RL9RAyUC-yZHKg3CdKN1VkPh_mMjvYoj3kHP_LS5jJSix75q6HEwpPvFra5ut2vf5A_MGR95z9UlBV4ADqs0TTJQfvPY2V3_X4tXfeJNIMC-HgA_3YQAyb43xV_enrud5JTD93REilkMmRSP1NTGlQ_46TomZYHXaVSB6"),
      ],
    );
  }

  Widget _buildTechniqueCard(String title, String subtitle, String duration, String tag, Color tagColor, String imageUrl) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(imageUrl, width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(tag.toUpperCase(), style: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
                const SizedBox(height: 8),
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.play_arrow, color: theme.colorScheme.onSecondaryContainer),
              ),
              const SizedBox(height: 8),
              Text(duration, style: theme.textTheme.bodySmall),
            ],
          )
        ],
      ),
    );
  }
}