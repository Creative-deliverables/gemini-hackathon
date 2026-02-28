import 'package:flutter/material.dart';
import '../widgets/chat_panel.dart';
import '../widgets/preview_panel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Panel: AI Chat Interface (approx 40% width)
          const Expanded(flex: 4, child: ChatPanel()),

          // Divider
          const VerticalDivider(width: 1),

          // Right Panel: Manuscript Preview & Output (approx 60% width)
          const Expanded(flex: 6, child: PreviewPanel()),
        ],
      ),
    );
  }
}
