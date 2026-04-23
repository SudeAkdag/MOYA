import 'package:flutter/material.dart';
import 'package:moya/data/services/meditation_service.dart';
import '../../../data/models/meditation_model.dart';
import 'package:moya/presentation/screens/E&M/widgets/meditation_detail_screen.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({
    super.key,
    required this.categoryName,
  });

  final String categoryName;

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder<List<MeditationModel>>(
        stream: MeditationService.getMeditationsByCategory(categoryName),
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: [
              _CategoryHeaderSliver(
                title: categoryName,
                subtitle: _subtitleFor(snapshot),
              ),
              _buildBodySliver(snapshot),
            ],
          );
        },
      ),
    );
  }

  String _subtitleFor(AsyncSnapshot<List<MeditationModel>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) return 'Yükleniyor...';
    if (snapshot.hasError) return 'Bir hata oluştu';
    final count = snapshot.data?.length ?? 0;
    return '$count meditasyon';
  }

  Widget _buildBodySliver(AsyncSnapshot<List<MeditationModel>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (snapshot.hasError) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Bir hata oluştu:\n${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final items = snapshot.data ?? const <MeditationModel>[];
    if (items.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Text('Bu kategoride henüz meditasyon yok.')),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      sliver: SliverList.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return _MeditationCard(
            item: item,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MeditationDetailScreen(meditation: item),
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- YARDIMCI WIDGETLAR (Eksik olan ve hata veren kısımlar burası) ---

class _CategoryHeaderSliver extends StatelessWidget {
  const _CategoryHeaderSliver({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

IconData _getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'uyku':
    case 'uykuya hazırlık':
      return Icons.nights_stay_rounded; // Ay ikonu
    case 'odaklanma':
    case 'sınav öncesi odak':
      return Icons.psychology_rounded; // Beyin/Odak ikonu
    case 'stres':
    case 'rahatlama':
      return Icons.spa_rounded; // Lotus çiçeği ikonu
    case 'enerji':
      return Icons.bolt_rounded; // Şimşek ikonu
    default:
      return Icons.self_improvement; // Varsayılan ikon
  }
}
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;
    

    return SliverAppBar(
      pinned: true,
      expandedHeight: 200, // Biraz daha genişleterek ferahlık sağladık
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      // Geri butonu tasarımı
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: theme.colorScheme.surface.withOpacity(0.4),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 18, color: theme.colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          children: [
            // 1. Arka Plan Gradyanı
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer.withOpacity(0.7),
                      theme.colorScheme.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // 2. Dekoratif Arka Plan İkonu (Boşluğu doldurur)
            Positioned(
              right: -25,
              top: 30,
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  _getCategoryIcon(title), // Kategoriyi temsil eden bir ikon
                  size: 180,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            // 3. İçerik Alanı
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 25, top: topPadding + 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end, // Altta ama padding ile dengeli
                children: [
                  // Kategori Etiketi (Küçük)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "KATEGORİ",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Ana Başlık
                  Text(
                    title,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Alt Başlık (İkonlu)
                  Row(
                    children: [
                      Icon(Icons. library_music_outlined, 
                           size: 14, 
                           color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      const SizedBox(width: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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

class _MeditationCard extends StatelessWidget {
  const _MeditationCard({required this.item, required this.onTap});
  final MeditationModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.onSurface.withOpacity(0.06),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              _CoverImage(imageUrl: item.image, duration: item.duration),
              const SizedBox(width: 12),
              Expanded(
                child: _CardText(
                  title: item.title,
                  description: item.description,
                  category: item.category,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.imageUrl, required this.duration});
  final String imageUrl;
  final String duration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 72,
        height: 72,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: theme.colorScheme.onSurface.withOpacity(0.10),
                child: Icon(Icons.image_not_supported_outlined,
                    color: theme.colorScheme.onSurface.withOpacity(0.45)),
              ),
            ),
            Positioned(
              right: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(duration,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardText extends StatelessWidget {
  const _CardText({required this.title, required this.description, required this.category});
  final String title;
  final String description;
  final String category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: theme.colorScheme.onSurface, fontWeight: FontWeight.w900, fontSize: 15)),
        const SizedBox(height: 4),
        Text(description.isEmpty ? 'Açıklama yok.' : description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.60), fontSize: 12, height: 1.2)),
        const SizedBox(height: 8),
        Row(
          children: const [
           
            SizedBox(width: 8),
            _Chip(icon: Icons.headphones_outlined, label: 'Dinle'),
          ],
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: theme.colorScheme.onSurface.withOpacity(0.6)),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}