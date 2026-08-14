import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/p2p_orders/presentation/pages/orders/p2p_chat_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/pages/orders/p2p_escrow_balance_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/pages/orders/p2p_escrow_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/pages/orders/p2p_fund_lock_history_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/pages/orders/p2p_my_orders_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/pages/orders/p2p_order_cancel_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/pages/orders/p2p_order_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/pages/orders/p2p_order_proof_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/pages/orders/p2p_order_rate_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/pages/orders/p2p_order_timeline_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/pages/wallet/p2p_wallet_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/pages/wallet/p2p_wallet_transfer_page.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> p2pOrdersRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  return [
    GoRoute(
      path: '/p2p/order/timeline/:orderId',
      name: AppRouteNames.sc212P2POrderTimeline,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-212',
          title: 'Dòng thời gian lệnh P2P',
          subtitle: 'Lệnh · trạng thái · thời gian',
          description:
              'Theo dõi từng bước của lệnh P2P và trạng thái xử lý trong bố cục Tablet.',
          facts: const [
            P2PTabletFact(label: 'Lệnh', value: 'Đã chọn'),
            P2PTabletFact(label: 'Bước hiện tại', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang xử lý'),
          ],
          actionLabel: 'Lọc dòng thời gian',
          icon: Icons.timeline_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2POrderTimelinePage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/order/rate/:orderId',
      name: AppRouteNames.sc213P2POrderRate,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-213',
          title: 'Đánh giá lệnh P2P',
          subtitle: 'Đánh giá · phản hồi · uy tín',
          description:
              'Rà soát nội dung đánh giá và xác nhận phản hồi sau khi hoàn tất lệnh P2P.',
          facts: const [
            P2PTabletFact(label: 'Lệnh', value: 'Đã chọn'),
            P2PTabletFact(label: 'Điểm đánh giá', value: 'Chưa chọn'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa gửi'),
          ],
          actionLabel: 'Gửi đánh giá',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận gửi đánh giá lệnh',
          icon: Icons.star_border_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2POrderRatePage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/order/cancel/:orderId',
      name: AppRouteNames.sc214P2POrderCancel,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-214',
          title: 'Hủy lệnh P2P',
          subtitle: 'Lệnh · hủy · điều kiện',
          description:
              'Kiểm tra điều kiện, tác động và bước xác nhận trước khi hủy lệnh P2P.',
          facts: const [
            P2PTabletFact(label: 'Lệnh', value: 'Đã chọn'),
            P2PTabletFact(label: 'Điều kiện hủy', value: 'Đang kiểm tra'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa hủy'),
          ],
          actionLabel: 'Xem trước hủy lệnh',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận hủy lệnh P2P',
          icon: Icons.cancel_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2POrderCancelPage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/order/proof/:orderId',
      name: AppRouteNames.sc215P2POrderProof,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-215',
          title: 'Bằng chứng thanh toán P2P',
          subtitle: 'Lệnh · bằng chứng · xác nhận',
          description:
              'Rà soát bằng chứng thanh toán và xác nhận nội dung trước khi gửi cho đối tác.',
          facts: const [
            P2PTabletFact(label: 'Lệnh', value: 'Đã chọn'),
            P2PTabletFact(label: 'Bằng chứng', value: 'Cần bổ sung'),
            P2PTabletFact(label: 'Trạng thái', value: 'Chưa gửi'),
          ],
          actionLabel: 'Gửi bằng chứng',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận gửi bằng chứng thanh toán',
          icon: Icons.receipt_long_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2POrderProofPage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/order/:orderId',
      name: AppRouteNames.sc216P2POrder,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-216',
          title: 'Chi tiết lệnh P2P',
          subtitle: 'Lệnh · thanh toán · trạng thái',
          description:
              'Theo dõi chi tiết lệnh, điều kiện thanh toán và bước tiếp theo trong bố cục Tablet.',
          facts: const [
            P2PTabletFact(label: 'Lệnh', value: 'Đã chọn'),
            P2PTabletFact(label: 'Tài sản', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang xử lý'),
          ],
          actionLabel: 'Mở thao tác lệnh',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận thao tác lệnh P2P',
          icon: Icons.receipt_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2POrderPage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/chat/:orderId',
      name: AppRouteNames.sc217P2PChat,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-217',
          title: 'Trao đổi lệnh P2P',
          subtitle: 'Lệnh · trao đổi · an toàn',
          description:
              'Theo dõi trao đổi liên quan đến lệnh và các nhắc nhở an toàn trong bố cục Tablet.',
          facts: const [
            P2PTabletFact(label: 'Lệnh', value: 'Đã chọn'),
            P2PTabletFact(label: 'Tin nhắn mới', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Cảnh báo', value: 'Không chia sẻ mã bảo mật'),
          ],
          actionLabel: 'Mở hướng dẫn trao đổi an toàn',
          icon: Icons.chat_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PChatPage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pEscrowBalance,
      name: AppRouteNames.sc245P2PEscrowBalance,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-245',
          title: 'Số dư ký quỹ P2P',
          subtitle: 'Ký quỹ · tài sản · bảo vệ',
          description:
              'Theo dõi số dư ký quỹ và tài sản đang được bảo vệ trong các lệnh P2P.',
          facts: const [
            P2PTabletFact(label: 'Tài sản', value: 'Theo lựa chọn'),
            P2PTabletFact(label: 'Số dư ký quỹ', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang bảo vệ'),
          ],
          actionLabel: 'Xem lịch sử ký quỹ',
          icon: Icons.account_balance_wallet_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PEscrowBalancePage(
          initialAsset: p2pAssetFromQuery(state.uri.queryParameters['asset']),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: '/p2p/escrow/:orderId',
      name: AppRouteNames.sc246P2PEscrowDetail,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-246',
          title: 'Chi tiết ký quỹ P2P',
          subtitle: 'Ký quỹ · lệnh · giải phóng',
          description:
              'Rà soát trạng thái ký quỹ, điều kiện giải phóng và bước xác nhận liên quan đến lệnh.',
          facts: const [
            P2PTabletFact(label: 'Lệnh', value: 'Đã chọn'),
            P2PTabletFact(label: 'Số dư ký quỹ', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang khóa'),
          ],
          actionLabel: 'Xem trước thao tác ký quỹ',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận thao tác ký quỹ',
          icon: Icons.lock_clock_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PEscrowDetailPage(
          orderId: requireRouteParam(state, 'orderId'),
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pWallet,
      name: AppRouteNames.sc264P2PWallet,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-264',
          title: 'Ví P2P',
          subtitle: 'Ví · số dư · chuyển tiền',
          description:
              'Theo dõi số dư dành cho P2P và các hoạt động chuyển tiền trong bố cục Tablet.',
          facts: const [
            P2PTabletFact(label: 'Số dư khả dụng', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Tài sản', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Trạng thái', value: 'Đang hoạt động'),
          ],
          actionLabel: 'Mở chuyển tiền P2P',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận mở chuyển tiền P2P',
          icon: Icons.wallet_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PWalletPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pWalletTransfer,
      name: AppRouteNames.sc261P2PWalletTransfer,
      builder: (_, state) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-261',
          title: 'Chuyển tiền trong ví P2P',
          subtitle: 'Ví · chuyển tiền · xác nhận',
          description:
              'Kiểm tra tài sản, hướng chuyển và số tiền trước khi xác nhận chuyển trong ví P2P.',
          facts: const [
            P2PTabletFact(label: 'Tài sản', value: 'Theo lựa chọn'),
            P2PTabletFact(label: 'Hướng chuyển', value: 'Theo yêu cầu'),
            P2PTabletFact(label: 'Số tiền', value: 'Cần nhập'),
          ],
          actionLabel: 'Xem trước chuyển tiền',
          requiresConfirmation: true,
          confirmationTitle: 'Xác nhận chuyển tiền trong ví P2P',
          icon: Icons.swap_horiz_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => () {
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
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-262',
          title: 'Lịch sử khóa quỹ P2P',
          subtitle: 'Ví · ký quỹ · lịch sử',
          description:
              'Đối chiếu lịch sử khóa quỹ, giải phóng và trạng thái các giao dịch P2P.',
          facts: const [
            P2PTabletFact(label: 'Giao dịch gần đây', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Đang khóa', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Đã giải phóng', value: 'Đang cập nhật'),
          ],
          actionLabel: 'Lọc lịch sử khóa quỹ',
          icon: Icons.history_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PFundLockHistoryPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pWalletHistory,
      name: AppRouteNames.sc263P2PWalletHistoryAlias,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-263',
          title: 'Lịch sử ví P2P',
          subtitle: 'Ví · giao dịch · lịch sử',
          description:
              'Theo dõi lịch sử biến động ví và các giao dịch liên quan đến P2P.',
          facts: const [
            P2PTabletFact(label: 'Biến động gần đây', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Tài sản', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Cảnh báo', value: 'Không có'),
          ],
          actionLabel: 'Lọc lịch sử ví',
          icon: Icons.receipt_long_outlined,
        ),
        AppSurface.phone || AppSurface.web || null => P2PFundLockHistoryPage(
          walletHistoryAlias: true,
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.p2pMyOrders,
      name: AppRouteNames.sc281P2PMyOrders,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => p2pTabletUtility(
          semanticIdentifier: 'SC-281',
          title: 'Lệnh P2P của tôi',
          subtitle: 'Lệnh · trạng thái · lịch sử',
          description:
              'Theo dõi lệnh mua bán, trạng thái thanh toán và bước tiếp theo trong bố cục Tablet.',
          facts: const [
            P2PTabletFact(label: 'Lệnh đang mở', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Chờ thanh toán', value: 'Đang cập nhật'),
            P2PTabletFact(label: 'Đã hoàn tất', value: 'Đang cập nhật'),
          ],
          actionLabel: 'Lọc lệnh của tôi',
          icon: Icons.list_alt_outlined,
        ),
        AppSurface.phone ||
        AppSurface.web ||
        null => P2PMyOrdersPage(shellRenderMode: shellRenderMode),
      },
    ),
  ];
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
