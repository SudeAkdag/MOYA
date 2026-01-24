import 'package:equatable/equatable.dart';
import '../app_theme.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ChangeTheme extends ThemeEvent {
  final AppThemeType theme;

  const ChangeTheme(this.theme);

  @override
  List<Object> get props => [theme];
}