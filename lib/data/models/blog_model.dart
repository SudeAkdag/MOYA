class BlogModel {
  final String? id;
  final String title;
  final String author;
  final String category;
  final String description; // Veritabanındaki 'ozet'
  final String content;     // Veritabanındaki 'icerik'
  final String imageUrl;    // Veritabanındaki 'resimUrl'
  final String readTime;    // Veritabanındaki 'okumaSure'
  final String date;        // Veritabanındaki 'tarih'
  final bool isFeatured;

  BlogModel({
    this.id, required this.title, required this.author,
    required this.category, required this.description,
    required this.content, required this.imageUrl,
    required this.readTime, required this.date,
    this.isFeatured = false,
  });

  factory BlogModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return BlogModel(
      id: docId,
      title: json['baslik'] ?? '',      
      author: json['yazar'] ?? '',      
      category: json['kategori'] ?? '', 
      description: json['ozet'] ?? '',   
      content: json['icerik'] ?? '',    
      imageUrl: json['resimUrl'] ?? '', 
      readTime: json['okumaSuresi'] ?? '', 
      date: json['tarih'] ?? '',         
      isFeatured: json['isFeatured'] ?? false,
    );
  }
}