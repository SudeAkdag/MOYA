import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moya/core/theme/app_theme.dart';
import 'package:moya/core/theme/bloc/theme_bloc.dart';
import 'package:moya/core/theme/bloc/theme_event.dart';
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
    final theme = Theme.of(context); // Temayı buraya da ekledik

    return Scaffold(
     
      backgroundColor: theme.colorScheme.surface, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Ayarlar', 
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        centerTitle: true,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
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
                    onChanged: (val) => setState(() => isPushNotificationsEnabled = val),
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
                          context.read<ThemeBloc>().add(
                            ChangeTheme(val ? AppThemeType.night : AppThemeType.ocean)
                          );
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
                                onTap: () => context.read<ThemeBloc>().add(ChangeTheme(themeType)),
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
                  icon: Icons.history,
                  onTap: () {},
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
            Text('MOYA v2.4.0', style: TextStyle(color: theme.colorScheme.outline, fontSize: 12)),
            const SizedBox(height: 100), 
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    // SnackBar renklerini de temaya uyumlu hale getirebilirsin
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hesap silme özelliği yakında eklenecek.')),
    );
  }
}