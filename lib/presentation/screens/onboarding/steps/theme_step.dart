import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moya/core/theme/app_theme.dart';
import 'package:moya/core/theme/bloc/theme_bloc.dart';
import 'package:moya/core/theme/bloc/theme_event.dart';
import 'package:moya/presentation/screens/home/home_screen_new.dart';


class ThemeStep extends StatefulWidget {
  final Function(String) onSelect;
  final VoidCallback onBack;

  const ThemeStep({super.key, required this.onSelect, required this.onBack});

  @override
  State<ThemeStep> createState() => _ThemeStepState();
}

class _ThemeStepState extends State<ThemeStep> {
  String? _selectedTheme;

  // Temaları senin AppThemeType listene göre tam sıraladım
  final List<Map<String, String>> _themes = [
    {"id": "forest", "title": "Doğa Terapisi", "img": "assets/images/forest.png"},
    {"id": "ocean", "title": "Okyanus Derinliği", "img": "assets/images/ocean.png"},
    {"id": "earth", "title": "Toprak Huzuru", "img": "assets/images/earth.png"},
    {"id": "clouds", "title": "Yumuşak Bulutlar", "img": "assets/images/clouds.png"},
    {"id": "galaxy", "title": "Mor Rüya", "img": "assets/images/galaxy.png"},
    {"id": "night", "title": "Gece Modu", "img": "assets/images/night.png"}, // Gece modu burada
  ];

  AppThemeType _mapIdToThemeType(String id) {
    switch (id) {
      case 'ocean': return AppThemeType.ocean;
      case 'forest': return AppThemeType.nature;
      case 'galaxy': return AppThemeType.purple;
      case 'clouds': return AppThemeType.pink;
      case 'earth': return AppThemeType.brown;
      case 'night': return AppThemeType.night;
      default: return AppThemeType.nature;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildHeader("5", context),
              const SizedBox(height: 12),
              
              // İLERLEME ÇUBUĞU
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 1.0,
                  minHeight: 8,
                  backgroundColor: theme.colorScheme.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              ),
              
              const SizedBox(height: 24),
              Text(
                "Sana en çok huzur veren\ntema hangisi?",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Kaydırılabilir Grid Alanı
              Expanded(
                child: GridView.builder(
                  // physics ekleyerek kaydırmayı garantiye alıyoruz
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9, // Kartların boyunu biraz kısalttık ki daha çok kart sığsın
                  ),
                  itemCount: _themes.length,
                  itemBuilder: (context, index) {
                    final item = _themes[index];
                    bool isSelected = _selectedTheme == item['id'];
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedTheme = item['id']);
                        // Temayı anında önizlet
                        context.read<ThemeBloc>().add(
                          ChangeThemeEvent(_mapIdToThemeType(item['id']!))
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24), // Senin teman
                          border: Border.all(
                            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ] : [],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(21),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Resim yüklenirken hata oluşmaması için placeholder veya renk verilebilir
                              Image.asset(
                                item['img']!, 
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
                              ),
                              // Yazının okunması için karartma
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 12, left: 8, right: 8,
                                child: Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    color: Colors.white, 
                                    fontSize: 12, 
                                    fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 10, right: 10,
                                  child: Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 24),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Alt Butonlar
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, top: 12),
                child: Row(
                  children: [
                    _buildBackButton(widget.onBack, theme),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                        onPressed: _selectedTheme != null 
    ? () {
        // 1. Önce BLoC üzerinden temayı güncelle (Önceki adımda yaptığımız gibi)
        final themeType = _mapIdToThemeType(_selectedTheme!);
        context.read<ThemeBloc>().add(ChangeThemeEvent(themeType));

        // 2. Parent widget'ın onSelect fonksiyonunu çalıştır (Firestore kaydı vb. için)
        widget.onSelect(_selectedTheme!);

        // 3. YÖNLENDİRME: Tüm sayfaları sil ve MainWrapper'a git
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreenNew(onMenuTap: () {  }, onProfileTap: () {  },)),
          (route) => false, // Geri dönmeyi engeller
        );
      } 
    : null,
                          child: const Text("TAMAMLA"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(VoidCallback onTap, ThemeData theme) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
        ),
        child: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
      ),
    );
  }

  Widget _buildHeader(String step, BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$step. ADIM / 5",
          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
        ),
        Text(
          "MOYA",
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
       
      ],
    );
  }
}