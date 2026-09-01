import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Phone-only route helpers.
///
/// These helpers intentionally have no surface selector and no Tablet/Web UI
/// dependency. Route groups use them only to preserve the existing Phone
/// fallback behavior for families that are utility-only elsewhere.
Widget buildPhoneRoute({
  required BuildContext context,
  required String semanticIdentifier,
  required String title,
  required String subtitle,
  required String description,
  required String backPath,
  required Widget fallback,
  List<Object>? facts,
  String? actionLabel,
  bool requiresConfirmation = false,
  String? confirmationTitle,
  String? confirmationMessage,
  IconData icon = Icons.dashboard_customize_outlined,
}) {
  return fallback;
}

/// Retains redirect/name/path contracts for utility-only route families while
/// keeping their Phone fallback as the only presentation composition.
List<RouteBase> buildPhoneUtilityRouteFamily({
  required Iterable<GoRoute> routes,
  required String title,
  required String subtitle,
  required String description,
  required String backPath,
  IconData icon = Icons.dashboard_customize_outlined,
  Widget Function(GoRoute route, Widget child)? wrapper,
}) {
  return [
    for (final route in routes)
      if (route.redirect != null)
        route
      else
        GoRoute(
          path: route.path,
          name: route.name,
          builder: (context, _) =>
              wrapper?.call(route, const SizedBox.shrink()) ??
              const SizedBox.shrink(),
        ),
  ];
}
