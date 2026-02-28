# 📖 원고 → 상세페이지 생성기

> **Google Gemini API Hackathon 2026** | 작가의 원고를 AI가 분석하여 온라인 판매 플랫폼용 상세페이지를 자동 생성합니다.

[![Next.js](https://img.shields.io/badge/Next.js-14-black?style=flat-square&logo=next.js)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue?style=flat-square&logo=typescript)](https://www.typescriptlang.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind-3.0-38bdf8?style=flat-square&logo=tailwindcss)](https://tailwindcss.com/)
[![Gemini API](https://img.shields.io/badge/Gemini-API-4285F4?style=flat-square&logo=google)](https://ai.google.dev/)
[![Vercel](https://img.shields.io/badge/Deploy-Vercel-black?style=flat-square&logo=vercel)](https://vercel.com/)

---

## 🎯 프로젝트 소개

작가가 원고(PDF, DOCX 등)를 업로드하면, **Google Gemini API**가 원고를 심층 분석하여 크몽, 클래스101, 탈잉, 스마트스토어 등 온라인 판매 플랫폼에 바로 게시할 수 있는 **전문적인 상세페이지**를 자동으로 생성합니다.

작가는 더 이상 마케팅 카피라이팅에 시간을 낭비하지 않아도 됩니다. 원고 하나로 판매 준비 완료.

---

## ✨ 주요 기능

- 📄 **원고 업로드** — PDF, DOCX, TXT 형식 지원
- 🤖 **AI 원고 분석** — Gemini API로 핵심 내용, 타겟 독자, 차별점 자동 추출
- 🛍️ **상세페이지 자동 생성** — 제목, 소개글, 목차, 추천 대상, 기대 효과 등 완성
- 🎨 **플랫폼별 최적화** — 크몽 / 클래스101 / 스마트스토어 형식 선택 가능
- 📋 **원클릭 복사** — 생성된 상세페이지 텍스트 즉시 복사
- 👀 **실시간 미리보기** — 생성 결과를 실제 판매 페이지처럼 미리 확인

---

## 🛠 기술 스택

| 분류 | 기술 |
|------|------|
| **Frontend** | Next.js 14 (App Router), TypeScript, Tailwind CSS |
| **AI / LLM** | Google Gemini API (gemini-2.0-flash) |
| **파일 처리** | pdf-parse, mammoth (DOCX) |
| **UI 컴포넌트** | shadcn/ui |
| **배포** | Vercel |
| **패키지 매니저** | npm |

---

## 🚀 시작하기

### 사전 요구사항

- Node.js 18.17 이상
- Google Gemini API Key ([발급받기](https://aistudio.google.com/app/apikey))

### 설치

```bash
# 레포지토리 클론
git clone https://github.com/Creative-deliverables/gemini-hackathon.git
cd gemini-hackathon

# 의존성 설치
npm install

# 환경 변수 설정
cp .env.example .env.local
# .env.local 파일에 API 키 입력

# 개발 서버 실행
npm run dev
```

브라우저에서 [http://localhost:3000](http://localhost:3000) 접속

---

## 🔑 환경 변수

`.env.local` 파일을 생성하고 아래 내용을 입력하세요:

```env
# Google Gemini API
GEMINI_API_KEY=your_gemini_api_key_here

# (선택) 앱 설정
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

> ⚠️ `.env.local` 파일은 절대 Git에 커밋하지 마세요. `.gitignore`에 이미 포함되어 있습니다.

---

## 📁 프로젝트 구조

```
gemini-hackathon/
├── app/                        # Next.js App Router
│   ├── api/
│   │   └── analyze/
│   │       └── route.ts        # Gemini API 호출 엔드포인트
│   ├── layout.tsx
│   └── page.tsx                # 메인 페이지
├── components/
│   ├── FileUpload.tsx           # 파일 업로드 컴포넌트
│   ├── AnalysisResult.tsx       # 분석 결과 표시
│   ├── DetailPagePreview.tsx    # 상세페이지 미리보기
│   └── PlatformSelector.tsx     # 플랫폼 선택 UI
├── lib/
│   ├── gemini.ts               # Gemini API 클라이언트
│   ├── pdf-parser.ts           # PDF 파싱 유틸리티
│   └── prompts.ts              # AI 프롬프트 템플릿
├── types/
│   └── index.ts                # TypeScript 타입 정의
├── public/
│   └── sample/                 # 샘플 원고 파일
├── .env.example
├── .env.local                  # (gitignore) 로컬 환경 변수
├── .gitignore
├── next.config.ts
├── package.json
├── tailwind.config.ts
├── tsconfig.json
├── README.md
└── AGENTS.md                   # AI 에이전트 협업 가이드
```

---

## 📖 사용 방법

1. **원고 업로드** — 메인 화면에서 PDF 또는 문서 파일을 드래그 앤 드롭
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
│   └── fix/pdf-parsing-error ← 버그 수정
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
git commit -m "feat: PDF 파일 업로드 및 파싱 기능 추가"
git commit -m "ui: 상세페이지 미리보기 레이아웃 개선"
git commit -m "fix: 대용량 PDF 처리 시 타임아웃 오류 수정"
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
