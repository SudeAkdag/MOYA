import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/music/widgets/category_card.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColors = [
      theme.colorScheme.primaryContainer,
      theme.colorScheme.secondaryContainer,
      theme.colorScheme.tertiaryContainer,
      theme.colorScheme.surfaceVariant,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kategoriler',
              style: theme.textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Tümünü Gör',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            CategoryCard(
              title: 'Odaklanma & Çalışma',
              icon: Icons.psychology,
              color: cardColors[0],
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBxzVfGi5oIov2eQvEb8StrJdo4X68KxaZOHRdAN1t4bjCNYc__pmz4W4riFFHG7mXiTCBvCgrRffVVDwF217YVLJWZEFmfDcRpL5NjneJ2w0U3AlhoPKq8WFGITqnPW-iMX-_oWOn82QUF1P_GNUCwhzWu945ZkiSek8Lks9Gr3fEhrRBJRdg2q_y7oUQ_XNOdo8ZO225I9Lcq-HVId2hQ4Peoyg8r_fQc2dXO_5WYz5hGpWNrtNWXqkTOgh7772t15UdtAm8grK4',
            ),
            CategoryCard(
              title: 'Derin Uyku',
              icon: Icons.bedtime,
              color: cardColors[1],
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBCGqMEazLagNpa6Xj2nCSVl598WkcJGKlSUYS4yU0eGpNM8nVeN6fCTWy8tQHedOXjooNMmA5ayCmweFVmzDaeVOo4FV-8v03-kpSteCUDQQOQaQfArAeHNQDE5lQsXMfB4I--17SoT5dVmCV9ka0K1xMdtmPKch7ljSEjYwFBgIOsYCx-dFJW8cDgTZLpmRfLISN6_6KwOUHI66IhxIX17cGP1JQR-kfRcvwpNW_LDptnahxJLSFtTTJlwSnzJxbcLzj-RwnGZDw',
            ),
            CategoryCard(
              title: 'Stres Azaltma',
              icon: Icons.self_improvement,
              color: cardColors[2],
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBHNJ-pFMDMb0Yn3N5OHYg8TsnvmXnr8geIZLNGyUdRfwADmqj1GB_OXuej5HP6YNkBiVcd_-q6YKq-EJD7wixYU9c8Y512K8CyJnj02mpWFUIg-h7Mh33Efz6YQknqtzaWcXGCc5_p4SqHWjfGW5cqdR5vMQCTwCkKHZZXnrx_ogteddg-PGLIYfv1VcJd6irRsInv4UmCUXYT479iQibPmJBkGnagB5vHU2SNvjN5m6SK_9qh8t-NXxyXE0f3b_9hoG8Lh6OnOtU',
            ),
            CategoryCard(
              title: 'Doğa Sesleri',
              icon: Icons.forest,
              color: cardColors[3],
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBjNPKVc-yXpF1O7e_cIa2UqWEC4YpB-7Yh0ZjnKbQlUSMlM85GP4vi8Q57jdrMrNDVXfZCi_1VVMYa1mfMmecW6kt1sD1gzVJe1zMaG3_wKaqCpwwAFSEeA_zK4_7mSqfBdNIhhrKatEVbWYXe3F7LtwFBNaPg9lE5b3UpSLNnuIQPw7Og2CAZqd5rcgQj-NIF_udVbBcQ_fM8qLCTAkq4Exq6uD-OhnHku6L6LskKTksR0_HMcfc44c7L6cpIn5k6FpF11ycaIbM',
            ),
          ],
        ),
      ],
    );
  }
}
