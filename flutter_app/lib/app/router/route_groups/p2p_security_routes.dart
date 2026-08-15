import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_security_center_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_2fa_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_device_management_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_anti_phishing_code_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_login_history_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_suspicious_activity_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_e2e_info_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_fraud_prevention_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_aml_screening_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_limit_tracker_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_compliance_overview_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_large_transaction_justification_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_risk_assessment_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_achievements_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_blacklist_add_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_blacklist_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_source_of_funds_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_tax_reporting_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_transaction_limits_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_contribution_history_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_report_merchant_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_reviews_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

List<RouteBase> p2pSecurityRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <RouteBase>[
    GoRoute(
      path: AppRoutePaths.p2pSecurityCenter,
      name: AppRouteNames.sc253P2PSecurityCenter,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-253',
          title: 'Trung tâm bảo mật P2P',
          subtitle: 'Bảo mật · tài khoản · giao dịch',
          description:
              'Theo dõi các lớp bảo vệ tài khoản và giao dịch P2P trong một bảng tổng quan Tablet.',
          facts: const [
            P2PTabletFact(label: 'Điểm bảo mật', value: 'Đang cập nhật'),
            P2PTabletFact(label: '2FA', value: 'Đang kiểm tra'),
            P2PTabletFact(label: 'Cảnh báo', value: 'Không có'),
          ],
          actionLabel: 'Rà soát bảo mật',
          icon: Icons.security_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PSecurityCenterPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pSecurity2fa,
      name: AppRouteNames.sc254P2P2FASettings,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-254',
          title: 'Cài đặt 2FA P2P',
          subtitle: 'Bảo mật · xác thực hai lớp',
          description:
              'Kiểm tra trạng thái 2FA và xem trước thay đổi bảo mật trước khi xác nhận.',
          facts: const [
            P2PTabletFact(label: 'Trạng thái 2FA', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Thiết bị xác thực', value: 'Đang kiểm tra'),
            P2PTabletFact(label: 'Bước tiếp theo', value: 'Xác nhận thay đổi'),
          ],
          actionLabel: 'Xem trước thay đổi 2FA',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận thay đổi 2FA',
          icon: Icons.phonelink_lock_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2P2FASettingsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pSecurityDevices,
      name: AppRouteNames.sc255P2PDeviceManagement,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-255',
          title: 'Thiết bị P2P',
          subtitle: 'Bảo mật · phiên đăng nhập',
          description:
              'Rà soát thiết bị và phiên truy cập trước khi thu hồi quyền hoặc xác nhận thiết bị tin cậy.',
          facts: const [
            P2PTabletFact(label: 'Thiết bị tin cậy', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Phiên hoạt động', value: 'Đang kiểm tra'),
            P2PTabletFact(label: 'Cảnh báo mới', value: 'Không có'),
          ],
          actionLabel: 'Rà soát thiết bị',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận rà soát thiết bị',
          icon: Icons.devices_other_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PDeviceManagementPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pSecurityAntiPhishing,
      name: AppRouteNames.sc256P2PAntiPhishingCode,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-256',
          title: 'Mã chống lừa đảo P2P',
          subtitle: 'Bảo mật · nhận diện thông báo',
          description:
              'Xem trước mã chống lừa đảo và xác nhận thay đổi để nhận diện thông báo an toàn.',
          facts: const [
            P2PTabletFact(label: 'Mã hiện tại', value: 'Đã thiết lập'),
            P2PTabletFact(label: 'Lần cập nhật', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang bật'),
          ],
          actionLabel: 'Đổi mã chống lừa đảo',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận đổi mã chống lừa đảo',
          icon: Icons.privacy_tip_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PAntiPhishingCodePage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pSecurityLoginHistory,
      name: AppRouteNames.sc257P2PLoginHistory,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-257',
          title: 'Lịch sử đăng nhập P2P',
          subtitle: 'Bảo mật · hoạt động · thiết bị',
          description:
              'Đối chiếu lịch sử đăng nhập, thiết bị và vị trí truy cập gần đây.',
          facts: const [
            P2PTabletFact(
              label: 'Lần đăng nhập gần nhất',
              value: 'Đang cập nhật',
            ),
            P2PTabletFact(label: 'Thiết bị mới', value: 'Không có'),
            P2PTabletFact(label: 'Cảnh báo', value: 'Không có'),
          ],
          actionLabel: 'Lọc lịch sử',
          icon: Icons.login_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PLoginHistoryPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pSecuritySuspiciousActivity,
      name: AppRouteNames.sc258P2PSuspiciousActivity,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-258',
          title: 'Hoạt động đáng ngờ P2P',
          subtitle: 'Bảo mật · cảnh báo · xử lý',
          description:
              'Rà soát cảnh báo hoạt động và xác nhận hành động bảo vệ tài khoản nếu cần.',
          facts: const [
            P2PTabletFact(label: 'Cảnh báo mở', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Mức độ', value: 'Đang kiểm tra'),
            P2PTabletFact(label: 'Bước tiếp theo', value: 'Rà soát thủ công'),
          ],
          actionLabel: 'Xác nhận đã rà soát',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận đã rà soát cảnh báo',
          icon: Icons.warning_amber_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PSuspiciousActivityPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pSecurityWhitelist,
      name: AppRouteNames.sc404P2PWhitelistMode,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-404',
          title: 'Chế độ danh sách cho phép P2P',
          subtitle: 'Bảo mật · đối tác tin cậy',
          description:
              'Kiểm tra phạm vi danh sách cho phép trước khi thay đổi đối tác P2P được giao dịch.',
          facts: const [
            P2PTabletFact(label: 'Trạng thái', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Đối tác tin cậy', value: 'Đang kiểm tra'),
            P2PTabletFact(label: 'Quyền áp dụng', value: 'Giao dịch P2P'),
          ],
          actionLabel: 'Xem trước thay đổi',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận thay đổi danh sách cho phép',
          icon: Icons.list_alt_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PWhitelistModePage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: '/p2p/report/:merchantId',
      name: AppRouteNames.sc229P2PReportMerchant,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-229',
          title: 'Báo cáo thương nhân P2P',
          subtitle: 'An toàn · bằng chứng · xử lý',
          description:
              'Chuẩn bị nội dung báo cáo và rà soát bằng chứng trước khi gửi yêu cầu xử lý.',
          facts: const [
            P2PTabletFact(label: 'Đối tượng', value: 'Đã chọn'),
            P2PTabletFact(label: 'Bằng chứng', value: 'Cần bổ sung'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa gửi'),
          ],
          actionLabel: 'Gửi báo cáo',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận gửi báo cáo thương nhân',
          icon: Icons.report_problem_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PReportMerchantPage(
          merchantId: requireRouteParam(state, 'merchantId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pReviews,
      name: AppRouteNames.sc231P2PReviews,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-231',
          title: 'Đánh giá giao dịch P2P',
          subtitle: 'Uy tín · phản hồi · cộng đồng',
          description:
              'Đối chiếu phản hồi giao dịch và các tiêu chí uy tín của cộng đồng P2P.',
          facts: const [
            P2PTabletFact(label: 'Đánh giá gần đây', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Điểm uy tín', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Cảnh báo', value: 'Không có'),
          ],
          actionLabel: 'Lọc đánh giá',
          icon: Icons.rate_review_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PReviewsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pContributionHistory,
      name: AppRouteNames.sc242P2PContributionHistory,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-242',
          title: 'Lịch sử đóng góp P2P',
          subtitle: 'Uy tín · đóng góp · hoạt động',
          description:
              'Theo dõi lịch sử đóng góp, hoạt động và trạng thái ghi nhận trong hệ sinh thái P2P.',
          facts: const [
            P2PTabletFact(label: 'Đóng góp gần đây', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Điểm đóng góp', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang hoạt động'),
          ],
          actionLabel: 'Lọc lịch sử',
          icon: Icons.volunteer_activism_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PContributionHistoryPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pBlacklistAdd,
      name: AppRouteNames.sc276P2PBlacklistAdd,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-276',
          title: 'Thêm vào danh sách chặn P2P',
          subtitle: 'Bảo mật · đối tác · kiểm soát',
          description:
              'Rà soát đối tượng và lý do trước khi thêm vào danh sách chặn giao dịch P2P.',
          facts: const [
            P2PTabletFact(label: 'Đối tượng', value: 'Đã chọn'),
            P2PTabletFact(label: 'Lý do', value: 'Cần nhập'),
            P2PTabletFact(label: 'Phạm vi', value: 'Giao dịch P2P'),
          ],
          actionLabel: 'Xem trước chặn đối tượng',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận thêm vào danh sách chặn',
          icon: Icons.block_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PBlacklistAddPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pBlacklist,
      name: AppRouteNames.sc277P2PBlacklist,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-277',
          title: 'Danh sách chặn P2P',
          subtitle: 'Bảo mật · đối tác · kiểm soát',
          description:
              'Theo dõi các đối tác bị chặn và phạm vi áp dụng trong giao dịch P2P.',
          facts: const [
            P2PTabletFact(label: 'Đối tác bị chặn', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Lý do gần nhất', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang áp dụng'),
          ],
          actionLabel: 'Rà soát danh sách',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận rà soát danh sách chặn',
          icon: Icons.block_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PBlacklistPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pE2EInfo,
      name: AppRouteNames.sc259P2PE2EInfo,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-259',
          title: 'Bảo mật đầu cuối P2P',
          subtitle: 'Bảo mật · dữ liệu · riêng tư',
          description:
              'Xem cách bảo vệ dữ liệu và thông tin nhạy cảm trong các luồng giao dịch P2P.',
          facts: const [
            P2PTabletFact(label: 'Phạm vi bảo vệ', value: 'Giao tiếp P2P'),
            P2PTabletFact(label: 'Dữ liệu nhạy cảm', value: 'Được bảo vệ'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang bật'),
          ],
          actionLabel: 'Xem chính sách',
          icon: Icons.enhanced_encryption_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PE2EInfoPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pFraudPrevention,
      name: AppRouteNames.sc260P2PFraudPrevention,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-260',
          title: 'Phòng chống gian lận P2P',
          subtitle: 'An toàn · cảnh báo · hướng dẫn',
          description:
              'Rà soát dấu hiệu gian lận, nguyên tắc giao dịch và bước xử lý an toàn.',
          facts: const [
            P2PTabletFact(label: 'Dấu hiệu cần lưu ý', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Bằng chứng', value: 'Cần lưu giữ'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang bảo vệ'),
          ],
          actionLabel: 'Mở hướng dẫn an toàn',
          icon: Icons.shield_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PFraudPreventionPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pLimits,
      name: AppRouteNames.sc266P2PTransactionLimits,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-266',
          title: 'Giới hạn giao dịch P2P',
          subtitle: 'Tuân thủ · giới hạn · an toàn',
          description:
              'Kiểm tra hạn mức giao dịch, điều kiện áp dụng và bước xác nhận thay đổi.',
          facts: const [
            P2PTabletFact(label: 'Hạn mức hiện tại', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Cấp xác minh', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang áp dụng'),
          ],
          actionLabel: 'Xem trước giới hạn',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận thay đổi giới hạn giao dịch',
          icon: Icons.tune_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PTransactionLimitsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pLimitsTracker,
      name: AppRouteNames.sc265P2PLimitTracker,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-265',
          title: 'Theo dõi hạn mức P2P',
          subtitle: 'Tuân thủ · hạn mức · sử dụng',
          description:
              'Theo dõi mức sử dụng giao dịch và phần hạn mức còn lại theo thời gian.',
          facts: const [
            P2PTabletFact(label: 'Đã sử dụng', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Còn lại', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Chu kỳ', value: 'Đang cập nhật'),
          ],
          actionLabel: 'Lọc theo chu kỳ',
          icon: Icons.speed_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PLimitTrackerPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pComplianceOverview,
      name: AppRouteNames.sc267P2PComplianceOverview,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-267',
          title: 'Tổng quan tuân thủ P2P',
          subtitle: 'Tuân thủ · hồ sơ · kiểm soát',
          description:
              'Theo dõi các yêu cầu tuân thủ và trạng thái kiểm tra trong một bố cục Tablet rõ ràng.',
          facts: const [
            P2PTabletFact(label: 'Kiểm tra đang mở', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Hồ sơ cần bổ sung', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang theo dõi'),
          ],
          actionLabel: 'Rà soát tuân thủ',
          icon: Icons.fact_check_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PComplianceOverviewPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pComplianceAmlScreening,
      name: AppRouteNames.sc268P2PAmlScreening,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-268',
          title: 'Sàng lọc AML P2P',
          subtitle: 'Tuân thủ · AML · kiểm tra',
          description:
              'Theo dõi trạng thái sàng lọc AML và các bước cần hoàn tất trước giao dịch.',
          facts: const [
            P2PTabletFact(label: 'Hồ sơ sàng lọc', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Kết quả', value: 'Đang kiểm tra'),
            P2PTabletFact(label: 'Bước tiếp theo', value: 'Theo dõi'),
          ],
          actionLabel: 'Mở chi tiết AML',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận mở chi tiết AML',
          icon: Icons.manage_search_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PAmlScreeningPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pComplianceSourceOfFunds,
      name: AppRouteNames.sc269P2PSourceOfFunds,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-269',
          title: 'Nguồn tiền P2P',
          subtitle: 'Tuân thủ · nguồn tiền · bằng chứng',
          description:
              'Rà soát thông tin nguồn tiền và bằng chứng cần cung cấp trước khi xác nhận.',
          facts: const [
            P2PTabletFact(label: 'Nguồn tiền', value: 'Cần khai báo'),
            P2PTabletFact(label: 'Bằng chứng', value: 'Cần bổ sung'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa hoàn tất'),
          ],
          actionLabel: 'Xem trước khai báo',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận khai báo nguồn tiền',
          icon: Icons.account_balance_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PSourceOfFundsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pComplianceLargeTransaction,
      name: AppRouteNames.sc270P2PLargeTransaction,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-270',
          title: 'Giải trình giao dịch lớn P2P',
          subtitle: 'Tuân thủ · giao dịch lớn · giải trình',
          description:
              'Rà soát số tiền, mục đích và bằng chứng trước khi gửi giải trình giao dịch lớn.',
          facts: const [
            P2PTabletFact(label: 'Số tiền', value: 'Theo yêu cầu'),
            P2PTabletFact(label: 'Mục đích', value: 'Cần khai báo'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa gửi'),
          ],
          actionLabel: 'Gửi giải trình',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận gửi giải trình giao dịch lớn',
          icon: Icons.receipt_long_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PLargeTransactionJustificationPage(
          amount:
              double.tryParse(state.uri.queryParameters['amount'] ?? '') ??
              100000000,
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pComplianceRiskAssessment,
      name: AppRouteNames.sc271P2PRiskAssessment,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-271',
          title: 'Đánh giá rủi ro P2P',
          subtitle: 'Tuân thủ · rủi ro · phù hợp',
          description:
              'Xem trước các yếu tố rủi ro và điều kiện phù hợp trước khi tiếp tục giao dịch.',
          facts: const [
            P2PTabletFact(label: 'Mức rủi ro', value: 'Đang đánh giá'),
            P2PTabletFact(label: 'Yếu tố cần xem', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Bước tiếp theo', value: 'Rà soát'),
          ],
          actionLabel: 'Xác nhận đã rà soát',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận hoàn tất đánh giá rủi ro',
          icon: Icons.assessment_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PRiskAssessmentPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pTaxReporting,
      name: AppRouteNames.sc272P2PTaxReporting,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-272',
          title: 'Báo cáo thuế P2P',
          subtitle: 'Tuân thủ · thuế · lịch sử',
          description:
              'Theo dõi thông tin báo cáo thuế, kỳ báo cáo và dữ liệu cần đối chiếu.',
          facts: const [
            P2PTabletFact(label: 'Kỳ hiện tại', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái hồ sơ', value: 'Đang kiểm tra'),
            P2PTabletFact(label: 'Bước tiếp theo', value: 'Rà soát'),
          ],
          actionLabel: 'Xem trước báo cáo',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận xem trước báo cáo thuế',
          icon: Icons.description_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PTaxReportingPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pAchievements,
      name: AppRouteNames.sc275P2PAchievements,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-275',
          title: 'Thành tích P2P',
          subtitle: 'Hoạt động · uy tín · tiến độ',
          description:
              'Theo dõi thành tích, tiến độ và các mốc hoạt động trong hệ sinh thái P2P.',
          facts: const [
            P2PTabletFact(label: 'Thành tích đạt được', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Tiến độ tiếp theo', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang hoạt động'),
          ],
          actionLabel: 'Xem tiến độ',
          icon: Icons.emoji_events_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PAchievementsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: '/p2p/tax-report/detailed/:year',
      name: AppRouteNames.sc407P2PTaxReportDetail,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-407',
          title: 'Chi tiết báo cáo thuế P2P',
          subtitle: 'Tuân thủ · thuế · chi tiết',
          description:
              'Rà soát chi tiết kỳ báo cáo và dữ liệu cần xác nhận trước khi tiếp tục.',
          facts: const [
            P2PTabletFact(label: 'Kỳ báo cáo', value: 'Theo lựa chọn'),
            P2PTabletFact(label: 'Dữ liệu giao dịch', value: 'Đang tổng hợp'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa xác nhận'),
          ],
          actionLabel: 'Xác nhận dữ liệu',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận dữ liệu báo cáo thuế',
          icon: Icons.fact_check_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PTaxReportingPage(
          initialYear: int.tryParse(state.pathParameters['year'] ?? ''),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
  ];

  if (surface == AppSurface.web) {
    return buildWebUtilityRouteFamily(
      routes: routes,
      title: 'Bảo mật và tuân thủ P2P',
      subtitle: 'Bảo mật · AML · giới hạn · báo cáo',
      description:
          'Không gian Web riêng cho bảo mật, phòng chống gian lận và tuân thủ P2P. Dữ liệu nhạy cảm, hạn mức và bằng chứng cần được rà soát trước khi cập nhật.',
      backPath: AppRoutePaths.p2p,
      icon: Icons.shield_outlined,
    );
  }
  return routes;
}
