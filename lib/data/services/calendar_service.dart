import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:moya/data/models/calendar_event_model.dart';

class CalendarService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static const String testUserId = "dbdoe1R1WUdUNr1y1iDy1CUKYC33";

  /// Takvimi anlık dinleyen Stream.
  static Stream<List<CalendarEventModel>> getEventsForMonth(DateTime month) {
    final String currentUserId = _auth.currentUser?.uid ?? testUserId;
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 1);

    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('calendar')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThan: Timestamp.fromDate(endOfMonth))
        .snapshots() 
        .map((snapshot) {
          return snapshot.docs.map((doc) => CalendarEventModel.fromFirestore(doc)).toList();
        });
  }

  /// Günlük Not ekranından gelen veriyi kaydeder veya günceller
  static Future<void> addDailyEntry(Map<String, dynamic> data) async {
    try {
      final String currentUserId = _auth.currentUser?.uid ?? testUserId;
      
      DateTime dateForId = DateTime.now();
      if (data['date'] is DateTime) {
        dateForId = data['date'];
        data['date'] = Timestamp.fromDate(dateForId);
      } else if (data['date'] is Timestamp) {
        dateForId = (data['date'] as Timestamp).toDate();
      }

      // Doküman ID'sini tarihi kullanarak oluşturuyoruz
      final String docId = DateFormat('yyyy-MM-dd').format(dateForId);

      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('calendar')
          .doc(docId) // .add() YERİNE .doc(docId).set() KULLANIYORUZ
          .set(data, SetOptions(merge: true)); // Üzerine yaz ama eskileri silme
          
    } catch (e) {
      rethrow;
    }
  }
}