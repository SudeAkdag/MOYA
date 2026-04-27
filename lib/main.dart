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
import 'data/services/seed_service.dart';

// 🔑 GLOBAL NAVIGATOR KEY
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // InAppWebView'ı başlat
  try {
    InAppWebViewController.setWebContentsDebuggingEnabled(true);
  } on UnimplementedError catch (_) {
    // Ignore on unsupported platforms
  }

  di.init();

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Müzik kataloğu seed'i sadece kullanıcı zaten giriş yapmışsa çalışır;
  // ilk girişte/registerda seed login sonrası çağrılır (Firestore kuralları
  // yazma için request.auth != null gerektirdiğinden).
  await SeedService.runSeedIfNeeded();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'MOYA',
            debugShowCheckedModeBanner: false,
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