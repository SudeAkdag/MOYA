import 'package:flutter/material.dart';
import 'package:moya/data/models/user_model.dart';
import 'package:moya/data/services/database_service.dart';
import 'ai_assistant_button.dart';
import 'daily_intention_card.dart';
import 'emergency_support_card.dart';
import 'featured_content_card.dart';
import 'greeting_widget.dart';
import 'home_app_bar.dart';
import 'home_mood_selector.dart';

class HomeScreenNew extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onProfileTap;

  const HomeScreenNew({
    super.key, 
    required this.onMenuTap, 
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // FutureBuilder ile veritabanından kullanıcı bilgilerini dinliyoruz
      body: FutureBuilder<UserModel?>(
        future: DatabaseService.getUserProfile(),
        builder: (context, snapshot) {
          
          // Veri yüklenirken gösterilecek varsayılan değerler
          String userName = 'Yükleniyor...';
          String userInitials = '...';

          // Veri başarıyla çekildiyse kendi modelimizden okuyoruz
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              // Veritabanından gelen veriler
              userName = snapshot.data!.name;
              userInitials = snapshot.data!.initials;
            } else {
              // Veritabanında belge yoksa hata mesajı
              userName = 'Bulunamadı';
              userInitials = '??';
            }
          }

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  HomeAppBar(
                    onMenuTap: onMenuTap,
                    onProfileTap: onProfileTap,
                    initials: userInitials, // Veritabanından gelen baş harf
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate.fixed(
                        [
                          const SizedBox(height: 24),
                          GreetingWidget(name: userName), // Veritabanından gelen isim
                          const SizedBox(height: 12),
                          const EmergencySupportCard(),
                          const SizedBox(height: 12),
                          const HomeMoodSelector(),
                          const SizedBox(height: 16),
                          const DailyIntentionCard(),
                          const SizedBox(height: 24),
                          const FeaturedContentCard(),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const AiAssistantButton(),
            ],
          );
        },
      ),
    );
  }
}