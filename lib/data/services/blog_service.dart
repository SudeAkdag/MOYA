import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blog_model.dart';

class BlogService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Blogları 'tarih' sırasına göre canlı olarak dinler
  static Stream<List<BlogModel>> getBlogsStream() {
    return _db.collection('blog').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => BlogModel.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }
}