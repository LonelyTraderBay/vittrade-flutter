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
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_calendar_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_advanced_charts_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_alerts_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_compare_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_derivatives_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_depth_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_heatmap_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_movers_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_news_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_overview_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_portfolio_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_unlocks_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_signals_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_correlations_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_watchlist_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_sectors_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_screener_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_sentiment_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pair_depth_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pair_detail_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_token_info_pane.dart';
import 'package:vit_trade_flutter/features/news/presentation/tablet/pages/news_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/domain/entities/p2p_shared_entities.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_home_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_dashboard_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_express_confirm_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_express_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_order_book_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_ad_analytics_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_ad_detail_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_create_ad_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_my_ads_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_order_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_chat_tablet_page.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_wallet_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_merchant_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_kyc_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_payment_method_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_dispute_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_insurance_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_security_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_account_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_compliance_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_settings_tablet_pages.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_my_orders_tablet_page.dart';
import 'package:vit_trade_flutter/features/rewards/presentation/tablet/pages/rewards_tablet_page.dart';
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
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/advanced_analytics_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/advanced_chart_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/advanced_tools_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/advanced_trading_demo_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/convert_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/copy_trading_card_demo_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/execution_quality_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/futures_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/leverage_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/live_market_data_analytics_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/margin_hub_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/margin_trading_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/market_data_analytics_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/orders_history_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/risk_management_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/tablet/pages/copy_trading_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/tablet/pages/copy_trading_core_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/tablet/pages/copy_flow_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/tablet/pages/copy_remaining_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/tablet/pages/copy_trading_extended_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/tablet/pages/regulatory_disclosures_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/tablet/pages/trade_bots_tablet_pages.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/tablet/pages/earn_savings_tablet_pages.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/tablet/pages/staking_tablet_pages.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_tablet_pages.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/tablet/pages/launchpad_tablet_pages.dart';
import 'package:vit_trade_flutter/features/arena/presentation/tablet/pages/arena_tablet_pages.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/tablet/pages/cross_module_tablet_pages.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/tablet/pages/misc_gate_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/tablet/pages/compliance_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/tablet/pages/compliance_regulatory_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/tablet/pages/costs_disclosure_tablet_pages.dart';
import 'package:vit_trade_flutter/features/dca/presentation/tablet/pages/dca_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/tablet/pages/compliance_reports_tablet_pages.dart';
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
  if (path == AppRoutePaths.news) return const NewsTabletPage();
  if (path == AppRoutePaths.rewards) return const RewardsTabletPage();
  if (path == AppRoutePaths.p2p) return const P2PHomeTabletPage();
  if (path == AppRoutePaths.p2pOrderBook) {
    return P2POrderBookTabletPage(
      initialAsset: state.uri.queryParameters['asset'] ?? 'USDT',
    );
  }
  if (path == AppRoutePaths.p2pDashboard) return const P2PDashboardTabletPage();
  if (path == AppRoutePaths.p2pExpress) return const P2PExpressTabletPage();
  if (path == AppRoutePaths.p2pExpressConfirm) {
    return P2PExpressConfirmTabletPage(
      tradeType: state.uri.queryParameters['type'] == 'sell'
          ? P2PTradeType.sell
          : P2PTradeType.buy,
      asset: state.uri.queryParameters['asset'] ?? 'USDT',
      fiatAmount: double.tryParse(state.uri.queryParameters['fiat'] ?? '') ?? 0,
      cryptoAmount:
          double.tryParse(state.uri.queryParameters['crypto'] ?? '') ?? 0,
      adId: state.uri.queryParameters['adId'],
      paymentMethod: state.uri.queryParameters['payment'],
    );
  }

  if (path == AppRoutePaths.p2pCreate) return const P2PCreateAdTabletPage();
  if (path == AppRoutePaths.p2pMyAds) return const P2PMyAdsTabletPage();
  if (path == '/p2p/ad-analytics/:adId') {
    return P2PAdAnalyticsTabletPage(adId: _requiredParam(state, 'adId'));
  }
  if (path == '/p2p/ad/:adId') {
    return P2PAdDetailTabletPage(adId: _requiredParam(state, 'adId'));
  }

  if (path == '/p2p/order/timeline/:orderId') {
    return P2POrderTimelineTabletPage(
      orderId: _requiredParam(state, 'orderId'),
    );
  }
  if (path == '/p2p/order/rate/:orderId') {
    return P2POrderRateTabletPage(orderId: _requiredParam(state, 'orderId'));
  }
  if (path == '/p2p/order/cancel/:orderId') {
    return P2POrderCancelTabletPage(orderId: _requiredParam(state, 'orderId'));
  }
  if (path == '/p2p/order/proof/:orderId') {
    return P2POrderProofTabletPage(orderId: _requiredParam(state, 'orderId'));
  }
  if (path == '/p2p/order/:orderId') {
    return P2POrderTabletPage(orderId: _requiredParam(state, 'orderId'));
  }
  if (path == AppRoutePaths.p2pMyOrders) {
    return const P2PMyOrdersTabletPage();
  }

  if (path == '/p2p/chat/:orderId') {
    return P2PChatTabletPage(orderId: _requiredParam(state, 'orderId'));
  }
  if (path == AppRoutePaths.p2pWallet) return const P2PWalletTabletPage();
  if (path == AppRoutePaths.p2pWalletTransfer) {
    return P2PWalletTransferTabletPage(
      asset: state.uri.queryParameters['asset'] ?? 'USDT',
      type: state.uri.queryParameters['type'] ?? 'internal',
    );
  }
  if (path == AppRoutePaths.p2pWalletFundLockHistory) {
    return const P2PFundLockHistoryTabletPage();
  }
  if (path == AppRoutePaths.p2pWalletHistory) {
    return const P2PFundLockHistoryTabletPage(walletHistoryAlias: true);
  }

  if (path == AppRoutePaths.p2pMerchantApply) {
    return const P2PMerchantApplyTabletPage();
  }
  if (path == '/p2p/merchant/:merchantId') {
    return P2PMerchantProfileTabletPage(
      merchantId: _requiredParam(state, 'merchantId'),
    );
  }
  if (path == '/p2p/report/:merchantId') {
    return P2PReportMerchantTabletPage(
      merchantId: _requiredParam(state, 'merchantId'),
    );
  }

  if (path == AppRoutePaths.p2pKycRequirements) {
    return const P2PKycRequirementsTabletPage();
  }
  if (path == AppRoutePaths.p2pKycStatus) {
    return const P2PKycStatusTabletPage();
  }
  if (path == AppRoutePaths.p2pKycIdentity ||
      path == AppRoutePaths.p2pKycVerify) {
    return const P2PIdentityVerificationTabletPage();
  }
  if (path == AppRoutePaths.p2pKycAddress) {
    return const P2PAddressProofTabletPage();
  }
  if (path == AppRoutePaths.p2pKycSelfie ||
      path == AppRoutePaths.p2pKycFaceMatch) {
    return const P2PSelfieVerificationTabletPage();
  }
  if (path == AppRoutePaths.p2pKycVideo) {
    return const P2PVideoVerificationTabletPage();
  }

  if (path == AppRoutePaths.p2pPaymentMethods) {
    return const P2PPaymentMethodsTabletPage();
  }
  if (path == AppRoutePaths.p2pPaymentMethodAdd) {
    return const P2PPaymentMethodAddTabletPage();
  }
  if (path == '/p2p/payment-method/verification/:methodId') {
    return P2PPaymentMethodVerificationTabletPage(
      methodId: _requiredParam(state, 'methodId'),
    );
  }
  if (path == '/p2p/payment-method/ownership/:methodId') {
    return P2PPaymentMethodOwnershipTabletPage(
      methodId: _requiredParam(state, 'methodId'),
    );
  }
  if (path == AppRoutePaths.p2pPaymentMethodCoolingPeriod) {
    return const P2PPaymentMethodCoolingPeriodTabletPage();
  }
  if (path == AppRoutePaths.p2pPaymentMethodHistory) {
    return const P2PPaymentMethodHistoryTabletPage();
  }

  if (path == AppRoutePaths.p2pDisputes) {
    return const P2PDisputesTabletPage();
  }
  if (path == '/p2p/dispute/detail/:disputeId') {
    return P2PDisputeDetailTabletPage(
      disputeId: _requiredParam(state, 'disputeId'),
    );
  }
  if (path == '/p2p/dispute/evidence/:disputeId') {
    return P2PDisputeEvidenceTabletPage(
      disputeId: _requiredParam(state, 'disputeId'),
    );
  }
  if (path == '/p2p/dispute/resolution/:disputeId') {
    return P2PDisputeResolutionTabletPage(
      disputeId: _requiredParam(state, 'disputeId'),
    );
  }
  if (path == '/p2p/dispute/:orderId') {
    return P2PDisputeOpenTabletPage(orderId: _requiredParam(state, 'orderId'));
  }

  if (path == AppRoutePaths.p2pInsurance) {
    return const P2PInsuranceFundTabletPage();
  }
  if (path == AppRoutePaths.p2pInsuranceCertificate) {
    return const P2PInsuranceCertificateTabletPage();
  }
  if (path == AppRoutePaths.p2pInsuranceScore) {
    return const P2PInsuranceScoreTabletPage();
  }
  if (path == AppRoutePaths.p2pInsurancePolicy) {
    return const P2PInsurancePolicyTabletPage();
  }
  if (path == '/p2p/insurance/claim/:claimId') {
    return P2PClaimDetailTabletPage(claimId: _requiredParam(state, 'claimId'));
  }

  if (path == AppRoutePaths.p2pSecurityCenter) {
    return const P2PSecurityCenterTabletPage();
  }
  if (path == AppRoutePaths.p2pSecurity2fa) {
    return const P2PTwoFactorSettingsTabletPage();
  }
  if (path == AppRoutePaths.p2pSecurityDevices) {
    return const P2PDeviceManagementTabletPage();
  }
  if (path == AppRoutePaths.p2pSecurityAntiPhishing) {
    return const P2PAntiPhishingCodeTabletPage();
  }
  if (path == AppRoutePaths.p2pSecurityLoginHistory) {
    return const P2PLoginHistoryTabletPage();
  }
  if (path == AppRoutePaths.p2pSecuritySuspiciousActivity) {
    return const P2PSuspiciousActivityTabletPage();
  }
  if (path == AppRoutePaths.p2pSecurityWhitelist) {
    return const P2PWhitelistModeTabletPage();
  }

  if (path == AppRoutePaths.p2pReviews) {
    return const P2PReviewsTabletPage();
  }
  if (path == AppRoutePaths.p2pContributionHistory) {
    return const P2PContributionHistoryTabletPage();
  }
  if (path == AppRoutePaths.p2pBlacklistAdd) {
    return const P2PBlacklistAddTabletPage();
  }
  if (path == AppRoutePaths.p2pBlacklist) {
    return const P2PBlacklistTabletPage();
  }
  if (path == AppRoutePaths.p2pE2EInfo) {
    return const P2PE2EInfoTabletPage();
  }
  if (path == AppRoutePaths.p2pFraudPrevention) {
    return const P2PFraudPreventionTabletPage();
  }
  if (path == AppRoutePaths.p2pAchievements) {
    return const P2PAchievementsTabletPage();
  }

  if (path == AppRoutePaths.p2pLimits) {
    return const P2PTransactionLimitsTabletPage();
  }
  if (path == AppRoutePaths.p2pLimitsTracker) {
    return const P2PLimitTrackerTabletPage();
  }
  if (path == AppRoutePaths.p2pComplianceOverview) {
    return const P2PComplianceOverviewTabletPage();
  }
  if (path == AppRoutePaths.p2pComplianceAmlScreening) {
    return const P2PAmlScreeningTabletPage();
  }
  if (path == AppRoutePaths.p2pComplianceSourceOfFunds) {
    return const P2PSourceOfFundsTabletPage();
  }
  if (path == AppRoutePaths.p2pComplianceLargeTransaction) {
    return P2PLargeTransactionJustificationTabletPage(
      amount:
          double.tryParse(state.uri.queryParameters['amount'] ?? '') ??
          200000000,
    );
  }
  if (path == AppRoutePaths.p2pComplianceRiskAssessment) {
    return const P2PRiskAssessmentTabletPage();
  }

  if (path == AppRoutePaths.p2pTradingLevel) {
    return const P2PTradingLevelTabletPage();
  }
  if (path == AppRoutePaths.p2pGuide) {
    return const P2PGuideTabletPage();
  }
  if (path == AppRoutePaths.p2pSettings) {
    return const P2PSettingsTabletPage();
  }
  if (path == AppRoutePaths.p2pSettingsNotifications) {
    return const P2PNotificationsSettingsTabletPage();
  }
  if (path == AppRoutePaths.p2pTaxReporting) {
    return const P2PTaxReportingTabletPage();
  }
  if (path == '/p2p/tax-report/detailed/:year') {
    return P2PTaxReportingTabletPage(
      initialYear: int.tryParse(_requiredParam(state, 'year')) ?? 2025,
    );
  }
  if (path == AppRoutePaths.markets) return const MarketsTabletPage();
  if (path == AppRoutePaths.marketsOverview) {
    return const MarketsOverviewPane();
  }
  if (path == '/pair/:pairId') {
    return MarketsPairDetailPane(pairId: _requiredParam(state, 'pairId'));
  }
  if (path == '/pair/:pairId/info') {
    return MarketsTokenInfoPane(pairId: _requiredParam(state, 'pairId'));
  }
  if (path == '/pair/:pairId/depth') {
    return MarketsPairDepthPane(pairId: _requiredParam(state, 'pairId'));
  }
  if (path == AppRoutePaths.marketsSectors) {
    return MarketsSectorsPane(
      selectedSectorId: state.uri.queryParameters['id'],
    );
  }
  if (path == AppRoutePaths.marketsHeatmap) {
    return const MarketsHeatmapPane();
  }
  if (path == AppRoutePaths.marketsMovers) {
    return const MarketsMoversPane();
  }
  if (path == AppRoutePaths.marketsWatchlist) {
    return const MarketsWatchlistPane();
  }
  if (path == AppRoutePaths.marketsAlerts) {
    return const MarketsAlertsPane();
  }
  if (path == AppRoutePaths.marketsScreener) {
    return const MarketsScreenerPane();
  }
  if (path == AppRoutePaths.marketsNews) {
    return const MarketsNewsPane();
  }
  if (path == AppRoutePaths.marketsPortfolioTracker) {
    return const MarketsPortfolioPane();
  }
  if (path == AppRoutePaths.marketsUnlocks) {
    return const MarketsUnlocksPane();
  }
  if (path == AppRoutePaths.marketsSignals) {
    return const MarketsSignalsPane();
  }
  if (path == AppRoutePaths.marketsCorrelations) {
    return const MarketsCorrelationsPane();
  }
  if (path == AppRoutePaths.marketsAdvancedCharts) {
    return const MarketsAdvancedChartsPane();
  }
  if (path == AppRoutePaths.marketsSocialSentiment) {
    return const MarketsSentimentPane();
  }
  if (path == AppRoutePaths.marketsDepth) {
    return const MarketsDepthPane();
  }
  if (path == AppRoutePaths.marketsCompare) {
    return const MarketsComparePane();
  }
  if (path == AppRoutePaths.marketsCalendar) {
    return const MarketsCalendarPane();
  }
  if (path == AppRoutePaths.marketsDerivatives) {
    return const MarketsDerivativesPane();
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
  if (path == '/trade/advanced-chart/:pairId') {
    return AdvancedChartTabletPage(pairId: _requiredParam(state, 'pairId'));
  }
  if (path == AppRoutePaths.tradeRiskManagement) {
    return const RiskManagementTabletPage();
  }
  if (path == AppRoutePaths.tradeBots) {
    return const TradingBotsTabletPage();
  }
  if (path == AppRoutePaths.tradeBotTermsOfService) {
    return const BotTermsOfServiceTabletPage();
  }
  if (path == AppRoutePaths.tradeBotRiskDisclosure) {
    return const BotRiskDisclosureTabletPage();
  }
  if (path == AppRoutePaths.tradeBotSuitabilityAssessment) {
    return const BotSuitabilityAssessmentTabletPage();
  }
  if (path == AppRoutePaths.tradeBotRiskDashboard) {
    return const BotRiskDashboardTabletPage();
  }
  if (path == AppRoutePaths.tradeBotEmergencyStop) {
    return const BotEmergencyStopTabletPage();
  }
  if (path == AppRoutePaths.tradeBotSecuritySettings) {
    return const BotSecuritySettingsTabletPage();
  }
  if (path == AppRoutePaths.tradeBotHistory) {
    return const BotHistoryTabletPage();
  }
  if (path == AppRoutePaths.tradeBotPerformanceAnalytics) {
    return const BotPerformanceAnalyticsTabletPage();
  }
  if (path == AppRoutePaths.tradeBotBacktesting) {
    return const BotBacktestingTabletPage();
  }
  if (path == AppRoutePaths.tradeBotStrategyCompare) {
    return const BotStrategyCompareTabletPage();
  }
  if (path == AppRoutePaths.tradeBotOptimization) {
    return const BotOptimizationTabletPage();
  }
  if (path == AppRoutePaths.tradeBotPortfolioDashboard) {
    return const BotPortfolioDashboardTabletPage();
  }
  if (path == AppRoutePaths.tradeBotDrawdownAnalyzer) {
    return const BotDrawdownAnalyzerTabletPage();
  }
  if (path == AppRoutePaths.tradeBotEquityCurve) {
    return const BotEquityCurveTabletPage();
  }
  if (path == AppRoutePaths.tradeBotGuide) {
    return const BotGuideTabletPage();
  }
  if (path == AppRoutePaths.tradeBotFaq) {
    return const BotFaqTabletPage();
  }
  if (path == AppRoutePaths.tradeBotTaxReporting) {
    return const BotTaxReportingTabletPage();
  }
  if (path == AppRoutePaths.tradeBotApiDocumentation) {
    return const BotApiDocumentationTabletPage();
  }
  if (path == AppRoutePaths.earnSavings) {
    return const SavingsHubTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsPortfolio) {
    return const SavingsPortfolioTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsHistory) {
    return const SavingsHistoryTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsGuide) {
    return const SavingsGuideTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsFAQ) {
    return const SavingsFaqTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsNotifications) {
    return const SavingsNotificationsTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsRecommendations) {
    return const SavingsRecommendationsTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsRiskAssessment) {
    return const SavingsRiskAssessmentTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsComparison) {
    return const SavingsComparisonTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsAutoCompound) {
    return const AutoCompoundSettingsTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsGoals) {
    return const SavingsGoalsTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsAnalytics) {
    return const SavingsAnalyticsTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsRebalance) {
    return const SavingsRebalanceTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsNotificationPreferences) {
    return const SavingsNotificationPreferencesTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsDca) {
    return const SavingsDcaTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsSmartSuggestions) {
    return const SavingsSmartSuggestionsTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsExport) {
    return const SavingsExportTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsBacktest) {
    return const SavingsBacktestTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsAutoPilot) {
    return const SavingsAutoPilotTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsLadder) {
    return const SavingsLadderTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsWhatIf) {
    return const SavingsWhatIfTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsProductSample) {
    return const SavingsProductSampleTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsRedeemPos001) {
    return const SavingsRedeemTabletPage();
  }
  if (path == AppRoutePaths.earnSavingsReceipt) {
    return const SavingsReceiptTabletPage();
  }
  if (path == AppRoutePaths.earnVotingProposalRoute) {
    return StakingVotingTabletPage(
      proposalId: _requiredParam(state, 'proposalId'),
    );
  }
  if (path == AppRoutePaths.earnStaking) {
    return const StakingEarnTabletPage();
  }
  if (path == AppRoutePaths.earnDashboard) {
    return const StakingDashboardTabletPage();
  }
  if (path == AppRoutePaths.earnAnalytics) {
    return const StakingAnalyticsTabletPage();
  }
  if (path == AppRoutePaths.earnHistory) {
    return const StakingHistoryTabletPage();
  }
  if (path == AppRoutePaths.earnCalendar) {
    return const StakingEarningsCalendarTabletPage();
  }
  if (path == AppRoutePaths.earnStakingTerms) {
    return const StakingTermsTabletPage();
  }
  if (path == AppRoutePaths.earnStakingRiskDisclosure) {
    return const StakingRiskDisclosureTabletPage();
  }
  if (path == AppRoutePaths.earnStakingTaxGuide) {
    return const StakingTaxGuideTabletPage();
  }
  if (path == AppRoutePaths.earnStakingRiskAssessment) {
    return const StakingRiskAssessmentTabletPage();
  }
  if (path == AppRoutePaths.earnSuitabilityAssessment) {
    return const StakingSuitabilityAssessmentTabletPage();
  }
  if (path == AppRoutePaths.earnEmergencyActions) {
    return const StakingEmergencyActionsTabletPage();
  }
  if (path == AppRoutePaths.earnContingencyPlan) {
    return const StakingContingencyPlanTabletPage();
  }
  if (path == AppRoutePaths.earnStakingWithdrawalPolicy) {
    return const StakingWithdrawalPolicyTabletPage();
  }
  if (path == AppRoutePaths.earnValidatorSelection) {
    return const StakingValidatorSelectionTabletPage();
  }
  if (path == AppRoutePaths.earnValidatorHealthMonitor) {
    return const StakingValidatorHealthMonitorTabletPage();
  }
  if (path == AppRoutePaths.earnAutoCompound) {
    return const StakingAutoCompoundTabletPage();
  }
  if (path == AppRoutePaths.earnLiquidStaking) {
    return const StakingLiquidStakingTabletPage();
  }
  if (path == AppRoutePaths.earnAdvancedOrders) {
    return const StakingAdvancedOrdersTabletPage();
  }
  if (path == AppRoutePaths.earnMultiChain) {
    return const StakingMultiChainTabletPage();
  }
  if (path == AppRoutePaths.earnInstitutional) {
    return const StakingInstitutionalTabletPage();
  }
  if (path == AppRoutePaths.earnInsurance) {
    return const StakingInsuranceTabletPage();
  }
  if (path == AppRoutePaths.earnInsuranceFundTransparency) {
    return const StakingInsuranceFundTransparencyTabletPage();
  }
  if (path == AppRoutePaths.earnRiskDashboard) {
    return const StakingRiskDashboardTabletPage();
  }
  if (path == AppRoutePaths.earnRiskScoreCalculator) {
    return const StakingRiskScoreCalculatorTabletPage();
  }
  if (path == AppRoutePaths.earnSlashingHistory) {
    return const StakingSlashingHistoryTabletPage();
  }
  if (path == AppRoutePaths.earnGuide) {
    return const StakingGuideTabletPage();
  }
  if (path == AppRoutePaths.earnFAQ) {
    return const StakingFaqTabletPage();
  }
  if (path == AppRoutePaths.earnNotifications) {
    return const StakingNotificationsTabletPage();
  }
  if (path == AppRoutePaths.earnRecommendations) {
    return const StakingRecommendationsTabletPage();
  }
  if (path == AppRoutePaths.earnRegulatoryFramework) {
    return const StakingRegulatoryFrameworkTabletPage();
  }
  if (path == AppRoutePaths.earnAuditReports) {
    return const StakingAuditReportsTabletPage();
  }
  if (path == AppRoutePaths.earnCustody) {
    return const StakingCustodyTabletPage();
  }
  if (path == AppRoutePaths.earnProofOfReserves) {
    return const StakingProofOfReservesTabletPage();
  }
  if (path == AppRoutePaths.earnTransactionReporting) {
    return const StakingTransactionReportingTabletPage();
  }
  if (path == AppRoutePaths.earnWebhooks) {
    return const StakingWebhooksTabletPage();
  }
  if (path == AppRoutePaths.earnDataExport) {
    return const StakingDataExportTabletPage();
  }
  if (path == AppRoutePaths.earnThirdPartyIntegrations) {
    return const StakingThirdPartyIntegrationsTabletPage();
  }
  if (path == AppRoutePaths.earnDeveloperConsole) {
    return const StakingDeveloperConsoleTabletPage();
  }
  if (path == AppRoutePaths.earnApiDocumentation) {
    return const StakingApiDocumentationTabletPage();
  }
  if (path == AppRoutePaths.earnSocialFeed) {
    return const StakingSocialFeedTabletPage();
  }
  if (path == AppRoutePaths.earnCommunityGovernance) {
    return const StakingCommunityGovernanceTabletPage();
  }
  if (path == AppRoutePaths.earnProposals) {
    return const StakingProposalsTabletPage();
  }
  if (path == AppRoutePaths.earnVoting) {
    return const StakingVotingTabletPage();
  }
  if (path == AppRoutePaths.earnForum) {
    return const StakingForumTabletPage();
  }
  if (path == AppRoutePaths.marketsPredictions) {
    return const PredictionsHomeTabletPage();
  }
  if (path == AppRoutePaths.marketsPredictionsSearch) {
    return const PredictionsSearchTabletPage();
  }
  if (path == AppRoutePaths.marketsPredictionsBreaking) {
    return const PredictionsBreakingTabletPage();
  }
  if (path == '/markets/predictions/event/:eventId') {
    return PredictionEventDetailTabletPage(
      eventId: _requiredParam(state, 'eventId'),
    );
  }
  if (path == AppRoutePaths.marketsPredictionsPortfolio) {
    return const PredictionsPortfolioTabletPage();
  }
  if (path == AppRoutePaths.marketsPredictionsRewards) {
    return const PredictionsRewardsTabletPage();
  }
  if (path == AppRoutePaths.marketsPredictionsLeaderboard) {
    return const PredictionsLeaderboardTabletPage();
  }
  if (path == AppRoutePaths.marketsPredictionsActivity) {
    return const PredictionsGlobalActivityTabletPage();
  }
  if (path == AppRoutePaths.marketsPredictionsRiskCalculator) {
    return const PredictionRiskCalculatorTabletPage();
  }
  if (path == AppRoutePaths.marketsPredictionsMarketMaker) {
    return const PredictionMarketMakerTabletPage();
  }
  if (path == AppRoutePaths.marketsPredictionsPortfolioAnalyzer) {
    return const PredictionPortfolioAnalyzerTabletPage();
  }
  if (path == AppRoutePaths.marketsPredictionsEventCalendar) {
    return const PredictionEventCalendarTabletPage();
  }
  if (path == AppRoutePaths.marketsPredictionsSocial) {
    return const PredictionSocialTabletPage();
  }
  if (path == '/markets/predictions/advanced-chart/:eventId') {
    return PredictionAdvancedChartTabletPage(
      eventId: _requiredParam(state, 'eventId'),
    );
  }
  if (path == AppRoutePaths.marketsPredictionsTournaments) {
    return const PredictionTournamentsTabletPage();
  }
  if (path == '/markets/predictions/tournament/:tournamentId') {
    return PredictionTournamentDetailTabletPage(
      tournamentId: _requiredParam(state, 'tournamentId'),
    );
  }
  if (path == AppRoutePaths.marketsPredictionsDataIntegration) {
    return const PredictionDataIntegrationTabletPage();
  }
  if (path == '/markets/predictions/receipt/:receiptId') {
    return PredictionOrderReceiptTabletPage(
      receiptId: _requiredParam(state, 'receiptId'),
    );
  }
  if (path == AppRoutePaths.launchpad) {
    return const LaunchpadHomeTabletPage();
  }
  if (path == AppRoutePaths.launchpadPortfolio) {
    return const LaunchpadPortfolioTabletPage();
  }
  if (path == AppRoutePaths.launchpadPerformance) {
    return const LaunchpadPerformanceTabletPage();
  }
  if (path == AppRoutePaths.launchpadStaking) {
    return const LaunchpadStakingTabletPage();
  }
  if (path == AppRoutePaths.launchpadIdoBridgeSample) {
    return const LaunchpadIdoBridgeTabletPage();
  }
  if (path == AppRoutePaths.launchpadContractSample) {
    return const LaunchpadContractTabletPage();
  }
  if (path == AppRoutePaths.launchpadReceiptSub001) {
    return const LaunchpadReceiptTabletPage();
  }
  if (path == AppRoutePaths.launchpadClaimReceiptPos001) {
    return const LaunchpadClaimReceiptTabletPage();
  }
  if (path == AppRoutePaths.launchpadBatchClaim) {
    return const LaunchpadBatchClaimTabletPage();
  }
  if (path == AppRoutePaths.launchpadBridgeCompare) {
    return const LaunchpadBridgeCompareTabletPage();
  }
  if (path == AppRoutePaths.launchpadBridgeOrderTx001) {
    return const LaunchpadBridgeOrderTabletPage();
  }
  if (path == AppRoutePaths.launchpadNotifSound) {
    return const LaunchpadNotifSoundTabletPage();
  }
  if (path == AppRoutePaths.launchpadEventLog) {
    return const LaunchpadEventLogTabletPage();
  }
  if (path == AppRoutePaths.launchpadAbiDiff) {
    return const LaunchpadAbiDiffTabletPage();
  }
  if (path == AppRoutePaths.launchpadAddressBook) {
    return const LaunchpadAddressBookTabletPage();
  }
  if (path == AppRoutePaths.launchpadWebhooks) {
    return const LaunchpadWebhooksTabletPage();
  }
  if (path == AppRoutePaths.launchpadGasTracker) {
    return const LaunchpadGasTrackerTabletPage();
  }
  if (path == AppRoutePaths.launchpadRebalance) {
    return const LaunchpadRebalanceTabletPage();
  }
  if (path == AppRoutePaths.launchpadMultisig) {
    return const LaunchpadMultisigTabletPage();
  }
  if (path == AppRoutePaths.launchpadSwapAggregator) {
    return const LaunchpadSwapAggregatorTabletPage();
  }
  if (path == AppRoutePaths.launchpadLimitOrders) {
    return const LaunchpadLimitOrdersTabletPage();
  }
  if (path == AppRoutePaths.launchpadDcaBuilder) {
    return const LaunchpadDcaBuilderTabletPage();
  }
  if (path == AppRoutePaths.launchpadRiskAnalytics) {
    return const LaunchpadRiskAnalyticsTabletPage();
  }
  if (path == AppRoutePaths.arena) {
    return const ArenaHomeTabletPage();
  }
  if (path == AppRoutePaths.arenaGuide) {
    return const ArenaGuideTabletPage();
  }
  if (path == AppRoutePaths.arenaStudio) {
    return const ArenaStudioTabletPage();
  }
  if (path == AppRoutePaths.arenaStudioSmartRules) {
    return const ArenaSmartRulesTabletPage();
  }
  if (path == AppRoutePaths.arenaStudioPresets) {
    return const ArenaPresetLibraryTabletPage();
  }
  if (path == AppRoutePaths.arenaStudioGovernance) {
    return const ArenaGovernanceGateTabletPage();
  }
  if (path == '/arena/mode/:modeId') {
    return ArenaModeDetailTabletPage(modeId: _requiredParam(state, 'modeId'));
  }
  if (path == '/arena/challenge/:challengeId') {
    return ArenaChallengeDetailTabletPage(
      challengeId: _requiredParam(state, 'challengeId'),
    );
  }
  if (path == '/arena/join/:challengeId') {
    return ArenaJoinTabletPage(
      challengeId: _requiredParam(state, 'challengeId'),
    );
  }
  if (path == AppRoutePaths.arenaResolution) {
    return const ArenaResolutionCenterTabletPage();
  }
  if (path == '/arena/creator/:creatorId') {
    return ArenaCreatorTabletPage(
      creatorId: _requiredParam(state, 'creatorId'),
    );
  }
  if (path == AppRoutePaths.arenaLeaderboard) {
    return const ArenaLeaderboardTabletPage();
  }
  if (path == AppRoutePaths.arenaVerified) {
    return const VerifiedChallengesTabletPage();
  }
  if (path == AppRoutePaths.arenaPoints) {
    return const ArenaPointsTabletPage();
  }
  if (path == AppRoutePaths.arenaFlowMap) {
    return const ArenaFlowMapTabletPage();
  }
  if (path == AppRoutePaths.arenaSafety) {
    return const ArenaSafetyCenterTabletPage();
  }
  if (path == AppRoutePaths.arenaBlocked) {
    return const ArenaBlockedUsersTabletPage();
  }
  if (path == AppRoutePaths.arenaMyReports) {
    return const MyArenaReportsTabletPage();
  }
  if (path == AppRoutePaths.arenaMy) {
    return const MyArenaTabletPage();
  }
  if (path == AppRoutePaths.arenaProduction) {
    return const ArenaProductionReadyTabletPage();
  }
  if (path == AppRoutePaths.arenaBridge) {
    return const ArenaPredictionBridgeTabletPage();
  }
  if (path == AppRoutePaths.arenaEcosystem) {
    return const ArenaEcosystemTabletPage();
  }
  if (path == '/arena/trust/:userId') {
    return ArenaTrustBreakdownTabletPage(
      userId: _requiredParam(state, 'userId'),
    );
  }
  if (path == '/arena/ledger/entry/:entryId') {
    return ArenaPointsEntryDetailTabletPage(
      entryId: _requiredParam(state, 'entryId'),
    );
  }
  if (path == AppRoutePaths.arenaLedger) {
    return const ArenaPointsLedgerTabletPage();
  }
  if (path == '/arena/report/:caseId') {
    return ArenaReportCaseTabletPage(caseId: _requiredParam(state, 'caseId'));
  }
  if (path == AppRoutePaths.support) {
    return const SupportHubTabletPage();
  }
  if (path == AppRoutePaths.supportHelp) {
    return const SupportHelpTabletPage();
  }
  if (path == AppRoutePaths.supportAnnouncements) {
    return const SupportAnnouncementsTabletPage();
  }
  if (path == AppRoutePaths.admin) {
    return const AdminHomeTabletPage();
  }
  if (path == AppRoutePaths.adminAnalytics) {
    return const AdminAnalyticsTabletPage();
  }
  if (path == AppRoutePaths.adminAbtests) {
    return const AdminAbtestsTabletPage();
  }
  if (path == AppRoutePaths.adminFunnels) {
    return const AdminFunnelsTabletPage();
  }
  if (path == AppRoutePaths.adminSettings) {
    return const AdminSettingsTabletPage();
  }
  if (path == AppRoutePaths.enterpriseStates) {
    return const EnterpriseStatesTabletPage();
  }
  if (path == AppRoutePaths.unifiedPortfolio) {
    return const UnifiedPortfolioTabletPage();
  }
  if (path == AppRoutePaths.crossModuleAnalytics) {
    return const CrossModuleAnalyticsTabletPage();
  }
  if (path == AppRoutePaths.smartAlerts) {
    return const SmartAlertCenterTabletPage();
  }
  if (path == AppRoutePaths.taxReports) {
    return const TaxReportCenterTabletPage();
  }
  if (path == AppRoutePaths.notifications) {
    return const NotificationsHubTabletPage();
  }
  if (path == AppRoutePaths.search) {
    return const UnifiedSearchTabletPage();
  }
  if (path == AppRoutePaths.topics) {
    return const TopicHubTabletPage();
  }
  if (path == AppRoutePaths.topicCrypto) {
    return const TopicCryptoTabletPage();
  }
  if (path == AppRoutePaths.referral) {
    return const ReferralHomeTabletPage();
  }
  if (path == AppRoutePaths.referralHistory) {
    return const ReferralHistoryTabletPage();
  }
  if (path == AppRoutePaths.referralRewards) {
    return const ReferralRewardsTabletPage();
  }
  if (path == AppRoutePaths.referralRules) {
    return const ReferralRulesTabletPage();
  }
  if (path == AppRoutePaths.routeChecker) {
    return const RouteCheckerTabletPage();
  }
  if (path == AppRoutePaths.performanceMonitor) {
    return const PerformanceMonitorTabletPage();
  }
  if (path == AppRoutePaths.devShowcase) {
    return const MissingScreensShowcaseTabletPage();
  }
  if (path == AppRoutePaths.devDesignSystem) {
    return const DesignSystemTabletPage();
  }
  if (path == AppRoutePaths.devDcaOverview) {
    return const DevDcaOverviewTabletPage();
  }
  if (path == AppRoutePaths.onboarding) {
    return const OnboardingTabletPage();
  }
  if (path == AppRoutePaths.earn) {
    return const StakingEarnTabletPage();
  }
  if (path == AppRoutePaths.launchpadSample) {
    return const LaunchpadDetailTabletPage(projectId: 'sample');
  }
  if (path == '/p2p/escrow/balance') {
    return const P2PEscrowTabletPage(orderId: 'balance');
  }
  if (path == '/p2p/escrow/:orderId') {
    return P2PEscrowTabletPage(orderId: _requiredParam(state, 'orderId'));
  }
  if (path == '/referral/friend/:friendId') {
    return const ReferralFriendDetailTabletPage();
  }
  if (path == AppRoutePaths.tradeExecutionQuality) {
    return const ExecutionQualityTabletPage();
  }
  if (path == AppRoutePaths.tradeAdvancedTools) {
    return const AdvancedToolsTabletPage();
  }
  if (path == AppRoutePaths.tradeMarginAdvancedDemo) {
    return const AdvancedTradingDemoTabletPage();
  }
  if (path == AppRoutePaths.tradeMarginAdvancedAnalytics) {
    return const AdvancedAnalyticsTabletPage();
  }
  if (path == AppRoutePaths.tradeMarginMarketDataAnalytics) {
    return const MarketDataAnalyticsTabletPage();
  }
  if (path == AppRoutePaths.tradeMarginLiveMarketDataAnalytics) {
    return const LiveMarketDataAnalyticsTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyClientMoneyProtection) {
    return const ClientMoneyProtectionTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyCassReconciliation) {
    return const CassReconciliationTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyInvestorCompensation) {
    return const InvestorCompensationTabletPage();
  }
  if (path == AppRoutePaths.tradeCopySlippageMonitoring) {
    return const SlippageMonitoringTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyComplaintsHandling) {
    return const ComplaintsHandlingTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyComplaintSubmission) {
    return const ComplaintSubmissionTabletPage();
  }

  if (path == AppRoutePaths.tradeCopyComplaintTrackingBase) {
    return const ComplaintTrackingTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyRegulatoryReportsDashboard) {
    return const RegulatoryReportsDashboardTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyArmIntegrationStatus) {
    return const ArmIntegrationStatusTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyRegulatoryInspectionReady) {
    return const RegulatoryInspectionReadyTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyOmbudsmanReferral) {
    return const OmbudsmanReferralTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyClientCategorization) {
    return const ClientCategorizationTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyProductGovernance) {
    return const ProductGovernanceTabletPage();
  }

  if (path == AppRoutePaths.tradeCopyExAnteCosts) {
    return const ExAnteCostsTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyRiyCalculator) {
    return const RiyCalculatorTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyExPostCostsReport) {
    return const ExPostCostsReportTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyKidGenerator) {
    return const KidGeneratorTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyPerformanceScenarios) {
    return const PerformanceScenariosTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyRiskIndicatorExplainer) {
    return const RiskIndicatorExplainerTabletPage();
  }

  if (path == AppRoutePaths.dca) return const DcaOverviewTabletPage();
  if (path == AppRoutePaths.dcaPortfolioOptimizer) {
    return const DcaPortfolioOptimizerTabletPage();
  }
  if (path == AppRoutePaths.dcaDynamicAmount) {
    return const DcaDynamicAmountTabletPage();
  }
  if (path == AppRoutePaths.dcaBacktester) {
    return const DcaBacktesterTabletPage();
  }
  if (path == AppRoutePaths.dcaMultiAsset) {
    return const DcaMultiAssetTabletPage();
  }
  if (path == AppRoutePaths.dcaPerformanceCompare) {
    return const DcaPerformanceCompareTabletPage();
  }
  if (path == AppRoutePaths.dcaSmartRules) {
    return const DcaSmartRulesTabletPage();
  }
  if (path == AppRoutePaths.dcaRebalanceConfig) {
    return const DcaRebalanceConfigTabletPage();
  }
  if (path == AppRoutePaths.dcaRebalanceDashboard) {
    return const DcaRebalanceDashboardTabletPage();
  }
  if (path == AppRoutePaths.dcaScheduleConfig) {
    return const DcaScheduleConfigTabletPage();
  }
  if (path == AppRoutePaths.dcaScheduleAnalytics) {
    return const DcaScheduleAnalyticsTabletPage();
  }
  if (path == '/dca/rebalance/:configId/edit') {
    return DcaRebalanceEditTabletPage(
      configId: _requiredParam(state, 'configId'),
    );
  }
  if (path == '/dca/rebalance/:configId/history') {
    return DcaRebalanceHistoryTabletPage(
      configId: _requiredParam(state, 'configId'),
    );
  }
  if (path == AppRoutePaths.tradeCopyRegulatoryDisclosures) {
    return const RegulatoryDisclosuresTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyTransactionReporting) {
    return const TransactionReportingTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyBestExecutionReports) {
    return const BestExecutionReportsTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyExecutionVenueAnalysis) {
    return const ExecutionVenueAnalysisTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyTargetMarketDefinition) {
    return const TargetMarketDefinitionTabletPage();
  }
  if (path == '/trade/copy-trading/target-market-definition/:productId') {
    return TargetMarketDefinitionTabletPage(
      productId: _requiredParam(state, 'productId'),
    );
  }
  if (path == AppRoutePaths.tradeCopyAuditTrail) {
    return const AuditTrailTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyClientOptUpRequest) {
    return const ClientOptUpRequestTabletPage();
  }
  if (path == '/trade/copy-trading/complaint-tracking/:complaintId') {
    return ComplaintTrackingTabletPage(
      complaintId: _requiredParam(state, 'complaintId'),
    );
  }
  if (path == AppRoutePaths.tradeCopyTrading) {
    return const CopyTradingTabletPage();
  }

  if (path == AppRoutePaths.tradeCopyActive) {
    return const ActiveCopiesTabletPage();
  }
  if (path == AppRoutePaths.tradeCopySettings) {
    return const CopySettingsTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyNotifications) {
    return const CopyNotificationsTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyLeaderboard) {
    return const ProviderLeaderboardTabletPage();
  }
  if (path == '/trade/copy-provider/:providerId') {
    return CopyProviderDetailTabletPage(
      providerId: _requiredParam(state, 'providerId'),
    );
  }
  if (path == '/trade/copy-provider/:providerId/assessment') {
    return PreCopyAssessmentTabletPage(
      providerId: _requiredParam(state, 'providerId'),
    );
  }
  if (path == '/trade/copy-provider/:providerId/configuration') {
    return CopyConfigurationTabletPage(
      providerId: _requiredParam(state, 'providerId'),
    );
  }
  if (path == '/trade/copy-provider/:providerId/confirmation') {
    return CopyConfirmationTabletPage(
      providerId: _requiredParam(state, 'providerId'),
    );
  }
  if (path == '/trade/copy-performance/:copyId') {
    return CopyPerformanceTabletPage(copyId: _requiredParam(state, 'copyId'));
  }
  if (path == '/trade/copy-performance/:copyId/attribution') {
    return PerformanceAttributionTabletPage(
      copyId: _requiredParam(state, 'copyId'),
    );
  }
  if (path == AppRoutePaths.tradeCopySafety) {
    return const SafetyEducationTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyEducation) {
    return const CopyEducationTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyProviderApply) {
    return const ProviderApplyTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyComparison) {
    return const ProviderComparisonTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyRiskAnalysis) {
    return const PortfolioRiskAnalysisTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyProviderGovernance) {
    return const ProviderGovernanceTabletPage();
  }
  if (path == AppRoutePaths.tradeCopyDisputeResolution) {
    return const CopyDisputeResolutionTabletPage();
  }
  if (path == '/trade/copy-audit-log/:copyId') {
    return CopyAuditLogTabletPage(copyId: _requiredParam(state, 'copyId'));
  }
  if (path == '/trade/trader/:traderId') {
    return CopyProviderDetailTabletPage(
      providerId: _requiredParam(state, 'traderId'),
    );
  }
  if (path == AppRoutePaths.tradeCopySafetyCenter) {
    return const CopySafetyCenterTabletPage();
  }
  if (path == AppRoutePaths.demoCopyCard) {
    return const CopyTradingCardDemoTabletPage();
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

Widget? _profileUtilityForRoute(String path) {
  // SC-405/SC-406: phone builds SecurityPage cho cả hai route (cùng nội dung
  // /profile/security) — tablet mirror đúng hành vi đó bằng ProfileSecurityPane
  // thay vì placeholder (xem profile_routes.dart arm tương ứng).
  if (path == AppRoutePaths.settingsSecurityBiometric ||
      path == AppRoutePaths.settingsSecurityChangePassword) {
    return const ProfileSecurityPane();
  }
  return null;
}

P2PTabletUtilityPage? _p2pUtilityForRoute(String path) {
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
