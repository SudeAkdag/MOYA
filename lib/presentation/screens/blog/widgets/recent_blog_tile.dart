import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../data/models/blog_model.dart';
import '../blog_detail_screen.dart';

class RecentBlogTile extends StatelessWidget {
  final BlogModel post;
  const RecentBlogTile({super.key, required this.post});

  // --- 1. KAYDETME FONKSİYONU (TOGGLE) ---
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
        await docRef.delete();
      } else {
        await docRef.set(post.toMap());
      }
    } catch (e) {
      debugPrint("Kayıt hatası: $e");
    }
  }

  // --- 2. KAYITLI MI KONTROL EDEN STREAM ---
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
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogDetailScreen(post: post),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Blog Küçük Resmi
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.imageUrl, 
                width: 85, 
                height: 85, 
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 85, height: 85, color: Colors.grey[300], child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Yazı Detayları
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.category.toUpperCase(), 
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.title, 
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), 
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${post.author} • ${post.readTime}", 
                    style: theme.textTheme.bodySmall
                  ),
                ],
              ),
            ),
            
            // --- 3. AKILLI KAYDET BUTONU ---
            StreamBuilder<bool>(
              stream: _isSavedStream(),
              builder: (context, snapshot) {
                final isSaved = snapshot.data ?? false;
                return IconButton(
                  onPressed: () => _toggleSave(context, isSaved), 
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border, 
                    color: isSaved ? theme.colorScheme.primary : theme.hintColor,
                    size: 24,
                  )
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}