import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:moya/data/models/music_model.dart';
import 'dart:developer' as developer;

enum PlayerState { idle, loading, playing, paused, error }

class AudioPlayerService {
  AudioPlayer? _player;
  bool _initialized = false;
  bool _broken = false;

  Song? _currentSong;

  Song? get currentSong => _currentSong;

  AudioPlayer? get player => _player;

  void _ensureInitialized() {
    if (_broken || _initialized) return;
    try {
      _player = AudioPlayer();
      _initialized = true;
    } catch (e) {
      developer.log("AudioPlayer başlatma hatası", error: e);
      _player = null;
      _broken = true;
    }
  }

  Stream<PlayerState> get playerStateStream {
    _ensureInitialized();
    if (_player == null) return Stream.value(PlayerState.idle);

    return _player!.playerStateStream.map((state) {
      if (state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering) {
        return PlayerState.loading;
      } else if (state.playing) {
        return PlayerState.playing;
      } else if (state.processingState == ProcessingState.completed) {
        return PlayerState.idle;
      } else {
        return PlayerState.paused;
      }
    }).transform(StreamTransformer<PlayerState, PlayerState>.fromHandlers(
      handleData: (data, sink) => sink.add(data),
      handleError: (error, stackTrace, sink) {
        developer.log("Player state stream hatası", error: error);
        sink.add(PlayerState.idle);
      },
    ));
  }

  Stream<Duration> get positionStream {
    _ensureInitialized();
    if (_player == null) return Stream.value(Duration.zero);
    return _player!.positionStream;
  }

  Duration? get totalDuration => _player?.duration;

  Future<void> play(Song song) async {
    try {
      _ensureInitialized();
      if (_player == null || _broken) return;

      _currentSong = song;

      await _player!.setUrl(song.audioUrl);
      await _player!.play();
    } catch (e) {
      developer.log("Şarkı çalma hatası", error: e);
      _broken = true;
      _currentSong = null;
    }
  }

  Future<void> pause() async {
    try {
      await _player?.pause();
    } catch (e) {
      developer.log("Pause hatası", error: e);
    }
  }

  Future<void> resume() async {
    try {
      await _player?.play();
    } catch (e) {
      developer.log("Resume hatası", error: e);
    }
  }

  Future<void> stop() async {
    try {
      await _player?.stop();
      _currentSong = null;
    } catch (e) {
      developer.log("Stop hatası", error: e);
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      await _player?.seek(position);
    } catch (e) {
      developer.log("Seek hatası", error: e);
    }
  }

  Future<void> dispose() async {
    try {
      await _player?.dispose();
    } catch (e) {
      developer.log("Dispose hatası", error: e);
    }
  }
}
