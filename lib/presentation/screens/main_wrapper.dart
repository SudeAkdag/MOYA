import 'package:flutter/material.dart';
import 'package:moya/presentation/widgets/custom_bottom_nav_bar.dart';
import '../../presentation/widgets/side_menu_drawer.dart';
import 'home/home_screen_new.dart'; // Yeni ana sayfa
import 'music/music_screen.dart';
import 'blog/blog_screen.dart';
import 'meditation/meditation_screen.dart';
import 'profile/profile_screen.dart';
import 'recording/recorded_screen.dart';
import 'chatbot/chatbot_screen.dart';
import 'settings/settings_screen.dart';
import 'package:moya/presentation/screens/calendar/calendar_screen.dart';
import 'about/about_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Yeni navigasyon düzenine göre index'ler
  // 0: Egzersiz, 1: Müzik, 2: Ana Sayfa, 3: Takvim, 4: Blog
  int _currentIndex = 2; // Başlangıç: Ana Sayfa

  // Sayfa listesini yeni tasarıma göre güncelle
  // SideMenu'dan gelen index'leri de yönetebilmek için geniş bir liste tutuyoruz.
  late final List<Widget> _allPages;

  @override
  void initState() {
    super.initState();
    _allPages = [
      const MeditationScreen(), // 8 // 0 -> Nav Bar 0
    MusicScreen(onMenuTap: () => _scaffoldKey.currentState?.openDrawer()),
      HomeScreenNew(onMenuTap: () => _scaffoldKey.currentState?.openDrawer()), // 2 -> Nav Bar 2 (Ana Sayfa)
      const CalendarScreen(), // 3 -> Nav Bar 3
      const BlogScreen(), // 4 -> Nav Bar 4
      // Alt kısımdakiler SideMenu'dan erişilenler
      const ProfileScreen(), // 5
      const RecordedScreen(), // 6
      const ChatbotScreen(), // 7
      const MeditationScreen(), // 8
      const SettingsScreen(), // 9
      const AboutScreen(), // 10
    ];
  }

  // Gösterilecek mevcut sayfa
  Widget _getCurrentPage() {
    if (_currentIndex >= 0 && _currentIndex < _allPages.length) {
      return _allPages[_currentIndex];
    }
    return _allPages[2]; // Varsayılan Ana Sayfa
  }

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
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
      extendBody: true, // Bottom bar arkasının görünmesi için
      drawer: isWideLayout
          ? null
          : SideMenuDrawer(onMenuTap: (index) {
              _onItemTapped(index);
              Navigator.pop(context);
            }),
      body: Row(
        children: [
          if (isWideLayout) ...[
            SideMenuDrawer(onMenuTap: _onItemTapped),
            VerticalDivider(width: 1, thickness: 1, color: theme.dividerColor.withAlpha(100)),
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