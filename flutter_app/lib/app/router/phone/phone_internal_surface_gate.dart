import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

enum InternalSurfaceKind { admin, developer, qaDemo }

final class InternalSurfaceAccessPolicy {
  const InternalSurfaceAccessPolicy._();

  static const bool explicitBuildEnable = bool.fromEnvironment(
    'VIT_INTERNAL_SURFACES_ENABLED',
    defaultValue: false,
  );

  static bool get isAllowedForCurrentBuild =>
      allows(releaseMode: kReleaseMode, explicitEnable: explicitBuildEnable);

  static bool allows({
    required bool releaseMode,
    required bool explicitEnable,
  }) => !releaseMode || explicitEnable;

  static bool isInternalPath(String path) => kindForPath(path) != null;

  static InternalSurfaceKind? kindForPath(String path) {
    final normalized = Uri.tryParse(path)?.path ?? path;
    if (normalized == AppRoutePaths.admin ||
        normalized.startsWith('${AppRoutePaths.admin}/')) {
      return InternalSurfaceKind.admin;
    }
    if (_developerPaths.contains(normalized)) {
      return InternalSurfaceKind.developer;
    }
    if (_qaDemoPaths.contains(normalized)) return InternalSurfaceKind.qaDemo;
    return null;
  }

  static const Set<String> _developerPaths = {
    AppRoutePaths.routeChecker,
    AppRoutePaths.performanceMonitor,
    AppRoutePaths.devShowcase,
    AppRoutePaths.devDesignSystem,
    AppRoutePaths.devDcaOverview,
  };

  static const Set<String> _qaDemoPaths = {AppRoutePaths.demoCopyCard};
}

class InternalSurfaceGate extends StatelessWidget {
  const InternalSurfaceGate({
    super.key,
    required this.kind,
    required this.routePath,
    required this.child,
  });

  final InternalSurfaceKind kind;
  final String routePath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (InternalSurfaceAccessPolicy.isAllowedForCurrentBuild) return child;
    return _InternalSurfaceRestrictedPage(kind: kind, routePath: routePath);
  }
}

class _InternalSurfaceRestrictedPage extends StatelessWidget {
  const _InternalSurfaceRestrictedPage({
    required this.kind,
    required this.routePath,
  });

  final InternalSurfaceKind kind;
  final String routePath;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      semanticLabel: 'Internal surface restricted',
      child: Column(
        children: [
          VitHeader(
            title: 'Restricted surface',
            subtitle: kind.label,
            showBack: true,
            onBack: () => context.go(AppRoutePaths.home),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
                padding: VitContentPadding.relaxed,
                children: [
                  VitCard(
                    padding: const EdgeInsets.all(AppSpacing.x5),
                    borderColor: AppColors.sell20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.admin_panel_settings_outlined,
                          color: AppColors.sell,
                          size: AppSpacing.iconLg,
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        Text(
                          'Internal route is disabled for customer builds.',
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          'Route: $routePath\n'
                          'Enable only through an explicit internal build flag.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension InternalSurfaceKindCopy on InternalSurfaceKind {
  String get label => switch (this) {
    InternalSurfaceKind.admin => 'Admin operations',
    InternalSurfaceKind.developer => 'Developer diagnostics',
    InternalSurfaceKind.qaDemo => 'QA demo surface',
  };
}
