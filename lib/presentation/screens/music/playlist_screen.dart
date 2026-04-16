import 'package:flutter/material.dart';

import 'package:moya/data/models/music_model.dart';
import 'package:moya/data/services/music_service.dart';
import 'package:moya/data/services/audio_player_service.dart';
import 'package:moya/injection_container.dart';

class PlaylistScreen extends StatefulWidget {
  final String categoryTitle;
  final String categoryId;

  const PlaylistScreen({
    super.key,
    required this.categoryTitle,
    required this.categoryId,
  });

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final MusicService musicService = sl<MusicService>();
  final AudioPlayerService audioService = sl<AudioPlayerService>();

  late final Stream<List<Song>> _songsStream;
  late final Stream<PlayerState> _playerStream;

  @override
  void initState() {
    super.initState();
    _songsStream = musicService.getSongsByCategory(widget.categoryId);
    _playerStream = audioService.playerStateStream;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      bottomNavigationBar: _buildMiniPlayer(theme),
      body: StreamBuilder<List<Song>>(
        stream: _songsStream,
        builder: (context, snapshot) {
          final songs = snapshot.data ?? [];
          final isLoading =
              snapshot.connectionState == ConnectionState.waiting;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (songs.isEmpty) {
            return const Center(child: Text('Şarkı bulunamadı.'));
          }

          return Column(
            children: [
              // Oynat / Karıştır butonları
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Oynat'),
                        onPressed: () {
                          audioService.play(songs.first);
                          musicService.recordPlay(songs.first);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.shuffle),
                        label: const Text('Karıştır'),
                        onPressed: () {
                          final shuffled = List<Song>.from(songs)..shuffle();
                          audioService.play(shuffled.first);
                          musicService.recordPlay(shuffled.first);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurface,
                          side: BorderSide(color: theme.dividerColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Şarkı listesi
              Expanded(
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      title: Text(song.title),
                      subtitle: Text(song.artist),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            song.duration,
                            style: theme.textTheme.bodySmall,
                          ),
                          _FavoriteButton(
                            songId: song.id,
                            musicService: musicService,
                          ),
                        ],
                      ),
                      onTap: () {
                        audioService.play(song);
                        musicService.recordPlay(song);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMiniPlayer(ThemeData theme) {
    return StreamBuilder<PlayerState>(
      stream: _playerStream,
      builder: (context, snapshot) {
        final currentSong = audioService.currentSong;
        if (currentSong == null) return const SizedBox.shrink();

        final isPlaying = snapshot.data == PlayerState.playing;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.onSecondaryContainer.withOpacity(0.1),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Icon(Icons.music_note,
                    color: theme.colorScheme.onSecondaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentSong.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentSong.artist,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: theme.colorScheme.onSecondaryContainer,
                    size: 36,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      audioService.pause();
                    } else {
                      audioService.resume();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.stop_circle_outlined,
                    color: theme.colorScheme.onSecondaryContainer,
                    size: 36,
                  ),
                  onPressed: () {
                    audioService.stop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  final String songId;
  final MusicService musicService;

  const _FavoriteButton({required this.songId, required this.musicService});

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  late final Stream<bool> _favStream;

  @override
  void initState() {
    super.initState();
    _favStream = widget.musicService.isFavorite(widget.songId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _favStream,
      builder: (context, favSnapshot) {
        final isFav = favSnapshot.data ?? false;
        return IconButton(
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.red : null,
            size: 20,
          ),
          onPressed: () {
            widget.musicService.toggleFavorite(widget.songId);
          },
        );
      },
    );
  }
}
