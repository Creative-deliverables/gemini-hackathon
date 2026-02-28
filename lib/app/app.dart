import 'package:flutter/material.dart';
import 'package:gemini_hackathon/config/router.dart';
import 'package:gemini_hackathon/config/theme.dart';

class PageCraftApp extends StatelessWidget {
  const PageCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI PageGen',
      debugShowCheckedModeBanner: false,
      theme: buildDarkTheme(),
      routerConfig: router,
    );
  }
}
