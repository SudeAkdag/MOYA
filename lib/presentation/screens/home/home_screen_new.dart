import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> with TickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      // extendBody: true,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(context, theme, textTheme),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      const SizedBox(height: 24),
                      _buildGreeting(textTheme),
                      const SizedBox(height: 20),
                      _buildEmergencySupport(context),
                      const SizedBox(height: 12), // Further reduced space
                      _buildMoodSelector(context, textTheme),
                      const SizedBox(height: 16), // Further reduced space
                      _buildDailyIntention(context, textTheme),
                      const SizedBox(height: 24),
                      _buildFeaturedContent(context, textTheme),
                      const SizedBox(height: 150), // For bottom nav bar spacing
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildAiAssistant(context),
        ],
      ),
    );
  }

  Widget _buildAiAssistant(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      bottom: 120, // Adjusted for new nav bar
      right: 24,
      child: GestureDetector(
        onTap: () {
          // TODO: AI Assistant tap action
        },
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            final glowValue = 0.4 + (_glowController.value * 0.2);
            final glowRadius = 30 + (_glowController.value * 15);
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withAlpha((glowValue * 255).toInt()),
                    blurRadius: glowRadius,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              border: Border.all(color: Colors.white.withAlpha((0.4 * 255).toInt()), width: 2),
            ),
            child: const Center(
              child: Icon(Icons.smart_toy_outlined, color: Colors.white, size: 32),
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, ThemeData theme, TextTheme textTheme) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      expandedHeight: 100.0,
      backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
      elevation: 0,
      automaticallyImplyLeading: false, // Disables default back button
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(bottom: 16),
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.spa_outlined, color: theme.primaryColor, size: 20),
                const SizedBox(width: 4),
                Text(
                  'MOYA',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white.withOpacity(0.9)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      leading: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.menu, size: 30, color: Colors.white),
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [theme.primaryColor, theme.colorScheme.secondary],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.cardTheme.color,
                ),
                child: const Center(
                  child: Text(
                    'SÖ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Merhaba, ',
            style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w300, color: Colors.white),
            children: [
              TextSpan(
                text: 'Selin',
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Şu an nasıl hissediyorsun?',
          style: textTheme.bodyMedium?.copyWith(color: Colors.grey[400], fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildEmergencySupport(BuildContext context) {
    return Material(
      color: Colors.red.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.support_agent, color: Colors.redAccent),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Acil Destek', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(height: 2),
                    Text('Birileriyle konuşmaya ihtiyacım var', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.redAccent.withOpacity(0.4), size: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodSelector(BuildContext context, TextTheme textTheme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _moodOption(context, '😔', 'Tükenmiş', Colors.indigo),
        _moodOption(context, '✨', 'Umutlu', Colors.yellow),
        _moodOption(context, '😰', 'Kaygılı', Colors.purple),
        _moodOption(context, '⚖️', 'Dengede', Colors.teal, isSelected: true),
      ],
    );
  }

  Widget _moodOption(BuildContext context, String emoji, String text, Color color, {bool isSelected = false}) {
    final theme = Theme.of(context);
    return Material(
      color: isSelected ? color.withOpacity(0.2) : theme.cardTheme.color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? color : Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey[300],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyIntention(BuildContext context, TextTheme textTheme) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)
        ]
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wb_sunny_outlined, color: theme.primaryColor, size: 14),
              const SizedBox(width: 8),
              Text('Günün Niyeti', style: textTheme.labelSmall?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"Bugün kontrol edemediğim şeyleri serbest bırakıyorum ve sadece kendi huzuruma odaklanıyorum."',
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              textStyle: textTheme.titleMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedContent(BuildContext context, TextTheme textTheme) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Senin İçin Seçtiklerimiz', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.smart_toy, size: 12, color: theme.primaryColor),
                  const SizedBox(width: 4),
                  Text('AI ÖNERİSİ', style: textTheme.labelSmall?.copyWith(fontSize: 10, color: theme.primaryColor, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, spreadRadius: -10)],
              image: const DecorationImage(
                image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCFtbal5YrjiXvO8see1DK3HkaA9Gl5AOLsa9d7PnBapTVwCrSVwYoego0j3gLmVREoNVMigzPK0Fm39V4Hz7tF28K8bRDDg38n9w4_VelQI67QfFVNulIdY75nxO2qFCGBu6Hl9Q84KYz4nzfe-w9PtSC4sEmR-eJcA04pzsf4VZ0rCVOsXP9eQtT1xBWFmCOTXQJNt-exMuAFwNfQuIi7UGuz_vVwFKRPuTiTeo2HaYAZd79XKUJyB7zJiDSZcri8Cop0-u0XH9h1'),
                fit: BoxFit.cover,
                opacity: 0.7,
              ),
            ),
            child: Stack(
              children: [
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [theme.scaffoldBackgroundColor, theme.scaffoldBackgroundColor.withOpacity(0)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                    ),
                  ),
                ),
                // Play Button
                Positioned(
                  top: 16,
                  right: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: const Icon(Icons.play_arrow, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                // Content
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _tag('ODAKLANMA'),
                          const SizedBox(width: 8),
                          _tag('NEFES'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Zihinsel Arınma', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 14, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text('3 dk Kutu Nefesi', style: textTheme.bodySmall?.copyWith(color: Colors.grey[400])),
                          const SizedBox(width: 8),
                          Text('•', style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(width: 8),
                          Icon(Icons.headphones_outlined, size: 14, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text('Odak Müziği', style: textTheme.bodySmall?.copyWith(color: Colors.grey[400])),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tag(String label) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}