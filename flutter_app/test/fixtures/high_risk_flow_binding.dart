// Size-gate note (QA audit 2026-07-27, Future-Feature-Onboarding-Checklist
// "data fixture files above 500 lines"): this file is intentionally long
// because it is a single homogeneous data table — one `HighRiskFlowBinding`
// entry per high-risk contract, each holding a fixed-shape list of
// `HighRiskFlowScreenBinding` stage rows for that flow. The ~80 lines of
// model/lookup code at the top (`HighRiskFlowScreenBinding`,
// `HighRiskFlowBinding`, `findByContractId`/`findByRoute`) is shared
// plumbing for every entry in `HighRiskFlowBindings.bindings` below it —
// there is no mixed responsibility to split out, only more per-flow rows.
// Consumers include every `test/features/**` mock-repository lifecycle test
// and `test/core/product_flow/high_risk_flow_binding_test.dart` /
// `high_risk_flow_route_pump_test.dart`.
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';

final class HighRiskFlowScreenBinding {
  const HighRiskFlowScreenBinding({
    required this.stage,
    required this.routePath,
    required this.screenName,
    required this.repositoryMethod,
    required this.snapshotType,
    required this.stateKey,
    this.relatedRoutePaths = const [],
  });

  final HighRiskFlowStage stage;
  final String routePath;
  final String screenName;
  final String repositoryMethod;
  final String snapshotType;
  final String stateKey;
  final List<String> relatedRoutePaths;

  List<String> get routePaths => [routePath, ...relatedRoutePaths];
}

final class HighRiskFlowBinding {
  const HighRiskFlowBinding({
    required this.contractId,
    required this.repositoryName,
    required this.primarySnapshotType,
    required this.supportContextFlowKey,
    required this.screenBindings,
  });

  final String contractId;
  final String repositoryName;
  final String primarySnapshotType;
  final String supportContextFlowKey;
  final List<HighRiskFlowScreenBinding> screenBindings;

  HighRiskFlowContract get contract =>
      HighRiskFlowContracts.findById(contractId)!;

  bool get coversRequiredStages => missingRequiredStages.isEmpty;

  bool get coversContractRoutes {
    final covered = normalizedRoutePaths.toSet();
    return contractRoutePaths
        .map(HighRiskFlowBindings.normalizeRoutePath)
        .every(covered.contains);
  }

  List<HighRiskFlowStage> get missingRequiredStages {
    final covered = screenBindings.map((binding) => binding.stage).toSet();
    return [
      for (final stage in HighRiskFlowContracts.requiredStages)
        if (!covered.contains(stage)) stage,
    ];
  }

  List<String> get contractRoutePaths => [
    contract.entryRoute,
    contract.supportRoute,
    for (final step in contract.steps)
      if (step.routePath != null) step.routePath!,
  ];

  List<String> get normalizedRoutePaths => [
    for (final binding in screenBindings)
      for (final routePath in binding.routePaths)
        HighRiskFlowBindings.normalizeRoutePath(routePath),
  ];

  HighRiskFlowScreenBinding? screenFor(HighRiskFlowStage stage) {
    for (final binding in screenBindings) {
      if (binding.stage == stage) return binding;
    }
    return null;
  }
}

final class HighRiskFlowBindings {
  const HighRiskFlowBindings._();

  static const bindings = [
    HighRiskFlowBinding(
      contractId: HighRiskFlowContractIds.tradeSpotOrder,
      repositoryName: 'TradeRepository',
      primarySnapshotType: 'TradeScreenSnapshot',
      supportContextFlowKey: 'order',
      screenBindings: [
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.entry,
          routePath: '/trade/btcusdt',
          screenName: 'TradePage',
          repositoryMethod: 'getTrade',
          snapshotType: 'TradeScreenSnapshot',
          stateKey: 'pair_entry',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.eligibilityCheck,
          routePath: '/trade/btcusdt',
          screenName: 'TradePage',
          repositoryMethod: 'getTrade',
          snapshotType: 'TradeScreenSnapshot',
          stateKey: 'balance_pair_account_readiness',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.setupOrConfiguration,
          routePath: '/trade/btcusdt',
          screenName: 'TradePage',
          repositoryMethod: 'previewOrder',
          snapshotType: 'TradeOrderDraft',
          stateKey: 'spot_order_form',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.riskAndFeePreview,
          routePath: '/trade/btcusdt',
          screenName: 'TradePage',
          repositoryMethod: 'previewOrder',
          snapshotType: 'TradeOrderPreview',
          stateKey: 'spot_preview_sheet',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.explicitConfirmation,
          routePath: '/trade/btcusdt',
          screenName: 'TradePage',
          repositoryMethod: 'submitOrder',
          snapshotType: 'TradeOrderDraft',
          stateKey: 'spot_confirmation',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.submittedState,
          routePath: '/trade/order-receipt',
          screenName: 'OrderReceiptPage',
          repositoryMethod: 'getOrderReceipt',
          snapshotType: 'TradeOrderReceiptSnapshot',
          stateKey: 'order_submitted',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          routePath: '/trade/order-receipt',
          screenName: 'OrderReceiptPage',
          repositoryMethod: 'getOrderReceipt',
          snapshotType: 'TradeOrderReceiptSnapshot',
          stateKey: 'order_receipt',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.manageOrHistory,
          routePath: '/trade/orders-history',
          screenName: 'OrdersHistoryPage',
          repositoryMethod: 'getOrdersHistory',
          snapshotType: 'TradeOrdersHistorySnapshot',
          stateKey: 'open_orders_history',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.supportOrRecovery,
          routePath: '/support?flow=order&referenceId=ORD-98EH1ZT2',
          screenName: 'SupportPage',
          repositoryMethod: 'supportRouteFor',
          snapshotType: 'ProductSupportContext',
          stateKey: 'order_support_context',
        ),
      ],
    ),
    HighRiskFlowBinding(
      contractId: HighRiskFlowContractIds.tradeMarginFutures,
      repositoryName: 'TradeRepository',
      primarySnapshotType: 'TradeMarginTradingSnapshot',
      supportContextFlowKey: 'order',
      screenBindings: [
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.entry,
          routePath: '/trade/margin',
          screenName: 'MarginTradingPage',
          repositoryMethod: 'getMarginTrading',
          snapshotType: 'TradeMarginTradingSnapshot',
          stateKey: 'margin_entry',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.eligibilityCheck,
          routePath: '/trade/margin/hub',
          screenName: 'MarginTradingHubPage',
          repositoryMethod: 'getMarginTradingHub',
          snapshotType: 'TradeMarginTradingHubSnapshot',
          stateKey: 'margin_appropriateness',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.setupOrConfiguration,
          routePath: '/trade/margin/btcusdt',
          screenName: 'MarginTradingPage',
          repositoryMethod: 'getMarginTrading',
          snapshotType: 'TradeMarginTradingSnapshot',
          stateKey: 'leverage_collateral_setup',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.riskAndFeePreview,
          routePath: '/trade/margin/advanced-demo',
          screenName: 'AdvancedTradingDemoPage',
          repositoryMethod: 'getAdvancedTradingDemo',
          snapshotType: 'TradeAdvancedTradingDemoSnapshot',
          stateKey: 'liquidation_fee_preview',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.explicitConfirmation,
          routePath: '/trade/margin/btcusdt',
          screenName: 'MarginTradingPage',
          repositoryMethod: 'previewFuturesOrder',
          snapshotType: 'TradeFuturesPreview',
          stateKey: 'leverage_confirmation',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.submittedState,
          routePath: '/trade/positions',
          screenName: 'PositionDashboardPage',
          repositoryMethod: 'getTradePositions',
          snapshotType: 'TradePositionsSnapshot',
          stateKey: 'margin_order_submitted',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          routePath: '/trade/positions',
          screenName: 'PositionDashboardPage',
          repositoryMethod: 'getTradePositions',
          snapshotType: 'TradePositionsSnapshot',
          stateKey: 'position_status_detail',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.manageOrHistory,
          routePath: '/trade/margin/advanced-analytics',
          screenName: 'AdvancedAnalyticsPage',
          repositoryMethod: 'getAdvancedAnalytics',
          snapshotType: 'TradeAdvancedAnalyticsSnapshot',
          stateKey: 'margin_management_history',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.supportOrRecovery,
          routePath: '/support?flow=order&referenceId=margin-btcusdt',
          screenName: 'SupportPage',
          repositoryMethod: 'supportRouteFor',
          snapshotType: 'ProductSupportContext',
          stateKey: 'margin_recovery_support',
        ),
      ],
    ),
    HighRiskFlowBinding(
      contractId: HighRiskFlowContractIds.tradeBots,
      repositoryName: 'TradeRepository',
      primarySnapshotType: 'TradeBotsSnapshot',
      supportContextFlowKey: 'order',
      screenBindings: [
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.entry,
          routePath: '/trade/bots',
          screenName: 'TradingBotsPage',
          repositoryMethod: 'getTradingBots',
          snapshotType: 'TradeBotsSnapshot',
          stateKey: 'bot_hub',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.eligibilityCheck,
          routePath: '/trade/bots/suitability-assessment',
          screenName: 'BotSuitabilityAssessmentPage',
          repositoryMethod: 'getBotSuitabilityAssessment',
          snapshotType: 'TradeBotSuitabilityAssessmentSnapshot',
          stateKey: 'bot_suitability',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.setupOrConfiguration,
          routePath: '/trade/bots/backtesting',
          screenName: 'BotBacktestingPage',
          repositoryMethod: 'getBotBacktesting',
          snapshotType: 'TradeBotBacktestingSnapshot',
          stateKey: 'strategy_backtest_setup',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.riskAndFeePreview,
          routePath: '/trade/bots/risk-dashboard',
          screenName: 'BotRiskDashboardPage',
          repositoryMethod: 'getBotRiskDashboard',
          snapshotType: 'TradeBotRiskDashboardSnapshot',
          stateKey: 'automation_risk_preview',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.explicitConfirmation,
          routePath: '/trade/bots/security-settings',
          screenName: 'BotSecuritySettingsPage',
          repositoryMethod: 'patchBotSecuritySettings',
          snapshotType: 'TradeBotSecuritySettingsSnapshot',
          stateKey: 'bot_start_pause_confirmation',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.submittedState,
          routePath: '/trade/bots/portfolio-dashboard',
          screenName: 'BotPortfolioDashboardPage',
          repositoryMethod: 'submitBotAction',
          snapshotType: 'TradeBotPortfolioDashboardSnapshot',
          stateKey: 'bot_command_submitted',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          routePath: '/trade/bots/portfolio-dashboard',
          screenName: 'BotPortfolioDashboardPage',
          repositoryMethod: 'getBotPortfolioDashboard',
          snapshotType: 'TradeBotPortfolioDashboardSnapshot',
          stateKey: 'bot_status_detail',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.manageOrHistory,
          routePath: '/trade/bots/history',
          screenName: 'BotHistoryPage',
          repositoryMethod: 'getBotHistory',
          snapshotType: 'TradeBotHistorySnapshot',
          stateKey: 'bot_history',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.supportOrRecovery,
          routePath: '/trade/bots/emergency-stop',
          screenName: 'BotEmergencyStopPage',
          repositoryMethod: 'submitBotEmergencyStop',
          snapshotType: 'TradeBotEmergencyStopSnapshot',
          stateKey: 'bot_emergency_recovery',
          relatedRoutePaths: ['/support?flow=order&referenceId=bot-risk'],
        ),
      ],
    ),
    HighRiskFlowBinding(
      contractId: HighRiskFlowContractIds.tradeCopy,
      repositoryName: 'TradeRepository',
      primarySnapshotType: 'TradeCopyTradingSnapshot',
      supportContextFlowKey: 'order',
      screenBindings: [
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.entry,
          routePath: '/trade/copy-trading',
          screenName: 'CopyTradingPage',
          repositoryMethod: 'getCopyTrading',
          snapshotType: 'TradeCopyTradingSnapshot',
          stateKey: 'copy_hub',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.eligibilityCheck,
          routePath: '/trade/copy-trading/education',
          screenName: 'CopyEducationPage',
          repositoryMethod: 'getCopyEducation',
          snapshotType: 'TradeCopyEducationSnapshot',
          stateKey: 'copy_education_suitability',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.setupOrConfiguration,
          routePath: '/trade/copy-provider/cp-alpha/configuration',
          screenName: 'CopyConfigurationPage',
          repositoryMethod: 'getCopyConfiguration',
          snapshotType: 'TradeCopyConfigurationSnapshot',
          stateKey: 'provider_allocation_setup',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.riskAndFeePreview,
          routePath: '/trade/copy-trading/ex-ante-costs',
          screenName: 'ExAnteCostsPage',
          repositoryMethod: 'getExAnteCosts',
          snapshotType: 'TradeExAnteCostsSnapshot',
          stateKey: 'copy_cost_risk_preview',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.explicitConfirmation,
          routePath: '/trade/copy-provider/cp-alpha/confirmation',
          screenName: 'CopyConfirmationPage',
          repositoryMethod: 'submitCopyConfirmation',
          snapshotType: 'TradeCopyConfirmationSnapshot',
          stateKey: 'copy_setup_confirmation',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.submittedState,
          routePath: '/trade/copy-trading/active',
          screenName: 'ActiveCopiesPage',
          repositoryMethod: 'submitCopyTradingAction',
          snapshotType: 'TradeActiveCopiesSnapshot',
          stateKey: 'copy_setup_submitted',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          routePath: '/trade/copy-trading/active',
          screenName: 'ActiveCopiesPage',
          repositoryMethod: 'getActiveCopies',
          snapshotType: 'TradeActiveCopiesSnapshot',
          stateKey: 'active_copy_status',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.manageOrHistory,
          routePath: '/trade/copy-audit-log/copy001',
          screenName: 'CopyAuditLogPage',
          repositoryMethod: 'getCopyAuditLog',
          snapshotType: 'TradeCopyAuditLogSnapshot',
          stateKey: 'copy_audit_history',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.supportOrRecovery,
          routePath: '/trade/copy-dispute-resolution',
          screenName: 'DisputeResolutionPage',
          repositoryMethod: 'getDisputeResolution',
          snapshotType: 'TradeDisputeResolutionSnapshot',
          stateKey: 'copy_dispute_recovery',
          relatedRoutePaths: ['/support?flow=order&referenceId=copy001'],
        ),
      ],
    ),
    HighRiskFlowBinding(
      contractId: HighRiskFlowContractIds.walletMoneyMovement,
      repositoryName: 'WalletRepository',
      primarySnapshotType: 'WalletWithdrawSnapshot',
      supportContextFlowKey: 'withdrawal',
      screenBindings: [
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.entry,
          routePath: '/wallet',
          screenName: 'WalletPage',
          repositoryMethod: 'getWallet',
          snapshotType: 'WalletSnapshot',
          stateKey: 'wallet_hub',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.eligibilityCheck,
          routePath: '/wallet/limits',
          screenName: 'WithdrawLimitsPage',
          repositoryMethod: 'getWithdrawLimits',
          snapshotType: 'WalletWithdrawLimitsSnapshot',
          stateKey: 'limits_address_security',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.setupOrConfiguration,
          routePath: '/wallet/withdraw/USDT',
          screenName: 'WithdrawPage',
          repositoryMethod: 'getWithdraw',
          snapshotType: 'WalletWithdrawSnapshot',
          stateKey: 'withdrawal_setup',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.riskAndFeePreview,
          routePath: '/wallet/withdraw/USDT',
          screenName: 'WithdrawPage',
          repositoryMethod: 'getWithdraw',
          snapshotType: 'WithdrawPreview',
          stateKey: 'withdrawal_fee_preview',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.explicitConfirmation,
          routePath: '/wallet/withdraw/USDT',
          screenName: 'WithdrawPage',
          repositoryMethod: 'getWithdraw',
          snapshotType: 'WithdrawPreview',
          stateKey: 'withdrawal_confirmation',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.submittedState,
          routePath: '/wallet/transaction/tx001',
          screenName: 'TransactionDetailPage',
          repositoryMethod: 'getTransactionDetail',
          snapshotType: 'WalletTransactionDetailSnapshot',
          stateKey: 'withdrawal_submitted',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          routePath: '/wallet/transaction/tx001',
          screenName: 'TransactionDetailPage',
          repositoryMethod: 'getTransactionDetail',
          snapshotType: 'WalletTransactionDetailSnapshot',
          stateKey: 'transaction_detail',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.manageOrHistory,
          routePath: '/wallet/history',
          screenName: 'TransactionHistoryPage',
          repositoryMethod: 'getTransactionHistory',
          snapshotType: 'WalletTransactionHistorySnapshot',
          stateKey: 'wallet_history',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.supportOrRecovery,
          routePath: '/support?flow=withdrawal&referenceId=tx001',
          screenName: 'SupportPage',
          repositoryMethod: 'supportRouteFor',
          snapshotType: 'ProductSupportContext',
          stateKey: 'withdrawal_support_context',
        ),
      ],
    ),
    HighRiskFlowBinding(
      contractId: HighRiskFlowContractIds.p2pEscrowOrder,
      repositoryName: 'P2PRepository',
      primarySnapshotType: 'P2POrderSnapshot',
      supportContextFlowKey: 'p2p_order',
      screenBindings: [
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.entry,
          routePath: '/p2p',
          screenName: 'P2PHomePage',
          repositoryMethod: 'getHome',
          snapshotType: 'P2PHomeSnapshot',
          stateKey: 'p2p_hub',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.eligibilityCheck,
          routePath: '/p2p/kyc/requirements',
          screenName: 'P2PKycRequirementsPage',
          repositoryMethod: 'getKycRequirements',
          snapshotType: 'P2PKycRequirementsSnapshot',
          stateKey: 'p2p_kyc_payment_readiness',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.setupOrConfiguration,
          routePath: '/p2p/express',
          screenName: 'P2PExpressPage',
          repositoryMethod: 'getExpress',
          snapshotType: 'P2PExpressSnapshot',
          stateKey: 'express_order_setup',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.riskAndFeePreview,
          routePath: '/p2p/express/confirm',
          screenName: 'P2PExpressConfirmPage',
          repositoryMethod: 'getExpressConfirm',
          snapshotType: 'P2PExpressConfirmSnapshot',
          stateKey: 'escrow_preview',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.explicitConfirmation,
          routePath: '/p2p/express/confirm',
          screenName: 'P2PExpressConfirmPage',
          repositoryMethod: 'getExpressConfirm',
          snapshotType: 'P2PExpressConfirmSnapshot',
          stateKey: 'p2p_order_confirmation',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.submittedState,
          routePath: '/p2p/order/order001',
          screenName: 'P2POrderPage',
          repositoryMethod: 'getOrder',
          snapshotType: 'P2POrderSnapshot',
          stateKey: 'escrow_order_submitted',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          routePath: '/p2p/order/timeline/order001',
          screenName: 'P2POrderTimelinePage',
          repositoryMethod: 'getOrderTimeline',
          snapshotType: 'P2POrderTimelineSnapshot',
          stateKey: 'order_timeline_dispute_status',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.manageOrHistory,
          routePath: '/p2p/my-orders',
          screenName: 'P2PMyOrdersPage',
          repositoryMethod: 'getMyOrders',
          snapshotType: 'P2PMyOrdersSnapshot',
          stateKey: 'p2p_order_history',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.supportOrRecovery,
          routePath: '/p2p/disputes',
          screenName: 'P2PDisputesPage',
          repositoryMethod: 'getDisputes',
          snapshotType: 'P2PDisputesSnapshot',
          stateKey: 'p2p_dispute_recovery',
          relatedRoutePaths: ['/support?flow=p2p_order&referenceId=order001'],
        ),
      ],
    ),
    HighRiskFlowBinding(
      contractId: HighRiskFlowContractIds.earnSavingsStaking,
      repositoryName: 'StakingEarnRepository',
      primarySnapshotType: 'StakingEarnSnapshot',
      supportContextFlowKey: 'staking',
      screenBindings: [
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.entry,
          routePath: '/earn/staking',
          screenName: 'StakingEarnPage',
          repositoryMethod: 'getStakingEarn',
          snapshotType: 'StakingEarnSnapshot',
          stateKey: 'earn_staking_entry',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.eligibilityCheck,
          routePath: '/earn/staking/terms',
          screenName: 'StakingTermsPage',
          repositoryMethod: 'getTerms',
          snapshotType: 'StakingTermsSnapshot',
          stateKey: 'terms_suitability_custody',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.setupOrConfiguration,
          routePath: '/earn/validator-selection',
          screenName: 'StakingValidatorSelectionPage',
          repositoryMethod: 'getSelection',
          snapshotType: 'StakingValidatorSelectionSnapshot',
          stateKey: 'validator_amount_setup',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.riskAndFeePreview,
          routePath: '/earn/staking/risk-assessment',
          screenName: 'StakingRiskAssessmentPage',
          repositoryMethod: 'getRiskAssessment',
          snapshotType: 'StakingRiskAssessmentSnapshot',
          stateKey: 'yield_lockup_slashing_preview',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.explicitConfirmation,
          routePath: '/earn/staking/terms',
          screenName: 'StakingTermsPage',
          repositoryMethod: 'getTerms',
          snapshotType: 'StakingTermsSnapshot',
          stateKey: 'stake_redeem_confirmation',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.submittedState,
          routePath: '/earn/history',
          screenName: 'StakingHistoryPage',
          repositoryMethod: 'getHistory',
          snapshotType: 'StakingHistorySnapshot',
          stateKey: 'earn_action_submitted',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          routePath: '/earn/history',
          screenName: 'StakingHistoryPage',
          repositoryMethod: 'getHistory',
          snapshotType: 'StakingHistorySnapshot',
          stateKey: 'earn_receipt_detail',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.manageOrHistory,
          routePath: '/earn/dashboard',
          screenName: 'StakingDashboardPage',
          repositoryMethod: 'getDashboard',
          snapshotType: 'StakingDashboardSnapshot',
          stateKey: 'earn_dashboard_management',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.supportOrRecovery,
          routePath: '/support?flow=staking&referenceId=staking-position',
          screenName: 'SupportPage',
          repositoryMethod: 'supportRouteFor',
          snapshotType: 'ProductSupportContext',
          stateKey: 'staking_support_context',
        ),
      ],
    ),
    HighRiskFlowBinding(
      contractId: HighRiskFlowContractIds.launchpadTokenAccess,
      repositoryName: 'LaunchpadRepository',
      primarySnapshotType: 'LaunchpadBridgeOrderSnapshot',
      supportContextFlowKey: 'launchpad',
      screenBindings: [
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.entry,
          routePath: '/launchpad',
          screenName: 'LaunchpadPage',
          repositoryMethod: 'getHome',
          snapshotType: 'LaunchpadHomeSnapshot',
          stateKey: 'launchpad_entry',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.eligibilityCheck,
          routePath: '/launchpad/portfolio',
          screenName: 'LaunchpadPortfolioPage',
          repositoryMethod: 'getPortfolio',
          snapshotType: 'LaunchpadPortfolioSnapshot',
          stateKey: 'kyc_funding_allocation_check',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.setupOrConfiguration,
          routePath: '/launchpad/idobridge/sample',
          screenName: 'LaunchpadIdoBridgePage',
          repositoryMethod: 'getIdoBridge',
          snapshotType: 'LaunchpadIdoBridgeSnapshot',
          stateKey: 'ido_bridge_setup',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.riskAndFeePreview,
          routePath: '/launchpad/contract/sample',
          screenName: 'LaunchpadContractPage',
          repositoryMethod: 'getContract',
          snapshotType: 'LaunchpadContractSnapshot',
          stateKey: 'contract_gas_fee_preview',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.explicitConfirmation,
          routePath: '/launchpad/receipt/sub001',
          screenName: 'LaunchpadReceiptPage',
          repositoryMethod: 'getReceipt',
          snapshotType: 'LaunchpadReceiptSnapshot',
          stateKey: 'subscription_bridge_confirmation',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.submittedState,
          routePath: '/launchpad/bridge-order/tx001',
          screenName: 'LaunchpadBridgeOrderPage',
          repositoryMethod: 'getBridgeOrder',
          snapshotType: 'LaunchpadBridgeOrderSnapshot',
          stateKey: 'launchpad_tx_submitted',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          routePath: '/launchpad/claim-receipt/pos001',
          screenName: 'LaunchpadClaimReceiptPage',
          repositoryMethod: 'getClaimReceipt',
          snapshotType: 'LaunchpadClaimReceiptSnapshot',
          stateKey: 'claim_bridge_receipt',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.manageOrHistory,
          routePath: '/launchpad/portfolio',
          screenName: 'LaunchpadPortfolioPage',
          repositoryMethod: 'getPortfolio',
          snapshotType: 'LaunchpadPortfolioSnapshot',
          stateKey: 'launchpad_portfolio_history',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.supportOrRecovery,
          routePath: '/support?flow=launchpad&referenceId=tx001',
          screenName: 'SupportPage',
          repositoryMethod: 'supportRouteFor',
          snapshotType: 'ProductSupportContext',
          stateKey: 'launchpad_support_context',
        ),
      ],
    ),
    HighRiskFlowBinding(
      contractId: HighRiskFlowContractIds.predictionMarketEvent,
      repositoryName: 'PredictionsRepository',
      primarySnapshotType: 'PredictionEventDetailSnapshot',
      supportContextFlowKey: 'order',
      screenBindings: [
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.entry,
          routePath: '/predictions',
          screenName: 'PredictionsHomePage',
          repositoryMethod: 'getHome',
          snapshotType: 'PredictionHomeSnapshot',
          stateKey: 'prediction_discovery',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.eligibilityCheck,
          routePath: '/predictions/risk-calculator',
          screenName: 'PredictionRiskCalculatorPage',
          repositoryMethod: 'getRiskCalculator',
          snapshotType: 'PredictionRiskCalculatorSnapshot',
          stateKey: 'event_rules_wallet_readiness',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.setupOrConfiguration,
          routePath: '/predictions/event/event001',
          screenName: 'PredictionEventDetailPage',
          repositoryMethod: 'getEventDetail',
          snapshotType: 'PredictionEventDetailSnapshot',
          stateKey: 'outcome_side_amount_setup',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.riskAndFeePreview,
          routePath: '/predictions/advanced-chart/event001',
          screenName: 'PredictionAdvancedChartPage',
          repositoryMethod: 'getAdvancedChart',
          snapshotType: 'PredictionAdvancedChartSnapshot',
          stateKey: 'probability_liquidity_preview',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.explicitConfirmation,
          routePath: '/predictions/event/event001',
          screenName: 'PredictionEventDetailPage',
          repositoryMethod: 'getEventDetail',
          snapshotType: 'PredictionEventDetailSnapshot',
          stateKey: 'prediction_order_confirmation',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.submittedState,
          routePath: '/predictions/receipt/receipt001',
          screenName: 'PredictionOrderReceiptPage',
          repositoryMethod: 'getOrderReceipt',
          snapshotType: 'PredictionOrderReceiptSnapshot',
          stateKey: 'prediction_order_submitted',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          routePath: '/predictions/receipt/receipt001',
          screenName: 'PredictionOrderReceiptPage',
          repositoryMethod: 'getOrderReceipt',
          snapshotType: 'PredictionOrderReceiptSnapshot',
          stateKey: 'prediction_receipt_detail',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.manageOrHistory,
          routePath: '/predictions/portfolio',
          screenName: 'PredictionsPortfolioPage',
          repositoryMethod: 'getPortfolio',
          snapshotType: 'PredictionPortfolioSnapshot',
          stateKey: 'prediction_portfolio_history',
        ),
        HighRiskFlowScreenBinding(
          stage: HighRiskFlowStage.supportOrRecovery,
          routePath: '/support?flow=order&referenceId=receipt001',
          screenName: 'SupportPage',
          repositoryMethod: 'supportRouteFor',
          snapshotType: 'ProductSupportContext',
          stateKey: 'prediction_support_context',
        ),
      ],
    ),
  ];

  static HighRiskFlowBinding? findByContractId(String contractId) {
    for (final binding in bindings) {
      if (binding.contractId == contractId) return binding;
    }
    return null;
  }

  static HighRiskFlowBinding? findByRoute(String routePath) {
    final normalized = normalizeRoutePath(routePath);
    for (final binding in bindings) {
      if (binding.normalizedRoutePaths.contains(normalized)) return binding;
    }
    return null;
  }

  static String normalizeRoutePath(String routePath) {
    final pathOnly = routePath.split('?').first;
    if (pathOnly.length > 1 && pathOnly.endsWith('/')) {
      return pathOnly.substring(0, pathOnly.length - 1);
    }
    return pathOnly;
  }
}
