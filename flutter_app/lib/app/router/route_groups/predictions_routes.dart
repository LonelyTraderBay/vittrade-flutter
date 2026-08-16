import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_advanced_chart_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/social/prediction_data_integration_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_breaking_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/social/prediction_event_calendar_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_event_detail_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/portfolio/prediction_market_maker_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_order_receipt_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/portfolio/prediction_portfolio_analyzer_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/portfolio/prediction_risk_calculator_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/social/prediction_social_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/social/prediction_tournaments_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/social/predictions_global_activity_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/social/predictions_leaderboard_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/portfolio/predictions_portfolio_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_rewards_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_search_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

List<RouteBase> predictionRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.marketsPredictions,
      name: AppRouteNames.sc027PredictionsHome,
      builder: (context, _) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc027PredictionsHome,
        fallback: PredictionsHomePage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsSearch,
      name: AppRouteNames.sc028PredictionsSearch,
      builder: (context, _) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc028PredictionsSearch,
        fallback: PredictionsSearchPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsBreaking,
      name: AppRouteNames.sc029PredictionsBreaking,
      builder: (context, _) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc029PredictionsBreaking,
        fallback: PredictionsBreakingPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: '/markets/predictions/event/:eventId',
      name: AppRouteNames.sc030PredictionEventDetail,
      builder: (context, state) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc030PredictionEventDetail,
        fallback: PredictionEventDetailPage(
          eventId: requireRouteParam(state, 'eventId'),
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsPortfolio,
      name: AppRouteNames.sc031PredictionsPortfolio,
      builder: (context, _) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc031PredictionsPortfolio,
        fallback: PredictionsPortfolioPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsRewards,
      name: AppRouteNames.sc032PredictionsRewards,
      builder: (context, _) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc032PredictionsRewards,
        fallback: PredictionsRewardsPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsLeaderboard,
      name: AppRouteNames.sc033PredictionsLeaderboard,
      builder: (context, _) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc033PredictionsLeaderboard,
        fallback: PredictionsLeaderboardPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsActivity,
      name: AppRouteNames.sc034PredictionsGlobalActivity,
      builder: (context, _) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc034PredictionsGlobalActivity,
        fallback: PredictionsGlobalActivityPage(
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: '/markets/predictions/receipt/:receiptId',
      name: AppRouteNames.sc035PredictionOrderReceipt,
      builder: (context, state) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc035PredictionOrderReceipt,
        fallback: PredictionOrderReceiptPage(
          receiptId: requireRouteParam(state, 'receiptId'),
          shellRenderMode: shellRenderMode,
        ),
        requiresConfirmation: true,
        actionLabel: 'Rà soát biên nhận',
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsRiskCalculator,
      name: AppRouteNames.sc036PredictionRiskCalculator,
      builder: (context, _) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc036PredictionRiskCalculator,
        fallback: PredictionRiskCalculatorPage(
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsMarketMaker,
      name: AppRouteNames.sc037PredictionMarketMaker,
      builder: (context, _) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc037PredictionMarketMaker,
        fallback: PredictionMarketMakerPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsPortfolioAnalyzer,
      name: AppRouteNames.sc038PredictionPortfolioAnalyzer,
      builder: (context, _) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc038PredictionPortfolioAnalyzer,
        fallback: PredictionPortfolioAnalyzerPage(
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsEventCalendar,
      name: AppRouteNames.sc039PredictionEventCalendar,
      builder: (context, _) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc039PredictionEventCalendar,
        fallback: PredictionEventCalendarPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsSocial,
      name: AppRouteNames.sc040PredictionSocial,
      builder: (context, _) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc040PredictionSocial,
        fallback: PredictionSocialPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: '/markets/predictions/advanced-chart/:eventId',
      name: AppRouteNames.sc041PredictionAdvancedChart,
      builder: (context, state) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc041PredictionAdvancedChart,
        fallback: PredictionAdvancedChartPage(
          // SEC-S45: default hợp lý UX (chợ/tài sản mặc định, không phải thực thể riêng tư) — giữ.
          eventId: state.pathParameters['eventId'] ?? 'btcusdt',
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsTournaments,
      name: AppRouteNames.sc042PredictionTournaments,
      builder: (context, _) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc042PredictionTournaments,
        fallback: PredictionTournamentsPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: '/markets/predictions/tournament/:tournamentId',
      name: AppRouteNames.sc414PredictionTournamentDetail,
      builder: (context, state) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc414PredictionTournamentDetail,
        fallback: PredictionTournamentDetailPage(
          tournamentId: requireRouteParam(state, 'tournamentId'),
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPredictionsDataIntegration,
      name: AppRouteNames.sc043PredictionDataIntegration,
      builder: (context, _) => _tabletPredictionRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc043PredictionDataIntegration,
        fallback: PredictionDataIntegrationPage(
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
  ];
}

Widget _tabletPredictionRoute({
  required BuildContext context,
  required AppSurface? surface,
  required String semanticIdentifier,
  required Widget fallback,
  bool requiresConfirmation = false,
  String? actionLabel,
}) {
  return buildSurfaceAwareTabletRoute(
    context: context,
    surface: surface,
    semanticIdentifier: semanticIdentifier,
    title: 'Prediction Markets',
    subtitle: 'Phân tích và quản trị vị thế trên Tablet',
    description:
        'Không gian Tablet tập trung cho dữ liệu, vị thế và quyết định có kiểm soát.',
    backPath: AppRoutePaths.marketsPredictions,
    fallback: fallback,
    requiresConfirmation: requiresConfirmation,
    actionLabel: actionLabel,
    icon: Icons.insights_outlined,
  );
}
