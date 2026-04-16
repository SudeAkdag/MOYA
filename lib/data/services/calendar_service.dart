import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moya/data/models/calendar_event_model.dart';
import 'dart:developer' as developer;

class CalendarService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>>? _calendarRef() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _firestore.collection('users').doc(user.uid).collection('calendar');
  }

  /// Belirtilen ay için mevcut kullanıcının olaylarını getiren bir stream döndürür.
  static Stream<List<CalendarEventModel>> getEventsForMonth(DateTime month) {
    final ref = _calendarRef();
    if (ref == null) return Stream.value([]);

    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 1);

    return ref.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => CalendarEventModel.fromFirestore(doc))
          .where((event) {
        return (event.date.isAtSameMomentAs(startOfMonth) ||
                event.date.isAfter(startOfMonth)) &&
            event.date.isBefore(endOfMonth);
      }).toList();
    }).transform(StreamTransformer<List<CalendarEventModel>,
        List<CalendarEventModel>>.fromHandlers(
      handleData: (data, sink) => sink.add(data),
      handleError: (error, stackTrace, sink) {
        developer.log("Calendar stream hatası", error: error);
        sink.add([]);
      },
    ));
  }

  /// Firestore'a yeni bir günlük girdi ekler.
  static Future<void> addDailyEntry(Map<String, dynamic> data) async {
    final ref = _calendarRef();
    if (ref == null) {
      throw Exception("Veri eklemek için kullanıcı girişi gereklidir.");
    }

    await ref.add(data);
  }
}
