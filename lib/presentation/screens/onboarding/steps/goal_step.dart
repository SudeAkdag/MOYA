import 'package:flutter/material.dart';

class GoalStep extends StatefulWidget {
  final Function(List<String>) onSelect;
  final VoidCallback onBack;

  const GoalStep({super.key, required this.onSelect, required this.onBack});

  @override
  State<GoalStep> createState() => _GoalStepState();
}

class _GoalStepState extends State<GoalStep> {
  final List<String> _selectedGoals = [];

  final List<Map<String, dynamic>> _goals = [
    {"id": "stress", "icon": Icons.air, "title": "Stres & Kaygı", "sub": "Zihnini sakinleştir"},
    {"id": "focus", "icon": Icons.center_focus_strong, "title": "Odaklanma", "sub": "Dikkatini güçlendir"},
    {"id": "sleep", "icon": Icons.nightlight_round, "title": "Uyku Kalitesi", "sub": "Derin ve huzurlu uyu"},
    {"id": "motivation", "icon": Icons.bolt, "title": "Motivasyon", "sub": "Enerjini yükselt"},
    {"id": "peace", "icon": Icons.self_improvement, "title": "Genel Huzur", "sub": "İç dengeyi bul"},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. ADIM VE İLERLEME ÇİZGİSİ (%20)
              _buildHeader("1", 5, theme),
              
              const SizedBox(height: 32),
              
              Text(
                "Seni MOYA'ya getiren\ntemel sebepler neler?",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Birden fazla seçebilirsin",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              
              const SizedBox(height: 32),
              
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _goals.length,
                  itemBuilder: (context, index) {
                    final goal = _goals[index];
                    bool isSelected = _selectedGoals.contains(goal['id']);
                    return _buildOptionCard(goal, isSelected, theme);
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // YUVARLAK NAVİGASYON BUTONLARI
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
                    onTap: _selectedGoals.isNotEmpty ? () => widget.onSelect(_selectedGoals) : null,
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

  // --- ÖZEL BİLEŞENLER ---

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
        // İlerleme Çizgisi
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

  Widget _buildOptionCard(Map<String, dynamic> goal, bool isSelected, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedGoals.remove(goal['id']);
          } else {
            _selectedGoals.add(goal['id']);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                goal['icon'],
                color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal['title'],
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    goal['sub'],
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: theme.colorScheme.primary),
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