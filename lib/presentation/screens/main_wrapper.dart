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
    return Scaffold(
      key: _scaffoldKey, 
      extendBody: true, 
      
      drawer: SideMenuDrawer(
        onMenuTap: (index) {
          _changePage(index); 
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
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            // DÜZELTİLEN SATIR BURASI 👇
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
}