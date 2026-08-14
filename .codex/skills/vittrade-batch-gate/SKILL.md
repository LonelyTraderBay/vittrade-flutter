---
name: vittrade-batch-gate
description: Close a VitTrade implementation batch with a minimal-diff review, applicable design-domain audits, focused Flutter verification, and evidence.
---

# VitTrade batch completion gate

Use this after implementing a scoped Flutter batch and before reporting it
complete.

1. Review the batch diff with `vittrade-minimal-review` and trim safe bloat.
2. If the plan names design domains, read
   `vittrade-design-domain` and run the exact audit commands from
   `Flutter-Design-System-Reference.md`.
3. From `flutter_app/`, run at minimum:
   - `flutter analyze`
   - focused `flutter test` commands for touched modules
4. Run the broader route, shared-layout, repository, or full test gates when
   the changed scope requires them.
5. Report the exact commands and PASS/FAIL evidence.

## Refusal cases

- Do not report a batch complete when analyze or required tests fail.
- Do not expand into the next batch in the same session.
- Treat Windows line-ending or formatting failures as a diagnosis task; do
  not silently weaken the gate.
