# Motion Standard (Mandatory — phase 1: tablet surface)

**Authority:** [DESIGN.md](../../../DESIGN.md) Interaction · [AGENTS.md](../../../AGENTS.md) UI rules · [Tablet-Input-Standard.md](./Tablet-Input-Standard.md) (hover/focus are input states; their *timing* is motion)
**Enforcement:** `dart run tool/motion_audit.dart --check` · `test/quality/motion_guardrail_test.dart` (**absolute lock on the tablet surface — zero baseline**; phone keeps its current rules in phase 1 — see "Phases")
**Scope:** every Dart file under `lib/` on the **tablet surface** (path contains `/tablet/`, or the file name mentions `tablet`), excluding the `lib/app/theme/` token layer. Shared widgets adopt tokens opportunistically (they render on every surface).
**Born:** 2026-08-23 — before this standard the repo had **no motion tokens at all** (`lib/app/theme/` had zero duration/easing values): every animation picked its milliseconds by feel, the exact drift class spacing suffered before S1–S4. World-class systems (Material 3, IBM Carbon, Shopify Polaris) all ship a duration scale + easing scale + reduced-motion rule; this standard brings the tablet surface to that bar.

## Why this standard exists

Two `Duration(milliseconds: 180)` literals were all the motion the tablet surface had (KYC chevron rotation, VIP tab switcher) — clean, but undocumented and one pull-request away from a third page picking 150, then 220. Motion drift is invisible in review (the numbers look arbitrary-but-fine) and expensive to audit later, as the border-tint history proved (12 different alpha steps before the Card & Border standard). Locking the scale now, while the surface holds two literals, costs nothing.

## Rule 1 — Durations are role-based (M1)

Every animation duration comes from `AppMotion` (`lib/app/theme/app_motion.dart`):

| Role | Token | Value |
| --- | --- | --- |
| Micro feedback (press/hover tint, chip toggle) | `AppMotion.feedback` | 100ms |
| Element state (row expand, tooltip, fade) | `AppMotion.element` | 180ms |
| Surface (sheet, dialog, panel) | `AppMotion.surface` | 240ms |
| Scene (page transition, hero move) | `AppMotion.scene` | 320ms |

Pick by what is animating, not by how fast you feel like it. A new tier needs a *role* that recurs (name it, document it in the token file) — not a one-off number for one page. **`duration: Duration(milliseconds: …)` literals in tablet files are violations** (M1-literal-duration) — the surface is at zero and locked there.

**Not motion** (never flagged, never tokenized): mock repository / network delays (`Future.delayed`, `loadDelay:`), debounce timers, test pump durations.

## Rule 2 — Easing is direction-based (M2)

| Direction | Token | Curve |
| --- | --- | --- |
| Enter / reveal | `AppMotion.enter` | `easeOutCubic` — fast out, gentle settle |
| Emphasized scene change | `AppMotion.emphasized` | `easeInOutCubicEmphasized` |
| Exit / dismiss | `AppMotion.exit` | `easeInCubic` — quick away |

`Curves.` references in tablet presentation code are violations (M2-literal-curve). If a motion genuinely needs a new curve (e.g. a spring), that is a new *named token* in `AppMotion` with a role comment — not an inline `Curves.bounceIn`.

## Rule 3 — Reduced motion is respected (M3, behavioral)

Every animated widget resolves its duration through `AppMotion.respect(context, AppMotion.…)` so the OS "remove animations" accessibility setting collapses motion to instant state changes. Collapsing to instant must never break the UI: state still flips, layout still lands — only the tween disappears. Widget tests of animated shared widgets pump with `disableAnimations: true` once to prove it.

## Rule 4 — Tokens only (M4)

M1/M2 are the static teeth of this rule: durations and curves in tablet presentation code are `AppMotion.*` references or they fail CI. Shared widgets that already animate (`VitCtaButton`'s disabled fade → `AppMotion.element`) adopt the same tokens so all surfaces stay consistent.

## Rule 5 — Skeletons must not out-dance their data (M5, behavioral)

Loading skeletons shimmer at `feedback` cadence and resolve without reflow (the Tablet-Adaptive dashboard playbook already requires skeleton-mirrors-dashboard). Under reduced motion, shimmer freezes to static blocks — a moving skeleton that ignores the setting is a violation of intent even if no `Duration` literal is involved.

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `duration: const Duration(milliseconds: 150)` "just this once" | 150 is on no scale; the next page picks 160 (M1) |
| `curve: Curves.easeOutCubic` inline | The scale exists precisely so this isn't re-typed per page (M2) |
| One-off spring/bounce curve inline | New motion character = new named token with a role |
| 600ms fade because "it feels premium" | Scene tier is 320ms; slower reads as lag, not luxury |
| Animating layout-affecting properties when `respect()` returns `none` | Reduced motion must collapse cleanly, not half-run (M3) |
| Shimmer that ignores disable-animations | Skeletons are chrome, not content — they go first (M5) |

## Recipe for new tablet UI

1. What moves? feedback / element / surface / scene → pick the duration tier (Rule 1).
2. Which direction? enter / emphasized / exit → pick the curve (Rule 2).
3. Wrap the duration in `AppMotion.respect(context, …)` if the widget has a context (Rule 3).
4. Never write `Duration(` or `Curves.` in the file (Rule 4) — the scanner will catch it in CI.
5. Before commit: `dart run tool/motion_audit.dart --check` + `flutter test test/quality/motion_guardrail_test.dart`.

## Enforcement & phases

- **Phase 1 (this standard, 2026-08-23):** tablet surface absolute lock, born at 0 violations (the last two literals migrated in the same commit); `lib/app/theme/` exempt as the token layer.
- **Phase 2 (roadmap):** phone surface adopts the same tokens with a ratchet baseline (its literal count is larger; retiring it happens file-by-file as pages are touched, the Card & Border debt model). No new standard will be written for phase 2 — this doc simply widens scope.

## Verify

```bash
cd flutter_app
dart run tool/motion_audit.dart            # regenerate audit CSV
dart run tool/motion_audit.dart --check    # CI: artifact current
flutter test test/quality/motion_guardrail_test.dart --reporter=compact
```

## Migration pointers

- Audit: [VitTrade-Motion-Audit.csv](../audits/VitTrade-Motion-Audit.csv) (empty — locked at zero)
- Tokens: `lib/app/theme/app_motion.dart`
- Migrated at birth: `profile_kyc_pane.dart` (chevron rotation), `profile_vip_pane.dart` (tab switcher), `vit_cta_button.dart` (disabled fade, shared)
- Interaction states whose timing this governs: [Tablet-Input-Standard.md](./Tablet-Input-Standard.md)
