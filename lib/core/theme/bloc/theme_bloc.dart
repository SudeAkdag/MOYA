


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moya/core/theme/app_theme.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  // Constructor: Başlangıç temasını alıyoruz
  ThemeBloc(AppThemeType initialTheme) : super(ThemeState(themeType: initialTheme)) {
    
    // 🔥 EKSİK OLAN KISIM BURASIYDI:
    // ChangeThemeEvent tipinde bir event geldiğinde çalışacak kod bloğu
    on<ChangeThemeEvent>((event, emit) async {
      // 1. Seçilen temayı yerel hafızaya kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_theme', event.themeType.name);
      
      // 2. Yeni State'i yayınla (Uygulama rengini değiştirir)
      emit(ThemeState(themeType: event.themeType));
    });

  }
}