import 'package:flutter/material.dart';
import 'package:moya/main.dart'; // 🔥 navigatorKey buradan gelmeli
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

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: theme.primaryColor),
            accountName: Text(
              "Ayşe Yılmaz",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            accountEmail: const Text(
              "ayse.yilmaz@ornek.com",
              style: TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.scaffoldBackgroundColor,
              child: Icon(Icons.person, size: 40, color: theme.primaryColor),
            ),
          ),

          // --- Menü Öğeleri ---
          _buildMenuItem(theme, Icons.person_outline, "Profil", () => onMenuTap(5)),
          _buildMenuItem(theme, Icons.self_improvement, "Egzersiz ve Meditasyon", () => onMenuTap(0)),
          _buildMenuItem(theme, Icons.music_note, "Müzik", () => onMenuTap(1)),
          
          // Müzik ve Blog arasına eklendi (Index 3: Takvim)
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
      ),
    );
  }

  void _handleLogout(BuildContext context, LoginViewModel viewModel) async {
    Navigator.of(context).pop();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await viewModel.logout();
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