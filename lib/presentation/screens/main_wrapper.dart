import 'package:flutter/material.dart';
import 'package:moya/presentation/widgets/custom_bottom_nav_bar.dart';
import '../../presentation/widgets/side_menu_drawer.dart';
import 'home/home_screen_new.dart'; // Yeni ana sayfa
import 'music/music_screen.dart';
import 'blog/blog_screen.dart';
import 'exercise/exercise_screen.dart';
import 'meditation/meditation_screen.dart';
import 'profile/profile_screen.dart';
import 'favorites/favorites_screen.dart';
import 'chatbot/chatbot_screen.dart';

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
  static const List<Widget> _allPages = [
    ExerciseScreen(),       // 0 -> Nav Bar 0
    MusicScreen(),          // 1 -> Nav Bar 1
    HomeScreenNew(),        // 2 -> Nav Bar 2 (Ana Sayfa)
    SizedBox(child: Center(child: Text("Takvim (Yakında)"))), // 3 -> Nav Bar 3
    BlogScreen(),           // 4 -> Nav Bar 4
    // Alt kısımdakiler SideMenu'den erişilenler
    ProfileScreen(),        // 5
    FavoritesScreen(),      // 6
    ChatbotScreen(),        // 7
    MeditationScreen(),     // 8
  ];

  // Gösterilecek mevcut sayfa
  Widget _getCurrentPage() {
    // Navigasyon barı index'leri doğrudan _allPages'deki ilk 5 sayfaya karşılık gelir.
    if (_currentIndex >= 0 && _currentIndex < 5) {
      return _allPages[_currentIndex];
    }
    // SideMenu'den gelen diğer index'ler için
    switch (_currentIndex) {
      case 5: return _allPages[5]; // Profil
      case 6: return _allPages[6]; // Favoriler
      case 7: return _allPages[7]; // Asistan
      case 8: return _allPages[8]; // Meditasyon
      default: return _allPages[2]; // Varsayılan Ana Sayfa
    }
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
            VerticalDivider(width: 1, thickness: 1, color: theme.dividerColor.withOpacity(0.1)),
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