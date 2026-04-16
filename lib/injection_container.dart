import 'package:get_it/get_it.dart';
import 'package:moya/data/services/music_service.dart';
import 'package:moya/data/services/audio_player_service.dart';

final sl = GetIt.instance;

void init() {
  // Services
  sl.registerLazySingleton(() => MusicService());
  sl.registerLazySingleton(() => AudioPlayerService());
}
