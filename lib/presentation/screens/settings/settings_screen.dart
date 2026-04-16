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

  // Firebase Servis Metodu: Ayarları Güncelle
  Future<void> _updateFirebaseSettings({bool? notifications, String? themeName}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final Map<String, dynamic> updates = {};
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

  // Firebase'den Mevcut Ayarları Çek
  Future<void> _fetchSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          setState(() {
            isPushNotificationsEnabled = doc.data()!['notifications_enabled'] ?? true;
            isLoading = false;
          });
        }
      } catch (e) {
        debugPrint("Veri çekme hatası: $e");
      }
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  final List<AppThemeType> themeTypes = [
    AppThemeType.ocean,
    AppThemeType.nature,
    AppThemeType.purple,
    AppThemeType.pink,
    AppThemeType.brown,
  ];

  final List<Color> displayColors = [
    const Color(0xFF2b8cee),
    const Color(0xFF606C38),
    const Color(0xFF5A189A),
    const Color(0xFFF4ACB7),
    const Color(0xFF99582A),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Ayarlar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            if (canPop) {
              Navigator.pop(context);
            } else if (widget.onBack != null) {
              widget.onBack!();
            }
          },
        ),
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
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
            SettingsGroup(
              title: 'Görünüm',
              children: [
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    final bool isCurrentlyNight = state.themeType == AppThemeType.night;
                    return SettingsTile(
                      title: 'Karanlık Mod',
                      icon: Icons.dark_mode_outlined,
                      trailing: Switch(
                        value: isCurrentlyNight,
                        onChanged: (bool val) {
                          final newTheme = val ? AppThemeType.night : AppThemeType.ocean;
                          context.read<ThemeBloc>().add(ChangeTheme(newTheme));
                          _updateFirebaseSettings(themeName: newTheme.name);
                        },
                        activeColor: theme.colorScheme.primary,
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tema Renk Paleti',
                          style: TextStyle(color: theme.colorScheme.outline, fontSize: 13)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(themeTypes.length, (index) {
                          final themeType = themeTypes[index];
                          return BlocBuilder<ThemeBloc, ThemeState>(
                            builder: (context, state) {
                              final isSelected = state.themeType == themeType;
                              return GestureDetector(
                                onTap: () {
                                  context.read<ThemeBloc>().add(ChangeTheme(themeType));
                                  _updateFirebaseSettings(themeName: themeType.name);
                                },
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: displayColors[index],
                                  child: isSelected
                                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                                      : null,
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SettingsGroup(
              title: 'Hesap Yönetimi',
              children: [
                SettingsTile(
                  title: 'Şifre Değiştir',
                  icon: Icons.lock_outline,
                  onTap: () {
                    // Şifre sıfırlama maili göndererek geçici çözüm sağlayabilirsin
                    _showPasswordResetDialog(context);
                  },
                ),
              ],
            ),
            SettingsGroup(
              title: 'Uygulama Bilgisi',
              children: [
                SettingsTile(
                  title: 'Hakkında',
                  icon: Icons.info_outline,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutScreen()),
                    );
                  },
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
            const SizedBox(height: 20),
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
            if (canPop) {
               Navigator.pop(context);
            } else if (widget.onBack != null) {
               widget.onBack!(); 
            }
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
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sıfırlama e-postası gönderildi.')),
                  );
                }
              }
            }, 
            child: const Text("Gönder")
          ),
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