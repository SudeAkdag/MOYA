import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeType {
  nature,   // Orman Teması
  ocean,    // Okyanus
  sunset,   // Gün Batımı
  lavender, // Lavanta
  night,    // Gece
}

class AppThemes {
  static ThemeData getTheme(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.nature:
        return _buildTheme(
          primary: const Color(0xFFBC6C25),    // Buton Rengi (Toprak Turuncu)
          background: const Color(0xFFF9F4EA), // Ana Arka Plan (Krem)
          surface: const Color(0xFF606C38),    // Kutu/Kart Rengi (Yosun Yeşili)
          textColor: const Color(0xFF283618),  // Yazı Rengi (Koyu Yeşil)
        );
        
      case AppThemeType.ocean:
        return _buildTheme(
          // Paletindeki orta koyu canlı maviyi buton/primary yaptım
          primary: const Color(0xFF4059C7),    
          
          // İsteğine göre EN AÇIK ton arka plan oldu
          background: const Color(0xFFDFEDF7), 
          
          // Kutular için orta açık maviyi seçtim (Yazı koyu olduğu için okunur)
          surface: const Color(0xFF4BB8EE),    
          
          // En koyu tonu yazı rengi yaptım (Okunabilirlik için)
          textColor: const Color(0xFF0D1B2A),  
        );

      case AppThemeType.sunset:
        return _buildTheme(
          primary: const Color(0xFFFF9800),
          background: const Color(0xFFF9F4EA),
          surface: const Color(0xFF4E342E),
          textColor: const Color(0xFF2D1B0E),
        );

      case AppThemeType.lavender:
        return _buildTheme(
          primary: const Color(0xFF9C27B0),
          background: const Color(0xFFF9F4EA),
          surface: const Color(0xFF2D1B36),
          textColor: const Color(0xFF1A1025),
        );

      case AppThemeType.night:
        return _buildTheme(
          primary: const Color(0xFF9E9E9E),
          background: const Color(0xFF000000),
          surface: const Color(0xFF121212),
          textColor: Colors.white,
        );
    }
  }

  static ThemeData _buildTheme({
    required Color primary,
    required Color background,
    required Color surface,
    required Color textColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light, 
      
      primaryColor: primary,
      scaffoldBackgroundColor: background, // En açık renk buraya atandı

      // Kart (Kutu) Tasarımları
      cardTheme: CardThemeData(
        color: surface, 
        elevation: 0,
        shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(16),
      ),
),


      // Yazı Ayarları
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: textColor,    
        displayColor: textColor, 
      ),

      // Buton Tasarımı
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary, 
          foregroundColor: Colors.white, // Buton üzerindeki yazı beyaz
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      
      // Alt Menü (Senin kuralına göre arka plan rengini aldı)
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background, // Arka plan ile aynı (En açık ton)
        selectedItemColor: primary,  // Seçili ikon Buton rengi
        unselectedItemColor: textColor.withOpacity(0.5), // Seçili olmayanlar silik yazı rengi
        type: BottomNavigationBarType.fixed,
        elevation: 0, 
      ),
      
      iconTheme: IconThemeData(color: textColor),
      
      // AppBar Ayarları
      appBarTheme: AppBarTheme(
        backgroundColor: background, // Arka plan ile aynı
        foregroundColor: textColor, 
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}