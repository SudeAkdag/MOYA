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
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          String userName = "Yükleniyor...";
          String userEmail = "...";
          String initials = "M"; // Varsayılan Baş Harf

          if (snapshot.hasData && snapshot.data!.exists) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            userName = userData['name'] ?? "İsimsiz Kullanıcı";
            userEmail = userData['email'] ?? "E-posta yok";
            
            // İsimden baş harf oluşturma (Sude Naz -> SN)
            if (userName != "İsimsiz Kullanıcı") {
              List<String> nameParts = userName.trim().split(' ');
              initials = nameParts.length >= 2 
                ? (nameParts[0][0] + nameParts[nameParts.length - 1][0]).toUpperCase()
                : userName[0].toUpperCase();
            }
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: theme.primaryColor),
                accountName: Text(
                  userName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  userEmail,
                  style: const TextStyle(color: Colors.white70),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      color: theme.primaryColor
                    ),
                  ),
                ),
              ),

              _buildMenuItem(theme, Icons.person_outline, "Profil", () => onMenuTap(5)),
              _buildMenuItem(theme, Icons.self_improvement, "Egzersiz ve Meditasyon", () => onMenuTap(0)),
              _buildMenuItem(theme, Icons.music_note, "Müzik", () => onMenuTap(1)),
              _buildMenuItem(theme, Icons.calendar_month_outlined, "Takvim", () => onMenuTap(3)), 
              _buildMenuItem(theme, Icons.article_outlined, "Blog", () => onMenuTap(4)),
              _buildMenuItem(theme, Icons.bookmark_border, "Kaydedilenler", () => onMenuTap(6)),
              _buildMenuItem(theme, Icons.settings, "Ayarlar", () => onMenuTap(9)),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  "Çıkış Yap",
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                onTap: () => _handleLogout(context, viewModel),
              ),
            ],
          );
        }
      ),
    );
  }

  void _handleLogout(BuildContext context, LoginViewModel viewModel) async {
    // Önce Drawer'ı kapat
    Navigator.of(context).pop();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Kalıcı çıkış kaydı
    await viewModel.logout(); // Firebase ve ViewModel temizliği
    
    // Stack'i temizle ve Login ekranına gönder
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget _buildMenuItem(ThemeData theme, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: theme.primaryColor),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}