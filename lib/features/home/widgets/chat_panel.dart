import 'package:flutter/material.dart';
import 'package:gemini_hackathon/core/extensions/color.dart';

class ChatPanel extends StatefulWidget {
  final ValueChanged<String>? onHtmlGenerated;

  const ChatPanel({super.key, this.onHtmlGenerated});

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  void _handleSend() {
    // For now, this just simulates receiving an HTML string from Gemini
    // and passing it up to the HomePage.
    // TODO: Connect to actual GeminiService here
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      final mockHtml =
          '''
      <h2>Generated Detail Page</h2>
      <p>This is a <strong>mock</strong> HTML response.</p>
      <ul>
        <li>Point 1 based on: ${_controller.text}</li>
        <li>Point 2</li>
      </ul>
      <figure class="my-8 text-center"><img src="https://placehold.co/800x500/f3f4f6/a8a29e?text=Book+Mockup" alt="책 샘플 이미지" class="w-full rounded-lg shadow-md mx-auto" /><figcaption class="text-sm text-gray-500 mt-2">※ 편집된 책의 본문 샘플 이미지</figcaption></figure>
      ''';

      widget.onHtmlGenerated?.call(mockHtml);

      setState(() {
        _isLoading = false;
        _controller.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.blueAccent),
                const SizedBox(width: 12),
                Text(
                  'AI Detail Page Planner',
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
          ),

          // Chat Messages Area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                _buildAIMessage(
                  context,
                  '안녕하세요! 원고를 분석하여 상세페이지를 생성해 드립니다.\n원고(PDF/이미지)를 오른쪽 패널에 업로드해 주세요.',
                ),
                // Additional messages will appear here
              ],
            ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(top: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                    ),
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  radius: 24,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: _handleSend,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIMessage(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary.withAlphaOpacity(0.1),
            child: Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(text, style: theme.textTheme.bodyLarge),
            ),
          ),
        ],
      ),
    );
  }
}
