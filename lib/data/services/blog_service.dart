import '../models/blog_model.dart';

class BlogService {
  static final List<BlogModel> blogPosts = [
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
    BlogModel(
      title: 'Kaliteli Uyku İçin 5 İpucu',
      author: 'Psk. Öğr. Damla Y.',
      category: 'UYKU',
      description: 'Uyku kalitenizi artırmak için yapılması gerekenler...',
      imageUrl: 'https://picsum.photos/400/202',
      readTime: '4 dk',
      date: '10 Ekim 2023',
    ),
  ];

  static List<String> categories = ["Tümü", "Meditasyon", "Psikoloji", "Uyku", "Nefes"];
}