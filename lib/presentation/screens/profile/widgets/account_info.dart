import 'package:flutter/material.dart';

class AccountInfoCard extends StatelessWidget {
  // ProfileScreen'den gelen merkezi veri paketini (Map) alıyoruz
  final Map<String, dynamic> userData;

  const AccountInfoCard({
    super.key, 
    required this.userData, required String email, required String birthday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Odak alanları listesini (List<String>) aralarına virgül koyarak metne dönüştürüyoruz
    final String focusAreasText = (userData['focusAreas'] as List<String>?)?.join(', ') ?? 'Seçilmedi';

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
              // Ad Soyad ve Kullanıcı Bilgileri
              _buildInfoTile(theme, Icons.badge_outlined, 'Ad Soyad', userData['name']),
              _buildInfoTile(theme, Icons.person_outline, 'Kullanıcı Adı', userData['username']),
              _buildInfoTile(theme, Icons.mail_outline, 'E-posta', userData['email']),
              
              // İletişim ve Kişisel Detaylar
              _buildInfoTile(theme, Icons.phone_outlined, 'Telefon', userData['phone']),
              _buildInfoTile(theme, Icons.wc_outlined, 'Cinsiyet', userData['gender'] ?? 'Belirtilmedi'),
              _buildInfoTile(theme, Icons.cake_outlined, 'Doğum Tarihi', userData['bday']),
              
              // Tıklanabilir alanlardan gelen Odak Alanları özeti
              _buildInfoTile(theme, Icons.track_changes_outlined, 'Odak Alanları', focusAreasText),
            ],
          ),
        ),
      ],
    );
  }

  // Her bir satırı oluşturan yardımcı Widget (Reusable Widget)
  Widget _buildInfoTile(ThemeData theme, IconData icon, String title, String? subtitle) {
    return ListTile(
      leading: CircleAvatar(
        // Tema renklerini kullanarak şeffaf bir arka plan oluşturur
        backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
        child: Icon(icon, color: theme.primaryColor, size: 20),
      ),
      title: Text(title, style: theme.textTheme.labelSmall),
      subtitle: Text(
        subtitle ?? 'Girilmedi', // Veri boşsa varsayılan metin gösterir
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, size: 16),
      onTap: () {
        // İleride her bir satır için ayrı düzenleme sayfaları açmak istersen burayı kullanabilirsin
      },
    );
  }
}