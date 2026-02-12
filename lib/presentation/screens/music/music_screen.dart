import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/music/playlist_screen.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: theme.colorScheme.onPrimary),
          onPressed: () {},
        ),
        title: Text(
          'Müzik ve Rahatlama',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: theme.colorScheme.onPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMoodSuggestionCard(context),
              const SizedBox(height: 24),
              _buildCategoriesSection(context),
              const SizedBox(height: 24),
              _buildForYouSection(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildPlayerBar(context),
    );
  }

  Widget _buildMoodSuggestionCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: theme.colorScheme.onPrimary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'MODUN İÇİN ÖNERİ',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Zihni Toparlama Zamanı',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Son zamanlardaki yoğunluğuna dayanarak, zihnini berraklaştıracak bu listeyi seçtik.',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Hemen Dinle',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
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
            _buildCategoryCard(
              context: context,
              title: 'Odaklanma & Çalışma',
              categoryId: 'focus',
              icon: Icons.psychology,
              color: cardColors[0],
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBxzVfGi5oIov2eQvEb8StrJdo4X68KxaZOHRdAN1t4bjCNYc__pmz4W4riFFHG7mXiTCBvCgrRffVVDwF217YVLJWZEFmfDcRpL5NjneJ2w0U3AlhoPKq8WFGITqnPW-iMX-_oWOn82QUF1P_GNUCwhzWu945ZkiSek8Lks9Gr3fEhrRBJRdg2q_y7oUQ_XNOdo8ZO225I9Lcq-HVId2hQ4Peoyg8r_fQc2dXO_5WYz5hGpWNrtNWXqkTOgh7772t15UdtAm8grK4',
            ),
            _buildCategoryCard(
              context: context,
              title: 'Derin Uyku',
              categoryId: 'sleep',
              icon: Icons.bedtime,
              color: cardColors[1],
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBCGqMEazLagNpa6Xj2nCSVl598WkcJGKlSUYS4yU0eGpNM8nVeN6fCTWy8tQHedOXjooNMmA5ayCmweFVmzDaeVOo4FV-8v03-kpSteCUDQQOQaQfArAeHNQDE5lQsXMfB4I--17SoT5dVmCV9ka0K1xMdtmPKch7ljSEjYwFBgIOsYCx-dFJW8cDgTZLpmRfLISN6_6KwOUHI66IhxIX17cGP1JQR-kfRcvwpNW_LDptnahxJLSFtTTJlwSnzJxbcLzj-RwnGZDw',
            ),
            _buildCategoryCard(
              context: context,
              title: 'Stres Azaltma',
              categoryId: 'stress',
              icon: Icons.self_improvement,
              color: cardColors[2],
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBHNJ-pFMDMb0Yn3N5OHYg8TsnvmXnr8geIZLNGyUdRfwADmqj1GB_OXuej5HP6YNkBiVcd_-q6YKq-EJD7wixYU9c8Y512K8CyJnj02mpWFUIg-h7Mh33Efz6YQknqtzaWcXGCc5_p4SqHWjfGW5cqdR5vMQCTwCkKHZZXnrx_ogteddg-PGLIYfv1VcJd6irRsInv4UmCUXYT479iQibPmJBkGnagB5vHU2SNvjN5m6SK_9qh8t-NXxyXE0f3b_9hoG8Lh6OnOtU',
            ),
            _buildCategoryCard(
              context: context,
              title: 'Doğa Sesleri',
              categoryId: 'nature',
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

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required String categoryId,
    required IconData icon,
    required Color color,
    required String imageUrl,
  }) {
    final theme = Theme.of(context);
    final brightness = ThemeData.estimateBrightnessForColor(color);
    final iconColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistScreen(
              categoryTitle: title,
              categoryId: categoryId,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.background.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
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

  Widget _buildForYouSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sizin İçin Seçildi',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildForYouCard(
                context: context,
                title: 'Yağmur Sesi',
                subtitle: 'Doğa',
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAr0vNUqjVKS_E92DqCxUFvTuLTJ3yMBGJiNk5Czhej2QdCJ_DZbr6941bdpmWLo2Bw74LzE29mPowBCLvImTIxR77vax7vV81xYEi5XoaVvPckIl_n6hQGZBMqXMxovnFSpPQ4_0LMtwz6xS2RnsFyXhLn3v6hVanqHbpAUBcZ5EwDyP0bq01AeoSRxrBC0xNgC-z2_fKUzV1k5lOS36Tq77ux11cG21gfOj3eCudHtp9z_cvKZWe_yqmll9Yj8okWdPcxD9wdbxw',
              ),
              _buildForYouCard(
                context: context,
                title: 'Orman Yürüyüşü',
                subtitle: 'Ambiyans',
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBAgW3CflygXDd3uNG-e1Xps92Ht36GhrLwDSGeb9leA6Sw8dvTh0CUiMp-01v5DZLibGFpayLrsls73rqRnTcpMMMgL6Tbv-LHiqmzQld8h8Z3XcCQSblOZjY9NgWKEinDMyiLECxOy0ZEoPntNENtin8pnqgvRs55m0QPk0WbpmidKrRldPpvP0TnVV_IPURUFjDzrgm4CDFT_ALDHY0YGcdT5_5JmTDTxG9rC00-ZHIycRP1SyVK608K89trha8RbunskSi2TPg',
              ),
              _buildForYouCard(
                context: context,
                title: 'Okyanus',
                subtitle: 'Rahatlama',
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCFNW6m799F9jL6K03HE2i7tZviPdO5owr993p6JutlyKoe61br7-cirJeKLcaPCV17-WQo1nsBHvhC1tltJ9_dK8ecmRCaIDvKD6sw0fTRm2DitQeuh99FsTBhoQTcSppl0Y-z1u0vB7-yW8ERwA63BkJXuej3OPPDXuQpiNoPsw-ov5dSi9SPVb2LlAokn8Hk94tkgJM_kqrA0bBJ-pvvEfxjrpxAhv7OXd3SxJ_PVGGJhjGqU9ClRcSpvSCVKNdSk84etSLI6s0',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForYouCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String imageUrl,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerBar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.onSecondaryContainer.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCFNW6m799F9jL6K03HE2i7tZviPdO5owr993p6JutlyKoe61br7-cirJeKLcaPCV17-WQo1nsBHvhC1tltJ9_dK8ecmRCaIDvKD6sw0fTRm2DitQeuh99FsTBhoQTcSppl0Y-z1u0vB7-yW8ERwA63BkJXuej3OPPDXuQpiNoPsw-ov5dSi9SPVb2LlAokn8Hk94tkgJM_kqrA0bBJ-pvvEfxjrpxAhv7OXd3SxJ_PVGGJhjGqU9ClRcSpvSCVKNdSk84etSLI6s0',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Okyanus Dalgaları',
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSecondaryContainer),
                ),
                Text(
                  'En son dinlenen',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSecondaryContainer.withOpacity(0.7)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.play_circle_fill,
                color: theme.colorScheme.onSecondaryContainer, size: 32),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
