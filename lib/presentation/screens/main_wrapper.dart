import 'package:flutter/material.dart';
import 'package:moya/presentation/widgets/custom_bottom_nav_bar.dart';
import '../../presentation/widgets/side_menu_drawer.dart';
import 'home/home_screen_new.dart'; 
import 'music/music_screen.dart';
import 'blog/blog_screen.dart';
import 'E&M/meditation_screen.dart';
import 'profile/profile_screen.dart';
import 'recording/recorded_screen.dart';
import 'chatbot/chatbot_screen.dart';
import 'settings/settings_screen.dart';
import 'package:moya/presentation/screens/calendar/calendar_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Navigasyon index yönetimi
  int _currentIndex = 2; // Başlangıç ekranı: Ana Sayfa
  int _lastIndex = 2;    // Ayarlardan veya profilden geri dönüldüğünde kullanılacak hafıza indexi

  // Sayfaları oluşturan yardımcı fonksiyon
  Widget _buildPage(int index) {
    switch (index) {
      case 0: return const MeditationScreen();
      case 1: return MusicScreen(onMenuTap: () => _scaffoldKey.currentState?.openDrawer());
      case 2: 
        return HomeScreenNew(
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
          onProfileTap: () => _onItemTapped(5), // SÖ butonuna basınca profile git
        );
      case 3: return const CalendarScreen();
      case 4: return const BlogScreen();
      case 5: 
        return ProfileScreen(
          onBack: () => _onItemTapped(2), // Geri tuşuna basınca ana sayfaya (index 2) dön
        );
      case 6: return const RecordedScreen();
      case 7: return const ChatbotScreen();
      case 8: return const MeditationScreen();
      case 9: 
        return SettingsScreen(
          onBack: () {
            setState(() {
              _currentIndex = _lastIndex; 
            });
          },
        );
      default:
        return const Center(child: Text("Sayfa Bulunamadı"));
    }
  }

  // Sayfa seçimini ve hafıza kaydını yöneten fonksiyon
  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        // Eğer Ayarlar'a (9) gitmiyorsak, şu anki sayfayı "son aktif sayfa" olarak kaydet
        if (_currentIndex != 9) {
          _lastIndex = _currentIndex;
        }
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWideLayout = MediaQuery.of(context).size.width > 720;

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true, 
      drawer: isWideLayout
          ? null
          : SideMenuDrawer(onMenuTap: (index) {
              _onItemTapped(index);
              Navigator.pop(context); // Menüyü kapat
            }),
      body: Row(
        children: [
          if (isWideLayout) ...[
            SideMenuDrawer(onMenuTap: _onItemTapped),
            VerticalDivider(
              width: 1, 
              thickness: 1, 
              color: theme.dividerColor.withAlpha(100),
            ),
          ],
          Expanded(child: _buildPage(_currentIndex)),
        ],
      ),
      bottomNavigationBar: isWideLayout 
          ? null 
          : CustomBottomNavBar(
              selectedIndex: _currentIndex,
              onItemTapped: _onItemTapped,
            ),
    );
  }
}