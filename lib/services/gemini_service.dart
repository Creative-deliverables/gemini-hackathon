import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

/// AI 응답 결과 (텍스트 또는 이미지)
class ChatResponse {
  ChatResponse.text(this.text)
    : type = 'text',
      base64Image = null,
      imagePrompt = null;

  ChatResponse.image({
    required this.text,
    required this.base64Image,
    required this.imagePrompt,
  }) : type = 'image';

  final String type;
  final String text;
  final String? base64Image;
  final String? imagePrompt;
}

class GeminiService {
  GeminiService._();
  static final instance = GeminiService._();

  /// 메인 생성 모델 (고성능)
  GenerativeModel get _proModel =>
      FirebaseAI.googleAI().generativeModel(model: 'gemini-3.1-pro-preview');

  /// 빠른 응답 모델 (채팅용)
  GenerativeModel get _flashModel =>
      FirebaseAI.googleAI().generativeModel(model: 'gemini-3-flash-preview');

  /// 이미지 생성 모델 (Imagen)
  ImagenModel get _imagenModel =>
      FirebaseAI.googleAI().imagenModel(model: 'imagen-3.0-generate-002');

  /// [IMAGE_PROMPT: ...] 태그 감지 정규식
  static final _imageTagRegex = RegExp(
    r'\[(?:IMAGE_PROMPT|Generated Image Prompt):\s*([\s\S]*?)\]',
    caseSensitive: false,
  );

  /// AI 채팅 시스템 프롬프트 (Next.js /api/ai-chat에서 포팅)
  String _buildChatSystemPrompt(String editorContent) {
    return '''당신은 사용자의 원고 작성을 돕는 친절하고 전문적인 AI 어시스턴트입니다.
현재 사용자가 에디터에 작성 중인 내용(Context)은 다음과 같습니다:
---
${editorContent.isNotEmpty ? editorContent : "(아직 작성된 내용이 없습니다)"}
---

[역할 및 규칙]
1. 사용자가 글쓰기 조언, 분석, 피드백을 요구하면 작성된 내용을 바탕으로 전문적인 지침과 개선점을 제공하세요. 답변은 한국어로 자연스럽게 작성하세요.
2. 사용자가 **이미지를 생성해 달라고 하거나 그려달라고 요청하거나 기존 이미지를 수정해달라고 요청하는 경우**(예: "슈나우저 그려줘", "이걸 기반으로 사진 만들어줘", "좀 더 어둡게 바꿔줘"), **다른 설명을 일절 덧붙이지 말고 오직 아래의 태그 포맷 하나만 반환**해야 합니다. 태그 내부에는 이미지 생성용 모델에 전달될 **구체적이고 상세한 영어 프롬프트**를 작성해야 합니다.
   반드시 지켜야 할 출력 형식: [IMAGE_PROMPT: A highly detailed...]
   (주의: "알겠습니다", "그려드릴게요", "여기에 있습니다" 등 어떠한 다른 텍스트도 절대 포함하지 마세요, 오직 태그만 보내세요)
''';
  }

  /// 8단계 판매페이지 프롬프트 (Next.js gemini.ts에서 포팅)
  String _buildSalesPagePrompt({
    required String platformInfo,
    required String toneInfo,
  }) {
    return '''
당신은 베스트셀러 도서 전문 편집자이자, 특급 카피라이터입니다.
다음 제공되는 원고의 내용을 심층 분석하여, 두 가지 작업을 연속적으로 수행한 결과물의 최종 HTML을 반환하세요.

[요구사항]
첫째, 작성자가 쓴 이 날것의 원고를 바탕으로 하여, 출판용 책(도서)으로서 어떤 가치가 있고 어떤 내용(목차)으로 구성되는지 '책 형식의 기획안' 관점에서 먼저 요약하고 정리하세요. (이 과정은 내부적으로만 수행)
둘째, 정리된 '책 형식의 기획'을 기반으로, 독자의 구매 전환을 이끌어낼 수 있는 '8단계 판매페이지 공식'에 맞춘 카피를 최종 생성하세요.
셋째, 단조로운 텍스트만 있지 않도록, 실제 상품 판매 페이지처럼 적절한 문단 사이사이에 가상 이미지 플레이스홀더를 3~4개 이상 필수적으로 삽입하세요.

[플랫폼 정보]
$platformInfo

[문체 지시]
다음 문체로 작성하세요: $toneInfo

[이미지 플레이스홀더 규칙]
다음 HTML 태그 형식을 사용하여 이미지를 레이아웃에 포함시키세요:
<figure class="my-8 text-center"><img src="https://placehold.co/800x500/f3f4f6/a8a29e?text=Book+Mockup" alt="책 샘플 이미지" class="w-full rounded-lg shadow-md mx-auto" /><figcaption class="text-sm text-gray-500 mt-2">※ 편집된 책의 본문 샘플 이미지</figcaption></figure>
(placehold.co의 뒷부분 text 쿼리를 내용에 맞게 Book+Mockup, Best+Seller, Target+Audience 등으로 유연하게 바꾸어 사용하세요.)

[8단계 판매페이지 공식]
1. 후킹 헤드라인: 타겟 독자의 시선을 사로잡는 강력한 헤드라인과 한 줄 부제 (이때 첫 번째 이미지를 헤더 아래에 배치)
2. 타겟 공감대 형성: 독자가 겪고 있는 문제점(Pain Point)을 짚어내며 공감 유도
3. 창작자 신뢰 구축: 왜 이 책과 작가를 믿고 구매해야 하는지에 대한 권위와 스토리
4. 가치 제안: 이 책을 읽고 나면 독자가 얻게 될 명확한 이득과 변화 (이쯤에 추가 이미지 배치)
5. 도서 상세 소개 (미리보기): 책이 어떻게 편집되었는지 서식 기반으로 목차나 하이라이트 부분 상세 소개 (책 내부 요소 이미지 배치)
6. 사회적 증거 (옵션): 예상 독자 리뷰나 추천사 (가상의 긍정적 페르소나 활용)
7. 가격 및 보장: 책이 제공하는 혜택에 비해 이 투자가 왜 가치있는지 설명
8. CTA (Call To Action): 당장 구매해야 하는 긴급성과 행동 촉구

[출력 형식 제한]
결과물은 HTML 태그 (<h2>, <p>, <ul>, <li>, <strong>, <img>, <figure> 등)로만 이루어져야 하며,
마크다운 코드 블록으로 절대 감싸지 말고, 순수 HTML 문자열만 반환해주세요.
''';
  }

  /// 직접 작성 원고용 생성 (텍스트 → Gemini)
  Future<String> generateFromText({
    required String text,
    String platform = '',
    String tone = '전문적인',
  }) async {
    try {
      final prompt = _buildSalesPagePrompt(
        platformInfo: platform.isNotEmpty ? platform : '일반 온라인 서점',
        toneInfo: tone,
      );

      final response = await _proModel.generateContent([
        Content.multi([TextPart(prompt), TextPart('\n\n[입력 원고]\n$text')]),
      ]);

      return response.text ?? '';
    } catch (e) {
      debugPrint('GeminiService.generateFromText error: $e');
      throw Exception('판매페이지 카피 생성에 실패했습니다: $e');
    }
  }

  /// PDF 업로드용 생성 (PDF bytes → Gemini 직접 전송, 파싱 불필요)
  Future<String> generateFromPdf({
    required Uint8List pdfBytes,
    String platform = '',
    String tone = '전문적인',
  }) async {
    try {
      final prompt = _buildSalesPagePrompt(
        platformInfo: platform.isNotEmpty ? platform : '일반 온라인 서점',
        toneInfo: tone,
      );

      final response = await _proModel.generateContent([
        Content.multi([
          TextPart(prompt),
          TextPart('\n\n[입력 원고] 아래 첨부된 PDF 파일의 내용을 분석하세요.'),
          InlineDataPart('application/pdf', pdfBytes),
        ]),
      ]);

      return response.text ?? '';
    } catch (e) {
      debugPrint('GeminiService.generateFromPdf error: $e');
      throw Exception('PDF 기반 판매페이지 생성에 실패했습니다: $e');
    }
  }

  /// AI 채팅 (에디터 컨텍스트 주입 + IMAGE_PROMPT 자동 감지)
  Future<ChatResponse> chatWithContext({
    required List<Content> history,
    required String userMessage,
    String editorContent = '',
  }) async {
    try {
      // 시스템 프롬프트를 history 맨 앞에 주입
      final systemHistory = <Content>[
        Content('user', [TextPart(_buildChatSystemPrompt(editorContent))]),
        Content('model', [
          TextPart('시스템 지침을 확인했으며, 사용자의 글쓰기를 돕고 필요한 경우 이미지 생성 태그를 반환하겠습니다.'),
        ]),
        ...history,
      ];

      final chat = _flashModel.startChat(history: systemHistory);
      final response = await chat.sendMessage(Content.text(userMessage));
      final aiText = response.text ?? '';

      // [IMAGE_PROMPT: ...] 태그 감지
      final match = _imageTagRegex.firstMatch(aiText);
      if (match != null && match.group(1) != null) {
        final imagePrompt = match.group(1)!.trim();
        try {
          final base64 = await generateImage(imagePrompt);
          return ChatResponse.image(
            text:
                '이미지를 성공적으로 생성했어요!\n\n마음에 들지 않거나 추가하고 싶은 부분이 있다면, "더 ㅇㅇ하게 해줘"처럼 계속 말씀해주세요.',
            base64Image: base64,
            imagePrompt: imagePrompt,
          );
        } catch (e) {
          debugPrint('Image generation failed: $e');
          return ChatResponse.text('이미지 생성에 실패했습니다: $e');
        }
      }

      return ChatResponse.text(aiText);
    } catch (e) {
      debugPrint('GeminiService.chatWithContext error: $e');
      throw Exception('AI 채팅 응답 생성에 실패했습니다: $e');
    }
  }

  /// Imagen을 통한 이미지 생성
  Future<String> generateImage(String prompt) async {
    try {
      final response = await _imagenModel.generateImages(prompt);

      if (response.images.isEmpty) {
        throw Exception('이미지 데이터가 생성되지 않았습니다.');
      }

      final imageBytes = response.images.first.bytesBase64Encoded;
      return 'data:image/png;base64,${base64Encode(imageBytes)}';
    } catch (e) {
      debugPrint('GeminiService.generateImage error: $e');
      throw Exception('AI 이미지 생성 중 문제가 발생했습니다: $e');
    }
  }

  /// 단순 AI 채팅용 (시스템 프롬프트 없이, Flash 모델)
  Future<String> chat({
    required List<Content> history,
    required String userMessage,
  }) async {
    try {
      final chat = _flashModel.startChat(history: history);
      final response = await chat.sendMessage(Content.text(userMessage));
      return response.text ?? '';
    } catch (e) {
      debugPrint('GeminiService.chat error: $e');
      throw Exception('AI 채팅 응답 생성에 실패했습니다: $e');
    }
  }
}
