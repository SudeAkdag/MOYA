import 'package:flutter/material.dart';
import '../../../../data/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Giriş yapma fonksiyonu
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final result = await _authService.login(email, password);
      if (!result) {
        _errorMessage = "E-posta veya şifre hatalı.";
      }
      _setLoading(false);
      return result;
    } catch (e) {
      _errorMessage = "Hata oluştu: $e";
      _setLoading(false);
      return false;
    }
  }

  // --- BURAYI EKLEDİK ---
  // Çıkış yapma fonksiyonu
  Future<void> logout() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.logout();
      // Çıkış başarılı olduğunda loading'i kapatıyoruz
      _setLoading(false);
    } catch (e) {
      _errorMessage = "Çıkış yapılırken bir hata oluştu: $e";
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}