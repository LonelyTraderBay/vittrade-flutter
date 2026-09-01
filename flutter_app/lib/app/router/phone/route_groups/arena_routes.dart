// Phone-only route group. Surface-specific Phone/Web builders stay outside this composition.

import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/arena_home_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_governance_gate_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_guide_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_blocked_users_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_challenge_detail_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_creator_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/arena_flow_map_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_leaderboard_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_safety_center_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_join_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_smart_rule_builder_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_studio_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_trust_breakdown_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_universal_preset_library_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_mode_detail_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/points/arena_points_entry_detail_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/points/arena_points_ledger_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/bridge/arena_prediction_bridge_foundation_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/arena_production_ready_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_report_case_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_resolution_center_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/bridge/connected_ecosystem_production_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/my_arena_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/my_arena_reports_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/verified_challenges_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/router/phone/phone_route_helpers.dart';

List<RouteBase> arenaCoreRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.arena,
      name: AppRouteNames.sc184ArenaHome,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc184ArenaHome,
        fallback: ArenaHomePage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaGuide,
      name: AppRouteNames.sc209ArenaGuide,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc209ArenaGuide,
        fallback: ArenaGuidePage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaStudio,
      name: AppRouteNames.sc185ArenaStudio,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc185ArenaStudio,
        fallback: ArenaStudioPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaStudioSmartRules,
      name: AppRouteNames.sc186ArenaSmartRules,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc186ArenaSmartRules,
        fallback: ArenaSmartRuleBuilderPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaStudioPresets,
      name: AppRouteNames.sc187ArenaPresetLibrary,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc187ArenaPresetLibrary,
        fallback: ArenaUniversalPresetLibraryPage(
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaStudioGovernance,
      name: AppRouteNames.sc188ArenaGovernanceGate,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc188ArenaGovernanceGate,
        fallback: ArenaGovernanceGatePage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: '/arena/mode/:modeId',
      name: AppRouteNames.sc189ArenaModeDetail,
      builder: (context, state) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc189ArenaModeDetail,
        fallback: ArenaModeDetailPage(
          modeId: requireRouteParam(state, 'modeId'),
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: '/arena/challenge/:challengeId',
      name: AppRouteNames.sc190ArenaChallengeDetail,
      builder: (context, state) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc190ArenaChallengeDetail,
        fallback: ArenaChallengeDetailPage(
          challengeId: requireRouteParam(state, 'challengeId'),
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: '/arena/join/:challengeId',
      name: AppRouteNames.sc191ArenaJoin,
      builder: (context, state) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc191ArenaJoin,
        fallback: ArenaJoinPage(
          challengeId: requireRouteParam(state, 'challengeId'),
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaResolution,
      name: AppRouteNames.sc192ArenaResolutionCenter,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc192ArenaResolutionCenter,
        fallback: ArenaResolutionCenterPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: '/arena/creator/:creatorId',
      name: AppRouteNames.sc193ArenaCreator,
      builder: (context, state) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc193ArenaCreator,
        fallback: ArenaCreatorPage(
          creatorId: requireRouteParam(state, 'creatorId'),
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaLeaderboard,
      name: AppRouteNames.sc194ArenaLeaderboard,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc194ArenaLeaderboard,
        fallback: ArenaLeaderboardPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaVerified,
      name: AppRouteNames.sc195VerifiedChallenges,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc195VerifiedChallenges,
        fallback: VerifiedChallengesPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaPoints,
      redirect: (_, _) => '${AppRoutePaths.rewards}?tab=arena',
    ),
  ];
}

List<RouteBase> arenaExtendedRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.arenaFlowMap,
      name: AppRouteNames.sc197ArenaFlowMap,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc197ArenaFlowMap,
        fallback: ArenaFlowMapPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaSafety,
      name: AppRouteNames.sc198ArenaSafetyCenter,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc198ArenaSafetyCenter,
        fallback: ArenaSafetyCenterPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaBlocked,
      name: AppRouteNames.sc203ArenaBlockedUsers,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc203ArenaBlockedUsers,
        fallback: ArenaBlockedUsersPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaMyReports,
      name: AppRouteNames.sc204MyArenaReports,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc204MyArenaReports,
        fallback: MyArenaReportsPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaMy,
      name: AppRouteNames.sc205MyArena,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc205MyArena,
        fallback: MyArenaPage(
          contractScope: MyArenaContractScope.arena,
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaProduction,
      name: AppRouteNames.sc206ArenaProductionReady,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc206ArenaProductionReady,
        fallback: ArenaProductionReadyPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaBridge,
      name: AppRouteNames.sc207ArenaPredictionBridgeFoundation,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc207ArenaPredictionBridgeFoundation,
        fallback: ArenaPredictionBridgeFoundationPage(
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaEcosystem,
      name: AppRouteNames.sc208ConnectedEcosystemProduction,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc208ConnectedEcosystemProduction,
        fallback: ConnectedEcosystemProductionPage(
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: '/arena/trust/:userId',
      name: AppRouteNames.sc199ArenaTrustBreakdown,
      builder: (context, state) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc199ArenaTrustBreakdown,
        fallback: ArenaTrustBreakdownPage(
          entityId: requireRouteParam(state, 'userId'),
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: '/arena/ledger/entry/:entryId',
      name: AppRouteNames.sc200ArenaPointsEntryDetail,
      builder: (context, state) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc200ArenaPointsEntryDetail,
        fallback: ArenaPointsEntryDetailPage(
          entryId: requireRouteParam(state, 'entryId'),
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.arenaLedger,
      name: AppRouteNames.sc201ArenaPointsLedger,
      builder: (context, _) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc201ArenaPointsLedger,
        fallback: ArenaPointsLedgerPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: '/arena/report/:caseId',
      name: AppRouteNames.sc202ArenaReportCase,
      builder: (context, state) => _phoneArenaRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc202ArenaReportCase,
        fallback: ArenaReportCasePage(
          caseId: requireRouteParam(state, 'caseId'),
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
  ];
}

Widget _phoneArenaRoute({
  required BuildContext context,

  required String semanticIdentifier,
  required Widget fallback,
}) {
  return buildPhoneRoute(
    context: context,
    semanticIdentifier: semanticIdentifier,
    title: 'Open Arena',
    subtitle: 'Không gian thử thách và điểm Arena trên Phone',
    description:
        'Không gian Phone riêng cho thử thách, điểm Arena, an toàn cộng đồng và quản trị hệ sinh thái.',
    backPath: AppRoutePaths.arena,
    fallback: fallback,
    icon: Icons.sports_esports_outlined,
  );
}
