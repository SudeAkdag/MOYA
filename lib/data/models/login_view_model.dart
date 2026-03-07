import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = "Lütfen tüm alanları doldurun.";
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      final result = await _authService.login(email, password);
      _setLoading(false);
      return result;
    } catch (e) {
      // Servisten fırlatılan (rethrow) mesajı burada yakalıyoruz
      _errorMessage = e.toString(); 
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> logout() async {
    _errorMessage = null;
    try {
      await _authService.logout();
      
      // ÇIKIŞ YAPILDIĞINDA LOCAL VERİYİ SİL
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn'); // veya setBool('isLoggedIn', false)
      
      notifyListeners();
    } catch (e) {
      _errorMessage = "Çıkış yapılırken bir hata oluştu: $e";
      notifyListeners();
    }
  }
  
}