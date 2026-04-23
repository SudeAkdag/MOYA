import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:moya/data/models/meditation_model.dart';

class MeditationDetailScreen extends StatefulWidget {
  final MeditationModel meditation;

  const MeditationDetailScreen({super.key, required this.meditation});

  @override
  State<MeditationDetailScreen> createState() => _MeditationDetailScreenState();
}

class _MeditationDetailScreenState extends State<MeditationDetailScreen> {
  late YoutubePlayerController _controller;
  bool isFavorite = false;
  bool _isPlayerReady = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    try {
      final videoId = YoutubePlayer.convertUrlToId(widget.meditation.audioUrl) 
          ?? widget.meditation.audioUrl;

      debugPrint('🎵 Video URL: ${widget.meditation.audioUrl}');
      debugPrint('📺 Video ID: $videoId');

      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          hideControls: false,
          disableDragSeek: false,
        ),
      );

      _controller.addListener(_onPlayerStateChanged);
      debugPrint('✅ Controller oluşturuldu ve listener eklendi');
    } catch (e) {
      debugPrint('❌ Controller oluşturma hatası: $e');
    }
  }

  void _onPlayerStateChanged() {
    if (_isDisposed) return;

    try {
      if (mounted && _controller.value.isReady) {
        if (!_isPlayerReady) {
          setState(() => _isPlayerReady = true);
          debugPrint('✅ Player hazır oldu');
        }
        // Slider güncelleme için state update
        if (_isPlayerReady) {
          setState(() {});
        }
      }
    } catch (e) {
      debugPrint('⚠️ Listener hatası: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    try {
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
      _controller.removeListener(_onPlayerStateChanged);
      _controller.dispose();
      debugPrint('✅ Controller temizlendi');
    } catch (e) {
      debugPrint('⚠️ Dispose hatası: $e');
    }
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: colorScheme.primary,
        onReady: () {
          debugPrint('✅ onReady callback çağrıldı');
          if (!_isDisposed && mounted) {
            setState(() => _isPlayerReady = true);
          }
        },
        onEnded: (metadata) {
          debugPrint('⏹️ Video sona erdi');
        },
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // --- ÜST BAR ---
                _buildTopBar(colorScheme, theme),

                // --- YOUTUBE PLAYER (Gizli) ---
                Opacity(
                  opacity: 0,
                  child: SizedBox(
                    height: 1,
                    child: player,
                  ),
                ),

                const Spacer(flex: 2),

                // --- KAPAK FOTOĞRAFI ---
                _buildCoverImage(),

                const Spacer(flex: 2),

                // --- BAŞLIK VE AÇIKLAMA ---
                _buildInfoSection(theme, colorScheme),

                const Spacer(flex: 3),

                // --- PLAYER KONTROLLERİ ---
                _buildPlayerControls(theme, colorScheme),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(ColorScheme colorScheme, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.expand_more, color: colorScheme.onSurface, size: 32),
            onPressed: () => Navigator.pop(context),
          ),
          Text("Moya Meditasyon", 
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant, 
                letterSpacing: 1.2
              )),
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.redAccent : colorScheme.onSurface, size: 28),
            onPressed: () => setState(() => isFavorite = !isFavorite),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), 
            blurRadius: 30, 
            offset: const Offset(0, 15)
          )
        ],
        image: DecorationImage(
          image: NetworkImage(widget.meditation.image), 
          fit: BoxFit.cover
        ),
      ),
    );
  }

  Widget _buildInfoSection(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(widget.meditation.title, textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold, 
                color: colorScheme.onSurface
              )),
          const SizedBox(height: 12),
          Text(widget.meditation.description, textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant
              ),
              maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildPlayerControls(ThemeData theme, ColorScheme colorScheme) {
    // ⭐ Player hazır değilse hiç bir şey gösterme
    if (!_isPlayerReady) {
      return const SizedBox.shrink(); // Tamamen gizle
    }

    // ⭐ Güvenli değişken erişimi
    Duration currentPos = Duration.zero;
    Duration totalDur = Duration.zero;
    bool isPlaying = false;

    try {
      currentPos = _controller.value.position;
      totalDur = _controller.value.metaData.duration;
      isPlaying = _controller.value.isPlaying;
    } catch (e) {
      debugPrint('⚠️ Değer erişim hatası: $e');
      return const SizedBox.shrink(); // Hata durumunda da gizle
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Progress Slider
          SliderTheme(
            data: theme.sliderTheme.copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              activeTrackColor: colorScheme.primary,
              inactiveTrackColor: colorScheme.surfaceContainerHighest,
              thumbColor: colorScheme.primary,
            ),
            child: Slider(
              value: currentPos.inSeconds.toDouble(),
              max: totalDur.inSeconds > 0 ? totalDur.inSeconds.toDouble() : 1.0,
              onChanged: (v) {
                if (_isPlayerReady && !_isDisposed) {
                  try {
                    _controller.seekTo(Duration(seconds: v.toInt()));
                    debugPrint('🎯 Seek to: ${v.toInt()}s');
                  } catch (e) {
                    debugPrint('⚠️ Seek hatası: $e');
                  }
                }
              },
            ),
          ),

          // Zaman gösterimi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(currentPos), style: theme.textTheme.labelSmall),
                Text(formatTime(totalDur), style: theme.textTheme.labelSmall),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Kontrol butonları
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Shuffle
              IconButton(
                icon: const Icon(Icons.shuffle),
                onPressed: () {
                  debugPrint('🔀 Shuffle tapped');
                },
              ),

              // 10 saniye geri
              IconButton(
                icon: const Icon(Icons.replay_10, size: 32),
                onPressed: () {
                  if (_isPlayerReady && !_isDisposed) {
                    try {
                      final newPos = currentPos - const Duration(seconds: 10);
                      if (newPos.isNegative) {
                        _controller.seekTo(Duration.zero);
                      } else {
                        _controller.seekTo(newPos);
                      }
                      debugPrint('⏮️ Replay 10s');
                      setState(() {});
                    } catch (e) {
                      debugPrint('⚠️ Replay hatası: $e');
                    }
                  }
                },
              ),

              // Play/Pause butonu (büyük)
              GestureDetector(
                onTap: () {
                  if (_isPlayerReady && !_isDisposed) {
                    try {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                        debugPrint('⏸️ Paused');
                      } else {
                        _controller.play();
                        debugPrint('▶️ Playing');
                      }
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (mounted) setState(() {});
                      });
                    } catch (e) {
                      debugPrint('❌ Play/Pause hatası: $e');
                    }
                  } else {
                    debugPrint('⚠️ Player hazır değil');
                  }
                },
                child: Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: colorScheme.onPrimary,
                    size: 48,
                  ),
                ),
              ),

              // 10 saniye ileri
              IconButton(
                icon: const Icon(Icons.forward_10, size: 32),
                onPressed: () {
                  if (_isPlayerReady && !_isDisposed) {
                    try {
                      final newPos = currentPos + const Duration(seconds: 10);
                      _controller.seekTo(newPos);
                      debugPrint('⏭️ Forward 10s');
                      setState(() {});
                    } catch (e) {
                      debugPrint('⚠️ Forward hatası: $e');
                    }
                  }
                },
              ),

              // Repeat
              IconButton(
                icon: const Icon(Icons.repeat),
                onPressed: () {
                  debugPrint('🔁 Repeat tapped');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}