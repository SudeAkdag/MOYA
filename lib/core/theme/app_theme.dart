import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeType {
  nature,   // Orman Teması
  ocean,    // Okyanus
  brown,   // Kahverengi
  pink, // Pembe
  purple, // Mor
  night,    // Gece
}

class AppThemes {
  static ThemeData getTheme(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.ocean:
        return _buildTheme(
          primary: const Color(0xFF2b8cee),
          background: const Color(0xFF0D1B2A), // moya-dark
          surface: const Color(0xFF1B263B),    // moya-card
          textColor: Colors.white,
          accentColor: const Color(0xFF415A77), // moya-accent
          brightness: Brightness.dark,
        );
      case AppThemeType.nature:
        return _buildTheme(
          primary: const Color(0xFFBC6C25),    // Buton Rengi (Toprak Turuncu)
          background: const Color(0xFFF9F4EA), // Ana Arka Plan (Krem)
          surface: const Color(0xFF606C38),    // Kutu/Kart Rengi (Yosun Yeşili)
          textColor: const Color(0xFF283618),  // Yazı Rengi (Koyu Yeşil)
        );

      case AppThemeType.brown:
        return _buildTheme(
          primary: const Color(0xFF99582A),
          background: const Color(0xFFFAF6F0),
          surface: const Color(0xFFE6CCB2),
          textColor: const Color(0xFF432818),
        );

      case AppThemeType.pink:// Artık Pembe/Sakura Teması oldu
        return _buildTheme(
          primary: const Color(0xFFBC186F),    // Canlı Koyu Pembe
          background: const Color(0xFFFFE5D9), // En Açık Ton (Arka Plan)
          surface: const Color(0xFFF4ACB7),    // Kart Rengi (Tatlı Pembe)
          textColor: const Color(0xFF610544),  // Yazı Rengi (Koyu Mürdüm)
        );

        case AppThemeType.night:
        return _buildTheme(
          primary: const Color(0xFF9E9E9E),
          background: const Color(0xFF000000),
          surface: const Color(0xFF121212),
          textColor: Colors.white,
          brightness: Brightness.dark,
        );

     case AppThemeType.purple:
        return _buildTheme(
          primary: const Color(0xFF5A189A),
          background: const Color(0xFFFDFCFF),
          surface: const Color(0xFFE0AAFF),
          textColor: const Color(0xFF240442),
        );

    }
  }

  static ThemeData _buildTheme({
    required Color primary,
    required Color background,
    required Color surface,
    required Color textColor,
    Color? accentColor,
    Brightness brightness = Brightness.light,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
        surface: surface,
      ).copyWith(
        secondary: accentColor,
      ),

      // Kart (Kutu) Tasarımları
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(24), // border-radius: 1.5rem;
        ),
      ),

      // Yazı Ayarları
      textTheme: (isDark
              ? GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
              : GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme)
             ).apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),

      // Buton Tasarımı
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: isDark ? textColor : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),

      // Alt Menü
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: primary,
        unselectedItemColor: textColor.withAlpha(100),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      iconTheme: IconThemeData(color: textColor.withAlpha(230)),

      // AppBar Ayarları
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent, // For glass effect
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}