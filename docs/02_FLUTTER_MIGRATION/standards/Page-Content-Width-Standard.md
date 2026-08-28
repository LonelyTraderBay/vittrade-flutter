# Page Content Width Standard (Mandatory)

**Authority:** [DESIGN.md](../../../DESIGN.md) Layout · [AGENTS.md](../../../AGENTS.md) UI rules · Home reference ([Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md))  
**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
**Enforcement:** `dart run tool/page_content_width_audit.dart --check` · `test/quality/page_content_width_guardrail_test.dart`  
**Reference screens:** `home_scroll_shell.dart` (Recipe A) · `profile_page.dart` (Recipe B)

Every standard scroll/detail page must share the same **horizontal content inset** so cards align with the top header and with sibling routes.

## Invariant

```text
contentWidth = viewportWidth - 2 × AppSpacing.contentPad   // 20px each side → 320px @ 360px
headerHorizontalInset = bodyHorizontalInset = contentPad
```

Header chrome uses `AppTopHeaderTokens.horizontalPadding = AppSpacing.contentPad` — body must not add a second horizontal `contentPad` on the `ScrollView → VitPageContent` chain.

## Six mandatory rules

| # | Rule |
| --- | --- |
| R1 | **One horizontal owner** — apply horizontal `contentPad` exactly **once** between screen edge and `VitPageContent` children. |
| R2 | **Recipe A (preferred, Home reference)** — `VitInsetScrollView(bottomInset: …)` or `SingleChildScrollView` with **bottom-only** padding → `VitPageContent(padding: compact\|default, fullBleed: false)`. References: `home_scroll_shell.dart`, `address_add_page.dart`, `referral_home_page.dart`. |
| R3 | **Recipe B (Profile reference)** — `SingleChildScrollView(padding: module*ScrollPadding` with horizontal `contentPad`) → `VitPageContent(fullBleed: true, padding: VitContentPadding.none)`. References: `profile_page.dart`, `p2p_dashboard_page.dart`. |
| R4 | **Never merge recipes** — do not combine horizontal scroll padding with a non-`fullBleed` `VitPageContent` (double inset). |
| R5 | **Token naming** — `*BottomScrollPadding` = bottom-only (Recipe A). `*PageScrollPadding` / `*ScrollPadding` with LTRB + horizontal `contentPad` = Recipe B (requires `fullBleed`). Example bottom-only: `marketScrollPadding` → `EdgeInsets.only(bottom: …)`. |
| R6 | **Flush exception** — chart/terminal/fullscreen-tool routes may be edge-to-edge; document with `// page-content-width: allow-flush` and do not use for normal list/card bodies. |

## Step checklist (new or changed page)

1. Pick Recipe A (default) or Recipe B.
2. Scroll layer: no horizontal `contentPad` when using Recipe A.
3. If scroll padding already includes horizontal `contentPad`, set `VitPageContent(fullBleed: true, padding: VitContentPadding.none)`.
4. Visually confirm first card aligns with header title @ 360×800.
5. Run `dart run tool/page_content_width_audit.dart --check` before merge.

## Anti-patterns

| Anti-pattern | Result |
| --- | --- |
| `referralPageScrollPadding` + `VitPageContent(padding: compact)` | 40px inset each side — body narrower than header |
| Hand-rolled `EdgeInsets.fromLTRB(contentPad, …, contentPad, …)` on scroll + default `VitPageContent` | Same double inset |
| `fullBleed: true` without horizontal scroll inset | Edge-to-edge body (P1 audit warn) |

## Limitations

- Static file heuristic — does not parse the widget tree; rare false positives if horizontal padding appears only in unrelated widgets in the same file.
- Recipe B vs A choice is not auto-enforced — only double-inset and obvious mismatches are gated.
- Full-repo remediation beyond the frozen baseline is tracked in the audit CSV; see **Upgrade path**.

## Upgrade path

1. Keep P0 baseline at 0 via `page_content_width_audit.dart --check` (done for current tree).
2. Optionally extend `VitInsetScrollView` with `topInset` to reduce Recipe B surface area.
3. Phone visual QA width asserts cover all 42 flows in `page_rhythm_phone_visual_qa_test.dart` (any `VitCard` in 318–322px @ 360).

## Verify

```bash
cd flutter_app
dart run tool/page_content_width_audit.dart          # regenerate MD + CSV
dart run tool/page_content_width_audit.dart --check  # CI: no regression past baseline
flutter test test/quality/page_content_width_guardrail_test.dart --reporter=compact
flutter test test/quality/page_rhythm_phone_visual_qa_test.dart --reporter=compact
```

## Related

- [Page-Rhythm-Standard.md](./Page-Rhythm-Standard.md) — vertical section rhythm (orthogonal to horizontal inset)
- [Flutter-Component-Mapping.md](../Flutter-Component-Mapping.md) — `VitInsetScrollView`, `VitPageContent`, `fullBleed`
- [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md) — §2 audit-domain map
