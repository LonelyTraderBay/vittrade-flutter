// Phone-only route group. Surface-specific Phone/Web builders stay outside this composition.

import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/tools/wallet_token_approval_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/withdraw_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/transfer/withdraw_limits_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/placeholder_routes.dart';

List<RouteBase> walletRoutes(ShellRenderMode shellRenderMode) {
  final routes = <RouteBase>[
    GoRoute(
      path: AppRoutePaths.wallet,
      name: AppRouteNames.sc135Wallet,
      builder: (_, _) => WalletPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletHistory,
      name: AppRouteNames.sc136TxHistory,
      builder: (_, _) =>
          TransactionHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletDeposit,
      name: AppRouteNames.sc137Deposit,
      builder: (_, _) => DepositPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '${AppRoutePaths.walletDeposit}/:asset',
      name: AppRouteNames.sc138DepositUsdt,
      builder: (_, state) {
        final asset = state.pathParameters['asset'] ?? 'USDT';
        return DepositPage(
          // SEC-S45: default hợp lý UX (chợ/tài sản mặc định, không phải thực thể riêng tư) — giữ.
          asset: asset,
          assetScoped: true,
          shellRenderMode: shellRenderMode,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletWithdraw,
      name: AppRouteNames.sc139Withdraw,
      builder: (_, _) => WithdrawPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '${AppRoutePaths.walletWithdraw}/:asset',
      name: AppRouteNames.sc140WithdrawUsdt,
      builder: (_, state) {
        final asset = state.pathParameters['asset'] ?? 'USDT';
        return WithdrawPage(
          // SEC-S45: default hợp lý UX (chợ/tài sản mặc định, không phải thực thể riêng tư) — giữ.
          asset: asset,
          assetScoped: true,
          shellRenderMode: shellRenderMode,
        );
      },
    ),
    GoRoute(
      path: '/wallet/transaction/:txId',
      name: AppRouteNames.sc141TransactionDetail,
      builder: (_, state) {
        final transactionId = requireRouteParam(state, 'txId');
        return TransactionDetailPage(
          transactionId: transactionId,
          shellRenderMode: shellRenderMode,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletPortfolioAnalytics,
      name: AppRouteNames.sc142PortfolioAnalytics,
      builder: (_, _) =>
          PortfolioAnalyticsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletAddressBookAdd,
      name: AppRouteNames.sc143AddressAdd,
      builder: (_, _) => AddressAddPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletAddressBook,
      name: AppRouteNames.sc144AddressBook,
      builder: (_, _) => AddressBookPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletBuyCrypto,
      name: AppRouteNames.sc145BuyCrypto,
      builder: (_, _) => BuyCryptoPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletTransfer,
      name: AppRouteNames.sc146Transfer,
      builder: (_, _) => TransferPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/wallet/asset/:assetId',
      name: AppRouteNames.sc147AssetDetail,
      builder: (_, state) {
        final assetId = state.pathParameters['assetId'] ?? 'btc';
        return AssetDetailPage(
          // SEC-S45: default hợp lý UX (chợ/tài sản mặc định, không phải thực thể riêng tư) — giữ.
          assetId: assetId,
          shellRenderMode: shellRenderMode,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.walletMultiManager,
      name: AppRouteNames.sc148MultiManager,
      builder: (_, _) =>
          WalletMultiManagerPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletGasOptimizer,
      name: AppRouteNames.sc149GasOptimizer,
      builder: (_, _) =>
          WalletGasOptimizerPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletTokenApproval,
      name: AppRouteNames.sc150TokenApproval,
      builder: (_, _) =>
          WalletTokenApprovalPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletHealthScore,
      name: AppRouteNames.sc151HealthScore,
      builder: (_, _) =>
          WalletHealthScorePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletPendingDeposits,
      name: AppRouteNames.sc152PendingDeposits,
      builder: (_, _) => PendingDepositsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletLimits,
      name: AppRouteNames.sc153WithdrawLimits,
      builder: (_, _) => WithdrawLimitsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletDustConverter,
      name: AppRouteNames.sc154DustConverter,
      builder: (_, _) => DustConverterPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.walletNetworkStatus,
      name: AppRouteNames.sc155NetworkStatus,
      builder: (_, _) => NetworkStatusPage(shellRenderMode: shellRenderMode),
    ),
    ...walletOutgoingPlaceholders,
  ];

  return routes;
}
