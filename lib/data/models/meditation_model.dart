class MeditationModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String audioUrl;
  final String duration;
  final String category;

  MeditationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.audioUrl,
    required this.duration,
    required this.category,
  });

  factory MeditationModel.fromMap(Map<String, dynamic> map, String documentId) {
    return MeditationModel(
      id: documentId,
      title: (map['title'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      image: (map['image'] ?? '') as String,
      audioUrl: (map['audioUrl'] ?? '') as String,
      duration: (map['duration'] ?? '') as String,
      category: (map['category'] ?? 'Genel') as String,
    );
  }
}