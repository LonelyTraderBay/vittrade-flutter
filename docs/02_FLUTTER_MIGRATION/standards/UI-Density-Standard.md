# UI Density Standard

**Authority:** Derived from the `VitDensity` tier contract in
**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
`lib/app/theme/app_density.dart` and the chained audit logic in
`tool/ui_fullscreen_density_audit.dart` (fixed-size/local-literal debt per full
screen) and `tool/visual_density_risk_audit.dart` (cross-route visual-density
risk score) — not new policy.  
**Enforcement:** `dart run tool/ui_fullscreen_density_audit.dart --check` ·
`dart run tool/visual_density_risk_audit.dart --check` — both flags are real
(verified against arg parsing). Whole-app `--check` stays artifact-staleness
only and is **not** a day-1 CI fail gate while inventory is dirty.
**P0 ratchet (SDD B1):** guardrail
`test/quality/ui_density_p0_allowlist_guardrail_test.dart` runs
`dart run tool/ui_fullscreen_density_audit.dart --check-allowlist
--baseline=test/quality/ui_density_p0_allowlist_baseline.txt` and fails only
when an allowlisted route's live `density_score` exceeds its baseline max.
`visual_density_risk_audit.dart` remains audit-only (no allowlist gate yet).
See [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md) §2.  
**Reference screen(s):** `flutter_app/lib/features/home/presentation/pages/home_page.dart`
— the risk audit's own `PASS_MONITOR` / `low_signal_monitor` reference row
(official score 8, visual risk 8).

This is the authoritative home for the five `VitDensity` tiers and the two
chained density audits. `docs/03_DESIGN_SYSTEM/Guidelines.md` points here
instead of restating the tier table.

## VitDensity tiers

The five tiers in `VitDensityMetrics` (`lib/app/theme/app_density.dart`) are
the only sanctioned density vocabulary — there is no ad-hoc "medium spacing"
outside this enum. Each tier resolves to concrete pixel/token values, not
prose:

| Tier | Intent | Control height | Vertical rhythm | Card padding (h × v) | Page top padding | Page content gap |
| --- | --- | ---: | --- | --- | --- | --- |
| `.compact` | Dense root/list/card sections and repeated actions | 44 | `pageContentGapTight` | 12 × 12 | `pageContentTopCompact` | `pageContentGapTight` |
| `.standard` | Default behavior for existing screens | `AppSpacing.ctaHeight` (52) | `AppSpacing.x4` | `pageContentGapDefault` × `pageContentGapDefault` | `pageContentTopDefault` | `pageContentGapDefault` |
| `.relaxed` | Low-frequency informational or confirmation content | 58 | `AppSpacing.x5` | `AppSpacing.x5` × `AppSpacing.x5` | `pageContentTopRelaxed` | `pageContentGapRelaxed` |
| `.hero` | Intentional first-screen emphasis, used sparingly | 58 | `AppSpacing.x5` | `contentPad` × 24 | `pageContentTopDefault` | `pageContentGapDefault` |
| `.tool` | Fullscreen tools that need chrome-efficient controls | 44 | `pageContentGapTight` | 12 × `AppSpacing.x2` | `pageContentTopCompact` | `pageContentGapTight` |

`.hero` and `.standard` share top-padding/gap; `.compact` and `.tool` share
top-padding/gap too — each pair only diverges on control height and card
padding. Density fixes must preserve readable text, touch targets, semantics,
financial-safety copy, and Prediction Markets/Open Arena boundaries.
Fullscreen tool routes are a QA exception, not a generic-compaction target —
see both tools' `Tool`/`fullscreenTool` handling below.

## Tool 1 — UI Fullscreen Density Audit

`tool/ui_fullscreen_density_audit.dart` flags fixed-size and local-literal
density debt per routed screen.

- **Input:** `VitTrade-Body-Component-Consistency-Audit.csv`. Exits with code 1
  and a "run `body_component_consistency_audit.dart` first" message if that
  CSV is missing.
- **Signal source:** for each route, it re-reads the route's own source
  files (`source_files` column) and regex-counts, over the concatenated
  source:
  - `VitContentPadding.relaxed` occurrences (weight ×5)
  - `VitContentGap.loose` occurrences (weight ×6)
  - `VitContentGap.relaxed` occurrences (weight ×4)
  - `SizedBox(height: AppSpacing.(x8|x9|x10|x11|x12|pageContentGapLoose|pageContentTopRelaxed)` matches (weight ×2)
  - `Center(` occurrences (integer-divided by 4), `MainAxisAlignment.center` (÷3), `maxWidth:` (÷3), `ConstrainedBox` (×1)
- **Score:** `densityScore` = the weighted sum above **plus**:
  - grade penalty: body grade `B` → +8, `Tool` → +12, else 0
  - custom penalty: `max(customBodyCount - sharedComponentCount, 0)` clamped to 0–10
  - sparse penalty: +4 when `sectionHeader + VitCard` count < 3 **and**
    archetype is not `authOnboarding` or `fullscreenTool`
- **Priority:** body grade `Tool` → `P1_fullscreen_tool_visual_qa` (score
  irrelevant); else score ≥30 → `P1_density_refactor`; ≥10 →
  `P2_visual_density_review`; ≥8 → `P3_followup_review`; else
  `Pass_or_low_signal`.
- **`--check` mode:** regenerates markdown/CSV in memory and byte-compares
  them against the files on disk; fails if either is missing or stale. It does
  **not** assert a fixed route-count baseline (unlike Tool 2). Whole-repo
  staleness is intentionally separate from the P0 ratchet.
- **`--check-allowlist` mode (P0 ratchet):** live-scores routes listed in
  `--baseline=route,max_score` (optional `--routes=` subset). Fails only when
  a listed route is missing or `density_score` exceeds its max. Does **not**
  require markdown/CSV artifacts to be current — safe for CI before full-app
  density cleanup.

**Baseline (captured 2026-07-08):**

| Priority | Rule | Routes |
| --- | --- | ---: |
| `P1_density_refactor` | score ≥ 30 | 0 |
| `P1_fullscreen_tool_visual_qa` | body grade `Tool` | 5 |
| `P2_visual_density_review` | score ≥ 10 | 57 |
| `P3_followup_review` | score ≥ 8 | 56 |
| `Pass_or_low_signal` | else | 296 |
| **Total routed screens** | | **414** |

## Tool 2 — Visual Density Risk Audit

`tool/visual_density_risk_audit.dart` chains onto Tool 1's output to produce a
cross-route risk score. It reads **two** upstream CSVs:
`VitTrade-Body-Component-Consistency-Audit.csv` (from
`body_component_consistency_audit.dart`) and
`VitTrade-UI-Fullscreen-Density-Audit.csv` (from Tool 1 above) — it exits with
code 1 and a specific "run `<x>` first" message for whichever is missing.

- **Signal source:** same per-route source-file bundle as Tool 1, but 9
  independent regex counters (7 feed the score, 2 are diagnostic-only):
  - `tokenizedFixedHeightRefs` — `height: AppSpacing.*Height*`
  - `tokenizedGapRefs` — `SizedBox(height: AppSpacing.*(Gap|Spacing|Top|Bottom)`
  - `spacerRefs` — `Spacer(`
  - `manualContentRefs` — `customGap:` / `VitContentPadding.relaxed` / `VitContentGap.(loose|relaxed)`
  - `bottomInsetRefs` — `bottomInset`/`BottomInset`/`bottomChrome`/`BottomChrome`
  - `rootTopChromeRefs` — `VitTopChromeType.(rootModule|rootBrand)`
  - `detailTopChromeRefs` — `VitTopChromeType.detail` / `VitHeader(`
  - `scrollRefs`, `gridOrWrapRefs` — computed and reported in the CSV/markdown
    but **not** part of the score formula (diagnostic columns only)
- **Score:** `visualDensityRiskScore` = Tool 1's `officialDensityScore` +
  `tokenizedFixedHeightRefs×3` + `tokenizedGapRefs×2` + `spacerRefs×4` +
  `manualContentRefs×5` + `bottomInsetRefs×2` + `rootTopChromeRefs×3` +
  `detailTopChromeRefs×1`.
- **Priority:** archetype `fullscreenTool` → `P1_TOOL_VISUAL_QA` (score
  irrelevant); else score ≥60 → `P0_CRITICAL_DENSITY_REVIEW`; ≥40 →
  `P1_HIGH_DENSITY_REVIEW`; ≥25 → `P2_MEDIUM_DENSITY_REVIEW`; ≥10 →
  `P3_LOW_DENSITY_REVIEW`; else `PASS_MONITOR`.
- **`--check` mode:** in addition to the artifact byte-compare, it hard-asserts
  `entries.length == 414` — a literal count in source, not a config value.

**Baseline (captured 2026-07-08, matches committed reports):**

| Priority | Rule | Routes |
| --- | --- | ---: |
| `P0_CRITICAL_DENSITY_REVIEW` | risk score ≥ 60 | 9 |
| `P1_HIGH_DENSITY_REVIEW` | risk score 40–59 | 34 |
| `P1_TOOL_VISUAL_QA` | fullscreen tool archetype | 2 |
| `P2_MEDIUM_DENSITY_REVIEW` | risk score 25–39 | 104 |
| `P3_LOW_DENSITY_REVIEW` | risk score 10–24 | 182 |
| `PASS_MONITOR` | risk score < 10 | 83 |
| **Total routed screens** | | **414** |

### Root-cause factors (drive the priority rollup)

The tool tags every route with 0+ cause strings; 8 get a dedicated `root_*=`
line in the printed summary (some tags are merged pairs — a base threshold and
a "very_high" threshold rolled into one counter):

| `root_*` counter | Trigger | Baseline |
| --- | --- | ---: |
| `root_official_audit_blind_spot` | `officialDensityScore < 8` **and** `visualDensityRiskScore >= 25` — Tool 1's static regex found no debt, but Tool 2's broader signal set still flags real risk | 112 |
| `root_shared_component_compliant_but_sparse` | body grade `A` **and** `visualDensityRiskScore >= 25` — fully shared-component compliant, but still visually sparse | 109 |
| `root_tokenized_fixed_height_pressure` | `tokenizedFixedHeightRefs >= 4` (or `>= 8` for the "very_high" variant) | 0 |
| `root_vertical_gap_accumulation` | `tokenizedGapRefs >= 4` (or `>= 8` "very_high") | 234 |
| `root_spacer_driven_looseness` | `spacerRefs > 0` (or `>= 4` "loose_cards" variant) | 16 |
| `root_manual_content_density_bypass` | `manualContentRefs >= 2` | 0 |
| `root_bottom_nav_inset_pressure` | `bottomInsetRefs >= 2` | 195 |
| `root_top_chrome_first_viewport_cost` | `rootTopChromeRefs > 0` | 10 |

Three additional per-route cause tags exist in source but have **no**
dedicated `root_*=` summary line (they still appear in the per-route
`root_causes` CSV column): `source_file_unresolved` (a listed source file
could not be read), `fullscreen_tool_manual_visual_qa` (archetype is
`fullscreenTool`), and `low_signal_monitor` (fallback when no other cause
fires — this is what tags the Home reference row above).

## Exceptions

Tool 1 supports a **P0 score baseline file**
(`test/quality/ui_density_p0_allowlist_baseline.txt`) via `--check-allowlist`
— that is a ratchet max-score list, not a skip list. Neither tool has a
`// density: allow-start` comment marker convention (unlike
`Card-Tile-Standard.md`'s `// card-tile: allow-start` — grepped, none exists
here). The only structural scoring exception is archetype-driven:
`fullscreenTool` routes (Tool 2) and `Tool`-grade routes (Tool 1) always
route to their QA-visual-check priority regardless of score. Beyond that,
Tool 2's own generated report states the process requirement in prose only:
"Exceptions require a reason, route, owner feature, and emulator or
widget-test evidence" — there is no tool-level mechanism that skips a route
from scoring.

## Verify

```bash
cd flutter_app
dart run tool/body_component_consistency_audit.dart           # regenerate input CSV
dart run tool/body_component_consistency_audit.dart --check   # verify input CSV/markdown are current
dart run tool/ui_fullscreen_density_audit.dart                # regenerate UI-Fullscreen-Density-Audit.md/.csv
dart run tool/ui_fullscreen_density_audit.dart --check        # verify fullscreen density artifacts are current
dart run tool/ui_fullscreen_density_audit.dart --check-allowlist \
  --baseline=test/quality/ui_density_p0_allowlist_baseline.txt
flutter test test/quality/ui_density_p0_allowlist_guardrail_test.dart
dart run tool/visual_density_risk_audit.dart                  # regenerate Visual-Density-Risk-Audit.md/.csv
dart run tool/visual_density_risk_audit.dart --check          # verify risk artifacts current + total_routed_screens == 414
```

## Related

- [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md) — §2 audit-domain map (rows for all three chained audits)
- [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md) — Home reference consistency
- [Page-Rhythm-Standard.md](./Page-Rhythm-Standard.md) — vertical-rhythm tier per page, the layout-nesting counterpart to density
- [Card-Tile-Standard.md](./Card-Tile-Standard.md) — fixed-height tile tiers referenced by Tool 1's `sectionHeader`/`VitCard(` sparse-penalty signal
- `docs/03_DESIGN_SYSTEM/Guidelines.md` — "First-Viewport Density Gate" (now points here)
