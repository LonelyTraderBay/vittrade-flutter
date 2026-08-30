# Start Here

VitTrade is now a Flutter enterprise mono-repo. The former React/Vite app and
web screenshot baseline were removed on 2026-05-26.

## Required Reading Order

1. `AGENTS.md`
2. `.codex/README.md`
3. `docs/00_START_HERE.md`
4. `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`
5. `docs/01_AI_RULES/Two-Phase-Codex-Workflow.md` (Plan → Execute for large tasks)
6. `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`
7. `docs/02_FLUTTER_MIGRATION/Flutter-App-Foundation.md`
8. `docs/02_FLUTTER_MIGRATION/standards/Flutter-Native-Design-Standard.md`
9. `docs/02_FLUTTER_MIGRATION/standards/Flutter-Module-Identity-Standard.md`
10. `docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md`
11. `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md`
12. `docs/03_DESIGN_SYSTEM/Guidelines.md`
13. `DESIGN.md` (root — visual tokens and Vit* component ladder)
14. `docs/02_FLUTTER_MIGRATION/ke-hoac-tong-the.md` (status dashboard)
15. `docs/02_FLUTTER_MIGRATION/ke-hoach-san-sang-production.md` (production gaps)
16. `docs/02_FLUTTER_MIGRATION/checklists/Future-Feature-Onboarding-Checklist.md`
17. `docs/02_FLUTTER_MIGRATION/checklists/Enterprise-PR-Review-Checklist.md`
18. Screen- or module-specific references only when working on that area.

## Source Of Truth

- Flutter app package: `flutter_app/`
- App source: `flutter_app/lib/`
- Router facade: `flutter_app/lib/app/router/app_router.dart`
- Tests: `flutter_app/test/`
- Design rules: `docs/03_DESIGN_SYSTEM/Guidelines.md`
- Generated QA artifacts: `flutter_app/run-artifacts/`

## Current Architecture

```text
flutter_app/lib/
├── app/        # Bootstrap, router facade, theme
├── core/       # config, data (repository guards), navigation, network,
│               # product_flow (high-risk flow contracts), utils
├── features/   # Feature modules with domain/data/presentation layers
└── shared/     # Shared layout and design-system widgets
```

Screens live under `features/<feature>/presentation/pages/`. The router facade
keeps the public `createAppRouter`, `appRouter`, `AppRoutePaths`, and
`AppRouteNames` API while delegating implementation to router part files.

## Default Verification

Run from `flutter_app/`:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

Use emulator/device validation when layout, navigation, visual QA, or platform
behavior changes.

## Docs Map

| Path | Purpose |
| --- | --- |
| `AGENTS.md` | Active coding constraints for agents. |
| `.codex/README.md` | Codex session entrypoint and skill router. |
| `docs/INDEX.md` | Doc picker — which file to load per task (on-demand). |
| `DESIGN.md` | Visual token contract and component ladder for UI work. |
| `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md` | Execution rules after Flutter-only cleanup. |
| `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md` | Conflict resolution when docs disagree. |
| `docs/02_FLUTTER_MIGRATION/ke-hoac-tong-the.md` | Status dashboard; completed migrations summary. |
| `docs/02_FLUTTER_MIGRATION/ke-hoach-san-sang-production.md` | Production readiness checklist. |
| `docs/02_FLUTTER_MIGRATION/` | Flutter engineering standards, checklists, backend skeletons. |
| `docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md` | Map of every design-consistency audit domain — what enforces it, and the command to check it locally. |
| `docs/02_FLUTTER_MIGRATION/checklists/Future-Feature-Onboarding-Checklist.md` | Required checklist before adding a feature, route, high-risk flow, or large test surface. |
| `docs/02_FLUTTER_MIGRATION/checklists/Enterprise-PR-Review-Checklist.md` | Pull request review gates for architecture, router, product safety, and tests. |
| `.codex/skills/` | Codex workflow skills for planning, implementation, UI, audits, testing, and review. |
| `docs/03_DESIGN_SYSTEM/Guidelines.md` | Product and design rules. |
| `docs/05_ARCHITECTURE/VitTrade-Enterprise-Architecture-Report.md` | Architecture reference; Flutter source wins on conflict. |

## Retired Material

Any reference to React source, Vite tooling, root npm scripts, or
`output/flutter-ui-reference` is historical unless explicitly marked as current
Flutter guidance after 2026-05-26.
