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
// Çıkış yapma fonksiyonu
  Future<void> logout() async {
    // Çıkış işleminde genellikle loading'e gerek yoktur, 
    // çünkü zaten sayfadan ayrılıyoruz.
    _errorMessage = null;
    try {
      await _authService.logout();
      // Önemli: Burada _setLoading(false) veya notifyListeners() 
      // çağırmaktan kaçınmalıyız çünkü widget ağacı o sırada yok ediliyor olabilir.
    } catch (e) {
      _errorMessage = "Çıkış yapılırken bir hata oluştu: $e";
      notifyListeners(); // Sadece hata varsa haber ver
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}