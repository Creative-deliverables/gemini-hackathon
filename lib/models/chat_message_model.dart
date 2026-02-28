/// AI 채팅 메시지 타입
enum MessageType { text, image }

/// AI 채팅 메시지 모델
class ChatMessage {
  ChatMessage({
    required this.role,
    required this.content,
    this.type = MessageType.text,
    this.base64Image,
    this.imagePrompt,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final String role; // 'user' or 'assistant'
  final String content;
  final MessageType type;
  final String? base64Image;
  final String? imagePrompt;
  final DateTime timestamp;
}
