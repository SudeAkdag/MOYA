import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moya/core/theme/app_theme.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  // Constructor: Uygulama açılışında main.dart'tan gelen initialTheme ile başlar
  ThemeBloc(AppThemeType initialTheme) : super(ThemeState(themeType: initialTheme)) {
    
    // Tema değiştirme olayını (event) dinliyoruz
    on<ChangeThemeEvent>((event, emit) async {
      try {
        // 1. Seçilen temayı yerel hafızaya (Kalıcı olarak) kaydet
        // Bu sayede uygulama kapatılıp açıldığında bu tema hatırlanacak
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selected_theme', event.themeType.name);
        
        // 2. Yeni State'i yayınla
        // Bu adım, MaterialApp'in anında yeniden build olmasını ve renklerin değişmesini sağlar
        emit(ThemeState(themeType: event.themeType));
        
      } catch (e) {
        // Hata durumunda mevcut temayı korumaya devam et
       
      }
    });
  }
}