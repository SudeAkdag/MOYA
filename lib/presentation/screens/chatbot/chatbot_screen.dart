import 'dart:ui';
import 'package:flutter/material.dart';

// Note: Colors and styles are derived from the user's HTML mockup.
const Color primaryColor = Color(0xFF135bec);
const Color backgroundDark = Color(0xFF101622);
const Color glassSurface = Color.fromRGBO(30, 41, 59, 0.7);
const Color glassBorder = Color.fromRGBO(255, 255, 255, 0.08);

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f1218),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 448), // max-w-md
          child: const _ChatView(),
        ),
      ),
    );
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Orbs
        Positioned(
          top: -100,
          left: -100,
          child: _BackgroundOrb(color: primaryColor.withOpacity(0.2), size: 500),
        ),
        Positioned(
          bottom: -150,
          right: -150,
          child: _BackgroundOrb(color: Colors.purple.withOpacity(0.1), size: 400, animationDelay: -4),
        ),
        Column(
          children: [
            const _ChatHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                children: const [
                  _Timestamp(text: 'Bugün 14:30'),
                  SizedBox(height: 24),
                  _UserMessage(text: 'Bugün kendimi biraz kaygılı hissediyorum, odaklanamıyorum.'),
                  SizedBox(height: 24),
                  _AiMessageGroup(),
                ],
              ),
            ),
          ],
        ),
        const _MessageInput(),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(width: 48), // To balance the back button
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
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
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
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
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
              )
            ],
          ),
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
        ),
      ],
    );
  }
}

class _AiMessageGroup extends StatelessWidget {
  const _AiMessageGroup();

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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5, fontFamily: 'Inter'),
                    children: [
                      TextSpan(text: 'Seni anlıyorum '),
                      TextSpan(text: '@Can', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                      TextSpan(text: ', biraz mola vermek sana iyi gelebilir. Yoğun dönemlerde bu hisler çok normal. 💙\n\nŞu anki ruh haline göre senin için seçtiklerim:'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _SuggestionCards(),
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
        border: Border.all(color: primaryColor.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.15), blurRadius: 20)],
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuBIrRtltJ6UzmZOJCILa6Aj7fihkQT1NnjDW9YfpxTY1_5wm7f-j7Cver3YV-BChbDNae8a6YWur4A0ko1XTtUYSZqaxYLo_Rc5zKV3XVm1N1WVNursHHPGXIgEDupo7TVRXzZtAVTGpvF2fs-xp9ZFfazC5tPt_JVkLPiZrzBgYw-rhT0xcFvSgidkMkg05dgBrh3XTDGyLcWHnSpmECiEiyMx_GX9y7Km1jnJdhquR7XIwPynppHTSz8EEX6e1mVZOTtqGTzbST8C"),
        ),
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
      padding: const EdgeInsets.only(left: 52), // Align with message bubble
      clipBehavior: Clip.none,
      child: Row(
        children: const [
          _SuggestionCard(
            title: '3 Dakikalık Nefes Molası',
            category: 'Egzersiz',
            icon: Icons.air,
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBglQH6KAX7oUxqrTZhNJPSMFZAUzsMJvUpJrZKZnaCLe5sjwQ6j0C3lt-TIUycyvksqmrrVVtL73XIWQRpsXp5fesrbec0XjkvKV2L4GpDOYBsaOk-OTquAS7Aa_Ci_6peGoXZBrdBStaZ9WMI7XsD4FPVHg-z2vdm_SFN9bSdv-RjX6RPBz7HfcvToYO39mQCTo-DHl2i49LhW7GOAeS5JUC5qbnz9Rc4K2bpsGLylrSuh193DrEttCgY4_XnEr7-W5_YXWK1Yb8X',
          ),
          SizedBox(width: 12),
          _SuggestionCard(
            title: 'Sakinleştirici Piyano',
            category: 'Playlist',
            icon: Icons.music_note,
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBTQkFCLn6lJRJICcQ78ofR9yl_GfXD4MDxJf2f-oSWW-HicL0-sjSgkD3FfQQ9zzGIMor_Pi9sTF3e30AeDbqYiYqrg_e25ugL9kYbU4ohnJlO7BuoIV0HO5uH8IqSfoM55MQbWRBIWRrsOT-hsiRVJ2V1Jd4ytuEYO7kTAPS3W2W2dshXprQu86hwyj-EJwaQ42bSLyncwM9zCKMIj_hPFKYMgIO67Fy7XGrrYbGTdvtqWs6AFUKb4gzpg-ShVhc22dFvZ3Mxmlhe',
          ),
           SizedBox(width: 12),
          _SuggestionCard(
            title: 'Sınav Kaygısı',
            category: 'Blog',
            icon: Icons.article,
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCXaUgH-9QadoVrZk5hMlpVPhN5-JTnvSeB9GsjEg206YkQ8CM21dTb8MgEfqoeb0Rgps8j9f7_07klYmKxTze1S2QVPLdU5MYOyw0fvna4XoIOEBEcLzqcltqxjgNYA3FmCbuumCxTdvr9YIDesH4WQbr6_797WpiVNxQYCRB368gJWFn6tvFF3oxAb3YubpJxxi3KBIFVFas-8uJuMfgJZNAlsBbnmBbH99nMfKC97UMRj14vjpbRr-g4cg2Rw7UU6E9mmiH1ZqQV',
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
  final String imageUrl;

  const _SuggestionCard({
    required this.title,
    required this.category,
    required this.icon,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: _GlassContainer(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container( // Play button overlay
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black.withOpacity(0.2)
                    ),
                    child: const Center(child: Icon(Icons.play_arrow, color: Colors.white, size: 32))),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                _GlassContainer(
                  padding: const EdgeInsets.all(6),
                  borderRadius: BorderRadius.circular(8),
                  child: Icon(icon, color: Colors.grey, size: 20),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16).copyWith(bottom: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundDark, backgroundDark.withOpacity(0)],
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
              const Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "MOYA'ya bir şeyler yaz...",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.mic, color: Colors.white54),
                onPressed: () {},
              ),
              const SizedBox(width: 4),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: primaryColor,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
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

  const _BackgroundOrb({required this.color, required this.size, this.animationDelay = 0});

  @override
  State<_BackgroundOrb> createState() => _BackgroundOrbState();
}

class _BackgroundOrbState extends State<_BackgroundOrb> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    Future.delayed(Duration(milliseconds: (widget.animationDelay * 1000).toInt().abs()), () {
      if(mounted) {
         _controller.repeat(reverse: true);
      }
    });
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
        final value = _controller.value; // 0.0 to 1.0
        return Transform.translate(
          offset: Offset(0, -20 * (value - 0.5).abs() * 4), // Simulates floating
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
