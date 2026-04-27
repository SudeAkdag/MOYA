import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart';  
import 'package:moya/main.dart'; 
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/auth/login/login_screen.dart';
import '../../data/models/login_view_model.dart';

class SideMenuDrawer extends StatelessWidget {
  final Function(int) onMenuTap;

  const SideMenuDrawer({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.read<LoginViewModel>();
    
    // Aktif kullanıcının ID'sini alıyoruz
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Drawer(
      backgroundColor: Colors.transparent, // Flu etki için şeffaf
      elevation: 0,
      width: 320, // Çekmece genişliği
      child: SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 288, // Tasarımdaki w-72 (288px) genişliğine benzer
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor.withOpacity(0.7),
              borderRadius: BorderRadius.circular(32), // rounded-[2rem]
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.36),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24), // Tasarımdaki blur(24px)
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
                  builder: (context, snapshot) {
                    String userName = "Yükleniyor...";

                    if (snapshot.hasData && snapshot.data!.exists) {
                      final userData = snapshot.data!.data() as Map<String, dynamic>;
                      userName = userData['name'] ?? "İsimsiz Kullanıcı";
                    }

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Sadece içeriği kadar yer kaplasın
                        children: [
                          // --- Profil Kısmı (Spotify Tarzı) ---
                          InkWell(
                            onTap: () {
                              onMenuTap(5); // Profil sayfasına yönlendir
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: theme.primaryColor.withOpacity(0.2),
                                    child: Icon(Icons.person, size: 28, color: theme.primaryColor),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName,
                                          style: theme.textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Profili görüntüle",
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.textTheme.bodySmall?.color ?? Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          Divider(height: 1, color: theme.dividerColor.withOpacity(0.1)),
                    
                          // --- Menü Öğeleri (Üst Tarafta) ---
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: Column(
                              children: [
                                _buildMenuItem(context, theme, Icons.bookmark_border, "Kaydedilenler", () => onMenuTap(6)),
                                _buildMenuItem(context, theme, Icons.settings, "Ayarlar", () => onMenuTap(9)),
                              ],
                            ),
                          ),
                    
                          Divider(height: 1, color: theme.dividerColor.withOpacity(0.1)),
                    
                          // --- Çıkış Yap ---
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              leading: const Icon(Icons.logout, color: Colors.redAccent),
                              title: const Text(
                                "Çıkış Yap",
                                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                              ),
                              onTap: () => _showLogoutDialog(context, viewModel),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, ThemeData theme, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Html'deki rounded-full yapısı
      leading: Icon(icon, color: theme.iconTheme.color),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      onTap: onTap, // Menüden seçim yapıldığında main_wrapper çekmeceyi kapatıyor
    );
  }

  void _showLogoutDialog(BuildContext context, LoginViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Çıkış Yap"),
          content: const Text("Çıkış yapmak istediğine emin misin?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(), // Hayır - İptal et
              child: const Text("Hayır"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dialogu kapat
                _handleLogout(context, viewModel); // Çıkış işlemini yap
              },
              child: const Text(
                "Evet",
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(BuildContext context, LoginViewModel viewModel) async {
    Navigator.of(context).pop(); // Çekmeceyi kapat
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await viewModel.logout();
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}