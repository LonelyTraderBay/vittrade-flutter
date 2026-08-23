# VitTrade Docs Index

**Last Updated:** 2026-08-15 (Codex-only workflow; archive completed playbooks → `docs/_archive/`)

Load docs **on demand** — do not paste large audit output into chat. Shared rules:
[AI_PROMPT_SHELL.md](01_AI_RULES/AI_PROMPT_SHELL.md).

## Always-on (short)

| File | When |
| --- | --- |
| [AGENTS.md](../AGENTS.md) | Every session (workspace rule) |
| [.codex/README.md](../.codex/README.md) | Codex entrypoint and skill router |
| [DESIGN.md](../DESIGN.md) | UI work — tokens + component ladder |
| [00_START_HERE.md](00_START_HERE.md) | First time / architecture |
| [AI_EXECUTION_CONTRACT.md](01_AI_RULES/AI_EXECUTION_CONTRACT.md) | Execution gate |
| [Two-Phase-Codex-Workflow.md](01_AI_RULES/Two-Phase-Codex-Workflow.md) | Plan → Execute batches; copy-paste prompts |
| [DOCUMENT_PRECEDENCE.md](01_AI_RULES/DOCUMENT_PRECEDENCE.md) | Doc conflicts |

## Status and remaining work

| File | When |
| --- | --- |
| [ke-hoac-tong-the.md](02_FLUTTER_MIGRATION/ke-hoac-tong-the.md) | Project dashboard + completed migration summary |
| [ke-hoach-san-sang-production.md](02_FLUTTER_MIGRATION/ke-hoach-san-sang-production.md) | Production readiness — what is done vs blocked |

## Flutter standards

| File | When |
| --- | --- |
| [Flutter-Design-System-Reference.md](02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md) | **Required entry point for all UI/UX work** — routes to every domain's `*-Standard.md`, what enforces it, and the command to check it locally |
| [Flutter-App-Foundation.md](02_FLUTTER_MIGRATION/Flutter-App-Foundation.md) | App bootstrap, layers |
| [Flutter-Native-Design-Standard.md](02_FLUTTER_MIGRATION/standards/Flutter-Native-Design-Standard.md) | Native UI rules |
| [Flutter-Module-Identity-Standard.md](02_FLUTTER_MIGRATION/standards/Flutter-Module-Identity-Standard.md) | Module accents |
| [Flutter-Page-Archetype-Standard.md](02_FLUTTER_MIGRATION/standards/Flutter-Page-Archetype-Standard.md) | Tabbed-detail / form-wizard page patterns |
| [Phone-Composition-Standard.md](02_FLUTTER_MIGRATION/standards/Phone-Composition-Standard.md) | Mandatory phone composition: one-column grammar + module composition archetypes (foundation cứng vs khác biệt theo nghề module) |
| [Tablet-Adaptive-Standard.md](02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md) | Mandatory dedicated tablet layouts (R1–R9 + module composition archetype table) |
| [Tablet-Spacing-Gutter-Standard.md](02_FLUTTER_MIGRATION/standards/Tablet-Spacing-Gutter-Standard.md) | Mandatory tablet token-locked spacing/gutters (S1–S4, absolute) |
| [Tablet-Card-Border-Standard.md](02_FLUTTER_MIGRATION/standards/Tablet-Card-Border-Standard.md) | Mandatory tablet card frames + 3-step border tints (R1–R3, absolute) |
| [Tablet-Input-Standard.md](02_FLUTTER_MIGRATION/standards/Tablet-Input-Standard.md) | Mandatory tablet hover/focus/traversal tokens (I1–I5, absolute) |
| [Motion-Standard.md](02_FLUTTER_MIGRATION/standards/Motion-Standard.md) | Mandatory motion duration/easing tokens + reduced motion (M1–M5; phase 1 = tablet) |
| [Home-Tablet-Reference-Contract.md](02_FLUTTER_MIGRATION/standards/Home-Tablet-Reference-Contract.md) | Tablet reference contract extracted from Home (reusable vs Home-only patterns) |
| [Flutter-Port-Master-Plan.md](02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md) | Screen coverage tracker |
| [Flutter-Migration-Execution-Runbook.md](02_FLUTTER_MIGRATION/checklists/Flutter-Migration-Execution-Runbook.md) | Standard workflow |
| [Flutter-Design-Tokens.md](02_FLUTTER_MIGRATION/Flutter-Design-Tokens.md) | Token file map |
| [Flutter-Component-Mapping.md](02_FLUTTER_MIGRATION/Flutter-Component-Mapping.md) | Vit* widget ladder |
| [Page-Rhythm-Standard.md](02_FLUTTER_MIGRATION/standards/Page-Rhythm-Standard.md) | Mandatory page spacing / rhythm |
| [Page-Rhythm-Visual-QA-Checklist.md](02_FLUTTER_MIGRATION/checklists/Page-Rhythm-Visual-QA-Checklist.md) | 360px visual QA flows (Phase 6 — 12 flows) |
| [Card-Tile-Standard.md](02_FLUTTER_MIGRATION/standards/Card-Tile-Standard.md) | Mandatory fixed-height card tiles |
| [Service-Tile-Badge-Standard.md](02_FLUTTER_MIGRATION/standards/Service-Tile-Badge-Standard.md) | Mandatory Tier B corner badge safe inset |
| [Task-Card-Standard.md](02_FLUTTER_MIGRATION/standards/Task-Card-Standard.md) | Mandatory Tier E mission task rows (`VitTaskCard`) |
| [Accent-Icon-Box-Standard.md](02_FLUTTER_MIGRATION/standards/Accent-Icon-Box-Standard.md) | Mandatory module accent icon boxes (`VitAccentIconBox`) |
| [Segment-Pill-Standard.md](02_FLUTTER_MIGRATION/standards/Segment-Pill-Standard.md) | Mandatory segment/tab/filter pill tiers (S1–S4) |
| [Card-Tile-Compliance-Report.md](02_FLUTTER_MIGRATION/audits/Card-Tile-Compliance-Report.md) | Card tile audit status (993/993 pass) |
| [Top-Header-Standard.md](02_FLUTTER_MIGRATION/standards/Top-Header-Standard.md) | Mandatory header behavior/actions/global-access/visual-archetype (4 sub-domains) |
| [Back-Navigation-Standard.md](02_FLUTTER_MIGRATION/standards/Back-Navigation-Standard.md) | Mandatory back-control safe fallback + Home-entry contract |
| [Bottom-Sheet-Standard.md](02_FLUTTER_MIGRATION/standards/Bottom-Sheet-Standard.md) | Mandatory `showVitBottomSheet` usage |
| [Scroll-Physics-Standard.md](02_FLUTTER_MIGRATION/standards/Scroll-Physics-Standard.md) | Mandatory `ClampingScrollPhysics` everywhere |
| [Scroll-Auto-Hide-Standard.md](02_FLUTTER_MIGRATION/standards/Scroll-Auto-Hide-Standard.md) | Mandatory collapse-budget gate for scroll-to-hide headers (no short-list snap-back) |
| [High-Risk-State-Standard.md](02_FLUTTER_MIGRATION/standards/High-Risk-State-Standard.md) | Mandatory `VitHighRiskStatePanel` for the 8 named high-risk pages |
| [Body-Component-Standard.md](02_FLUTTER_MIGRATION/standards/Body-Component-Standard.md) | Body layout/surface/controls/state grading (audit-only, not yet CI-enforced) |
| [UI-Density-Standard.md](02_FLUTTER_MIGRATION/standards/UI-Density-Standard.md) | `VitDensity` tiers + visual density risk (audit-only, not yet CI-enforced) |
| [Spacing-Token-Duplication-Standard.md](02_FLUTTER_MIGRATION/standards/Spacing-Token-Duplication-Standard.md) | Per-module literals that duplicate a core `AppSpacing.x1..x7` scale step |
| [Guidelines.md](03_DESIGN_SYSTEM/Guidelines.md) | Product + design rules |

## Ponytail audit (over-engineering)

| File | When |
| --- | --- |
| [ke-hoach-ponytail-audit-toan-module.md](02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md) | Audit từng module v2.1 — khối HANDOFF Section 1.2 + bảng prompt Section 13 |
| `.codex/skills/ponytail-audit/SKILL.md` | Skill ledger-only (không fix trong audit turn) |
| `.codex/skills/vittrade-minimal-review/SKILL.md` | Fix batch sau audit |

## Codex workflow skills

Load only the skill needed for the current task. `AGENTS.md` remains the
project contract and the skill files provide focused procedures.

| Skill | When |
| --- | --- |
| `.codex/skills/planning-and-task-breakdown/SKILL.md` | Break down ambiguous or multi-file work |
| `.codex/skills/incremental-implementation/SKILL.md` | Implement and verify changes in small slices |
| `.codex/skills/frontend-ui-engineering/SKILL.md` | Build or redesign Flutter UI |
| `.codex/skills/ui-ux-pro-max/SKILL.md` | Deep UI/UX direction and searchable design intelligence |
| `.codex/skills/vittrade-ui-checklists/SKILL.md` | Review accessibility, density, states, motion, and shared primitives |
| `.codex/skills/vittrade-design-domain/SKILL.md` | Select exact design audit commands |
| `.codex/skills/vittrade-product-verify/SKILL.md` | Verify high-risk financial flows |
| `.codex/skills/vittrade-button-wiring-audit/SKILL.md` | Find dead or ambiguously wired button handlers |
| `.codex/skills/vittrade-minimal-review/SKILL.md` | Trim over-engineering from a diff |
| `.codex/skills/code-review-and-quality/SKILL.md` | Pre-merge correctness, architecture, security, and performance review |
| `.codex/skills/security-and-hardening/SKILL.md` | Security review and hardening |
| `.codex/skills/test-driven-development/SKILL.md` | Test-first behavior changes |
| `.codex/skills/gitnexus-cli/SKILL.md` | Index/status/maintenance commands |

## Checklists

| File | When |
| --- | --- |
| [Future-Feature-Onboarding-Checklist.md](02_FLUTTER_MIGRATION/checklists/Future-Feature-Onboarding-Checklist.md) | New feature / route |
| [Enterprise-PR-Review-Checklist.md](02_FLUTTER_MIGRATION/checklists/Enterprise-PR-Review-Checklist.md) | Pre-merge review |
| [Flutter-Manual-Smoke-Checklist.md](02_FLUTTER_MIGRATION/checklists/Flutter-Manual-Smoke-Checklist.md) | Manual QA |
| [Flutter-Visual-QA.md](02_FLUTTER_MIGRATION/checklists/Flutter-Visual-QA.md) | Visual QA notes |

## Backend handoff

| File | When |
| --- | --- |
| `docs/02_FLUTTER_MIGRATION/*-Backend-Contract-Skeleton.md` | Remote API integration per module |

## Architecture

| File | When |
| --- | --- |
| [VitTrade-Enterprise-Architecture-Report.md](05_ARCHITECTURE/VitTrade-Enterprise-Architecture-Report.md) | Architecture reference |
| [decisions/README.md](05_ARCHITECTURE/decisions/README.md) | Architecture Decision Records (ADR) — vì sao một quyết định kiến trúc được chốt |

## Screen references (on demand)

| File | When |
| --- | --- |
| [HomePage-Flutter-Native-Standard.md](04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md) | Home module work |
| [IA Route Entry Point Map](02_FLUTTER_MIGRATION/audits/IA-Route-Entry-Point-Map/00-INDEX.md) | Living IA wireframes + route map |
| [GD4-Async-Playbook.md](02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md) | Living async/error idiom (A+) |
| [_archive/README.md](_archive/README.md) | Completed redesign / IA / A+ / migration playbooks (66/66, P0–P6, etc.) |

## Audit tools (run from `flutter_app/`)

Prefer tools over static markdown dumps:

```bash
dart run tool/design_token_consistency_audit.dart --check
dart run tool/body_component_consistency_audit.dart --check
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
```

Generated CSV/MD artifacts live under `docs/02_FLUTTER_MIGRATION/audits/` (not
the `02_FLUTTER_MIGRATION/` top level — verified against the tools' own
`docsDir.path` construction, e.g. `tool/design_token_consistency_audit.dart:154-159`).

## Codex workflow setup

| Resource | Purpose |
| --- | --- |
| `.codex/skills/` | Repo-local Codex skills and VitTrade procedures |
| `AGENTS.md` | Project contract and Codex workflow authority |
| `docs/01_AI_RULES/Two-Phase-Codex-Workflow.md` | Plan → Execute batch discipline |
| `.gitnexus/` | Local GitNexus graph cache (ignored) |

Policy: use the smallest applicable Codex skill, GitNexus impact before symbol
changes, and `detect_changes` before commits.

## Removed / archived docs (2026-07-23)

Repo cleanup (phương án C). Summary also in
[ke-hoac-tong-the.md](02_FLUTTER_MIGRATION/ke-hoac-tong-the.md) § Completed
migrations. Full history: `git log -- docs/`.

### Deleted (stubs / orphans)

- `02_FLUTTER_MIGRATION/prompt-redesign/CHECKLIST-26-PENDING-BATCHES.md`
- `02_FLUTTER_MIGRATION/prompt-redesign/EXECUTION-PENDING-26.md`
- `02_FLUTTER_MIGRATION/prompt-redesign/EXECUTION-PENDING-4-LAST.md`
- `02_FLUTTER_MIGRATION/prompt-redesign/EXECUTION-PENDING-FINAL.md`
- `02_FLUTTER_MIGRATION/prompt-redesign/prompt-redesign-trading-bots-hub-sc059.md`
- `02_FLUTTER_MIGRATION/redesign/VitTrade-Screen-Redesign-Checklist.md`
- `02_FLUTTER_MIGRATION/Flutter-Enterprise-100-Percent-File-Action-Manifest.csv`
- `02_FLUTTER_MIGRATION/VitTrade-Card-Tile-Debt-Audit.csv`
- `02_FLUTTER_MIGRATION/VitTrade-Dark-Professional-Flow-Reorder-Matrix.csv`
- `02_FLUTTER_MIGRATION/VitTrade-Product-Capability-Inventory.csv`

### Archived under [`docs/_archive/`](_archive/README.md)

- Redesign v2.5 hubs + playbook + CSVs → `_archive/2026-redesign-v2.5/`
- IA/UI-UX reorg playbook + gates → `_archive/2026-ia-ux-reorg/`
  (wireframes `17–26`, `00-INDEX`, `99-ALL-ROUTES` stay active)
- A+ assessment / playbook / manifests → `_archive/2026-a-plus-closed/`
  ([GD4-Async-Playbook.md](02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md) stays active)
- Card-tile / segment-pill / notice / hub-reorg plans → `_archive/2026-migrations-closed/`

### Earlier removals (still true)

- 2026-07-16: top-level duplicate `VitTrade-Screen-Redesign-Checklist.csv`/`.md`;
  `03_DESIGN_SYSTEM/VitTrade-Whole-App-P2-P3-Assignment-Ledger.csv`.
