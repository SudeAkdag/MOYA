import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moya/core/theme/app_theme.dart'; // AppThemeType enum'ı için
import 'package:moya/core/theme/bloc/theme_bloc.dart'; // ThemeBloc için
import 'package:moya/core/theme/bloc/theme_event.dart'; // ChangeTheme event'i için
import 'package:moya/core/theme/bloc/theme_state.dart';
import 'widgets/settings_group.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isPushNotificationsEnabled = true;

  // Temaları AppThemes enum değerlerine göre sıraladık
  final List<AppThemeType> themeTypes = [
    AppThemeType.ocean,
    AppThemeType.nature,
    AppThemeType.purple,
    AppThemeType.pink,
    AppThemeType.brown,
  ];

  // Görseldeki dairelerin renkleri (Enum sırasıyla uyumlu)
  final List<Color> displayColors = [
    const Color(0xFF2b8cee), // Ocean
    const Color(0xFF606C38), // Nature
    const Color(0xFF5A189A), // Purple
    const Color(0xFFF4ACB7), // Pink
    const Color(0xFF99582A), // Brown
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Koyu arka plan
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Ayarlar', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                    onChanged: (val) => setState(() => isPushNotificationsEnabled = val),
                    activeColor: Colors.blue,
                  ),
                ),
              ],
            ),

            // GÖRÜNÜM
            SettingsGroup(
              title: 'Görünüm',
              children: [
                // Karanlık Mod Switch'i (Night Temasına Bağlı)
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    final bool isCurrentlyNight = state.themeType == AppThemeType.night;

                    return SettingsTile(
                      title: 'Karanlık Mod',
                      icon: Icons.dark_mode_outlined,
                      trailing: Switch(
                        value: isCurrentlyNight,
                        onChanged: (bool val) {
                          if (val) {
                            // Switch açılırsa Night temasını gönder
                            context.read<ThemeBloc>().add(const ChangeTheme(AppThemeType.night));
                          } else {
                            // Switch kapanırsa varsayılan Ocean temasını gönder
                            context.read<ThemeBloc>().add(const ChangeTheme(AppThemeType.ocean));
                          }
                        },
                        activeColor: Colors.blue,
                      ),
                    );
                  },
                ),
                
                // Renk Paleti
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tema Renk Paleti', 
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
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
                                  // Bloc'a tema değiştirme emri gönderilir
                                  context.read<ThemeBloc>().add(ChangeTheme(themeType));
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

            // HESAP YÖNETİMİ
            SettingsGroup(
              title: 'Hesap Yönetimi',
              children: [
                SettingsTile(
                  title: 'Şifre Değiştir',
                  icon: Icons.history,
                  onTap: () { /* Navigasyon buraya gelecek */ },
                ),
              ],
            ),

            const SizedBox(height: 20),
            
            // TEHLİKELİ BÖLGE
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
            const Text('MOYA v2.4.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 100), 
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hesap silme özelliği yakında eklenecek.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}