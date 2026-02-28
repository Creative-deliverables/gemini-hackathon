# 🤖 AGENTS.md — AI 에이전트 협업 가이드

> 이 프로젝트에서 AI 코딩 어시스턴트(Claude, Gemini, Cursor 등)를 효과적으로 활용하기 위한 가이드입니다.

---

## 📌 프로젝트 개요 (AI 컨텍스트)

```
프로젝트명: 원고 → 상세페이지 생성기
목적: 작가가 원고(PDF)를 업로드하면 Gemini API가 분석하여 온라인 판매 플랫폼용 상세페이지를 자동 생성
스택: Next.js 14 (App Router) + TypeScript + Tailwind CSS + Google Gemini API
배포: Vercel
```

---

## 🏗 아키텍처 개요

```
[사용자] → [파일 업로드 UI] → [Next.js API Route]
                                      ↓
                              [PDF 파싱 (pdf-parse)]
                                      ↓
                              [Gemini API 호출]
                              (gemini-2.0-flash)
                                      ↓
                              [상세페이지 텍스트 생성]
                                      ↓
                              [미리보기 & 복사 UI]
```

---

## 📂 핵심 파일 & 역할

| 파일 | 역할 | 수정 시 주의사항 |
|------|------|-----------------|
| `app/api/analyze/route.ts` | Gemini API 호출 메인 엔드포인트 | 프롬프트 변경 시 `lib/prompts.ts`와 함께 수정 |
| `lib/gemini.ts` | Gemini 클라이언트 초기화 및 래퍼 | API 키는 반드시 환경 변수에서 읽기 |
| `lib/prompts.ts` | AI 프롬프트 템플릿 모음 | 플랫폼별 프롬프트 분리 유지 |
| `lib/pdf-parser.ts` | PDF → 텍스트 변환 | 대용량 파일(10MB+) 처리 고려 |
| `components/FileUpload.tsx` | 드래그 앤 드롭 업로드 UI | 파일 크기/형식 검증 포함 |
| `components/DetailPagePreview.tsx` | 생성 결과 미리보기 | 플랫폼별 렌더링 분기 처리 |
| `types/index.ts` | 전역 TypeScript 타입 | 새 타입 추가 시 여기에 정의 |

---

## 🤖 AI 에이전트 사용 규칙

### ✅ DO — 이렇게 요청하세요

**구체적인 파일과 함께 요청:**
```
"app/api/analyze/route.ts 파일에서 Gemini API를 호출하는 부분을 수정해줘.
현재는 단순 텍스트만 반환하는데, JSON 형식으로 { title, description, targetAudience, benefits } 를 반환하도록 변경해줘."
```

**컨텍스트를 포함한 요청:**
```
"lib/prompts.ts의 generateDetailPagePrompt 함수를 수정해줘.
현재 크몽 플랫폼용 프롬프트인데, 클래스101 플랫폼에 맞게 커리큘럼 구조를 강조하는 버전도 추가해줘."
```

**에러 메시지와 함께 요청:**
```
"PDF 파싱 시 다음 에러가 발생해:
Error: ENOENT: no such file or directory
lib/pdf-parser.ts 파일을 확인하고 수정해줘."
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
| `gemini-2.0-flash` | **기본 사용** — 빠른 응답, 비용 효율 | 대부분의 경우 이 모델 사용 |
| `gemini-1.5-pro` | 대용량 문서 분석 (100만 토큰) | 필요 시에만 사용 |

### 프롬프트 작성 원칙

```typescript
// lib/prompts.ts 작성 시 따를 원칙

// 1. 역할 부여 (Role)
const systemPrompt = `당신은 전문 마케팅 카피라이터입니다.
작가의 원고를 분석하여 온라인 판매 플랫폼에 최적화된 상세페이지를 작성합니다.`;

// 2. 출력 형식 명시 (Format)
const formatInstruction = `반드시 다음 JSON 형식으로 응답하세요:
{
  "title": "상품명 (50자 이내)",
  "subtitle": "부제목 (100자 이내)",
  "description": "상품 소개 (300자 이내)",
  "targetAudience": ["타겟 독자 1", "타겟 독자 2"],
  "benefits": ["기대 효과 1", "기대 효과 2"],
  "tableOfContents": ["목차 1", "목차 2"]
}`;

// 3. 원고 내용 삽입
const userPrompt = `다음 원고를 분석해주세요:\n\n${manuscriptText}`;
```

### API 호출 패턴

```typescript
// app/api/analyze/route.ts 기본 패턴
import { GoogleGenerativeAI } from "@google/generative-ai";

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY!);

export async function POST(request: Request) {
  const { manuscriptText, platform } = await request.json();
  
  const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });
  
  const prompt = generateDetailPagePrompt(manuscriptText, platform);
  const result = await model.generateContent(prompt);
  const response = result.response.text();
  
  // JSON 파싱 및 반환
  return Response.json(JSON.parse(response));
}
```

---

## 🎨 UI/UX 컨벤션

### Tailwind CSS 클래스 패턴

```tsx
// 카드 컴포넌트 기본 스타일
<div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">

// 주요 버튼
<button className="rounded-lg bg-blue-600 px-6 py-3 text-white font-semibold hover:bg-blue-700 transition-colors">

// 섹션 제목
<h2 className="text-2xl font-bold text-gray-900 mb-4">

// 보조 텍스트
<p className="text-sm text-gray-500">
```

### 컴포넌트 작성 규칙

```tsx
// 모든 컴포넌트는 TypeScript + 명시적 Props 타입 사용
interface FileUploadProps {
  onFileSelect: (file: File) => void;
  accept?: string;
  maxSizeMB?: number;
}

export function FileUpload({ onFileSelect, accept = ".pdf", maxSizeMB = 20 }: FileUploadProps) {
  // ...
}
```

---

## 🧪 테스트 & 검증

### 로컬 테스트 체크리스트

```
□ PDF 업로드 → 파싱 성공 확인
□ Gemini API 응답 → JSON 파싱 성공 확인
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
- [ ] Next.js 프로젝트 초기 세팅
- [ ] PDF 업로드 UI 구현
- [ ] PDF → 텍스트 파싱
- [ ] Gemini API 연동 및 상세페이지 생성
- [ ] 결과 텍스트 표시 및 복사 기능

### Phase 2 — 완성도 향상 (Should Have) `~2시간`
- [ ] 플랫폼별 프롬프트 최적화 (크몽, 클래스101)
- [ ] 로딩 상태 및 에러 처리 UI
- [ ] 상세페이지 미리보기 레이아웃

### Phase 3 — 데모 준비 (Nice to Have) `~1시간`
- [ ] Vercel 배포
- [ ] 랜딩 페이지 / 소개 섹션
- [ ] 데모 시연 준비

---

## 🚨 주의사항

1. **API 키 보안** — `GEMINI_API_KEY`는 절대 코드에 하드코딩 금지. 반드시 `.env.local` 사용
2. **파일 크기 제한** — Gemini API의 토큰 한도 고려. 대용량 PDF는 청크 분할 처리
3. **에러 핸들링** — API 호출 실패 시 사용자에게 명확한 에러 메시지 표시
4. **타입 안전성** — `any` 타입 사용 금지. 모든 API 응답에 타입 정의 필수
5. **한국어 처리** — 프롬프트와 응답 모두 한국어로 처리. 인코딩 이슈 주의

---

## 📞 빠른 참고 링크

- [Gemini API 문서](https://ai.google.dev/gemini-api/docs)
- [Gemini API Node.js SDK](https://www.npmjs.com/package/@google/generative-ai)
- [Next.js App Router 문서](https://nextjs.org/docs/app)
- [shadcn/ui 컴포넌트](https://ui.shadcn.com/)
- [pdf-parse npm](https://www.npmjs.com/package/pdf-parse)

---

<p align="center">
  <em>이 문서는 AI 에이전트와의 협업 효율을 높이기 위해 작성되었습니다.</em><br>
  <em>프로젝트 구조나 컨벤션이 변경되면 이 파일도 함께 업데이트해주세요.</em>
</p>
