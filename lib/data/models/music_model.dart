import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String duration;
  final int durationMs;
  final String categoryId;
  final String audioUrl;
  final String coverUrl;
  final int order;
  final bool isActive;
  final int playCount;
  final List<String> tags;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    this.durationMs = 0,
    required this.categoryId,
    required this.audioUrl,
    required this.coverUrl,
    this.order = 0,
    this.isActive = true,
    this.playCount = 0,
    this.tags = const [],
  });

  @override
  List<Object?> get props => [id, title, artist, duration, audioUrl, coverUrl, categoryId];

  factory Song.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Song(
      id: doc.id,
      title: data['title'] ?? 'Bilinmeyen Şarkı',
      artist: data['artist'] ?? 'Bilinmeyen Sanatçı',
      duration: data['duration'] ?? '0:00',
      durationMs: data['durationInMs'] ?? data['durationMs'] ?? 0,
      categoryId: data['categoryId'] ?? '',
      audioUrl: data['audioUrl'] ?? '',
      coverUrl: data['coverUrl'] ?? '',
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
      playCount: data['playCount'] ?? 0,
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  factory Song.fromJson(Map<String, dynamic> json, String id) {
    return Song(
      id: id,
      title: json['title'] ?? 'Bilinmeyen Şarkı',
      artist: json['artist'] ?? 'Bilinmeyen Sanatçı',
      duration: json['duration'] ?? '0:00',
      durationMs: json['durationMs'] ?? 0,
      categoryId: json['categoryId'] ?? '',
      audioUrl: json['audioUrl'] ?? json['url'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? true,
      playCount: json['playCount'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'duration': duration,
      'durationMs': durationMs,
      'categoryId': categoryId,
      'audioUrl': audioUrl,
      'coverUrl': coverUrl,
      'order': order,
      'isActive': isActive,
      'playCount': playCount,
      'tags': tags,
    };
  }
}

class MusicCategory extends Equatable {
  final String id;
  final String title;
  final String icon;
  final String coverUrl;
  final String description;
  final int order;
  final bool isActive;
  final int songCount;

  const MusicCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.coverUrl,
    this.description = '',
    this.order = 0,
    this.isActive = true,
    this.songCount = 0,
  });

  @override
  List<Object?> get props => [id, title, icon, coverUrl];

  factory MusicCategory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MusicCategory(
      id: doc.id,
      title: data['title'] ?? '',
      icon: data['icon'] ?? 'music_note',
      coverUrl: data['coverUrl'] ?? '',
      description: data['description'] ?? '',
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
      songCount: data['songCount'] ?? 0,
    );
  }
}

class Playlist extends Equatable {
  final String id;
  final String title;
  final String description;
  final String coverUrl;
  final List<Song> songs;
  final String categoryId;

  const Playlist({
    required this.id,
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.songs,
    this.categoryId = '',
  });

  @override
  List<Object?> get props => [id, title, description, coverUrl, songs];
}
