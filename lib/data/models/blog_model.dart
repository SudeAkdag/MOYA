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
}


final List<BlogModel> blogPosts = [
  BlogModel(
    title: 'Kaygı ile Başa Çıkmanın Yolları',
    author: 'Psk. Dan. Ahmet Y.',
    category: 'PSİKOLOJİ',
    description: 'Günlük hayatta karşılaştığımız stres faktörlerini yönetmek...',
    imageUrl: 'https://picsum.photos/400/200',
    readTime: '5 dk',
    date: '12 Ekim 2023',
    isFeatured: true,
  ),
  BlogModel(
    title: 'Doğru Nefes Teknikleri',
    author: 'Dr. Elif K.',
    category: 'NEFES',
    description: 'Zihninizi sakinleştirmek için temel egzersizler...',
    imageUrl: 'https://picsum.photos/400/201',
    readTime: '3 dk',
    date: '10 Ekim 2023',
  ),
];