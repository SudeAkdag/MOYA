import 'dart:ui';
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
  final List<int> _navigationHistory = []; // Geri tuşu geçmişi
  bool _isDrawerOpen = false; // Çekmece durumu

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        if (index < 5) {
          // Alt menüden (bottom nav bar) seçim yapıldığında geçmişi temizle
          _navigationHistory.clear();
        } else if (index == 5 || index == 6 || index == 9) {
          // Side bar üzerinden (Profil, Kaydedilenler, Ayarlar) bir sayfaya geçiliyorsa
          // Geçerli olan (şu anki) sayfayı geçmiş listesine ekle
          _navigationHistory.add(_currentIndex);
        }
        _currentIndex = index;
      });
    }
  }

  void _onBack() {
    setState(() {
      if (_navigationHistory.isNotEmpty) {
        // En son kaydedilen sayfaya geri dön ve onu geçmişten sil
        _currentIndex = _navigationHistory.removeLast();
      } else {
        // Geçmiş yoksa varsayılan olarak ana sayfaya dön
        _currentIndex = 2; 
      }
    });
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
        return ProfileScreen(onBack: _onBack);
      
      case 6: 
        return RecordedScreen(
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
          onBack: _onBack,
        );
      
      case 7: return const ChatbotScreen();
      case 9: 
        return SettingsScreen(onBack: _onBack);
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
      drawerScrimColor: Colors.transparent, // Ekranın kararmasını önler
      
      onDrawerChanged: (isOpened) {
        setState(() {
          _isDrawerOpen = isOpened;
        });
      },

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
          Expanded(
            child: Stack(
              children: [
                _buildPage(_currentIndex),
                // Çekmece açıldığında arkaplanı flu yap
                if (!isWideLayout)
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: !_isDrawerOpen,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0.0,
                          end: _isDrawerOpen ? 5.0 : 0.0,
                        ),
                        duration: const Duration(milliseconds: 250),
                        builder: (context, blurValue, child) {
                          if (blurValue == 0.0) return const SizedBox();
                          return BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: blurValue,
                              sigmaY: blurValue,
                            ),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
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