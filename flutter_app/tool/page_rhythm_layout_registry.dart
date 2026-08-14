import 'dart:io';

/// Maps page widgets to shared layout shells that own [VitPageContent].

/// Shell widget class → lib-relative VPC owner file.
const shellWidgetToVpcPath = <String, String>{
  'WalletTabletDetailSurface':
      'features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart',
  'ProfileTabletUtilitySurface':
      'features/profile/presentation/tablet/widgets/profile_tablet_utility_surface.dart',
  'P2PTabletUtilitySurface':
      'features/p2p_core/presentation/tablet/widgets/p2p_tablet_utility_surface.dart',
  'VitWalletDetailScaffold':
      'features/wallet/presentation/widgets/hub/vit_wallet_detail_scaffold.dart',
  'VitP2PFlowScaffold':
      'features/p2p_core/presentation/widgets/vit_p2p_flow_scaffold.dart',
  'VitTradeHubScaffold':
      'features/trade_core/presentation/widgets/trade_module_layout.dart',
  'VitTradeSimpleShell':
      'features/trade_core/presentation/widgets/trade_module_layout.dart',
  'VitTradeWorkspaceScaffold':
      'features/trade_core/presentation/widgets/trade_module_layout.dart',
  'VitTradeDetailScaffold':
      'features/trade_core/presentation/widgets/trade_module_layout.dart',
  'CrossModuleTabbedPageShell':
      'features/cross_module/presentation/widgets/cross_module_tabbed_shell.dart',
};

/// Rhythm tier owned by each shell when a layout file declares multiple tiers.
const shellWidgetRhythmTier = <String, String>{
  'WalletTabletDetailSurface': 'form',
  'ProfileTabletUtilitySurface': 'form',
  'P2PTabletUtilitySurface': 'form',
  'VitTradeWorkspaceScaffold': 'compact',
  'VitTradeHubScaffold': 'compact',
  'VitTradeDetailScaffold': 'standard',
  'VitTradeSimpleShell': 'standard',
  'VitWalletDetailScaffold': 'form',
  'VitP2PFlowScaffold': 'standard',
  'CrossModuleTabbedPageShell': 'compact',
};

String? shellWidgetUsedInSource(String? source) {
  if (source == null) return null;
  for (final shell in shellWidgetToVpcPath.keys) {
    if (source.contains('$shell(')) return shell;
  }
  return null;
}

String? shellRhythmTierForSource(String? source) {
  final shell = shellWidgetUsedInSource(source);
  if (shell == null) return null;
  return shellWidgetRhythmTier[shell];
}

/// Page base names whose chart/terminal VPC lives in a linked part file.
const chartPartPageBases = <String>{
  'futures_page',
  'market_depth_page',
  'trade_terminal_page',
  'cross_module_chart_page',
};

const gateShellWidgets = {'InternalSurfaceGate'};

/// Route truth-table widget → page file to actually inspect for VPC
/// compliance — either because the widget isn't under `presentation/pages/`,
/// or (like `HomeResponsiveEntry`/`WalletResponsiveEntry`) the widget is a
/// tablet-adaptive dispatcher whose own file has no VitPageContent of its
/// own (see `Tablet-Adaptive-Standard.md` R1). Each dispatcher picks between
/// its phone page and tablet page by width; both independently pass their
/// own file-level page_rhythm_audit, and the phone page is the pre-existing
/// canonical reference, so it stays the rollup target here.
const widgetClassPageOverrides = <String, String>{
  'HomeResponsiveEntry':
      'features/home/presentation/phone/pages/home_page.dart',
  'WalletResponsiveEntry':
      'features/wallet/presentation/phone/pages/wallet_page.dart',
  'MarketsResponsiveEntry':
      'features/markets/presentation/phone/pages/market_list_page.dart',
  'TradeResponsiveEntry':
      'features/trade/presentation/phone/pages/trade_page.dart',
  'OrderReceiptPage':
      'features/trade/presentation/phone/pages/order_receipt_page.dart',
  'ProfileResponsiveEntry':
      'features/profile/presentation/phone/pages/profile_page.dart',
  'ClientOptUpRequestPage':
      'features/trade_compliance/presentation/pages/governance/client_categorization_opt_up_page.dart',
  'PredictionTournamentDetailPage':
      'features/predictions/presentation/pages/prediction_tournaments_page.dart',
  'P2PWhitelistModePage':
      'features/p2p_security/presentation/pages/security/p2p_security_center_page.dart',
  'PredictionAdvancedChartPage':
      'features/predictions/presentation/pages/prediction_advanced_chart_page.dart',
};

/// Surface-aware route builders are recorded as `switch` in the route truth
/// table. Keep the rollup pointed at the active Tablet composition where it
/// exists; routes without a Tablet page use their canonical Phone page.
const routeNameToPageOverrides = <String, String>{
  'AppRouteNames.sc007Home':
      'features/home/presentation/phone/pages/home_page.dart',
  'AppRouteNames.sc008MarketList':
      'features/markets/presentation/phone/pages/market_list_page.dart',
  'AppRouteNames.sc049TradePair':
      'features/trade/presentation/tablet/pages/trade_tablet_page.dart',
  'AppRouteNames.sc050OrdersHistory':
      'features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart',
  'AppRouteNames.sc052TradeSettings':
      'features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart',
  'AppRouteNames.sc053PositionDashboard':
      'features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart',
  'AppRouteNames.sc054TradeHistoryExport':
      'features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart',
  'AppRouteNames.sc056Convert':
      'features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart',
  'AppRouteNames.sc057Futures':
      'features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart',
  'AppRouteNames.sc058Leverage':
      'features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart',
  'AppRouteNames.sc085MarginTrading':
      'features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart',
  'AppRouteNames.sc086MarginTradingPair':
      'features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart',
  'AppRouteNames.sc090MarginTradingHub':
      'features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart',
  'AppRouteNames.sc135Wallet':
      'features/wallet/presentation/tablet/pages/wallet_tablet_page.dart',
  'AppRouteNames.sc136TxHistory':
      'features/wallet/presentation/tablet/pages/transaction_history_tablet_page.dart',
  'AppRouteNames.sc137Deposit':
      'features/wallet/presentation/tablet/pages/deposit_tablet_page.dart',
  'AppRouteNames.sc139Withdraw':
      'features/wallet/presentation/tablet/pages/withdraw_tablet_page.dart',
  'AppRouteNames.sc142PortfolioAnalytics':
      'features/wallet/presentation/tablet/pages/portfolio_analytics_tablet_page.dart',
  'AppRouteNames.sc143AddressAdd':
      'features/wallet/presentation/tablet/pages/address_add_tablet_page.dart',
  'AppRouteNames.sc144AddressBook':
      'features/wallet/presentation/tablet/pages/address_book_tablet_page.dart',
  'AppRouteNames.sc145BuyCrypto':
      'features/wallet/presentation/tablet/pages/buy_crypto_tablet_page.dart',
  'AppRouteNames.sc146Transfer':
      'features/wallet/presentation/tablet/pages/transfer_tablet_page.dart',
  'AppRouteNames.sc148MultiManager':
      'features/wallet/presentation/tablet/pages/wallet_multi_manager_tablet_page.dart',
  'AppRouteNames.sc149GasOptimizer':
      'features/wallet/presentation/tablet/pages/wallet_gas_optimizer_tablet_page.dart',
  'AppRouteNames.sc150TokenApproval':
      'features/wallet/presentation/tablet/pages/wallet_token_approval_tablet_page.dart',
  'AppRouteNames.sc151HealthScore':
      'features/wallet/presentation/tablet/pages/wallet_health_score_tablet_page.dart',
  'AppRouteNames.sc152PendingDeposits':
      'features/wallet/presentation/tablet/pages/pending_deposits_tablet_page.dart',
  'AppRouteNames.sc153WithdrawLimits':
      'features/wallet/presentation/tablet/pages/withdraw_limits_tablet_page.dart',
  'AppRouteNames.sc154DustConverter':
      'features/wallet/presentation/tablet/pages/dust_converter_tablet_page.dart',
  'AppRouteNames.sc155NetworkStatus':
      'features/wallet/presentation/tablet/pages/network_status_tablet_page.dart',
  'AppRouteNames.sc156Profile':
      'features/profile/presentation/phone/pages/profile_page.dart',
  'AppRouteNames.sc157EditProfile':
      'features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart',
  'AppRouteNames.sc158Security':
      'features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart',
  'AppRouteNames.sc159Kyc':
      'features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart',
  'AppRouteNames.sc160Settings':
      'features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart',
  'AppRouteNames.sc161ActivityLog':
      'features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart',
  'AppRouteNames.sc162ApiKeyCreate':
      'features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart',
  'AppRouteNames.sc163ApiManagement':
      'features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart',
  'AppRouteNames.sc164Vip':
      'features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart',
  'AppRouteNames.sc165DeviceManagement':
      'features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart',
  'AppRouteNames.sc166SubAccount':
      'features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart',
  'AppRouteNames.sc413SettingsSecurity':
      'features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart',
  'AppRouteNames.sc405SettingsSecurityBiometric':
      'features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart',
  'AppRouteNames.sc406SettingsSecurityChangePassword':
      'features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart',
  'AppRouteNames.sc227P2PMerchantApply':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc228P2PMerchantProfile':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc247P2PKycRequirements':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc248P2PKycStatus':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc249P2PIdentityVerification':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc250P2PAddressProof':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc402P2PKycVerify':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc403P2PKycFaceMatch':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc251P2PSelfieVerification':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc252P2PVideoVerification':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc232P2PPaymentMethodAdd':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc233P2PPaymentMethodVerification':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc234P2PPaymentMethodOwnership':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc235P2PPaymentMethodCoolingPeriod':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc236P2PPaymentMethodHistory':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc237P2PPaymentMethods':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc253P2PSecurityCenter':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc254P2P2FASettings':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc255P2PDeviceManagement':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc256P2PAntiPhishingCode':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc257P2PLoginHistory':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc258P2PSuspiciousActivity':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc404P2PWhitelistMode':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc229P2PReportMerchant':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc231P2PReviews':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc242P2PContributionHistory':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc276P2PBlacklistAdd':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc277P2PBlacklist':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc259P2PE2EInfo':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc260P2PFraudPrevention':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc266P2PTransactionLimits':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc265P2PLimitTracker':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc267P2PComplianceOverview':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc268P2PAmlScreening':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc269P2PSourceOfFunds':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc270P2PLargeTransaction':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc271P2PRiskAssessment':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc272P2PTaxReporting':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc275P2PAchievements':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc407P2PTaxReportDetail':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc218P2PDisputeDetail':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc219P2PDisputeEvidence':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc220P2PDisputeResolution':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc221P2PDispute':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc222P2PDisputes':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc238P2PInsuranceFund':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc239P2PInsuranceCertificate':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc240P2PInsuranceScore':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc241P2PInsurancePolicy':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc243P2PClaimDetail':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc211P2PExpress':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc210P2PExpressConfirm':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc223P2PAdAnalytics':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc224P2PAdDetail':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc225P2PMyAds':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc226P2PCreateAd':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc230P2PTradingLevel':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc280P2PGuide':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc279P2PSettings':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc278P2PNotificationsSettings':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc273P2POrderBook':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc274P2PDashboard':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc282P2PHome':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc212P2POrderTimeline':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc213P2POrderRate':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc214P2POrderCancel':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc215P2POrderProof':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc216P2POrder':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc217P2PChat':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc245P2PEscrowBalance':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc246P2PEscrowDetail':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc264P2PWallet':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc261P2PWalletTransfer':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc262P2PFundLockHistory':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc263P2PWalletHistoryAlias':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc281P2PMyOrders':
      'features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
  'AppRouteNames.sc180AdminHome': 'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc181AnalyticsDashboard':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc182AbTestDashboard':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc183FunnelDashboard':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc410AdminSettings':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc292HelpCenter': 'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc293Announcements':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc294Support': 'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc319RewardsHub': 'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc320EnterpriseStates':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc321UnifiedPortfolio':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc322CrossModuleAnalytics':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc323SmartAlertCenter':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc324TaxReportCenter':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc325RouteChecker':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc326PerformanceMonitor':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc398MissingScreensShowcase':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc399DesignSystem':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc400DcaOverviewDemo':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc283UnifiedSearch':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc291Notifications':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc284TopicHub': 'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc285TopicCrypto':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc290ReferralHome':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc286ReferralHistory':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc287ReferralRewards':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc288ReferralRules':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc289ReferralFriendDetail':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc027PredictionsHome':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc028PredictionsSearch':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc029PredictionsBreaking':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc030PredictionEventDetail':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc031PredictionsPortfolio':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc032PredictionsRewards':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc033PredictionsLeaderboard':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc034PredictionsGlobalActivity':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc035PredictionOrderReceipt':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc036PredictionRiskCalculator':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc037PredictionMarketMaker':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc038PredictionPortfolioAnalyzer':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc039PredictionEventCalendar':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc040PredictionSocial':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc041PredictionAdvancedChart':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc042PredictionTournaments':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc414PredictionTournamentDetail':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc043PredictionDataIntegration':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc044PairDetail': 'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc045TokenInfo': 'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc046PairDepth': 'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc055AdvancedChart':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc060RiskManagement':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc061ExecutionQuality':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc062AdvancedTools':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc088AdvancedTradingDemo':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc092AdvancedAnalytics':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc169Dca': 'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc170DcaRebalanceConfig':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc171DcaRebalanceDashboard':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc172DcaScheduleConfig':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc173DcaScheduleAnalytics':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc174DcaPortfolioOptimizer':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc175DcaDynamicAmount':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc176DcaBacktester':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc177DcaMultiAsset':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc178DcaPerformanceCompare':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc179DcaSmartRules':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc408DcaRebalanceEdit':
      'shared/layout/vit_tablet_utility_page.dart',
  'AppRouteNames.sc409DcaRebalanceHistory':
      'shared/layout/vit_tablet_utility_page.dart',
};

/// Auth routes list `AuthRouteShell`; child pages own [VitPageContent].
const authRouteNameToPage = <String, String>{
  'AppRouteNames.sc001Login':
      'features/auth/presentation/phone/pages/login_page.dart',
  'AppRouteNames.sc002Register':
      'features/auth/presentation/phone/pages/register_page.dart',
  'AppRouteNames.sc003Otp':
      'features/auth/presentation/phone/pages/otp_page.dart',
  'AppRouteNames.sc004TwoFaSetup':
      'features/auth/presentation/phone/pages/two_fa_setup_page.dart',
  'AppRouteNames.sc005ForgotPassword':
      'features/auth/presentation/phone/pages/forgot_password_page.dart',
  'AppRouteNames.sc006ResetPassword':
      'features/auth/presentation/phone/pages/reset_password_page.dart',
};

/// [InternalSurfaceGate] routes → gated child page (rollup / audit target).
const gateRouteNameToPage = <String, String>{
  'AppRouteNames.sc180AdminHome':
      'features/admin/presentation/pages/admin_home_page.dart',
  'AppRouteNames.sc181AnalyticsDashboard':
      'features/admin/presentation/pages/analytics_dashboard_page.dart',
  'AppRouteNames.sc182AbTestDashboard':
      'features/admin/presentation/pages/ab_test_dashboard_page.dart',
  'AppRouteNames.sc183FunnelDashboard':
      'features/admin/presentation/pages/funnel_dashboard_page.dart',
  'AppRouteNames.sc410AdminSettings':
      'features/admin/presentation/pages/admin_settings_page.dart',
  'AppRouteNames.sc325RouteChecker':
      'features/dev/presentation/pages/route_checker_page.dart',
  'AppRouteNames.sc326PerformanceMonitor':
      'features/dev/presentation/pages/performance_monitor.dart',
  'AppRouteNames.sc398MissingScreensShowcase':
      'features/dev/presentation/pages/missing_screens_showcase_page.dart',
  'AppRouteNames.sc399DesignSystem':
      'features/dev/presentation/pages/design_system_page.dart',
  'AppRouteNames.sc400DcaOverviewDemo':
      'features/dca/presentation/pages/hub/dca_overview_demo.dart',
  'AppRouteNames.sc401CopyTradingCardDemo':
      'features/trade_copy/presentation/pages/hub/copy_trading_card_demo.dart',
};

/// Product-intent tier: declared tier matches UX role though path heuristics differ.
const tierProductRouteOverrides = <String, String>{
  'AppRouteNames.sc221P2PDispute': 'form',
  'AppRouteNames.sc220P2PDisputeResolution': 'form',
  'AppRouteNames.sc232P2PPaymentMethodAdd': 'form',
  'AppRouteNames.sc218P2PDisputeDetail': 'form',
  'AppRouteNames.sc003Otp': 'form',
  'AppRouteNames.sc004TwoFaSetup': 'form',
  'AppRouteNames.sc005ForgotPassword': 'form',
  'AppRouteNames.sc006ResetPassword': 'form',
  'AppRouteNames.sc001Login': 'form',
  'AppRouteNames.sc002Register': 'form',
  'AppRouteNames.sc071PreCopyAssessment': 'form',
  'AppRouteNames.sc226P2PCreateAd': 'form',
  'AppRouteNames.sc233P2PPaymentMethodVerification': 'form',
  'AppRouteNames.sc235P2PPaymentMethodCoolingPeriod': 'form',
  'AppRouteNames.sc213P2POrderRate': 'form',
  'AppRouteNames.sc249P2PIdentityVerification': 'form',
  'AppRouteNames.sc251P2PSelfieVerification': 'form',
  'AppRouteNames.sc402P2PKycVerify': 'form',
  'AppRouteNames.sc403P2PKycFaceMatch': 'form',
  'AppRouteNames.sc143AddressAdd': 'form',
  'AppRouteNames.sc153WithdrawLimits': 'form',
  'AppRouteNames.sc355StakingWithdrawalPolicy': 'form',
  'AppRouteNames.sc188ArenaGovernanceGate': 'form',
  'AppRouteNames.sc023AdvancedCharts': 'flush',
  // Canonical tabbed-detail archetype reference (Flutter-Page-Archetype-Standard.md
  // Archetype A): "Use VitPageRhythm.form when tab panels are data-entry
  // heavy (as in the canonical reference)" — refers to this exact page.
  'AppRouteNames.sc150TokenApproval': 'form',
  // Insurance fund/policy pages are read-only stats & terms displays (standard),
  // not data-entry flows — the form suggestion comes from the dispute/ path
  // heuristic. Wallet hub is a deliberately dense asset list (compact).
  'AppRouteNames.sc238P2PInsuranceFund': 'standard',
  'AppRouteNames.sc244P2PInsuranceFundAlias': 'standard',
  'AppRouteNames.sc241P2PInsurancePolicy': 'standard',
  'AppRouteNames.sc135Wallet': 'compact',
  // SC-009 is L2-with-back (not Markets tab root); standard rhythm matches
  // Page-Rhythm-Standard for detail/overview drill-in pages.
  'AppRouteNames.sc009MarketOverview': 'standard',
};

final flushChartWidgetPatterns = RegExp(
  r'(Chart|Depth|Terminal|Candlestick|OrderBook)Page$',
);

enum LayoutPattern {
  directVpc('direct_vpc'),
  sharedShell('shared_shell'),
  flushChart('flush_chart'),
  gateShell('gate_shell'),
  bottomSheet('bottom_sheet'),
  customScroll('custom_scroll'),
  unmapped('unmapped');

  const LayoutPattern(this.label);
  final String label;
}

String auditLibKey(String relativeLibPath) =>
    'flutter_app/lib/$relativeLibPath';

String normalizeLibPath(String path, String appRoot) {
  final normalized = path.replaceAll('\\', '/');
  final prefix = '${appRoot.replaceAll('\\', '/')}/lib/';
  if (normalized.startsWith(prefix)) {
    return 'flutter_app/lib/${normalized.substring(prefix.length)}';
  }
  if (normalized.startsWith('flutter_app/lib/')) return normalized;
  return 'flutter_app/lib/$normalized';
}

/// Collects all lib-relative files that may contain rhythm for [pagePath].
List<String> collectVpcFilesForPage(
  Directory appRoot,
  String pagePath,
  Set<String> auditRelativePaths,
) {
  final normalizedPage = pagePath.replaceAll('\\', '/');
  final libPrefix = '${appRoot.path}/lib/'.replaceAll('\\', '/');
  final relativePage = normalizedPage.startsWith(libPrefix)
      ? normalizedPage.substring(libPrefix.length)
      : normalizedPage.split('/lib/').last;

  final pageDir = relativePage.substring(0, relativePage.lastIndexOf('/'));
  final pageBase = relativePage.split('/').last.replaceAll('.dart', '');
  final files = <String>{relativePage};

  for (final rel in auditRelativePaths) {
    if (!rel.startsWith('$pageDir/')) continue;
    final name = rel.split('/').last;
    if (name == '$pageBase.dart' || name.startsWith('${pageBase}_part_')) {
      files.add(rel);
    }
  }

  final pageFile = File(
    normalizedPage.startsWith(libPrefix)
        ? normalizedPage
        : '${appRoot.path}/lib/$relativePage',
  );
  var pageSource = '';
  if (pageFile.existsSync()) {
    pageSource = pageFile.readAsStringSync();
    for (final match in RegExp(r"part\s+'([^']+)'").allMatches(pageSource)) {
      final partRel = resolvePartRelativePath(pageDir, match.group(1)!);
      if (auditRelativePaths.contains(partRel)) {
        files.add(partRel);
      }
    }
  }

  if (relativePage.endsWith('trade/presentation/phone/pages/trade_page.dart')) {
    const layout =
        'features/trade_core/presentation/widgets/trade_module_layout.dart';
    if (auditRelativePaths.contains(layout)) files.add(layout);
  }

  if (relativePage.endsWith('home/presentation/pages/home_page.dart')) {
    for (final rel in auditRelativePaths) {
      if (rel.contains('home/presentation/pages/home_page_part_')) {
        files.add(rel);
      }
    }
  }

  final combinedSource = combinedPageSource(appRoot, pagePath);
  for (final entry in shellWidgetToVpcPath.entries) {
    if (_sourceUsesShell(combinedSource, entry.key) &&
        auditRelativePaths.contains(entry.value)) {
      files.add(entry.value);
    }
  }

  if (chartPartPageBases.contains(pageBase)) {
    for (final rel in auditRelativePaths) {
      if (rel.startsWith('$pageDir/${pageBase}_part_')) {
        files.add(rel);
      }
    }
  }

  final sorted = files.toList()..sort();
  return sorted;
}

bool _sourceUsesShell(String source, String shellName) =>
    source.contains('$shellName(');

String combinedPageSource(Directory appRoot, String pagePath) {
  final normalizedPage = pagePath.replaceAll('\\', '/');
  final libPrefix = '${appRoot.path}/lib/'.replaceAll('\\', '/');
  final relativePage = normalizedPage.startsWith(libPrefix)
      ? normalizedPage.substring(libPrefix.length)
      : normalizedPage.split('/lib/').last;
  final pageDir = relativePage.substring(0, relativePage.lastIndexOf('/'));
  final pageFile = File(
    normalizedPage.startsWith(libPrefix)
        ? normalizedPage
        : '${appRoot.path}/lib/$relativePage',
  );
  if (!pageFile.existsSync()) return '';
  final buffer = StringBuffer(pageFile.readAsStringSync());
  for (final match in RegExp(
    r"part\s+'([^']+)'",
  ).allMatches(pageFile.readAsStringSync())) {
    final partPath = File(
      '${appRoot.path}/lib/${resolvePartRelativePath(pageDir, match.group(1)!)}',
    );
    if (partPath.existsSync()) {
      buffer.writeln(partPath.readAsStringSync());
    }
  }
  return buffer.toString();
}

String? resolvePageFilePath({
  required Directory appRoot,
  required String pageWidget,
  required String routeName,
  required Map<String, String> widgetToPage,
}) {
  // Support Truth Table `Wrapper>Child` evidence (route_coverage B0) as well
  // as legacy bare wrapper / bare page names.
  final leaf = pageWidget.contains('>')
      ? pageWidget.split('>').last
      : pageWidget;
  final outer = pageWidget.contains('>')
      ? pageWidget.split('>').first
      : pageWidget;

  // The trade receipt route selects Phone/Tablet page implementations inside
  // one builder, so the route truth table records the conditional branch as
  // `real_page` instead of a concrete leaf widget.
  if (routeName == 'AppRouteNames.sc051OrderReceipt') {
    return '${appRoot.path}/lib/features/trade/presentation/phone/pages/'
            'order_receipt_page.dart'
        .replaceAll('\\', '/');
  }

  final override = widgetClassPageOverrides[leaf];
  if (override != null) {
    return '${appRoot.path}/lib/$override'.replaceAll('\\', '/');
  }
  final routeOverride = routeNameToPageOverrides[routeName];
  if (routeOverride != null) {
    return '${appRoot.path}/lib/$routeOverride'.replaceAll('\\', '/');
  }
  final mapped = widgetToPage[leaf];
  if (mapped != null) {
    return mapped;
  }

  if (outer == 'InternalSurfaceGate' || leaf == 'InternalSurfaceGate') {
    final gated = gateRouteNameToPage[routeName];
    if (gated != null) {
      return '${appRoot.path}/lib/$gated'.replaceAll('\\', '/');
    }
  }
  if (outer == 'AuthRouteShell' || leaf == 'AuthRouteShell') {
    final rel = authRouteNameToPage[routeName];
    if (rel != null) {
      return '${appRoot.path}/lib/$rel'.replaceAll('\\', '/');
    }
  }

  // Builder functions (e.g. buildOtpPage) are not classes — fall back by name.
  final gatedByName = gateRouteNameToPage[routeName];
  if (gatedByName != null) {
    return '${appRoot.path}/lib/$gatedByName'.replaceAll('\\', '/');
  }
  final authByName = authRouteNameToPage[routeName];
  if (authByName != null) {
    return '${appRoot.path}/lib/$authByName'.replaceAll('\\', '/');
  }
  return null;
}

LayoutPattern classifyLayoutPattern({
  required String pageWidget,
  required String routePath,
  required String routeName,
  required String pageFile,
  required List<String> vpcFiles,
  String? pageSource,
}) {
  if (pageSource != null && pageSource.contains('VitPageContent(')) {
    return LayoutPattern.directVpc;
  }

  for (final shell in shellWidgetToVpcPath.keys) {
    if (pageSource != null && pageSource.contains('$shell(')) {
      return LayoutPattern.sharedShell;
    }
  }

  if (vpcFiles.any((f) => shellWidgetToVpcPath.values.contains(f))) {
    return LayoutPattern.sharedShell;
  }

  if (gateShellWidgets.contains(pageWidget) &&
      !gateRouteNameToPage.containsKey(routeName)) {
    return LayoutPattern.gateShell;
  }

  if (pageSource != null &&
      pageSource.contains('VitPageLayout') &&
      (pageSource.contains('VitAutoHideHeaderScaffold') ||
          pageSource.contains('VitPageVariant.flush'))) {
    return LayoutPattern.customScroll;
  }

  if (flushChartWidgetPatterns.hasMatch(pageWidget) ||
      routePath.contains('/chart') ||
      routePath.contains('/depth') ||
      routePath.contains('/terminal')) {
    return LayoutPattern.flushChart;
  }

  if (vpcFiles.isNotEmpty) {
    return LayoutPattern.directVpc;
  }

  if (routePath.contains('/sheet') || pageWidget.endsWith('Sheet')) {
    return LayoutPattern.bottomSheet;
  }

  return LayoutPattern.unmapped;
}

String complianceNote({
  required LayoutPattern pattern,
  required String l1Status,
  required String l2Status,
  required int innerGapViolations,
  required String declaredTier,
  required String suggestedTier,
}) {
  if (pattern == LayoutPattern.flushChart) {
    return 'exception:flush_chart';
  }
  if (pattern == LayoutPattern.gateShell) {
    return 'exception:gate_shell';
  }
  if (pattern == LayoutPattern.bottomSheet) {
    return 'exception:bottom_sheet';
  }
  if (pattern == LayoutPattern.customScroll) {
    return 'exception:custom_scroll';
  }
  if (l1Status == 'pass' && l2Status == 'pass' && innerGapViolations == 0) {
    return 'compliant';
  }
  if (innerGapViolations > 0) {
    return 'debt:inner_gap';
  }
  if (declaredTier.isNotEmpty &&
      suggestedTier.isNotEmpty &&
      declaredTier != suggestedTier &&
      !declaredTier.contains('|')) {
    return 'debt:tier_mismatch';
  }
  if (l1Status == 'unknown' || l2Status == 'unknown') {
    return 'unmapped';
  }
  return 'compliant';
}

String tierStatus(
  String declaredTier,
  String suggestedTier, {
  String? routeName,
}) {
  if (routeName != null && tierProductRouteOverrides.containsKey(routeName)) {
    final productTier = tierProductRouteOverrides[routeName]!;
    final declared = declaredTier.split('|').toSet();
    if (declared.contains(productTier)) {
      return 'aligned';
    }
  }
  if (declaredTier.isEmpty || suggestedTier.isEmpty) return '';
  final declared = declaredTier.split('|').toSet();
  final suggested = suggestedTier.split('|').toSet();
  if (declared.length == 1 &&
      suggested.length == 1 &&
      declared.first == suggested.first) {
    return 'aligned';
  }
  if (declared.intersection(suggested).isNotEmpty) {
    return 'aligned';
  }
  return 'exception';
}

String resolveDeclaredTierForPattern({
  required LayoutPattern pattern,
  required List<String> vpcFiles,
  required Map<String, String> declaredTierByLibKey,
}) {
  if (vpcFiles.isEmpty) return '';
  final tiers = <String>{};
  for (final file in vpcFiles) {
    if (pattern == LayoutPattern.sharedShell &&
        !shellWidgetToVpcPath.values.contains(file)) {
      continue;
    }
    final tier = declaredTierByLibKey[auditLibKey(file)];
    if (tier != null && tier.isNotEmpty) tiers.add(tier);
  }
  if (tiers.isEmpty) {
    for (final file in vpcFiles) {
      final tier = declaredTierByLibKey[auditLibKey(file)];
      if (tier != null && tier.isNotEmpty) tiers.add(tier);
    }
  }
  return tiers.join('|');
}

String resolveSuggestedTierForPattern({
  required LayoutPattern pattern,
  required List<String> vpcFiles,
  required Map<String, String> suggestedTierByLibKey,
}) {
  if (vpcFiles.isEmpty) return '';
  final tiers = <String>{};
  for (final file in vpcFiles) {
    if (pattern == LayoutPattern.sharedShell &&
        !shellWidgetToVpcPath.values.contains(file)) {
      continue;
    }
    final tier = suggestedTierByLibKey[auditLibKey(file)];
    if (tier != null && tier.isNotEmpty) tiers.add(tier);
  }
  if (tiers.isEmpty) {
    for (final file in vpcFiles) {
      final tier = suggestedTierByLibKey[auditLibKey(file)];
      if (tier != null && tier.isNotEmpty) tiers.add(tier);
    }
  }
  return tiers.join('|');
}

String resolvePartRelativePath(String pageDir, String partUri) {
  final segments = pageDir.split('/');
  for (final segment in partUri.split('/')) {
    if (segment == '..') {
      if (segments.isNotEmpty) segments.removeLast();
    } else if (segment != '.') {
      segments.add(segment);
    }
  }
  return segments.join('/');
}

String rulesStatus({
  required String l1,
  required String l2,
  required int innerGapViolations,
  required String tierStatusValue,
}) {
  final parts = <String>[];
  parts.add('R1:${l1 == 'pass' || l1 == 'unknown' ? 'pass' : 'warn'}');
  parts.add(
    'R2:${l2 == 'pass'
        ? 'pass'
        : l2 == 'unknown'
        ? 'pass'
        : 'warn'}',
  );
  parts.add(
    'R3:${l1 == 'pass'
        ? 'pass'
        : l1 == 'unknown'
        ? 'pass'
        : 'warn'}',
  );
  parts.add(
    'R4:${l1 == 'pass'
        ? 'pass'
        : l1 == 'unknown'
        ? 'pass'
        : 'warn'}',
  );
  parts.add('R5:${innerGapViolations == 0 ? 'pass' : 'warn'}');
  parts.add(
    'R6:${tierStatusValue == 'aligned' || tierStatusValue.isEmpty ? 'pass' : 'warn'}',
  );
  return parts.join('|');
}
