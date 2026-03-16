import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mevcut kullanıcının ID'sini almak için yardımcı getter
  String? get _userId => _auth.currentUser?.uid;

  /// Kullanıcı ayarlarını Firestore'a kaydeder veya günceller.
  /// [notifications] bildirim tercihi, [themeName] ise temanın enum ismi (örn: 'ocean')
  Future<void> updateUserSettings({bool? notifications, String? themeName}) async {
    if (_userId == null) return;

    try {
      final Map<String, dynamic> data = {};
      if (notifications != null) data['notifications_enabled'] = notifications;
      if (themeName != null) data['theme_type'] = themeName;

      await _firestore.collection('users').doc(_userId).set(
        data,
        SetOptions(merge: true), // Sadece gönderilen alanları günceller, diğerlerini silmez
      );
    } catch (e) {
      debugPrint("SettingsService Update Error: $e");
      rethrow; // Gerektiğinde UI tarafında hata yakalamak için
    }
  }

  /// Firestore'dan kullanıcı ayarlarını çeker.
  Future<Map<String, dynamic>?> getUserSettings() async {
    if (_userId == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(_userId).get();
      return doc.data();
    } catch (e) {
      debugPrint("SettingsService Fetch Error: $e");
      return null;
    }
  }

  /// Şifre sıfırlama maili gönderir.
  Future<void> sendPasswordReset() async {
    final email = _auth.currentUser?.email;
    if (email != null) {
      await _auth.sendPasswordResetEmail(email: email);
    } else {
      throw Exception("E-posta adresi bulunamadı.");
    }
  }
}