---
name: vittrade-button-wiring-audit
description: Audit VitTrade Flutter onPressed and onTap handlers for dead buttons, while separating intentional disabled and dev-only states.
---

# Button-wiring audit

Use when reviewing button/data-flow wiring or checking for dead actions after a
UI batch. This is read-only: report findings and do not edit application code.
It complements route and navigation audits, which do not prove that a
non-navigation button actually performs an action.

## Scope

Default to one feature module, for example
`flutter_app/lib/features/<module>/`. Narrow to a page, widget directory, or
file list when the caller provides a scope. Exclude
`flutter_app/lib/features/dev/` unless explicitly requested.

## 1. Exhaustive candidate scan

From the repository root, scan the requested Dart scope for every candidate:

```text
onPressed:\s*\(\)\s*\{\s*\}
onTap:\s*\(\)\s*\{\s*\}
onPressed:\s*\(\)\s*async\s*\{\s*\}
onTap:\s*\(\)\s*async\s*\{\s*\}
onPressed:\s*null
onTap:\s*null
```

Do not sample. Record every match before classification.

## 2. Context classification

Read the enclosing widget/class, nearest comments and TODOs, route reachability
under `flutter_app/lib/app/router/route_groups/`, and sibling handlers.

- `broken`: an actionable product button is visibly enabled but has no action,
  with no conditional gate or explanation.
- `needs_review`: intent cannot be proved from the surrounding code.
- `legitimate`: a conditional terminal/disabled state, a widget that visibly
  renders disabled semantics, or an explicitly internal dev/demo surface.

Do not re-flag an unchanged candidate already classified in the existing
ledger; compare the file's latest commit when freshness matters.

## Output

Report a ledger with these sections:

```text
# Button-wiring audit - <scope> - <date>
## Broken (N)
## Needs review (N)
## Legitimate (N)
## Summary
```

For each finding include file, line, implied action, and the evidence for its
classification. Check for an existing
`flutter_app/run-artifacts/button-wiring-audit-<scope>-*.md` ledger and report
its age. Persist only when the caller requests it, using the documented
`flutter_app/run-artifacts/` naming convention.
