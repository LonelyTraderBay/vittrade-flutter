import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_product_detail_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_redeem_page.dart';

List<RouteBase> earnSavingsRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <GoRoute>[
    GoRoute(
      path: AppRoutePaths.earnSavings,
      name: AppRouteNames.sc329Savings,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsPortfolio,
      name: AppRouteNames.sc333SavingsPortfolio,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsHistory,
      name: AppRouteNames.sc334SavingsHistory,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsGuide,
      name: AppRouteNames.sc335SavingsGuide,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsFAQ,
      name: AppRouteNames.sc336SavingsFAQ,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsNotifications,
      name: AppRouteNames.sc337SavingsNotifications,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsRecommendations,
      name: AppRouteNames.sc338SavingsRecommendations,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsRiskAssessment,
      name: AppRouteNames.sc339SavingsRiskAssessment,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsComparison,
      name: AppRouteNames.sc340SavingsComparison,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsAutoCompound,
      name: AppRouteNames.sc341AutoCompoundSettings,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsGoals,
      name: AppRouteNames.sc342SavingsGoal,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsAnalytics,
      name: AppRouteNames.sc343SavingsAnalytics,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsRebalance,
      name: AppRouteNames.sc344SavingsAutoRebalance,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsNotificationPreferences,
      name: AppRouteNames.sc345SavingsNotificationPreferences,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsDca,
      name: AppRouteNames.sc346SavingsDca,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsSmartSuggestions,
      name: AppRouteNames.sc347SavingsSmartSuggestions,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsExport,
      name: AppRouteNames.sc348SavingsExport,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsBacktest,
      name: AppRouteNames.sc349SavingsBacktest,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsAutoPilot,
      name: AppRouteNames.sc350SavingsAutoPilot,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsLadder,
      name: AppRouteNames.sc351SavingsLadder,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsWhatIf,
      name: AppRouteNames.sc352SavingsWhatIf,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsProductSample,
      name: AppRouteNames.sc330SavingsProductDetail,
      builder: (_, _) => SavingsProductDetailPage(
        productId: 'sample',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsRedeemPos001,
      name: AppRouteNames.sc331SavingsRedeem,
      builder: (_, _) => SavingsRedeemPage(
        positionId: 'pos001',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsReceipt,
      name: AppRouteNames.sc332SavingsReceipt,
      builder: legacyPhoneRouteStub,
    ),
  ];
  if (surface != AppSurface.tablet && surface != AppSurface.web) return routes;
  return buildTabletUtilityRouteFamily(
    routes: routes,
    surface: surface!,
    title: 'Earn Savings',
    subtitle: 'Tích lũy linh hoạt và mục tiêu tài chính trên Tablet',
    description:
        'Không gian Tablet để theo dõi sản phẩm tiết kiệm, mục tiêu, lợi suất và lịch sử.',
    backPath: AppRoutePaths.earnSavings,
    icon: Icons.savings_outlined,
  );
}
