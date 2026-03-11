import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Kendi dosya yollarınla değiştirmen gerekebilir
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Düzenleme sayfasını açan ve veriyi gönderen fonksiyon
  void _showEditSheet(Map<String, dynamic> currentData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileSheet(
        currentData: currentData,
        onSave: (newData) async {
          // Firebase'e kaydetme işlemi
          String uid = _auth.currentUser!.uid;
          await _firestore.collection('users').doc(uid).set(newData, SetOptions(merge: true));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String uid = _auth.currentUser?.uid ?? "";

    if (uid.isEmpty) {
      return const Scaffold(body: Center(child: Text("Lütfen giriş yapın.")));
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          // Firestore'dan anlık veri dinleme
          stream: _firestore.collection('users').doc(uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const Center(child: Text("Hata oluştu"));
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            // Eğer veritabanında henüz bu kullanıcı yoksa varsayılan boş bir map döner
            final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};

            return Column(
              children: [
                // --- ÜST BAR ---
                _buildTopBar(context),
                
                // --- KAYDIRILABİLİR İÇERİK ---
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        ProfileHeader(
                          // Veritabanından gelen ismi kullan, yoksa "İsimsiz" yaz
                          name: userData['name'] ?? 'İsimsiz', 
                          onEditPressed: () => _showEditSheet(userData),
                        ),
                        const SizedBox(height: 32),
                        const StatisticsSection(),
                        const SizedBox(height: 24),
                        const MoodHistorySection(),
                        const SizedBox(height: 32),
                        // Hesap bilgileri kartına veritabanı verilerini gönderiyoruz
                        AccountInfoCard(
                          userData: userData, 
                          email: userData['email'] ?? '', 
                          birthday: userData['bday'] ?? '',
                        ), 
                        const SizedBox(height: 100), 
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: widget.onBack, 
          ),
          const Text('Profil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
    );
  }
}