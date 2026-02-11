import 'package:flutter/material.dart';

// Gerekli Widget Importları
import 'widgets/profile_header.dart';
import 'widgets/statistics_section.dart';
import 'widgets/mood_history_section.dart';
import 'widgets/account_info.dart'; 
import 'widgets/edit_profile_sheet.dart';

// Ayarlar Sayfasına Navigasyon İçin
import '../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 1. Merkezi Veri Yönetimi: Tüm kullanıcı verileri bu Map üzerinden dağıtılır
  Map<String, dynamic> userData = {
    'name': 'Ayşe Yılmaz',
    'username': 'ayseyilmaz',
    'email': 'ayse.yilmaz@ornek.com',
    'phone': '0555 555 55 55',
    'bday': '12 Mayıs 1995',
    'gender': 'Kadın',
    'focusAreas': ['Odaklanma', 'Stres Yönetimi'],
  };

  // 2. Güncelleme Fonksiyonu: Düzenleme yapıldığında arayüzü yeniler
  void _handleUpdate(Map<String, dynamic> newData) {
    setState(() {
      userData = newData;
    });
  }

  // 3. Profil Düzenleme Penceresini (Bottom Sheet) Açan Fonksiyon
  void _showEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileSheet(
        currentData: userData,
        onSave: _handleUpdate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar Yapılandırması: Bildirim zili kaldırıldı, Ayarlar simgesi eklendi
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              // Ayarlar sayfasına akıcı geçiş
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            }, 
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profil Başlığı: Fotoğraf ve dinamik isim alanı
            ProfileHeader(
              name: userData['name'], 
              onEditPressed: _showEditSheet,
            ),
            const SizedBox(height: 32),
            
            // Kullanıcı İstatistikleri (Haftalık Odak ve Seri Bilgisi)
            const StatisticsSection(),
            const SizedBox(height: 32),
            
            // Ruh Hali Takip Grafiği
            const MoodHistorySection(),
            const SizedBox(height: 32),
            
            // Hesap Bilgileri Listesi: Tam siyah metinli detaylar
            AccountInfoCard(userData: userData, email: '', birthday: '',), 
            const SizedBox(height: 32),
          ],
        ),
      ),
      // Alt Sağdaki Yardımcı Mesajlaşma Butonu
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Buraya ileride chatbot veya mesajlaşma eklenebilir
        },
        child: const Icon(Icons.forum),
      ),
    );
  }
}