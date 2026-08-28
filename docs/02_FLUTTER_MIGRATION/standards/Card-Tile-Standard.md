# Card Tile Standard (Mandatory)

**Authority:** [DESIGN.md](../../../DESIGN.md) Layout · [AGENTS.md](../../../AGENTS.md) UI rules  
**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
**Enforcement:** `dart run tool/card_tile_audit.dart --check` · `test/quality/card_tile_guardrail_test.dart`  
**Reference screen:** `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart`

Card tiles define **when a `VitCard` gets a fixed height and vertical centering** — so horizontal strip tiles (Home “Gần đây”, market ticker) stay optically balanced without per-page `Column` hacks. On the tablet surface a fixed-height card is a control surface and must also declare `radius: VitCardRadius.tight` (Tablet-Card-Border CB-R5 — 16 on a ~34dp tile reads as a pill).

## Five tiers

| Tier | Pattern | Fixed height? | `contentAlign.center`? | Canonical widget |
| --- | --- | --- | --- | --- |
| **A** | Horizontal strip tile | Yes (`height` or `minHeight`) | Yes | `VitCompactProductCard`, `VitMarketTickerCard` |
| **B** | Grid / service tile | Via aspect ratio | Internal `Center`, not `VitCard` | `VitServiceTile`, `VitActionTileGrid` |
| **C** | Horizontal row card | No (intrinsic) | No | `VitNextActionCard`, `VitDiscoveryActionCard` |
| **D** | Hero / portfolio block | No (intrinsic) | No | Portfolio hero `VitCard`, large-radius surfaces |
| **E** | List container / mission task row | No (intrinsic) | No | Market list `VitCard`, `VitTaskCard` |

**Tier B badge rule:** corner badges (`badgeLabel`, `riskBadgeLabel`) require safe inset on the centered body — see [Service-Tile-Badge-Standard.md](./Service-Tile-Badge-Standard.md).

**Tier E task row rule:** mission / reward task cards use intrinsic height via `VitTaskCard` — see [Task-Card-Standard.md](./Task-Card-Standard.md).

**Rule:** Only **Tier A** strip tiles use `VitCard.height` / `constraints.minHeight` **with** `contentAlign: VitCardContentAlign.center`.

## Tier A tokens (mandatory)

| Token | Value | Use |
| --- | --- | --- |
| `AppSpacing.cardTilePadding` | 12×5 directional | Tier A `VitCard` padding |
| `AppSpacing.cardTileInnerGap` | 5px (`pageRhythmCompactInnerGap`) | Icon → title → subtitle inside tile |
| `AppSpacing.homeRecentProductHeight` | 86px | Recent product strip slot |
| `AppSpacing.homeRecentProductWidth` | 146px | Recent product strip width |
| `AppSpacing.homeMarketTickerCardMinHeight` | 74px | Ticker tile minimum height |
| `AppSpacing.homeMarketTickerCardWidth` | 146px | Ticker tile width |

ListView / strip **slot height** must match the tile token (`homeRecentProductHeight`), not ad-hoc `buttonStandard + x6`.

## Six mandatory rules

1. **Tier A only for strip tiles** — Do not set `VitCard.height` or `minHeight` on scroll/detail/list containers (Tier D/E).
2. **Center via `VitCard`** — Tier A uses `contentAlign: VitCardContentAlign.center`; do not hand-roll `Column(mainAxisAlignment: center)` on pages.
3. **Shared widgets first** — New strip tiles extend `shared/widgets/` (`VitCompactProductCard` pattern); pages consume widgets, not raw fixed-height `VitCard`.
4. **Padding tokens** — Tier A uses `cardTilePadding` and `cardTileInnerGap`; avoid duplicate module padding tokens for the same role.
5. **Slot = token** — Horizontal `ListView` / `SizedBox` extent equals the tile height token.
6. **Skeleton parity** — Loading skeletons mirror loaded tile dimensions (same height/width tokens).

## Wire pattern (Tier A)

```dart
VitCard(
  height: AppSpacing.homeRecentProductHeight,
  contentAlign: VitCardContentAlign.center,
  padding: AppSpacing.cardTilePadding,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      // icon row …
      const SizedBox(height: AppSpacing.cardTileInnerGap),
      // title …
    ],
  ),
)
```

## Home inventory (reference)

| Surface | Tier | Widget |
| --- | --- | --- |
| Gần đây strip | A | `VitCompactProductCard` |
| Market ticker strip | A | `VitMarketTickerCard` |
| Sản phẩm grid | B | `VitServiceTile` / `VitActionTileGrid` |
| Tiếp theo | C | `VitNextActionCard` |
| Dự đoán & Thách đấu | C | `VitDiscoveryActionCard` |
| Portfolio hero | D | `VitCard` large, intrinsic height |
| Thị trường list | E | `VitCard` clip list, intrinsic height |
| Rewards / Arena tasks | E | `VitTaskCard` |

## Allowed exceptions

Document in code:

```dart
// card-tile: allow-start — scroll card with minHeight for tap target only
```

Allowed without comment: `/dev/*`, progress bars, pills, non-`VitCard` `BoxConstraints`.

### Exception matrix (baseline inventory)

| Pattern | Tier | Action |
| --- | --- | --- |
| Horizontal strip product/ticker tile | A | `contentAlign.center` + `cardTilePadding` (canonical widget) |
| Horizontal strip chip/preset (Arena quick chip, market screener preset) | A | `contentAlign.center`; module padding OK when inner layout centers |
| Fixed chart/stat grid cell (Fear & Greed, P2P stat) | D | `// card-tile: allow-start` |
| Square icon/back button card | E | `// card-tile: allow-start` |
| List container `clip: true` | E | No fixed height — pass |

Bulk baseline for non-strip fixed height: `dart run tool/card_tile_baseline.dart` (from audit warn rows).

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `VitCard(height: …)` without `contentAlign.center` | Top-heavy tile padding (Home BTC/USDT bug) |
| `buttonStandard + x6` strip slot | Drifts from `homeRecentProductHeight` (86 vs 89) |
| `EdgeInsets.all(12)` on Tier A tiles | Use `cardTilePadding` (12×5) for vertical balance |
| Page-local fixed-height `VitCard` | Bypasses shared tile; duplicates regulation |
| `Column(mainAxisAlignment: center)` inside Tier A page | Centering belongs on `VitCard` |

## Verify

```bash
cd flutter_app
dart run tool/card_tile_audit.dart          # regenerate audit CSV + compliance report
dart run tool/card_tile_audit.dart --check  # CI: artifact current
dart run tool/card_tile_manifest.dart       # regenerate migration manifest
dart run tool/card_tile_baseline.dart       # apply allow-start to warn rows (one-time)
flutter test test/quality/card_tile_guardrail_test.dart --reporter=compact
```

## Migration pointers

- Audit: [VitTrade-Card-Tile-Audit.csv](../audits/VitTrade-Card-Tile-Audit.csv)
- Manifest: [VitTrade-Card-Tile-Migration-Manifest.csv](../audits/VitTrade-Card-Tile-Migration-Manifest.csv)
- Report: [Card-Tile-Compliance-Report.md](../audits/Card-Tile-Compliance-Report.md)
- Execution plan (archived): [Card-Tile-Migration-Execution-Plan.md](../../_archive/2026-migrations-closed/Card-Tile-Migration-Execution-Plan.md)
- Checklist (archived): [Card-Tile-Migration-Checklist.md](../../_archive/2026-migrations-closed/Card-Tile-Migration-Checklist.md)
- Page rhythm (section gaps): [Page-Rhythm-Standard.md](./Page-Rhythm-Standard.md)
