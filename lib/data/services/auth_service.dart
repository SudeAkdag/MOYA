import 'dart:developer' as developer;

class AuthService {
  // Giriş yapma fonksiyonu
  Future<bool> login(String email, String password) async {
    try {
      developer.log("Giriş denemesi: $email", name: 'AuthService');
      
      await Future.delayed(const Duration(seconds: 2));
      
      if (email.isNotEmpty && password.length >= 6) {
        return true;
      }
      return false;
    } catch (e) {
      developer.log("Servis hatası", name: 'AuthService', error: e);
      return false;
    }
  }

  // --- BURAYI EKLEDİK ---
  // Çıkış yapma fonksiyonu
  Future<void> logout() async {
    try {
      developer.log("Oturum kapatılıyor...", name: 'AuthService');
      
      // İleride buraya Firebase.signOut() veya 
      // SharedPreferences temizleme kodları gelecek.
      await Future.delayed(const Duration(milliseconds: 500)); 
      
      developer.log("Oturum başarıyla kapatıldı.", name: 'AuthService');
    } catch (e) {
      developer.log("Çıkış yapılırken hata oluştu", name: 'AuthService', error: e);
      rethrow; // Hatayı ViewModel'e fırlatıyoruz ki gerekirse kullanıcıya göstersin
    }
  }
}