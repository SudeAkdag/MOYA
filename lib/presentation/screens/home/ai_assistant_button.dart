import 'package:flutter/material.dart';
import 'package:moya/presentation/screens/chatbot/chatbot_screen.dart';

class AiAssistantButton extends StatefulWidget {
  const AiAssistantButton({super.key});

  @override
  State<AiAssistantButton> createState() => _AiAssistantButtonState();
}

class _AiAssistantButtonState extends State<AiAssistantButton> with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      bottom: 120,
      right: 24,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotScreen()),
          );
        },
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            final glowValue = 0.4 + (_glowController.value * 0.2);
            final glowRadius = 30 + (_glowController.value * 15);
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withAlpha((glowValue * 255).toInt()),
                    blurRadius: glowRadius,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              border: Border.all(color: theme.colorScheme.onPrimary.withAlpha(102), width: 2),
            ),
            child: Icon(Icons.smart_toy_outlined, color: theme.colorScheme.onPrimary, size: 32),
          ),
        ),
      ),
    );
  }
}