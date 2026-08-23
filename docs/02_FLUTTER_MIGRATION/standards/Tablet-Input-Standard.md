# Tablet Input Modality Standard (Mandatory)

**Authority:** [DESIGN.md](../../../DESIGN.md) Interaction · [AGENTS.md](../../../AGENTS.md) UI rules · [Tablet-Adaptive-Standard.md](./Tablet-Adaptive-Standard.md) (R9 header, master-detail)
**Enforcement:** `dart run tool/tablet_input_audit.dart --check` · `test/quality/tablet_input_guardrail_test.dart` (**absolute lock — zero baseline**)
**Scope:** every Dart file under `lib/` on the **tablet surface** (path contains `/tablet/`, or the file name mentions `tablet`). Shared widgets live outside the scan but carry the sanctioned mechanism (Q3: tokens ship in shared widgets so all surfaces benefit; the *rules* lock tablet first).
**Born:** 2026-08-23 — closes the biggest gap vs world-class adaptive guidance (Material 3 treats *input* as a first-class pillar beside layout; Apple HIG requires pointer + keyboard handling on iPad-class devices): the tablet surface shipped with zero hover states, no visible keyboard-focus affordance, and no traversal contract.

## Why this standard exists

A tablet is routinely driven with a mouse/trackpad (DeX, iPad Magic Keyboard, emulator development) and increasingly by keyboard-only users. Before this standard the surface was touch-only: `InkWell`s rendered with theme-default (near-invisible) hover/focus overlays, inputs kept a static border whether focused or not, and nothing defined what tab order or shortcuts must do. This standard fixes the token map (hover fill, focus fill, focus border), the mechanism (shared widgets, never per-page plumbing), and the behavioral contract (traversal, shortcuts, no layout shift).

## Rule 1 — Input states are tokenized roles (I1 mechanism)

Every pointer-hover and keyboard-focus visual comes from `AppInputStates` (`lib/app/theme/app_input_states.dart`):

| Role | Token | Visual |
| --- | --- | --- |
| Pointer hover on a control | `AppInputStates.hoverOverlay` | 5% white fill |
| Keyboard focus on a control | `AppInputStates.focusOverlay` | 12% primary fill |
| Keyboard focus on a text input | `AppInputStates.focusInputBorder` | border → primary |

Shared widgets consume the tokens through their `InkWell` (`VitCard`, `VitCtaButton`, `VitMarketPairRow`, master-detail menu rows) or border (`VitInput` — error border wins over focus). Tablet presentation code never hand-rolls `MouseRegion`/`onHover` (**I1-raw-hover**) or off-token `hoverColor:`/`focusColor:` (**I2-adhoc-input-state**).

## Rule 2 — Focus must be visible on every interactive control

A control reachable by keyboard must show its focus state through the tokens above — the `focusOverlay` fill for controls, the `focusInputBorder` border for inputs. Inputs use a border (not a fill) so the caret stays the only bright element inside the field; an error border takes priority over the focus border. Disabling the visuals "for cleanliness" (`focusColor: Colors.transparent` on an interactive element) is a violation, not a style choice.

## Rule 3 — Traversal follows visual order

Keyboard tab order must match visual order: master-detail goes menu → detail pane, top-to-bottom, left-to-right. `skipTraversal: true` is forbidden (**I3-skip-traversal**); if a widget is truly decorative, remove it from the focus tree by not being interactive.

## Rule 4 — Minimum keyboard contract (I4, behavioral)

- **Esc** closes the topmost sheet/dialog.
- **Enter** submits the final step of a form (with the same preview/confirm gating as the touch path — financial safety rules out an Enter that skips a confirm).
- Master-detail arrow navigation (↑/↓ through the menu) is the roadmap item, not a launch requirement; do not block on it, do not hand-roll a parallel shortcut system per pane either.

These are enforced by widget tests on the affected flows, not by the static scanner.

## Rule 5 — Hover/focus never shift layout (I5, behavioral)

Hover and focus change *color only* — fills and border color swaps at constant width. No size change, no padding change, no elevation jump on hover: a row that grows by 2px under the cursor makes lists jitter and mis-clicks. Enforced by the token design (fills only) and reviewed in the widget tests of interactive shared widgets.

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `MouseRegion(onHover: …)` in a pane to "add hover" | Bypasses the shared mechanism; next pane re-invents it with different colors (I1) |
| `hoverColor: Colors.white10` "just here" | Off-token state color — the exact drift class the Card & Border standard killed for tints (I2) |
| `InkWell(focusColor: Colors.transparent)` on a control | Hides keyboard focus — a11y regression, not minimalism |
| `FocusNode(skipTraversal: true)` to "fix" tab order | Order is wrong *because* something upstream is wrong; fix the order (I3) |
| Hover effect that resizes or re-pads the control | Jitter + mis-clicks (I5) |
| New input state color added to `AppColors` for one widget | Input states live in `AppInputStates` as roles, not in the palette |

## Recipe for new tablet UI

1. Interactive card/row/button → the shared widget with `onTap`/`onPressed` (tokens ride along automatically).
2. Text input → `VitInput` (focus border automatic; pass `errorText` for the error border).
3. A genuinely new interactive primitive → build it in `shared/widgets/`, wire `AppInputStates` tokens into its `InkWell`, add the widget test locking the two colors.
4. Verify keyboard reachability by tabbing through the pane once in the widget test.
5. Before commit: `dart run tool/tablet_input_audit.dart --check` + `flutter test test/quality/tablet_input_guardrail_test.dart`.

## Enforcement & ratchet

- **I1/I2/I3 are absolute locks** — the tablet surface was born clean (2026-08-23 sweep: the only matches are the tokenized lines themselves) and any new violation fails CI outright. No baseline exists; do not create one.
- **I4/I5 are behavioral** — covered by the shared widgets' tests (`vit_card_test.dart`, `vit_input_test.dart`, `vit_market_rows_test.dart`, `profile_tablet_page_test.dart`) and flow-level tests; the static scanner documents them as out of reach, same caveat as S4.
- The audit artifact (`VitTrade-Tablet-Input-Audit.csv`) must stay current; the scanner self-tests its regexes on every run.

## Verify

```bash
cd flutter_app
dart run tool/tablet_input_audit.dart            # regenerate audit CSV
dart run tool/tablet_input_audit.dart --check    # CI: artifact current
flutter test test/quality/tablet_input_guardrail_test.dart --reporter=compact
flutter test test/shared/widgets/vit_card_test.dart test/shared/widgets/vit_input_test.dart test/shared/widgets/vit_market_rows_test.dart --reporter=compact
```

## Migration pointers

- Audit: [VitTrade-Tablet-Input-Audit.csv](../audits/VitTrade-Tablet-Input-Audit.csv) (empty — locked at zero)
- Tokens: `lib/app/theme/app_input_states.dart`
- Shared mechanism: `VitCard` / `VitCtaButton` / `VitMarketPairRow` / `VitInput` / Profile master-detail menu rows
- Layout context: [Tablet-Adaptive-Standard.md](./Tablet-Adaptive-Standard.md)
