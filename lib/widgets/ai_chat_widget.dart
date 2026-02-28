import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/theme.dart';
import '../models/chat_message_model.dart';
import '../services/gemini_service.dart';

class AiChatWidget extends StatefulWidget {
  const AiChatWidget({
    super.key,
    this.editorContent = '',
  });

  /// 현재 에디터에 작성 중인 원고 내용 (시스템 프롬프트에 주입)
  final String editorContent;

  @override
  State<AiChatWidget> createState() => _AiChatWidgetState();
}

class _AiChatWidgetState extends State<AiChatWidget> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      role: 'assistant',
      content:
          'AI 어시스턴트입니다. 작성 중인 글에 대한 조언이 필요하거나 그림(이미지) 추가 작업이 필요하면 편하게 말씀해주세요!',
    ),
  ];
  bool _isLoading = false;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 대화 히스토리를 Gemini Content 형식으로 변환
  List<Content> _buildHistory() {
    return _messages
        .skip(1) // 초기 인사말 제외
        .map((m) {
          // 이미지 메시지는 히스토리에 프롬프트 정보로 변환
          final text = m.type == MessageType.image && m.imagePrompt != null
              ? '(이전에 성공적으로 이미지를 생성했음. 사용된 프롬프트: "${m.imagePrompt}")'
              : m.content;
          return m.role == 'user'
              ? Content('user', [TextPart(text)])
              : Content('model', [TextPart(text)]);
        })
        .toList();
  }

  Future<void> _handleSend() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(role: 'user', content: text));
      _isLoading = true;
    });
    _inputController.clear();
    _scrollToBottom();

    try {
      final history = _buildHistory();
      // 마지막 사용자 메시지는 history에서 제거 (chatWithContext에서 직접 전송)
      if (history.isNotEmpty) history.removeLast();

      final response = await GeminiService.instance.chatWithContext(
        history: history,
        userMessage: text,
        editorContent: widget.editorContent,
      );

      setState(() {
        if (response.type == 'image') {
          _messages.add(ChatMessage(
            role: 'assistant',
            content: response.text,
            type: MessageType.image,
            base64Image: response.base64Image,
            imagePrompt: response.imagePrompt,
          ));
        } else {
          _messages.add(ChatMessage(role: 'assistant', content: response.text));
        }
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          role: 'assistant',
          content: '앗, 오류가 발생했어요. 다시 시도해 주실래요?\n\n(오류: $e)',
        ));
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(left: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildMessageList()),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: const Row(
        children: [
          Icon(Icons.smart_toy, size: 18, color: AppColors.primary),
          SizedBox(width: 8),
          Text(
            'AI 채팅',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return _buildLoadingBubble();
        }
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isUser = msg.role == 'user';
    final isInitMessage = msg == _messages.first;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: isUser ? null : Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser)
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.smart_toy, size: 14, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'AI',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            SelectableText(
              msg.content,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isUser ? Colors.white : AppColors.textPrimary,
              ),
            ),
            // 이미지 프롬프트 표시 (접기/펴기)
            if (msg.type == MessageType.image && msg.imagePrompt != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text(
                    '사용된 프롬프트 보기',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  children: [
                    SelectableText(
                      msg.imagePrompt!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            // 생성된 이미지 표시
            if (msg.type == MessageType.image && msg.base64Image != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(msg.base64Image!.replaceFirst(
                        RegExp(r'data:image/[^;]+;base64,'), '')),
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            // 텍스트 복사 버튼
            if (!isUser && !isInitMessage)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: IconButton(
                    icon: const Icon(Icons.copy, size: 14),
                    color: AppColors.textMuted,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: '텍스트 복사',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: msg.content));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('복사되었습니다.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '생각하는 중...',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              maxLines: 4,
              minLines: 1,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                hintText: 'AI에게 질문이나 요청을 적어주세요...',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _isLoading ? null : _handleSend,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
