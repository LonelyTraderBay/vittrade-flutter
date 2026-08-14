import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/p2p_dispute/presentation/pages/dispute/p2p_insurance_fund_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/pages/dispute/p2p_insurance_certificate_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/pages/dispute/p2p_claim_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/pages/dispute/p2p_insurance_policy_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/pages/dispute/p2p_insurance_score_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/pages/dispute/p2p_dispute_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/pages/dispute/p2p_dispute_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/pages/dispute/p2p_dispute_evidence_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/pages/dispute/p2p_dispute_resolution_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/pages/dispute/p2p_disputes_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> p2pDisputeRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  return [
    GoRoute(
      path: '/p2p/dispute/detail/:disputeId',
      name: AppRouteNames.sc218P2PDisputeDetail,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-218',
          title: 'Chi tiết tranh chấp P2P',
          subtitle: 'Tranh chấp · bằng chứng · xử lý',
          description:
              'Rà soát nội dung tranh chấp, bằng chứng và bước xử lý trước khi xác nhận.',
          facts: const [
            P2PTabletFact(label: 'Mã tranh chấp', value: 'Đã chọn'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang xử lý'),
            P2PTabletFact(label: 'Bằng chứng', value: 'Đang cập nhật'),
          ],
          actionLabel: 'Xác nhận xem xét',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận xem xét tranh chấp',
          icon: Icons.gavel_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PDisputeDetailPage(
          disputeId: requireRouteParam(state, 'disputeId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/dispute/evidence/:disputeId',
      name: AppRouteNames.sc219P2PDisputeEvidence,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-219',
          title: 'Bằng chứng tranh chấp P2P',
          subtitle: 'Tranh chấp · bằng chứng · xác nhận',
          description:
              'Kiểm tra danh sách bằng chứng và xác nhận nội dung trước khi gửi cho bên xử lý.',
          facts: const [
            P2PTabletFact(label: 'Bằng chứng đã có', value: 'Đang cập nhật'),
            P2PTabletFact(
              label: 'Bằng chứng cần bổ sung',
              value: 'Đang kiểm tra',
            ),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa gửi'),
          ],
          actionLabel: 'Gửi bằng chứng',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận gửi bằng chứng tranh chấp',
          icon: Icons.attach_file_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PDisputeEvidencePage(
          disputeId: requireRouteParam(state, 'disputeId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/dispute/resolution/:disputeId',
      name: AppRouteNames.sc220P2PDisputeResolution,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-220',
          title: 'Giải quyết tranh chấp P2P',
          subtitle: 'Tranh chấp · phương án · xác nhận',
          description:
              'Rà soát phương án giải quyết và các điều kiện liên quan trước khi xác nhận.',
          facts: const [
            P2PTabletFact(label: 'Phương án', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Điều kiện', value: 'Cần rà soát'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa xác nhận'),
          ],
          actionLabel: 'Xem trước phương án',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận phương án giải quyết',
          icon: Icons.rule_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PDisputeResolutionPage(
          disputeId: requireRouteParam(state, 'disputeId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/dispute/:orderId',
      name: AppRouteNames.sc221P2PDispute,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-221',
          title: 'Mở tranh chấp P2P',
          subtitle: 'Tranh chấp · giao dịch · bằng chứng',
          description:
              'Kiểm tra giao dịch, lý do và bằng chứng cần chuẩn bị trước khi mở tranh chấp.',
          facts: const [
            P2PTabletFact(label: 'Giao dịch', value: 'Đã chọn'),
            P2PTabletFact(label: 'Lý do', value: 'Cần chọn'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa gửi'),
          ],
          actionLabel: 'Mở tranh chấp',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận mở tranh chấp',
          icon: Icons.report_gmailerrorred_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PDisputePage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pDisputes,
      name: AppRouteNames.sc222P2PDisputes,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-222',
          title: 'Tranh chấp P2P',
          subtitle: 'Tranh chấp · trạng thái · lịch sử',
          description:
              'Theo dõi các tranh chấp, trạng thái xử lý và bước tiếp theo trong bố cục Tablet.',
          facts: const [
            P2PTabletFact(label: 'Tranh chấp đang mở', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Cần bổ sung', value: 'Đang kiểm tra'),
            P2PTabletFact(label: 'Đã giải quyết', value: 'Đang cập nhật'),
          ],
          actionLabel: 'Lọc tranh chấp',
          icon: Icons.list_alt_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PDisputesPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsurance,
      name: AppRouteNames.sc238P2PInsuranceFund,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-238',
          title: 'Quỹ bảo hiểm P2P',
          subtitle: 'Bảo hiểm · số dư · bảo vệ',
          description:
              'Theo dõi quỹ bảo hiểm, phạm vi bảo vệ và thông tin cập nhật trong bố cục Tablet.',
          facts: const [
            P2PTabletFact(label: 'Số dư quỹ', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Phạm vi bảo vệ', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang hoạt động'),
          ],
          actionLabel: 'Xem chi tiết quỹ',
          icon: Icons.account_balance_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PInsuranceFundPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsuranceFundAlias,
      name: AppRouteNames.sc244P2PInsuranceFundAlias,
      redirect: (_, _) => AppRoutePaths.p2pInsurance,
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsuranceCertificate,
      name: AppRouteNames.sc239P2PInsuranceCertificate,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-239',
          title: 'Chứng nhận bảo hiểm P2P',
          subtitle: 'Bảo hiểm · chứng nhận · giao dịch',
          description:
              'Xem chứng nhận bảo hiểm và phạm vi áp dụng cho giao dịch P2P hiện tại.',
          facts: const [
            P2PTabletFact(label: 'Chứng nhận', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Phạm vi', value: 'Đang kiểm tra'),
            P2PTabletFact(label: 'Trạng thái', value: 'Có hiệu lực'),
          ],
          actionLabel: 'Xác nhận đã xem',
          icon: Icons.card_membership_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PInsuranceCertificatePage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsuranceScore,
      name: AppRouteNames.sc240P2PInsuranceScore,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-240',
          title: 'Điểm bảo hiểm P2P',
          subtitle: 'Bảo hiểm · điểm · đánh giá',
          description:
              'Theo dõi điểm bảo hiểm và các yếu tố ảnh hưởng đến phạm vi bảo vệ P2P.',
          facts: const [
            P2PTabletFact(label: 'Điểm hiện tại', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Yếu tố ảnh hưởng', value: 'Đang kiểm tra'),
            P2PTabletFact(label: 'Xu hướng', value: 'Đang cập nhật'),
          ],
          actionLabel: 'Xem cách tính điểm',
          icon: Icons.score_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PInsuranceScorePage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pInsurancePolicy,
      name: AppRouteNames.sc241P2PInsurancePolicy,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-241',
          title: 'Chính sách bảo hiểm P2P',
          subtitle: 'Bảo hiểm · điều khoản · phạm vi',
          description:
              'Rà soát điều khoản, phạm vi và điều kiện áp dụng của chính sách bảo hiểm P2P.',
          facts: const [
            P2PTabletFact(label: 'Phạm vi', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Điều kiện', value: 'Đang kiểm tra'),
            P2PTabletFact(label: 'Hiệu lực', value: 'Đang cập nhật'),
          ],
          actionLabel: 'Xác nhận đã đọc',
          icon: Icons.policy_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PInsurancePolicyPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: '/p2p/insurance/claim/:claimId',
      name: AppRouteNames.sc243P2PClaimDetail,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-243',
          title: 'Chi tiết yêu cầu bảo hiểm P2P',
          subtitle: 'Bảo hiểm · yêu cầu · xử lý',
          description:
              'Rà soát yêu cầu bảo hiểm, bằng chứng và bước xử lý trước khi xác nhận.',
          facts: const [
            P2PTabletFact(label: 'Mã yêu cầu', value: 'Đã chọn'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang xử lý'),
            P2PTabletFact(label: 'Bằng chứng', value: 'Đang cập nhật'),
          ],
          actionLabel: 'Xác nhận yêu cầu',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận yêu cầu bảo hiểm',
          icon: Icons.assignment_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PClaimDetailPage(
          claimId: requireRouteParam(state, 'claimId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
  ];
}
