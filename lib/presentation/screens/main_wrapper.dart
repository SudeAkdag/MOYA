import 'package:flutter/material.dart';
import 'package:moya/presentation/widgets/custom_bottom_nav_bar.dart';
import '../../presentation/widgets/side_menu_drawer.dart';
import 'home/home_screen_new.dart'; 
import 'music/music_screen.dart';
import 'blog/blog_screen.dart';
import 'meditation/meditation_screen.dart';
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
  int _lastIndex = 2;    // Ayarlardan geri dönüldüğünde kullanılacak hafıza indexi

  late final List<Widget> _allPages;

  @override
  void initState() {
    super.initState();
    _allPages = [
      const MeditationScreen(), // 0
      MusicScreen(onMenuTap: () => _scaffoldKey.currentState?.openDrawer()), // 1
      HomeScreenNew(onMenuTap: () => _scaffoldKey.currentState?.openDrawer()), // 2
      const CalendarScreen(), // 3
      const BlogScreen(), // 4
      const ProfileScreen(), // 5
      const RecordedScreen(), // 6
      const ChatbotScreen(), // 7
      const MeditationScreen(), // 8 (Yedek)
      SettingsScreen(
        onBack: () {
          setState(() {
            _currentIndex = _lastIndex; // Ayarlardan çıkınca son aktif sayfaya dön
          });
        },
      ), // 9
    ];
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

  // Mevcut sayfayı getiren yardımcı fonksiyon
  Widget _getCurrentPage() {
    if (_currentIndex >= 0 && _currentIndex < _allPages.length) {
      return _allPages[_currentIndex];
    }
    return _allPages[2]; // Hata durumunda varsayılan Ana Sayfa
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
          Expanded(child: _getCurrentPage()),
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