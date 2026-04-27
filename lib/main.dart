import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Kendi dosya yolların (Klasör yapına göre kontrol et)
import 'package:moya/core/theme/app_theme.dart';
import 'package:moya/core/theme/bloc/theme_bloc.dart';
import 'package:moya/core/theme/bloc/theme_state.dart';
import 'package:moya/presentation/screens/auth/login/login_screen.dart';
import 'package:moya/data/models/login_view_model.dart';
import 'package:moya/presentation/screens/main_wrapper.dart';
import 'package:moya/injection_container.dart' as di;
import 'firebase_options.dart';

// 🔑 GLOBAL NAVIGATOR KEY (Çıkış yaparken vs. her yerden erişim sağlar)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Çevresel değişkenleri yükle (.env dosyası varsa)
  await dotenv.load(fileName: ".env");

  // Firebase Başlatma
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // WebView hata ayıklama (İhtiyaç varsa)
  InAppWebViewController.setWebContentsDebuggingEnabled(true);

  // Dependency Injection (Bağımlılık Enjeksiyonu) başlatma
  di.init();

  // --- KALICILIK VE TEMA KONTROLLERİ ---
  final prefs = await SharedPreferences.getInstance();
  
  // 1. Kullanıcı daha önce giriş yapmış mı?
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  
  // 2. Kayıtlı tema ismini oku
  final String? savedThemeName = prefs.getString('selected_theme');
  
  // 3. Başlangıç Teması Belirleme
  // Eğer giriş yapılmışsa ve kayıtlı tema varsa onu getir, yoksa DEFAULT (Nature)
  AppThemeType initialTheme = AppThemeType.nature;
  if (isLoggedIn && savedThemeName != null) {
    try {
      initialTheme = AppThemeType.values.firstWhere(
        (e) => e.name == savedThemeName,
      );
    } catch (_) {
      initialTheme = AppThemeType.nature;
    }
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, initialTheme: initialTheme));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final AppThemeType initialTheme;

  const MyApp({super.key, required this.isLoggedIn, required this.initialTheme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        // 🚀 ThemeBloc, cihazdan okunan tema ile ayağa kalkar
        BlocProvider(create: (context) => ThemeBloc(initialTheme)),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: navigatorKey, // Global key burada bağlı
            title: 'MOYA',
            debugShowCheckedModeBanner: false,
            
            // 🎨 Bloc'taki güncel state'e göre tema belirleniyor
            theme: AppThemes.getTheme(state.themeType),
            
            // Dil ve Bölge Ayarları (Türkçe Öncelikli)
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

            // 🏠 Oturum durumuna göre açılış ekranı
            home: isLoggedIn ? const MainWrapper() : const LoginScreen(),
          );
        },
      ),
    );
  }
}