import 'package:flutter/material.dart';
import 'package:moya/data/models/music_category.dart';
import 'package:moya/presentation/screens/music/playlist_screen.dart';
import 'package:moya/presentation/widgets/category_card.dart';

class MusicHomeScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;
  const MusicHomeScreen({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    // Hardcoded category data based on user's mockup
    final List<MusicCategory> categories = [
      MusicCategory(
        id: 'focus',
        title: 'Odaklanma & Çalışma',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBxzVfGi5oIov2eQvEb8StrJdo4X68KxaZOHRdAN1t4bjCNYc__pmz4W4riFFHG7mXiTCBvCgrRffVVDwF217YVLJWZEFmfDcRpL5NjneJ2w0U3AlhoPKq8WFGITqnPW-iMX-_oWOn82QUF1P_GNUCwhzWu945ZkiSek8Lks9Gr3fEhrRBJRdg2q_y7oUQ_XNOdo8ZO225I9Lcq-HVId2hQ4Peoyg8r_fQc2dXO_5WYz5hGpWNrtNWXqkTOgh7772t15UdtAm8grK4',
      ),
      MusicCategory(
        id: 'sleep',
        title: 'Derin Uyku',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBCGqMEazLagNpa6Xj2nCSVl598WkcJGKlSUYS4yU0eGpNM8nVeN6fCTWy8tQHedOXjooNMmA5ayCmweFVmzDaeVOo4FV-8v03-kpSteCUDQQOQaQfArAeHNQDE5lQsXMfB4I--17SoT5dVmCV9ka0K1xMdtmPKch7ljSEjYwFBgIOsYCx-dFJW8cDgTZLpmRfLISN6_6KwOUHI66IhxIX17cGP1JQR-kfRcvwpNW_LDptnahxJLSFtTTJlwSnzJxbcLzj-RwnGZDw',
      ),
      MusicCategory(
        id: 'stress',
        title: 'Stres Azaltma',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBHNJ-pFMDMb0Yn3N5OHYg8TsnvmXnr8geIZLNGyUdRfwADmqj1GB_OXuej5HP6YNkBiVcd_-q6YKq-EJD7wixYU9c8Y512K8CyJnj02mpWFUIg-h7Mh33Efz6YQknqtzaWcXGCc5_p4SqHWjfGW5cqdR5vMQCTwCkKHZZXnrx_ogteddg-PGLIYfv1VcJd6irRsInv4UmCUXYT479iQibPmJBkGnagB5vHU2SNvjN5m6SK_9qh8t-NXxyXE0f3b_9hoG8Lh6OnOtU',
      ),
      MusicCategory(
        id: 'nature',
        title: 'Doğa Sesleri',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBjNPKVc-yXpF1O7e_cIa2UqWEC4YpB-7Yh0ZjnKbQlUSMlM85GP4vi8Q57jdrMrNDVXfZCi_1VVMYa1mfMmecW6kt1sD1gzVJe1zMaG3_wKaqCpwwAFSEeA_zK4_7mSqfBdNIhhrKatEVbWYXe3F7LtwFBNaPg9lE5b3UpSLNnuIQPw7Og2CAZqd5rcgQj-NIF_udVbBcQ_fM8qLCTAkq4Exq6uD-OhnHku6L6LskKTksR0_HMcfc44c7L6cpIn5k6FpF11ycaIbM',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onMenuTap,
        ),
        title: const Text('Müzik ve Rahatlama'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 4 / 5,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryCard(
            category: category,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistScreen(
                    categoryId: category.id,
                    categoryTitle: category.title,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
