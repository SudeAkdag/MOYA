import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../data/services/azure_openai_service.dart';

// Note: Colors and styles are derived from the user's HTML mockup.
const Color primaryColor = Color(0xFF135bec);
const Color backgroundDark = Color(0xFF101622);
const Color glassSurface = Color.fromRGBO(30, 41, 59, 0.7);
const Color glassBorder = Color.fromRGBO(255, 255, 255, 0.08);

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
    return Scaffold(
      backgroundColor: const Color(0xff0f1218),
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
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: _BackgroundOrb(
            color: primaryColor.withOpacity(0.2),
            size: 500,
          ),
        ),
        Positioned(
          bottom: -150,
          right: -150,
          child: _BackgroundOrb(
            color: Colors.purple.withOpacity(0.1),
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
  final Color backgroundColor;
  final Color borderColor;

  const _GlassContainer({
    required this.child,
    this.padding = const EdgeInsets.all(0),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.backgroundColor = glassSurface,
    this.borderColor = glassBorder,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
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
    return _GlassContainer(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Expanded(
            child: Text(
              'MOYA Rehberin',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 48),
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
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
        if (showSuggestions) ...[
          const SizedBox(height: 16),
          const _SuggestionCards(),
        ],
      ],
    );
  }
}

class _AiTypingBubble extends StatelessWidget {
  const _AiTypingBubble();

  @override
  Widget build(BuildContext context) {
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
            child: const Text(
              'MOYA düşünüyor...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
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
      child: const Icon(
        Icons.auto_awesome,
        color: Colors.white,
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
    return SizedBox(
      width: 230,
      child: _GlassContainer(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _GlassContainer(
              padding: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(12),
              backgroundColor: primaryColor.withOpacity(0.18),
              borderColor: primaryColor.withOpacity(0.25),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: const TextStyle(
                      color: Colors.grey,
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16).copyWith(bottom: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backgroundDark,
              backgroundDark.withOpacity(0),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: _GlassContainer(
          borderRadius: BorderRadius.circular(32),
          padding: const EdgeInsets.only(left: 20, right: 6),
          backgroundColor: primaryColor.withOpacity(0.15),
          borderColor: primaryColor.withOpacity(0.2),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !isLoading,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "MOYA'ya bir şeyler yaz...",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => onSend(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.mic, color: Colors.white54),
                onPressed: () {},
              ),
              const SizedBox(width: 4),
              ElevatedButton(
                onPressed: isLoading ? null : onSend,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: primaryColor,
                  disabledBackgroundColor: Colors.grey,
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