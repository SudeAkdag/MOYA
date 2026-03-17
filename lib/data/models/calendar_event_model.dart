import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarEventModel {
  final String id;
  final DateTime date;
  final double? mood; // 1-10 arası bir değer
  final String? notes;
  
  // --- YENİ EKLENEN ALANLAR ---
  final String? moodText; 
  final String? emoji;

  CalendarEventModel({
    required this.id,
    required this.date,
    this.mood,
    this.notes,
    this.moodText,
    this.emoji,
  });

  // Firestore'dan veri okumak için
  factory CalendarEventModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Tarih okurken uygulamayı çökertmemesi için güvenlik ağı:
    DateTime parsedDate;
    if (data['date'] is Timestamp) {
      parsedDate = (data['date'] as Timestamp).toDate();
    } else if (data['date'] is String) {
      parsedDate = DateTime.parse(data['date']);
    } else {
      parsedDate = DateTime.now(); // Beklenmeyen bir durumda bugünü baz al
    }

    return CalendarEventModel(
      id: doc.id,
      date: parsedDate,
      mood: (data['mood'] as num?)?.toDouble(),
      notes: data['notes'],
      moodText: data['moodText'], // Veritabanından çekiliyor
      emoji: data['emoji'],       // Veritabanından çekiliyor
    );
  }

  // Firestore'a veri yazmak için
  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'mood': mood,
      'notes': notes,
      'moodText': moodText, // Veritabanına yazılıyor
      'emoji': emoji,       // Veritabanına yazılıyor
    };
  }
}