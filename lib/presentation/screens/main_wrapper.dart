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
  // GlobalKey: BlogScreen gibi alt sayfalardan Sidebar'ı tetiklemek için şart.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 2; // Başlangıç ekranı: Ana Sayfa
  int _lastIndex = 2; 

  // Sayfa değişim yönetimi
  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        // Profil (5) veya Ayarlar (9) açıldığında eski sayfayı hatırla
        if (index == 5 || index == 9) {
          _lastIndex = _currentIndex;
        }
        _currentIndex = index;
      });
    }
  }

  // Sayfa içerikleri
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
        // Sidebar'ı buradan tetikliyoruz
        return BlogScreen(onMenuTap: () => _scaffoldKey.currentState?.openDrawer());
      case 5: 
        return ProfileScreen(onBack: () => setState(() => _currentIndex = _lastIndex));
      case 6: return const RecordedScreen();
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
      key: _scaffoldKey, // Alt sayfalardaki menü butonlarının çalışması için
      extendBody: true, // Alt barın içeriğin üzerine hafif binmesini sağlar (tasarımsal)
      
      // 1. ADIM: Sidebar'ı buraya (Scaffold'un drawer kısmına) ekledik.
      // Drawer burada olduğu sürece açıldığında BottomNavigationBar'ın ÜSTÜNE biner ve onu kapatır.
      drawer: isWideLayout
          ? null
          : SideMenuDrawer(onMenuTap: (index) {
              _onItemTapped(index);
              Navigator.pop(context); // Menüden seçim yapınca sidebarı kapat
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
          // Ana içerik alanı
          Expanded(child: _buildPage(_currentIndex)),
        ],
      ),

      // 2. ADIM: Alt Navigasyon Barı
      // Drawer açıldığında Scaffold otomatik olarak bu barın üzerine gölge (overlay) atar ve kapatır.
      bottomNavigationBar: isWideLayout 
          ? null 
          : CustomBottomNavBar(
              selectedIndex: _currentIndex,
              onItemTapped: _onItemTapped,
            ),
    );
  }
}