import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

class GeminiService {
  GeminiService._();
  static final instance = GeminiService._();

  /// 메인 생성 모델 (고성능)
  GenerativeModel get _proModel => FirebaseAI.googleAI().generativeModel(
        model: 'gemini-3.1-pro-preview',
      );

  /// 빠른 응답 모델 (채팅용)
  GenerativeModel get _flashModel => FirebaseAI.googleAI().generativeModel(
        model: 'gemini-3-flash-preview',
      );

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
        Content.multi([
          TextPart(prompt),
          TextPart('\n\n[입력 원고]\n$text'),
        ]),
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

  /// AI 채팅용 (Flash 모델)
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
