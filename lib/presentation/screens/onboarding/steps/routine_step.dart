import 'package:flutter/material.dart';

class RoutineStep extends StatefulWidget {
  final Function(List<String>) onSelect;
  final VoidCallback onBack;

  const RoutineStep({
    super.key,
    required this.onSelect,
    required this.onBack,
  });

  @override
  State<RoutineStep> createState() => _RoutineStepState();
}

class _RoutineStepState extends State<RoutineStep> {
  final List<String> _tempSelectedRoutines = [];

  final List<Map<String, dynamic>> _routines = [
    {"id": "morning", "title": "Sabah meditasyonu", "sub": "Güne huzurla başla", "icon": Icons.self_improvement},
    {"id": "breath", "title": "Nefes egzersizi", "sub": "Stresi anında azalt", "icon": Icons.air},
    {"id": "intention", "title": "Günlük niyet", "sub": "Her güne bir niyet belirle", "icon": Icons.notes},
    {"id": "gratitude", "title": "Şükran günlüğü", "sub": "Güzel anlara odaklan", "icon": Icons.favorite},
    {"id": "walk", "title": "Kısa yürüyüş", "sub": "Bedeni ve zihni canlandır", "icon": Icons.directions_walk},
    {"id": "night", "title": "Gece rutini", "sub": "Huzurlu bir uyku hazırlığı", "icon": Icons.dark_mode},
    {"id": "water", "title": "Su içme hatırlatıcısı", "sub": "Kendine iyi bak", "icon": Icons.opacity},
    {"id": "review", "title": "Günü değerlendir", "sub": "Akşam yansıma pratiği", "icon": Icons.auto_stories},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // İlerleme kısıtlaması kontrolü
    bool canProceed = _tempSelectedRoutines.length >= 3;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, "4"),
              const SizedBox(height: 40),
              
              Text(
                "Günlük rutinine ne\neklemek istersin?",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              
              // Dinamik Bilgilendirme Metni
              Text(
                canProceed 
                  ? "Harika! Devam edebilirsin." 
                  : "Lütfen en az 3 görev seç (Şu an: ${_tempSelectedRoutines.length}/3)",
                style: TextStyle(
                  color: canProceed 
                      ? theme.colorScheme.primary 
                      : theme.colorScheme.onSurface.withOpacity(0.5),
                  fontWeight: canProceed ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              Expanded(
                child: ListView.builder(
                  itemCount: _routines.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final routine = _routines[index];
                    bool isSelected = _tempSelectedRoutines.contains(routine['id']);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _tempSelectedRoutines.remove(routine['id']);
                          } else {
                            _tempSelectedRoutines.add(routine['id']);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? theme.colorScheme.primary.withOpacity(0.08)
                              : theme.colorScheme.surfaceVariant.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? theme.colorScheme.primary.withOpacity(0.1)
                                    : theme.colorScheme.onSurface.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                routine['icon'],
                                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.4),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    routine['title'],
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    routine['sub'],
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.1),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Alt Butonlar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Geri Butonu (Yuvarlak)
                  _buildCircleButton(
                    onTap: widget.onBack,
                    icon: Icons.arrow_back,
                    theme: theme,
                    isPrimary: false,
                  ),
                  
                  // İleri Butonu (Yuvarlak & Kısıtlamalı)
                  _buildCircleButton(
                    onTap: canProceed ? () => widget.onSelect(_tempSelectedRoutines) : null,
                    icon: Icons.arrow_forward,
                    theme: theme,
                    isPrimary: true,
                    isEnabled: canProceed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Yuvarlak Buton Yardımcı Widget'ı
  Widget _buildCircleButton({
    required VoidCallback? onTap,
    required IconData icon,
    required ThemeData theme,
    required bool isPrimary,
    bool isEnabled = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPrimary 
              ? (isEnabled ? theme.colorScheme.primary : Colors.grey.withOpacity(0.3))
              : Colors.transparent,
          border: isPrimary 
              ? null 
              : Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
          boxShadow: isPrimary && isEnabled ? [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ] : null,
        ),
        child: Icon(
          icon, 
          color: isPrimary 
              ? (isEnabled ? theme.colorScheme.onPrimary : Colors.white)
              : theme.colorScheme.onSurface,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String stepIndex) {
    final theme = Theme.of(context);
    final double progress = int.parse(stepIndex) / 5;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$stepIndex. ADIM / 5",
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1.1,
              ),
            ),
            const Text(
              "MOYA",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 4,
              width: (MediaQuery.of(context).size.width - 48) * progress,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}