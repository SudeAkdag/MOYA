import 'package:flutter/material.dart';

// Gerekli Widget Importları (Dosya yollarını projenize göre kontrol edin)
import 'widgets/profile_header.dart';
import 'widgets/statistics_section.dart';
import 'widgets/mood_history_section.dart';
import 'widgets/account_info.dart'; 
import 'widgets/edit_profile_sheet.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ProfileScreen({super.key, required this.onBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Merkezi Veri Yönetimi
  Map<String, dynamic> userData = {
    'name': 'Ayşe Yılmaz',
    'username': 'ayseyilmaz',
    'email': 'ayse.yilmaz@moya.com',
    'phone': '0555 555 55 55',
    'bday': '12 Mayıs 1995',
    'gender': 'Kadın',
    'focusAreas': ['Odaklanma', 'Stres Yönetimi'],
  };

  void _handleUpdate(Map<String, dynamic> newData) {
    setState(() {
      userData = newData;
    });
  }

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // SafeArea üst çubuktaki saat/pil gibi alanlarla çakışmayı önler
      body: SafeArea(
        child: Column(
          children: [
            // --- SABİT ÜST BAR (Kaymaz) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
                    onPressed: widget.onBack,
                  ),
                  const Text(
                    'Profil',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Colors.black87),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // --- KAYDIRILABİLİR İÇERİK ---
            Expanded(
              child: SingleChildScrollView(
                // ClampingScrollPhysics: Sayfanın sınırlardan dışarı esnemesini (boşluk kalmasını) engeller
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Profil Başlığı (Resim ve "Profili Düzenle" butonu içerir)
                    ProfileHeader(
                      name: userData['name'], 
                      onEditPressed: _showEditSheet,
                    ),
                    const SizedBox(height: 32),
                    
                    // İstatistikler Bölümü (Odak ve Seri Kartları)
                    const StatisticsSection(),
                    const SizedBox(height: 24),

                    // Tamamlanan Görevler Kartı (Görseldeki %75'lik ilerleme)
                    _buildTaskProgressCard(theme),
                    const SizedBox(height: 32),
                    
                    // Ruh Hali Geçmişi Bölümü (Grafik)
                    const MoodHistorySection(),
                    const SizedBox(height: 32),
                    
                    // Kişisel Bilgiler / Hesap Kartı
                    AccountInfoCard(
                      userData: userData, 
                      email: userData['email'], 
                      birthday: userData['bday'],
                    ), 
                    
                    // Alt navigasyon barın üzerine gelmemesi için boşluk
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Görseldeki "Tamamlanan Görevler" kartını oluşturan yardımcı metod
  Widget _buildTaskProgressCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('TAMAMLANAN', style: TextStyle(fontSize: 12, color: Colors.black54, letterSpacing: 1.1)),
              SizedBox(height: 4),
              Text('42 Görev', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(
            width: 55,
            height: 55,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.75,
                  strokeWidth: 6,
                  backgroundColor: Colors.white,
                  color: theme.primaryColor,
                ),
                const Text('75%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}