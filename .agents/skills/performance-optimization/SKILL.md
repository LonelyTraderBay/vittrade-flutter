---
name: performance-optimization
description: Flutter performance optimization for VitTrade. Use when a plan requires perf work, the user reports lag/jank, or profiling shows rebuild/list/chart bottlenecks. Do not use for premature optimization.
---

# Performance Optimization (Flutter / VitTrade)

## When to use

- Active plan or user explicitly requests performance work.
- Measurable jank, slow scroll, or frame drops on trade/home screens.
- Profiling shows excessive rebuilds or layout thrash.

**Do not** optimize speculatively when the plan gate does not require it.

## Gate

Before changing code:

1. **Reproduce** — device/emulator, route, and action that lag.
2. **Measure** — profile mode or DevTools; cite metric (frame time, rebuild count).
3. **Fix one bottleneck** — smallest change; verify improvement.
4. **Guard** — focused test or widget test if behavior could regress.

## Widget rebuild

- [ ] Mark stable subtrees `const` where values are compile-time constant.
- [ ] Extract heavy `build()` sections into smaller widgets so only changed
      subtrees rebuild.
- [ ] Avoid creating `TextStyle`, `EdgeInsets`, or `BoxDecoration` inline in
      hot paths — use theme tokens (`AppTextStyles`, `AppSpacing`).
- [ ] Do not call `setState` on a large ancestor when a `ValueNotifier` /
      Riverpod provider can scope the update.

## Lists and scroll

- [ ] Long lists use `ListView.builder`, `SliverList`, or sliver composition —
      not unbounded `Column` + `children`.
- [ ] Trade order lists, provider leaderboards, history rows: lazy build only
      visible items.
- [ ] Fixed-height rows where possible — helps scroll performance.
- [ ] `cacheExtent` only when profiling shows benefit; do not guess.

## State (Riverpod)

- [ ] Prefer `ref.watch(provider.select(...))` over watching entire state objects.
- [ ] Split providers by update frequency (price tick vs static config).
- [ ] Avoid `ref.watch` in leaf widgets that only need one field — pass data
      from a parent or use `select`.

## Charts and custom paint

- [ ] Wrap custom painters (e.g. `advanced_chart_painter.dart`) in
      `RepaintBoundary` when parent rebuilds often.
- [ ] Throttle/debounce high-frequency market updates at the provider layer.
- [ ] Keep `shouldRepaint` precise — repaint only when data actually changes.

## Images and assets

- [ ] Network images: appropriate `cacheWidth` / `cacheHeight` for display size.
- [ ] Precache hero assets on routes that show them immediately after navigation.
- [ ] Prefer vector/SVG or appropriately sized raster assets.

## Layout

- [ ] Avoid intrinsic height passes in scroll views (`IntrinsicHeight` in lists).
- [ ] Prefer `LayoutBuilder` / constraints over hard-coded heights except where
      design tokens define them (`AppSpacing.ctaHeight`).
- [ ] Test at **360px** width — phone-first baseline per `DESIGN.md`.

## Measurement commands

From `flutter_app/`:

```bash
flutter run --profile
flutter run -d chrome --profile   # web QA batches
```

Use Flutter DevTools: Performance tab, timeline, rebuild stats.

Dev page: `PerformanceMonitor` under `features/dev/` when available.

## Exit criteria

- [ ] Before/after metric cited (frame time, jank count, or rebuild reduction).
- [ ] `flutter analyze` clean.
- [ ] Focused tests on touched module pass.
- [ ] No behavior regression on financial preview/confirm flows.

## References

- [`references/flutter-performance-checklist.md`](../../../references/flutter-performance-checklist.md)
- Web CWV checklist (secondary): [`references/performance-checklist.md`](../../../references/performance-checklist.md)
