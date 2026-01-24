import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moya/core/theme/app_theme.dart';

// Import yolları burada. Kendi klasör yapına göre kontrol et.
import 'core/theme/bloc/theme_bloc.dart';
import 'core/theme/bloc/theme_state.dart'; 
import 'presentation/screens/main_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>( // Hata burada mıydı?
        builder: (context, state) {
          return MaterialApp(
            title: 'MindSpace',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.getTheme(AppThemeType.ocean),
            home: const MainWrapper(),
          );
        },
      ),
    );
  }
}