# Flutter Native Design Standard

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

## Verification

For UI changes:

```bash
cd flutter_app
flutter analyze
flutter test
```

Then inspect the touched screen in emulator/device when visual behavior changed.
