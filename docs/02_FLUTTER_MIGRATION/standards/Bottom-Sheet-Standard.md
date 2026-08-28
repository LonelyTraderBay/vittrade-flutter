# Bottom-Sheet Standard (Mandatory)

**Authority:** Derived from the existing `showVitBottomSheet` wrapper (`flutter_app/lib/shared/widgets/vit_bottom_sheet.dart`) and its guardrail test — not new policy.  
**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
**Enforcement:** `test/quality/bottom_sheet_guardrail_test.dart` (no audit tool exists for this domain)  
**Reference screen:** `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart` (`_showMoreProducts`)

## Rule

**Always call `showVitBottomSheet<T>(...)`, never Flutter's raw `showModalBottomSheet(...)` directly**, anywhere under `lib/app`, `lib/features`, or `lib/shared` — except inside `vit_bottom_sheet.dart` itself, which is the one file allowed to call the raw Flutter API because it *is* the wrapper.

`showVitBottomSheet` forwards straight to `showModalBottomSheet` but locks in three pieces of shared chrome so every sheet in the app looks and behaves the same:

- **Shape** — defaults `shape` to `RoundedRectangleBorder(borderRadius: AppRadii.sheetTopLargeRadius)` (large top-corner radius), so callers don't hand-roll their own `BorderRadius`.
- **Scrim** — defaults `barrierColor` to `AppColors.modalScrim` (60%-alpha black) and `backgroundColor` to `AppColors.surface`, keeping the dim/backdrop tone consistent across modules.
- **Navigator attachment** — defaults `useRootNavigator: true`. This is the guardrail's stated reason for the rule: sheets opened with the raw API can attach to the wrong (nested) navigator, while `showVitBottomSheet` always attaches to the root navigator.
- **Drag behavior** — `enableDrag: true` and `isDismissible: true` by default, so drag-to-dismiss and tap-outside-to-dismiss stay uniform. Note: this only enables the drag *gesture*; the wrapper does not render a visual drag-handle bar (`showDragHandle` is not passed), so no handle affordance is drawn today.

All other `showModalBottomSheet` parameters (`isScrollControlled`, `constraints`, `useSafeArea`, `backgroundColor`, `barrierColor`, `shape`) still pass through as optional overrides — the wrapper only supplies defaults, it does not remove caller control.

## Parameters (from the wrapper signature)

| Parameter | Wrapper default | Caller override |
| --- | --- | --- |
| `isScrollControlled` | `false` | Pass `true` for tall/scrollable sheet content (forms, long lists) |
| `useRootNavigator` | `true` | Rarely overridden — flipping it re-introduces the nested-navigator risk the rule exists to avoid |
| `backgroundColor` | `null` → resolves to `AppColors.surface` | Any `Color` |
| `barrierColor` | `null` → resolves to `AppColors.modalScrim` | Any `Color` |
| `shape` | `null` → resolves to `RoundedRectangleBorder(borderRadius: AppRadii.sheetTopLargeRadius)` | Any `ShapeBorder` |
| `constraints` | `null` (no wrapper default) | `BoxConstraints`, e.g. a max-height cap |
| `enableDrag` | `true` | `bool` |
| `isDismissible` | `true` | `bool` |
| `useSafeArea` | `false` | `bool` |

`context` and `builder` are required and have no default; `T` is the sheet's return type, same as raw `showModalBottomSheet<T>`.

## Wire pattern

```dart
showVitBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: AppColors.bg,
  barrierColor: AppColors.modalScrim,
  builder: (sheetContext) {
    return HomeMoreProductsSheet(
      actions: actions,
      onNavigate: (path) {
        Navigator.of(sheetContext).pop();
        rootContext.push(path);
      },
      density: density,
    );
  },
)
```

Minimal usage — no overrides, inherits every default (shape, scrim, root navigator, drag/dismiss):

```dart
showVitBottomSheet<void>(
  context: context,
  builder: (sheetContext) => const SomeSheetContent(),
)
```

`await`ing the call returns whatever the sheet passes to `Navigator.of(sheetContext).pop(value)` — the same await/return contract as raw `showModalBottomSheet<T>`, since the wrapper forwards its generic `T` straight through.

## Anti-pattern

| Anti-pattern | Why |
| --- | --- |
| `showModalBottomSheet(context: context, builder: ...)` in a feature/page file | Bypasses root-navigator attachment, shape, and scrim defaults; fails the guardrail |
| Re-declaring `RoundedRectangleBorder(borderRadius: ...)` / custom scrim color per call site | Duplicates what `showVitBottomSheet` already defaults; drifts from `sheetTopLargeRadius` / `modalScrim` |

## Exception

The guardrail scans `lib/app`, `lib/features`, `lib/shared` recursively for the literal string `showModalBottomSheet` and fails on any match, with exactly one path allowlisted: `lib/shared/widgets/vit_bottom_sheet.dart` (the wrapper's own implementation). There is no code-comment opt-out (no `// bottom-sheet: allow-*` marker) — the only way to keep a raw call is to be inside that one file.

The check is a per-line substring match (`lines[index].contains('showModalBottomSheet')`) after normalizing path separators to `/` for the allowlist comparison — it is not an AST or import-resolution check. In practice that means: it would also flag the identifier inside a comment or string literal, and it only recognizes the exact text `showModalBottomSheet` — other modal-style APIs (`showGeneralDialog`, `showCupertinoModalPopup`, etc.) are not covered by this guardrail today.

## Where it's used

`showVitBottomSheet` call sites currently span eight feature modules — `arena`, `earn`, `home`, `news`, `predictions`, `referral`, `trade`, `wallet` — plus the shared layer, so this is an app-wide primitive rather than a single-module convention. At the time of writing, the guardrail's `showModalBottomSheet` scan finds the identifier in exactly one file across `lib/app`, `lib/features`, `lib/shared`: the wrapper itself.

## Verify

```bash
cd flutter_app
flutter test test/quality/bottom_sheet_guardrail_test.dart --reporter=compact
```

## Migration pointers

There is no `tool/bottom_sheet_*.dart` audit or CSV for this domain — enforcement is guardrail-test-only (see **Enforcement** above). If a dedicated audit is added later, it should mirror the guardrail's own scan roots and single-file allowlist rather than introducing a second, divergent set of rules.

## Related

- [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md)
- [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md)
- [Card-Tile-Standard.md](./Card-Tile-Standard.md)
- [Segment-Pill-Standard.md](./Segment-Pill-Standard.md)
