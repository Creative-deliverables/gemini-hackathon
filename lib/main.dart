import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/router.dart';
import 'config/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.currentPlatform,
        // ↑ flutterfire configure 실행 후 firebase_options.dart 생성되면 주석 해제
        );
  } catch (e) {
    debugPrint('Firebase init failed: $e');
  }
  runApp(const PageCraftApp());
}

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
