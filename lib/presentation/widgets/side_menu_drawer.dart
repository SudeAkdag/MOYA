import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SideMenuDrawer extends StatelessWidget {
  // Ana ekrandan gelen sayfa değiştirme fonksiyonunu alıyoruz
  final Function(int) onMenuTap; 

  const SideMenuDrawer({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF9F4EA),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryGreen),
            accountName: const Text("Ayşe Yılmaz", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: const Text("ayse.yilmaz@ornek.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppColors.primaryGreen),
            ),
          ),

          // YENİ YÖNTEM: Push yerine index gönderiyoruz
         // YENİ YÖNTEM: Doğru sayfa numaraları (index) gönderiliyor
_buildMenuItem(Icons.person_outline, "Profil", () => onMenuTap(5)), // 5. Sayfa
_buildMenuItem(Icons.fitness_center, "Egzersiz", () => onMenuTap(6)), // 6. Sayfa
_buildMenuItem(Icons.self_improvement, "Meditasyon", () => onMenuTap(7)), // 7. Sayfa

// Müzik sayfası listede 3. sırada olduğu için onu değiştirmiyoruz
_buildMenuItem(Icons.music_note, "Müzik", () => onMenuTap(3)), 

_buildMenuItem(Icons.article_outlined, "Blog", () => onMenuTap(8)), // 8. Sayfa
          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Çıkış Yap", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              // Giriş ekranına yönlendirme kodu buraya gelecek
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}