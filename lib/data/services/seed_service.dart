import 'package:cloud_firestore/cloud_firestore.dart';

class SeedService {
  static final _firestore = FirebaseFirestore.instance;

  /// Bu fonksiyonu SADECE ilk seferde çalıştır.
  /// main.dart'ta veya bir debug butonunda çağır.
  static Future<void> seedMusicData() async {
    final categories = {
      'focus': {
        'title': 'Odaklanma & Çalışma',
        'icon': 'psychology',
        'coverUrl': 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400',
        'description': 'Derin konsantrasyon ve verimli çalışma için hazırlanmış sesler.',
        'order': 1,
        'isActive': true,
        'songCount': 3,
        'createdAt': FieldValue.serverTimestamp(),
      },
      'sleep': {
        'title': 'Derin Uyku',
        'icon': 'bedtime',
        'coverUrl': 'https://images.unsplash.com/photo-1507400492013-162706c8c05e?w=400',
        'description': 'Huzurlu bir uykuya dalmanız için sakinleştirici sesler.',
        'order': 2,
        'isActive': true,
        'songCount': 3,
        'createdAt': FieldValue.serverTimestamp(),
      },
      'stress': {
        'title': 'Stres Azaltma',
        'icon': 'self_improvement',
        'coverUrl': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400',
        'description': 'Gerginliği azaltmak ve zihni sakinleştirmek için.',
        'order': 3,
        'isActive': true,
        'songCount': 3,
        'createdAt': FieldValue.serverTimestamp(),
      },
      'nature': {
        'title': 'Doğa Sesleri',
        'icon': 'forest',
        'coverUrl': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400',
        'description': 'Doğanın huzur veren sesleri ile rahatlayın.',
        'order': 4,
        'isActive': true,
        'songCount': 3,
        'createdAt': FieldValue.serverTimestamp(),
      },
    };

    for (final entry in categories.entries) {
      await _firestore.collection('categories').doc(entry.key).set(entry.value);
    }

    final songs = [
      // Focus kategorisi
      {
        'id': 'focus_lofi_01',
        'title': 'Lofi Çalışma Müziği',
        'artist': 'Ambient Studio',
        'duration': '4:30',
        'durationMs': 270000,
        'categoryId': 'focus',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        'coverUrl': 'https://images.unsplash.com/photo-1488190211105-8b0e65b80b4e?w=200',
        'order': 1,
        'isActive': true,
        'playCount': 0,
        'tags': ['lofi', 'study', 'focus'],
      },
      {
        'id': 'focus_piano_01',
        'title': 'Piyano & Yağmur',
        'artist': 'Calm Music',
        'duration': '5:15',
        'durationMs': 315000,
        'categoryId': 'focus',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        'coverUrl': 'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=200',
        'order': 2,
        'isActive': true,
        'playCount': 0,
        'tags': ['piano', 'rain', 'focus'],
      },
      {
        'id': 'focus_ambient_01',
        'title': 'Derin Odaklanma',
        'artist': 'Focus Lab',
        'duration': '6:00',
        'durationMs': 360000,
        'categoryId': 'focus',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        'coverUrl': 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=200',
        'order': 3,
        'isActive': true,
        'playCount': 0,
        'tags': ['ambient', 'deep', 'focus'],
      },
      // Sleep kategorisi
      {
        'id': 'sleep_rain_01',
        'title': 'Gece Yağmuru',
        'artist': 'Sleep Sounds',
        'duration': '8:00',
        'durationMs': 480000,
        'categoryId': 'sleep',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
        'coverUrl': 'https://images.unsplash.com/photo-1501691223387-dd0500403074?w=200',
        'order': 1,
        'isActive': true,
        'playCount': 0,
        'tags': ['rain', 'night', 'sleep'],
      },
      {
        'id': 'sleep_lullaby_01',
        'title': 'Hafif Ninni',
        'artist': 'Dream Weaver',
        'duration': '5:45',
        'durationMs': 345000,
        'categoryId': 'sleep',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
        'coverUrl': 'https://images.unsplash.com/photo-1532274402911-5a369e4c4bb5?w=200',
        'order': 2,
        'isActive': true,
        'playCount': 0,
        'tags': ['lullaby', 'gentle', 'sleep'],
      },
      {
        'id': 'sleep_whitenoise_01',
        'title': 'Beyaz Gürültü',
        'artist': 'Sleep Lab',
        'duration': '10:00',
        'durationMs': 600000,
        'categoryId': 'sleep',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
        'coverUrl': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=200',
        'order': 3,
        'isActive': true,
        'playCount': 0,
        'tags': ['whitenoise', 'sleep'],
      },
      // Stress kategorisi
      {
        'id': 'stress_breath_01',
        'title': 'Nefes Rehberi',
        'artist': 'Mindful Space',
        'duration': '7:00',
        'durationMs': 420000,
        'categoryId': 'stress',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
        'coverUrl': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=200',
        'order': 1,
        'isActive': true,
        'playCount': 0,
        'tags': ['breathing', 'meditation', 'stress'],
      },
      {
        'id': 'stress_calm_01',
        'title': 'Sakin Melodi',
        'artist': 'Zen Garden',
        'duration': '4:50',
        'durationMs': 290000,
        'categoryId': 'stress',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
        'coverUrl': 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?w=200',
        'order': 2,
        'isActive': true,
        'playCount': 0,
        'tags': ['calm', 'melody', 'relax'],
      },
      {
        'id': 'stress_tibetan_01',
        'title': 'Tibet Çanları',
        'artist': 'Sacred Sounds',
        'duration': '6:30',
        'durationMs': 390000,
        'categoryId': 'stress',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
        'coverUrl': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=200',
        'order': 3,
        'isActive': true,
        'playCount': 0,
        'tags': ['tibetan', 'bells', 'meditation'],
      },
      // Nature kategorisi
      {
        'id': 'nature_rain_01',
        'title': 'Yağmur Sesleri',
        'artist': 'Doğa',
        'duration': '5:30',
        'durationMs': 330000,
        'categoryId': 'nature',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
        'coverUrl': 'https://images.unsplash.com/photo-1515694346937-94d85e39e29f?w=200',
        'order': 1,
        'isActive': true,
        'playCount': 0,
        'tags': ['rain', 'nature', 'water'],
      },
      {
        'id': 'nature_forest_01',
        'title': 'Orman Yürüyüşü',
        'artist': 'Nature',
        'duration': '7:20',
        'durationMs': 440000,
        'categoryId': 'nature',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3',
        'coverUrl': 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=200',
        'order': 2,
        'isActive': true,
        'playCount': 0,
        'tags': ['forest', 'birds', 'nature'],
      },
      {
        'id': 'nature_ocean_01',
        'title': 'Okyanus Dalgaları',
        'artist': 'Ocean Vibes',
        'duration': '6:45',
        'durationMs': 405000,
        'categoryId': 'nature',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3',
        'coverUrl': 'https://images.unsplash.com/photo-1505118380757-91f5f5632de0?w=200',
        'order': 3,
        'isActive': true,
        'playCount': 0,
        'tags': ['ocean', 'waves', 'nature'],
      },
    ];

    for (final song in songs) {
      final id = song['id'] as String;
      final data = Map<String, dynamic>.from(song);
      data.remove('id');
      data['createdAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('songs').doc(id).set(data);
    }

    // ignore: avoid_print
    print('Seed data yüklendi! 4 kategori ve 12 şarkı oluşturuldu.');
  }
}
