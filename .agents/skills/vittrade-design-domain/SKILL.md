---
name: vittrade-design-domain
description: Look up and verify VitTrade design-consistency domains before changing Flutter presentation code.
---

# Design-domain lookup

Before implementing or reviewing a UI batch:

1. Read the audit-domain table in
   `docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md`.
2. Match the task to the named domain instead of inventing an audit command.
3. Run the exact regenerate/check command and guardrail test listed there.
4. Keep the generated artifact diff limited to the expected design change.

Common mappings:

| Change | Domain |
| --- | --- |
| Section spacing or page scroll rhythm | `page-rhythm`, `page-content-width` |
| Horizontal cards or product tiles | `card-tile` |
| Tabs, filters, MUA/BÁN, presets | `segment-pill` |
| Success/error acknowledgement | `notice-acknowledgement` |
| Collapsing headers | `scroll-auto-hide` |
| Routes or `context.go`/`context.push` | `route-coverage`, `navigation-edges` |

The design-system reference is authoritative for command names, flags, and CI
blocking status. Read-only auditors report findings; the implementation task
owns the fix.
