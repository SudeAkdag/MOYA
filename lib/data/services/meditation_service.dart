import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meditation_model.dart';

class MeditationService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<List<MeditationModel>> getMeditationsStream() {
    return _db.collection('meditasyon').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // 'as Map<String, dynamic>' kaldırıldı
        return MeditationModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  static Stream<List<MeditationModel>> getMeditationsByCategory(String category) {
    return _db
        .collection('meditasyon')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        // 'as Map<String, dynamic>' kaldırıldı
        return MeditationModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}