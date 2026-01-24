import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../app_theme.dart'; // Bir üst klasördeki app_theme.dart'ı çağırır

class ThemeState extends Equatable {
  final ThemeData themeData;
  final AppThemeType themeType;

  const ThemeState({required this.themeData, required this.themeType});

  factory ThemeState.initial() {
    return ThemeState(
      themeData: AppThemes.getTheme(AppThemeType.nature),
      themeType: AppThemeType.nature,
    );
  }

  @override
  List<Object> get props => [themeData, themeType];
}