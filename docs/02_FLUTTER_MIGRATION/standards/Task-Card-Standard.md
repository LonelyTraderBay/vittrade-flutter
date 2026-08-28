# Task Card Standard (Mandatory)

**Authority:** [DESIGN.md](../../../DESIGN.md) Layout · [AGENTS.md](../../../AGENTS.md) UI rules · [Card-Tile-Standard.md](./Card-Tile-Standard.md) Tier E  
**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
**Enforcement:** `flutter test test/quality/task_card_guardrail_test.dart`  
**Canonical widget:** `flutter_app/lib/shared/widgets/vit_task_card.dart` → `VitTaskCard`

Mission / reward **task rows** (Rewards hub, Arena points) are **Tier E** list cards: intrinsic height, no fixed `minHeight`, content stacks from the top. Cards must not reserve empty space for CTAs that are not rendered (e.g. claimed tasks without a claim button).

## Roles

| Element | Source | Rule |
| --- | --- | --- |
| Card shell | `VitCard` | Intrinsic height only — no `height` / `constraints.minHeight` |
| Icon | `VitAccentIconBox` | Module accent via `accentColor` + `icon` |
| Status | `VitTaskCardStatus` → `VitStatusPill` sm | `Đang làm` / `Nhận` / `Đã nhận` |
| Progress | `_VitTaskCardProgressBar` | `taskCardProgressHeight` token |
| Reward row | Inline in `VitTaskCard` | Claimed = buy green; pending = warn |

**Rule:** Do not hand-roll page-local `_TaskCard` widgets. Use `VitTaskCard` (or extend it in `shared/widgets/`).

## Mandatory layout contract

1. **Intrinsic height** — `VitCard` with default `contentAlign: start`; column uses `mainAxisSize: min`.
2. **No legacy minHeight** — forbid `buttonHero + x7 + x5` (165px) and similar CTA-reserve formulas when no CTA row exists.
3. **Padding token** — `AppSpacing.taskCardPadding` (16px all sides).
4. **Inner gaps** — title→subtitle `taskCardTitleSubtitleGap`; before progress `taskCardProgressSectionGap`; after progress `taskCardRewardRowGap`.
5. **List spacing** — gap between cards uses `taskCardListGap` (8px).
6. **Subtitle clamp** — `taskCardSubtitleMaxLines` (3) with ellipsis.

## Tokens (mandatory)

| Token | Value | Use |
| --- | --- | --- |
| `taskCardPadding` | 16px | Card padding |
| `taskCardIconSize` | 34px (`accentIconBoxSize`) | Accent icon box via `VitAccentIconBox` |
| `taskCardProgressHeight` | 8px (`x3`) | Progress bar track |
| `taskCardTitleSubtitleGap` | 3px (`x1`) | Title → subtitle |
| `taskCardProgressSectionGap` | 13px | Subtitle → progress |
| `taskCardRewardRowGap` | 8px (`x3`) | Progress → reward row |
| `taskCardListGap` | 8px (`x3`) | Between cards in list |
| `taskCardSubtitleMaxLines` | 3 | Subtitle clamp |

## Wire pattern

```dart
VitTaskCard(
  key: RewardsHubPage.taskKey(task.id),
  title: task.title,
  subtitle: task.subtitle,
  progress: task.progress,
  rewardLabel: task.rewardLabel,
  status: VitTaskCardStatus.claimed,
  accentColor: AppModuleAccents.rewards,
  icon: Icons.task_alt_outlined,
)
```

Pages pass data and module accent only — **no local fixed-height `VitCard` task copies**.

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `minHeight: buttonHero + x7 + x5` on task rows | ~40% dead space when CTA absent (claimed tasks) |
| `contentAlign: center` with fixed minHeight | Content floats in oversized card |
| Duplicate `_TaskCard` in feature pages | Drifts from Tier E; bypasses shared progress/pill |
| Ad-hoc progress bar height per screen | Breaks visual rhythm across Rewards / Arena |
| Tier A strip tile tokens on task lists | Wrong tier — task rows are Tier E, not horizontal strips |

## Verify

```bash
cd flutter_app
flutter test test/shared/widgets/vit_shared_widgets_test.dart --name "VitTaskCard"
flutter test test/quality/task_card_guardrail_test.dart --reporter=compact
flutter analyze
```

## Related

- Card tile tiers: [Card-Tile-Standard.md](./Card-Tile-Standard.md)
- Rewards reference: `rewards_hub_page_part_02.dart` → `VitTaskCard`
- Arena reference: `arena_points_page_part_02.dart` → `VitTaskCard`
