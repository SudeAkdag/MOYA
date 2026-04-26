// lib/core/theme/bloc/theme_state.dart
import 'package:moya/core/theme/app_theme.dart';

class ThemeState {
  final AppThemeType themeType;

  // Sadece themeType alacak şekilde güncelledik, themeData zorunluluğunu kaldırdık.
  ThemeState({required this.themeType});
}