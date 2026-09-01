# UI Rule Layer Map (Mandatory)

**Authority:** this map is the single lookup for *"which surface does this rule apply to?"* — it classifies every standard under `docs/02_FLUTTER_MIGRATION/standards/` into one of three layers (plus module-scoped conventions).
**Enforcement:** `test/quality/standards_scope_guardrail_test.dart` — every standard must carry a `**Scope:**` line with a layer label, and every standard file must appear in this map.
**Born:** 2026-08-28 — after the user flagged perceived contradictions between rules; the audit found no value conflicts, but 22 standards shipped without a Scope line and one table (Page-Rhythm hero tier) read as if it applied to tablet.

## The three layers

| Layer | Meaning | Who can change it |
| --- | --- | --- |
| **Chung (both surfaces)** | Applies to phone and tablet alike — shared vocabulary, tokens, components, page anatomy. | Anyone, via the normal standard process. |
| **Phone-only** | Binds the 360px phone composition only. | Phone work. |
| **Tablet-only** | Binds the tablet surface only (path `/tablet/` or file name mentions `tablet`). A tablet rule never overrides a chung rule — it narrows it for the surface. | Tablet work. |
| *(Module-scoped)* | Binds one feature's screens on both surfaces (e.g. Trade conventions). | That module's work. |

**Precedence when layers meet:** chung sets the floor; a surface standard may only *tighten* it for that surface (e.g. Typography is chung; Tablet-Spacing tightens which tokens each role uses). A surface standard may not loosen a chung rule. Differences between surfaces are allowed only as *disciplined* per-surface rules — never ad-hoc values.

## Layer index — all 33 standards

### Chung (both surfaces) — 24

| Standard | Notes |
| --- | --- |
| Flutter-Native-Design-Standard | Product-level visual principles. |
| Flutter-Module-Identity-Standard | 3-layer color model, module accents. |
| Flutter-Page-Archetype-Standard | Guidance archetypes, review checklist. |
| Typography-Standard | Explicitly surface-agnostic. |
| UI-Density-Standard | Fullscreen density audit, both surfaces. |
| Accent-Icon-Box-Standard | 34px accent icon boxes. |
| Top-Header-Standard | 4 audits scan app-wide. |
| Back-Navigation-Standard | 2 domains, app-wide. |
| Body-Component-Standard | Routed-screen body anatomy. |
| Page-Content-Width-Standard | Recipe A/B; tablet shells documented. |
| Page-Rhythm-Standard | Role→tier table is chung — **hero `relaxed` is phone-only** (PR-T1 bans it on tablet). |
| Device-UI-Organization-Standard | Folder contract phone\|tablet\|web. |
| Surface-Architecture-Standard | No cross-surface imports. |
| Card-Tile-Standard | Fixed-height tiles; on tablet also obey CB-R5 (radius tight). |
| Segment-Pill-Standard | `VitSegmentedTabBar` pills. |
| Service-Tile-Badge-Standard | Tier-B corner badges. |
| Task-Card-Standard | Tier-E intrinsic-height rows. |
| Bottom-Sheet-Standard | `showVitBottomSheet` only. |
| High-Risk-State-Standard | Risk chrome primitives. |
| Notice-Acknowledgement-Standard | Acknowledgement flow. |
| Scroll-Auto-Hide-Standard | Scrollbar visibility. |
| Scroll-Physics-Standard | Scroll feel. |
| Spacing-Token-Duplication-Standard | One role → one token. |
| Data-Table-Standard | "either surface" — financial tables. |

### Phone-only — 1

| Standard | Notes |
| --- | --- |
| Phone-Composition-Standard | 5 composition archetypes at 360px + phone↔tablet mapping. |

### Tablet-only — 6

| Standard | Notes |
| --- | --- |
| Tablet-Adaptive-Standard | R1–R9 surface contract, shells, tiers. |
| Tablet-Spacing-Gutter-Standard | S1–S7 + closed Base-8-derived role scale + Rule 5 token overrides. `TabletSpacingTokens` owns Tablet geometry; `AppSurfaceSpacing` is the surface-aware bridge for shared widgets. |
| Tablet-Card-Border-Standard | R1–R7 frames, radii, tints, card padding. |
| Tablet-Input-Standard | I1–I5 hover/focus states. |
| Home-Tablet-Reference-Contract | Home-as-reference extraction. |
| Motion-Standard | Phase 1: tablet absolute; phone 55 legacy items ratcheted (phase 2). |

### Module-scoped (Trade) — 2

| Standard | Notes |
| --- | --- |
| Trade-Header-Navigation-Conventions | Trade screens, both surfaces. |
| Trade-Hero-Section-Archetype-Standard | Trade hero section, both surfaces. |

## Known disciplined per-surface differences (not contradictions)

| Topic | Phone | Tablet |
| --- | --- | --- |
| Page rhythm — hero tier | `relaxed` allowed for hero/onboarding blocks. | `relaxed` banned (PR-T1); hub=compact, detail=standard, chart=flush. |
| Motion durations | Legacy `Duration(...)` ratcheted (55 items, shrink-only). | `AppMotion` tokens absolute. |
| Card frames | Current rules; tablet-grade frame rules may be adopted later. | VitCard-only, tint steps, CB-R1–R7. |
| Input hover/focus | Inherits via shared widgets (not enforced). | I1–I5 enforced. |
| Page horizontal inset | `contentPad` once (Recipe A/B). | Inside master-detail shells: `fullBleed` (S6) — the shell owns the gutter. |

The Tablet spacing contract is one governed surface system: 4dp is only the
alignment substrate; new UI may use only the named role values in
`Tablet-Spacing-Gutter-Standard.md`. It must not introduce a second free-form
4dp scale or read Phone `AppSpacing` directly.

## Verify

```bash
cd flutter_app
flutter test test/quality/standards_scope_guardrail_test.dart --reporter=compact
```

## Maintenance

Adding a new standard? Give it a `**Scope:**` line with one of the labels above *and* add a row to this map in the same commit — the guardrail fails CI otherwise.
