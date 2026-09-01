// Phone-only route group. Surface-specific Phone/Web builders stay outside this composition.

import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_insurance_fund_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_insurance_certificate_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_claim_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_insurance_policy_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_insurance_score_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_dispute_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_dispute_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_dispute_evidence_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_dispute_resolution_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_disputes_page.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';

List<RouteBase> p2pDisputeRoutes(ShellRenderMode shellRenderMode) {
  final routes = <RouteBase>[
    GoRoute(
      path: '/p2p/dispute/detail/:disputeId',
      name: AppRouteNames.sc218P2PDisputeDetail,
      builder: (_, state) => P2PDisputeDetailPage(
        disputeId: requireRouteParam(state, 'disputeId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/dispute/evidence/:disputeId',
      name: AppRouteNames.sc219P2PDisputeEvidence,
      builder: (_, state) => P2PDisputeEvidencePage(
        disputeId: requireRouteParam(state, 'disputeId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/dispute/resolution/:disputeId',
      name: AppRouteNames.sc220P2PDisputeResolution,
      builder: (_, state) => P2PDisputeResolutionPage(
        disputeId: requireRouteParam(state, 'disputeId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/dispute/:orderId',
      name: AppRouteNames.sc221P2PDispute,
      builder: (_, state) => P2PDisputePage(
        orderId: requireRouteParam(state, 'orderId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.p2pDisputes,
      name: AppRouteNames.sc222P2PDisputes,
      builder: (_, _) => P2PDisputesPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsurance,
      name: AppRouteNames.sc238P2PInsuranceFund,
      builder: (_, _) => P2PInsuranceFundPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsuranceFundAlias,
      name: AppRouteNames.sc244P2PInsuranceFundAlias,
      redirect: (_, _) => AppRoutePaths.p2pInsurance,
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsuranceCertificate,
      name: AppRouteNames.sc239P2PInsuranceCertificate,
      builder: (_, _) =>
          P2PInsuranceCertificatePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsuranceScore,
      name: AppRouteNames.sc240P2PInsuranceScore,
      builder: (_, _) =>
          P2PInsuranceScorePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsurancePolicy,
      name: AppRouteNames.sc241P2PInsurancePolicy,
      builder: (_, _) =>
          P2PInsurancePolicyPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/p2p/insurance/claim/:claimId',
      name: AppRouteNames.sc243P2PClaimDetail,
      builder: (_, state) => P2PClaimDetailPage(
        claimId: requireRouteParam(state, 'claimId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
  ];

  return routes;
}
