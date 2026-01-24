import 'package:flutter/material.dart';
import '../../widgets/mood_selector.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Temaya erişim (Primary, TextTheme vb. için)
    final theme = Theme.of(context);

    return Scaffold(
    
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "İyi akşamlar,",
              // 3. Alt metinler için temanın bodySmall veya labelMedium stilini kullanıyoruz
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              ),
            ),
            Text(
              "Ayşe Yılmaz",
              // 4. İsim kısmı temanın ana rengini (primary) alıyor
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              child: CircleAvatar(
                radius: 20,
                // 5. Avatar arka planı temanın ana rengi oldu
                backgroundColor: theme.primaryColor,
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ),
          )
        ],
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // MoodSelector zaten kendi içinde temayı kullanmalı.
            MoodSelector(
              onMoodSelected: (score) {
                debugPrint("Seçilen Mod Puanı: $score");
              },
            ),

            // Buraya gelecek diğer kartlar theme.cardColor kullanacaktır.
          ],
        ),
      ),
    );
  }
}