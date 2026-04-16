import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moya/data/models/music_model.dart';
import 'dart:developer' as developer;

class MusicService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ========== KATEGORİLER ==========

  Stream<List<MusicCategory>> getCategories() {
    return _firestore
        .collection('categories')
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => MusicCategory.fromFirestore(doc))
          .where((cat) => cat.isActive)
          .toList();
      list.sort((a, b) => a.order.compareTo(b.order));
      return list;
    }).onErrorReturn([]);
  }

  Future<List<MusicCategory>> getCategoriesOnce() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      final list = snapshot.docs
          .map((doc) => MusicCategory.fromFirestore(doc))
          .where((cat) => cat.isActive)
          .toList();
      list.sort((a, b) => a.order.compareTo(b.order));
      return list;
    } catch (e) {
      developer.log("Kategori çekme hatası", error: e);
      return [];
    }
  }

  // ========== ŞARKILAR ==========

  Stream<List<Song>> getSongsByCategory(String categoryId) {
    return _firestore
        .collection('songs')
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => Song.fromFirestore(doc))
          .where((song) => song.isActive)
          .toList();
      list.sort((a, b) => a.order.compareTo(b.order));
      return list;
    }).onErrorReturn([]);
  }

  Future<Playlist> getPlaylist(String categoryId) async {
    try {
      final catDoc =
          await _firestore.collection('categories').doc(categoryId).get();

      final songsSnapshot = await _firestore
          .collection('songs')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      final songs = songsSnapshot.docs
          .map((doc) => Song.fromFirestore(doc))
          .where((song) => song.isActive)
          .toList();
      songs.sort((a, b) => a.order.compareTo(b.order));

      final catData = catDoc.data() ?? {};

      return Playlist(
        id: categoryId,
        title: catData['title'] ?? 'Bilinmeyen Kategori',
        description: catData['description'] ?? '',
        coverUrl: catData['coverUrl'] ?? '',
        songs: songs,
        categoryId: categoryId,
      );
    } catch (e) {
      developer.log("Playlist çekme hatası", error: e);
      return Playlist(
        id: categoryId,
        title: 'Hata',
        description: 'Playlist yüklenirken bir hata oluştu.',
        coverUrl: '',
        songs: [],
        categoryId: categoryId,
      );
    }
  }

  // ========== SİZİN İÇİN SEÇİLDİ ==========

  Future<List<Song>> getForYouSongs({int limit = 6}) async {
    try {
      final snapshot = await _firestore.collection('songs').get();
      final songs = snapshot.docs
          .map((doc) => Song.fromFirestore(doc))
          .where((song) => song.isActive)
          .toList();
      songs.sort((a, b) => b.playCount.compareTo(a.playCount));
      return songs.take(limit).toList();
    } catch (e) {
      developer.log("ForYou şarkı çekme hatası", error: e);
      return [];
    }
  }

  // ========== SON DİNLENENLER ==========

  Future<List<Song>> getRecentlyPlayed({int limit = 5}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final recentSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('recentlyPlayed')
          .orderBy('playedAt', descending: true)
          .limit(limit)
          .get();

      List<Song> songs = [];
      for (final doc in recentSnapshot.docs) {
        final songId = doc.data()['songId'] as String?;
        if (songId != null) {
          final songDoc =
              await _firestore.collection('songs').doc(songId).get();
          if (songDoc.exists) {
            songs.add(Song.fromFirestore(songDoc));
          }
        }
      }
      return songs;
    } catch (e) {
      developer.log("Son dinlenenler hatası", error: e);
      return [];
    }
  }

  void recordPlay(Song song) {
    final user = _auth.currentUser;
    if (user == null) return;

    // Fire-and-forget: UI'ı bloklamaz, hata olursa sessizce geçer
    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('recentlyPlayed')
        .doc(song.id)
        .set({
      'songId': song.id,
      'categoryId': song.categoryId,
      'playedAt': FieldValue.serverTimestamp(),
    }).catchError((_) => null);
  }

  // ========== FAVORİLER ==========

  Future<bool> toggleFavorite(String songId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final favRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(songId);

      final doc = await favRef.get();
      if (doc.exists) {
        await favRef.delete();
        return false;
      } else {
        await favRef.set({
          'songId': songId,
          'addedAt': FieldValue.serverTimestamp(),
        });
        return true;
      }
    } catch (e) {
      developer.log("Favori toggle hatası", error: e);
      return false;
    }
  }

  Stream<bool> isFavorite(String songId) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(false);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(songId)
        .snapshots()
        .map((doc) => doc.exists)
        .onErrorReturn(false);
  }

  Future<List<Song>> getFavorites() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final favSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .orderBy('addedAt', descending: true)
          .get();

      List<Song> songs = [];
      for (final doc in favSnapshot.docs) {
        final songId = doc.data()['songId'] as String?;
        if (songId != null) {
          final songDoc =
              await _firestore.collection('songs').doc(songId).get();
          if (songDoc.exists) {
            songs.add(Song.fromFirestore(songDoc));
          }
        }
      }
      return songs;
    } catch (e) {
      developer.log("Favoriler çekme hatası", error: e);
      return [];
    }
  }

  // ========== ARAMA ==========

  Future<List<Song>> searchSongs(String query) async {
    try {
      if (query.isEmpty) return [];

      final snapshot = await _firestore.collection('songs').get();

      final lowerQuery = query.toLowerCase();
      return snapshot.docs
          .map((doc) => Song.fromFirestore(doc))
          .where((song) =>
              song.isActive &&
              (song.title.toLowerCase().contains(lowerQuery) ||
                  song.artist.toLowerCase().contains(lowerQuery) ||
                  song.tags
                      .any((tag) => tag.toLowerCase().contains(lowerQuery))))
          .toList();
    } catch (e) {
      developer.log("Arama hatası", error: e);
      return [];
    }
  }
}

// Stream extension: hata olunca fallback değer yayınla
extension _StreamErrorReturn<T> on Stream<T> {
  Stream<T> onErrorReturn(T fallback) {
    return transform(StreamTransformer<T, T>.fromHandlers(
      handleData: (data, sink) => sink.add(data),
      handleError: (error, stackTrace, sink) {
        developer.log("Stream hatası, fallback kullanılıyor", error: error);
        sink.add(fallback);
      },
    ));
  }
}
