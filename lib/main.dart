import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moya/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart'; //
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore kullanımı için şart
import 'firebase_options.dart'; //

import 'core/theme/bloc/theme_bloc.dart';
import 'core/theme/bloc/theme_state.dart'; 
import 'presentation/screens/auth/login/login_screen.dart';
import 'presentation/screens/auth/login/login_view_model.dart';
import 'presentation/screens/main_wrapper.dart';
import 'package:moya/injection_container.dart' as di;

// 🔑 GLOBAL NAVIGATOR KEY
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Flutter bağlamını başlatıyoruz
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  
  // 1. Firebase'i başlatıyoruz
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. 🔥 TEST KODU: Firestore bağlantısını terminalden kontrol et
  // Eğer bağlantı başarılıysa Debug Console'da doküman sayısını göreceksin
  try {
    var snapshot = await FirebaseFirestore.instance.collection('meditasyon').get();
    print("🔥 Firestore'daki doküman sayısı: ${snapshot.docs.length}");
  } catch (e) {
    print("❌ Firestore hatası: $e");
  }

  // 3. Mevcut SharedPreferences kontrolün
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

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
            home: isLoggedIn ? const MainWrapper() : const LoginScreen(),
          );
        },
      ),
    );
  }
}
