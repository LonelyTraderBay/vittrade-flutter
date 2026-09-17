enum HighRiskFlowStage {
  entry,
  eligibilityCheck,
  setupOrConfiguration,
  riskAndFeePreview,
  explicitConfirmation,
  submittedState,
  receiptOrStatusDetail,
  manageOrHistory,
  supportOrRecovery,
}

extension HighRiskFlowStageX on HighRiskFlowStage {
  String get key => switch (this) {
    HighRiskFlowStage.entry => 'entry',
    HighRiskFlowStage.eligibilityCheck => 'eligibility_check',
    HighRiskFlowStage.setupOrConfiguration => 'setup_or_configuration',
    HighRiskFlowStage.riskAndFeePreview => 'risk_and_fee_preview',
    HighRiskFlowStage.explicitConfirmation => 'explicit_confirmation',
    HighRiskFlowStage.submittedState => 'submitted_state',
    HighRiskFlowStage.receiptOrStatusDetail => 'receipt_or_status_detail',
    HighRiskFlowStage.manageOrHistory => 'manage_or_history',
    HighRiskFlowStage.supportOrRecovery => 'support_or_recovery',
  };
}

final class HighRiskFlowStep {
  const HighRiskFlowStep({
    required this.stage,
    required this.label,
    this.routePath,
  });

  final HighRiskFlowStage stage;
  final String label;
  final String? routePath;
}

final class HighRiskFlowContract {
  const HighRiskFlowContract({
    required this.id,
    required this.productArea,
    required this.module,
    required this.capability,
    required this.ownerSurface,
    required this.entryRoute,
    required this.supportRoute,
    required this.steps,
  });

  final String id;
  final String productArea;
  final String module;
  final String capability;
  final String ownerSurface;
  final String entryRoute;
  final String supportRoute;
  final List<HighRiskFlowStep> steps;

  bool get coversRequiredStages => missingRequiredStages.isEmpty;

  List<HighRiskFlowStage> get missingRequiredStages {
    final covered = steps.map((step) => step.stage).toSet();
    return [
      for (final stage in HighRiskFlowContracts.requiredStages)
        if (!covered.contains(stage)) stage,
    ];
  }
}

final class HighRiskFlowContractIds {
  const HighRiskFlowContractIds._();

  static const tradeSpotOrder = 'trade_spot_order';
  static const tradeMarginFutures = 'trade_margin_futures';
  static const tradeBots = 'trade_bots';
  static const tradeCopy = 'trade_copy';
  static const walletMoneyMovement = 'wallet_money_movement';
  static const p2pEscrowOrder = 'p2p_escrow_order';
  static const earnSavingsStaking = 'earn_savings_staking';
  static const launchpadTokenAccess = 'launchpad_token_access';
  static const predictionMarketEvent = 'prediction_market_event';
}

final class HighRiskFlowContracts {
  const HighRiskFlowContracts._();

  static const requiredStages = [
    HighRiskFlowStage.entry,
    HighRiskFlowStage.eligibilityCheck,
    HighRiskFlowStage.setupOrConfiguration,
    HighRiskFlowStage.riskAndFeePreview,
    HighRiskFlowStage.explicitConfirmation,
    HighRiskFlowStage.submittedState,
    HighRiskFlowStage.receiptOrStatusDetail,
    HighRiskFlowStage.manageOrHistory,
    HighRiskFlowStage.supportOrRecovery,
  ];

  static const contracts = [
    HighRiskFlowContract(
      id: HighRiskFlowContractIds.tradeSpotOrder,
      productArea: 'Trading Execution',
      module: 'trade',
      capability: 'Spot order execution',
      ownerSurface: 'Trade tab',
      entryRoute: '/trade/btcusdt',
      supportRoute: '/support',
      steps: [
        HighRiskFlowStep(stage: HighRiskFlowStage.entry, label: 'Pair entry'),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.eligibilityCheck,
          label: 'Balance, pair status, and account readiness',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.setupOrConfiguration,
          label: 'Side, order type, price, amount, TP/SL setup',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.riskAndFeePreview,
          label: 'Total, fee, slippage, balance impact preview',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.explicitConfirmation,
          label: 'Order confirmation before submission',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.submittedState,
          label: 'Order submission status',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          label: 'Order receipt',
          routePath: '/trade/order-receipt',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.manageOrHistory,
          label: 'Open orders and order history',
          routePath: '/trade/orders-history',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.supportOrRecovery,
          label: 'Trading support with order context',
          routePath: '/support',
        ),
      ],
    ),
    HighRiskFlowContract(
      id: HighRiskFlowContractIds.tradeMarginFutures,
      productArea: 'Margin and Advanced Trading',
      module: 'trade',
      capability: 'Margin and leverage execution',
      ownerSurface: 'Trade tab',
      entryRoute: '/trade/margin',
      supportRoute: '/support',
      steps: [
        HighRiskFlowStep(stage: HighRiskFlowStage.entry, label: 'Margin hub'),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.eligibilityCheck,
          label: 'Appropriateness, leverage limit, and collateral readiness',
          routePath: '/trade/margin/hub',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.setupOrConfiguration,
          label: 'Pair, leverage, collateral, and order setup',
          routePath: '/trade/margin/btcusdt',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.riskAndFeePreview,
          label: 'Liquidation, funding, margin, and fee preview',
          routePath: '/trade/margin/advanced-demo',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.explicitConfirmation,
          label: 'Leverage or margin order confirmation',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.submittedState,
          label: 'Margin order submission status',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          label: 'Position status detail',
          routePath: '/trade/positions',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.manageOrHistory,
          label: 'Margin analytics and management',
          routePath: '/trade/margin/advanced-analytics',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.supportOrRecovery,
          label: 'Liquidation and margin support',
          routePath: '/support',
        ),
      ],
    ),
    HighRiskFlowContract(
      id: HighRiskFlowContractIds.tradeBots,
      productArea: 'Trading Automation',
      module: 'trade_bots',
      capability: 'Trading bots',
      ownerSurface: 'Trade product hub',
      entryRoute: '/trade/bots',
      supportRoute: '/support',
      steps: [
        HighRiskFlowStep(stage: HighRiskFlowStage.entry, label: 'Bot hub'),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.eligibilityCheck,
          label: 'Terms, risk disclosure, suitability, and API readiness',
          routePath: '/trade/bots/suitability-assessment',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.setupOrConfiguration,
          label: 'Strategy, symbol, limits, and security setup',
          routePath: '/trade/bots/backtesting',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.riskAndFeePreview,
          label: 'Drawdown, exposure, fee, and automation risk preview',
          routePath: '/trade/bots/risk-dashboard',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.explicitConfirmation,
          label: 'Start, pause, or emergency stop confirmation',
          routePath: '/trade/bots/security-settings',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.submittedState,
          label: 'Bot command submitted state',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          label: 'Bot performance and status detail',
          routePath: '/trade/bots/portfolio-dashboard',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.manageOrHistory,
          label: 'Bot history and reporting',
          routePath: '/trade/bots/history',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.supportOrRecovery,
          label: 'Bot support and emergency recovery',
          routePath: '/support',
        ),
      ],
    ),
    HighRiskFlowContract(
      id: HighRiskFlowContractIds.tradeCopy,
      productArea: 'Copy Trading',
      module: 'trade_copy',
      capability: 'Copy trading',
      ownerSurface: 'Trade product hub',
      entryRoute: '/trade/copy-trading',
      supportRoute: '/support',
      steps: [
        HighRiskFlowStep(stage: HighRiskFlowStage.entry, label: 'Copy hub'),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.eligibilityCheck,
          label: 'Education, suitability, KID, and risk disclosures',
          routePath: '/trade/copy-trading/education',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.setupOrConfiguration,
          label: 'Provider and allocation configuration',
          routePath: '/trade/copy-provider/cp-alpha/configuration',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.riskAndFeePreview,
          label: 'Provider risk, costs, slippage, and RIY preview',
          routePath: '/trade/copy-trading/ex-ante-costs',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.explicitConfirmation,
          label: 'Copy setup confirmation',
          routePath: '/trade/copy-provider/cp-alpha/confirmation',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.submittedState,
          label: 'Copy setup submitted state',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          label: 'Active copy and performance status',
          routePath: '/trade/copy-trading/active',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.manageOrHistory,
          label: 'Audit log, attribution, and governance history',
          routePath: '/trade/copy-audit-log/copy001',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.supportOrRecovery,
          label: 'Copy dispute or complaint recovery',
          routePath: '/trade/copy-dispute-resolution',
        ),
      ],
    ),
    HighRiskFlowContract(
      id: HighRiskFlowContractIds.walletMoneyMovement,
      productArea: 'Wallet and Treasury',
      module: 'wallet',
      capability: 'Deposit, withdrawal, transfer, and address controls',
      ownerSurface: 'Wallet tab',
      entryRoute: '/wallet',
      supportRoute: '/support',
      steps: [
        HighRiskFlowStep(stage: HighRiskFlowStage.entry, label: 'Wallet hub'),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.eligibilityCheck,
          label: 'Limits, network status, address state, and security checks',
          routePath: '/wallet/limits',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.setupOrConfiguration,
          label: 'Asset, network, amount, address, and transfer setup',
          routePath: '/wallet/withdraw/USDT',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.riskAndFeePreview,
          label: 'Fee, arrival, limit, and address risk preview',
          routePath: '/wallet/withdraw/USDT',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.explicitConfirmation,
          label: 'Withdrawal or transfer confirmation',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.submittedState,
          label: 'Transaction submitted state',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          label: 'Transaction detail',
          routePath: '/wallet/transaction/tx001',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.manageOrHistory,
          label: 'Wallet history and approvals',
          routePath: '/wallet/history',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.supportOrRecovery,
          label: 'Wallet support with transaction context',
          routePath: '/support',
        ),
      ],
    ),
    HighRiskFlowContract(
      id: HighRiskFlowContractIds.p2pEscrowOrder,
      productArea: 'P2P Trading',
      module: 'p2p',
      capability: 'P2P order, escrow, and dispute lifecycle',
      ownerSurface: 'Trade product hub',
      entryRoute: '/p2p',
      supportRoute: '/support',
      steps: [
        HighRiskFlowStep(stage: HighRiskFlowStage.entry, label: 'P2P hub'),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.eligibilityCheck,
          label: 'P2P KYC, payment method, limits, and trust checks',
          routePath: '/p2p/kyc/requirements',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.setupOrConfiguration,
          label: 'Offer, amount, payment method, and merchant selection',
          routePath: '/p2p/express',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.riskAndFeePreview,
          label: 'Escrow, fee, merchant reputation, and payment preview',
          routePath: '/p2p/express/confirm',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.explicitConfirmation,
          label: 'P2P order confirmation',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.submittedState,
          label: 'Escrow order submitted state',
          routePath: '/p2p/order/order001',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          label: 'Order timeline, chat, proof, and dispute status',
          routePath: '/p2p/order/timeline/order001',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.manageOrHistory,
          label: 'My P2P orders and escrow history',
          routePath: '/p2p/my-orders',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.supportOrRecovery,
          label: 'P2P dispute and support recovery',
          routePath: '/p2p/disputes',
        ),
      ],
    ),
    HighRiskFlowContract(
      id: HighRiskFlowContractIds.earnSavingsStaking,
      productArea: 'Earn and Savings',
      module: 'earn',
      capability: 'Staking, savings, and yield operations',
      ownerSurface: 'Trade product hub',
      entryRoute: '/earn/staking',
      supportRoute: '/support',
      steps: [
        HighRiskFlowStep(stage: HighRiskFlowStage.entry, label: 'Earn entry'),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.eligibilityCheck,
          label: 'Terms, risk disclosure, suitability, and custody checks',
          routePath: '/earn/staking/terms',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.setupOrConfiguration,
          label: 'Product, validator, term, amount, and auto-compound setup',
          routePath: '/earn/validator-selection',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.riskAndFeePreview,
          label: 'Yield, lockup, slashing, custody, and fee preview',
          routePath: '/earn/staking/risk-assessment',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.explicitConfirmation,
          label: 'Stake, redeem, or savings action confirmation',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.submittedState,
          label: 'Earn action submitted state',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          label: 'Earn history and receipt detail',
          routePath: '/earn/history',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.manageOrHistory,
          label: 'Earn dashboard and portfolio management',
          routePath: '/earn/dashboard',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.supportOrRecovery,
          label: 'Earn support and emergency action recovery',
          routePath: '/support',
        ),
      ],
    ),
    HighRiskFlowContract(
      id: HighRiskFlowContractIds.launchpadTokenAccess,
      productArea: 'Launchpad and Token Access',
      module: 'launchpad',
      capability: 'Launchpad subscription, bridge, claim, and settlement',
      ownerSurface: 'Trade product hub',
      entryRoute: '/launchpad',
      supportRoute: '/support',
      steps: [
        HighRiskFlowStep(
          stage: HighRiskFlowStage.entry,
          label: 'Launchpad entry',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.eligibilityCheck,
          label: 'KYC, funding, eligibility, allocation, and risk checks',
          routePath: '/launchpad/portfolio',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.setupOrConfiguration,
          label: 'IDO bridge, contract, staking, and address setup',
          routePath: '/launchpad/idobridge/sample',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.riskAndFeePreview,
          label: 'Contract, bridge, gas, allocation, and fee preview',
          routePath: '/launchpad/contract/sample',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.explicitConfirmation,
          label: 'Subscription, bridge, or claim confirmation',
          routePath: '/launchpad/receipt/sub001',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.submittedState,
          label: 'Launchpad transaction submitted state',
          routePath: '/launchpad/bridge-order/tx001',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          label: 'Launchpad claim or bridge receipt',
          routePath: '/launchpad/claim-receipt/pos001',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.manageOrHistory,
          label: 'Launchpad portfolio, staking, and event history',
          routePath: '/launchpad/portfolio',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.supportOrRecovery,
          label: 'Launchpad support with transaction context',
          routePath: '/support',
        ),
      ],
    ),
    HighRiskFlowContract(
      id: HighRiskFlowContractIds.predictionMarketEvent,
      productArea: 'Prediction Markets',
      module: 'predictions',
      capability: 'Prediction event trading and receipt lifecycle',
      ownerSurface: 'Markets tab',
      entryRoute: '/predictions',
      supportRoute: '/support',
      steps: [
        HighRiskFlowStep(
          stage: HighRiskFlowStage.entry,
          label: 'Prediction market discovery',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.eligibilityCheck,
          label: 'Event rules, wallet readiness, and risk calculator checks',
          routePath: '/predictions/risk-calculator',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.setupOrConfiguration,
          label: 'Outcome, probability, side, amount, and limit setup',
          routePath: '/predictions/event/event001',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.riskAndFeePreview,
          label: 'Probability, liquidity, fee, and payout scenario preview',
          routePath: '/predictions/advanced-chart/event001',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.explicitConfirmation,
          label: 'Prediction order confirmation',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.submittedState,
          label: 'Prediction order submitted state',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.receiptOrStatusDetail,
          label: 'Prediction receipt detail',
          routePath: '/predictions/receipt/receipt001',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.manageOrHistory,
          label: 'Prediction portfolio and activity history',
          routePath: '/predictions/portfolio',
        ),
        HighRiskFlowStep(
          stage: HighRiskFlowStage.supportOrRecovery,
          label: 'Prediction support with event and receipt context',
          routePath: '/support',
        ),
      ],
    ),
  ];

  static HighRiskFlowContract? findById(String id) {
    for (final contract in contracts) {
      if (contract.id == id) return contract;
    }
    return null;
  }
}
