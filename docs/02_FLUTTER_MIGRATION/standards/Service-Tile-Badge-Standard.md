# Service Tile Badge Standard (Mandatory)

**Authority:** [DESIGN.md](../../../DESIGN.md) Layout · [AGENTS.md](../../../AGENTS.md) UI rules · [Card-Tile-Standard.md](./Card-Tile-Standard.md) Tier B  
**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
**Enforcement:** `flutter test test/quality/service_tile_badge_guardrail_test.dart`  
**Canonical widget:** `flutter_app/lib/shared/widgets/vit_module_components.dart` → `VitServiceTile`

Corner badges on **Tier B** service tiles (`VitServiceTile` / `VitActionTileGrid`) must not collide with the centered icon + label. Risk disclosures (e.g. `Rủi ro cao`) stay readable and visually separate from product names (e.g. Launchpad).

## Roles

| Badge | Parameter | Corner | Color intent |
| --- | --- | --- | --- |
| State / module label | `badgeLabel` | Top-end | Module `accentColor` |
| Risk disclosure | `riskBadgeLabel` | Bottom-start | `AppColors.riskWarning` |

**Rule:** Do not hand-roll corner badges on pages. Use `VitServiceTile` (or extend it in `shared/widgets/`).

## Mandatory layout contract

1. **Corner badges stay `Positioned`** in the tile `Stack` — state top-end, risk bottom-start, with `serviceTileBadgeOffset` bleed.
2. **Center body uses safe inset** via `_contentSafeInsets` / `Padding` before `Center` — never place icon + label directly in the same layer as badges without inset.
3. **Risk badge reserves bottom + start** — `serviceTileBadgeReserveVertical` + `serviceTileBadgeReserveHorizontal`.
4. **State badge reserves top + end lightly** — `AppSpacing.x2` nudge only (state labels are short; do not use half badge width).
5. **Risk tiles compact the body** — when `riskBadgeLabel != null`, use compact icon metrics + `FittedBox(scaleDown)` so dual-badge tiles fit the grid cell.
6. **Grid aspect tokens own cell height** — `serviceTileGridAspectStandard` / `serviceTileGridAspectCompact`; do not fix overlap by one-off page padding.

## Tokens (mandatory)

| Token | Role |
| --- | --- |
| `serviceTileBadgeOffset` | Corner badge bleed (2px) |
| `serviceTileBadgeMaxWidth` | State badge max width (52) |
| `serviceTileRiskBadgeMaxWidth` | Risk badge max width (76) |
| `serviceTileBadgeReserveVertical` | Bottom/top safe band for label clearance |
| `serviceTileBadgeReserveHorizontal` | Start safe nudge when risk badge present |
| `serviceTileGridAspectStandard` | Standard grid cell aspect (1.42) |
| `serviceTileGridAspectCompact` | Compact / Home grid aspect (1.40) |

## Wire pattern

```dart
VitServiceTile(
  icon: Icons.rocket_launch_outlined,
  label: 'Launchpad',
  accentColor: accent,
  badgeLabel: 'Token',
  riskBadgeLabel: 'Rủi ro cao',
  onTap: onTap,
)
```

Pages pass data only — **no local `Stack` + `Positioned` badge copies**.

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `Center` icon + label with corner badges, no safe inset | Label overlaps risk badge (Launchpad bug) |
| Half badge width as horizontal inset | Shrinks label cell to unusable width |
| Page-local fixed-height badge rows | Bypasses shared tile; drifts from Tier B |
| Inline risk badge under label | Breaks corner disclosure pattern |
| Arbitrary `childAspectRatio` on one screen | Grid rhythm drift across modules |

## Verify

```bash
cd flutter_app
flutter test test/shared/widgets/vit_shared_widgets_test.dart --name "VitServiceTile corner badges"
flutter test test/quality/service_tile_badge_guardrail_test.dart --reporter=compact
flutter analyze
```

## Related

- Tier B card tiles: [Card-Tile-Standard.md](./Card-Tile-Standard.md)
- Module identity grids: [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md)
- Home reference: `home_products_section.dart` → `VitServiceTile`
