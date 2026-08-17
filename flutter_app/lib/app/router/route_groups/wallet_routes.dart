import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/address_add_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/address_book_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/assets/asset_detail_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/assets/buy_crypto_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/deposit_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/assets/dust_converter_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/tools/network_status_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/pending_deposits_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/tools/portfolio_analytics_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/transaction_detail_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/transaction_history_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/transfer_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/tools/wallet_gas_optimizer_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/tools/wallet_health_score_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/tools/wallet_multi_manager_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/wallet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/tools/wallet_token_approval_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/withdraw_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/deposit_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/address_book_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/address_add_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/asset_detail_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/buy_crypto_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/portfolio_analytics_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/transaction_detail_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/transaction_history_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/pending_deposits_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/transfer_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/withdraw_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_multi_manager_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_gas_optimizer_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_health_score_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_token_approval_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/withdraw_limits_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/dust_converter_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/network_status_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/transfer/withdraw_limits_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/placeholder_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

List<RouteBase> walletRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <RouteBase>[
    GoRoute(
      path: AppRoutePaths.wallet,
      name: AppRouteNames.sc135Wallet,
      builder: (_, _) => switch (surface) {
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => WalletPage(shellRenderMode: shellRenderMode),
        AppSurface.tablet => const WalletTabletPage(),
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletHistory,
      name: AppRouteNames.sc136TxHistory,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const TransactionHistoryTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => TransactionHistoryPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletDeposit,
      name: AppRouteNames.sc137Deposit,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const DepositTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => DepositPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: '${AppRoutePaths.walletDeposit}/:asset',
      name: AppRouteNames.sc138DepositUsdt,
      builder: (_, state) {
        final asset = state.pathParameters['asset'] ?? 'USDT';
        return switch (surface) {
          AppSurface.tablet => DepositTabletPage(
            asset: asset,
            assetScoped: true,
          ),
          // Web surface composition is migrated in P7.
          AppSurface.phone || AppSurface.web || null => DepositPage(
            // SEC-S45: default hợp lý UX (chợ/tài sản mặc định, không phải thực thể riêng tư) — giữ.
            asset: asset,
            assetScoped: true,
            shellRenderMode: shellRenderMode,
          ),
        };
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletWithdraw,
      name: AppRouteNames.sc139Withdraw,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const WithdrawTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => WithdrawPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: '${AppRoutePaths.walletWithdraw}/:asset',
      name: AppRouteNames.sc140WithdrawUsdt,
      builder: (_, state) {
        final asset = state.pathParameters['asset'] ?? 'USDT';
        return switch (surface) {
          AppSurface.tablet => WithdrawTabletPage(
            asset: asset,
            assetScoped: true,
          ),
          // Web surface composition is migrated in P7.
          AppSurface.phone || AppSurface.web || null => WithdrawPage(
            // SEC-S45: default hợp lý UX (chợ/tài sản mặc định, không phải thực thể riêng tư) — giữ.
            asset: asset,
            assetScoped: true,
            shellRenderMode: shellRenderMode,
          ),
        };
      },
    ),
    GoRoute(
      path: '/wallet/transaction/:txId',
      name: AppRouteNames.sc141TransactionDetail,
      builder: (_, state) {
        final transactionId = requireRouteParam(state, 'txId');
        return switch (surface) {
          AppSurface.tablet => TransactionDetailTabletPage(
            transactionId: transactionId,
          ),
          // Web surface composition is migrated in P7.
          AppSurface.phone || AppSurface.web || null => TransactionDetailPage(
            transactionId: transactionId,
            shellRenderMode: shellRenderMode,
          ),
        };
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletPortfolioAnalytics,
      name: AppRouteNames.sc142PortfolioAnalytics,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const PortfolioAnalyticsTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => PortfolioAnalyticsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletAddressBookAdd,
      name: AppRouteNames.sc143AddressAdd,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const AddressAddTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => AddressAddPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletAddressBook,
      name: AppRouteNames.sc144AddressBook,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const AddressBookTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => AddressBookPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletBuyCrypto,
      name: AppRouteNames.sc145BuyCrypto,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const BuyCryptoTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => BuyCryptoPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletTransfer,
      name: AppRouteNames.sc146Transfer,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const TransferTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => TransferPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: '/wallet/asset/:assetId',
      name: AppRouteNames.sc147AssetDetail,
      builder: (_, state) {
        final assetId = state.pathParameters['assetId'] ?? 'btc';
        return switch (surface) {
          AppSurface.tablet => AssetDetailTabletPage(assetId: assetId),
          // Web surface composition is migrated in P7.
          AppSurface.phone || AppSurface.web || null => AssetDetailPage(
            // SEC-S45: default hợp lý UX (chợ/tài sản mặc định, không phải thực thể riêng tư) — giữ.
            assetId: assetId,
            shellRenderMode: shellRenderMode,
          ),
        };
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletMultiManager,
      name: AppRouteNames.sc148MultiManager,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const WalletMultiManagerTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => WalletMultiManagerPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletGasOptimizer,
      name: AppRouteNames.sc149GasOptimizer,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const WalletGasOptimizerTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => WalletGasOptimizerPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletTokenApproval,
      name: AppRouteNames.sc150TokenApproval,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const WalletTokenApprovalTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => WalletTokenApprovalPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletHealthScore,
      name: AppRouteNames.sc151HealthScore,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const WalletHealthScoreTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => WalletHealthScorePage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletPendingDeposits,
      name: AppRouteNames.sc152PendingDeposits,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const PendingDepositsTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => PendingDepositsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletLimits,
      name: AppRouteNames.sc153WithdrawLimits,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const WithdrawLimitsTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => WithdrawLimitsPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletDustConverter,
      name: AppRouteNames.sc154DustConverter,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const DustConverterTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => DustConverterPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletNetworkStatus,
      name: AppRouteNames.sc155NetworkStatus,
      builder: (_, _) => switch (surface) {
        AppSurface.tablet => const NetworkStatusTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => NetworkStatusPage(shellRenderMode: shellRenderMode),
      },
    ),
    ...walletOutgoingPlaceholders,
  ];

  if (surface == AppSurface.web) {
    return buildWebUtilityRouteFamily(
      routes: routes,
      title: 'Ví và tài sản',
      subtitle: 'Tài sản · lịch sử · công cụ quản lý',
      description:
          'Không gian Web riêng cho quản lý tài sản, lịch sử giao dịch và công cụ ví. Các điều kiện phí, hạn mức và xác nhận vẫn được rà soát trước khi thực thi.',
      backPath: AppRoutePaths.home,
      icon: Icons.account_balance_wallet_outlined,
    );
  }
  return routes;
}
