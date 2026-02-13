import 'package:get_it/get_it.dart';
import 'package:moya/data/services/music_service.dart';

final sl = GetIt.instance;

void init() {
  // Services
  sl.registerLazySingleton(() => MusicService());
}
