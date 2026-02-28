import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gemini_hackathon/app/app.dart';

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
