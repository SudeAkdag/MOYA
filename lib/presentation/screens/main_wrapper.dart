import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../presentation/widgets/side_menu_drawer.dart'; // YENİ: Drawer'ı ekledik

// Sayfalar
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
  // Drawer'ı kodla açabilmek için bu anahtara ihtiyacımız var
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 2; // Başlangıçta HOME (Index 2) açık

  final List<Widget> _pages = [
    const SizedBox(),        // 0: Menü (Burası boş, çünkü açılmayacak)
    const ChatbotScreen(),   // 1: Chatbot
    const HomeScreen(),      // 2: HOME
    const MusicScreen(),     // 3: Müzik
    const FavoritesScreen(), // 4: Favoriler
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Anahtarı buraya tanımladık
      extendBody: true,
      
      // YENİ: Yan Menüyü (Drawer) buraya ekledik
      drawer: const SideMenuDrawer(),

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
            currentIndex: _currentIndex,
            // Tıklama olayını burada yakalıyoruz
            onTap: (index) {
              if (index == 0) {
                // EĞER 0. İKONA (MENÜ) TIKLANDIYSA:
                // Sayfayı değiştirme, Çekmeceyi Aç!
                _scaffoldKey.currentState?.openDrawer();
              } else {
                // Diğer ikonlarda normal sayfa değişimi yap
                setState(() {
                  _currentIndex = index;
                });
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
              // 0. MENÜ İKONU
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_rounded), // İkonu değiştirdim
                label: 'Menü',
              ),
              // 1. CHATBOT
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline_rounded),
                activeIcon: Icon(Icons.chat_bubble_rounded),
                label: 'Asistan',
              ),
              // 2. HOME
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 30),
                label: 'Ana Sayfa',
              ),
              // 3. MÜZİK
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note_rounded),
                label: 'Müzik',
              ),
              // 4. FAVORİLER
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