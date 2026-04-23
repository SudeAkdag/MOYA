import 'package:flutter/material.dart';
import '../../../data/models/meditation_model.dart';
import '../../../data/services/meditation_service.dart';
import 'category_detail_screen.dart';
import 'widgets/meditation_detail_screen.dart';

class MeditationScreenNew extends StatelessWidget {
  const MeditationScreenNew({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme; // Temadaki ana renk şeması

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. AppBar
            SliverAppBar(
              backgroundColor: theme.scaffoldBackgroundColor,
              floating: true,
              pinned: true,
              elevation: 0,
              centerTitle: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                onPressed: () => Navigator.pop(context),
              ),
              titleSpacing: 0,
              title: Text(
                "Meditasyon Keşfet",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),

            // 2. Giriş ve Arama
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Zihnini dinlendir, odaklan ve enerjini tazele.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        style: TextStyle(color: colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: "Nasıl hissediyorsun? Bir seans ar...",
                          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
                          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // 3. İçerik Bölümleri
            _buildSectionHeader(context, "Uykuya Hazırlık"),
            _buildDynamicHorizontalList("Uykuya Hazırlık"),

            _buildSectionHeader(context, "Sabah Enerjisi"),
            _buildDynamicVerticalList("Sabah Enerjisi"),

            _buildSectionHeader(context, "Odaklanma"),
            _buildDynamicFeaturedCard("Odaklanma"),

            const SliverToBoxAdapter(child: SizedBox(height: 50)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, 
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary, // Temanın birincil rengi (Mavi/Teal vb.)
              )
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryDetailScreen(categoryName: title)),
                );
              },
              child: Text("Hepsini Gör", 
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  decoration: TextDecoration.underline,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicHorizontalList(String category) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 210,
        child: StreamBuilder<List<MeditationModel>>(
          stream: MeditationService.getMeditationsByCategory(category),
          builder: (context, snapshot) {
            final theme = Theme.of(context);
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final meditations = snapshot.data!;
            
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: meditations.length,
              itemBuilder: (context, index) {
                final item = meditations[index];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MeditationDetailScreen(meditation: item))),
                  child: Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                child: Image.network(item.image, width: double.infinity, fit: BoxFit.cover),
                              ),
                              Positioned(left: 10, bottom: 10, child: _buildBadge(context, item.duration)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold), maxLines: 1),
                                    Text(item.category, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                                  ],
                                ),
                              ),
                              Icon(Icons.play_circle_outline, color: theme.colorScheme.primary),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDynamicVerticalList(String category) {
    return StreamBuilder<List<MeditationModel>>(
      stream: MeditationService.getMeditationsByCategory(category),
      builder: (context, snapshot) {
        final theme = Theme.of(context);
        if (!snapshot.hasData) return const SliverToBoxAdapter(child: SizedBox());
        final meditations = snapshot.data!;
        
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = meditations[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(item.image, width: 55, height: 55, fit: BoxFit.cover),
                  ),
                  title: Text(item.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text("${item.duration} • ${item.category}", style: theme.textTheme.bodySmall),
                  trailing: Icon(Icons.play_arrow_rounded, color: theme.colorScheme.primary),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MeditationDetailScreen(meditation: item))),
                ),
              );
            },
            childCount: meditations.length,
          ),
        );
      },
    );
  }

  Widget _buildDynamicFeaturedCard(String category) {
    return StreamBuilder<List<MeditationModel>>(
      stream: MeditationService.getMeditationsByCategory(category),
      builder: (context, snapshot) {
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const SliverToBoxAdapter(child: SizedBox());
        final item = snapshot.data!.first;
        
        return SliverToBoxAdapter(
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MeditationDetailScreen(meditation: item))),
            child: Container(
              margin: const EdgeInsets.all(16),
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(image: NetworkImage(item.image), fit: BoxFit.cover),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter, end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBadge(context, "ÖNE ÇIKAN", isFeatured: true),
                    const SizedBox(height: 8),
                    Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(item.duration, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadge(BuildContext context, String label, {bool isFeatured = false}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isFeatured ? theme.colorScheme.primary.withOpacity(0.8) : Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label, 
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)
      ),
    );
  }
}