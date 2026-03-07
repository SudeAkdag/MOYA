import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blog_model.dart';

import 'package:firebase_auth/firebase_auth.dart'; // User ID için lazım

class BlogService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. Mevcut Blogları Getir (Senin kodun)
  static Stream<List<BlogModel>> getBlogsStream() {
    return _db.collection('blog').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => BlogModel.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  // 2. Bloğu Kullanıcının "kaydedilenler" Klasörüne Ekle
  static Future<void> saveBlogToUser(BlogModel blog) async {
    final String uid = _auth.currentUser!.uid; // Giriş yapan kullanıcının ID'si

    await _db
        .collection('users')         // Ana kullanıcılar listesi
        .doc(uid)                    // Mevcut kullanıcı dokümanı
        .collection('saved_blogs')   // Kullanıcıya özel "Kaydedilenler" alt koleksiyonu
        .doc(blog.id)                // Bloğun kendi ID'sini döküman ID'si yapıyoruz (tekrarı önler)
        .set(blog.toMap());          // Bloğun tüm verilerini buraya kopyalıyoruz
  }

  static Stream<List<BlogModel>> getSavedBlogsStream() {
  final user = _auth.currentUser;
  
  // Kullanıcı giriş yapmamışsa boş liste döndür, uygulama çökmesin
  if (user == null) {
    return Stream.value([]); 
  }

  return _db
      .collection('users')
      .doc(user.uid)
      .collection('saved_blogs')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => BlogModel.fromFirestore(doc.data(), doc.id))
            .toList();
      });
}
}