import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kullanıcıyı veritabanına kaydet
  Future<void> saveUserToFirestore(Map<String, dynamic> userData) async {
    String uid = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(uid).set(userData);
  }

  // Kullanıcı verilerini anlık (Stream) olarak dinle
  Stream<DocumentSnapshot> getUserStream() {
    String uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).snapshots();
  }
}