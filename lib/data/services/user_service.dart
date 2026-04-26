import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Tüm kullanıcı verilerini kaydetmek/güncellemek için tek ve sağlam fonksiyon
  Future<void> saveUserToFirestore(Map<String, dynamic> userData) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // .set(..., SetOptions(merge: true)) belgedeki eski verileri silmeden yenileri ekler
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userData, SetOptions(merge: true));
        print("Veritabanı kaydı başarılı: ${user.uid}");
      } else {
        print("Hata: Oturum açmış kullanıcı bulunamadı!");
      }
    } catch (e) {
      print("Firestore Kayıt Hatası: $e");
      rethrow; // Hatayı yukarı fırlat ki UI'da görebilelim
    }
  }

  // Akışı dinlemek için
  Stream<DocumentSnapshot> getUserStream() {
    String uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).snapshots();
  }
}