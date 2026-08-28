# Accent Icon Box Standard (Mandatory)

**Authority:** [DESIGN.md](../../../DESIGN.md) Layout · [AGENTS.md](../../../AGENTS.md) UI rules · [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md)  
**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
**Enforcement:** `flutter test test/quality/accent_icon_box_guardrail_test.dart`  
**Canonical widget:** `flutter_app/lib/shared/widgets/vit_accent_icon_box.dart` → `VitAccentIconBox`

Module **accent icon boxes** tint a row-leading icon with a shared 34px container — Rewards bonus rows, Arena summary cards, DCA schedule/rebalance headers, Unified Search module rows, P2P offer rows, and `VitTaskCard` mission icons all use the same visual family.

## Roles

| Element | Source | Rule |
| --- | --- | --- |
| Box size | `AppSpacing.accentIconBoxSize` | 34px (`buttonCompact`) |
| Fill | `AppSpacing.accentIconFillAlpha` | 0.14 tint of `color` |
| Border | `AppSpacing.accentIconBorderAlpha` | 0.24 tint of `color` |
| Radius | `AppRadii.mdRadius` | Matches Rewards/Arena bonus rows on the same scroll surface |
| Icon | `AppSpacing.iconMd` | Centered; optional `iconSize` override |
| Muted | `muted: true` | `AppColors.surface2` fill, no accent border (disabled rows) |

**Rule:** Do not hand-roll page-local `_AccentIcon` widgets. Use `VitAccentIconBox`.

## Wire pattern

```dart
VitAccentIconBox(
  icon: Icons.task_alt_outlined,
  color: AppModuleAccents.rewards,
)

// Disabled / inactive row
VitAccentIconBox(
  icon: Icons.flash_on_rounded,
  color: AppColors.text3,
  muted: true,
)
```

Pages pass `icon` + module accent `color` only — **no local DecoratedBox accent copies**.

## Tokens (mandatory)

| Token | Value | Use |
| --- | --- | --- |
| `accentIconBoxSize` | 34px | Box width/height |
| `accentIconFillAlpha` | 0.14 | Tinted fill |
| `accentIconBorderAlpha` | 0.24 | Accent border |
| `taskCardIconSize` | alias → `accentIconBoxSize` | Task card leading icon |

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `class _AccentIcon` in feature pages | Drifts from shared fill/border/radius |
| Per-module box sizes (40px, 42px) | Breaks scroll-surface visual family |
| `Material` + padding instead of bordered box | P2P/legacy pattern — migrate to shared widget |
| `inputRadius` / `cardRadius` on accent boxes | Wrong tier — use `mdRadius` only |
| Inline `alpha: .14` + `DecoratedBox` duplicates | Bypasses tokens and guardrails |

## Legacy tokens (deprecated)

`dcaScheduleAccentIconBox` (40px) and `discoveryAccentIconBox` (42px) remain as deprecated aliases for unrelated module sizing — **do not use for new accent icon boxes**. Use `accentIconBoxSize`.

## Verify

```bash
cd flutter_app
flutter test test/shared/widgets/vit_shared_widgets_test.dart --name "VitAccentIconBox"
flutter test test/quality/accent_icon_box_guardrail_test.dart --reporter=compact
flutter test test/quality/task_card_guardrail_test.dart --reporter=compact
flutter analyze
```

**Manual (360px):** Rewards (Nhiệm vụ + Bonus), Arena Points, DCA schedule, Unified Search, P2P Home — icon accent same size, same muted border, same corner radius.

## Related

- Task card icon: [Task-Card-Standard.md](./Task-Card-Standard.md)
- Module accent color: [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md)
- Rewards reference: `rewards_hub_page_part_02.dart` → `VitAccentIconBox` / `VitTaskCard`
- Discovery reference: `unified_search_shell.dart` → `VitAccentIconBox`
