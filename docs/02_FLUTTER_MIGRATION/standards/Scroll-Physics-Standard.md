# Scroll Physics Standard (Mandatory)

**Authority:** Derived from the existing app-wide `_VitTradeScrollBehavior` override in `lib/app/vit_trade_app.dart` and `test/quality/scroll_physics_guardrail_test.dart` — not a new policy.
**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
**Enforcement:** `flutter test test/quality/scroll_physics_guardrail_test.dart` (no `tool/*_audit.dart` exists for this domain — the guardrail test is the sole check; it is a plain `flutter_test`, not a CLI with a `--check` flag)

VitTrade uses one scroll motion language app-wide: **`ClampingScrollPhysics` only.** There is no platform split — iOS does not get the native rubber-band/overscroll-glow bounce that `BouncingScrollPhysics` (or the Cupertino/Material default `ScrollBehavior`) would otherwise apply. This is already the shipped behavior, not an aspiration: `MaterialApp.router`'s `scrollBehavior` is set to a custom `_VitTradeScrollBehavior` that unconditionally returns `ClampingScrollPhysics`, and 250+ scrollables additionally set `physics: const ClampingScrollPhysics()` explicitly.

## Mechanism (how it's actually enforced today)

1. **App-wide default** — `lib/app/vit_trade_app.dart` defines:

   ```dart
   class _VitTradeScrollBehavior extends MaterialScrollBehavior {
     const _VitTradeScrollBehavior();

     @override
     ScrollPhysics getScrollPhysics(BuildContext context) {
       return const ClampingScrollPhysics();
     }
   }
   ```

   and wires it in via `MaterialApp.router(scrollBehavior: const _VitTradeScrollBehavior(), ...)` (the app boots through `go_router`, so it's the `.router` named constructor, not the bare `MaterialApp(...)` constructor). This overrides Flutter's default per-platform physics (which would hand iOS `BouncingScrollPhysics`) so every scrollable that does **not** set an explicit `physics:` still clamps.
2. **Per-widget guardrail** — `test/quality/scroll_physics_guardrail_test.dart` recursively scans every `.dart` file under `lib/app`, `lib/features`, and `lib/shared`, checks each line for the literal substring `BouncingScrollPhysics`, and fails listing every `path:line: <trimmed line>` match it finds. It does not check for the presence of `ClampingScrollPhysics` — it only bans the bouncing variant.

## Rules

1. Never reference `BouncingScrollPhysics` anywhere under `lib/app/`, `lib/features/`, or `lib/shared/` — this fails `scroll_physics_guardrail_test.dart` unconditionally, with no allowlist.
2. Any scrollable that declares an explicit `physics:` (`ListView`, `SingleChildScrollView`, `PageView`, `CustomScrollView`, `NestedScrollView`, etc.) must pass `const ClampingScrollPhysics()` — matching what `_VitTradeScrollBehavior.getScrollPhysics` already returns by default. Omitting `physics:` is also compliant (the app-wide default already clamps), but do not add it back as `BouncingScrollPhysics`.
3. Do not introduce a second `ScrollBehavior` subclass, and do not branch physics by platform (e.g. `Platform.isIOS ? BouncingScrollPhysics() : ClampingScrollPhysics()`). `_VitTradeScrollBehavior` in `lib/app/vit_trade_app.dart` is the single, app-level source of truth — new pages/widgets must not re-derive scroll behavior locally.
4. Do not wrap `BouncingScrollPhysics` inside a composed physics chain (e.g. `BouncingScrollPhysics(parent: ClampingScrollPhysics())`) to dodge the substring scan in spirit — the rule is "no iOS-style overscroll bounce anywhere," not just "no bare `BouncingScrollPhysics()` constructor."

## Wire pattern (explicit physics)

Real usage from `lib/features/arena/presentation/pages/arena_points_page_part_02.dart` — a horizontal `SingleChildScrollView` opting into the same clamping behavior the app-wide default already provides:

```dart
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  physics: const ClampingScrollPhysics(),
  child: Row(
    children: [ /* chips / tiles */ ],
  ),
)
```

The same `ClampingScrollPhysics()` literal is repeated 269 times across 250 files under `lib/features/` (arena, earn, p2p, dca, wallet, launchpad, profile, referral, discovery, support, and more) — it is not a one-off, it is the app-wide convention this doc formalizes.

## Exceptions

**None.** Reading `scroll_physics_guardrail_test.dart` in full (42 lines) confirms there is no `allow`/`exempt`/`ignore` marker convention, no per-file allowlist, and no directory skip beyond its three `scanRoots` (`lib/app`, `lib/features`, `lib/shared`). It is a flat, unconditional literal-substring scan — every match is a failure.

## Known scope gap (say it plainly, don't paper over it)

The guardrail's `scanRoots` are only `lib/app`, `lib/features`, and `lib/shared` — it does **not** scan `lib/core` or `lib/main.dart`. As of this writing `lib/core` has zero `ScrollPhysics` references, so this is a latent gap, not an active violation. If a scrollable is ever added under `lib/core`, this test will not catch a `BouncingScrollPhysics` regression there.

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `physics: const BouncingScrollPhysics()` | Reintroduces iOS rubber-band bounce; fails the guardrail test directly |
| `Platform.isIOS ? BouncingScrollPhysics() : ClampingScrollPhysics()` | Platform-conditional physics contradicts the single app-wide motion language |
| New page-local `ScrollBehavior` subclass | Duplicates `_VitTradeScrollBehavior`; drifts from the one sanctioned override |
| `BouncingScrollPhysics(parent: ClampingScrollPhysics())` | Still bounces at the edge; defeats the intent even if reviewers only grep for the bare constructor |

## Verify

```bash
cd flutter_app
flutter test test/quality/scroll_physics_guardrail_test.dart --reporter=compact
```

## Related

- [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md)
- [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md)
- [Flutter-App-Foundation.md](../Flutter-App-Foundation.md) — app bootstrap, where `MaterialApp.router`'s `scrollBehavior` is wired
- [Scroll-Auto-Hide-Standard.md](./Scroll-Auto-Hide-Standard.md) — scroll-linked chrome must not clamp short-list offsets
- [Card-Tile-Standard.md](./Card-Tile-Standard.md)
