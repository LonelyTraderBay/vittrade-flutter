import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/notifications_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/router/contracts/auth_route_args.dart';
import 'package:vit_trade_flutter/app/router/tablet/tablet_route_manifest.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/auth/domain/entities/auth_entities.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/forgot_password_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/login_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/otp_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/register_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/reset_password_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/two_fa_setup_tablet_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/tablet/pages/home_tablet_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/pages/markets_tablet_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/widgets/markets_tablet_master_shell.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pair_depth_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pair_detail_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_token_info_pane.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/tablet/pages/profile_tablet_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_api_create_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_api_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_activity_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_devices_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_edit_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_kyc_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_security_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_settings_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_sub_accounts_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_vip_pane.dart';
import 'package:vit_trade_flutter/features/profile/presentation/tablet/widgets/profile_tablet_master_shell.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/convert_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/futures_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/leverage_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/margin_hub_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/margin_trading_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/orders_history_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/position_dashboard_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_history_export_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_settings_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_order_receipt_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/address_add_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/address_book_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/asset_detail_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/buy_crypto_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/deposit_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/dust_converter_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/network_status_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/pending_deposits_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/portfolio_analytics_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/transaction_detail_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/transaction_history_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/transfer_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_gas_optimizer_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_health_score_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_multi_manager_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_token_approval_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/withdraw_limits_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/withdraw_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/app/shell/tablet/tablet_app_shell.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';

/// Builds the complete Tablet route tree without importing the Phone/Web
/// composition or the compatibility router.
List<RouteBase> buildTabletRouteTree({
  required ShellRenderMode shellRenderMode,
}) {
  final marketSpecs = _sortedSpecs(tabletRouteManifest.where(_isMarketSpec));
  final profileSpecs = _sortedSpecs(tabletRouteManifest.where(_isProfileSpec));
  final contentSpecs = _sortedSpecs(
    tabletRouteManifest.where(
      (spec) =>
          !_tabletTopLevelPaths.contains(spec.path) &&
          !_isMarketSpec(spec) &&
          !_isProfileSpec(spec),
    ),
  );

  return [
    ..._tabletTopLevelRoutes(shellRenderMode),
    ShellRoute(
      builder: (context, state, child) => _TabletShell(
        shellRenderMode: shellRenderMode,
        state: state,
        child: child,
      ),
      routes: [
        _marketsShell(marketSpecs, shellRenderMode),
        _profileShell(profileSpecs),
        for (final spec in contentSpecs) _goRouteForSpec(spec, shellRenderMode),
      ],
    ),
  ];
}

List<RouteBase> _tabletTopLevelRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(path: AppRoutePaths.root, redirect: (_, _) => AppRoutePaths.home),
    GoRoute(
      path: AppRoutePaths.authLogin,
      name: AppRouteNames.sc001Login,
      builder: (_, _) => _TabletAuthShell(
        renderMode: shellRenderMode,
        child: const LoginTabletPage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authRegister,
      name: AppRouteNames.sc002Register,
      builder: (_, _) => _TabletAuthShell(
        renderMode: shellRenderMode,
        child: const RegisterTabletPage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authOtp,
      name: AppRouteNames.sc003Otp,
      builder: (_, state) => _TabletAuthShell(
        renderMode: shellRenderMode,
        child: OtpTabletPage(
          contact:
              _otpArgs(state).contact ??
              state.uri.queryParameters['contact'] ??
              'your@email.com',
          contactType: _otpArgs(state).contactType ?? _otpContactType(state),
          purpose: _otpArgs(state).purpose ?? _otpPurpose(state),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.auth2faSetup,
      name: AppRouteNames.sc004TwoFaSetup,
      builder: (_, _) => _TabletAuthShell(
        renderMode: shellRenderMode,
        child: const TwoFaSetupTabletPage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authForgotPassword,
      name: AppRouteNames.sc005ForgotPassword,
      builder: (_, _) => _TabletAuthShell(
        renderMode: shellRenderMode,
        child: const ForgotPasswordTabletPage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authResetPassword,
      name: AppRouteNames.sc006ResetPassword,
      builder: (_, _) => _TabletAuthShell(
        renderMode: shellRenderMode,
        child: const ResetPasswordTabletPage(),
      ),
    ),
    for (final spec in tabletRouteManifest.where(
      (spec) =>
          spec.path == AppRoutePaths.onboarding ||
          spec.path == AppRoutePaths.maintenanceGate ||
          spec.path == AppRoutePaths.forceUpdateGate,
    ))
      _goRouteForSpec(spec, shellRenderMode),
  ];
}

StatefulShellRoute _marketsShell(
  List<TabletRouteSpec> specs,
  ShellRenderMode shellRenderMode,
) {
  final orderedSpecs = [
    ...specs.where((spec) => spec.path == AppRoutePaths.markets),
    ...specs.where((spec) => spec.path != AppRoutePaths.markets),
  ];
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) => MarketsTabletMasterShell(
      navigationShell: navigationShell,
      currentPath: state.uri.path,
    ),
    branches: [
      StatefulShellBranch(
        routes: [
          for (final spec in orderedSpecs)
            _goRouteForSpec(spec, shellRenderMode),
        ],
      ),
    ],
  );
}

StatefulShellRoute _profileShell(List<TabletRouteSpec> specs) {
  final orderedSpecs = [
    ...specs.where((spec) => spec.path == AppRoutePaths.profile),
    ...specs.where((spec) => spec.path != AppRoutePaths.profile),
  ];
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) => ProfileTabletMasterShell(
      navigationShell: navigationShell,
      currentPath: state.uri.path,
    ),
    branches: [
      StatefulShellBranch(
        routes: [
          for (final spec in orderedSpecs) _goRouteForSpec(spec, null),
          _profileUtilityRoute(
            path: AppRoutePaths.settingsSecurity,
            name: AppRouteNames.sc413SettingsSecurity,
          ),
          _profileUtilityRoute(
            path: AppRoutePaths.settingsSecurityBiometric,
            name: AppRouteNames.sc405SettingsSecurityBiometric,
          ),
          _profileUtilityRoute(
            path: AppRoutePaths.settingsSecurityChangePassword,
            name: AppRouteNames.sc406SettingsSecurityChangePassword,
          ),
        ],
      ),
    ],
  );
}

GoRoute _profileUtilityRoute({required String path, required String name}) {
  return GoRoute(
    path: path,
    name: name,
    builder: (context, state) => _buildTabletPage(
      context,
      state,
      TabletRouteSpec(path: path, name: name),
      ShellRenderMode.native,
    ),
  );
}

GoRoute _goRouteForSpec(
  TabletRouteSpec spec,
  ShellRenderMode? shellRenderMode,
) {
  if (spec.isRedirectAlias) {
    return GoRoute(
      path: spec.path,
      name: spec.name,
      redirect: (_, _) => spec.redirectTarget,
    );
  }
  return GoRoute(
    path: spec.path,
    name: spec.name,
    builder: (context, state) => _buildTabletPage(
      context,
      state,
      spec,
      shellRenderMode ?? ShellRenderMode.native,
    ),
  );
}

Widget _buildTabletPage(
  BuildContext context,
  GoRouterState state,
  TabletRouteSpec spec,
  ShellRenderMode shellRenderMode,
) {
  final path = spec.path;

  if (path == AppRoutePaths.home) return const HomeTabletPage();

  if (path == AppRoutePaths.markets) return const MarketsTabletPage();
  if (path == '/pair/:pairId') {
    return MarketsPairDetailPane(pairId: _requiredParam(state, 'pairId'));
  }
  if (path == '/pair/:pairId/info') {
    return MarketsTokenInfoPane(pairId: _requiredParam(state, 'pairId'));
  }
  if (path == '/pair/:pairId/depth') {
    return MarketsPairDepthPane(pairId: _requiredParam(state, 'pairId'));
  }

  if (path == AppRoutePaths.trade) {
    return TradeTabletPage(
      initialSide: _tradeSideFromQuery(state.uri.queryParameters['side']),
    );
  }
  if (path == AppRoutePaths.tradeConvert) return const ConvertTabletPage();
  if (path == AppRoutePaths.tradeMargin) {
    return const MarginTradingTabletPage();
  }
  if (path == AppRoutePaths.tradeMarginBtcusdt) {
    return const MarginTradingTabletPage(
      pairId: 'btcusdt',
      pairRouteVariant: true,
    );
  }
  if (path == AppRoutePaths.tradeMarginHub) {
    return const MarginHubTabletPage();
  }
  if (path == AppRoutePaths.tradeOrderReceipt) {
    return TradeTabletOrderReceiptPage(shellRenderMode: shellRenderMode);
  }
  if (path == AppRoutePaths.tradeOrdersHistory) {
    return const OrdersHistoryTabletPage();
  }
  if (path == AppRoutePaths.tradePositions) {
    return const PositionDashboardTabletPage();
  }
  if (path == AppRoutePaths.tradeSettings) {
    return const TradeSettingsTabletPage();
  }
  if (path == AppRoutePaths.tradeExport) {
    return const TradeHistoryExportTabletPage();
  }
  if (path == '/trade/:pairId/futures/leverage') {
    return LeverageTabletPage(pairId: _requiredParam(state, 'pairId'));
  }
  if (path == '/trade/:pairId/futures') {
    return FuturesTabletPage(pairId: _requiredParam(state, 'pairId'));
  }
  if (path == '/trade/:pairId') {
    return TradeTabletPage(
      pairId: _requiredParam(state, 'pairId'),
      initialSide: _tradeSideFromQuery(state.uri.queryParameters['side']),
    );
  }

  if (path == AppRoutePaths.wallet) return const WalletTabletPage();
  if (path == AppRoutePaths.walletHistory) {
    return const TransactionHistoryTabletPage();
  }
  if (path == AppRoutePaths.walletDeposit) {
    return const DepositTabletPage();
  }
  if (path == '${AppRoutePaths.walletDeposit}/:asset') {
    return DepositTabletPage(
      asset: _requiredParam(state, 'asset'),
      assetScoped: true,
    );
  }
  if (path == AppRoutePaths.walletWithdraw) {
    return const WithdrawTabletPage();
  }
  if (path == '${AppRoutePaths.walletWithdraw}/:asset') {
    return WithdrawTabletPage(
      asset: _requiredParam(state, 'asset'),
      assetScoped: true,
    );
  }
  if (path == '/wallet/transaction/:txId') {
    return TransactionDetailTabletPage(
      transactionId: _requiredParam(state, 'txId'),
    );
  }
  if (path == AppRoutePaths.walletPortfolioAnalytics) {
    return const PortfolioAnalyticsTabletPage();
  }
  if (path == AppRoutePaths.walletAddressBookAdd) {
    return const AddressAddTabletPage();
  }
  if (path == AppRoutePaths.walletAddressBook) {
    return const AddressBookTabletPage();
  }
  if (path == AppRoutePaths.walletBuyCrypto) {
    return const BuyCryptoTabletPage();
  }
  if (path == AppRoutePaths.walletTransfer) {
    return const TransferTabletPage();
  }
  if (path == '/wallet/asset/:assetId') {
    return AssetDetailTabletPage(assetId: _requiredParam(state, 'assetId'));
  }
  if (path == AppRoutePaths.walletMultiManager) {
    return const WalletMultiManagerTabletPage();
  }
  if (path == AppRoutePaths.walletGasOptimizer) {
    return const WalletGasOptimizerTabletPage();
  }
  if (path == AppRoutePaths.walletTokenApproval) {
    return const WalletTokenApprovalTabletPage();
  }
  if (path == AppRoutePaths.walletHealthScore) {
    return const WalletHealthScoreTabletPage();
  }
  if (path == AppRoutePaths.walletPendingDeposits) {
    return const PendingDepositsTabletPage();
  }
  if (path == AppRoutePaths.walletLimits) {
    return const WithdrawLimitsTabletPage();
  }
  if (path == AppRoutePaths.walletDustConverter) {
    return const DustConverterTabletPage();
  }
  if (path == AppRoutePaths.walletNetworkStatus) {
    return const NetworkStatusTabletPage();
  }

  if (path == AppRoutePaths.profile) return const ProfileTabletPage();
  if (path == AppRoutePaths.profileEdit) return const ProfileEditPane();
  if (path == AppRoutePaths.profileKyc) return const ProfileKycPane();
  if (path == AppRoutePaths.profileSecurity ||
      path == AppRoutePaths.settingsSecurity) {
    return const ProfileSecurityPane();
  }
  if (path == AppRoutePaths.profileSettings) {
    return const ProfileSettingsPane();
  }
  if (path == AppRoutePaths.profileActivity) {
    return const ProfileActivityPane();
  }
  if (path == AppRoutePaths.profileApi) return const ProfileApiPane();
  if (path == AppRoutePaths.profileApiCreate) {
    return const ProfileApiCreatePane();
  }
  if (path == AppRoutePaths.profileVip) return const ProfileVipPane();
  if (path == AppRoutePaths.profileDevices) {
    return const ProfileDevicesPane();
  }
  if (path == AppRoutePaths.profileSubAccounts) {
    return const ProfileSubAccountsPane();
  }

  final profileUtility = _profileUtilityForRoute(path);
  if (profileUtility != null) return profileUtility;

  final p2pUtility = _p2pUtilityForRoute(path);
  if (p2pUtility != null) return p2pUtility;

  final utilityTitle = _tabletUtilityTitle(path);
  if (utilityTitle != null) {
    return VitTabletUtilityPage(
      semanticIdentifier: _semanticIdentifier(spec),
      title: utilityTitle,
      subtitle: _tabletUtilitySubtitle(utilityTitle),
      description: _tabletUtilityDescription(utilityTitle),
      facts: const [
        VitTabletUtilityFact(label: 'Surface', value: 'Tablet'),
        VitTabletUtilityFact(label: 'Trạng thái', value: 'Sẵn sàng mở rộng'),
      ],
      onBack: () => context.go(_backPathFor(path)),
      actionLabel: _requiresConfirmation(path) ? 'Xem trước điều kiện' : null,
      requiresConfirmation: _requiresConfirmation(path),
      confirmationTitle: 'Xác nhận bước tiếp theo',
    );
  }

  if (_isProfileSpec(spec)) {
    return ProfileTabletUtilityPage(
      semanticIdentifier: _semanticIdentifier(spec),
      title: 'Tài khoản trên Tablet',
      subtitle: 'Hồ sơ · bảo mật · thiết lập',
      description:
          'Màn hình này đã được tách riêng cho bố cục Tablet. Nội dung chi tiết sẽ được mở rộng trong pane tài khoản tương ứng.',
      icon: Icons.manage_accounts_outlined,
    );
  }

  if (_isP2pSpec(spec)) {
    return P2PTabletUtilityPage(
      semanticIdentifier: _semanticIdentifier(spec),
      title: 'P2P trên Tablet',
      subtitle: 'Giao dịch · đối chiếu · an toàn',
      description:
          'Thông tin P2P được trình bày trong không gian Tablet riêng, với điều kiện và bước tiếp theo được hiển thị rõ ràng.',
      facts: const [
        P2PTabletFact(label: 'Phạm vi', value: 'P2P'),
        P2PTabletFact(label: 'Trạng thái', value: 'Đang cập nhật'),
        P2PTabletFact(label: 'Bước tiếp theo', value: 'Rà soát điều kiện'),
      ],
      actionLabel: _requiresConfirmation(path) ? 'Xem trước điều kiện' : null,
      requiresConfirmation: _requiresConfirmation(path),
      confirmationTitle: 'Xác nhận bước P2P',
    );
  }

  if (_isTradeSpec(spec)) {
    return TradeTabletUtilityPage(
      semanticIdentifier: _semanticIdentifier(spec),
      title: 'Giao dịch trên Tablet',
      subtitle: 'Lệnh · điều kiện · quản trị rủi ro',
      description:
          'Màn hình giao dịch này có composition Tablet riêng. Phí, điều kiện và trạng thái thực thi cần được rà soát trước khi tiếp tục.',
      facts: const [
        TradeTabletFact(label: 'Khu vực', value: 'Giao dịch'),
        TradeTabletFact(label: 'Trạng thái', value: 'Đang cập nhật'),
      ],
      actionLabel: _requiresConfirmation(path) ? 'Xem trước điều kiện' : null,
      requiresConfirmation: _requiresConfirmation(path),
      confirmationTitle: 'Xác nhận rà soát giao dịch',
    );
  }

  return VitTabletUtilityPage(
    semanticIdentifier: _semanticIdentifier(spec),
    title: 'Tính năng trên Tablet',
    subtitle: 'Không gian Tablet · trạng thái tính năng',
    description:
        'Màn hình này đã được tách khỏi Phone và đang sử dụng composition Tablet theo route contract chung.',
    facts: const [
      VitTabletUtilityFact(label: 'Surface', value: 'Tablet'),
      VitTabletUtilityFact(label: 'Trạng thái', value: 'Sẵn sàng mở rộng'),
    ],
    onBack: () => context.go(_backPathFor(spec.path)),
    actionLabel: _requiresConfirmation(path) ? 'Xem trước điều kiện' : null,
    requiresConfirmation: _requiresConfirmation(path),
    confirmationTitle: 'Xác nhận bước tiếp theo',
  );
}

bool _isMarketSpec(TabletRouteSpec spec) {
  final path = spec.path;
  return path == AppRoutePaths.markets ||
      path.startsWith('${AppRoutePaths.markets}/') ||
      path.startsWith('/pair/');
}

bool _isProfileSpec(TabletRouteSpec spec) {
  final path = spec.path;
  return path == AppRoutePaths.profile ||
      path.startsWith('${AppRoutePaths.profile}/') ||
      path == AppRoutePaths.settingsSecurity ||
      path.startsWith('/settings/security/');
}

bool _isP2pSpec(TabletRouteSpec spec) => spec.path.startsWith('/p2p');

bool _isTradeSpec(TabletRouteSpec spec) =>
    spec.path == AppRoutePaths.trade ||
    spec.path.startsWith('${AppRoutePaths.trade}/');

bool _requiresConfirmation(String path) {
  const sensitiveMarkers = [
    'withdraw',
    'security',
    'kyc',
    'payment-method',
    'dispute',
    'insurance/claim',
    'risk',
    'regulatory',
    'compliance',
    'emergency',
    'stop',
    'client-money',
    'cost',
    'complaint',
  ];
  return sensitiveMarkers.any(path.contains);
}

String _backPathFor(String path) {
  if (path.startsWith('/p2p')) return AppRoutePaths.p2p;
  if (path.startsWith('/trade')) return AppRoutePaths.trade;
  if (path.startsWith('/wallet')) return AppRoutePaths.wallet;
  if (path.startsWith('/profile') || path.startsWith('/settings/security')) {
    return AppRoutePaths.profile;
  }
  if (path.startsWith('/markets') || path.startsWith('/pair/')) {
    return AppRoutePaths.markets;
  }
  return AppRoutePaths.home;
}

String? _tabletUtilityTitle(String path) {
  if (path == AppRoutePaths.support ||
      path.startsWith('${AppRoutePaths.support}/')) {
    return 'Hỗ trợ VitTrade';
  }
  if (path == AppRoutePaths.rewards) return 'Trung tâm phần thưởng';
  if (path == AppRoutePaths.adminSettings) return 'Cài đặt quản trị';
  if (path == AppRoutePaths.marketsOverview) return 'Công cụ thị trường';
  if (path == AppRoutePaths.marketsPredictions ||
      path.startsWith('${AppRoutePaths.marketsPredictions}/')) {
    return 'Prediction Markets';
  }
  if (path == AppRoutePaths.dca || path.startsWith('${AppRoutePaths.dca}/')) {
    return 'DCA';
  }
  if (path == AppRoutePaths.arena ||
      path.startsWith('${AppRoutePaths.arena}/')) {
    return 'Open Arena';
  }
  if (path == AppRoutePaths.launchpad ||
      path.startsWith('${AppRoutePaths.launchpad}/')) {
    return 'Launchpad';
  }
  if (path == AppRoutePaths.earnSavings ||
      path.startsWith('${AppRoutePaths.earnSavings}/')) {
    return 'Earn Savings';
  }
  if (path == AppRoutePaths.earn || path.startsWith('${AppRoutePaths.earn}/')) {
    return 'Earn Staking';
  }
  if (path == AppRoutePaths.tradeBots ||
      path.startsWith('${AppRoutePaths.tradeBots}/')) {
    return 'Trading Bots';
  }
  if (path == AppRoutePaths.tradeCopyTrading ||
      path.startsWith('${AppRoutePaths.tradeCopyTrading}/')) {
    return 'Copy Trading';
  }
  if (path == AppRoutePaths.tradeCopyRegulatoryDisclosures) {
    return 'Tuân thủ giao dịch';
  }
  if (path == AppRoutePaths.tradeRiskManagement) {
    return 'Giao dịch trên Tablet';
  }
  return null;
}

ProfileTabletUtilityPage? _profileUtilityForRoute(String path) {
  if (path == AppRoutePaths.settingsSecurityBiometric) {
    return const ProfileTabletUtilityPage(
      semanticIdentifier: 'SC-405',
      title: 'Sinh trắc học',
      subtitle: 'Xác thực · thiết bị',
      description: 'Bật hoặc tắt xác thực sinh trắc học cho thiết bị này.',
      icon: Icons.fingerprint,
    );
  }
  if (path == AppRoutePaths.settingsSecurityChangePassword) {
    return const ProfileTabletUtilityPage(
      semanticIdentifier: 'SC-406',
      title: 'Đổi mật khẩu',
      subtitle: 'Mật khẩu · xác nhận',
      description: 'Đặt mật khẩu mới và xác minh qua bước bảo mật tiếp theo.',
      icon: Icons.lock_outline_rounded,
    );
  }
  return null;
}

P2PTabletUtilityPage? _p2pUtilityForRoute(String path) {
  if (path == AppRoutePaths.p2p) {
    return p2pTabletUtility(
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
    );
  }
  if (path == AppRoutePaths.p2pSecurity2fa) {
    return p2pTabletUtility(
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
    );
  }
  if (path.startsWith('/p2p/dispute/')) {
    return p2pTabletUtility(
      semanticIdentifier: 'SC-221',
      title: 'Mở tranh chấp P2P',
      subtitle: 'Tranh chấp · giao dịch · bằng chứng',
      description:
          'Kiểm tra giao dịch, lý do và bằng chứng cần chuẩn bị trước khi mở tranh chấp.',
      facts: const [
        P2PTabletFact(label: 'Giao dịch', value: 'Đã chọn'),
        P2PTabletFact(label: 'Lý do', value: 'Cần chọn'),
        P2PTabletFact(label: 'Trạng thái', value: 'Chưa gửi'),
      ],
      actionLabel: 'Mở tranh chấp',
      requiresConfirmation: true,
      confirmationTitle: 'Xác nhận mở tranh chấp',
      icon: Icons.report_gmailerrorred_outlined,
    );
  }
  if (path.startsWith('/p2p/order/cancel/')) {
    return p2pTabletUtility(
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
    );
  }
  return null;
}

String _tabletUtilitySubtitle(String title) {
  return switch (title) {
    'Hỗ trợ VitTrade' => 'Hỗ trợ · yêu cầu · trạng thái',
    'Trung tâm phần thưởng' => 'Phần thưởng · nhiệm vụ · tiến độ',
    'Cài đặt quản trị' => 'Quản trị · quyền · cấu hình',
    'Công cụ thị trường' => 'Dữ liệu · phân tích · theo dõi',
    'Prediction Markets' => 'Phân tích và quản trị vị thế trên Tablet',
    'DCA' => 'Chiến lược phân bổ định kỳ trên Tablet',
    'Open Arena' => 'Không gian thử thách và điểm Arena trên Tablet',
    'Launchpad' => 'Quản trị tài sản phát hành trên Tablet',
    'Earn Savings' => 'Tích lũy linh hoạt và mục tiêu tài chính trên Tablet',
    'Earn Staking' => 'Staking, validator và quản trị rủi ro trên Tablet',
    'Trading Bots' => 'Tự động hóa giao dịch và kiểm soát rủi ro trên Tablet',
    'Copy Trading' => 'Theo dõi nhà giao dịch và quản trị sao chép trên Tablet',
    _ => 'Lệnh · điều kiện · quản trị rủi ro',
  };
}

String _tabletUtilityDescription(String title) {
  return switch (title) {
    'Hỗ trợ VitTrade' =>
      'Tìm đúng kênh hỗ trợ và theo dõi yêu cầu trong bố cục Tablet rõ ràng.',
    'Trung tâm phần thưởng' =>
      'Theo dõi nhiệm vụ, phần thưởng và tiến độ trong bố cục Tablet rõ ràng.',
    'Cài đặt quản trị' => 'Rà soát quyền và cấu hình quản trị trước khi lưu.',
    'Công cụ thị trường' =>
      'Theo dõi dữ liệu, biến động và công cụ phân tích trong không gian Tablet.',
    'Prediction Markets' =>
      'Không gian Tablet tập trung cho dữ liệu, vị thế và quyết định có kiểm soát.',
    'DCA' =>
      'Không gian Tablet để theo dõi cấu hình, lịch thực hiện và hiệu suất DCA.',
    'Open Arena' =>
      'Không gian Tablet riêng cho thử thách, điểm Arena và an toàn cộng đồng.',
    'Launchpad' =>
      'Không gian Tablet để theo dõi dự án, giao dịch phát hành và công cụ Launchpad.',
    'Earn Savings' =>
      'Không gian Tablet để theo dõi sản phẩm tiết kiệm, mục tiêu, lợi suất và lịch sử.',
    'Earn Staking' =>
      'Không gian Tablet để theo dõi lợi suất staking, validator và các chính sách liên quan.',
    'Trading Bots' =>
      'Không gian Tablet để theo dõi bot, hiệu suất, cấu hình và điều kiện an toàn.',
    'Copy Trading' =>
      'Không gian Tablet để xem nhà cung cấp, hiệu suất và các lớp an toàn Copy Trading.',
    _ =>
      'Màn hình giao dịch này có composition Tablet riêng. Phí, điều kiện và trạng thái thực thi cần được rà soát trước khi tiếp tục.',
  };
}

String _semanticIdentifier(TabletRouteSpec spec) {
  final value = spec.name ?? spec.path;
  final normalized = value.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_');
  return 'TABLET_${normalized.toUpperCase()}';
}

List<TabletRouteSpec> _sortedSpecs(Iterable<TabletRouteSpec> specs) {
  final result = specs.toList(growable: true);
  result.sort((a, b) {
    final specificity = _routeSpecificity(b.path) - _routeSpecificity(a.path);
    if (specificity != 0) return specificity;
    return a.path.compareTo(b.path);
  });
  return result;
}

int _routeSpecificity(String path) {
  final segments = path.split('/').where((segment) => segment.isNotEmpty);
  var score = 0;
  for (final segment in segments) {
    score += segment.startsWith(':') ? 1 : 10;
  }
  return score * 100 + path.length;
}

String _requiredParam(GoRouterState state, String key) {
  final value = state.pathParameters[key];
  if (value == null || value.isEmpty) {
    throw StateError(
      'Thiếu path param bắt buộc "$key" cho route ${state.uri}.',
    );
  }
  return value;
}

OtpPageRouteArgs _otpArgs(GoRouterState state) {
  return state.extra is OtpPageRouteArgs
      ? state.extra! as OtpPageRouteArgs
      : const OtpPageRouteArgs();
}

AuthOtpPurpose _otpPurpose(GoRouterState state) {
  return switch (state.uri.queryParameters['purpose']) {
    'register' => AuthOtpPurpose.register,
    'twoFactor' || '2fa' => AuthOtpPurpose.twoFactor,
    'passwordReset' || 'reset' => AuthOtpPurpose.passwordReset,
    _ => AuthOtpPurpose.verify,
  };
}

AuthContactType _otpContactType(GoRouterState state) {
  return state.uri.queryParameters['type'] == 'phone'
      ? AuthContactType.phone
      : AuthContactType.email;
}

TradeOrderSide _tradeSideFromQuery(String? value) {
  return value == 'sell' ? TradeOrderSide.sell : TradeOrderSide.buy;
}

const _tabletTopLevelPaths = <String>{
  AppRoutePaths.root,
  AppRoutePaths.authLogin,
  AppRoutePaths.authRegister,
  AppRoutePaths.authOtp,
  AppRoutePaths.auth2faSetup,
  AppRoutePaths.authForgotPassword,
  AppRoutePaths.authResetPassword,
  AppRoutePaths.onboarding,
  AppRoutePaths.maintenanceGate,
  AppRoutePaths.forceUpdateGate,
};

class _TabletShell extends ConsumerWidget {
  const _TabletShell({
    required this.shellRenderMode,
    required this.state,
    required this.child,
  });

  final ShellRenderMode shellRenderMode;
  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeDestination = _activeDestinationForPath(state.uri.path);
    final badgeCount = ref.watch(notificationUnreadCountProvider);
    return TabletAppShell(
      renderMode: shellRenderMode,
      activeDestination: activeDestination,
      notificationBadgeCount: badgeCount,
      statusBarTime: shellRenderMode.usesVisualQaFrame ? '23:38' : null,
      onDestinationSelected: (destination) => context.go(destination.routePath),
      child: child,
    );
  }
}

VitBottomNavDestination _activeDestinationForPath(String path) {
  if (path == AppRoutePaths.home ||
      path == AppRoutePaths.news ||
      path == AppRoutePaths.search ||
      path == AppRoutePaths.notifications ||
      path == AppRoutePaths.topics ||
      path.startsWith('/topic/') ||
      path == AppRoutePaths.support ||
      path.startsWith('/support/')) {
    return VitBottomNavDestination.home;
  }
  if (path == AppRoutePaths.wallet || path.startsWith('/wallet/')) {
    return VitBottomNavDestination.wallet;
  }
  if (path == AppRoutePaths.markets ||
      path.startsWith('/markets/') ||
      path.startsWith('/pair/')) {
    return VitBottomNavDestination.markets;
  }
  if (path.startsWith('/profile/') ||
      path == AppRoutePaths.profile ||
      path.startsWith('/settings/security')) {
    return VitBottomNavDestination.profile;
  }
  return VitBottomNavDestination.trade;
}

class _TabletAuthShell extends StatelessWidget {
  const _TabletAuthShell({required this.child, required this.renderMode});

  final Widget child;
  final ShellRenderMode renderMode;

  @override
  Widget build(BuildContext context) {
    final body = Material(
      color: AppColors.bg,
      child: SizedBox.expand(child: child),
    );
    if (!renderMode.usesVisualQaFrame) {
      return SafeArea(top: true, bottom: false, child: body);
    }
    return Material(
      color: AppColors.bg,
      child: Column(
        children: [
          const VitStatusBar(time: '23:27'),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class TabletRouteErrorPage extends StatelessWidget {
  const TabletRouteErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bg,
      child: SafeArea(
        child: Center(
          child: VitErrorState(
            title: 'Không tìm thấy trang',
            message: 'Liên kết không hợp lệ hoặc nội dung đã bị gỡ.',
            icon: Icons.explore_off_rounded,
            actionLabel: 'Về trang chủ',
            onAction: () => context.go(AppRoutePaths.home),
          ),
        ),
      ),
    );
  }
}
