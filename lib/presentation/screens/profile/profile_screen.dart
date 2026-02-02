import 'package:flutter/material.dart';
import 'widgets/profile_header.dart';
import 'widgets/statistics_section.dart';
import 'widgets/mood_history_section.dart';
import 'widgets/account_info.dart'; 
import 'widgets/edit_profile_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 1. Merkezi Veri Yönetimi (Map kullanarak tüm bilgileri bir arada tutuyoruz)
  Map<String, dynamic> userData = {
    'name': 'Ayşe Yılmaz',
    'username': 'ayseyilmaz',
    'email': 'ayse.yilmaz@ornek.com',
    'phone': '0555 555 55 55',
    'bday': '12 Mayıs 1995',
    'gender': 'Kadın',
    'focusAreas': ['Odaklanma', 'Stres Yönetimi'], // Çoklu seçim alanı
  };

  // 2. Güncelleme Fonksiyonu: Pop-up'tan gelen Map'i buraya kaydediyoruz
  void _handleUpdate(Map<String, dynamic> newData) {
    setState(() {
      userData = newData;
    });
  }

  // 3. Düzenleme Penceresini Açan Fonksiyon
  void _showEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileSheet(
        currentData: userData, // Mevcut verileri gönderiyoruz
        onSave: _handleUpdate, // Güncelleme fonksiyonunu bağlıyoruz
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header'a güncel ismi gönderiyoruz
            ProfileHeader(
              name: userData['name'], 
              onEditPressed: _showEditSheet,
            ),
            const SizedBox(height: 32),
            
            const StatisticsSection(),
            const SizedBox(height: 32),
            
            const MoodHistorySection(),
            const SizedBox(height: 32),
            
            // Tüm userData Map'ini AccountInfoCard'a gönderiyoruz
            AccountInfoCard(userData: userData, email: '', birthday: '',), 
            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.forum),
      ),
    );
  }
}