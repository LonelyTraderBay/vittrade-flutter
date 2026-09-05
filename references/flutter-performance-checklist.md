# Flutter Performance Checklist (VitTrade)

Quick reference for Flutter/Dart performance work. Use with
`.agents/skills/performance-optimization/SKILL.md`.

## Before you optimize

- [ ] Repro steps documented (route, device, action)
- [ ] Profiled in `--profile` mode or DevTools
- [ ] One bottleneck targeted per change

## Widget tree

- [ ] `const` constructors on leaf widgets with stable inputs
- [ ] Heavy subtrees extracted to limit rebuild scope
- [ ] No expensive work in `build()` (parsing, sorting large lists, I/O)
- [ ] `AutomaticKeepAliveClientMixin` only when tabs must preserve state

## Lists

- [ ] `ListView.builder` / slivers for unbounded or long lists
- [ ] Stable `Key`s on list items when identity matters
- [ ] `itemExtent` or prototype item when row height is fixed

## State

- [ ] Riverpod `select` for partial watches
- [ ] Providers split by update rate
- [ ] No broad `ref.watch` in chart/header leaves

## Charts / paint

- [ ] `RepaintBoundary` around custom painters
- [ ] Precise `shouldRepaint`
- [ ] Market data throttled at source

## Images

- [ ] `cacheWidth` / `cacheHeight` on decoded bitmaps
- [ ] Asset sizes match display density

## Layout

- [ ] No unnecessary `IntrinsicHeight` / `IntrinsicWidth` in scrollables
- [ ] Verified at 360px minimum width

## Verify

```bash
cd flutter_app
flutter analyze
flutter test test/<touched_module>/ --reporter=compact
```

- [ ] Metric improved or documented as unchanged with reason
- [ ] Financial and navigation flows still pass manual smoke if touched

## Anti-patterns

- Premature `RepaintBoundary` everywhere without profiling
- Caching entire provider state in local variables to "avoid rebuilds"
- Replacing readable code with micro-optimizations that fail analyze/tests
- Optimizing web LCP/INP before fixing Flutter frame jank (see
  `references/performance-checklist.md` for web-only work)
