import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/E&M/meditation_screen.dart';
import 'package:moya/presentation/screens/blog/blog_screen.dart';
import 'package:moya/presentation/screens/calendar/calendar_screen.dart';
import 'package:moya/presentation/screens/chatbot/chatbot_screen.dart';
import 'package:moya/presentation/screens/home/home_screen_new.dart';
import 'package:moya/presentation/screens/music/music_screen.dart';
import 'package:moya/presentation/screens/profile/profile_screen.dart' show ProfileScreen;
import 'package:moya/presentation/screens/recording/recorded_screen.dart';
import 'package:moya/presentation/screens/settings/settings_screen.dart';
import 'package:moya/presentation/widgets/custom_bottom_nav_bar.dart';
import '../../presentation/widgets/side_menu_drawer.dart';


class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  // 🔑 Drawer'ı açmak için gereken anahtar
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 2; // Başlangıç: Ana Sayfa
  int _lastIndex = 2; 

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        if (index == 5 || index == 9) {
          _lastIndex = _currentIndex;
        }
        _currentIndex = index;
      });
    }
  }

  Widget _buildPage(int index) {
    // Merkezi drawer açma fonksiyonu
    final VoidCallback openDrawer = () => _scaffoldKey.currentState?.openDrawer();

    switch (index) {
      case 0: return MeditationScreen(onMenuTap: openDrawer);
      case 1: return MusicScreen(onMenuTap: openDrawer);
      case 2: 
        return HomeScreenNew(
          onMenuTap: openDrawer, // 🚀 Artık side bar'ı açar
          onProfileTap: () => _onItemTapped(5), // 🚀 Artık profile götürer
        );
      case 3: return CalendarScreen(onMenuTap: openDrawer);
      case 4: return BlogScreen(onMenuTap: openDrawer);
      case 5: return ProfileScreen(onBack: () => setState(() => _currentIndex = _lastIndex));
      case 6: return RecordedScreen(onMenuTap: openDrawer);
      case 7: return const ChatbotScreen();
      case 9: return SettingsScreen(onBack: () => setState(() => _currentIndex = _lastIndex));
      default: return const Center(child: Text("Sayfa Bulunamadı"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWideLayout = MediaQuery.of(context).size.width > 720;

    return Scaffold(
      key: _scaffoldKey, // 🔑 Scaffold anahtarı bağlandı
      extendBody: true, 
      
      // Side Bar (Drawer)
      drawer: isWideLayout
          ? null
          : SideMenuDrawer(onMenuTap: (index) {
              _onItemTapped(index);
              Navigator.pop(context); // Tıklayınca menüyü kapat
            }),

      body: Row(
        children: [
          if (isWideLayout) ...[
            SideMenuDrawer(onMenuTap: _onItemTapped),
            VerticalDivider(
              width: 1, 
              thickness: 1, 
              color: theme.dividerColor.withOpacity(0.1),
            ),
          ],
          Expanded(child: _buildPage(_currentIndex)),
        ],
      ),

      // Alt Menü
      bottomNavigationBar: isWideLayout 
          ? null 
          : CustomBottomNavBar(
              selectedIndex: _currentIndex,
              onItemTapped: _onItemTapped,
            ),
    );
  }
}