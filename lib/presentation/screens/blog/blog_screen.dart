import 'package:flutter/material.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    final theme = Theme.of(context);

    return Scaffold(
      
      backgroundColor: theme.scaffoldBackgroundColor,
      
      body: Center(
        child: Text(
          "Blog Sayfası",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            
          ),
        ),
      ),
    );
  }
}