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

  int _currentIndex = 2; // Başlangıç ekranı: Ana Sayfa
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
    switch (index) {
      case 0: 
        return MeditationScreen(onMenuTap: () => _scaffoldKey.currentState?.openDrawer());
      case 1: 
        return MusicScreen(onMenuTap: () => _scaffoldKey.currentState?.openDrawer());
      case 2: 
        return HomeScreenNew(
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
          onProfileTap: () => _onItemTapped(5),
        );
      case 3: 
        return CalendarScreen(onMenuTap: () => _scaffoldKey.currentState?.openDrawer());
      case 4: 
        return BlogScreen(onMenuTap: () => _scaffoldKey.currentState?.openDrawer());
      case 5: 
        return ProfileScreen(onBack: () => setState(() => _currentIndex = _lastIndex));
      
      // DÜZELTİLEN KISIM BURASI: RecordedScreen'e menü açma yetkisi verildi
      case 6: 
        return RecordedScreen(onMenuTap: () => _scaffoldKey.currentState?.openDrawer());
      
      case 7: return const ChatbotScreen();
      case 9: 
        return SettingsScreen(onBack: () => setState(() => _currentIndex = _lastIndex));
      default:
        return const Center(child: Text("Sayfa Bulunamadı"));
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
              Navigator.pop(context); 
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