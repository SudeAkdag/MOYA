import 'package:moya/data/models/music_model.dart';

class MusicService {
  // This is a placeholder. In the future, this will fetch real data from Firebase.
  Future<Playlist> getPlaylist(String categoryId) async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return a dummy playlist based on the category ID
    // This helps in developing the UI without a real backend.
    
    final dummySongs = List<Song>.generate(
      15,
      (index) => Song(
        id: '${categoryId}_$index',
        title: 'Şarkı Adı ${index + 1}',
        artist: '$categoryId Sanatçısı',
        duration: '3:${(index * 15) % 60 < 10 ? '0' : ''}${(index * 15) % 60}',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-${index + 1}.mp3', // Dummy URL
        coverUrl: 'https://picsum.photos/seed/${categoryId}_$index/200', // Dummy image
      ),
    );

    return Playlist(
      id: categoryId,
      title: _mapCategoryIdToTitle(categoryId),
      description: 'Bu, $categoryId kategorisi için oluşturulmuş bir çalma listesidir. Keyfini çıkarın!',
      coverUrl: 'https://picsum.photos/seed/$categoryId/400/400',
      songs: dummySongs,
    );
  }

  String _mapCategoryIdToTitle(String categoryId) {
    switch (categoryId) {
      case 'focus':
        return 'Odaklanma & Çalışma';
      case 'sleep':
        return 'Derin Uyku';
      case 'stress':
        return 'Stres Azaltma';
      case 'nature':
        return 'Doğa Sesleri';
      default:
        return 'Bilinmeyen Kategori';
    }
  }
}
