import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moya/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

import 'core/theme/bloc/theme_bloc.dart';
import 'core/theme/bloc/theme_state.dart';
import 'presentation/screens/auth/login/login_screen.dart';
import 'data/models/login_view_model.dart';
import 'presentation/screens/main_wrapper.dart';
import 'package:moya/injection_container.dart' as di;

// 🔑 GLOBAL NAVIGATOR KEY
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  InAppWebViewController.setWebContentsDebuggingEnabled(true);

  di.init();

  // --- TEMA KALICILIĞI İÇİN BURASI GÜNCELLENDİ ---
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  
  // 1. Kayıtlı tema ismini oku
  final String? savedThemeName = prefs.getString('selected_theme');
  
  // 2. Kayıtlı ismi Enum tipine çevir (Bulamazsa nature yap)
  AppThemeType initialTheme = AppThemeType.nature;
  if (savedThemeName != null) {
    try {
      initialTheme = AppThemeType.values.firstWhere(
        (e) => e.name == savedThemeName,
      );
    } catch (_) {
      initialTheme = AppThemeType.nature;
    }
  }

  // 3. Başlangıç temasını MyApp'e gönder
  runApp(MyApp(isLoggedIn: isLoggedIn, initialTheme: initialTheme));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final AppThemeType initialTheme; // Yeni eklendi

  const MyApp({super.key, required this.isLoggedIn, required this.initialTheme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        // 🚀 ThemeBloc artık uygulama açılışındaki tema ile başlıyor
        BlocProvider(create: (context) => ThemeBloc(initialTheme)),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'MOYA',
            debugShowCheckedModeBanner: false,
            // Bloc'taki güncel state'e göre tema belirleniyor
            theme: AppThemes.getTheme(state.themeType),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('tr', 'TR'),
              Locale('en', 'US'),
            ],
            locale: const Locale('tr', 'TR'),
            home: isLoggedIn ? const MainWrapper() : const LoginScreen(),
          );
        },
      ),
    );
  }
}