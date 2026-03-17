import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moya/data/models/calendar_event_model.dart';

class CalendarService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static const String testUserId = "dbdoe1R1WUdUNr1y1iDy1CUKYC33";

  /// Takvimi anlık dinleyen Stream. Veritabanı değiştiği an takvim güncellenir.
  static Stream<List<CalendarEventModel>> getEventsForMonth(DateTime month) {
    final String currentUserId = _auth.currentUser?.uid ?? testUserId;

    // Ayın başlangıç ve bitişini Timestamp araması için hazırlıyoruz
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 1);

    return _firestore
        .collection('calendar')
        .where('userId', isEqualTo: currentUserId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth)) // <--- DÜZELTİLDİ
        .where('date', isLessThan: Timestamp.fromDate(endOfMonth)) // <--- DÜZELTİLDİ
        .snapshots() 
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CalendarEventModel.fromFirestore(doc))
              .toList();
        });
  }

  // BURASI HATAYI DÜZELTEN KISIM:
  static Future<void> addDailyEntry(Map<String, dynamic> data) async {
    try {
      final String currentUserId = _auth.currentUser?.uid ?? testUserId;
      data['userId'] = currentUserId;
      // Eğer tarih DateTime olarak geliyorsa Timestamp'e çeviriyoruz
      if (data['date'] is DateTime) {
        data['date'] = Timestamp.fromDate(data['date']);
      }
      await _firestore.collection('calendar').add(data);
    } catch (e) {
      rethrow;
    }
  }
}