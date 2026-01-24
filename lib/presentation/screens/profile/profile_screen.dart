import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: theme.appBarTheme.backgroundColor?.withValues(alpha: 0.9),
            title: Text(
              'Profil',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
            pinned: true,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Divider(
                height: 1, 
                color: theme.dividerColor.withValues(alpha: 0.1),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildProfileHeader(theme),
                  const SizedBox(height: 32),
                  _buildStatistics(theme),
                  const SizedBox(height: 32),
                  _buildMoodHistory(theme),
                  const SizedBox(height: 32),
                  _buildAccountInfo(theme),
                  const SizedBox(height: 32),
                  _buildFavorites(theme),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: theme.primaryColor,
        elevation: 4,
        shape: const CircleBorder(),
        child: Icon(Icons.forum, color: theme.scaffoldBackgroundColor),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 56,
          backgroundColor: theme.primaryColor,
          child: const CircleAvatar(
            radius: 54,
            backgroundImage: NetworkImage('https://picsum.photos/200'),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Ayşe Yılmaz',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified, color: theme.primaryColor, size: 18),
            const SizedBox(width: 4),
            Text(
              'Premium Üye',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
            foregroundColor: theme.primaryColor,
            side: BorderSide(color: theme.primaryColor.withValues(alpha: 0.3)),
            elevation: 0,
          ),
          child: const Text('Profili Düzenle'),
        ),
      ],
    );
  }

  Widget _buildStatistics(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            'İstatistikler',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                theme,
                icon: Icons.self_improvement,
                label: 'Odak',
                value: '12s 30dk',
                subValue: 'Bu hafta',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                theme,
                icon: Icons.local_fire_department,
                label: 'Seri',
                value: '5 Gün',
                subValue: 'En iyi seri: 14 gün',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildCompletedTasks(theme),
      ],
    );
  }

  Widget _buildStatCard(ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
    required String subValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subValue,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedTasks(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle_outline, color: theme.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  const Text('TAMAMLANAN'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '42 Görev',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                  backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                ),
                Text(
                  '75%',
                  style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodHistory(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ruh Hali Geçmişi',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Tümünü Gör'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            height: 128,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMoodBar(theme, 'Pzt', 0.4),
                _buildMoodBar(theme, 'Sal', 0.65),
                _buildMoodBar(theme, 'Çar', 0.8, isToday: true),
                _buildMoodBar(theme, 'Per', 0.5),
                _buildMoodBar(theme, 'Cum', 0.3),
                _buildMoodBar(theme, 'Cmt', 0.7),
                _buildMoodBar(theme, 'Paz', 0.85),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodBar(ThemeData theme, String day, double heightFactor, {bool isToday = false}) {
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
                  color: isToday ? theme.primaryColor : theme.primaryColor.withValues(alpha: 0.4),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            day,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isToday ? theme.primaryColor : null,
              fontWeight: isToday ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            'Hesap Bilgileri',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildInfoTile(theme, icon: Icons.mail_outline, title: 'E-posta', subtitle: 'ayse.yilmaz@ornek.com'),
              _buildInfoTile(theme, icon: Icons.cake_outlined, title: 'Doğum Tarihi', subtitle: '12 Mayıs 1995'),
              _buildInfoTile(
                theme,
                icon: Icons.palette_outlined,
                title: 'Uygulama Teması',
                subtitle: 'Dinamik Tema',
                trailing: CircleAvatar(radius: 8, backgroundColor: theme.primaryColor),
                hideChevron: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    bool hideChevron = false,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
        child: Icon(icon, color: theme.primaryColor, size: 20),
      ),
      title: Text(title, style: theme.textTheme.labelSmall),
      subtitle: Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
      trailing: hideChevron ? trailing : const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }

  Widget _buildFavorites(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Favoriler', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('Düzenle')),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFavoriteCard(theme, title: 'Sabah Nefesi', subtitle: '5 dakika • Nefes', icon: Icons.play_circle),
              const SizedBox(width: 16),
              _buildFavoriteCard(theme, title: 'Derin Uyku', subtitle: '30 dakika • Müzik', icon: Icons.headphones),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteCard(ThemeData theme, {required String title, required String subtitle, required IconData icon}) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Center(child: Icon(icon, size: 40, color: theme.primaryColor.withValues(alpha: 0.5))),
                Positioned(
                  top: 8, 
                  right: 8,
                  child: Icon(Icons.favorite, color: theme.primaryColor, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 1),
          Text(subtitle, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}