import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moya/core/theme/app_theme.dart';
import 'package:moya/core/theme/bloc/theme_bloc.dart';
import 'package:moya/core/theme/bloc/theme_event.dart';

class StepTheme extends StatefulWidget {
  final Map<String, dynamic> data;
  const StepTheme({super.key, required this.data});

  @override
  State<StepTheme> createState() => _StepThemeState();
}

class _StepThemeState extends State<StepTheme> {
  // Tema tipine göre kullanıcıya gösterilecek isimleri döndüren yardımcı fonksiyon
  String _getThemeName(AppThemeType type) {
    switch (type) {
      case AppThemeType.nature: return 'Doğa Terapisi';
      case AppThemeType.ocean: return 'Okyanus Derinliği';
      case AppThemeType.brown: return 'Toprak Huzuru';
      case AppThemeType.pink: return 'Yumuşak Bulutlar';
      case AppThemeType.purple: return 'Lavanta Bahçesi';
      case AppThemeType.night: return 'Gece Modu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sana en çok huzur veren\ntema hangisi?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Seçtiğin tema uygulama genelinde kullanılacak",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            // AppThemeType.values kullanarak tüm enum listesini otomatik alıyoruz
            itemCount: AppThemeType.values.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final themeType = AppThemeType.values[index];
              // AppThemes.getTheme ile o temanın renklerini çekiyoruz
              final themeData = AppThemes.getTheme(themeType);
              bool isSelected = widget.data['selectedTheme'] == themeType.name;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    widget.data['selectedTheme'] = themeType.name;
                  });
                  // Temayı anlık olarak BLoC üzerinden değiştir
                  context.read<ThemeBloc>().add(ChangeThemeEvent(themeType));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: themeData.primaryColor, // Temanın kendi ana rengi
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 4,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: themeData.primaryColor.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      if (isSelected)
                        const Positioned(
                          top: 10,
                          right: 10,
                          child: Icon(Icons.check_circle, color: Colors.white),
                        ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                          ),
                          child: Text(
                            _getThemeName(themeType),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}