import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moya/core/theme/app_theme.dart';
import 'core/theme/bloc/theme_bloc.dart';
import 'core/theme/bloc/theme_state.dart'; 
import 'presentation/screens/auth/login/login_screen.dart';
import 'presentation/screens/auth/login/login_view_model.dart';
import 'presentation/screens/main_wrapper.dart';

// 🔑 GLOBAL NAVIGATOR KEY
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
      // SABİT YERİNE: state içindeki mevcut temayı alıyoruz
      theme: AppThemes.getTheme(state.themeType), 
      home: isLoggedIn ? const MainWrapper() : const LoginScreen(),
    );
  },
),
    );
  }
}