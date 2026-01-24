import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_theme.dart';
import 'theme_event.dart'; // Event dosyasını çağırmalı
import 'theme_state.dart'; // State dosyasını çağırmalı

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ChangeTheme>((event, emit) {
      final themeData = AppThemes.getTheme(event.theme);
      emit(ThemeState(themeData: themeData, themeType: event.theme));
    });
  }
}