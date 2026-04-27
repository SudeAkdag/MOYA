// core/theme/bloc/theme_event.dart
import 'package:moya/core/theme/app_theme.dart';

abstract class ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {
  final AppThemeType themeType;
  ChangeThemeEvent(this.themeType);
} 