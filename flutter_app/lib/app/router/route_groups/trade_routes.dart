import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_breakpoints.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_order_receipt_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/hub/orders_history_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/order_receipt_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/hub/trade_settings_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/hub/position_dashboard_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/hub/trade_history_export_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/convert/convert_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/futures/futures_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/futures/leverage_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/margin/margin_trading_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/margin/margin_trading_hub_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/placeholder_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

List<RouteBase> tradeRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <RouteBase>[
    GoRoute(
      path: AppRoutePaths.trade,
      name: AppRouteNames.sc048Trade,
      builder: (_, state) {
        final initialSide = _tradeSideFromQuery(
          state.uri.queryParameters['side'],
        );
        return switch (surface) {
          // Web surface composition is migrated in P7.
          AppSurface.phone || AppSurface.web || null => TradePage(
            initialSide: initialSide,
            shellRenderMode: shellRenderMode,
          ),
          AppSurface.tablet => TradeTabletPage(initialSide: initialSide),
        };
      },
    ),
    GoRoute(
      path: AppRoutePaths.tradeConvert,
      name: AppRouteNames.sc056Convert,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => _tradeTabletUtility(
          semanticIdentifier: 'SC-056',
          title: 'Chuyển đổi tài sản',
          subtitle: 'Đổi tài sản · xem trước tỷ giá và phí',
          description:
              'Xem lại tỷ giá quy đổi, phí áp dụng và tài sản nhận trước khi tiếp tục.',
          facts: const [
            TradeTabletFact(label: 'Tài sản gửi', value: 'USDT'),
            TradeTabletFact(label: 'Tài sản nhận', value: 'BTC'),
            TradeTabletFact(
              label: 'Phí chuyển đổi',
              value: 'Theo báo giá hiện tại',
            ),
          ],
          actionLabel: 'Xem trước chuyển đổi',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận chuyển đổi tài sản',
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => ConvertPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyRegulatoryDisclosuresAlias,
      name: AppRouteNames.sc412TradeCopyRegulatoryDisclosuresAlias,
      redirect: (_, _) => AppRoutePaths.tradeCopyRegulatoryDisclosures,
    ),
    GoRoute(
      path: AppRoutePaths.tradeMargin,
      name: AppRouteNames.sc085MarginTrading,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => _tradeTabletUtility(
          semanticIdentifier: 'SC-085',
          title: 'Giao dịch Margin',
          subtitle: 'Vay tài sản · quản lý tỷ lệ ký quỹ',
          description:
              'Theo dõi giá trị vị thế, tài sản vay và ngưỡng thanh lý trong cùng một màn hình Tablet.',
          facts: const [
            TradeTabletFact(label: 'Cặp giao dịch', value: 'BTC/USDT'),
            TradeTabletFact(
              label: 'Tỷ lệ ký quỹ',
              value: 'Theo thời gian thực',
            ),
            TradeTabletFact(
              label: 'Cảnh báo',
              value: 'Cần xem trước trước khi gửi',
              valueColor: AppColors.caution,
            ),
          ],
          actionLabel: 'Xem trước lệnh Margin',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận lệnh Margin',
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => MarginTradingPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginBtcusdt,
      name: AppRouteNames.sc086MarginTradingPair,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => _tradeTabletUtility(
          semanticIdentifier: 'SC-086',
          title: 'Margin BTC/USDT',
          subtitle: 'Vị thế BTC/USDT · kiểm soát rủi ro',
          description:
              'Kiểm tra giá tham chiếu, tỷ lệ ký quỹ và ngưỡng thanh lý trước khi thực hiện lệnh.',
          facts: const [
            TradeTabletFact(label: 'Cặp giao dịch', value: 'BTC/USDT'),
            TradeTabletFact(label: 'Chế độ', value: 'Margin cô lập'),
            TradeTabletFact(
              label: 'Trạng thái',
              value: 'Cần xem trước',
              valueColor: AppColors.caution,
            ),
          ],
          actionLabel: 'Xem trước lệnh Margin',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận lệnh Margin BTC/USDT',
        ),
        AppSurface.phone || AppSurface.web || null => MarginTradingPage(
          pairId: 'btcusdt',
          pairRouteVariant: true,
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginHub,
      name: AppRouteNames.sc090MarginTradingHub,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => _tradeTabletUtility(
          semanticIdentifier: 'SC-090',
          title: 'Trung tâm Margin',
          subtitle: 'Tổng quan vị thế · vay · rủi ro',
          description:
              'Tổng hợp các vị thế Margin và hành động cần ưu tiên trên một bố cục Tablet rộng.',
          facts: const [
            TradeTabletFact(label: 'Vị thế đang mở', value: '2'),
            TradeTabletFact(label: 'Tài sản vay', value: 'USDT'),
            TradeTabletFact(
              label: 'Mức cảnh báo',
              value: 'Theo tỷ lệ ký quỹ',
              valueColor: AppColors.caution,
            ),
          ],
          actionLabel: 'Mở bảng điều khiển Margin',
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => MarginTradingHubPage(shellRenderMode: shellRenderMode),
      },
    ),
    ...tradeMarginOutgoingPlaceholders,
    ...tradeBotsOutgoingPlaceholders,
    GoRoute(
      path: AppRoutePaths.tradeOrderReceipt,
      name: AppRouteNames.sc051OrderReceipt,
      builder: (context, _) => switch (surface) {
        AppSurface.phone => OrderReceiptPage(shellRenderMode: shellRenderMode),
        AppSurface.tablet => TradeTabletOrderReceiptPage(
          shellRenderMode: shellRenderMode,
        ),
        // Web surface composition is migrated in P7.
        AppSurface.web => OrderReceiptPage(shellRenderMode: shellRenderMode),
        null =>
          AppBreakpoints.isTablet(MediaQuery.sizeOf(context).width)
              ? TradeTabletOrderReceiptPage(shellRenderMode: shellRenderMode)
              : OrderReceiptPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.tradeOrdersHistory,
      name: AppRouteNames.sc050OrdersHistory,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => _tradeTabletUtility(
          semanticIdentifier: 'SC-050',
          title: 'Lịch sử lệnh',
          subtitle: 'Theo dõi trạng thái và kết quả lệnh',
          description:
              'Bố cục hai cột giúp đối chiếu trạng thái lệnh và thông tin chi tiết nhanh hơn.',
          facts: const [
            TradeTabletFact(label: 'Lệnh gần đây', value: '8'),
            TradeTabletFact(
              label: 'Đang xử lý',
              value: '2',
              valueColor: AppColors.caution,
            ),
            TradeTabletFact(
              label: 'Đã hoàn tất',
              value: '6',
              valueColor: AppColors.buy,
            ),
          ],
          actionLabel: 'Lọc lịch sử lệnh',
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => OrdersHistoryPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.tradePositions,
      name: AppRouteNames.sc053PositionDashboard,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => _tradeTabletUtility(
          semanticIdentifier: 'SC-053',
          title: 'Bảng vị thế',
          subtitle: 'Vị thế mở · giá trị · P/L',
          description:
              'Theo dõi vị thế, giá vào và P/L trong vùng nội dung rộng dành cho Tablet.',
          facts: const [
            TradeTabletFact(label: 'Vị thế mở', value: '2'),
            TradeTabletFact(label: 'Giá trị danh nghĩa', value: '\$12,480'),
            TradeTabletFact(
              label: 'P/L hôm nay',
              value: '+\$184.20',
              valueColor: AppColors.buy,
            ),
          ],
          actionLabel: 'Xem chi tiết vị thế',
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => PositionDashboardPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.tradeSettings,
      name: AppRouteNames.sc052TradeSettings,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => _tradeTabletUtility(
          semanticIdentifier: 'SC-052',
          title: 'Cài đặt giao dịch',
          subtitle: 'Xác nhận · thông báo · hiển thị',
          description:
              'Quản lý các tùy chọn giao dịch và yêu cầu xác nhận trong một bảng điều khiển rõ ràng.',
          facts: const [
            TradeTabletFact(
              label: 'Xác nhận lệnh',
              value: 'Đang bật',
              valueColor: AppColors.buy,
            ),
            TradeTabletFact(
              label: 'Thông báo giá',
              value: 'Đang bật',
              valueColor: AppColors.buy,
            ),
            TradeTabletFact(label: 'Chế độ hiển thị', value: 'Tablet rộng'),
          ],
          actionLabel: 'Lưu cài đặt',
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => TradeSettingsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.tradeExport,
      name: AppRouteNames.sc054TradeHistoryExport,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => _tradeTabletUtility(
          semanticIdentifier: 'SC-054',
          title: 'Xuất lịch sử giao dịch',
          subtitle: 'Chọn phạm vi · định dạng · kênh nhận',
          description:
              'Chuẩn bị báo cáo giao dịch với phạm vi và định dạng được kiểm tra trước khi tạo.',
          facts: const [
            TradeTabletFact(
              label: 'Phạm vi mặc định',
              value: '30 ngày gần nhất',
            ),
            TradeTabletFact(label: 'Định dạng', value: 'CSV'),
            TradeTabletFact(label: 'Kênh nhận', value: 'Tải xuống an toàn'),
          ],
          actionLabel: 'Tạo báo cáo',
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => TradeHistoryExportPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: '/trade/:pairId/futures/leverage',
      name: AppRouteNames.sc058Leverage,
      builder: (_, state) {
        final pairId = state.pathParameters['pairId'] ?? 'btcusdt';
        return switch (surface) {
          AppSurface.tablet => _tradeTabletUtility(
            semanticIdentifier: 'SC-058',
            title: 'Đòn bẩy Futures',
            subtitle: 'Thiết lập đòn bẩy · xem trước tác động',
            description:
                'Kiểm tra đòn bẩy, ký quỹ ban đầu và rủi ro thanh lý trước khi áp dụng cho $pairId.',
            facts: [
              TradeTabletFact(
                label: 'Cặp giao dịch',
                value: pairId.toUpperCase(),
              ),
              const TradeTabletFact(label: 'Đòn bẩy hiện tại', value: '5x'),
              const TradeTabletFact(
                label: 'Yêu cầu',
                value: 'Xác nhận rủi ro',
                valueColor: AppColors.caution,
              ),
            ],
            actionLabel: 'Xem trước đòn bẩy',
            requiresConfirmation: true,
            confirmationTitle: 'Xác nhận thay đổi đòn bẩy',
          ),
          AppSurface.phone || AppSurface.web || null => LeveragePage(
            pairId: pairId,
            shellRenderMode: shellRenderMode,
          ),
        };
      },
    ),
    GoRoute(
      path: '/trade/:pairId/futures',
      name: AppRouteNames.sc057Futures,
      builder: (_, state) {
        final pairId = state.pathParameters['pairId'] ?? 'btcusdt';
        return switch (surface) {
          AppSurface.tablet => _tradeTabletUtility(
            semanticIdentifier: 'SC-057',
            title: 'Giao dịch Futures',
            subtitle: 'Vị thế Long/Short · ký quỹ · thanh lý',
            description:
                'Tổng hợp thông tin Futures và đặt lệnh với vùng đánh giá rủi ro luôn hiển thị trên Tablet.',
            facts: [
              TradeTabletFact(
                label: 'Cặp giao dịch',
                value: pairId.toUpperCase(),
              ),
              const TradeTabletFact(
                label: 'Chế độ',
                value: 'Hợp đồng vĩnh cửu',
              ),
              const TradeTabletFact(
                label: 'Rủi ro',
                value: 'Cần xem trước trước khi gửi',
                valueColor: AppColors.caution,
              ),
            ],
            actionLabel: 'Xem trước lệnh Futures',
            requiresConfirmation: true,
            confirmationTitle: 'Xác nhận lệnh Futures',
          ),
          AppSurface.phone ||
          AppSurface.web ||
          null => FuturesPage(pairId: pairId, shellRenderMode: shellRenderMode),
        };
      },
    ),
    GoRoute(
      path: '/trade/:pairId',
      name: AppRouteNames.sc049TradePair,
      builder: (_, state) {
        final pairId = state.pathParameters['pairId'] ?? 'btcusdt';
        final side = _tradeSideFromQuery(state.uri.queryParameters['side']);
        return switch (surface) {
          AppSurface.tablet => TradeTabletPage(
            pairId: pairId,
            initialSide: side,
          ),
          AppSurface.phone || AppSurface.web || null => TradePage(
            pairId: pairId,
            chartVariant: TradeChartVariant.pairRoute,
            initialSide: side,
            shellRenderMode: shellRenderMode,
          ),
        };
      },
    ),
  ];

  if (surface == AppSurface.web) {
    return buildWebUtilityRouteFamily(
      routes: routes,
      title: 'Giao dịch',
      subtitle: 'Thị trường · lệnh · quản trị rủi ro',
      description:
          'Không gian Web riêng cho giao dịch, vị thế, lịch sử lệnh và cấu hình. Thông tin giá, phí, hạn mức và rủi ro phải được rà soát trước khi thực thi.',
      backPath: AppRoutePaths.home,
      icon: Icons.candlestick_chart_outlined,
    );
  }
  return routes;
}

TradeOrderSide _tradeSideFromQuery(String? value) {
  return value == 'sell' ? TradeOrderSide.sell : TradeOrderSide.buy;
}

TradeTabletUtilityPage _tradeTabletUtility({
  required String semanticIdentifier,
  required String title,
  required String subtitle,
  required String description,
  required List<TradeTabletFact> facts,
  String? actionLabel,
  bool requiresConfirmation = false,
  String? confirmationTitle,
}) {
  return TradeTabletUtilityPage(
    semanticIdentifier: semanticIdentifier,
    title: title,
    subtitle: subtitle,
    description: description,
    facts: facts,
    actionLabel: actionLabel,
    requiresConfirmation: requiresConfirmation,
    confirmationTitle: confirmationTitle,
  );
}
