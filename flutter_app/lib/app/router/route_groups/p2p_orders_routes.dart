import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_chat_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_escrow_balance_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_escrow_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_fund_lock_history_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_my_orders_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_cancel_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_proof_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_rate_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_timeline_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/wallet/p2p_wallet_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/wallet/p2p_wallet_transfer_page.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

List<RouteBase> p2pOrdersRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <RouteBase>[
    GoRoute(
      path: '/p2p/order/timeline/:orderId',
      name: AppRouteNames.sc212P2POrderTimeline,
      builder: (_, state) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => P2POrderTimelinePage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/order/rate/:orderId',
      name: AppRouteNames.sc213P2POrderRate,
      builder: (_, state) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => P2POrderRatePage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/order/cancel/:orderId',
      name: AppRouteNames.sc214P2POrderCancel,
      builder: (_, state) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => P2POrderCancelPage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/order/proof/:orderId',
      name: AppRouteNames.sc215P2POrderProof,
      builder: (_, state) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => P2POrderProofPage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/order/:orderId',
      name: AppRouteNames.sc216P2POrder,
      builder: (_, state) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => P2POrderPage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/chat/:orderId',
      name: AppRouteNames.sc217P2PChat,
      builder: (_, state) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => P2PChatPage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pEscrowBalance,
      name: AppRouteNames.sc245P2PEscrowBalance,
      builder: (_, state) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => P2PEscrowBalancePage(
          initialAsset: p2pAssetFromQuery(state.uri.queryParameters['asset']),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/escrow/:orderId',
      name: AppRouteNames.sc246P2PEscrowDetail,
      builder: (_, state) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => P2PEscrowDetailPage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pWallet,
      name: AppRouteNames.sc264P2PWallet,
      builder: (_, _) => P2PWalletPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pWalletTransfer,
      name: AppRouteNames.sc261P2PWalletTransfer,
      builder: (_, state) => switch (surface) {
        AppSurface.phone || AppSurface.tablet || AppSurface.web || null => () {
          final query = state.uri.queryParameters;
          return P2PWalletTransferPage(
            initialAsset: p2pAssetFromQuery(query['asset']),
            initialType: p2pWalletTransferTypeFromQuery(query),
            shellRenderMode: shellRenderMode,
          );
        }(),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pWalletFundLockHistory,
      name: AppRouteNames.sc262P2PFundLockHistory,
      builder: (_, _) =>
          P2PFundLockHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pWalletHistory,
      name: AppRouteNames.sc263P2PWalletHistoryAlias,
      builder: (_, _) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => P2PFundLockHistoryPage(
          walletHistoryAlias: true,
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pMyOrders,
      name: AppRouteNames.sc281P2PMyOrders,
      builder: (_, _) => P2PMyOrdersPage(shellRenderMode: shellRenderMode),
    ),
  ];

  if (surface == AppSurface.web) {
    return buildWebUtilityRouteFamily(
      routes: routes,
      title: 'Lệnh P2P',
      subtitle: 'Đơn hàng · ký quỹ · bằng chứng',
      description:
          'Không gian Web riêng để theo dõi lệnh, ký quỹ, trao đổi và lịch sử P2P. Các bước giải phóng hoặc xác nhận phải đi qua kiểm tra điều kiện an toàn.',
      backPath: AppRoutePaths.p2p,
      icon: Icons.receipt_long_outlined,
    );
  }
  return routes;
}

String p2pAssetFromQuery(String? value) {
  final asset = value?.toUpperCase();
  return switch (asset) {
    'BTC' || 'VND' || 'USDT' => asset!,
    _ => 'USDT',
  };
}

String p2pWalletTransferTypeFromQuery(Map<String, String> query) {
  return switch (query['direction']) {
    'to-main' => 'withdraw',
    'from-main' => 'deposit',
    _ => query['type'] == 'withdraw' ? 'withdraw' : 'deposit',
  };
}
