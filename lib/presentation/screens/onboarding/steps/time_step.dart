import 'package:flutter/material.dart';

class TimeStep extends StatefulWidget {
  final Function(String) onSelect;
  final VoidCallback onBack;

  const TimeStep({super.key, required this.onSelect, required this.onBack});

  @override
  State<TimeStep> createState() => _TimeStepState();
}

class _TimeStepState extends State<TimeStep> {
  String? _selected;
  final List<String> _times = ["5-10 Dakika", "15-20 Dakika", "30+ Dakika"];

  @override
  Widget build(BuildContext context) {
    // Tüm renk ve stil bilgilerini temadan alıyoruz
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ÜST BİLGİ VE TEMAYA BAĞLI ÇİZGİ
              _buildHeader("3", 5, theme), 
              
              const SizedBox(height: 40),
              
              Text(
                "Günlük ne kadar vakit\nayırabilirsin?",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // SEÇENEK KARTLARI
              ..._times.map((t) => _buildTimeCard(t, theme)),
              
              const Spacer(),
              
              // TAM YUVARLAK BUTONLAR
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
                    onTap: _selected != null ? () => widget.onSelect(_selected!) : null,
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

  // HEADER (Adım ve İlerleme Çubuğu)
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
                color: theme.colorScheme.primary, // Temadaki ana renk
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

  // SEÇENEK KARTI
  Widget _buildTimeCard(String time, ThemeData theme) {
    bool isSelected = _selected == time;
    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: () => setState(() => _selected = time),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected 
              ? primaryColor.withOpacity(0.08) 
              : theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(
              time,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: primaryColor),
          ],
        ),
      ),
    );
  }

  // YUVARLAK NAVİGASYON BUTONU
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