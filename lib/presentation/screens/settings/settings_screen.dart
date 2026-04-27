import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moya/core/theme/app_theme.dart';
import 'package:moya/core/theme/bloc/theme_bloc.dart';
import 'package:moya/core/theme/bloc/theme_event.dart';
import 'package:moya/core/theme/bloc/theme_state.dart';
import 'package:moya/presentation/widgets/custom_bottom_nav_bar.dart';
import 'widgets/settings_group.dart';
import 'widgets/settings_tile.dart';
import '../about/about_screen.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const SettingsScreen({super.key, this.onBack});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isPushNotificationsEnabled = true;
  bool isLoading = true;

  // Tema seçenekleri ve önizleme renkleri
  final List<Map<String, dynamic>> _themeOptions = [
    {'type': AppThemeType.nature, 'color': const Color(0xFF606C38), 'label': 'Doğa'},
    {'type': AppThemeType.ocean, 'color': const Color(0xFF0077B6), 'label': 'Okyanus'},
    {'type': AppThemeType.pink, 'color': const Color(0xFFD81B60), 'label': 'Bulut'},
    {'type': AppThemeType.brown, 'color': const Color(0xFF99582A), 'label': 'Toprak'},
    {'type': AppThemeType.purple, 'color': const Color(0xFF6A1B9A), 'label': 'Gece'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          setState(() {
            isPushNotificationsEnabled = doc.data()!['notifications_enabled'] ?? true;
          });
        }
      } catch (e) {
        debugPrint("Veri çekme hatası: $e");
      }
    }
    setState(() => isLoading = false);
  }

  Future<void> _updateFirebaseSettings({bool? notifications, String? themeName}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final updates = <String, dynamic>{};
    if (notifications != null) updates['notifications_enabled'] = notifications;
    if (themeName != null) updates['theme_type'] = themeName;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(updates, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Firebase Güncelleme Hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ayarlar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => canPop ? Navigator.pop(context) : widget.onBack?.call(),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // BİLDİRİMLER
                  SettingsGroup(
                    title: 'Bildirimler',
                    children: [
                      SettingsTile(
                        title: 'Anlık Bildirimler',
                        icon: Icons.notifications_none,
                        trailing: Switch(
                          value: isPushNotificationsEnabled,
                          onChanged: (val) {
                            setState(() => isPushNotificationsEnabled = val);
                            _updateFirebaseSettings(notifications: val);
                          },
                          activeColor: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),

                  // GÖRÜNÜM (KARANLIK MOD VE RENK PALETİ)
                  SettingsGroup(
                    title: 'Görünüm',
                    children: [
                      BlocBuilder<ThemeBloc, ThemeState>(
                        builder: (context, state) {
                          bool isDark = state.themeType == AppThemeType.night;

                          return Column(
                            children: [
                              // Karanlık Mod Switch
                              SettingsTile(
                                title: 'Karanlık Mod',
                                icon: Icons.dark_mode_outlined,
                                trailing: Switch(
                                  value: isDark,
                                  onChanged: (val) {
                                    final newTheme = val ? AppThemeType.night : AppThemeType.nature;
                                    context.read<ThemeBloc>().add(ChangeThemeEvent(newTheme));
                                    _updateFirebaseSettings(themeName: newTheme.name);
                                  },
                                  activeColor: theme.colorScheme.primary,
                                ),
                              ),
                              // Renk Paleti Seçimi (Karanlık mod kapalıyken daha görünür olur)
                              if (!isDark)
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Tema Renk Paleti',
                                          style: TextStyle(
                                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                                              fontSize: 13)),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: _themeOptions.map((option) {
                                          final type = option['type'] as AppThemeType;
                                          final color = option['color'] as Color;
                                          final isSelected = state.themeType == type;

                                          return GestureDetector(
                                            onTap: () {
                                              context.read<ThemeBloc>().add(ChangeThemeEvent(type));
                                              _updateFirebaseSettings(themeName: type.name);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: isSelected
                                                      ? theme.colorScheme.primary
                                                      : Colors.transparent,
                                                  width: 2,
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundColor: color,
                                                child: isSelected
                                                    ? const Icon(Icons.check,
                                                        color: Colors.white, size: 20)
                                                    : null,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),

                  // HESAP VE DİĞERLERİ
                  SettingsGroup(
                    title: 'Hesap Yönetimi',
                    children: [
                      SettingsTile(
                        title: 'Şifre Değiştir',
                        icon: Icons.lock_outline,
                        onTap: () => _showPasswordResetDialog(context),
                      ),
                    ],
                  ),
                  SettingsGroup(
                    title: 'Uygulama Bilgisi',
                    children: [
                      SettingsTile(
                        title: 'Hakkında',
                        icon: Icons.info_outline,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SettingsGroup(
                    title: 'Tehlikeli Bölge',
                    children: [
                      SettingsTile(
                        title: 'Hesabı Sil',
                        icon: Icons.delete_forever,
                        onTap: () => _showDeleteConfirmation(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text('MOYA v2.4.0',
                      style: TextStyle(color: theme.colorScheme.outline, fontSize: 12)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 9,
        onItemTapped: (index) {
          if (index != 9) {
            canPop ? Navigator.pop(context) : widget.onBack?.call();
          }
        },
      ),
    );
  }

  void _showPasswordResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Şifre Yenileme"),
        content: const Text("E-posta adresinize bir şifre sıfırlama bağlantısı gönderilsin mi?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user?.email != null) {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sıfırlama e-postası gönderildi.')),
                    );
                  }
                }
              },
              child: const Text("Gönder")),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hesap silme özelliği yakında eklenecek.')),
    );
  }
}