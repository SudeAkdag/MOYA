import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarEventModel {
  final String id;
  final DateTime date;
  final double? mood; // 1-10 arası bir değer
  final String? notes;

  CalendarEventModel({
    required this.id,
    required this.date,
    this.mood,
    this.notes,
  });

  // Firestore'dan veri okumak için
  factory CalendarEventModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CalendarEventModel(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      mood: (data['mood'] as num?)?.toDouble(),
      notes: data['notes'],
    );
  }

  // Firestore'a veri yazmak için
  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'mood': mood,
      'notes': notes,
    };
  }
}