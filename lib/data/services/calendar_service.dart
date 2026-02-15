import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moya/data/models/calendar_event_model.dart';

class CalendarService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// Belirtilen ay için mevcut kullanıcının olaylarını getiren bir stream döndürür.
  static Stream<List<CalendarEventModel>> getEventsForMonth(DateTime month) {
    // 1. Mevcut kullanıcıyı al.
    final User? user = _auth.currentUser;

    // 2. Kullanıcı giriş yapmamışsa, hata vermemesi için boş bir veri listesi döndür.
    if (user == null) {
      return Stream.value([]);
    }

    // 3. Sorgulanacak ayın başlangıç ve bitiş tarihlerini hesapla.
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 1); // Bir sonraki ayın ilk günü

    // 4. Firestore sorgusunu oluştur ve stream olarak dinle.
    return _firestore
        .collection('calendar')
        // Sadece mevcut kullanıcının verilerini getir (Güvenlik kuralı için kritik).
        .where('userId', isEqualTo: user.uid)
        // Sadece seçili aydaki verileri getir.
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThan: Timestamp.fromDate(endOfMonth))
        .snapshots() // Veritabanındaki değişiklikleri anlık olarak dinler.
        .map((snapshot) {
      // Gelen dökümanları CalendarEventModel listesine çevir.
      return snapshot.docs
          .map((doc) => CalendarEventModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Firestore'a yeni bir günlük girdi ekler.
  static Future<void> addDailyEntry(Map<String, dynamic> data) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("Veri eklemek için kullanıcı girişi gereklidir.");
    }

    // Gelen veriye mevcut kullanıcının kimliğini ekle.
    data['userId'] = user.uid;

    await _firestore.collection('calendar').add(data);
  }
}