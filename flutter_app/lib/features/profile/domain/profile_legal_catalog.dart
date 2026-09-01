import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';

/// STEP-P1.4 — 39 GOM routes under Profile › Pháp lý & báo cáo.
///
/// Groups: Copy (29 trade-compliance) · Bot (6) · P2P (2) · Arena (1) ·
/// Launchpad (1). Source: `17-HOME-PROFILE-MENU-WIREFRAME.md` §AG +
/// `05-trade-compliance.md`.
abstract final class ProfileLegalCatalog {
  static const groups = <ProfileLegalGroup>[
    ProfileLegalGroup(
      id: 'copy',
      label: 'Copy & tuân thủ giao dịch',
      items: [
        ProfileLegalItem(
          id: 'complaint-tracking-sample',
          label: 'Theo dõi khiếu nại (chi tiết)',
          route: '/trade/copy-trading/complaint-tracking/demo',
        ),
        ProfileLegalItem(
          id: 'arm-integration',
          label: 'Trạng thái tích hợp ARM',
          route: AppRoutePaths.tradeCopyArmIntegrationStatus,
        ),
        ProfileLegalItem(
          id: 'audit-trail',
          label: 'Nhật ký kiểm toán',
          route: AppRoutePaths.tradeCopyAuditTrail,
        ),
        ProfileLegalItem(
          id: 'best-execution',
          label: 'Báo cáo best execution',
          route: AppRoutePaths.tradeCopyBestExecutionReports,
        ),
        ProfileLegalItem(
          id: 'cass',
          label: 'Đối chiếu CASS',
          route: AppRoutePaths.tradeCopyCassReconciliation,
        ),
        ProfileLegalItem(
          id: 'client-categorization',
          label: 'Phân loại khách hàng',
          route: AppRoutePaths.tradeCopyClientCategorization,
        ),
        ProfileLegalItem(
          id: 'client-money',
          label: 'Bảo vệ tiền khách hàng',
          route: AppRoutePaths.tradeCopyClientMoneyProtection,
        ),
        ProfileLegalItem(
          id: 'client-opt-up',
          label: 'Yêu cầu nâng hạng khách hàng',
          route: AppRoutePaths.tradeCopyClientOptUpRequest,
        ),
        ProfileLegalItem(
          id: 'complaints-handling',
          label: 'Xử lý khiếu nại',
          route: AppRoutePaths.tradeCopyComplaintsHandling,
        ),
        ProfileLegalItem(
          id: 'complaint-submission',
          label: 'Gửi khiếu nại',
          route: AppRoutePaths.tradeCopyComplaintSubmission,
        ),
        ProfileLegalItem(
          id: 'complaint-tracking',
          label: 'Theo dõi khiếu nại',
          route: AppRoutePaths.tradeCopyComplaintTrackingBase,
        ),
        ProfileLegalItem(
          id: 'ex-ante-costs',
          label: 'Chi phí ex-ante',
          route: AppRoutePaths.tradeCopyExAnteCosts,
        ),
        ProfileLegalItem(
          id: 'execution-venue',
          label: 'Phân tích sàn khớp lệnh',
          route: AppRoutePaths.tradeCopyExecutionVenueAnalysis,
        ),
        ProfileLegalItem(
          id: 'ex-post-costs',
          label: 'Báo cáo chi phí ex-post',
          route: AppRoutePaths.tradeCopyExPostCostsReport,
        ),
        ProfileLegalItem(
          id: 'investor-compensation',
          label: 'Bồi thường nhà đầu tư',
          route: AppRoutePaths.tradeCopyInvestorCompensation,
        ),
        ProfileLegalItem(
          id: 'kid-generator',
          label: 'Tạo KID',
          route: AppRoutePaths.tradeCopyKidGenerator,
        ),
        ProfileLegalItem(
          id: 'ombudsman',
          label: 'Giới thiệu ombudsman',
          route: AppRoutePaths.tradeCopyOmbudsmanReferral,
        ),
        ProfileLegalItem(
          id: 'performance-scenarios',
          label: 'Kịch bản hiệu suất',
          route: AppRoutePaths.tradeCopyPerformanceScenarios,
        ),
        ProfileLegalItem(
          id: 'product-governance',
          label: 'Quản trị sản phẩm',
          route: AppRoutePaths.tradeCopyProductGovernance,
        ),
        ProfileLegalItem(
          id: 'regulatory-disclosures',
          label: 'Công bố quy định',
          route: AppRoutePaths.tradeCopyRegulatoryDisclosures,
        ),
        ProfileLegalItem(
          id: 'regulatory-inspection',
          label: 'Sẵn sàng thanh tra',
          route: AppRoutePaths.tradeCopyRegulatoryInspectionReady,
        ),
        ProfileLegalItem(
          id: 'regulatory-reports',
          label: 'Bảng báo cáo quy định',
          route: AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
        ),
        ProfileLegalItem(
          id: 'risk-indicator',
          label: 'Giải thích chỉ báo rủi ro',
          route: AppRoutePaths.tradeCopyRiskIndicatorExplainer,
        ),
        ProfileLegalItem(
          id: 'riy-calculator',
          label: 'Máy tính RIY',
          route: AppRoutePaths.tradeCopyRiyCalculator,
        ),
        ProfileLegalItem(
          id: 'slippage',
          label: 'Giám sát trượt giá',
          route: AppRoutePaths.tradeCopySlippageMonitoring,
        ),
        ProfileLegalItem(
          id: 'target-market',
          label: 'Định nghĩa thị trường mục tiêu',
          route: AppRoutePaths.tradeCopyTargetMarketDefinition,
        ),
        ProfileLegalItem(
          id: 'transaction-reporting',
          label: 'Báo cáo giao dịch',
          route: AppRoutePaths.tradeCopyTransactionReporting,
        ),
        ProfileLegalItem(
          id: 'margin-live-market-data',
          label: 'Phân tích dữ liệu ký quỹ (live)',
          route: AppRoutePaths.tradeMarginLiveMarketDataAnalytics,
        ),
        ProfileLegalItem(
          id: 'margin-market-data',
          label: 'Phân tích dữ liệu ký quỹ',
          route: AppRoutePaths.tradeMarginMarketDataAnalytics,
        ),
      ],
    ),
    ProfileLegalGroup(
      id: 'bots',
      label: 'Bot',
      items: [
        ProfileLegalItem(
          id: 'bot-api-docs',
          label: 'Tài liệu API Bot',
          route: AppRoutePaths.tradeBotApiDocumentation,
        ),
        ProfileLegalItem(
          id: 'bot-emergency-stop',
          label: 'Dừng khẩn cấp Bot',
          route: AppRoutePaths.tradeBotEmergencyStop,
        ),
        ProfileLegalItem(
          id: 'bot-risk-dashboard',
          label: 'Bảng rủi ro Bot',
          route: AppRoutePaths.tradeBotRiskDashboard,
        ),
        ProfileLegalItem(
          id: 'bot-risk-disclosure',
          label: 'Công bố rủi ro Bot',
          route: AppRoutePaths.tradeBotRiskDisclosure,
        ),
        ProfileLegalItem(
          id: 'bot-suitability',
          label: 'Đánh giá phù hợp Bot',
          route: AppRoutePaths.tradeBotSuitabilityAssessment,
        ),
        ProfileLegalItem(
          id: 'bot-terms',
          label: 'Điều khoản Bot',
          route: AppRoutePaths.tradeBotTermsOfService,
        ),
      ],
    ),
    ProfileLegalGroup(
      id: 'p2p',
      label: 'P2P',
      items: [
        ProfileLegalItem(
          id: 'p2p-insurance',
          label: 'Quỹ bảo hiểm P2P',
          route: AppRoutePaths.p2pInsurance,
        ),
        ProfileLegalItem(
          id: 'p2p-insurance-fund',
          label: 'Quỹ bảo hiểm P2P (alias)',
          route: AppRoutePaths.p2pInsuranceFundAlias,
        ),
      ],
    ),
    ProfileLegalGroup(
      id: 'arena',
      label: 'Arena',
      items: [
        ProfileLegalItem(
          id: 'arena-governance',
          label: 'Cổng quản trị Arena',
          route: AppRoutePaths.arenaStudioGovernance,
        ),
      ],
    ),
    ProfileLegalGroup(
      id: 'launchpad',
      label: 'Launchpad',
      items: [
        ProfileLegalItem(
          id: 'launchpad-webhooks',
          label: 'Webhook Launchpad',
          route: AppRoutePaths.launchpadWebhooks,
        ),
      ],
    ),
  ];

  static int get itemCount =>
      groups.fold<int>(0, (sum, group) => sum + group.items.length);
}
