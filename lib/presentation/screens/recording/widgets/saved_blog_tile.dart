import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../data/models/blog_model.dart';
import '../../blog/blog_detail_screen.dart';

class SavedBlogTile extends StatelessWidget {
  final BlogModel post;
  const SavedBlogTile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BlogDetailScreen(post: post)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 1. KÜÇÜK RESİM (SOLDA)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            
            // 2. METİN ALANI (ORTADA)
            Expanded(
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${post.date} • ${post.readTime}",
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                  ),
                ],
              ),
            ),

            // ... (Diğer kısımlar aynı)


IconButton(
  // Kesikli görünümü engellemek ve temaya uymak için
  style: IconButton.styleFrom(
    foregroundColor: theme.colorScheme.primary, // Senin temanın ana rengi
    padding: EdgeInsets.zero,
  ),
  icon: Icon(
    Icons.bookmark, // İçi dolu bookmark daha premium durur
    color: theme.colorScheme.primary, 
    size: 24,
  ),
  onPressed: () async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      // Basınca listeden silsin
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('saved_blogs')
          .doc(post.id)
          .delete();
          
      // İstersen küçük bir bildirim geçebilirsin
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kaydedilenlerden kaldırıldı"),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  },
),
          ],
        ),
      ),
    );
  }
}