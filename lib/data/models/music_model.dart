import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String duration;
  final String url;
  final String coverUrl;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.url,
    required this.coverUrl,
  });

  @override
  List<Object?> get props => [id, title, artist, duration, url, coverUrl];

  factory Song.fromJson(Map<String, dynamic> json, String id) {
    return Song(
      id: id,
      title: json['title'] ?? 'Bilinmeyen Şarkı',
      artist: json['artist'] ?? 'Bilinmeyen Sanatçı',
      duration: json['duration'] ?? '0:00',
      url: json['url'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
    );
  }
}

class Playlist extends Equatable {
  final String id;
  final String title;
  final String description;
  final String coverUrl;
  final List<Song> songs;

  const Playlist({
    required this.id,
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.songs,
  });

  @override
  List<Object?> get props => [id, title, description, coverUrl, songs];
}
