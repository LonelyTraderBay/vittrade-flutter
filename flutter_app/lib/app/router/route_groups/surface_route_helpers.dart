import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';

/// Builds a route with an independent Tablet composition and a legacy fallback.
///
/// The fallback is only selected for Phone, Web and the compatibility surface;
/// the Tablet branch never receives or renders the fallback widget.
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
  final tablet = VitTabletUtilityPage(
    semanticIdentifier: semanticIdentifier,
    title: title,
    subtitle: subtitle,
    description: description,
    facts:
        facts ??
        [
          VitTabletUtilityFact(label: 'Mã màn hình', value: semanticIdentifier),
          const VitTabletUtilityFact(
            label: 'Trạng thái',
            value: 'Đang cập nhật',
          ),
          const VitTabletUtilityFact(
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
    AppSurface.tablet => tablet,
    AppSurface.phone || AppSurface.web || null => fallback,
  };
}
