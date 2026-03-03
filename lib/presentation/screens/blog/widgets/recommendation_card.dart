import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../data/models/blog_model.dart';
import '../blog_detail_screen.dart';

class RecommendationCard extends StatelessWidget {
  final BlogModel post;
  const RecommendationCard({super.key, required this.post});

  // --- KAYDETME FONKSİYONU ---
  Future<void> _toggleSave(BuildContext context, bool isCurrentlySaved) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

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
      debugPrint("Hata: $e");
    }
  }

  // --- KAYITLI MI KONTROLÜ ---
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlogDetailScreen(post: post),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim ve Kaydet Butonu Katmanı
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    post.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.broken_image, color: theme.hintColor),
                    ),
                  ),
                ),
                // --- BURASI EKLENDİ: SAĞ ÜST KAYDET BUTONU ---
                Positioned(
                  top: 8,
                  right: 8,
                  child: StreamBuilder<bool>(
                    stream: _isSavedStream(),
                    builder: (context, snapshot) {
                      final isSaved = snapshot.data ?? false;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          onPressed: () => _toggleSave(context, isSaved),
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                            size: 18,
                            color: isSaved ? theme.colorScheme.primary : Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.category.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}