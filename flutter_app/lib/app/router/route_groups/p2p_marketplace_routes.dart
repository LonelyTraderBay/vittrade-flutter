import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/ads/p2p_ad_analytics_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/ads/p2p_ad_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/ads/p2p_create_ad_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/ads/p2p_my_ads_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/ads/p2p_order_book_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/hub/p2p_dashboard_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/hub/p2p_express_confirm_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/hub/p2p_express_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/hub/p2p_guide_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/hub/p2p_home_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/hub/p2p_notifications_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/hub/p2p_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/hub/p2p_trading_level_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> p2pMarketplaceRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.p2pExpress,
      name: AppRouteNames.sc211P2PExpress,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-211',
          title: 'P2P Express',
          subtitle: 'Mua bán nhanh · tài sản · thanh toán',
          description:
              'Chọn tài sản và phương thức thanh toán trong bố cục Tablet để rà soát giao dịch nhanh.',
          facts: const [
            P2PTabletFact(label: 'Tài sản', value: 'Theo lựa chọn'),
            P2PTabletFact(label: 'Phương thức', value: 'Theo lựa chọn'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa tạo lệnh'),
          ],
          actionLabel: 'Xem trước giao dịch',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận giao dịch P2P Express',
          icon: Icons.flash_on_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PExpressPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pExpressConfirm,
      name: AppRouteNames.sc210P2PExpressConfirm,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-210',
          title: 'Xác nhận P2P Express',
          subtitle: 'Xem trước · phí · thanh toán',
          description:
              'Kiểm tra tài sản, số tiền, phí và phương thức thanh toán trước khi xác nhận lệnh.',
          facts: const [
            P2PTabletFact(label: 'Tài sản', value: 'Theo yêu cầu'),
            P2PTabletFact(label: 'Số tiền', value: 'Theo yêu cầu'),
            P2PTabletFact(label: 'Phí', value: 'Đang tính'),
          ],
          actionLabel: 'Xác nhận lệnh Express',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận lệnh P2P Express',
          icon: Icons.fact_check_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PExpressConfirmPage(
          shellRenderMode: shellRenderMode,
          tradeType: parseP2PTradeType(state.uri.queryParameters['type']),
          asset: state.uri.queryParameters['asset'] ?? 'USDT',
          fiatAmount: parseP2PAmount(state.uri.queryParameters['fiat']),
          cryptoAmount: parseP2PAmount(state.uri.queryParameters['crypto']),
          adId: state.uri.queryParameters['adId'],
          paymentMethod: state.uri.queryParameters['payment'],
        ),
      },
    ),
    GoRoute(
      path: '/p2p/ad-analytics/:adId',
      name: AppRouteNames.sc223P2PAdAnalytics,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-223',
          title: 'Phân tích quảng cáo P2P',
          subtitle: 'Quảng cáo · hiệu suất · giao dịch',
          description:
              'Theo dõi hiệu suất quảng cáo, lượt xem và giao dịch trong vùng phân tích rộng trên Tablet.',
          facts: const [
            P2PTabletFact(label: 'Lượt xem', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Tỷ lệ giao dịch', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang hoạt động'),
          ],
          actionLabel: 'Lọc theo thời gian',
          icon: Icons.analytics_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PAdAnalyticsPage(
          adId: requireRouteParam(state, 'adId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/ad/:adId',
      name: AppRouteNames.sc224P2PAdDetail,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-224',
          title: 'Chi tiết quảng cáo P2P',
          subtitle: 'Quảng cáo · điều kiện · thanh toán',
          description:
              'Rà soát điều kiện quảng cáo, phương thức thanh toán và trạng thái hoạt động.',
          facts: const [
            P2PTabletFact(label: 'Tài sản', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Giá và giới hạn', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang hoạt động'),
          ],
          actionLabel: 'Xem trước thay đổi',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận thay đổi quảng cáo',
          icon: Icons.campaign_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PAdDetailPage(
          adId: requireRouteParam(state, 'adId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pMyAds,
      name: AppRouteNames.sc225P2PMyAds,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-225',
          title: 'Quảng cáo của tôi',
          subtitle: 'Quảng cáo · trạng thái · hiệu suất',
          description:
              'Theo dõi quảng cáo, trạng thái hoạt động và hiệu suất trong một bảng điều khiển Tablet.',
          facts: const [
            P2PTabletFact(label: 'Quảng cáo đang bật', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Quảng cáo nháp', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Cảnh báo', value: 'Không có'),
          ],
          actionLabel: 'Lọc quảng cáo',
          icon: Icons.view_list_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PMyAdsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pCreate,
      name: AppRouteNames.sc226P2PCreateAd,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-226',
          title: 'Tạo quảng cáo P2P',
          subtitle: 'Quảng cáo · giá · giới hạn',
          description:
              'Thiết lập giá, giới hạn và phương thức thanh toán trong bố cục Tablet để rà soát trước khi đăng.',
          facts: const [
            P2PTabletFact(label: 'Tài sản', value: 'Theo lựa chọn'),
            P2PTabletFact(label: 'Giá', value: 'Cần nhập'),
            P2PTabletFact(label: 'Giới hạn', value: 'Cần kiểm tra'),
          ],
          actionLabel: 'Xem trước quảng cáo',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận tạo quảng cáo P2P',
          icon: Icons.add_business_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PCreateAdPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pTradingLevel,
      name: AppRouteNames.sc230P2PTradingLevel,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-230',
          title: 'Cấp độ giao dịch P2P',
          subtitle: 'Uy tín · giao dịch · tiến độ',
          description:
              'Theo dõi cấp độ, điều kiện và tiến độ giao dịch P2P trong bố cục Tablet.',
          facts: const [
            P2PTabletFact(label: 'Cấp hiện tại', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Điểm cần đạt', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang theo dõi'),
          ],
          actionLabel: 'Xem điều kiện cấp độ',
          icon: Icons.stairs_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PTradingLevelPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pGuide,
      name: AppRouteNames.sc280P2PGuide,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-280',
          title: 'Hướng dẫn P2P',
          subtitle: 'Hướng dẫn · an toàn · giao dịch',
          description:
              'Tìm hiểu quy trình giao dịch, bảo vệ tài khoản và cách xử lý tình huống P2P.',
          facts: const [
            P2PTabletFact(label: 'Chủ đề', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Mức độ', value: 'Cơ bản đến nâng cao'),
            P2PTabletFact(label: 'Trạng thái', value: 'Sẵn sàng'),
          ],
          actionLabel: 'Mở chủ đề hướng dẫn',
          icon: Icons.menu_book_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PGuidePage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pSettings,
      name: AppRouteNames.sc279P2PSettings,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-279',
          title: 'Cài đặt P2P',
          subtitle: 'Cài đặt · thông báo · giao dịch',
          description:
              'Điều chỉnh cài đặt P2P và kiểm tra phạm vi áp dụng trước khi lưu.',
          facts: const [
            P2PTabletFact(label: 'Thông báo giao dịch', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Tự động xác nhận', value: 'Đang kiểm tra'),
            P2PTabletFact(label: 'Ngôn ngữ', value: 'Tiếng Việt'),
          ],
          actionLabel: 'Lưu cài đặt P2P',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận lưu cài đặt P2P',
          icon: Icons.settings_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PSettingsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pSettingsNotifications,
      name: AppRouteNames.sc278P2PNotificationsSettings,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-278',
          title: 'Thông báo P2P',
          subtitle: 'Cài đặt · thông báo · ưu tiên',
          description:
              'Quản lý nhóm thông báo P2P và xem trước thay đổi trong vùng nội dung rộng.',
          facts: const [
            P2PTabletFact(label: 'Thông báo lệnh', value: 'Đang bật'),
            P2PTabletFact(label: 'Thông báo tranh chấp', value: 'Đang bật'),
            P2PTabletFact(label: 'Kênh nhận', value: 'Đang cập nhật'),
          ],
          actionLabel: 'Lưu tùy chọn thông báo',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận tùy chọn thông báo P2P',
          icon: Icons.notifications_active_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PNotificationsSettingsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pOrderBook,
      name: AppRouteNames.sc273P2POrderBook,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-273',
          title: 'Sổ lệnh P2P',
          subtitle: 'Quảng cáo · giá · thanh khoản',
          description:
              'Theo dõi quảng cáo mua bán, giá và điều kiện thanh khoản trong bố cục Tablet.',
          facts: const [
            P2PTabletFact(label: 'Quảng cáo mua', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Quảng cáo bán', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Tài sản', value: 'Theo lựa chọn'),
          ],
          actionLabel: 'Lọc sổ lệnh',
          icon: Icons.table_rows_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2POrderBookPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pDashboard,
      name: AppRouteNames.sc274P2PDashboard,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-274',
          title: 'Tổng quan P2P',
          subtitle: 'Giao dịch · quảng cáo · uy tín',
          description:
              'Theo dõi tổng quan hoạt động P2P, quảng cáo và trạng thái tài khoản trên Tablet.',
          facts: const [
            P2PTabletFact(label: 'Lệnh đang mở', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Quảng cáo đang bật', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Cảnh báo', value: 'Không có'),
          ],
          actionLabel: 'Mở hoạt động P2P',
          icon: Icons.dashboard_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PDashboardPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2p,
      name: AppRouteNames.sc282P2PHome,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-282',
          title: 'P2P Marketplace',
          subtitle: 'Mua bán · quảng cáo · an toàn',
          description:
              'Khám phá giao dịch P2P, quảng cáo và công cụ an toàn trong trải nghiệm Tablet riêng.',
          facts: const [
            P2PTabletFact(label: 'Tài sản phổ biến', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Quảng cáo nổi bật', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái tài khoản', value: 'Đang bảo vệ'),
          ],
          actionLabel: 'Khám phá sổ lệnh',
          icon: Icons.storefront_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PHomePage(shellRenderMode: shellRenderMode),
      },
    ),
  ];
}
