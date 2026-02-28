import 'package:flutter/material.dart';
import '../../../core/widgets/resize_divider.dart';
import '../widgets/chat_panel.dart';
import '../widgets/preview_panel.dart';

class HomePage extends StatefulWidget {
  final String? initialHtml;

  const HomePage({super.key, this.initialHtml});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String? _generatedHtml = widget.initialHtml;
  double _leftRatio = 0.6; // Default to 60% for Preview Panel
  bool _isDividerHovering = false;

  void _handleHtmlGenerated(String html) {
    setState(() {
      _generatedHtml = html;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;

          return Row(
            children: [
              // Left Panel: Manuscript Preview & Output
              SizedBox(
                width: totalWidth * _leftRatio,
                child: PreviewPanel(htmlContent: _generatedHtml),
              ),

              // Adjustable Divider
              ResizeDivider(
                isHovering: _isDividerHovering,
                onHoverChanged: (hover) =>
                    setState(() => _isDividerHovering = hover),
                onDragUpdate: (delta) {
                  setState(() {
                    _leftRatio += delta / totalWidth;
                    // Clamp ratio between 50% (5:5) and 70% (7:3)
                    _leftRatio = _leftRatio.clamp(0.5, 0.7);
                  });
                },
              ),

              // Right Panel: AI Chat Interface
              Expanded(child: ChatPanel(onHtmlGenerated: _handleHtmlGenerated)),
            ],
          );
        },
      ),
    );
  }
}
