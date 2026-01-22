import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SideMenuDrawer extends StatelessWidget {
  const SideMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF9F4EA), // Krem rengi arka plan
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 1. ÜST KISIM (Kullanıcı Bilgileri)
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen, // Yeşil Başlık
            ),
            accountName: const Text(
              "Ayşe Yılmaz",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: const Text("ayse.yilmaz@ornek.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppColors.primaryGreen),
            ),
          ),

          // 2. MENÜ LİSTESİ
          _buildMenuItem(Icons.person_outline, "Profil", () {}),
          _buildMenuItem(Icons.settings_outlined, "Ayarlar", () {}),
          _buildMenuItem(Icons.notifications_outlined, "Bildirimler", () {}),
          _buildMenuItem(Icons.language, "Dil Seçimi (TR)", () {}),
          
          const Divider(), // Araya çizgi atar
          
          _buildMenuItem(Icons.help_outline, "Yardım & Destek", () {}),
          _buildMenuItem(Icons.info_outline, "Hakkında", () {}),
          
          const SizedBox(height: 20),
          
          // Çıkış Yap Butonu
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              "Çıkış Yap",
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Çıkış işlemleri buraya
            },
          ),
        ],
      ),
    );
  }

  // Menü elemanlarını tek tek yazmamak için yardımcı fonksiyon
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black87),
      ),
      onTap: onTap,
    );
  }
}