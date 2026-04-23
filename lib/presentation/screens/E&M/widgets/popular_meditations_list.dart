import 'package:flutter/material.dart';
import 'package:moya/data/models/meditation_model.dart';
import 'package:moya/data/services/meditation_service.dart';
import 'package:moya/presentation/screens/E&M/widgets/meditation_detail_screen.dart';


class PopularMeditationsList extends StatelessWidget {
  const PopularMeditationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: StreamBuilder<List<MeditationModel>>(
        stream: MeditationService.getMeditationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 240,
              child: Center(child: CircularProgressIndicator(color: Colors.teal)),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox(
              height: 240,
              child: Center(
                child: Text("Henüz meditasyon bulunamadı.", 
                  style: TextStyle(color: Colors.black54
                  )),
              ),
            );
          }

          final meditations = snapshot.data!;

          return SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: meditations.length,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemBuilder: (context, index) {
                final item = meditations[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeditationDetailScreen(meditation: item),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SizedBox(
                              height: 144,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    item.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => 
                                      Container(color: Colors.grey[900], child: const Icon(Icons.broken_image, color: Colors.white24)),
                                  ),
                                  _buildGradientOverlay(),
                                  _buildDurationBadge(item.duration),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(item.title, 
                            style: theme.textTheme.titleMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text("${item.category} • ${item.duration}", 
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
        ),
      ),
    );
  }

  Widget _buildDurationBadge(String duration) {
    return Positioned(
      bottom: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(duration, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ),
    );
  }
}