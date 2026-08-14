# Document Precedence

Use this order when documents disagree.

## Precedence Order

1. User instruction in the current conversation.
2. Root `AGENTS.md` for coding and repository constraints.
3. Applicable `.codex/skills/*/SKILL.md` for Codex workflow (does not override
   AGENTS.md product, financial, or architecture rules).
4. Active execution prompt for the current task scope only (does not override
   AGENTS.md product boundaries).
5. `docs/INDEX.md` for choosing which doc to load (picker only, not source of truth).
6. `docs/00_START_HERE.md` for the docs reading order.
7. Flutter source under `flutter_app/lib/`.
8. Flutter tests under `flutter_app/test/`.
9. `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md` for screen coverage
   tracking.
10. `docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md` as the
    required entry point for UI/UX regulation — routes to the correct
    `*-Standard.md` per domain (picker only; does not itself carry normative
    content beyond what those docs and their enforcing tools/tests define).
11. `docs/02_FLUTTER_MIGRATION/standards/Flutter-Native-Design-Standard.md` and
    `docs/02_FLUTTER_MIGRATION/standards/Flutter-Module-Identity-Standard.md` for UI rules.
12. `docs/03_DESIGN_SYSTEM/Guidelines.md` for product and design rules.
13. Screen-specific references under `docs/04_SCREEN_REFERENCES/`.
14. Architecture reports under `docs/05_ARCHITECTURE/`.

## Conflict Rules

- If docs conflict with current Flutter code and tests, inspect the code/tests
  first and update stale docs as part of the change when in scope.
- If a historical web-baseline note conflicts with Flutter-native design rules,
  Flutter-native design rules win.
- If a screen-specific reference conflicts with global product rules, follow the
  global rule unless the reference documents a deliberate exception.
- If an architecture report conflicts with current Flutter routing or
  repositories, current Flutter source wins.

## Artifact Rule

Generated outputs belong under `flutter_app/run-artifacts/` unless a tool has a
more specific Flutter-standard location. Do not recreate `output/flutter-ui-reference`.
