import 'package:flutter/material.dart';
import 'package:moya/data/models/music_model.dart';
import 'package:moya/data/services/music_service.dart';
import 'package:moya/data/services/audio_player_service.dart';
import 'package:moya/injection_container.dart';
import 'package:moya/presentation/screens/music/playlist_screen.dart';

class MusicScreen extends StatefulWidget {
  final VoidCallback onMenuTap;

  const MusicScreen({super.key, required this.onMenuTap});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}
    
class _MusicScreenState extends State<MusicScreen> {
  final MusicService musicService = sl<MusicService>();
  final AudioPlayerService audioService = sl<AudioPlayerService>();

  final cardColors = <Color>[];

  late final Stream<List<MusicCategory>> _categoriesStream;
  late final Future<List<Song>> _forYouFuture;
  late final Stream<PlayerState> _playerStream;

  @override
  void initState() {
    super.initState();
    _categoriesStream = musicService.getCategories();
    _forYouFuture = musicService.getForYouSongs(limit: 6);
    _playerStream = audioService.playerStateStream;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (cardColors.isEmpty) {
      cardColors.addAll([
        theme.colorScheme.primaryContainer,
        theme.colorScheme.secondaryContainer,
        theme.colorScheme.tertiaryContainer,
        theme.colorScheme.surfaceContainerHighest,
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: theme.colorScheme.onPrimary),
          onPressed: widget.onMenuTap,
        ),
        title: Text(
          'Müzik ve Rahatlama',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: theme.colorScheme.onPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 220),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMoodSuggestionCard(context),
              const SizedBox(height: 24),
              _buildCategoriesSection(context),
              const SizedBox(height: 24),
              _buildForYouSection(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildPlayerBar(context),
    );
  }

  Widget _buildMoodSuggestionCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: theme.colorScheme.onPrimary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'MODUN İÇİN ÖNERİ',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Zihni Toparlama Zamanı',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Son zamanlardaki yoğunluğuna dayanarak, zihnini berraklaştıracak bu listeyi seçtik.',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final songs = await musicService.getForYouSongs(limit: 1);
              if (songs.isNotEmpty) {
                audioService.play(songs.first);
                musicService.recordPlay(songs.first);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Hemen Dinle',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kategoriler',
              style: theme.textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Tümünü Gör',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<MusicCategory>>(
          stream: _categoriesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Kategori bulunamadı'));
            }
            final categories = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return _buildCategoryCard(
                  context: context,
                  title: cat.title,
                  categoryId: cat.id,
                  icon: _mapIcon(cat.icon),
                  color: cardColors[index % cardColors.length],
                  imageUrl: cat.coverUrl,
                  coverUrl: cat.coverUrl,
                );
              },
            );
          },
        ),
      ],
    );
  }

  IconData _mapIcon(String iconName) {
    switch (iconName) {
      case 'psychology':
        return Icons.psychology;
      case 'bedtime':
        return Icons.bedtime;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'forest':
        return Icons.forest;
      case 'spa':
        return Icons.spa;
      case 'waves':
        return Icons.waves;
      case 'music_note':
        return Icons.music_note;
      default:
        return Icons.music_note;
    }
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required String categoryId,
    required IconData icon,
    required Color color,
    required String imageUrl,
    required String coverUrl,
  }) {
    final theme = Theme.of(context);
    final iconColor = ThemeData.estimateBrightnessForColor(color) == Brightness.dark ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: color,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistScreen(
                    categoryTitle: title,
                    categoryId: categoryId,
                    coverUrl: coverUrl,
                  ),
                ),
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (imageUrl.isNotEmpty)
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: color),
                  ),
                // Başlığın okunabilmesi için altta koyu gradient
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                        Colors.black87,
                      ],
                      stops: [0.35, 0.7, 1.0],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.85),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: iconColor, size: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          shadows: const [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 6,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForYouSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sizin İçin Seçildi',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Song>>(
          future: _forYouFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox(
                height: 150,
                child: Center(child: Text('Henüz öneri yok')),
              );
            }
            final songs = snapshot.data!;
            return SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return _buildForYouCard(
                    context: context,
                    title: song.title,
                    subtitle: song.artist,
                    imageUrl: song.coverUrl,
                    onTap: () {
                      audioService.play(song);
                      musicService.recordPlay(song);
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildForYouCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String imageUrl,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.surfaceContainerHighest,
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Center(
                child: Icon(
                  Icons.play_arrow,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerBar(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<PlayerState>(
      stream: _playerStream,
      builder: (context, snapshot) {
        final currentSong = audioService.currentSong;
        if (currentSong == null) return const SizedBox.shrink();

        final isPlaying = snapshot.data == PlayerState.playing;

        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 128),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.onSecondaryContainer.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: theme.colorScheme.surfaceContainerHighest,
                  image: currentSong.coverUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(currentSong.coverUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: currentSong.coverUrl.isEmpty
                    ? Icon(Icons.music_note, color: theme.colorScheme.onSurface)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentSong.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      currentSong.artist,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: theme.colorScheme.onSecondaryContainer,
                  size: 32,
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
                  size: 32,
                ),
                onPressed: () {
                  audioService.stop();
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
