import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:moya/data/models/user_model.dart';
import 'dart:developer' as developer;

class DatabaseService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String _todayDocId(DateTime now) => DateFormat('yyyy-MM-dd').format(now);

  static DocumentReference<Map<String, dynamic>>? _todayMoodDocRef() {
    final user = _auth.currentUser;
    if (user == null) return null;

    final now = DateTime.now();
    final docId = _todayDocId(now);

    return _firestore.collection('users').doc(user.uid).collection('calendar').doc(docId);
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> todayMoodDocStream() {
    final ref = _todayMoodDocRef();
    if (ref == null) return const Stream.empty();
    return ref.snapshots();
  }

  static Future<UserModel?> getUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      developer.log("Profil çekme hatası", error: e);
      return null;
    }
  }

  static Future<String> getDailyIntention() async {
    try {
      // 1. Tüm sözleri çek (Eğer söz sayısı çok fazlaysa farklı bir random mantığı kurulur 
      // ama başlangıç için en sağlıklısı budur)
      final snapshot = await _firestore.collection('intentions').get();
      
      if (snapshot.docs.isNotEmpty) {
        // 2. Liste içinden rastgele bir index seç
        final allDocs = snapshot.docs;
        // Opsiyonel: Her gün aynı sözü göstermek istersen 'Random(DateTime.now().day)' kullanabilirsin
        allDocs.shuffle(); 
        
        return allDocs.first['content'] as String;
      }
      return "Bugün sadece nefesine odaklan ve anı yaşa.";
    } catch (e) {
      developer.log("Söz çekme hatası", error: e);
      return "Kendine nazik davranmayı unutma.";
    }
  }

  static Future<void> saveDailyMood(String moodText, String emoji) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final now = DateTime.now();
      final docId = _todayDocId(now);

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('calendar')
          .doc(docId)
          .set({
        'date': Timestamp.fromDate(now),
        'moodText': moodText,
        'emoji': emoji,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      developer.log("Başarıyla kaydedildi: $moodText, ID: $docId");
    } catch (e) {
      developer.log("Ruh hali kaydı hatası", error: e);
    }
  }
}