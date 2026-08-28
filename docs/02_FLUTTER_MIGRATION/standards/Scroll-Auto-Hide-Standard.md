# Scroll Auto-Hide Standard (Mandatory)

**Authority:** Derived from the shipped `VitAutoHideHeaderScaffold` contract in
**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
`lib/shared/layout/vit_auto_hide_header_scaffold.dart`, the short-content
regression in `test/shared/layout/vit_auto_hide_header_scaffold_test.dart`, and
`test/quality/scroll_auto_hide_guardrail_test.dart`.
**Enforcement:** `flutter test test/quality/scroll_auto_hide_guardrail_test.dart`
plus the behavioral widget test above. There is no `tool/*_audit.dart` for this
domain — the shared scaffold is the single implementation, and the guardrail
locks that implementation + bans page-local copies.

## Problem this standard prevents

When a scroll-linked chrome element **changes the layout height** of the
viewport (for example collapsing a header with `AnimatedAlign(heightFactor: 0)`
inside a `Column` above an `Expanded` scroll body), Flutter recalculates
`ScrollMetrics.maxScrollExtent`. If the current `pixels` no longer fit, the
framework **clamps the offset toward zero**. On short pages (few cards, empty
states, filtered lists) that looks like: user drags down → content briefly
moves → page springs back to the top.

Incident reference: Support **Thông báo** (`AnnouncementsPage` / SC-293) with
~5 announcement cards under `VitAutoHideHeaderScaffold`.

## Scope (audit snapshot)

| Surface | Count / pattern | Risk |
| --- | --- | --- |
| `VitAutoHideHeaderScaffold(` | ~279 call sites under `lib/` | Covered by shared `_canHideHeader` gate |
| `VitAutoHidePageScaffold(` | ~14 wrappers → same scaffold | Covered |
| Hand-rolled `_headerVisible` | **0** outside the shared scaffold | Guardrail-banned |
| `heightFactor: visible ? 1 : 0` | **Only** in `_AutoHideHeaderHost` | Guardrail-banned elsewhere |
| `VitAppShell` bottom-nav auto-hide | `AnimatedSlide` / opacity overlay | Safe — does **not** change scroll viewport height |

## Mechanism (how it is enforced today)

1. **Shared scaffold only** — pages must use `VitAutoHideHeaderScaffold` or
   `VitAutoHidePageScaffold`. Do not invent a local `_headerVisible` +
   `UserScrollNotification` collapse.
2. **Collapse budget gate** — before hiding the header, the scaffold requires:

   ```dart
   metrics.pixels <= metrics.maxScrollExtent - _collapseBudget
   ```

   with `_collapseBudget = 96` (approximate header height). If collapsing the
   header would shrink `maxScrollExtent` enough to clamp the current offset,
   the header **stays expanded**.
3. **Bottom nav stays overlay** — `VitAppShell` may hide the floating bottom
   nav with slide/opacity. It must **not** switch to a `heightFactor` /
   `SizedBox(height: 0)` layout collapse that grows the body viewport.
4. **Physics stay clamping** — see [Scroll-Physics-Standard.md](./Scroll-Physics-Standard.md).
   Bounce physics can mask or worsen short-list overscroll; they are already
   forbidden app-wide.

## Rules

1. New/changed pages with a scroll-to-hide header **must** use
   `VitAutoHideHeaderScaffold` / `VitAutoHidePageScaffold` — never a page-local
   copy of `_headerVisible` + `heightFactor` collapse.
2. Do not remove or bypass `_canHideHeader` / `_collapseBudget` in
   `vit_auto_hide_header_scaffold.dart` without replacing it with an equivalent
   gate that keeps `pixels <= maxScrollExtent` after the header height change.
3. Do not introduce a second scroll-coupled chrome that collapses via
   `heightFactor`, `SizedBox.shrink()` height animation, or removing a
   `Column` child above an `Expanded` scroll view, unless that chrome is
   overlaid (does not change the scrollable's viewport extent).
4. Prefer overlay hide (opacity / slide / `IgnorePointer`) for chrome that
   must disappear without affecting scroll metrics — same pattern as
   `VitAppShell` bottom nav.
5. Short-list / filtered / empty states are first-class: any auto-hide change
   must keep a focused widget test that drags a short list and asserts the
   scroll offset stays `> 8` after settle.

## Wire pattern (required gate)

From `lib/shared/layout/vit_auto_hide_header_scaffold.dart`:

```dart
bool _canHideHeader(ScrollMetrics metrics) {
  return metrics.pixels <= metrics.maxScrollExtent - _collapseBudget;
}

// Only hide when both the hide threshold and the collapse budget allow it:
if (delta > 0 &&
    notification.metrics.pixels > widget.hideThreshold &&
    _canHideHeader(notification.metrics)) {
  _setHeaderVisible(false);
}
```

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| Page-local `_headerVisible` + `AnimatedAlign(heightFactor: …)` | Reintroduces snap-back; bypasses the shared gate |
| Hiding header by removing it from a `Column` above `Expanded` | Same viewport-extent shrink → clamp |
| Collapsing bottom nav with `heightFactor` / zero-height layout | Same class of bug as header collapse |
| Deleting `_canHideHeader` "because long lists hide fine" | Short lists and filtered empty states regress silently |
| Relying on `BouncingScrollPhysics` to hide the clamp | Forbidden by Scroll-Physics-Standard; does not fix the root cause |

## Verify

```bash
cd flutter_app
flutter test test/quality/scroll_auto_hide_guardrail_test.dart --reporter=compact
flutter test test/shared/layout/vit_auto_hide_header_scaffold_test.dart --reporter=compact
```

## Related

- [Top-Header-Standard.md](./Top-Header-Standard.md) — which routes use auto-hide vs fixed header
- [Scroll-Physics-Standard.md](./Scroll-Physics-Standard.md) — clamping-only motion language
- [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md) — domain map entry
- `lib/shared/layout/vit_auto_hide_header_scaffold.dart` — single implementation
- `lib/shared/layout/vit_app_shell.dart` — overlay bottom-nav auto-hide (safe pattern)
