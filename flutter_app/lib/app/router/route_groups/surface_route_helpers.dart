import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_web_utility_page.dart';

/// Builds a route with independent Tablet and Web compositions.
///
/// The fallback is selected only for Phone and the compatibility surface.
Widget buildSurfaceAwareTabletRoute({
  required BuildContext context,
  required AppSurface? surface,
  required String semanticIdentifier,
  required String title,
  required String subtitle,
  required String description,
  required String backPath,
  required Widget fallback,
  List<VitTabletUtilityFact>? facts,
  String? actionLabel,
  bool requiresConfirmation = false,
  String? confirmationTitle,
  String? confirmationMessage,
  IconData icon = Icons.dashboard_customize_outlined,
}) {
  final web = VitWebUtilityPage(
    semanticIdentifier: semanticIdentifier,
    title: title,
    subtitle: subtitle.replaceAll('Tablet', 'Web'),
    description: description.replaceAll('Tablet', 'Web'),
    facts: [
      VitWebUtilityFact(label: 'Mã màn hình', value: semanticIdentifier),
      const VitWebUtilityFact(label: 'Trạng thái', value: 'Đang cập nhật'),
      const VitWebUtilityFact(
        label: 'Bước tiếp theo',
        value: 'Rà soát thông tin',
      ),
    ],
    onBack: () => context.go(backPath),
    actionLabel: actionLabel,
    requiresConfirmation: requiresConfirmation,
    confirmationTitle: confirmationTitle,
    confirmationMessage: confirmationMessage,
    icon: icon,
  );

  return switch (surface) {
    AppSurface.web => web,
    AppSurface.phone || AppSurface.tablet || null => fallback,
  };
}

/// Converts a route family into an independent Tablet or Web composition.
///
/// The source route list remains the Phone compatibility contract. Callers
/// select the active surface explicitly; this helper preserves redirect-only
/// routes so aliases keep their route contract on every surface.
List<RouteBase> buildTabletUtilityRouteFamily({
  required Iterable<GoRoute> routes,
  required String title,
  required String subtitle,
  required String description,
  required String backPath,
  AppSurface surface = AppSurface.web,
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
          builder: (context, _) {
            final child = buildSurfaceAwareTabletRoute(
              context: context,
              surface: surface,
              semanticIdentifier: route.name ?? route.path,
              title: title,
              subtitle: subtitle,
              description: description,
              backPath: backPath,
              fallback: const SizedBox.shrink(),
              icon: icon,
            );
            return wrapper?.call(route, child) ?? child;
          },
        ),
  ];
}

/// Converts a route family into a Web-only utility composition.
///
/// Redirect-only aliases are retained verbatim. This keeps deep-link and
/// named-route parity while the Web presentation evolves independently.
List<RouteBase> buildWebUtilityRouteFamily({
  required Iterable<RouteBase> routes,
  required String title,
  required String subtitle,
  required String description,
  required String backPath,
  IconData icon = Icons.dashboard_customize_outlined,
}) {
  return buildTabletUtilityRouteFamily(
    routes: routes.whereType<GoRoute>(),
    surface: AppSurface.web,
    title: title,
    subtitle: subtitle,
    description: description,
    backPath: backPath,
    icon: icon,
  );
}
