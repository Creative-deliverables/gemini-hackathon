# AI Detail Page Generator — Design System

> This document is the single source of truth for colors, typography, and theming.
> Every team member — including future contributors — should read this before touching UI code.
> **Keep this document in sync with any code changes.**

---

## Working Language

- **All code, comments, commits, and documentation must be written in English.**
- Conversations between team members may use Korean, but anything that lands in the repository must be in English.

---

## SOLID Principles in This Codebase

All UI code in this project must follow SOLID principles. Below is how each principle maps to our Flutter architecture:

| Principle                     | Application                                                                                                                                                         |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **S** — Single Responsibility | Each widget/class has one reason to change. `AppColors` only holds color constants. `ChatPanel` only renders chat. `PreviewPanel` only renders the manuscript.      |
| **O** — Open/Closed           | Extend behavior via new classes or providers, not by modifying existing ones. Add a new `ThemeMode` variant without touching `AppTheme`.                            |
| **L** — Liskov Substitution   | All `ConsumerWidget`/`StatelessWidget` subtypes are interchangeable where `Widget` is expected. No widget overrides should break parent contracts.                  |
| **I** — Interface Segregation | Providers expose only what consumers need. Widgets do not access internals directly.                                                                                |
| **D** — Dependency Inversion  | Widgets depend on abstractions (providers, `ThemeData`), not concrete implementations. Colors come from `AppColors`, not hardcoded `Color(0xFF...)`.                |

---

## 1. Color Palette

Based on Mockup 4 (Integrated Chat & Manuscript Preview Interface).

### Brand Colors

| Role                | Name         | Value     | Preview | Usage                                                      |
| ------------------- | ------------ | --------- | ------- | ---------------------------------------------------------- |
| **Primary**         | Blue Accent  | `#2563EB` | 🔵      | CTA buttons, highlights, badges, primary actions           |
| **Primary Dark**    | Blue Dark    | `#1D4ED8` | 🔵      | Pressed/hover state of primary                             |
| **Secondary**       | Gray Fill    | `#F3F4F6` | ⚪️      | Chat bubble backgrounds, secondary buttons                 |

### Light Theme Backgrounds

| Layer         | Constant                 | Value     |
| ------------- | ------------------------ | --------- |
| Base Scaffold | `AppColors.lightBg`      | `#F8FAFC` |
| Surface       | `AppColors.lightSurface` | `#FFFFFF` |
| Card          | `AppColors.lightCard`    | `#F1F5F9` |
| Border        | `AppColors.lightBorder`  | `#E2E8F0` |

### Text Colors

| Role           | Constant                                   | Light     |
| -------------- | ------------------------------------------ | --------- |
| Primary text   | `lightTextPrimary`                         | `#0F172A` |
| Secondary text | `lightTextSecondary`                       | `#64748B` |
| Muted text     | `lightTextMuted`                           | `#94A3B8` |
| On Primary     | `onPrimary`                                | `#FFFFFF` |

---

## 2. File Structure (Feature-First)

```
lib/
├── app/
│   └── app.dart                 — App root, ThemeData wired here
├── core/
│   ├── theme/
│   │   ├── app_colors.dart      — All color constants
│   │   ├── app_text_styles.dart — TextTheme definitions
│   │   └── app_theme.dart       — ThemeData getters
│   └── widgets/                 — Shared UI components
├── features/
│   └── home/
│       ├── pages/
│       │   └── home_page.dart   — Integrated Split-Pane Layout
│       └── widgets/
│           ├── chat_panel.dart  — Left: AI Chat Interface
│           └── preview_panel.dart — Right: PDF/Info Preview
└── main.dart
```

---

## 3. Usage Guide

### ✅ Correct

```dart
// Inside widget tree (preferred)
final color = Theme.of(context).colorScheme.primary;

// Outside ThemeData — CustomPainter, Canvas, etc.
final color = AppColors.primary;
```

### ❌ Forbidden

```dart
// Never hardcode colors inline — add to AppColors first
final color = Color(0xFF2563EB); // ❌ violates Single Source of Truth
```

---

## 4. Typography Scale

Use standard Material 3 typography guidelines tailored for desktop.

| Token            | Size | Weight | Used For                 |
| ---------------- | ---- | ------ | ------------------------ |
| `displayLarge`   | 48   | 800    | Hero titles              |
| `headlineMedium` | 24   | 700    | Panel headings           |
| `titleLarge`     | 18   | 600    | Emphasized body          |
| `bodyLarge`      | 16   | 400    | Standard reading text    |
| `bodyMedium`     | 14   | 400    | Chat bubbles, supporting |
| `labelLarge`     | 14   | 600    | Button labels            |

---

## 5. UI Layout: Mockup 4 (Integrated Split-Pane)

- **Single Page Application (SPA)** behavior.
- **Left Panel (35-40%)**: Conversational AI Chat Interface. Used to discuss the product detail page planning and requirements.
- **Right Panel (60-65%)**: Manuscript (PDF) Preview and Extracted Information Panel.
- **Divider**: A subtle border separates the two panels, creating a unified yet organized interface.
