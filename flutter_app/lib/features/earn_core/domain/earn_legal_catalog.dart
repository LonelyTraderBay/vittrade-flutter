import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';

/// One Earn legal / risk GOM document entry.
final class EarnLegalItem {
  const EarnLegalItem({
    required this.id,
    required this.label,
    required this.route,
  });

  final String id;
  final String label;
  final String route;
}

/// Cluster of Earn legal items shown in the Tài liệu & rủi ro sheet.
final class EarnLegalGroup {
  const EarnLegalGroup({
    required this.id,
    required this.label,
    required this.items,
  });

  final String id;
  final String label;
  final List<EarnLegalItem> items;
}

/// STEP-P3.2 — 31 GOM routes under Earn › Tài liệu & rủi ro.
///
/// Source: `22-EARN-SAVINGS-HUB-WIREFRAME.md` §4.3.
abstract final class EarnLegalCatalog {
  static const groups = <EarnLegalGroup>[
    EarnLegalGroup(
      id: 'legal-terms',
      label: 'Pháp lý & điều khoản',
      items: [
        EarnLegalItem(
          id: 'staking-terms',
          label: 'Điều khoản staking',
          route: AppRoutePaths.earnStakingTerms,
        ),
        EarnLegalItem(
          id: 'staking-risk-disclosure',
          label: 'Công bố rủi ro staking',
          route: AppRoutePaths.earnStakingRiskDisclosure,
        ),
        EarnLegalItem(
          id: 'staking-withdrawal-policy',
          label: 'Chính sách rút staking',
          route: AppRoutePaths.earnStakingWithdrawalPolicy,
        ),
        EarnLegalItem(
          id: 'staking-tax-guide',
          label: 'Hướng dẫn thuế staking',
          route: AppRoutePaths.earnStakingTaxGuide,
        ),
        EarnLegalItem(
          id: 'suitability-assessment',
          label: 'Đánh giá phù hợp',
          route: AppRoutePaths.earnSuitabilityAssessment,
        ),
        EarnLegalItem(
          id: 'regulatory-framework',
          label: 'Khung quy định',
          route: AppRoutePaths.earnRegulatoryFramework,
        ),
      ],
    ),
    EarnLegalGroup(
      id: 'validator-operations',
      label: 'Rủi ro validator & vận hành',
      items: [
        EarnLegalItem(
          id: 'risk-dashboard',
          label: 'Bảng rủi ro',
          route: AppRoutePaths.earnRiskDashboard,
        ),
        EarnLegalItem(
          id: 'risk-score-calculator',
          label: 'Máy tính điểm rủi ro',
          route: AppRoutePaths.earnRiskScoreCalculator,
        ),
        EarnLegalItem(
          id: 'validator-health-monitor',
          label: 'Giám sát sức khỏe validator',
          route: AppRoutePaths.earnValidatorHealthMonitor,
        ),
        EarnLegalItem(
          id: 'slashing-history',
          label: 'Lịch sử slashing',
          route: AppRoutePaths.earnSlashingHistory,
        ),
        EarnLegalItem(
          id: 'contingency-plan',
          label: 'Kế hoạch dự phòng',
          route: AppRoutePaths.earnContingencyPlan,
        ),
        EarnLegalItem(
          id: 'emergency-actions',
          label: 'Hành động khẩn cấp',
          route: AppRoutePaths.earnEmergencyActions,
        ),
        EarnLegalItem(
          id: 'liquid-staking',
          label: 'Staking thanh khoản',
          route: AppRoutePaths.earnLiquidStaking,
        ),
        EarnLegalItem(
          id: 'multi-chain',
          label: 'Staking đa chuỗi',
          route: AppRoutePaths.earnMultiChain,
        ),
      ],
    ),
    EarnLegalGroup(
      id: 'transparency-reporting',
      label: 'Minh bạch quỹ & báo cáo',
      items: [
        EarnLegalItem(
          id: 'proof-of-reserves',
          label: 'Bằng chứng dự trữ',
          route: AppRoutePaths.earnProofOfReserves,
        ),
        EarnLegalItem(
          id: 'insurance-fund-transparency',
          label: 'Minh bạch quỹ bảo hiểm',
          route: AppRoutePaths.earnInsuranceFundTransparency,
        ),
        EarnLegalItem(
          id: 'audit-reports',
          label: 'Báo cáo kiểm toán',
          route: AppRoutePaths.earnAuditReports,
        ),
        EarnLegalItem(
          id: 'transaction-reporting',
          label: 'Báo cáo giao dịch',
          route: AppRoutePaths.earnTransactionReporting,
        ),
        EarnLegalItem(
          id: 'data-export',
          label: 'Xuất dữ liệu',
          route: AppRoutePaths.earnDataExport,
        ),
        EarnLegalItem(
          id: 'advanced-orders',
          label: 'Lệnh nâng cao',
          route: AppRoutePaths.earnAdvancedOrders,
        ),
      ],
    ),
    EarnLegalGroup(
      id: 'developer-integration',
      label: 'Developer / tích hợp',
      items: [
        EarnLegalItem(
          id: 'api-documentation',
          label: 'Tài liệu API',
          route: AppRoutePaths.earnApiDocumentation,
        ),
        EarnLegalItem(
          id: 'developer-console',
          label: 'Bảng điều khiển developer',
          route: AppRoutePaths.earnDeveloperConsole,
        ),
        EarnLegalItem(
          id: 'webhooks',
          label: 'Webhooks',
          route: AppRoutePaths.earnWebhooks,
        ),
        EarnLegalItem(
          id: 'third-party-integrations',
          label: 'Tích hợp bên thứ ba',
          route: AppRoutePaths.earnThirdPartyIntegrations,
        ),
      ],
    ),
    EarnLegalGroup(
      id: 'community-governance',
      label: 'Cộng đồng & quản trị',
      items: [
        EarnLegalItem(
          id: 'community-governance',
          label: 'Quản trị cộng đồng',
          route: AppRoutePaths.earnCommunityGovernance,
        ),
        EarnLegalItem(
          id: 'forum',
          label: 'Diễn đàn',
          route: AppRoutePaths.earnForum,
        ),
        EarnLegalItem(
          id: 'social-feed',
          label: 'Bảng tin cộng đồng',
          route: AppRoutePaths.earnSocialFeed,
        ),
        EarnLegalItem(
          id: 'proposals',
          label: 'Đề xuất',
          route: AppRoutePaths.earnProposals,
        ),
        EarnLegalItem(
          id: 'voting',
          label: 'Biểu quyết',
          route: AppRoutePaths.earnVoting,
        ),
        EarnLegalItem(
          id: 'voting-proposal-demo',
          label: 'Chi tiết biểu quyết mẫu',
          route: '/earn/voting/demo',
        ),
        EarnLegalItem(
          id: 'institutional',
          label: 'Tổ chức',
          route: AppRoutePaths.earnInstitutional,
        ),
      ],
    ),
  ];

  static int get itemCount =>
      groups.fold<int>(0, (sum, group) => sum + group.items.length);
}
