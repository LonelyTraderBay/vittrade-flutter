# Flutter Native Design Standard

**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
This file defines the active Flutter-native UI standard for VitTrade.

## Design Goals

- Trust-first financial UI.
- Clear boundaries between value surfaces and points-only/social surfaces.
- Fast scanning without hiding risk, fees, or confirmation states.
- Beginner-friendly defaults with pro controls available where appropriate.
- No dark patterns, hype, FOMO, or casino-style treatment.

## Global UI Rules

- Use dark theme tokens from `flutter_app/lib/app/theme/`.
- **Dark-only is a deliberate product decision** (2026-08-24, locked): a
  professional trading terminal reads best on one dark canvas; there is
  exactly one theme and no light mode to maintain. Do not add
  `ThemeData.light`, light-surface tokens, or theme-mode toggles — a
  light theme is a new product decision, not a UI task.
- Keep primary brand, app chrome, bottom navigation, shared cards, and primary
  CTAs globally consistent.
- Module identity is an accent layer only.
- Use shared primitives from `flutter_app/lib/shared/layout/` and
  `flutter_app/lib/shared/widgets/`.
- Avoid repeated hardcoded colors, radii, spacing, and control heights.
- Support phone-sized layouts first and verify text does not overlap controls.

## App Chrome

- `ShellRenderMode.native` is the default runtime mode.
- Respect OS safe areas.
- Use `VitAppShell`, `VitHeader`, `VitPageLayout`, `VitPageContent`, and
  `VitBottomNav` for standard screens.
- Detail pages should expose clear back behavior.
- High-risk flows should keep final CTAs stable and visible only after required
  previews/disclosures are satisfied.

## Financial Safety

- Withdrawals, escrow release, password/security changes, address creation, and
  payment-method changes need explicit confirmation.
- Show fee/risk/limit summaries before confirmation.
- Mask sensitive values by default where appropriate.
- Provide loading, empty, error, and offline states for networked surfaces.

## Domain Boundaries

- Prediction Markets: wallet/value positions, orders, probability, receipts, and
  P/L language are allowed.
- Open Arena: use Arena Points, pool diem, chot ket qua, thu thach; do not use
  wallet value, payout USD, profit, or stake-return language.

## Contrast floor (WCAG token pairs — locked 2026-08-24)

Text readability on the single dark canvas is a token property, not a
per-page concern. `test/quality/contrast_floor_guardrail_test.dart` parses
the literal color tokens from `app_colors.dart`, computes WCAG 2.x contrast
ratios for the core fg/bg pairs actually composed in the UI, and fails CI
when:

- a **standard pair** (text1/text2 on every surface, `primary`/`buy`/`sell`
  as text on surface) drops below **4.5:1** — someone changed a token value
  and silently made text unreadable; or
- a **known deviation** drops below its locked current floor (ratchet: may
  only improve; improving past 4.5 removes it from the debt list); or
- a listed token no longer resolves (rename/alias would silently gut the
  audit).

Current ratios (2026-08-24): text1/surface 17.2, text2/surface 8.4,
primary/surface 7.0, buy/surface 7.3, sell/surface 4.9 — all pass. The three
locked deviations:

| Pair | Ratio | Why it's debt, not a pass |
| --- | --- | --- |
| `text3` on `surface` | 3.71 (floor 3.6) | Tertiary/placeholder text below 4.5 — pay by lightening `text3` |
| `navCenterIcon` (white `onAccent`) on `primary` | 2.64 (floor 2.6) | White on the amber CTA — promotion candidate: dark text on amber, or a darker amber |
| `textDisabled` on `surface` | 2.95 (floor 2.85) | Disabled-control text is WCAG-exempt (inactive UI); floor exists only to block silent worsening |

Rule for new pairings: a **new** fg/bg token pairing intended for text
either meets 4.5:1 or enters the deviation list with a reason and a locked
floor — never ships silently below the floor. Large-text roles (≥18pt or
14pt bold) may argue 3.0:1 instead, stated in the pair entry.

## Verification

For UI changes:

```bash
cd flutter_app
flutter analyze
flutter test test/quality/contrast_floor_guardrail_test.dart --reporter=compact
flutter test
```

Then inspect the touched screen in emulator/device when visual behavior changed.
