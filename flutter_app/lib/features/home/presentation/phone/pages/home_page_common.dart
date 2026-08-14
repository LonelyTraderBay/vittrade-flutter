part of 'home_page.dart';

String _formatBillions(double value) {
  return (value / 1000000000).toStringAsFixed(2);
}

/// Flat «Xem thêm» catalog: group order preserved, route duplicates skipped
/// (including primary quick-action routes already on Home).
List<HomeQuickAction> _flatMoreCatalogActions({
  required List<HomeProductGroup> productGroups,
  required Set<String> excludedRoutes,
}) {
  final seen = Set<String>.of(excludedRoutes);
  final actions = <HomeQuickAction>[];
  for (final group in productGroups) {
    for (final action in group.actions) {
      if (seen.add(action.routePath)) {
        actions.add(action);
      }
    }
  }
  return actions;
}
