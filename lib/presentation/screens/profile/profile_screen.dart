import 'package:flutter/material.dart';
import 'package:moya/core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDarkPink,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.backgroundDarkPink.withAlpha(230),
            title: const Text(
              'Profil',
              style: TextStyle(
                color: AppColors.textMainPink,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textMainPink),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined,
                    color: AppColors.textMainPink),
              ),
            ],
            pinned: true,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: AppColors.textSubPink.withAlpha(25),
                height: 1.0,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildProfileHeader(),
                  const SizedBox(height: 32),
                  _buildStatistics(),
                  const SizedBox(height: 32),
                  _buildMoodHistory(),
                  const SizedBox(height: 32),
                  _buildAccountInfo(),
                  const SizedBox(height: 32),
                  _buildFavorites(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryPink,
        child: Icon(Icons.forum, color: AppColors.backgroundDarkPink),
        elevation: 4,
        shape: const CircleBorder(),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 56,
          backgroundColor: AppColors.primaryPink,
          child: CircleAvatar(
            radius: 54,
            backgroundImage: NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuC4LZAwoirynTRF3PiBRi2hxGlBWxcngrEIMA5MShtI1xvuvFp8x_vwy1utY87ktepjZ4-q2uBvxfiN2v4rAbpJOZG5WtD5ZxLGgKaSErnjFH64Chnb1yl3qbh90EX1cLBJ88u7f_Ckc6L0rOXMV3gUd3uGkVIigd81RxthiJuesO8ukk5vrkiq6hntAIEXMa7CxR7vbnzkATHUi9C-kcq-rVL5R8L4err1JKUDdx-KW46nKx5Vy27k5aeYTGOJWcoOxyV-qILcuDo'),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Ayşe Yılmaz',
          style: TextStyle(
            color: AppColors.textMainPink,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified, color: AppColors.primaryPink, size: 18),
            const SizedBox(width: 4),
            Text(
              'Premium Üye',
              style: TextStyle(
                color: AppColors.textSubPink,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPink.withOpacity(0.2),
            side: BorderSide(color: AppColors.primaryPink.withOpacity(0.3)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: const Size(double.infinity, 48),
            elevation: 0,
          ),
          child: Text(
            'Profili Düzenle',
            style: TextStyle(
              color: AppColors.primaryPink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            'İstatistikler',
            style: TextStyle(
              color: AppColors.textMainPink,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
                child: _buildStatCard(
              icon: Icons.self_improvement,
              label: 'Odak',
              value: '12s 30dk',
              subValue: 'Bu hafta',
            )),
            const SizedBox(width: 12),
            Expanded(
                child: _buildStatCard(
              icon: Icons.local_fire_department,
              label: 'Seri',
              value: '5 Gün',
              subValue: 'En iyi seri: 14 gün',
              iconColor: AppColors.textMainPink,
            )),
          ],
        ),
        const SizedBox(height: 12),
        _buildCompletedTasks(),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String subValue,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDarkPink,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor ?? AppColors.textSubPink, size: 20),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textSubPink,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textMainPink,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subValue,
            style: TextStyle(
              color: AppColors.textSubPink.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedTasks() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDarkPink,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: AppColors.textSubPink, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'TAMAMLANAN',
                    style: TextStyle(
                      color: AppColors.textSubPink,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '42 Görev',
                style: TextStyle(
                  color: AppColors.textMainPink,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 48,
            width: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.75,
                  strokeWidth: 3,
                  backgroundColor: Colors.black.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.textMainPink),
                ),
                const Text(
                  '75%',
                  style: TextStyle(
                    color: AppColors.textMainPink,
                    fontSize: 10,
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

  Widget _buildMoodHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ruh Hali Geçmişi',
              style: TextStyle(
                color: AppColors.textMainPink,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Tümünü Gör',
                style: TextStyle(color: AppColors.textSubPink, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceDarkPink,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: SizedBox(
            height: 128,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMoodBar('Pzt', 0.4),
                _buildMoodBar('Sal', 0.65),
                _buildMoodBar('Çar', 0.8, isToday: true),
                _buildMoodBar('Per', 0.5),
                _buildMoodBar('Cum', 0.3),
                _buildMoodBar('Cmt', 0.7),
                _buildMoodBar('Paz', 0.85),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodBar(String day, double heightFactor,
      {bool isToday = false}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: FractionallySizedBox(
              heightFactor: heightFactor,
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: isToday
                      ? AppColors.textMainPink
                      : AppColors.textMainPink.withOpacity(heightFactor * 0.8),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                  boxShadow: isToday
                      ? [
                          BoxShadow(
                            color: AppColors.textMainPink.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            day,
            style: TextStyle(
              color: isToday
                  ? AppColors.textMainPink
                  : AppColors.textSubPink.withOpacity(0.7),
              fontSize: 10,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            'Hesap Bilgileri',
            style: TextStyle(
              color: AppColors.textMainPink,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDarkPink,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              _buildInfoTile(
                icon: Icons.mail_outline,
                title: 'E-posta',
                subtitle: 'ayse.yilmaz@ornek.com',
              ),
              _buildInfoTile(
                icon: Icons.cake_outlined,
                title: 'Doğum Tarihi',
                subtitle: '12 Mayıs 1995',
              ),
              _buildInfoTile(
                icon: Icons.palette_outlined,
                title: 'Uygulama Teması',
                subtitle: 'Modern Pembe',
                trailing: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                ),
                hideChevron: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    bool hideChevron = false,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.textMainPink.withOpacity(0.2),
        child: Icon(icon, color: AppColors.textMainPink, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(color: AppColors.textSubPink, fontSize: 12)),
      subtitle: Text(subtitle,
          style: const TextStyle(
              color: AppColors.textMainPink,
              fontSize: 14,
              fontWeight: FontWeight.w500)),
      trailing: hideChevron
          ? trailing
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                trailing ?? const SizedBox(),
                const Icon(Icons.chevron_right, color: AppColors.textSubPink),
              ],
            ),
      onTap: () {},
    );
  }

  Widget _buildFavorites() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Favoriler',
              style: TextStyle(
                color: AppColors.textMainPink,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Düzenle',
                  style: TextStyle(color: AppColors.textSubPink, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFavoriteCard(
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBK2nM-iBYTksE5pvo4hhQL4_s6MLLyJsEw2WsmHPDUOjhoggzaIJki1m-N-z-BcKZIi1MXw9pxlWDOVtVUX4JRE8IQjDN3AcLhjLKJDQKht6Wi9Qrdyq9tWO2Efqkh7uIL7t70BhNO2TshWZn2An1zMqx3nXOoSNn7IfdlvQOGPvmPgZEpmpNwkrEltXOT_j6uVbOfLPn3rYqwPD_-p8t4SEoA9p66DZ0rZU_BN6RHg4UlcCrbZ-3OHipZ6OYfo-Q5Wys7ehIquK0',
                title: 'Sabah Nefesi',
                subtitle: '5 dakika • Nefes',
                icon: Icons.play_circle,
              ),
              const SizedBox(width: 16),
              _buildFavoriteCard(
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAzyD7p5xtWGpmMzeLVdqDZs8ML6dH5uSYVZltGwq2jNUAnyi0XQeEW9JyMU9QgR9NyLOZ2ngPtuKSRgG5l6yCCu2yMZdoJXirUz4i0XT2tIXiF1PGeZ7vAi0Hx8go-pbcc3M_lgpLCv-__h-FgkCEmte-FVzfElRxGFWpUD3sv9z0g6hFAvwCqaoJmxVPz_04pvqVDUrJns6b1hNjFCH-nun3TXPtYHxZWcLlt9TqhU57Q5mMIGC7WgrKFUdasSLd5JNC1iFJ-qUw',
                title: 'Derin Uyku',
                subtitle: '30 dakika • Müzik',
                icon: Icons.headphones,
              ),
              const SizedBox(width: 16),
              _buildFavoriteCard(
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuC6SEYwHuYWplARyOcnoxbP2Gp-Of0DWBE5V6waZ-ZjbU4dw6OwVThGENbmscXcwk9-8YCQt94y53bviI1UOf1bpzF6V6ABEhZ8nc2lwmvfI3O7QV-XQxxfElpTWF1_LJfyze2U-aWaN8sJB88Z45TDi6UU4iurdtyQbC29AE3eF1_-xhwzEBF4zX4Sl48JFRxD4097bMv1LlhF766zt8WVtaQUt071qn1AGIXnQDPbXXSU2x6ZQYLWQRdvBReJrJ0UxjpcUTI0biU',
                title: 'Stres Yönetimi',
                subtitle: 'Blog • 3 dk okuma',
                icon: Icons.article,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteCard({
    required String imageUrl,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor:
                          AppColors.backgroundDarkPink.withOpacity(0.6),
                      child: const Icon(Icons.favorite,
                          color: AppColors.textMainPink, size: 14),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Icon(icon, color: AppColors.textMainPink, size: 18),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
                color: AppColors.textMainPink,
                fontWeight: FontWeight.bold,
                fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.textSubPink, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
