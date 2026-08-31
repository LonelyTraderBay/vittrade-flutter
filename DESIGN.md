---
version: alpha
name: VitTrade Dark Enterprise
description: Dark-first crypto trading UI — phone-first 360px+, shared Vit* primitives, theme tokens in flutter_app/lib/app/theme/
colors:
  bg: "#07090D"
  surface: "#10141B"
  surface2: "#171C24"
  surface3: "#222936"
  borderSolid: "#2D3440"
  primary: "#E58A00"
  primaryDark: "#B96000"
  primarySoft: "#F5A524"
  buy: "#10B981"
  buyDark: "#059669"
  sell: "#EF4444"
  sellDark: "#DC2626"
  accent: "#8B5CF6"
  info: "#3B82F6"
  caution: "#F59E0B"
  text1: "#F5F7FA"
  text2: "#A7AFBF"
  text3: "#667085"
  textDisabled: "#566175"
  cardBg: "#10141B"
  cardBorder: "#12FFFFFF"
  divider: "#0DFFFFFF"
typography:
  micro:
    fontSize: 10px
    fontWeight: 400
    lineHeight: 1.5
  caption:
    fontSize: 13px
    fontWeight: 400
    lineHeight: 1.5
  body:
    fontSize: 14px
    fontWeight: 400
    lineHeight: 1.5
  base:
    fontSize: 16px
    fontWeight: 400
    lineHeight: 1.5
  control:
    fontSize: 14px
    fontWeight: 600
    lineHeight: 1
  sectionTitle:
    fontSize: 21px
    fontWeight: 700
    lineHeight: 1.272
  pageTitle:
    fontSize: 26px
    fontWeight: 700
    lineHeight: 1.272
  heroNumber:
    fontSize: 34px
    fontWeight: 700
    lineHeight: 1.272
  display:
    fontSize: 43px
    fontWeight: 700
    lineHeight: 1.618
rounded:
  sm: 8px
  input: 14px
  card: 16px
  cardLarge: 24px
  pill: 999px
spacing:
  x1: 3px
  x2: 5px
  x3: 8px
  x4: 13px
  x5: 21px
  x6: 34px
  x7: 55px
  contentPad: 20px
  sectionGap: 20px
  rowPy: 14px
  inputHeight: 52px
  ctaHeight: 52px

# Tablet whitespace law — 8pt grid (2026-09-01, hướng A): tablet surface
# runs a Base-8 scale (4·8·12·16·24·32·56) in TabletSpacingTokens; every
# VERTICAL AND HORIZONTAL gap = 12px — no exceptions, zero tolerance.
# One gap = one layer. Data-row extents, control sizes, borders are out
# of scope (metrics). Phone keeps the Fibonacci AppSpacing scale.
# Enforced by tablet_gap_12_guardrail_test + RenderBox layout locks.
# See Tablet-Spacing-Gutter-Standard Rule 6.
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.text1}"
    rounded: "{rounded.input}"
    height: "{spacing.ctaHeight}"
  button-buy:
    backgroundColor: "{colors.buy}"
    textColor: "{colors.text1}"
    rounded: "{rounded.input}"
  button-sell:
    backgroundColor: "{colors.sell}"
    textColor: "{colors.text1}"
    rounded: "{rounded.input}"
  card-standard:
    backgroundColor: "{colors.cardBg}"
    rounded: "{rounded.card}"
  card-large:
    backgroundColor: "{colors.cardBg}"
    rounded: "{rounded.cardLarge}"
  input-field:
    backgroundColor: "{colors.surface2}"
    textColor: "{colors.text1}"
    rounded: "{rounded.input}"
    height: "{spacing.inputHeight}"
  status-pill:
    rounded: "{rounded.pill}"
---

# VitTrade Design System

## Overview

VitTrade is an enterprise crypto trading app with a **dark baseline** UI. The visual
identity is dense but readable: deep ink backgrounds, warm amber primary actions,
semantic green/red for buy/sell, and layered surfaces for cards and terminals.

- **Baseline:** dark theme only for new work.
- **Layout:** phone-first from **360px** width upward; tablet-adaptive shell
  (nav rail) from **600px** (`AppBreakpoints.tablet`) — see AGENTS.md UI Rules.
- **Architecture:** reuse shared `Vit*` widgets before local scaffolds.
- **Authority:** `AGENTS.md` overrides this file for product boundaries, financial
  safety, and required migration scope.

### Flutter token mapping

| DESIGN.md | Dart |
| --- | --- |
| `colors.primary` | `AppColors.primary` |
| `colors.buy` / `colors.sell` | `AppColors.buy` / `AppColors.sell` |
| `colors.text1`–`text3` | `AppColors.text1`–`text3` |
| `rounded.input` | `AppRadii.inputRadius` (14px) |
| `rounded.card` | `AppRadii.cardRadius` (16px) |
| `rounded.cardLarge` | `AppRadii.cardLargeRadius` (24px) |
| `rounded.sm` | `AppRadii.smRadius` (8px) |
| `rounded.pill` | `AppRadii.pillRadius` (999px) |
| `spacing.contentPad` | `AppSpacing.contentPad` |
| `spacing.sectionGap` | `AppSpacing.sectionGap` (legacy 20px design token) |
| `spacing.pageRhythm.compact.sectionGap` | `AppSpacing.pageRhythmCompactSectionGap` (8px) |
| `spacing.pageRhythm.compact.innerGap` | `AppSpacing.pageRhythmCompactInnerGap` (5px) |
| `spacing.pageRhythm.standard.sectionGap` | `AppSpacing.pageRhythmStandardSectionGap` (13px) |
| `spacing.pageRhythm.standard.innerGap` | `AppSpacing.pageRhythmStandardInnerGap` (8px) |
| `spacing.pageRhythm.form.sectionGap` | `AppSpacing.pageRhythmFormSectionGap` (16px) |
| `spacing.pageRhythm.relaxed.sectionGap` | `AppSpacing.pageRhythmRelaxedSectionGap` (24px) |
| `VitPageRhythm` tier enum | `app_page_rhythm.dart` |
| `typography.body` | `AppTextStyles.body` |
| `typography.pageTitle` | `AppTextStyles.pageTitle` |

Import from `package:vit_trade_flutter/app/theme/`.

## Colors

**One dark theme, deliberately.** Dark-only is a locked product decision for
this trading app — no light theme, no mode toggle. See
`Flutter-Native-Design-Standard.md` (Global UI Rules).

The palette uses layered dark surfaces with a single warm primary accent.

- **Background (#07090D):** deepest canvas — `AppColors.bg`.
- **Surface (#10141B–#222936):** cards, panels, elevated content — `surface`,
  `surface2`, `surface3`.
- **Primary (#E58A00):** main CTA, nav active, brand accent — not for body text.
- **Buy (#10B981) / Sell (#EF4444):** semantic trade direction only.
- **Text1 (#F5F7FA):** primary readable text.
- **Text2 (#A7AFBF):** secondary labels, captions.
- **Text3 (#667085):** tertiary, placeholders, inactive nav.

Use alpha tints (`primary12`, `buy10`, `sell15`) for subtle fills — never invent
new hex values when an existing tint token fits.

## Typography

System font stack via Flutter theme. Numeric displays use tabular figures
(`AppTextStyles.tabularFigures` / `heroNumber`, `numericCode`).

- **Display / hero:** large PnL, balances — `display`, `heroNumber`, `jumbo`.
- **Page title:** screen headers — `pageTitle`, `sectionTitle`.
- **Body:** default copy — `body`, `base`.
- **Caption / micro:** metadata, timestamps — `caption`, `micro`.
- **Control:** buttons, tabs, segmented labels — `control`.

Do not introduce arbitrary font sizes outside `AppTextStyles`.

## Layout

Phone-first fluid layout with consistent horizontal padding.

- **Content padding:** 20px (`AppSpacing.contentPad`).
- **Section gap (legacy):** 20px design reference (`AppSpacing.sectionGap`). Runtime
  pages use **page rhythm** tiers below — feed roots intentionally use compact 8px.
- **Page rhythm (3 levels):**
  1. **Section gap** — parent `VitPageContent` / `rhythm` / `customGap` between major blocks.
  2. **Inner gap** — section title → body (`pageRhythm*InnerGap`, `VitSectionHeader.bottomGap`).
  3. **Item gap** — rows, chips, cards within a section (`rowGap`, module tokens).
- **Tiers:** `VitPageRhythm.compact` (feed/tab root), `.standard` (scroll), `.form`
  (wizard/KYC/bottom sheets), `.relaxed` (hero/onboarding icon blocks only), `.flush` (charts/terminals).
- **Ownership:** parent owns section gaps; children must not add orphan `SizedBox`
  between top-level blocks.
- **Scale:** Fibonacci-inspired steps x1–x7 (3, 5, 8, 13, 21, 34, 55).
- **Controls:** CTA and input height 52px.
- **Page content:** use `VitPageLayout` + `VitPageContent` — not raw `Scaffold` +
  manual padding.

Migration checklist: `docs/02_FLUTTER_MIGRATION/checklists/Page-Rhythm-Migration-Checklist.md`.
**Mandatory standard + CI:** `docs/02_FLUTTER_MIGRATION/standards/Page-Rhythm-Standard.md`.
Audit: `dart run tool/page_rhythm_audit.dart --check` from `flutter_app/`.
Guardrail: `flutter test test/quality/page_rhythm_guardrail_test.dart`.

**Card tiles (Tier A strip):** fixed-height horizontal tiles use
`VitCardContentAlign.center`, `AppSpacing.cardTilePadding`, and
`AppSpacing.cardTileInnerGap`. Canonical widgets: `VitCompactProductCard`,
`VitMarketTickerCard`. Standard: `docs/02_FLUTTER_MIGRATION/standards/Card-Tile-Standard.md`.
Audit: `dart run tool/card_tile_audit.dart --check`.

**Service tile badges (Tier B):** `VitServiceTile` corner badges use safe inset
tokens (`serviceTileBadgeReserve*`) and grid aspect tokens — do not overlap the
centered label. Standard: `docs/02_FLUTTER_MIGRATION/standards/Service-Tile-Badge-Standard.md`.
Guardrail: `flutter test test/quality/service_tile_badge_guardrail_test.dart`.

**Task cards (Tier E):** `VitTaskCard` mission rows use intrinsic height and
`taskCard*` spacing tokens — no legacy `buttonHero + x7 + x5` minHeight.
Standard: `docs/02_FLUTTER_MIGRATION/standards/Task-Card-Standard.md`.
Guardrail: `flutter test test/quality/task_card_guardrail_test.dart`.

**Accent icon boxes:** `VitAccentIconBox` module row icons use `accentIconBoxSize`
(34px) with shared fill/border tokens — no page-local `_AccentIcon`.
Standard: `docs/02_FLUTTER_MIGRATION/standards/Accent-Icon-Box-Standard.md`.
Guardrail: `flutter test test/quality/accent_icon_box_guardrail_test.dart`.

**Segment pills (S1–S4):** page tabs → `VitTabBar.segment` / `VitSegmentedTabBar`;
binary toggles → `VitSegmentedChoice`; preset rows → `VitPresetChipRow`;
filters → `VitFilterChip`. No P0 local `_FilterButton` / `_FilterTabs`.
Standard: `docs/02_FLUTTER_MIGRATION/standards/Segment-Pill-Standard.md`.
Audit: `dart run tool/segment_pill_audit.dart --check --strict-full`.
Guardrail: `flutter test test/quality/segment_pill_guardrail_test.dart`.

## Elevation & Depth

Depth is conveyed through **surface layering and borders**, not heavy shadows.

- Cards sit on `surface` over `bg`.
- Borders use `AppColors.cardBorder`, `borderSolid`, or semantic tinted borders.
- Modals use `modalScrim` / `modalScrimStrong` scrims.
- Do not add drop shadows unless an existing shared primitive already defines them.

## Interaction States & Motion

Pointer-hover, keyboard-focus, and animation values are tokens — never
hand-rolled per page. On the tablet surface both are absolute CI locks
(`Tablet-Input-Standard.md` I1–I5, `Motion-Standard.md` M1–M5); shared
widgets consume them everywhere.

| Role | Token | Visual |
| --- | --- | --- |
| Pointer hover on a control | `AppInputStates.hoverOverlay` | 5% white fill |
| Keyboard focus on a control | `AppInputStates.focusOverlay` | 12% primary fill |
| Keyboard focus on a text input | `AppInputStates.focusInputBorder` | border → primary (error wins) |
| Micro feedback duration | `AppMotion.feedback` | 100ms |
| Element state duration | `AppMotion.element` | 180ms |
| Surface (sheet/dialog) duration | `AppMotion.surface` | 240ms |
| Scene transition duration | `AppMotion.scene` | 320ms |
| Easing enter / emphasized / exit | `AppMotion.enter` / `emphasized` / `exit` | easeOutCubic / easeInOutCubicEmphasized / easeInCubic |

- Hover/focus come from shared widgets (`VitCard`, `VitCtaButton`, rows,
  `VitInput`) — no page-local `MouseRegion`/`onHover`, no off-token
  `hoverColor:`/`focusColor:`; fills never shift layout.
- Animation durations/easings are `AppMotion.*` references — no inline
  `Duration(`/`Curves.` in tablet presentation; respect reduced motion via
  `AppMotion.respect(context, …)`.

## Shapes

Canonical radius tiers — **do not use `BorderRadius.circular()` outside
`app_radii.dart`**.

| Role | Token | px |
| --- | --- | --- |
| Interactive controls | `AppRadii.inputRadius` | 14 |
| Standard cards | `AppRadii.cardRadius` | 16 |
| Large / hero cards | `AppRadii.cardLargeRadius` | 24 |
| Micro surfaces | `AppRadii.smRadius` | 8 |
| Status pills | `AppRadii.pillRadius` | 999 |

Legacy `mdRadius`, `headerActionRadius` are chart/chrome only — not for new UI.

## Components

Use shared primitives from `flutter_app/lib/shared/widgets/` before creating
local widgets.

| Primitive | Use for |
| --- | --- |
| `VitAppShell`, `VitPageLayout`, `VitPageContent` | Page scaffold |
| `VitHeader`, `VitBottomNav` | Chrome |
| `VitCard` | Standard (16) and large (24) card surfaces |
| `VitCtaButton` | Primary/secondary CTAs |
| `VitInput` | Text fields |
| `VitTabBar`, `VitSegmentedTabBar` | Tab navigation — **no** wrapping in `VitCard` |
| `VitSegmentedChoice` | MUA/BÁN, Long/Short, 2–4 option toggles |
| `VitPresetChipRow` | Preset amount/% shortcuts — **no** card wrapper |
| `VitStatusPill`, `VitAccentPill` | Status badges (pill radius) |
| `VitEmptyState`, `VitErrorState`, `VitOfflineBanner` | Flow states |

Segment tabs and segmented choices render their own pill outline — do not add
extra bordered containers around them.

## Do's and Don'ts

**Do**

- Read this file (relevant sections) before generating or editing UI.
- Map every color, radius, spacing, and text style to existing theme tokens.
- Include loading, empty, error, offline, submitting, and success states when
  the flow requires them.
- Preview and confirm before high-risk financial actions.
- Keep Open Arena copy points-only; Prediction Markets may use positions/P/L.

**Don't**

- Invent new hex colors, radii, or font sizes outside theme files.
- Wrap `VitTabBar` / `VitSegmentedTabBar` in bordered `VitCard`.
- Use `VitCard` + `Row` + full-width pills for binary toggles — use
  `VitSegmentedChoice`.
- Duplicate local `_SegmentButton`, `_CommunityRules*`, or other widgets that
  already exist as `Vit*`.
- Use wallet/payout/profit language in Open Arena surfaces.
