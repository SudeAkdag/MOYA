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
  unselectedItemColor: textColor.withValues(alpha: 0.5), // Seçili olmayanlar silik yazı rengi
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