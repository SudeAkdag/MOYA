import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart'; // 1. Firebase Auth paketini import et

class AuthService {
  // 2. Firebase Auth nesnesini tanımla
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> login(String email, String password) async {
    try {
      developer.log("Giriş denemesi başlatıldı: $email", name: 'AuthService');
      
      // 3. Firebase üzerinden giriş yap
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      developer.log("Giriş başarılı.", name: 'AuthService');
      return true;
    } on FirebaseAuthException catch (e) {
      // Firebase'den gelen özel hata kodlarına göre mesajları Türkçeleştiriyoruz
      developer.log("Firebase Hatası: ${e.code}", name: 'AuthService');
      
      if (e.code == 'user-not-found') {
        throw 'Bu e-posta adresiyle kayıtlı bir kullanıcı bulunamadı.';
      } else if (e.code == 'wrong-password') {
        throw 'Girdiğiniz şifre hatalı.';
      } else if (e.code == 'invalid-email') {
        throw 'Geçersiz bir e-posta formatı girdiniz.';
      } else if (e.code == 'user-disabled') {
        throw 'Bu kullanıcı hesabı devre dışı bırakılmış.';
      } else {
        throw 'Giriş yapılamadı: ${e.message}';
      }
    } catch (e) {
      developer.log("Beklenmedik Hata", name: 'AuthService', error: e);
      throw 'Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }

  Future<void> logout() async {
    try {
      // 4. Firebase oturumunu kapat
      await _auth.signOut();
      developer.log("Oturum başarıyla kapatıldı.", name: 'AuthService');
    } catch (e) {
      developer.log("Çıkış hatası", name: 'AuthService', error: e);
      rethrow;
    }
  }
}