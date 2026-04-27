import 'package:flutter/material.dart';

class AccountInfoCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const AccountInfoCard({
    super.key, 
    required this.userData, 
    required String email, 
    required String birthday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // selectedGoals listesini (List<String>) aralarına virgül koyarak metne dönüştürüyoruz
    // Firestore'daki anahtar isminle (selectedGoals) birebir eşleşmeli
    final String selectedGoalsText = (userData['selectedGoals'] != null && (userData['selectedGoals'] as List).isNotEmpty)
        ? List<String>.from(userData['selectedGoals']).join(', ') 
        : 'Hedef belirlenmedi';
    
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
              _buildInfoTile(theme, Icons.badge_outlined, 'Ad Soyad', userData['name']),
              _buildInfoTile(theme, Icons.person_outline, 'Kullanıcı Adı', userData['username']),
              _buildInfoTile(theme, Icons.mail_outline, 'E-posta', userData['email']),
              _buildInfoTile(theme, Icons.phone_outlined, 'Telefon', userData['phone']),
              _buildInfoTile(theme, Icons.wc_outlined, 'Cinsiyet', userData['gender']),
              _buildInfoTile(theme, Icons.cake_outlined, 'Doğum Tarihi', userData['bday']),
              
              // BURASI GÜNCELLENDİ: 'Odak Alanları' artık 'selectedGoals' verisini gösteriyor
              _buildInfoTile(
                theme, 
                Icons.track_changes_outlined, 
                'Odak Alanları', 
                selectedGoalsText
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(ThemeData theme, IconData icon, String title, String? subtitle) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.primaryColor.withOpacity(0.1),
        child: Icon(icon, color: theme.primaryColor, size: 20),
      ),
      title: Text(title, style: theme.textTheme.labelSmall),
      subtitle: Text(
        subtitle ?? 'Girilmedi', 
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, size: 16),
      onTap: () {
        // İleride düzenleme için kullanılabilir
      },
    );
  }
}