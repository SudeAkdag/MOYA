import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  // 1. Dışarıdan gelecek verileri ve fonksiyonu tanımlıyoruz
  final String name;
  final VoidCallback onEditPressed;

  // 2. Constructor (Yapıcı Metot) içinde bunları zorunlu (required) kılıyoruz
  const ProfileHeader({
    super.key, 
    required this.name, 
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        // 3. Sabit metin yerine dışarıdan gelen 'name' değişkenini kullanıyoruz
        Text(
          name,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        _buildPremiumBadge(theme),
        const SizedBox(height: 20),
        ElevatedButton(
          // 4. Butona basılınca dışarıdan gelen 'onEditPressed' fonksiyonunu çalıştırıyoruz
          onPressed: onEditPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
            foregroundColor: theme.primaryColor,
            elevation: 0,
          ),
          child: const Text('Profili Düzenle'),
        ),
      ],
    );
  }

  Widget _buildPremiumBadge(ThemeData theme) {
    return Row(
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
    );
  }
}