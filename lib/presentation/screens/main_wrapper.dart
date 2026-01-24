import 'package:flutter/material.dart';
import '../../presentation/widgets/side_menu_drawer.dart'; 
import 'home/home_screen.dart';
import 'music/music_screen.dart';
import 'chatbot/chatbot_screen.dart';
import 'favorites/favorites_screen.dart';
import 'blog/blog_screen.dart';
import 'exercise/exercise_screen.dart';
import 'meditation/meditation_screen.dart';
import 'profile/profile_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 2; // Başlangıç: Home

  final List<Widget> _pages = const [
    SizedBox(),              // 0: Menü Tetikleyici
    ChatbotScreen(),        // 1: Asistan
    HomeScreen(),           // 2: Ana Sayfa
    MusicScreen(),          // 3: Müzik
    FavoritesScreen(),      // 4: Favoriler
    ProfileScreen(),        // 5: Profil
    ExerciseScreen(),       // 6: Egzersiz
    MeditationScreen(),     // 7: Meditasyon
    BlogScreen(),           // 8: Blog
  ];

  void _changePage(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideLayout = constraints.maxWidth > 720;

        return Scaffold(
          key: _scaffoldKey,
          extendBody: true, // Bottom bar arkasının görünmesi için
          drawer: isWideLayout 
              ? null 
              : SideMenuDrawer(onMenuTap: (index) {
                  _changePage(index);
                  Navigator.pop(context);
                }),
          body: Row(
            children: [
              if (isWideLayout) ...[
                SideMenuDrawer(onMenuTap: _changePage),
                VerticalDivider(width: 1, thickness: 1, color: theme.dividerColor.withValues(alpha: 0.1)),
              ],
              Expanded(child: _pages[_currentIndex]),
            ],
          ),
          bottomNavigationBar: isWideLayout ? null : _buildBottomNavBar(theme),
        );
      },
    );
  }

  Widget _buildBottomNavBar(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        // Kart rengini (surface) arka plan yapıyoruz
        color: theme.cardTheme.color, 
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          // Menü dışındaki indexleri Ana Sayfa (2) olarak işaretle
          currentIndex: _currentIndex > 4 ? 2 : _currentIndex,
          onTap: (index) {
            if (index == 0) {
              _scaffoldKey.currentState?.openDrawer();
            } else {
              _changePage(index);
            }
          },
          // Tema verilerini kullanıyoruz
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: theme.primaryColor,
          unselectedItemColor: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: 'Menü'),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              activeIcon: Icon(Icons.chat_bubble_rounded),
              label: 'Asistan',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 30), label: 'Ana Sayfa'),
            BottomNavigationBarItem(icon: Icon(Icons.music_note_rounded), label: 'Müzik'),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: 'Favoriler',
            ),
          ],
        ),
      ),
    );
  }
}