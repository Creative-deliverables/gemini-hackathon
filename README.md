# 📖 원고 → 상세페이지 생성기

> **Google Gemini API Hackathon 2026** | 작가의 원고를 AI가 분석하여 온라인 판매 플랫폼용 상세페이지를 자동 생성합니다.

[![Flutter](https://img.shields.io/badge/Flutter-3.41.2-54C5F8?style=flat-square&logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.11.0-0175C2?style=flat-square&logo=dart)](https://dart.dev/)
[![Firebase AI](https://img.shields.io/badge/Firebase_AI_Logic-Gemini-FFCA28?style=flat-square&logo=firebase)](https://firebase.google.com/docs/ai-logic)
[![Firebase Hosting](https://img.shields.io/badge/Deploy-Firebase_Hosting-FFCA28?style=flat-square&logo=firebase)](https://firebase.google.com/docs/hosting)

---

## 🎯 프로젝트 소개

작가가 원고(PDF)를 업로드하면, **Google Gemini API**가 원고를 직접 분석하여 크몽, 클래스101, 탈잉, 스마트스토어 등 온라인 판매 플랫폼에 바로 게시할 수 있는 **전문적인 상세페이지**를 자동으로 생성합니다.

PDF를 별도로 파싱하지 않고 **Gemini에 파일을 그대로 전달**하여 분석합니다. 작가는 더 이상 마케팅 카피라이팅에 시간을 낭비하지 않아도 됩니다. 원고 하나로 판매 준비 완료.

---

## ✨ 주요 기능

- 📄 **원고 업로드** — PDF 파일 선택 (file_picker)
- 🤖 **AI 원고 분석** — PDF를 Gemini에 직접 전송, 별도 파싱 불필요
- 🛍️ **상세페이지 자동 생성** — 제목, 소개글, 목차, 추천 대상, 기대 효과 등 완성
- 🎨 **플랫폼별 최적화** — 크몽 / 클래스101 / 스마트스토어 형식 선택 가능
- 📋 **원클릭 복사** — 생성된 상세페이지 텍스트 즉시 복사
- 👀 **실시간 미리보기** — 생성 결과를 실제 판매 페이지처럼 미리 확인

---

## 🛠 기술 스택

| 분류 | 기술 |
|------|------|
| **Framework** | Flutter 3.41.2 |
| **Language** | Dart 3.11.0 |
| **AI / LLM** | Firebase AI Logic (`firebase_ai`) — Gemini API |
| **PDF 처리** | PDF bytes를 Gemini에 직접 전송 (`InlineDataPart`) |
| **파일 선택** | `file_picker` |
| **배포** | Firebase Hosting (`flutter build web`) |

> **왜 `firebase_ai`인가?**
> 기존 `google_generative_ai` 패키지는 deprecated 되었습니다. Google의 공식 후속 SDK인 `firebase_ai` (Firebase AI Logic)를 사용합니다. Gemini 3.1 모델을 완벽히 지원하며, API 키 보안도 Firebase App Check로 처리됩니다.
> 
> **패키지 버전 관리 정책:** 모든 Flutter 패키지는 항상 최신 버전을 유지하는 것을 원칙으로 하되, 호환성 문제가 발생할 경우에만 다운그레이드하여 해결합니다.

---

## 🚀 시작하기

### 사전 요구사항

- Flutter 3.41.2 / Dart 3.11.0
- Firebase 프로젝트 ([콘솔에서 생성](https://console.firebase.google.com/))
- Firebase CLI (`npm install -g firebase-tools`)

### 설치

```bash
# 레포지토리 클론
git clone https://github.com/Creative-deliverables/gemini-hackathon.git
cd gemini-hackathon

# 의존성 설치
flutter pub get

# Firebase 연동 (최초 1회)
flutterfire configure

# 개발 서버 실행 (Web)
flutter run -d chrome
```

### Firebase AI Logic 활성화

1. [Firebase 콘솔](https://console.firebase.google.com/) → 프로젝트 선택
2. **Firebase AI Logic** 메뉴 → **Get started**
3. **Gemini Developer API** 선택 → API 키 자동 생성
4. `flutterfire configure` 로 `firebase_options.dart` 자동 생성

---

## 🔑 환경 설정

Firebase AI Logic을 사용하면 API 키를 코드에 직접 넣지 않아도 됩니다.
`flutterfire configure` 실행 시 자동 생성되는 `firebase_options.dart`가 모든 설정을 담당합니다.

```dart
// main.dart — Firebase 초기화
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

> ⚠️ `firebase_options.dart`는 민감한 프로젝트 정보를 포함합니다. 공개 레포에서는 `.gitignore` 추가를 검토하세요.

---

## 📁 프로젝트 구조

```
gemini-hackathon/
├── lib/
│   ├── main.dart                   # 앱 진입점, Firebase 초기화
│   ├── screens/
│   │   ├── home_screen.dart        # 메인 화면 (업로드 + 결과)
│   │   └── preview_screen.dart     # 상세페이지 미리보기
│   ├── widgets/
│   │   ├── file_upload_widget.dart # PDF 업로드 UI
│   │   ├── platform_selector.dart  # 플랫폼 선택 (크몽/클래스101 등)
│   │   └── result_card.dart        # 생성 결과 카드
│   ├── services/
│   │   └── gemini_service.dart     # Firebase AI Logic 호출 & 프롬프트
│   └── models/
│       └── detail_page_model.dart  # 상세페이지 데이터 모델
├── firebase_options.dart           # Firebase 설정 (flutterfire configure 자동 생성)
├── pubspec.yaml                    # 패키지 의존성
├── .gitignore
├── README.md
└── AGENTS.md                       # AI 에이전트 협업 가이드
```

---

## 📖 사용 방법

1. **원고 업로드** — 메인 화면에서 PDF 파일 선택
2. **플랫폼 선택** — 게시할 판매 플랫폼 선택 (크몽, 클래스101, 스마트스토어 등)
3. **AI 분석 시작** — "상세페이지 생성" 버튼 클릭
4. **결과 확인** — 생성된 상세페이지 미리보기 및 수정
5. **복사 & 게시** — 원클릭으로 텍스트 복사 후 플랫폼에 붙여넣기

---

## 🌿 개발 가이드

### 브랜치 전략

```
main          ← 배포 브랜치 (항상 동작하는 상태 유지)
├── dev       ← 개발 통합 브랜치
│   ├── feat/upload-ui        ← 기능 개발
│   ├── feat/gemini-api
│   └── fix/pdf-send-error    ← 버그 수정
```

### 커밋 컨벤션

```
feat: 새로운 기능 추가
fix:  버그 수정
ui:   UI/스타일 변경
docs: 문서 수정
refactor: 코드 리팩토링
chore: 빌드, 설정 변경
```

**예시:**
```bash
git commit -m "feat: PDF 파일 선택 및 Gemini 전송 기능 추가"
git commit -m "ui: 상세페이지 미리보기 레이아웃 개선"
git commit -m "fix: 대용량 PDF 전송 시 타임아웃 오류 수정"
```

### PR 규칙

- `dev` 브랜치로 PR 생성
- 셀프 리뷰 후 팀원 승인 1명 필요
- PR 제목은 커밋 컨벤션과 동일한 형식 사용

---

## 👥 팀원

| 역할 | 이름 | GitHub |
|------|------|--------|
| 풀스택 개발 | SANGWOO PARK | [@cyberprophet](https://github.com/cyberprophet) |
| 풀스택 개발 | 팀원 2 | - |

---

## 📄 라이선스

MIT License © 2026 Creative-deliverables

---

<p align="center">
  Made with ❤️ at Google Gemini API Hackathon 2026
</p>
