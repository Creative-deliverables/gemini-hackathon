# 📖 Gemini Detail Page Generator (원고 → 상세페이지 생성기)

> **Google Gemini API Hackathon 2026** | 작가의 원고를 AI가 분석하여 온라인 판매 플랫폼용 상세페이지를 자동 생성합니다.

[![Flutter](https://img.shields.io/badge/Flutter-3.41.2-54C5F8?style=flat-square&logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.11.0-0175C2?style=flat-square&logo=dart)](https://dart.dev/)
[![Firebase AI](https://img.shields.io/badge/Firebase_AI_Logic-Gemini-FFCA28?style=flat-square&logo=firebase)](https://firebase.google.com/docs/ai-logic)
[![Firebase Hosting](https://img.shields.io/badge/Deploy-Firebase_Hosting-FFCA28?style=flat-square&logo=firebase)](https://firebase.google.com/docs/hosting)

---

![Hero Image](./docs/screenshots/hero.png)

---

## 🎯 Problem & Solution

### 😟 Problem: 작가들의 고질적인 고민, "마케팅은 너무 어려워요"
많은 작가들이 원고 집필보다 더 어려워하는 것이 바로 **'판매용 상세페이지'** 작성입니다.
- **시간 낭비**: 원고를 다 썼는데, 다시 마케팅 카피를 짜느라 며칠을 허비합니다.
- **플랫폼별 파편화**: 교보문고, 예스24, 알라딘 등 플랫폼마다 요구하는 양식과 톤앤매너가 다릅니다.
- **전문성 부족**: 좋은 글을 쓰는 것과 물건을 잘 파는 카피를 쓰는 것은 별개의 영역입니다.

### ✨ Solution: Gemini AI가 제안하는 "원고 하나로 끝내는 상세페이지"
**Gemini Detail Page Generator**는 작가가 업로드한 PDF 원고를 직접 분석하여, 각 플랫폼에 최적화된 전문 마케팅 카피를 단 몇 초 만에 생성합니다.
- **직접 분석**: PDF를 텍스트로 변환할 필요 없이, Gemini가 원고의 맥락과 핵심 가치를 직접 파악합니다.
- **플랫폼 맞춤형**: 선택한 플랫폼의 특성에 맞는 구조와 문체로 상세페이지를 구성합니다.
- **작가 중심**: 작가는 오직 '글'에만 집중하고, '판매'는 AI가 돕습니다.

---

## 🚀 Key Features

### 1. 원고 직접 작성 및 PDF 업로드
복잡한 텍스트 추출 과정 없이, 작성 중인 원고나 완성된 PDF 파일을 그대로 업로드하세요. Gemini가 파일의 내용을 즉시 이해합니다.
![Upload](./docs/screenshots/1_upload.png)

### 2. 맞춤형 템플릿 및 문체 설정
게시할 플랫폼(교보문고, 예스24, 부크크 등)을 선택하고, 독자에게 다가갈 문체(친근한, 전문적인, 감성적인 등)를 설정할 수 있습니다.
![Template](./docs/screenshots/2_template.png)

### 3. AI 기반 상세페이지 자동 생성 & 대화형 수정
생성된 결과물을 확인하고, 마음에 들지 않는 부분은 AI와 대화하며 실시간으로 수정할 수 있습니다. 완성된 카피는 원클릭으로 복사하여 바로 사용하세요.
![Result](./docs/screenshots/3_result.png)

---

## 🛠 Tech Stack

- **Frontend**: Flutter 3.41.2 (Web)
- **Language**: Dart 3.11.0
- **AI Engine**: Google Gemini 3.1 Pro (via Firebase AI Logic)
- **Backend**: Firebase (Auth, Hosting, App Check)
- **PDF Processing**: `InlineDataPart` (Direct PDF bytes transmission to Gemini)

---

## 🏁 Getting Started

### Prerequisites
- Flutter SDK (3.41.2+)
- Firebase CLI
- Google Cloud Project with Gemini API enabled

### Installation
```bash
# Clone the repository
git clone https://github.com/Creative-deliverables/gemini-hackathon.git
cd gemini-hackathon

# Install dependencies
flutter pub get

# Configure Firebase
flutterfire configure

# Run the project
flutter run -d chrome
```

---

<p align="center">
  Made with ❤️ at Google Gemini API Hackathon 2026
</p>

