import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:google_fonts/google_fonts.dart';
import 'package:moya/presentation/screens/chatbot/chatbot_screen.dart';
import 'package:moya/presentation/screens/profile/profile_screen.dart';
=======
import 'ai_assistant_button.dart';
import 'daily_intention_card.dart';
import 'emergency_support_card.dart';
import 'featured_content_card.dart';
import 'greeting_widget.dart';
import 'home_app_bar.dart';
import 'home_mood_selector.dart';
>>>>>>> 580281d (takvim sayfası widgetlara ayrıldı, müzik sayfası için playlist taslakları oluşturuldu.)

// Ana ekran widget'ı.
class HomeScreenNew extends StatelessWidget {
  final VoidCallback onMenuTap;

  const HomeScreenNew({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
<<<<<<< HEAD
              _HomeAppBar(onMenuTap: onMenuTap),
=======
              // onMenuTap fonksiyonunu alt widget'a gönderiyoruz.
              HomeAppBar(onMenuTap: onMenuTap),
>>>>>>> 580281d (takvim sayfası widgetlara ayrıldı, müzik sayfası için playlist taslakları oluşturuldu.)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      const SizedBox(height: 24),
                      const GreetingWidget(),
                      const SizedBox(height: 12),
                      const EmergencySupportCard(),
                      const SizedBox(height: 12),
                      const HomeMoodSelector(),
                      const SizedBox(height: 16),
                      const DailyIntentionCard(),
                      const SizedBox(height: 24),
<<<<<<< HEAD
                      const _FeaturedContentCard(),
                      const SizedBox(height: 150), 
=======
                      const FeaturedContentCard(),
                      const SizedBox(height: 150), // Alt navigasyon çubuğu boşluğu
>>>>>>> 580281d (takvim sayfası widgetlara ayrıldı, müzik sayfası için playlist taslakları oluşturuldu.)
                    ],
                  ),
                ),
              ),
            ],
          ),
          const AiAssistantButton(),
        ],
      ),
    );
  }
<<<<<<< HEAD
}

// --- 1. APP BAR WIDGET ---
class _HomeAppBar extends StatelessWidget {
  final VoidCallback onMenuTap;
  const _HomeAppBar({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      expandedHeight: 100.0,
      backgroundColor: theme.scaffoldBackgroundColor.withAlpha(217),
      elevation: 0,
      automaticallyImplyLeading: false,
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
                    color: theme.colorScheme.onBackground.withAlpha(230),
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
            onTap: onMenuTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.menu, size: 30, color: theme.colorScheme.onBackground),
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            child: InkWell( // Navigasyon sarmalayıcısı
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                // SÖ simgesine tıklandığında ProfileScreen'e gider
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
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
                  child: Center(
                    child: Text(
                      'SÖ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: theme.colorScheme.onSurface),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- 2. GREETING WIDGET ---
class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Merhaba, ',
            style: textTheme.headlineMedium,
            children: [
              TextSpan(
                text: 'Selin',
                style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Şu an nasıl hissediyorsun?',
          style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.6), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// --- 3. EMERGENCY SUPPORT WIDGET ---
class _EmergencySupportCard extends StatelessWidget {
  const _EmergencySupportCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.error.withAlpha(25),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.error.withAlpha(77)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.support_agent, color: theme.colorScheme.error),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Acil Destek', style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('Birileriyle konuşmaya ihtiyacım var', style: TextStyle(color: theme.colorScheme.error, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: theme.colorScheme.error.withAlpha(102), size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 4. MOOD SELECTOR WIDGET ---
class _MoodSelector extends StatefulWidget {
  const _MoodSelector();

  @override
  State<_MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<_MoodSelector> {
  String _selectedMood = 'Dengede';

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😔', 'text': 'Tükenmiş', 'color': Colors.indigo},
    {'emoji': '✨', 'text': 'Umutlu', 'color': Colors.yellow},
    {'emoji': '😰', 'text': 'Kaygılı', 'color': Colors.purple},
    {'emoji': '⚖️', 'text': 'Dengede', 'color': Colors.teal},
    {'emoji': '😄', 'text': 'Mutlu', 'color': Colors.orange},
    {'emoji': '😠', 'text': 'Kızgın', 'color': Colors.red},
    {'emoji': '😥', 'text': 'Üzgün', 'color': Colors.blue},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_moods.length, (index) {
          final mood = _moods[index];
          final text = mood['text'] as String;
          return Padding(
            padding: EdgeInsets.only(right: index == _moods.length - 1 ? 0 : 12),
            child: _MoodOption(
              emoji: mood['emoji'] as String,
              text: text,
              color: mood['color'] as Color,
              isSelected: _selectedMood == text,
              onTap: () {
                setState(() {
                  _selectedMood = text;
                });
              },
            ),
          );
        }),
      ),
    );
  }
}

class _MoodOption extends StatelessWidget {
  const _MoodOption({
    required this.emoji,
    required this.text,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String emoji;
  final String text;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: isSelected ? color.withAlpha(51) : theme.cardTheme.color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? color : theme.colorScheme.onBackground.withAlpha(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? theme.colorScheme.onBackground : theme.colorScheme.onBackground.withOpacity(0.7),
                    fontSize: 12,
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

// --- 5. DAILY INTENTION WIDGET ---
class _DailyIntentionCard extends StatelessWidget {
  const _DailyIntentionCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.onBackground.withAlpha(25)),
        gradient: LinearGradient(
          colors: [theme.colorScheme.surface, theme.colorScheme.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wb_sunny_outlined, color: theme.primaryColor, size: 14),
              const SizedBox(width: 8),
              Text(
                'Günün Niyeti',
                style: textTheme.labelSmall?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold, letterSpacing: 1.1),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"Bugün kontrol edemediğim şeyleri serbest bırakıyorum ve sadece kendi huzuruma odaklanıyorum."',
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              textStyle: textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onBackground.withAlpha(230),
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 6. FEATURED CONTENT WIDGET ---
class _FeaturedContentCard extends StatelessWidget {
  const _FeaturedContentCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Senin İçin Seçtiklerimiz', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.primaryColor.withAlpha(51)),
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
              border: Border.all(color: theme.colorScheme.onBackground.withAlpha(12)),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 20, spreadRadius: -10)],
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'),
                fit: BoxFit.cover,
                opacity: 0.7,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [theme.scaffoldBackgroundColor, theme.scaffoldBackgroundColor.withAlpha(0)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                    ),
                  ),
                ),
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
                          color: theme.colorScheme.onBackground.withAlpha(25),
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.colorScheme.onBackground.withAlpha(51)),
                        ),
                        child: Icon(Icons.play_arrow, color: theme.colorScheme.onBackground),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          _Tag('ODAKLANMA'),
                          SizedBox(width: 8),
                          _Tag('NEFES'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Zihinsel Arınma', style: textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 14, color: theme.colorScheme.onBackground.withOpacity(0.6)),
                          const SizedBox(width: 4),
                          Text('3 dk Kutu Nefesi', style: textTheme.bodySmall),
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
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.onBackground.withAlpha(25),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: theme.colorScheme.onBackground.withAlpha(25)),
          ),
          child: Text(label, style: theme.textTheme.labelSmall),
        ),
      ),
    );
  }
}

// --- 7. AI ASSISTANT BUTTON WIDGET ---
class _AiAssistantButton extends StatefulWidget {
  const _AiAssistantButton();

  @override
  State<_AiAssistantButton> createState() => _AiAssistantButtonState();
}

class _AiAssistantButtonState extends State<_AiAssistantButton> with SingleTickerProviderStateMixin {
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
    return Positioned(
      bottom: 120,
      right: 24,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotScreen()),
          );
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
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              border: Border.all(color: theme.colorScheme.onPrimary.withAlpha(102), width: 2),
            ),
            child: Icon(Icons.smart_toy_outlined, color: theme.colorScheme.onPrimary, size: 32),
          ),
        ),
      ),
    );
  }
=======
>>>>>>> 580281d (takvim sayfası widgetlara ayrıldı, müzik sayfası için playlist taslakları oluşturuldu.)
}