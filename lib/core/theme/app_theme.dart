import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Tema Seçenekleri
enum AppThemeType { nature, ocean, brown, pink, purple, night }

class AppThemes {
  static ThemeData getTheme(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.nature:
        // Figma: Zeytin Yeşili ve Krem
        return _buildTheme(
          primary: const Color(0xFF606C38),    // Ana Butonlar
          background: const Color(0xFFFEFAE0), // Ana Arka Plan
          surface: const Color(0xFFD9E3C1),    // Kartlar ve Yüzeyler
          textColor: const Color(0xFF1C1C1C),  // EN KOYU SİYAH (Belirginlik için)
        );

      case AppThemeType.ocean:
        // Figma: Okyanus Mavisi Tonları
        return _buildTheme(
          primary: const Color(0xFF0077B6),
          background: const Color(0xFFE0F7FA), // Çok Açık Su Mavisi
          surface: const Color(0xFFB2EBF2),    // Açık Mavi Kartlar
          textColor: const Color(0xFF0D0D0D),  // EN KOYU SİYAH
        );

      case AppThemeType.brown:
        // Figma: Toprak ve Kahve Tonları
        return _buildTheme(
          primary: const Color(0xFF99582A),
          background: const Color(0xFFFAF3E0), // Sıcak Krem
          surface: const Color(0xFFEED9C4),    // Açık Kahve Kartlar
          textColor: const Color(0xFF1A1A1A),  // EN KOYU SİYAH
        );

      case AppThemeType.pink:
        // Figma: Sakura Pembesi Tonları
        return _buildTheme(
          primary: const Color(0xFFD81B60),
          background: const Color(0xFFFCE4EC),
          surface: const Color(0xFFF8BBD0),
          textColor: const Color(0xFF212121),  // EN KOYU SİYAH
        );

      case AppThemeType.purple:
        // Figma: Revize Edilmiş, Daha Derin Mor
        return _buildTheme(
          primary: const Color(0xFF6A1B9A),    // Koyu Lavanta
          background: const Color(0xFFF3E5F5), // Çok Açık Mor Zemin
          surface: const Color(0xFFE1BEE7),    // Yumuşak Mor Kartlar
          textColor: const Color(0xFF1F1F1F),  // EN KOYU SİYAH
        );

      case AppThemeType.night:
        // MOYA Koyu Mod (Gece) - Figma Referanslı Koyu Mavi
        return _buildTheme(
          primary: const Color(0xFF4FC3F7),    // Açık Mavi Vurgu
          background: const Color(0xFF0D1B2A), // Koyu Lacivert Zemin
          surface: const Color(0xFF1B263B),    // Biraz Daha Açık Lacivert Kartlar
          textColor: const Color(0xFFFFFFFF),  // BEYAZ Metin
          brightness: Brightness.dark,         // Koyu Mod İşareti
        );
    }
  }

  // Tüm Temalar İçin Standart Yapı Oluşturucu
  static ThemeData _buildTheme({
    required Color primary,
    required Color background,
    required Color surface,
    required Color textColor,
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
        onSurface: textColor,
        background: background,
        onBackground: textColor,
      ),

      // Kart Tasarımı - Figma Radius: 24px
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      // Yazı Tasarımı - Belirgin Siyah/Beyaz Metinler
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),

      // Buton Tasarımı - Figma Radius: 12px
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: isDark ? background : Colors.white, // Metin rengi zıtlık sağlar
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),

      // AppBar ve İkonlar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textColor,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(color: textColor.withOpacity(0.9)),
      
      // Alt Menü (Bottom Navigation Bar)
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textColor.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}