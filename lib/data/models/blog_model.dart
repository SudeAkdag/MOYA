class BlogModel {
  final String title;
  final String author;
  final String category;
  final String description;
  final String imageUrl;
  final String readTime;
  final String date;
  final bool isFeatured;

  BlogModel({
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.readTime,
    required this.date,
    this.isFeatured = false,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      category: json['category'] ?? 'Genel',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/400x200',
      readTime: json['readTime'] ?? '5 dk',
      date: json['date'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
    );
  }
}