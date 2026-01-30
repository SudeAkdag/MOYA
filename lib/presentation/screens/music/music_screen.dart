import 'package:flutter/material.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A).withOpacity(0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Müzik ve Rahatlama',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
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
              _buildMoodSuggestionCard(),
              const SizedBox(height: 24),
              _buildCategoriesSection(),
              const SizedBox(height: 24),
              _buildForYouSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildPlayerBar(),
    );
  }

  Widget _buildMoodSuggestionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4BB8EE), Color(0xFF2D9CDB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4BB8EE).withOpacity(0.2),
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
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'MODUN İÇİN ÖNERİ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Zihni Toparlama Zamanı',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Son zamanlardaki yoğunluğuna dayanarak, zihnini berraklaştıracak bu listeyi seçtik.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow, color: Color(0xFF4BB8EE)),
                SizedBox(width: 8),
                Text(
                  'Hemen Dinle',
                  style: TextStyle(
                    color: Color(0xFF4BB8EE),
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

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kategoriler',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Tümünü Gör',
                style: TextStyle(
                  color: Color(0xFF4BB8EE),
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
              title: 'Odaklanma & Çalışma',
              icon: Icons.psychology,
              color: const Color(0xFF154984),
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBxzVfGi5oIov2eQvEb8StrJdo4X68KxaZOHRdAN1t4bjCNYc__pmz4W4riFFHG7mXiTCBvCgrRffVVDwF217YVLJWZEFmfDcRpL5NjneJ2w0U3AlhoPKq8WFGITqnPW-iMX-_oWOn82QUF1P_GNUCwhzWu945ZkiSek8Lks9Gr3fEhrRBJRdg2q_y7oUQ_XNOdo8ZO225I9Lcq-HVId2hQ4Peoyg8r_fQc2dXO_5WYz5hGpWNrtNWXqkTOgh7772t15UdtAm8grK4',
            ),
            _buildCategoryCard(
              title: 'Derin Uyku',
              icon: Icons.bedtime,
              color: Colors.indigo,
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBCGqMEazLagNpa6Xj2nCSVl598WkcJGKlSUYS4yU0eGpNM8nVeN6fCTWy8tQHedOXjooNMmA5ayCmweFVmzDaeVOo4FV-8v03-kpSteCUDQQOQaQfArAeHNQDE5lQsXMfB4I--17SoT5dVmCV9ka0K1xMdtmPKch7ljSEjYwFBgIOsYCx-dFJW8cDgTZLpmRfLISN6_6KwOUHI66IhxIX17cGP1JQR-kfRcvwpNW_LDptnahxJLSFtTTJlwSnzJxbcLzj-RwnGZDw',
            ),
            _buildCategoryCard(
              title: 'Stres Azaltma',
              icon: Icons.self_improvement,
              color: Colors.teal,
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBHNJ-pFMDMb0Yn3N5OHYg8TsnvmXnr8geIZLNGyUdRfwADmqj1GB_OXuej5HP6YNkBiVcd_-q6YKq-EJD7wixYU9c8Y512K8CyJnj02mpWFUIg-h7Mh33Efz6YQknqtzaWcXGCc5_p4SqHWjfGW5cqdR5vMQCTwCkKHZZXnrx_ogteddg-PGLIYfv1VcJd6irRsInv4UmCUXYT479iQibPmJBkGnagB5vHU2SNvjN5m6SK_9qh8t-NXxyXE0f3b_9hoG8Lh6OnOtU',
            ),
            _buildCategoryCard(
              title: 'Doğa Sesleri',
              icon: Icons.forest,
              color: Colors.green,
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBjNPKVc-yXpF1O7e_cIa2UqWEC4YpB-7Yh0ZjnKbQlUSMlM85GP4vi8Q57jdrMrNDVXfZCi_1VVMYa1mfMmecW6kt1sD1gzVJe1zMaG3_wKaqCpwwAFSEeA_zK4_7mSqfBdNIhhrKatEVbWYXe3F7LtwFBNaPg9lE5b3UpSLNnuIQPw7Og2CAZqd5rcgQj-NIF_udVbBcQ_fM8qLCTAkq4Exq6uD-OhnHku6L6LskKTksR0_HMcfc44c7L6cpIn5k6FpF11ycaIbM',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required Color color,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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
                  child: Icon(icon, color: Colors.white, size: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForYouSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sizin İçin Seçildi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildForYouCard(
                title: 'Yağmur Sesi',
                subtitle: 'Doğa',
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAr0vNUqjVKS_E92DqCxUFvTuLTJ3yMBGJiNk5Czhej2QdCJ_DZbr6941bdpmWLo2Bw74LzE29mPowBCLvImTIxR77vax7vV81xYEi5XoaVvPckIl_n6hQGZBMqXMxovnFSpPQ4_0LMtwz6xS2RnsFyXhLn3v6hVanqHbpAUBcZ5EwDyP0bq01AeoSRxrBC0xNgC-z2_fKUzV1k5lOS36Tq77ux11cG21gfOj3eCudHtp9z_cvKZWe_yqmll9Yj8okWdPcxD9wdbxw',
              ),
              _buildForYouCard(
                title: 'Orman Yürüyüşü',
                subtitle: 'Ambiyans',
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBAgW3CflygXDd3uNG-e1Xps92Ht36GhrLwDSGeb9leA6Sw8dvTh0CUiMp-01v5DZLibGFpayLrsls73rqRnTcpMMMgL6Tbv-LHiqmzQld8h8Z3XcCQSblOZjY9NgWKEinDMyiLECxOy0ZEoPntNENtin8pnqgvRs55m0QPk0WbpmidKrRldPpvP0TnVV_IPURUFjDzrgm4CDFT_ALDHY0YGcdT5_5JmTDTxG9rC00-ZHIycRP1SyVK608K89trha8RbunskSi2TPg',
              ),
              _buildForYouCard(
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
    required String title,
    required String subtitle,
    required String imageUrl,
  }) {
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
                color: Colors.white.withOpacity(0.7),
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF154984).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Okyanus Dalgaları',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'En son dinlenen',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_fill,
                color: Colors.white, size: 32),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
