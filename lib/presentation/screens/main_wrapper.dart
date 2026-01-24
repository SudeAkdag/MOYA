import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/blog/blog_screen.dart';
import 'package:moya/presentation/screens/exercise/exercise_screen.dart';
import 'package:moya/presentation/screens/meditation/meditation_screen.dart';
import 'package:moya/presentation/screens/profile/profile_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../presentation/widgets/side_menu_drawer.dart'; 

import 'home/home_screen.dart';
import 'music/music_screen.dart';
import 'chatbot/chatbot_screen.dart';
import 'favorites/favorites_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 2; // Başlangıçta HOME (Index 2) açık

  final List<Widget> _pages = [
    const SizedBox(),        // 0: Menü 
    const ChatbotScreen(),   // 1: Chatbot
    const HomeScreen(),      // 2: Ana Sayfa
    const MusicScreen(),     // 3: Müzik
    const FavoritesScreen(), // 4: Favoriler
    const ProfileScreen(),   // 5: Profil
    const ExerciseScreen(),  // 6: Egzersiz
    const MeditationScreen(),// 7: Meditasyon
    const BlogScreen(),      // 8: Blog
  ];

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to make the UI responsive
    return LayoutBuilder(
      builder: (context, constraints) {
        // WIDE layout (e.g., for tablets, web, desktop)
        if (constraints.maxWidth > 720) { // A common breakpoint for tablets
          return Scaffold(
            body: Row(
              children: [
                // The drawer becomes a permanent side menu
                SideMenuDrawer(
                  onMenuTap: (index) {
                    // Just change the page, DON'T pop the navigator
                    _changePage(index);
                  },
                ),
                // A visual divider between menu and content
                const VerticalDivider(width: 1, thickness: 1),
                // The main content area
                Expanded(
                  child: _pages[_currentIndex],
                ),
              ],
            ),
            // No BottomNavigationBar in wide layout
          );
        }
        // NARROW layout (the original code for mobile phones)
        else {
          return Scaffold(
            key: _scaffoldKey,
            extendBody: true,
            drawer: SideMenuDrawer(
              onMenuTap: (index) {
                _changePage(index);
                // On mobile, the drawer is temporary, so we pop it
                Navigator.pop(context);
              },
            ),
            body: _pages[_currentIndex],
            bottomNavigationBar: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Corrected method
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex > 4 ? 2 : _currentIndex,
                  onTap: (index) {
                    if (index == 0) {
                      _scaffoldKey.currentState?.openDrawer();
                    } else {
                      _changePage(index);
                    }
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: AppColors.primaryGreen,
                  unselectedItemColor: Colors.grey.shade400,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu_rounded),
                      label: 'Menü',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble_outline_rounded),
                      activeIcon: Icon(Icons.chat_bubble_rounded),
                      label: 'Asistan',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_rounded, size: 30),
                      label: 'Ana Sayfa',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.music_note_rounded),
                      label: 'Müzik',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border_rounded),
                      activeIcon: Icon(Icons.favorite_rounded),
                      label: 'Favoriler',
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}