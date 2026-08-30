---
name: vittrade-minimal-review
description: >
  VitTrade over-engineering review for diffs and batch self-checks. Finds local
  widgets that duplicate Vit* shared primitives, one-caller abstractions,
  unnecessary wrappers, and shrink opportunities. Respects financial safety,
  required migration scope, and guardrail tests. Use at batch completion gate,
  or when the user says "minimal review", "ponytail review batch", or
  "review diff for bloat".
---

Review the current diff (or batch diff) for unnecessary complexity. One line
per finding: location, what to cut, what replaces it. The best outcome is a
shorter diff that still passes the active plan gate.

## Format

`L<line>: <tag> <what>. <replacement>.` or `<file>:L<line>: ...` for multi-file.

Tags:

- `delete:` dead code, unused wrapper, speculative layer. Replacement: nothing.
- `yagni:` abstraction with one implementation, config nobody sets, helper with one caller.
- `shrink:` same behavior, fewer lines. Show the shorter form.
- `reuse-vit:` local widget/scaffold duplicating a shared primitive. Name the Vit* widget.

## Do not flag

- Financial preview/confirm flows, masked sensitive data, risk copy.
- Required migration from local widget to shared primitive (even if diff grows briefly).
- Loading, empty, error, offline, submitting, success states required by plan or AGENTS.md.
- Guardrail tests under `flutter_app/test/quality/` and focused tests the plan requires.
- Arena points-only / Prediction Markets copy corrections.

## Scoring

End with: `net: -<N> lines possible.` or `Lean already. Ship.`

## Batch gate (automatic)

When invoked by batch completion (no user prompt):

1. List findings only for **this batch's diff**.
2. Apply safe trims inline in the same turn (delete wrapper, inline one-caller helper).
3. Re-run `flutter analyze` and focused tests before marking batch complete.
4. Do not defer trims to a follow-up chat unless blocked after recovery attempts.

## Boundaries

Complexity only — correctness, security, and product-boundary bugs go to
`.codex/skills/code-review-and-quality/SKILL.md`. Lists findings; batch gate
may apply safe trims. Does not run whole-repo audit.
