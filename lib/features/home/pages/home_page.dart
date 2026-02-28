import 'package:flutter/material.dart';
import '../widgets/chat_panel.dart';
import '../widgets/preview_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _generatedHtml;

  void _handleHtmlGenerated(String html) {
    setState(() {
      _generatedHtml = html;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Panel: AI Chat Interface (approx 40% width)
          Expanded(
            flex: 4,
            child: ChatPanel(onHtmlGenerated: _handleHtmlGenerated),
          ),

          // Divider
          const VerticalDivider(width: 1),

          // Right Panel: Manuscript Preview & Output (approx 60% width)
          Expanded(flex: 6, child: PreviewPanel(htmlContent: _generatedHtml)),
        ],
      ),
    );
  }
}
