// Phone-only route group. Surface-specific Phone/Web builders stay outside this composition.

import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/auto_compound_settings_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_analytics_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_auto_rebalance_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_autopilot_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_backtest_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_comparison_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_dca_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_export_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_history_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_faq_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_goal_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_ladder_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_notification_preferences_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_what_if_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_guide_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_notifications_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_portfolio_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_product_detail_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_recommendations_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_receipt_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_redeem_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_risk_assessment_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_smart_suggestions_page.dart';

List<RouteBase> earnSavingsRoutes(ShellRenderMode shellRenderMode) {
  final routes = <GoRoute>[
    GoRoute(
      path: AppRoutePaths.earnSavings,
      name: AppRouteNames.sc329Savings,
      builder: (_, _) => SavingsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsPortfolio,
      name: AppRouteNames.sc333SavingsPortfolio,
      builder: (_, _) => SavingsPortfolioPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsHistory,
      name: AppRouteNames.sc334SavingsHistory,
      builder: (_, _) => SavingsHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsGuide,
      name: AppRouteNames.sc335SavingsGuide,
      builder: (_, _) => SavingsGuidePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsFAQ,
      name: AppRouteNames.sc336SavingsFAQ,
      builder: (_, _) => SavingsFAQPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsNotifications,
      name: AppRouteNames.sc337SavingsNotifications,
      builder: (_, _) =>
          SavingsNotificationsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsRecommendations,
      name: AppRouteNames.sc338SavingsRecommendations,
      builder: (_, _) =>
          SavingsRecommendationsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsRiskAssessment,
      name: AppRouteNames.sc339SavingsRiskAssessment,
      builder: (_, _) =>
          SavingsRiskAssessmentPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsComparison,
      name: AppRouteNames.sc340SavingsComparison,
      builder: (_, _) =>
          SavingsComparisonPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsAutoCompound,
      name: AppRouteNames.sc341AutoCompoundSettings,
      builder: (_, _) =>
          AutoCompoundSettingsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsGoals,
      name: AppRouteNames.sc342SavingsGoal,
      builder: (_, _) => SavingsGoalPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsAnalytics,
      name: AppRouteNames.sc343SavingsAnalytics,
      builder: (_, _) => SavingsAnalyticsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsRebalance,
      name: AppRouteNames.sc344SavingsAutoRebalance,
      builder: (_, _) =>
          SavingsAutoRebalancePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsNotificationPreferences,
      name: AppRouteNames.sc345SavingsNotificationPreferences,
      builder: (_, _) =>
          SavingsNotificationPreferencesPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsDca,
      name: AppRouteNames.sc346SavingsDca,
      builder: (_, _) => SavingsDCAPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsSmartSuggestions,
      name: AppRouteNames.sc347SavingsSmartSuggestions,
      builder: (_, _) =>
          SavingsSmartSuggestionsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsExport,
      name: AppRouteNames.sc348SavingsExport,
      builder: (_, _) => SavingsExportPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsBacktest,
      name: AppRouteNames.sc349SavingsBacktest,
      builder: (_, _) => SavingsBacktestPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsAutoPilot,
      name: AppRouteNames.sc350SavingsAutoPilot,
      builder: (_, _) => SavingsAutoPilotPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsLadder,
      name: AppRouteNames.sc351SavingsLadder,
      builder: (_, _) => SavingsLadderPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSavingsWhatIf,
      name: AppRouteNames.sc352SavingsWhatIf,
      builder: (_, _) => SavingsWhatIfPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) => SavingsReceiptPage(shellRenderMode: shellRenderMode),
    ),
  ];
  return routes;
}
