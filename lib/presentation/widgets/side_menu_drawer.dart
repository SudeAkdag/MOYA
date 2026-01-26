import 'package:flutter/material.dart';

class SideMenuDrawer extends StatelessWidget {
  final Function(int) onMenuTap; 

  const SideMenuDrawer({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    // 1. Temaya erişim
    final theme = Theme.of(context);

    return Drawer(
      // 2. Arka plan rengini temadan alıyoruz
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              // 3. Header kısmını temanın ana rengi yapıyoruz
              color: theme.primaryColor,
            ),
            accountName: Text(
              "Ayşe Yılmaz", 
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white, // Header içi yazı genelde sabit kalabilir veya temadan çekilebilir
              ),
            ),
            accountEmail: const Text(
              "ayse.yilmaz@ornek.com",
              style: TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.scaffoldBackgroundColor,
              child: Icon(
                Icons.person, 
                size: 40, 
                color: theme.primaryColor,
              ),
            ),
          ),

          // Menü Öğeleri
          _buildMenuItem(theme, Icons.person_outline, "Profil", () => onMenuTap(5)),
          _buildMenuItem(theme, Icons.self_improvement, "Egzersiz ve Meditasyon", () => onMenuTap(8)),
          _buildMenuItem(theme, Icons.music_note, "Müzik", () => onMenuTap(1)), 
          _buildMenuItem(theme, Icons.article_outlined, "Blog", () => onMenuTap(4)),
          _buildMenuItem(theme, Icons.bookmark_border, "Kaydedilenler", () => onMenuTap(6)),
          _buildMenuItem(theme, Icons.settings, "Ayarlar", () => onMenuTap(9)),
          _buildMenuItem(theme, Icons.info_outline, "Hakkında", () => onMenuTap(10)),
          
          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              "Çıkış Yap", 
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              // Çıkış mantığı buraya
            },
          ),
        ],
      ),
    );
  }

  // Yardımcı metodun içine 'theme' parametresini ekleyerek performansı koruyoruz
  Widget _buildMenuItem(ThemeData theme, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon, 
        // İkon rengi artık temanın ana rengini takip ediyor
        color: theme.primaryColor,
      ),
      title: Text(
        title, 
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}