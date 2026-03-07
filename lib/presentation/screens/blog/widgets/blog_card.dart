import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/blog/blog_detail_screen.dart';
import '../../../../data/models/blog_model.dart';

class BlogCard extends StatelessWidget {
  final BlogModel post;
  const BlogCard({super.key, required this.post});

  // Kaydetme veya Kayıttan Çıkarma Fonksiyonu (Toggle)
  Future<void> _toggleSave(BuildContext context, bool isCurrentlySaved) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lütfen önce giriş yapın!")),
        );
        return;
      }

      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_blogs')
          .doc(post.id);

      if (isCurrentlySaved) {
        // Zaten kayıtlıysa SİL
        await docRef.delete();
      } else {
        // Kayıtlı değilse EKLE
        await docRef.set(post.toMap());
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata oluştu: $e")),
        );
      }
    }
  }

  // Bu bloğun kayıtlı olup olmadığını anlık dinleyen Stream
  Stream<bool> _isSavedStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value(false);
    
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('saved_blogs')
        .doc(post.id)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- RESİM VE ÜST BUTONLAR ALANI ---
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                Image.network(
                  post.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
                // Resim Üstündeki Bilgi ve Buton Satırı
                Positioned(
                  top: 10,
                  left: 12,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Okuma Süresi
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.white, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              post.readTime,
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      // Kaydet Butonu (Gelişmiş Stream)
                      StreamBuilder<bool>(
                        stream: _isSavedStream(),
                        builder: (context, snapshot) {
                          final isSaved = snapshot.data ?? false;
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(8),
                              onPressed: () => _toggleSave(context, isSaved),
                              icon: Icon(
                                isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                                size: 20,
                                color: isSaved 
                                    ? theme.colorScheme.primary 
                                    : Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // --- METİN İÇERİK ALANI ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.category.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                
                // Alt Bilgi Satırı
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${post.date} • ${post.author}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlogDetailScreen(post: post),
                          ),
                        );
                      },
                      child: Text(
                        'Devamını Oku →',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}