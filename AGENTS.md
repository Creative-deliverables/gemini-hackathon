# 🤖 AGENTS.md — AI 에이전트 협업 가이드

> 이 프로젝트에서 AI 코딩 어시스턴트(Claude, Gemini, Cursor 등)를 효과적으로 활용하기 위한 가이드입니다.

---

## 📌 프로젝트 개요 (AI 컨텍스트)

```
프로젝트명: 원고 → 상세페이지 생성기
목적: 작가가 원고(PDF)를 업로드하면 Gemini API가 분석하여 온라인 판매 플랫폼용 상세페이지를 자동 생성
스택: Flutter 3.41.2 + Dart 3.11.0 + Firebase AI Logic (firebase_ai) + Gemini API
배포: Firebase Hosting (flutter build web)
특이사항: PDF를 별도 파싱 없이 Gemini에 bytes로 직접 전송 (InlineDataPart)
```

---

## 📋 프로젝트 진행 규칙 (Project Rules)

1. **SOLID 원칙 준수:** 객체 지향 설계의 핵심 원칙을 지키며 코드 작성
2. **기술 용어는 영어 사용:** 코드, 커밋 메시지, 기술적인 문서는 가급적 영어 사용
3. **기존 코드 수정 최소화:** 구현된 코드는 최대한 보존하고 필요한 부분만 최소한으로 수정
4. **디자인 시스템 준수:** 향후 추가될 Design System 문서의 가이드라인을 철저히 따름 (문서 첨부 예정)

---

## 🏗 아키텍처 개요

```
[사용자] → [파일 업로드 UI] → [file_picker]
                                      ↓
                              [PDF → Uint8List (bytes)]
                                      ↓
                              [Firebase AI Logic 호출]
                              InlineDataPart('application/pdf', bytes)
                                      ↓
                              [Gemini API 직접 분석]
                              (gemini-3.1-pro-preview)
                                      ↓
                              [상세페이지 텍스트 생성]
                                      ↓
                              [미리보기 & 복사 UI]
```

---

## 📂 핵심 파일 & 역할

| 파일 | 역할 | 수정 시 주의사항 |
|------|------|-----------------|
| `lib/services/gemini_service.dart` | Firebase AI Logic 호출 & 프롬프트 | 프롬프트 변경 시 플랫폼별 분기 유지 |
| `lib/main.dart` | 앱 진입점, Firebase 초기화 | `firebase_options.dart` 없으면 실행 불가 |
| `lib/screens/home_screen.dart` | 메인 화면 (업로드 + 결과) | 상태 관리 로직 포함 |
| `lib/widgets/file_upload_widget.dart` | PDF 업로드 UI | 파일 크기(20MB) 검증 포함 |
| `lib/widgets/platform_selector.dart` | 플랫폼 선택 UI | 플랫폼 추가 시 프롬프트도 함께 수정 |
| `lib/models/detail_page_model.dart` | 상세페이지 데이터 모델 | 새 필드 추가 시 여기에 정의 |
| `firebase_options.dart` | Firebase 프로젝트 설정 | `flutterfire configure`로 자동 생성, 수동 수정 금지 |

---

## 🤖 AI 에이전트 사용 규칙

### ✅ DO — 이렇게 요청하세요

**구체적인 파일과 함께 요청:**
```
"lib/services/gemini_service.dart 파일에서 Gemini API를 호출하는 부분을 수정해줘.
현재는 단순 텍스트만 반환하는데, JSON 형식으로 { title, description, targetAudience, benefits } 를 반환하도록 변경해줘."
```

**컨텍스트를 포함한 요청:**
```
"lib/services/gemini_service.dart의 generateDetailPage 메서드를 수정해줘.
현재 크몽 플랫폼용 프롬프트인데, 클래스101 플랫폼에 맞게 커리큘럼 구조를 강조하는 버전도 추가해줘."
```

**에러 메시지와 함께 요청:**
```
"PDF 전송 시 다음 에러가 발생해:
FirebaseException: [firebase_ai] INVALID_ARGUMENT
lib/services/gemini_service.dart 파일을 확인하고 수정해줘."
```

### ❌ DON'T — 이런 요청은 피하세요

```
# 너무 모호한 요청
"상세페이지 생성 기능 만들어줘"

# 범위가 너무 넓은 요청
"전체 앱을 다시 만들어줘"

# 컨텍스트 없는 요청
"이 코드 고쳐줘" (어떤 코드인지 명시 필요)
```

---

## 🔑 Gemini API 사용 가이드

### 모델 선택

| 모델 | 용도 | 비고 |
|------|------|------|
| `gemini-3.1-pro-preview` | **메인 텍스트 분석/생성 (고성능)** | 복잡한 문서 분석 및 고품질 카피라이팅 |
| `gemini-3-flash-preview` | **빠른 텍스트 분석/생성** | 빠른 응답이 필요하거나 단순한 작업 시 사용 |
| `gemini-3.1-flash-image-preview` | **이미지 포함 문서 빠른 분석** | 이미지가 포함된 PDF 등의 빠른 분석용 |
| `gemini-3-pro-image-preview` | **이미지 포함 문서 정밀 분석** | 이미지가 포함된 PDF 등의 고품질 분석용 |

> **패키지 버전 관리 정책:**
> 모든 Flutter 패키지는 항상 최신 버전을 유지하는 것을 원칙으로 하되, 호환성 문제가 발생할 경우에만 다운그레이드하여 해결합니다.

### 프롬프트 작성 원칙

```dart
// lib/services/gemini_service.dart 작성 시 따를 원칙

// 1. 역할 부여 (Role)
const systemPrompt = '당신은 전문 마케팅 카피라이터입니다. '
    '작가의 원고를 분석하여 온라인 판매 플랫폼에 최적화된 상세페이지를 작성합니다.';

// 2. 출력 형식 명시 (Format)
const formatInstruction = '''반드시 다음 JSON 형식으로 응답하세요:
{
  "title": "상품명 (50자 이내)",
  "subtitle": "부제목 (100자 이내)",
  "description": "상품 소개 (300자 이내)",
  "targetAudience": ["타겟 독자 1", "타겟 독자 2"],
  "benefits": ["기대 효과 1", "기대 효과 2"],
  "tableOfContents": ["목차 1", "목차 2"]
}''';
```

### API 호출 패턴

```dart
// lib/services/gemini_service.dart 기본 패턴
import 'package:firebase_ai/firebase_ai.dart';

class GeminiService {
  final _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.1-pro-preview',
  );

  Future<String> generateDetailPage(Uint8List pdfBytes, String platform) async {
    final prompt = TextPart(_buildPrompt(platform));
    final pdfPart = InlineDataPart('application/pdf', pdfBytes);

    final response = await _model.generateContent([
      Content.multi([prompt, pdfPart])
    ]);

    return response.text ?? '';
  }
}
```

---

## 🎨 UI/UX 컨벤션

### Flutter 위젯 패턴

```dart
// 카드 컴포넌트 기본 스타일
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: Padding(padding: EdgeInsets.all(24), child: ...),
)

// 주요 버튼
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue[600],
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  onPressed: () {},
  child: Text('상세페이지 생성', style: TextStyle(fontWeight: FontWeight.bold)),
)

// 섹션 제목
Text('결과', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold))

// 보조 텍스트
Text('파일을 선택해주세요', style: TextStyle(fontSize: 12, color: Colors.grey[500]))
```

### 위젯 작성 규칙

```dart
// 모든 위젯은 명시적 파라미터 타입 사용
class FileUploadWidget extends StatelessWidget {
  const FileUploadWidget({
    super.key,
    required this.onFileSelected,
    this.maxSizeMB = 20,
  });

  final void Function(Uint8List bytes, String fileName) onFileSelected;
  final int maxSizeMB;

  @override
  Widget build(BuildContext context) {
    // ...
  }
}
```

---

## 🧪 테스트 & 검증

### 로컬 테스트 체크리스트

```
□ PDF 업로드 → 파싱 성공 확인
□ Gemini API 응답 → 텍스트 수신 성공 확인
□ 상세페이지 미리보기 렌더링 확인
□ 복사 기능 동작 확인
□ 대용량 파일 (10MB+) 처리 확인
□ 네트워크 오류 시 에러 메시지 표시 확인
```

### 샘플 원고 파일

레포지토리에 포함된 샘플 파일로 테스트하세요:
- `넥서스 인사이트 2026 한국편(완고 9mb).pdf` — 한국 시장 분석 리포트
- `넥서스 인사이트 2026 중국편(완고 6MB).pdf` — 중국 시장 분석 리포트

---

## ⚡ 해커톤 개발 우선순위

시간이 제한되어 있습니다. 다음 순서로 개발하세요:

### Phase 1 — 핵심 기능 (Must Have) `~3시간`
- [ ] Flutter 프로젝트 초기 세팅 + Firebase 연동
- [ ] PDF 업로드 UI 구현 (file_picker)
- [ ] PDF bytes → Gemini 직접 전송
- [ ] Firebase AI Logic 연동 및 상세페이지 생성
- [ ] 결과 텍스트 표시 및 복사 기능

### Phase 2 — 완성도 향상 (Should Have) `~2시간`
- [ ] 플랫폼별 프롬프트 최적화 (크몽, 클래스101)
- [ ] 로딩 상태 및 에러 처리 UI
- [ ] 상세페이지 미리보기 레이아웃

### Phase 3 — 데모 준비 (Nice to Have) `~1시간`
- [ ] Firebase Hosting 배포 (`flutter build web && firebase deploy`)
- [ ] 랜딩 페이지 / 소개 섹션
- [ ] 데모 시연 준비


---

## 🚨 주의사항

1. **API 키 보안** — `firebase_options.dart`의 API 키는 절대 코드에 하드코딩 금지. `flutterfire configure` 사용
2. **파일 크기 제한** — Gemini API 요청 한도 20MB. 대용량 PDF는 Cloud Storage 경유 처리
3. **에러 핸들링** — API 호출 실패 시 사용자에게 명확한 에러 메시지 표시
4. **타입 안전성** — `dynamic` 타입 사용 금지. 모든 API 응답에 모델 클래스 정의 필수
5. **한국어 처리** — 프롬프트와 응답 모두 한국어로 처리. 인코딩 이슈 주의

---

## 📞 빠른 참고 링크

- [Gemini API 문서](https://ai.google.dev/gemini-api/docs)
- [Firebase AI Logic (Dart) 문서](https://firebase.google.com/docs/ai-logic/get-started?platform=flutter)
- [Firebase AI Logic — PDF 분석 가이드](https://firebase.google.com/docs/ai-logic/analyze-documents)
- [file_picker 패키지](https://pub.dev/packages/file_picker)
- [Firebase Hosting 배포 가이드](https://firebase.google.com/docs/hosting)


---

<p align="center">
  <em>이 문서는 AI 에이전트와의 협업 효율을 높이기 위해 작성되었습니다.</em><br>
  <em>프로젝트 구조나 컨벤션이 변경되면 이 파일도 함께 업데이트해주세요.</em>
</p>
