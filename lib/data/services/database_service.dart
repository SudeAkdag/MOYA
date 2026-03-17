import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moya/data/models/user_model.dart';
import 'dart:developer' as developer;

class DatabaseService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// Kullanıcı profilini çeker
  static Future<UserModel?> getUserProfile() async {
    try {
      // DİNAMİK: Artık sadece o an giriş yapmış olan gerçek kullanıcıyı baz alıyoruz.
      final user = _auth.currentUser;
      if (user == null) return null;

      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      
      // Eğer döküman yoksa 'Elif' dönmek yerine null dönelim ki 
      // uygulama orada bir veri olmadığını anlasın ve hata vermesin.
      return null;
    } catch (e) {
      developer.log("Profil çekme hatası", error: e);
      return null;
    }
  }

  /// Firestore'dan 'intentions' koleksiyonundaki niyet cümlesini çeker
  static Future<String> getDailyIntention() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('intentions').limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first['content'] as String;
      }
      return "Bugün sadece nefesine odaklan ve anı yaşa.";
    } catch (e) {
      return "Kendine nazik davranmayı unutma.";
    }
  }

  /// Ruh halini kaydeder.
  static Future<void> saveDailyMood(String moodText, String emoji, double value) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      String todayStr = DateTime.now().toString().split(' ')[0]; 
      DateTime todayDate = DateTime.parse(todayStr); 

      await _firestore.collection('calendar').doc("${user.uid}_$todayStr").set({
        'userId': user.uid,
        'date': Timestamp.fromDate(todayDate),
        'mood': value, 
        'moodText': moodText,
        'emoji': emoji, 
        'type': 'mood_log',
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      developer.log("Başarıyla kaydedildi: $moodText");
    } catch (e) {
      developer.log("Ruh hali kaydı hatası", error: e);
    }
  }
}