import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../widgets/mood_selector.dart';
import '../profile/profile_screen.dart'; // Profil sayfasına gitmek için

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Profil Butonunun Olduğu Üst Bar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Şeffaf
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "İyi akşamlar,",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const Text(
              "Ayşe Yılmaz",
              style: TextStyle(
                color: AppColors.primaryGreen, 
                fontSize: 20, 
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        actions: [
          // SAĞ ÜSTTEKİ PROFIL BUTONU
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // Profil Sayfasına Git
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryGreen,
                child: Icon(Icons.person, color: Colors.white),
                // İleride buraya kullanıcının resmi gelecek:
                // backgroundImage: AssetImage('assets/images/user.png'),
              ),
            ),
          )
        ],
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // Mood Selector (Az önce yapmıştık)
            MoodSelector(
              onMoodSelected: (score) {
              debugPrint("Seçilen Mod Puanı: $score");
              },
            ),

            // Diğer içerikler buraya...
          ],
        ),
      ),
    );
  }
}