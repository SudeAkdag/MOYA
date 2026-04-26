import 'package:flutter/material.dart';

class ExperienceStep extends StatefulWidget {
  final Function(String) onSelect;
  final VoidCallback onBack;

  const ExperienceStep({super.key, required this.onSelect, required this.onBack});

  @override
  State<ExperienceStep> createState() => _ExperienceStepState();
}

class _ExperienceStepState extends State<ExperienceStep> {
  String? _selectedId;

  final List<Map<String, String>> _options = [
    {"id": "none", "title": "Hiç Denemedim", "sub": "Sıfırdan başlamak için harika bir yerdesin."},
    {"id": "some", "title": "Biraz Bilgim Var", "sub": "Temel kavramları biliyorum, derinleşmek istiyorum."},
    {"id": "pro", "title": "Düzenli Uyguluyorum", "sub": "Zaten bir pratiğim var, yeni teknikler arıyorum."},
  ];

  @override
  Widget build(BuildContext context) {
    // Tüm renkleri buradan çekiyoruz
    final theme = Theme.of(context);
  

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. ÜST BİLGİ VE İLERLEME ÇİZGİSİ (2/5 = %40)
              _buildHeader("2", 5, theme),
              
              const SizedBox(height: 32),
              
              Text(
                "Daha önce meditasyon veya\nnefes egzersizi\ndeneyiminin oldu mu?",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Sana en uygun olanı seçebilirsin",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // 2. SEÇENEK LİSTESİ
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: _options.map((opt) => _buildOptionCard(opt, theme)).toList(),
                ),
              ),
              
              // 3. YUVARLAK NAVİGASYON BUTONLARI
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRoundButton(
                    icon: Icons.arrow_back,
                    onTap: widget.onBack,
                    theme: theme,
                    isPrimary: false,
                  ),
                  _buildRoundButton(
                    icon: Icons.arrow_forward,
                    onTap: _selectedId != null ? () => widget.onSelect(_selectedId!) : null,
                    theme: theme,
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TEMAYA DUYARLI BİLEŞENLER ---

  Widget _buildHeader(String currentStep, int totalSteps, ThemeData theme) {
    double progressValue = int.parse(currentStep) / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$currentStep. ADIM / $totalSteps",
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            Text(
              "MOYA",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: 6,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard(Map<String, String> opt, ThemeData theme) {
    bool isSelected = _selectedId == opt['id'];
    
    return GestureDetector(
      onTap: () => setState(() => _selectedId = opt['id']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // Seçiliyse primary rengin çok açık bir tonu, değilse yüzey rengi
          color: isSelected 
              ? theme.colorScheme.primary.withOpacity(0.08) 
              : theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent, 
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opt['title']!, 
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    opt['sub']!, 
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off, 
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundButton({
    required IconData icon,
    required VoidCallback? onTap,
    required ThemeData theme,
    required bool isPrimary,
  }) {
    bool isDisabled = onTap == null;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // İleri butonu ise primary rengi, geri butonu ise şeffaf
          color: isPrimary 
              ? (isDisabled ? theme.disabledColor.withOpacity(0.3) : theme.colorScheme.primary)
              : Colors.transparent,
          border: isPrimary 
              ? null 
              : Border.all(color: theme.colorScheme.onSurface.withOpacity(0.15), width: 1.5),
        ),
        child: Icon(
          icon,
          color: isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
          size: 28,
        ),
      ),
    );
  }
}