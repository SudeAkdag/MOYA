import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeedService {
  static final _firestore = FirebaseFirestore.instance;

  // Müzik kataloğu sürümü. Seed verisini her güncellediğinde bu sayıyı artır;
  // her cihaz bir defa otomatik olarak Firestore'a yeni veriyi yazar.
  static const int kSeedVersion = 2;
  static const String _seedVersionKey = 'music_seed_version';

  /// Kullanıcı giriş yapmışsa ve yerel sürüm güncel değilse seed'i çalıştırır.
  /// Firestore kuralları yazma için `request.auth != null` istediğinden,
  /// bu fonksiyon main.dart'ta auth restore edildikten ve login/register
  /// başarısından sonra çağrılır.
  static Future<void> runSeedIfNeeded() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_seedVersionKey) ?? 0;
    if (current >= kSeedVersion) return;
    try {
      await seedMusicData();
      await prefs.setInt(_seedVersionKey, kSeedVersion);
    } catch (e) {
      // ignore: avoid_print
      print('Seed güncellenemedi: $e');
    }
  }

  // NOT: Aşağıdaki audioUrl'ler test amaçlı SoundHelix örnekleridir.
  // Gerçek tema uyumlu sesler için (yağmur, orman, lofi vb.) kendi
  // dosyalarınızı Firebase Storage'a yükleyip URL'leri buraya yapıştırın.
  // Diğer tüm meta veriler (başlık, kapak, etiket, açıklama) tema ile uyumludur.
  static const _sh = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-';
  static String _audio(int i) => '$_sh$i.mp3';

  /// Bu fonksiyonu SADECE ilk seferde (veya verileri güncellerken) çalıştır.
  /// `.set()` kullandığı için tekrar çalıştırmak güvenlidir; mevcut belgeleri günceller.
  static Future<void> seedMusicData() async {
    final categories = {
      'focus': {
        'title': 'Odaklanma & Çalışma',
        'icon': 'psychology',
        'coverUrl':
            'https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=400',
        'description':
            'Derin konsantrasyon ve verimli çalışma için hazırlanmış sesler.',
        'order': 1,
        'isActive': true,
        'songCount': 8,
        'createdAt': FieldValue.serverTimestamp(),
      },
      'sleep': {
        'title': 'Derin Uyku',
        'icon': 'bedtime',
        'coverUrl':
            'https://images.unsplash.com/photo-1507400492013-162706c8c05e?w=400',
        'description':
            'Huzurlu bir uykuya dalmanız için sakinleştirici sesler.',
        'order': 2,
        'isActive': true,
        'songCount': 8,
        'createdAt': FieldValue.serverTimestamp(),
      },
      'stress': {
        'title': 'Stres Azaltma',
        'icon': 'self_improvement',
        'coverUrl':
            'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400',
        'description':
            'Gerginliği azaltmak ve zihni sakinleştirmek için meditatif sesler.',
        'order': 3,
        'isActive': true,
        'songCount': 8,
        'createdAt': FieldValue.serverTimestamp(),
      },
      'nature': {
        'title': 'Doğa Sesleri',
        'icon': 'forest',
        'coverUrl':
            'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400',
        'description':
            'Doğanın huzur veren atmosferiyle ruhunuzu dinlendirin.',
        'order': 4,
        'isActive': true,
        'songCount': 8,
        'createdAt': FieldValue.serverTimestamp(),
      },
    };

    for (final entry in categories.entries) {
      await _firestore
          .collection('categories')
          .doc(entry.key)
          .set(entry.value);
    }

    final songs = <Map<String, dynamic>>[
      // ---------- Odaklanma & Çalışma ----------
      {
        'id': 'focus_lofi_01',
        'title': 'Lofi Çalışma Saati',
        'artist': 'Ambient Studio',
        'duration': '4:30',
        'durationMs': 270000,
        'categoryId': 'focus',
        'audioUrl': _audio(1),
        'coverUrl':
            'https://images.unsplash.com/photo-1488190211105-8b0e65b80b4e?w=400',
        'order': 1,
        'isActive': true,
        'playCount': 0,
        'tags': ['lofi', 'study', 'focus'],
      },
      {
        'id': 'focus_piano_rain_01',
        'title': 'Piyano & Yağmur',
        'artist': 'Calm Music',
        'duration': '5:15',
        'durationMs': 315000,
        'categoryId': 'focus',
        'audioUrl': _audio(2),
        'coverUrl':
            'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=400',
        'order': 2,
        'isActive': true,
        'playCount': 0,
        'tags': ['piano', 'rain', 'focus'],
      },
      {
        'id': 'focus_deep_01',
        'title': 'Derin Odaklanma',
        'artist': 'Focus Lab',
        'duration': '6:00',
        'durationMs': 360000,
        'categoryId': 'focus',
        'audioUrl': _audio(3),
        'coverUrl':
            'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400',
        'order': 3,
        'isActive': true,
        'playCount': 0,
        'tags': ['ambient', 'deep', 'focus'],
      },
      {
        'id': 'focus_cafe_01',
        'title': 'Kafe Ambiyansı',
        'artist': 'Coffee Shop Vibes',
        'duration': '5:50',
        'durationMs': 350000,
        'categoryId': 'focus',
        'audioUrl': _audio(4),
        'coverUrl':
            'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400',
        'order': 4,
        'isActive': true,
        'playCount': 0,
        'tags': ['cafe', 'ambient', 'focus'],
      },
      {
        'id': 'focus_classical_01',
        'title': 'Klasik Konsantrasyon',
        'artist': 'Mozart Effect',
        'duration': '7:10',
        'durationMs': 430000,
        'categoryId': 'focus',
        'audioUrl': _audio(5),
        'coverUrl':
            'https://images.unsplash.com/photo-1465847899084-d164df4dedc6?w=400',
        'order': 5,
        'isActive': true,
        'playCount': 0,
        'tags': ['classical', 'focus', 'study'],
      },
      {
        'id': 'focus_pomodoro_01',
        'title': 'Pomodoro Akışı',
        'artist': 'Productivity Lab',
        'duration': '25:00',
        'durationMs': 1500000,
        'categoryId': 'focus',
        'audioUrl': _audio(6),
        'coverUrl':
            'https://images.unsplash.com/photo-1506784983877-45594efa4cbe?w=400',
        'order': 6,
        'isActive': true,
        'playCount': 0,
        'tags': ['pomodoro', 'productivity', 'focus'],
      },
      {
        'id': 'focus_brown_noise_01',
        'title': 'Kahverengi Gürültü',
        'artist': 'Noise Studio',
        'duration': '10:00',
        'durationMs': 600000,
        'categoryId': 'focus',
        'audioUrl': _audio(7),
        'coverUrl':
            'https://images.unsplash.com/photo-1517842645767-c639042777db?w=400',
        'order': 7,
        'isActive': true,
        'playCount': 0,
        'tags': ['brown noise', 'focus', 'concentration'],
      },
      {
        'id': 'focus_synthwave_01',
        'title': 'Synth Çalışma',
        'artist': 'Night Coder',
        'duration': '6:25',
        'durationMs': 385000,
        'categoryId': 'focus',
        'audioUrl': _audio(8),
        'coverUrl':
            'https://images.unsplash.com/photo-1518972559570-7cc1309f3229?w=400',
        'order': 8,
        'isActive': true,
        'playCount': 0,
        'tags': ['synthwave', 'coding', 'focus'],
      },

      // ---------- Derin Uyku ----------
      {
        'id': 'sleep_night_rain_01',
        'title': 'Gece Yağmuru',
        'artist': 'Sleep Sounds',
        'duration': '8:00',
        'durationMs': 480000,
        'categoryId': 'sleep',
        'audioUrl': _audio(9),
        'coverUrl':
            'https://images.unsplash.com/photo-1501691223387-dd0500403074?w=400',
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
        'audioUrl': _audio(10),
        'coverUrl':
            'https://images.unsplash.com/photo-1532274402911-5a369e4c4bb5?w=400',
        'order': 2,
        'isActive': true,
        'playCount': 0,
        'tags': ['lullaby', 'gentle', 'sleep'],
      },
      {
        'id': 'sleep_white_noise_01',
        'title': 'Beyaz Gürültü',
        'artist': 'Sleep Lab',
        'duration': '10:00',
        'durationMs': 600000,
        'categoryId': 'sleep',
        'audioUrl': _audio(11),
        'coverUrl':
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
        'order': 3,
        'isActive': true,
        'playCount': 0,
        'tags': ['whitenoise', 'sleep'],
      },
      {
        'id': 'sleep_moonlight_01',
        'title': 'Dolunay Sessizliği',
        'artist': 'Moonlight',
        'duration': '7:30',
        'durationMs': 450000,
        'categoryId': 'sleep',
        'audioUrl': _audio(12),
        'coverUrl':
            'https://images.unsplash.com/photo-1532978879514-6cb1ddf1ab6c?w=400',
        'order': 4,
        'isActive': true,
        'playCount': 0,
        'tags': ['moon', 'calm', 'sleep'],
      },
      {
        'id': 'sleep_pink_noise_01',
        'title': 'Pembe Gürültü',
        'artist': 'Deep Sleep',
        'duration': '9:00',
        'durationMs': 540000,
        'categoryId': 'sleep',
        'audioUrl': _audio(13),
        'coverUrl':
            'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400',
        'order': 5,
        'isActive': true,
        'playCount': 0,
        'tags': ['pink noise', 'sleep'],
      },
      {
        'id': 'sleep_starry_01',
        'title': 'Yıldız Tozu',
        'artist': 'Cosmic Dreams',
        'duration': '6:50',
        'durationMs': 410000,
        'categoryId': 'sleep',
        'audioUrl': _audio(14),
        'coverUrl':
            'https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?w=400',
        'order': 6,
        'isActive': true,
        'playCount': 0,
        'tags': ['stars', 'cosmic', 'sleep'],
      },
      {
        'id': 'sleep_soft_ocean_01',
        'title': 'Yumuşak Okyanus',
        'artist': 'Sleep Ocean',
        'duration': '8:20',
        'durationMs': 500000,
        'categoryId': 'sleep',
        'audioUrl': _audio(15),
        'coverUrl':
            'https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=400',
        'order': 7,
        'isActive': true,
        'playCount': 0,
        'tags': ['ocean', 'soft', 'sleep'],
      },
      {
        'id': 'sleep_dream_01',
        'title': 'Rüya Müziği',
        'artist': 'Dream Land',
        'duration': '6:15',
        'durationMs': 375000,
        'categoryId': 'sleep',
        'audioUrl': _audio(16),
        'coverUrl':
            'https://images.unsplash.com/photo-1502230831726-fe5549140034?w=400',
        'order': 8,
        'isActive': true,
        'playCount': 0,
        'tags': ['dream', 'sleep'],
      },

      // ---------- Stres Azaltma ----------
      {
        'id': 'stress_breath_01',
        'title': 'Nefes Rehberi',
        'artist': 'Mindful Space',
        'duration': '7:00',
        'durationMs': 420000,
        'categoryId': 'stress',
        'audioUrl': _audio(1),
        'coverUrl':
            'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400',
        'order': 1,
        'isActive': true,
        'playCount': 0,
        'tags': ['breathing', 'meditation', 'stress'],
      },
      {
        'id': 'stress_calm_melody_01',
        'title': 'Sakin Melodi',
        'artist': 'Zen Garden',
        'duration': '4:50',
        'durationMs': 290000,
        'categoryId': 'stress',
        'audioUrl': _audio(2),
        'coverUrl':
            'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?w=400',
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
        'audioUrl': _audio(3),
        'coverUrl':
            'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
        'order': 3,
        'isActive': true,
        'playCount': 0,
        'tags': ['tibetan', 'bells', 'meditation'],
      },
      {
        'id': 'stress_bamboo_01',
        'title': 'Bambu Meditasyonu',
        'artist': 'Eastern Calm',
        'duration': '5:40',
        'durationMs': 340000,
        'categoryId': 'stress',
        'audioUrl': _audio(4),
        'coverUrl':
            'https://images.unsplash.com/photo-1480506132288-68f7705954bd?w=400',
        'order': 4,
        'isActive': true,
        'playCount': 0,
        'tags': ['bamboo', 'meditation', 'zen'],
      },
      {
        'id': 'stress_solfeggio_01',
        'title': 'Solfeggio 528Hz',
        'artist': 'Healing Frequencies',
        'duration': '9:00',
        'durationMs': 540000,
        'categoryId': 'stress',
        'audioUrl': _audio(5),
        'coverUrl':
            'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=400',
        'order': 5,
        'isActive': true,
        'playCount': 0,
        'tags': ['528hz', 'healing', 'frequency'],
      },
      {
        'id': 'stress_chakra_01',
        'title': 'Çakra Dengeleme',
        'artist': 'Sacred Sounds',
        'duration': '8:15',
        'durationMs': 495000,
        'categoryId': 'stress',
        'audioUrl': _audio(6),
        'coverUrl':
            'https://images.unsplash.com/photo-1545389336-cf090694435e?w=400',
        'order': 6,
        'isActive': true,
        'playCount': 0,
        'tags': ['chakra', 'balance', 'meditation'],
      },
      {
        'id': 'stress_yoga_flow_01',
        'title': 'Yoga Akışı',
        'artist': 'Asana Flow',
        'duration': '6:45',
        'durationMs': 405000,
        'categoryId': 'stress',
        'audioUrl': _audio(7),
        'coverUrl':
            'https://images.unsplash.com/photo-1545389336-cf090694435e?w=400',
        'order': 7,
        'isActive': true,
        'playCount': 0,
        'tags': ['yoga', 'flow', 'relax'],
      },
      {
        'id': 'stress_inner_peace_01',
        'title': 'İç Huzur',
        'artist': 'Inner Peace',
        'duration': '5:55',
        'durationMs': 355000,
        'categoryId': 'stress',
        'audioUrl': _audio(8),
        'coverUrl':
            'https://images.unsplash.com/photo-1474418397713-7ede21d49118?w=400',
        'order': 8,
        'isActive': true,
        'playCount': 0,
        'tags': ['peace', 'meditation', 'calm'],
      },

      // ---------- Doğa Sesleri ----------
      {
        'id': 'nature_rain_01',
        'title': 'Yağmur Sesleri',
        'artist': 'Doğa',
        'duration': '5:30',
        'durationMs': 330000,
        'categoryId': 'nature',
        'audioUrl': _audio(9),
        'coverUrl':
            'https://images.unsplash.com/photo-1515694346937-94d85e39e29f?w=400',
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
        'audioUrl': _audio(10),
        'coverUrl':
            'https://images.unsplash.com/photo-1448375240586-882707db888b?w=400',
        'order': 2,
        'isActive': true,
        'playCount': 0,
        'tags': ['forest', 'birds', 'nature'],
      },
      {
        'id': 'nature_ocean_waves_01',
        'title': 'Okyanus Dalgaları',
        'artist': 'Ocean Vibes',
        'duration': '6:45',
        'durationMs': 405000,
        'categoryId': 'nature',
        'audioUrl': _audio(11),
        'coverUrl':
            'https://images.unsplash.com/photo-1505118380757-91f5f5632de0?w=400',
        'order': 3,
        'isActive': true,
        'playCount': 0,
        'tags': ['ocean', 'waves', 'nature'],
      },
      {
        'id': 'nature_waterfall_01',
        'title': 'Şelale Akışı',
        'artist': 'Waterfall Sounds',
        'duration': '6:00',
        'durationMs': 360000,
        'categoryId': 'nature',
        'audioUrl': _audio(12),
        'coverUrl':
            'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?w=400',
        'order': 4,
        'isActive': true,
        'playCount': 0,
        'tags': ['waterfall', 'water', 'nature'],
      },
      {
        'id': 'nature_birds_01',
        'title': 'Kuş Cıvıltıları',
        'artist': 'Forest Birds',
        'duration': '4:55',
        'durationMs': 295000,
        'categoryId': 'nature',
        'audioUrl': _audio(13),
        'coverUrl':
            'https://images.unsplash.com/photo-1444464666168-49d633b86797?w=400',
        'order': 5,
        'isActive': true,
        'playCount': 0,
        'tags': ['birds', 'morning', 'nature'],
      },
      {
        'id': 'nature_mountain_wind_01',
        'title': 'Dağ Rüzgarı',
        'artist': 'Mountain Wind',
        'duration': '7:00',
        'durationMs': 420000,
        'categoryId': 'nature',
        'audioUrl': _audio(14),
        'coverUrl':
            'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=400',
        'order': 6,
        'isActive': true,
        'playCount': 0,
        'tags': ['wind', 'mountain', 'nature'],
      },
      {
        'id': 'nature_meadow_01',
        'title': 'Çayır Sabahı',
        'artist': 'Meadow Morning',
        'duration': '5:35',
        'durationMs': 335000,
        'categoryId': 'nature',
        'audioUrl': _audio(15),
        'coverUrl':
            'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=400',
        'order': 7,
        'isActive': true,
        'playCount': 0,
        'tags': ['meadow', 'morning', 'nature'],
      },
      {
        'id': 'nature_campfire_01',
        'title': 'Kamp Ateşi',
        'artist': 'Campfire Crackle',
        'duration': '8:10',
        'durationMs': 490000,
        'categoryId': 'nature',
        'audioUrl': _audio(16),
        'coverUrl':
            'https://images.unsplash.com/photo-1475738972911-5b44ce984c42?w=400',
        'order': 8,
        'isActive': true,
        'playCount': 0,
        'tags': ['fire', 'campfire', 'nature'],
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
    print(
      'Seed data yüklendi! ${categories.length} kategori ve ${songs.length} şarkı oluşturuldu.',
    );
  }
}
