import 'package:flutter/material.dart';
import 'package:moya/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Paket eklendi
import 'widgets/auth_text_field.dart';
import '../../../../data/models/login_view_model.dart';
import 'widgets/login_header.dart';
import 'widgets/login_button.dart';
import 'widgets/login_footer.dart';
import 'widgets/forgot_password_button.dart';
import '../../main_wrapper.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const LoginHeader(),
                const SizedBox(height: 40),
                AuthTextField(
                  controller: _emailController,
                  label: "E-posta",
                  hintText: "E-posta adresinizi girin",
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  controller: _passwordController,
                  label: "Şifre",
                  hintText: "Şifrenizi girin",
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  suffixIcon: const Icon(Icons.visibility_outlined, color: Colors.white70),
                ),
                const ForgotPasswordButton(),
                const SizedBox(height: 20),
                LoginButton(
                  isLoading: viewModel.isLoading,
                  onPressed: () => _onLoginPressed(viewModel, theme),
                ),
                const SizedBox(height: 30),
                const LoginFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLoginPressed(LoginViewModel viewModel, ThemeData theme) async {
    final success = await viewModel.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      // 1. Oturumu Kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // 2. Navigasyon (En sağlam yöntem)
      if (mounted) {
        // pushAndRemoveUntil kullanarak arkadaki her şeyi temizleyip temiz bir sayfa açıyoruz
        navigatorKey.currentState!.pushAndRemoveUntil(
  MaterialPageRoute(builder: (_) => const MainWrapper()),
  (route) => false,
);

      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? "Giriş başarısız"),
          backgroundColor: theme.colorScheme.error, // Hata olduğu için error rengi daha mantıklı
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}