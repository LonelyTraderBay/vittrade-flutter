import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
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

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

List<RouteBase> p2pDisputeRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <RouteBase>[
    GoRoute(
      path: '/p2p/dispute/detail/:disputeId',
      name: AppRouteNames.sc218P2PDisputeDetail,
      builder: (_, state) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => P2PDisputeDetailPage(
          disputeId: requireRouteParam(state, 'disputeId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/dispute/evidence/:disputeId',
      name: AppRouteNames.sc219P2PDisputeEvidence,
      builder: (_, state) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => P2PDisputeEvidencePage(
          disputeId: requireRouteParam(state, 'disputeId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/dispute/resolution/:disputeId',
      name: AppRouteNames.sc220P2PDisputeResolution,
      builder: (_, state) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => P2PDisputeResolutionPage(
          disputeId: requireRouteParam(state, 'disputeId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/dispute/:orderId',
      name: AppRouteNames.sc221P2PDispute,
      builder: (_, state) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => P2PDisputePage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
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
      builder: (_, state) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => P2PClaimDetailPage(
          claimId: requireRouteParam(state, 'claimId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
  ];

  if (surface == AppSurface.web) {
    return buildWebUtilityRouteFamily(
      routes: routes,
      title: 'Tranh chấp P2P',
      subtitle: 'Khiếu nại · bằng chứng · xử lý',
      description:
          'Không gian Web riêng để theo dõi tranh chấp, chứng từ và trạng thái xử lý P2P. Mọi kết quả và bước tiếp theo phải được đối chiếu trước khi xác nhận.',
      backPath: AppRoutePaths.p2p,
      icon: Icons.gavel_outlined,
    );
  }
  return routes;
}
