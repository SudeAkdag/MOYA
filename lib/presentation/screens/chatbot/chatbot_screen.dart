import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../data/services/azure_openai_service.dart';
import '../../../core/theme/app_theme.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final AzureOpenAIService _azureService = AzureOpenAIService();

  final List<AiChatMessage> _messages = [];

  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();

    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(
        AiChatMessage(
          role: 'user',
          content: text,
        ),
      );
      _controller.clear();
      _isLoading = true;
    });

    try {
      final answer = await _azureService.sendMessage(
        messages: _messages,
      );

      setState(() {
        _messages.add(
          AiChatMessage(
            role: 'assistant',
            content: answer,
          ),
        );
      });
    } catch (error) {
      setState(() {
        _messages.add(
          AiChatMessage(
            role: 'assistant',
            content: 'Bağlantı hatası oluştu:\n$error',
          ),
        );
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Arka plan rengini temadan alıyoruz
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 448),
          child: _ChatView(
            messages: _messages,
            controller: _controller,
            isLoading: _isLoading,
            onSend: _sendMessage,
          ),
        ),
      ),
    );
  }
}

class _ChatView extends StatelessWidget {
  final List<AiChatMessage> messages;
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  const _ChatView({
    required this.messages,
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Stack(
      children: [
        // Dinamik Tema Renkleriyle Arka Plan Parlamaları (Orbs)
        Positioned(
          top: -100,
          left: -100,
          child: _BackgroundOrb(
            color: primaryColor.withOpacity(0.15),
            size: 500,
          ),
        ),
        Positioned(
          bottom: -150,
          right: -150,
          child: _BackgroundOrb(
            // İkinci parlamayı primary color'ın biraz daha şeffaf hali yapıyoruz
            color: primaryColor.withOpacity(0.1),
            size: 400,
            animationDelay: -4,
          ),
        ),
        Column(
          children: [
            const _ChatHeader(),
            Expanded(
              child: messages.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 130),
                      children: const [
                        _Timestamp(text: 'Bugün'),
                        SizedBox(height: 24),
                        _AiMessageGroup(
                          text:
                              'Merhaba, ben MOYA rehberin. Beslenme, spor, motivasyon, uyku ve günlük wellness rutinin için bana yazabilirsin. 💙',
                          showSuggestions: true,
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 130),
                      itemCount: messages.length + (isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length && isLoading) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: _AiTypingBubble(),
                          );
                        }

                        final message = messages[index];
                        final isUser = message.role == 'user';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: isUser
                              ? _UserMessage(text: message.content)
                              : _AiMessageGroup(
                                  text: message.content,
                                  showSuggestions: false,
                                ),
                        );
                      },
                    ),
            ),
          ],
        ),
        _MessageInput(
          controller: controller,
          isLoading: isLoading,
          onSend: onSend,
        ),
      ],
    );
  }
}

class _GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Color? customBackgroundColor;
  final Color? customBorderColor;

  const _GlassContainer({
    required this.child,
    this.padding = const EdgeInsets.all(0),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.customBackgroundColor,
    this.customBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    // Temadaki surface (kart) rengini glass efekti için şeffaflaştırıyoruz
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    
    final bgColor = customBackgroundColor ?? surfaceColor.withOpacity(0.85);
    final borderColor = customBorderColor ?? onSurfaceColor.withOpacity(0.08);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader();

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return _GlassContainer(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              'MOYA Rehberin',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(width: 48), // Dengelemek için
        ],
      ),
    );
  }
}

class _Timestamp extends StatelessWidget {
  final String text;

  const _Timestamp({required this.text});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: textColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class _UserMessage extends StatelessWidget {
  final String text;

  const _UserMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Mesaj balonu primary color, içindeki metin ise kontrast sağlaması için ayarlandı
    final textColor = isDark ? theme.scaffoldBackgroundColor : Colors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _AiMessageGroup extends StatelessWidget {
  final String text;
  final bool showSuggestions;

  const _AiMessageGroup({
    required this.text,
    this.showSuggestions = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const _AiAvatar(),
            const SizedBox(width: 12),
            Flexible(
              child: _GlassContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (showSuggestions) ...[
          const SizedBox(height: 16),
          const _SuggestionCards(), // Bu kısım 2. aşamada dinamik olacak
        ],
      ],
    );
  }
}

class _AiTypingBubble extends StatelessWidget {
  const _AiTypingBubble();

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const _AiAvatar(),
        const SizedBox(width: 12),
        Flexible(
          child: _GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Text(
              'MOYA düşünüyor...',
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 14,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AiAvatar extends StatelessWidget {
  const _AiAvatar();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primaryColor.withOpacity(0.2),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.15),
            blurRadius: 20,
          ),
        ],
      ),
      child: Icon(
        Icons.auto_awesome,
        color: primaryColor,
        size: 22,
      ),
    );
  }
}

class _SuggestionCards extends StatelessWidget {
  const _SuggestionCards();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 52),
      clipBehavior: Clip.none,
      child: Row(
        children: const [
          _SuggestionCard(
            title: '3 Dakikalık Nefes Molası',
            category: 'Egzersiz',
            icon: Icons.air,
          ),
          SizedBox(width: 12),
          _SuggestionCard(
            title: 'Sakinleştirici Rutin',
            category: 'Wellness',
            icon: Icons.spa,
          ),
          SizedBox(width: 12),
          _SuggestionCard(
            title: 'Kaygı Azaltma Notları',
            category: 'Blog',
            icon: Icons.article,
          ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final String title;
  final String category;
  final IconData icon;

  const _SuggestionCard({
    required this.title,
    required this.category,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return SizedBox(
      width: 230,
      child: _GlassContainer(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _GlassContainer(
              padding: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(12),
              customBackgroundColor: primaryColor.withOpacity(0.18),
              customBorderColor: primaryColor.withOpacity(0.25),
              child: Icon(icon, color: primaryColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: TextStyle(
                      color: textColor.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  const _MessageInput({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final primaryColor = theme.primaryColor;
    final textColor = theme.colorScheme.onSurface;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16).copyWith(bottom: 24),
        decoration: BoxDecoration(
          // Mesaj yazma alanının arkasındaki yumuşak gradient geçişi
          gradient: LinearGradient(
            colors: [
              bgColor,
              bgColor.withOpacity(0),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: _GlassContainer(
          borderRadius: BorderRadius.circular(32),
          padding: const EdgeInsets.only(left: 20, right: 6),
          // Input alanını hafif primary renkle renklendiriyoruz
          customBackgroundColor: primaryColor.withOpacity(0.1),
          customBorderColor: primaryColor.withOpacity(0.2),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !isLoading,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: "MOYA'ya bir şeyler yaz...",
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => onSend(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.mic, color: textColor.withOpacity(0.5)),
                onPressed: () {},
              ),
              const SizedBox(width: 4),
              ElevatedButton(
                onPressed: isLoading ? null : onSend,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: primaryColor,
                  disabledBackgroundColor: Colors.grey.withOpacity(0.5),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackgroundOrb extends StatefulWidget {
  final Color color;
  final double size;
  final double animationDelay;

  const _BackgroundOrb({
    required this.color,
    required this.size,
    this.animationDelay = 0,
  });

  @override
  State<_BackgroundOrb> createState() => _BackgroundOrbState();
}

class _BackgroundOrbState extends State<_BackgroundOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    Future.delayed(
      Duration(milliseconds: (widget.animationDelay * 1000).toInt().abs()),
      () {
        if (mounted) {
          _controller.repeat(reverse: true);
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value;

        return Transform.translate(
          offset: Offset(0, -20 * (value - 0.5).abs() * 4),
          child: Opacity(
            opacity: 0.3 + (value * 0.2),
            child: child,
          ),
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}