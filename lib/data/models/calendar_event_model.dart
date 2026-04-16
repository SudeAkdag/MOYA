import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarEventModel {
  final String id; // Artık "2026-04-15" gibi bir formatta gelecek
  final DateTime date;
  final double? mood; // 1-10 arası bir değer
  final double? energy; // UI'dan gelen enerji verisi
  final String? note; 
  final String? moodText; 
  final String? emoji;

  CalendarEventModel({
    required this.id, 
    required this.date,
    this.mood,
    this.energy,
    this.note,
    this.moodText,
    this.emoji,
  });

  // Firestore'dan veri okumak için
  factory CalendarEventModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    DateTime parsedDate;
    if (data['date'] is Timestamp) {
      parsedDate = (data['date'] as Timestamp).toDate();
    } else if (data['date'] is String) {
      parsedDate = DateTime.parse(data['date']);
    } else {
      parsedDate = DateTime.now();
    }

    return CalendarEventModel(
      id: doc.id, // Bu artık "yyyy-MM-dd" olacak
      date: parsedDate,
      mood: (data['mood'] as num?)?.toDouble(),
      energy: (data['energy'] as num?)?.toDouble(),
      note: data['note'], 
      moodText: data['moodText'], 
      emoji: data['emoji'],      
    );
  }

  // Firestore'a veri yazmak için (Genel kullanım)
  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'mood': mood,
      'energy': energy,
      'note': note,
      'moodText': moodText, 
      'emoji': emoji,      
    };
  }
}