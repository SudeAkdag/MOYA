import 'package:flutter/material.dart';
import 'ai_assistant_button.dart';
import 'daily_intention_card.dart';
import 'emergency_support_card.dart';
import 'featured_content_card.dart';
import 'greeting_widget.dart';
import 'home_app_bar.dart';
import 'home_mood_selector.dart';

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
              // onMenuTap fonksiyonunu alt widget'a gönderiyoruz.
              HomeAppBar(onMenuTap: onMenuTap),
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
                      const FeaturedContentCard(),
                      const SizedBox(height: 150), // Alt navigasyon çubuğu boşluğu
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
}
