// Phone-only route group. Surface-specific Phone/Web builders stay outside this composition.

import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/features/rewards/presentation/phone/pages/rewards_hub_page.dart';
import 'package:vit_trade_flutter/features/enterprise_states/presentation/phone/pages/enterprise_states_page.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/phone/pages/unified_portfolio_dashboard_page.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/phone/pages/cross_module_analytics_page.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/phone/pages/smart_alert_center_page.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/phone/pages/tax_report_center_page.dart';
import 'package:vit_trade_flutter/features/dev/presentation/phone/pages/route_checker_page.dart';
import 'package:vit_trade_flutter/features/dev/presentation/phone/pages/performance_monitor.dart';
import 'package:vit_trade_flutter/features/dev/presentation/phone/pages/missing_screens_showcase_page.dart';
import 'package:vit_trade_flutter/features/dev/presentation/phone/pages/design_system_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/hub/dca_overview_demo.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/phone/pages/unified_search_page.dart';
import 'package:vit_trade_flutter/features/notifications/presentation/phone/pages/notifications_page.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/phone/pages/topic_hub_page.dart';
import 'package:vit_trade_flutter/features/referral/presentation/phone/pages/referral_home_page.dart';
import 'package:vit_trade_flutter/features/referral/presentation/phone/pages/referral_history_page.dart';
import 'package:vit_trade_flutter/features/referral/presentation/phone/pages/referral_rewards_page.dart';
import 'package:vit_trade_flutter/features/referral/presentation/phone/pages/referral_rules_page.dart';
import 'package:vit_trade_flutter/features/referral/presentation/phone/pages/referral_friend_detail_page.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/router/internal_surface_gate.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/placeholder_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/phone_route_helpers.dart';

List<RouteBase> utilityRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.rewards,
      name: AppRouteNames.sc319RewardsHub,
      builder: (context, state) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-319',
        title: 'Trung tâm phần thưởng',
        subtitle: 'Phần thưởng · nhiệm vụ · tiến độ',
        description:
            'Theo dõi nhiệm vụ, phần thưởng và tiến độ trong bố cục Phone rõ ràng.',
        backPath: AppRoutePaths.home,
        actionLabel: 'Xem nhiệm vụ',
        icon: Icons.card_giftcard_outlined,
        fallback: RewardsHubPage(
          shellRenderMode: shellRenderMode,
          initialFilter: rewardsFilterFromTab(state.uri.queryParameters['tab']),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.enterpriseStates,
      name: AppRouteNames.sc320EnterpriseStates,
      builder: (context, _) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-320',
        title: 'Trạng thái doanh nghiệp',
        subtitle: 'Hệ thống · trạng thái · vận hành',
        description: 'Theo dõi trạng thái các dịch vụ doanh nghiệp trên Phone.',
        backPath: AppRoutePaths.home,
        actionLabel: 'Lọc trạng thái',
        icon: Icons.business_center_outlined,
        fallback: EnterpriseStatesPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.unifiedPortfolio,
      name: AppRouteNames.sc321UnifiedPortfolio,
      builder: (context, _) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-321',
        title: 'Danh mục tổng hợp',
        subtitle: 'Danh mục · tài sản · phân bổ',
        description:
            'Theo dõi tổng quan danh mục và phân bổ tài sản trong màn hình Phone.',
        backPath: AppRoutePaths.home,
        actionLabel: 'Lọc danh mục',
        icon: Icons.pie_chart_outline,
        fallback: UnifiedPortfolioDashboardPage(
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.crossModuleAnalytics,
      name: AppRouteNames.sc322CrossModuleAnalytics,
      builder: (context, _) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-322',
        title: 'Phân tích tổng hợp',
        subtitle: 'Phân tích · xu hướng · dữ liệu',
        description: 'Đối chiếu dữ liệu và xu hướng liên mô-đun trên Phone.',
        backPath: AppRoutePaths.home,
        actionLabel: 'Lọc phân tích',
        icon: Icons.insights_outlined,
        fallback: CrossModuleAnalyticsPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.smartAlerts,
      name: AppRouteNames.sc323SmartAlertCenter,
      builder: (context, _) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-323',
        title: 'Trung tâm cảnh báo',
        subtitle: 'Cảnh báo · ưu tiên · xử lý',
        description: 'Theo dõi và xử lý cảnh báo trong bố cục Phone.',
        backPath: AppRoutePaths.home,
        actionLabel: 'Lọc cảnh báo',
        icon: Icons.notifications_active_outlined,
        fallback: SmartAlertCenterPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.taxReports,
      name: AppRouteNames.sc324TaxReportCenter,
      builder: (context, _) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-324',
        title: 'Trung tâm báo cáo thuế',
        subtitle: 'Báo cáo · thuế · dữ liệu',
        description: 'Theo dõi kỳ báo cáo và dữ liệu thuế trên Phone.',
        backPath: AppRoutePaths.home,
        actionLabel: 'Xem trước báo cáo',
        requiresConfirmation: true,
        confirmationTitle: 'Xác nhận xem trước báo cáo thuế',
        icon: Icons.description_outlined,
        fallback: TaxReportCenterPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.routeChecker,
      name: AppRouteNames.sc325RouteChecker,
      builder: (context, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.developer,
        routePath: AppRoutePaths.routeChecker,
        child: buildPhoneRoute(
          context: context,
          semanticIdentifier: 'SC-325',
          title: 'Kiểm tra route',
          subtitle: 'Dev · route · kiểm chứng',
          description:
              'Kiểm tra tính đầy đủ và trạng thái của route trên Phone.',
          backPath: AppRoutePaths.home,
          actionLabel: 'Chạy kiểm tra route',
          icon: Icons.route_outlined,
          fallback: RouteChecker(shellRenderMode: shellRenderMode),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.performanceMonitor,
      name: AppRouteNames.sc326PerformanceMonitor,
      builder: (context, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.developer,
        routePath: AppRoutePaths.performanceMonitor,
        child: buildPhoneRoute(
          context: context,
          semanticIdentifier: 'SC-326',
          title: 'Giám sát hiệu năng',
          subtitle: 'Dev · hiệu năng · chẩn đoán',
          description: 'Theo dõi hiệu năng và chẩn đoán trong bố cục Phone.',
          backPath: AppRoutePaths.home,
          actionLabel: 'Bắt đầu giám sát',
          icon: Icons.speed_outlined,
          fallback: PerformanceMonitor(shellRenderMode: shellRenderMode),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.devShowcase,
      name: AppRouteNames.sc398MissingScreensShowcase,
      builder: (context, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.developer,
        routePath: AppRoutePaths.devShowcase,
        child: buildPhoneRoute(
          context: context,
          semanticIdentifier: 'SC-398',
          title: 'Trình diễn màn hình',
          subtitle: 'Dev · showcase · kiểm tra',
          description: 'Kiểm tra các trạng thái màn hình trong bố cục Phone.',
          backPath: AppRoutePaths.home,
          actionLabel: 'Mở danh sách màn hình',
          icon: Icons.dashboard_customize_outlined,
          fallback: MissingScreensShowcasePage(
            shellRenderMode: shellRenderMode,
          ),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.devDesignSystem,
      name: AppRouteNames.sc399DesignSystem,
      builder: (context, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.developer,
        routePath: AppRoutePaths.devDesignSystem,
        child: buildPhoneRoute(
          context: context,
          semanticIdentifier: 'SC-399',
          title: 'Design system',
          subtitle: 'Dev · token · component',
          description: 'Kiểm tra component và token trong trải nghiệm Phone.',
          backPath: AppRoutePaths.home,
          actionLabel: 'Mở component',
          icon: Icons.palette_outlined,
          fallback: DesignSystemPage(shellRenderMode: shellRenderMode),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.devDcaOverview,
      name: AppRouteNames.sc400DcaOverviewDemo,
      builder: (context, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.developer,
        routePath: AppRoutePaths.devDcaOverview,
        child: buildPhoneRoute(
          context: context,
          semanticIdentifier: 'SC-400',
          title: 'Demo DCA',
          subtitle: 'Dev · DCA · kiểm thử',
          description: 'Kiểm tra luồng DCA và trạng thái minh họa trên Phone.',
          backPath: AppRoutePaths.home,
          actionLabel: 'Mở demo DCA',
          icon: Icons.auto_graph_outlined,
          fallback: DCAOverviewDemo(shellRenderMode: shellRenderMode),
        ),
      ),
    ),
  ];
}

String? rewardsFilterFromTab(String? tab) {
  return tab == 'arena' ? 'Arena' : null;
}

List<RouteBase> discoveryAndReferralRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: AppRoutePaths.search,
      name: AppRouteNames.sc283UnifiedSearch,
      builder: (context, _) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-283',
        title: 'Tìm kiếm tổng hợp',
        subtitle: 'Tìm kiếm · khám phá · dữ liệu',
        description:
            'Tìm kiếm tài sản, nội dung và tính năng trong bố cục Phone.',
        backPath: AppRoutePaths.home,
        actionLabel: 'Lọc kết quả',
        icon: Icons.search_outlined,
        fallback: UnifiedSearchPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.notifications,
      name: AppRouteNames.sc291Notifications,
      builder: (context, _) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-291',
        title: 'Thông báo',
        subtitle: 'Thông báo · ưu tiên · trạng thái',
        description: 'Theo dõi các thông báo quan trọng trong giao diện Phone.',
        backPath: AppRoutePaths.home,
        actionLabel: 'Đánh dấu đã đọc',
        icon: Icons.notifications_outlined,
        fallback: NotificationsPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.topics,
      name: AppRouteNames.sc284TopicHub,
      builder: (context, _) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-284',
        title: 'Chủ đề khám phá',
        subtitle: 'Khám phá · chủ đề · nội dung',
        description: 'Khám phá chủ đề và nội dung liên quan trên Phone.',
        backPath: AppRoutePaths.home,
        actionLabel: 'Lọc chủ đề',
        icon: Icons.topic_outlined,
        fallback: TopicHubPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.topicCrypto,
      name: AppRouteNames.sc285TopicCrypto,
      builder: (context, _) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-285',
        title: 'Chủ đề Crypto',
        subtitle: 'Crypto · khám phá · nội dung',
        description: 'Theo dõi nội dung chủ đề Crypto trong bố cục Phone.',
        backPath: AppRoutePaths.topics,
        actionLabel: 'Lọc nội dung',
        icon: Icons.currency_bitcoin_outlined,
        fallback: TopicHubPage(
          initialTopicId: 'crypto',
          useDetailEndpoint: true,
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.referral,
      name: AppRouteNames.sc290ReferralHome,
      builder: (context, _) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-290',
        title: 'Giới thiệu bạn bè',
        subtitle: 'Giới thiệu · tiến độ · phần thưởng',
        description: 'Theo dõi chương trình giới thiệu và tiến độ trên Phone.',
        backPath: AppRoutePaths.home,
        actionLabel: 'Xem tiến độ giới thiệu',
        icon: Icons.group_add_outlined,
        fallback: ReferralHomePage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.referralHistory,
      name: AppRouteNames.sc286ReferralHistory,
      builder: (context, _) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-286',
        title: 'Lịch sử giới thiệu',
        subtitle: 'Giới thiệu · lịch sử · trạng thái',
        description: 'Đối chiếu lịch sử giới thiệu trong bố cục Phone.',
        backPath: AppRoutePaths.referral,
        actionLabel: 'Lọc lịch sử',
        icon: Icons.history_outlined,
        fallback: ReferralHistoryPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.referralRewards,
      name: AppRouteNames.sc287ReferralRewards,
      builder: (context, _) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-287',
        title: 'Phần thưởng giới thiệu',
        subtitle: 'Giới thiệu · phần thưởng · điều kiện',
        description:
            'Theo dõi phần thưởng và điều kiện chương trình trên Phone.',
        backPath: AppRoutePaths.referral,
        actionLabel: 'Xem điều kiện',
        icon: Icons.redeem_outlined,
        fallback: ReferralRewardsPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.referralRules,
      name: AppRouteNames.sc288ReferralRules,
      builder: (context, _) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-288',
        title: 'Điều kiện giới thiệu',
        subtitle: 'Giới thiệu · quy tắc · điều kiện',
        description: 'Rà soát quy tắc và điều kiện chương trình giới thiệu.',
        backPath: AppRoutePaths.referral,
        actionLabel: 'Xác nhận đã đọc',
        icon: Icons.rule_outlined,
        fallback: ReferralRulesPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: '/referral/friend/:friendId',
      name: AppRouteNames.sc289ReferralFriendDetail,
      builder: (context, state) => buildPhoneRoute(
        context: context,
        semanticIdentifier: 'SC-289',
        title: 'Chi tiết người được giới thiệu',
        subtitle: 'Giới thiệu · người dùng · trạng thái',
        description: 'Theo dõi trạng thái người được giới thiệu trên Phone.',
        backPath: AppRoutePaths.referral,
        actionLabel: 'Xem lịch sử hoạt động',
        icon: Icons.person_outline,
        fallback: ReferralFriendDetailPage(
          friendId: requireRouteParam(state, 'friendId'),
        ),
      ),
    ),
  ];
}

List<RouteBase> get navigationPlaceholderRoutes {
  return [...homeOutgoingPlaceholders, ...marketOutgoingPlaceholders];
}
