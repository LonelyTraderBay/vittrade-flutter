part of 'app_route_contracts.dart';

final class AppRoutePaths {
  const AppRoutePaths._();

  // ==== AUTH ====
  static const String root = AuthRoutePaths.root;
  static const String authLogin = AuthRoutePaths.authLogin;
  static const String authRegister = AuthRoutePaths.authRegister;
  static const String authOtp = AuthRoutePaths.authOtp;
  static const String auth2faSetup = AuthRoutePaths.auth2faSetup;
  static const String authForgotPassword = AuthRoutePaths.authForgotPassword;
  static const String authResetPassword = AuthRoutePaths.authResetPassword;

  // ==== HOME ====
  static const String home = HomeRoutePaths.home;

  // ==== DISCOVERY ====
  static const String search = UtilityRoutePaths.search;
  static const String topics = UtilityRoutePaths.topics;
  static const String topicCrypto = UtilityRoutePaths.topicCrypto;

  // ==== REFERRAL ====
  static const String referral = UtilityRoutePaths.referral;
  static const String referralHistory = UtilityRoutePaths.referralHistory;
  static const String referralRewards = UtilityRoutePaths.referralRewards;
  static const String referralRules = UtilityRoutePaths.referralRules;
  static String referralFriend(String friendId) =>
      UtilityRoutePaths.referralFriend(friendId);

  // ==== CROSS_MODULE ====
  static const String enterpriseStates = UtilityRoutePaths.enterpriseStates;
  static const String unifiedPortfolio = UtilityRoutePaths.unifiedPortfolio;
  static const String crossModuleAnalytics =
      UtilityRoutePaths.crossModuleAnalytics;
  static const String smartAlerts = UtilityRoutePaths.smartAlerts;
  static const String taxReports = UtilityRoutePaths.taxReports;

  // ==== DEV ====
  static const String routeChecker = UtilityRoutePaths.routeChecker;
  static const String performanceMonitor = UtilityRoutePaths.performanceMonitor;
  static const String devShowcase = UtilityRoutePaths.devShowcase;
  static const String devDesignSystem = UtilityRoutePaths.devDesignSystem;
  static const String devDcaOverview = UtilityRoutePaths.devDcaOverview;
  static const String demoCopyCard = TradeCopyRoutePaths.demoCopyCard;

  // ==== EARN (staking + savings) ====
  static const String earn = EarnRoutePaths.earn;
  static const String earnStaking = EarnRoutePaths.earnStaking;
  static const String earnStakingTerms = EarnRoutePaths.earnStakingTerms;
  static const String earnStakingRiskDisclosure =
      EarnRoutePaths.earnStakingRiskDisclosure;
  static const String earnStakingWithdrawalPolicy =
      EarnRoutePaths.earnStakingWithdrawalPolicy;
  static const String earnStakingTaxGuide = EarnRoutePaths.earnStakingTaxGuide;
  static const String earnStakingRiskAssessment =
      EarnRoutePaths.earnStakingRiskAssessment;
  static const String earnDashboard = EarnRoutePaths.earnDashboard;
  static const String earnAnalytics = EarnRoutePaths.earnAnalytics;
  static const String earnCalendar = EarnRoutePaths.earnCalendar;
  static const String earnHistory = EarnRoutePaths.earnHistory;
  static const String earnValidatorSelection =
      EarnRoutePaths.earnValidatorSelection;
  static const String earnAutoCompound = EarnRoutePaths.earnAutoCompound;
  static const String earnLiquidStaking = EarnRoutePaths.earnLiquidStaking;
  static const String earnInsurance = EarnRoutePaths.earnInsurance;
  static const String earnAdvancedOrders = EarnRoutePaths.earnAdvancedOrders;
  static const String earnMultiChain = EarnRoutePaths.earnMultiChain;
  static const String earnInstitutional = EarnRoutePaths.earnInstitutional;
  static const String earnGuide = EarnRoutePaths.earnGuide;
  static const String earnFAQ = EarnRoutePaths.earnFAQ;
  static const String earnNotifications = EarnRoutePaths.earnNotifications;
  static const String earnRecommendations = EarnRoutePaths.earnRecommendations;
  static const String earnRegulatoryFramework =
      EarnRoutePaths.earnRegulatoryFramework;
  static const String earnAuditReports = EarnRoutePaths.earnAuditReports;
  static const String earnCustody = EarnRoutePaths.earnCustody;
  static const String earnSuitabilityAssessment =
      EarnRoutePaths.earnSuitabilityAssessment;
  static const String earnInsuranceFundTransparency =
      EarnRoutePaths.earnInsuranceFundTransparency;
  static const String earnTransactionReporting =
      EarnRoutePaths.earnTransactionReporting;
  static const String earnApiDocumentation =
      EarnRoutePaths.earnApiDocumentation;
  static const String earnProofOfReserves = EarnRoutePaths.earnProofOfReserves;
  static const String earnRiskDashboard = EarnRoutePaths.earnRiskDashboard;
  static const String earnSlashingHistory = EarnRoutePaths.earnSlashingHistory;
  static const String earnValidatorHealthMonitor =
      EarnRoutePaths.earnValidatorHealthMonitor;
  static const String earnRiskScoreCalculator =
      EarnRoutePaths.earnRiskScoreCalculator;
  static const String earnEmergencyActions =
      EarnRoutePaths.earnEmergencyActions;
  static const String earnContingencyPlan = EarnRoutePaths.earnContingencyPlan;
  static const String earnSocialFeed = EarnRoutePaths.earnSocialFeed;
  static const String earnCommunityGovernance =
      EarnRoutePaths.earnCommunityGovernance;
  static const String earnProposals = EarnRoutePaths.earnProposals;
  static const String earnVoting = EarnRoutePaths.earnVoting;
  static String earnVotingProposal(String proposalId) =>
      EarnRoutePaths.earnVotingProposal(proposalId);
  static const String earnVotingProposalRoute =
      EarnRoutePaths.earnVotingProposalRoute;
  static const String earnForum = EarnRoutePaths.earnForum;
  static const String earnWebhooks = EarnRoutePaths.earnWebhooks;
  static const String earnDataExport = EarnRoutePaths.earnDataExport;
  static const String earnThirdPartyIntegrations =
      EarnRoutePaths.earnThirdPartyIntegrations;
  static const String earnDeveloperConsole =
      EarnRoutePaths.earnDeveloperConsole;
  static const String earnSavings = EarnRoutePaths.earnSavings;
  static const String earnSavingsPortfolio =
      EarnRoutePaths.earnSavingsPortfolio;
  static const String earnSavingsHistory = EarnRoutePaths.earnSavingsHistory;
  static const String earnSavingsGuide = EarnRoutePaths.earnSavingsGuide;
  static const String earnSavingsFAQ = EarnRoutePaths.earnSavingsFAQ;
  static const String earnSavingsNotifications =
      EarnRoutePaths.earnSavingsNotifications;
  static const String earnSavingsRecommendations =
      EarnRoutePaths.earnSavingsRecommendations;
  static const String earnSavingsRiskAssessment =
      EarnRoutePaths.earnSavingsRiskAssessment;
  static const String earnSavingsComparison =
      EarnRoutePaths.earnSavingsComparison;
  static const String earnSavingsAutoCompound =
      EarnRoutePaths.earnSavingsAutoCompound;
  static const String earnSavingsGoals = EarnRoutePaths.earnSavingsGoals;
  static const String earnSavingsAnalytics =
      EarnRoutePaths.earnSavingsAnalytics;
  static const String earnSavingsRebalance =
      EarnRoutePaths.earnSavingsRebalance;
  static const String earnSavingsNotificationPreferences =
      EarnRoutePaths.earnSavingsNotificationPreferences;
  static const String earnSavingsDca = EarnRoutePaths.earnSavingsDca;
  static const String earnSavingsSmartSuggestions =
      EarnRoutePaths.earnSavingsSmartSuggestions;
  static const String earnSavingsExport = EarnRoutePaths.earnSavingsExport;
  static const String earnSavingsBacktest = EarnRoutePaths.earnSavingsBacktest;
  static const String earnSavingsAutoPilot =
      EarnRoutePaths.earnSavingsAutoPilot;
  static const String earnSavingsLadder = EarnRoutePaths.earnSavingsLadder;
  static const String earnSavingsWhatIf = EarnRoutePaths.earnSavingsWhatIf;
  static const String earnSavingsProductSample =
      EarnRoutePaths.earnSavingsProductSample;
  static const String earnSavingsRedeemPos001 =
      EarnRoutePaths.earnSavingsRedeemPos001;
  static const String earnSavingsReceipt = EarnRoutePaths.earnSavingsReceipt;

  // ==== NOTIFICATIONS ====
  static const String notifications = UtilityRoutePaths.notifications;

  // ==== SUPPORT ====
  static const String support = SupportRoutePaths.support;
  static const String supportAnnouncements =
      SupportRoutePaths.supportAnnouncements;

  // ==== LAUNCHPAD ====
  static const String launchpad = LaunchpadRoutePaths.launchpad;
  static const String launchpadPortfolio =
      LaunchpadRoutePaths.launchpadPortfolio;
  static const String launchpadPerformance =
      LaunchpadRoutePaths.launchpadPerformance;
  static const String launchpadStaking = LaunchpadRoutePaths.launchpadStaking;
  static const String launchpadBatchClaim =
      LaunchpadRoutePaths.launchpadBatchClaim;
  static const String launchpadClaimReceiptPos001 =
      LaunchpadRoutePaths.launchpadClaimReceiptPos001;
  static const String launchpadIdoBridgeSample =
      LaunchpadRoutePaths.launchpadIdoBridgeSample;
  static const String launchpadBridgeCompare =
      LaunchpadRoutePaths.launchpadBridgeCompare;
  static const String launchpadBridgeOrderTx001 =
      LaunchpadRoutePaths.launchpadBridgeOrderTx001;
  static const String launchpadContractSample =
      LaunchpadRoutePaths.launchpadContractSample;
  static const String launchpadReceiptSub001 =
      LaunchpadRoutePaths.launchpadReceiptSub001;
  static const String launchpadSample = LaunchpadRoutePaths.launchpadSample;
  static const String launchpadNotifSound =
      LaunchpadRoutePaths.launchpadNotifSound;
  static const String launchpadEventLog = LaunchpadRoutePaths.launchpadEventLog;
  static const String launchpadAbiDiff = LaunchpadRoutePaths.launchpadAbiDiff;
  static const String launchpadAddressBook =
      LaunchpadRoutePaths.launchpadAddressBook;
  static const String launchpadWebhooks = LaunchpadRoutePaths.launchpadWebhooks;
  static const String launchpadGasTracker =
      LaunchpadRoutePaths.launchpadGasTracker;
  static const String launchpadRebalance =
      LaunchpadRoutePaths.launchpadRebalance;
  static const String launchpadMultisig = LaunchpadRoutePaths.launchpadMultisig;
  static const String launchpadSwapAggregator =
      LaunchpadRoutePaths.launchpadSwapAggregator;
  static const String launchpadLimitOrders =
      LaunchpadRoutePaths.launchpadLimitOrders;
  static const String launchpadDcaBuilder =
      LaunchpadRoutePaths.launchpadDcaBuilder;
  static const String launchpadRiskAnalytics =
      LaunchpadRoutePaths.launchpadRiskAnalytics;

  // ==== NEWS ====
  static const String news = HomeRoutePaths.news;

  // ==== MARKETS ====
  static const String markets = MarketsRoutePaths.markets;
  static const String marketsOverview = MarketsRoutePaths.marketsOverview;
  static const String marketsMovers = MarketsRoutePaths.marketsMovers;
  static const String marketsSectors = MarketsRoutePaths.marketsSectors;
  static const String marketsWatchlist = MarketsRoutePaths.marketsWatchlist;
  static const String marketsHeatmap = MarketsRoutePaths.marketsHeatmap;
  static const String marketsAlerts = MarketsRoutePaths.marketsAlerts;
  static const String marketsScreener = MarketsRoutePaths.marketsScreener;
  static const String marketsCompare = MarketsRoutePaths.marketsCompare;
  static const String marketsCalendar = MarketsRoutePaths.marketsCalendar;
  static const String marketsDerivatives = MarketsRoutePaths.marketsDerivatives;
  static const String marketsDepth = MarketsRoutePaths.marketsDepth;
  static const String marketsSocialSentiment =
      MarketsRoutePaths.marketsSocialSentiment;
  static const String marketsPortfolioTracker =
      MarketsRoutePaths.marketsPortfolioTracker;
  static const String marketsNews = MarketsRoutePaths.marketsNews;
  static const String marketsAdvancedCharts =
      MarketsRoutePaths.marketsAdvancedCharts;
  static const String marketsUnlocks = MarketsRoutePaths.marketsUnlocks;
  static const String marketsSignals = MarketsRoutePaths.marketsSignals;
  static const String marketsCorrelations =
      MarketsRoutePaths.marketsCorrelations;

  // ==== PREDICTIONS (nested under /markets/predictions) ====
  static const String marketsPredictions =
      PredictionsRoutePaths.marketsPredictions;
  static const String marketsPredictionsSearch =
      PredictionsRoutePaths.marketsPredictionsSearch;
  static const String marketsPredictionsBreaking =
      PredictionsRoutePaths.marketsPredictionsBreaking;
  static const String marketsPredictionsPortfolio =
      PredictionsRoutePaths.marketsPredictionsPortfolio;
  static String marketsPredictionEvent(String eventId) =>
      PredictionsRoutePaths.marketsPredictionEvent(eventId);
  static String marketsPredictionReceipt(String receiptId) =>
      PredictionsRoutePaths.marketsPredictionReceipt(receiptId);
  static const String marketsPredictionsRewards =
      PredictionsRoutePaths.marketsPredictionsRewards;
  static const String marketsPredictionsLeaderboard =
      PredictionsRoutePaths.marketsPredictionsLeaderboard;
  static const String marketsPredictionsActivity =
      PredictionsRoutePaths.marketsPredictionsActivity;
  static const String marketsPredictionsRiskCalculator =
      PredictionsRoutePaths.marketsPredictionsRiskCalculator;
  static const String marketsPredictionsMarketMaker =
      PredictionsRoutePaths.marketsPredictionsMarketMaker;
  static const String marketsPredictionsPortfolioAnalyzer =
      PredictionsRoutePaths.marketsPredictionsPortfolioAnalyzer;
  static const String marketsPredictionsEventCalendar =
      PredictionsRoutePaths.marketsPredictionsEventCalendar;
  static const String marketsPredictionsSocial =
      PredictionsRoutePaths.marketsPredictionsSocial;
  static String marketsPredictionsAdvancedChart(String eventId) =>
      PredictionsRoutePaths.marketsPredictionsAdvancedChart(eventId);
  static const String marketsPredictionsTournaments =
      PredictionsRoutePaths.marketsPredictionsTournaments;
  static String marketsPredictionTournament(String tournamentId) =>
      PredictionsRoutePaths.marketsPredictionTournament(tournamentId);
  static const String marketsPredictionsDataIntegration =
      PredictionsRoutePaths.marketsPredictionsDataIntegration;

  // ==== MARKETS (pair/token detail) ====
  static String pairDetail(String pairId) =>
      MarketsRoutePaths.pairDetail(pairId);
  static String pairInfo(String pairId) => MarketsRoutePaths.pairInfo(pairId);
  static String pairDepth(String pairId) => MarketsRoutePaths.pairDepth(pairId);

  // ==== TRADE FAMILY (trade, trade_bots, trade_compliance, trade_copy, trade_terminal — heavily interleaved by historical rollout order, not split further) ====
  static String tradeAdvancedChart(String pairId) =>
      TradeTerminalRoutePaths.tradeAdvancedChart(pairId);
  static String tradePair(String pairId) => TradeRoutePaths.tradePair(pairId);
  static String tradeFutures(String pairId) =>
      TradeRoutePaths.tradeFutures(pairId);
  static String tradeFuturesLeverage(String pairId) =>
      TradeRoutePaths.tradeFuturesLeverage(pairId);
  static const String tradeOrderReceipt = TradeRoutePaths.tradeOrderReceipt;
  static const String tradeOrdersHistory = TradeRoutePaths.tradeOrdersHistory;
  static const String tradeSettings = TradeRoutePaths.tradeSettings;
  static const String tradePositions = TradeRoutePaths.tradePositions;
  static const String tradeExport = TradeRoutePaths.tradeExport;
  static const String tradeConvert = TradeRoutePaths.tradeConvert;
  static const String tradeBots = TradeBotsRoutePaths.tradeBots;
  static const String tradeBotTermsOfService =
      TradeBotsRoutePaths.tradeBotTermsOfService;
  static const String tradeBotRiskDisclosure =
      TradeBotsRoutePaths.tradeBotRiskDisclosure;
  static const String tradeBotSuitabilityAssessment =
      TradeBotsRoutePaths.tradeBotSuitabilityAssessment;
  static const String tradeBotRiskDashboard =
      TradeBotsRoutePaths.tradeBotRiskDashboard;
  static const String tradeBotEmergencyStop =
      TradeBotsRoutePaths.tradeBotEmergencyStop;
  static const String tradeBotSecuritySettings =
      TradeBotsRoutePaths.tradeBotSecuritySettings;
  static const String tradeBotHistory = TradeBotsRoutePaths.tradeBotHistory;
  static const String tradeBotPerformanceAnalytics =
      TradeBotsRoutePaths.tradeBotPerformanceAnalytics;
  static const String tradeBotBacktesting =
      TradeBotsRoutePaths.tradeBotBacktesting;
  static const String tradeBotStrategyCompare =
      TradeBotsRoutePaths.tradeBotStrategyCompare;
  static const String tradeBotOptimization =
      TradeBotsRoutePaths.tradeBotOptimization;
  static const String tradeBotPortfolioDashboard =
      TradeBotsRoutePaths.tradeBotPortfolioDashboard;
  static const String tradeBotDrawdownAnalyzer =
      TradeBotsRoutePaths.tradeBotDrawdownAnalyzer;
  static const String tradeBotEquityCurve =
      TradeBotsRoutePaths.tradeBotEquityCurve;
  static const String tradeBotGuide = TradeBotsRoutePaths.tradeBotGuide;
  static const String tradeBotFaq = TradeBotsRoutePaths.tradeBotFaq;
  static const String tradeBotTaxReporting =
      TradeBotsRoutePaths.tradeBotTaxReporting;
  static const String tradeBotApiDocumentation =
      TradeBotsRoutePaths.tradeBotApiDocumentation;
  static const String tradeRiskManagement =
      TradeTerminalRoutePaths.tradeRiskManagement;
  static const String tradeExecutionQuality =
      TradeTerminalRoutePaths.tradeExecutionQuality;
  static const String tradeAdvancedTools =
      TradeTerminalRoutePaths.tradeAdvancedTools;
  static const String tradeCopyTrading = TradeCopyRoutePaths.tradeCopyTrading;
  static const String tradeCopyEducation =
      TradeCopyRoutePaths.tradeCopyEducation;
  static const String tradeCopyActive = TradeCopyRoutePaths.tradeCopyActive;
  static const String tradeCopySettings = TradeCopyRoutePaths.tradeCopySettings;
  static const String tradeCopyNotifications =
      TradeCopyRoutePaths.tradeCopyNotifications;
  static const String tradeCopyComparison =
      TradeCopyRoutePaths.tradeCopyComparison;
  static const String tradeCopyProviderApply =
      TradeCopyRoutePaths.tradeCopyProviderApply;
  static String tradeCopyProvider(String providerId, {String? backPath}) =>
      TradeCopyRoutePaths.tradeCopyProvider(providerId, backPath: backPath);

  static String tradeCopyProviderAssessment(String providerId) =>
      TradeCopyRoutePaths.tradeCopyProviderAssessment(providerId);

  static String tradeCopyProviderConfiguration(
    String providerId, {
    String? backPath,
  }) => TradeCopyRoutePaths.tradeCopyProviderConfiguration(
    providerId,
    backPath: backPath,
  );

  static String tradeCopyProviderConfirmation(String providerId) =>
      TradeCopyRoutePaths.tradeCopyProviderConfirmation(providerId);

  static String tradeCopyPerformance(String copyId) =>
      TradeCopyRoutePaths.tradeCopyPerformance(copyId);

  static String tradeCopyPerformanceAttribution(String copyId) =>
      TradeCopyRoutePaths.tradeCopyPerformanceAttribution(copyId);

  static String tradeCopyAuditLog(String copyId) =>
      TradeCopyRoutePaths.tradeCopyAuditLog(copyId);

  static const String tradeCopyRiskAnalysis =
      TradeCopyRoutePaths.tradeCopyRiskAnalysis;
  static const String tradeCopyLeaderboard =
      TradeCopyRoutePaths.tradeCopyLeaderboard;
  static const String tradeCopySafety = TradeCopyRoutePaths.tradeCopySafety;
  static const String tradeCopyProviderGovernance =
      TradeCopyRoutePaths.tradeCopyProviderGovernance;
  static const String tradeCopyDisputeResolution =
      TradeCopyRoutePaths.tradeCopyDisputeResolution;
  static const String tradeCopySafetyCenter =
      TradeCopyRoutePaths.tradeCopySafetyCenter;
  static const String tradeCopyRegulatoryDisclosures =
      TradeComplianceRoutePaths.tradeCopyRegulatoryDisclosures;
  static const String tradeCopyTransactionReporting =
      TradeComplianceRoutePaths.tradeCopyTransactionReporting;
  static const String tradeCopyRegulatoryReportsDashboard =
      TradeComplianceRoutePaths.tradeCopyRegulatoryReportsDashboard;
  static const String tradeCopyArmIntegrationStatus =
      TradeComplianceRoutePaths.tradeCopyArmIntegrationStatus;
  static const String tradeCopyBestExecutionReports =
      TradeComplianceRoutePaths.tradeCopyBestExecutionReports;
  static const String tradeCopyExecutionVenueAnalysis =
      TradeComplianceRoutePaths.tradeCopyExecutionVenueAnalysis;
  static const String tradeCopySlippageMonitoring =
      TradeComplianceRoutePaths.tradeCopySlippageMonitoring;
  static const String tradeCopyClientCategorization =
      TradeComplianceRoutePaths.tradeCopyClientCategorization;
  static const String tradeCopyClientOptUpRequest =
      TradeComplianceRoutePaths.tradeCopyClientOptUpRequest;
  static const String tradeCopyRegulatoryDisclosuresAlias =
      TradeRoutePaths.tradeCopyRegulatoryDisclosuresAlias;
  static const String tradeCopyProductGovernance =
      TradeComplianceRoutePaths.tradeCopyProductGovernance;
  static const String tradeCopyTargetMarketDefinition =
      TradeComplianceRoutePaths.tradeCopyTargetMarketDefinition;
  static String tradeCopyTargetMarketDefinitionForProduct(String productId) =>
      TradeComplianceRoutePaths.tradeCopyTargetMarketDefinitionForProduct(
        productId,
      );
  static const String tradeCopyClientMoneyProtection =
      TradeComplianceRoutePaths.tradeCopyClientMoneyProtection;
  static const String tradeCopyCassReconciliation =
      TradeComplianceRoutePaths.tradeCopyCassReconciliation;
  static const String tradeCopyInvestorCompensation =
      TradeComplianceRoutePaths.tradeCopyInvestorCompensation;
  static const String tradeCopyExAnteCosts =
      TradeComplianceRoutePaths.tradeCopyExAnteCosts;
  static const String tradeCopyRiyCalculator =
      TradeComplianceRoutePaths.tradeCopyRiyCalculator;
  static const String tradeCopyExPostCostsReport =
      TradeComplianceRoutePaths.tradeCopyExPostCostsReport;
  static const String tradeCopyKidGenerator =
      TradeComplianceRoutePaths.tradeCopyKidGenerator;
  static const String tradeCopyPerformanceScenarios =
      TradeComplianceRoutePaths.tradeCopyPerformanceScenarios;
  static const String tradeCopyRiskIndicatorExplainer =
      TradeComplianceRoutePaths.tradeCopyRiskIndicatorExplainer;
  static const String tradeCopyComplaintsHandling =
      TradeComplianceRoutePaths.tradeCopyComplaintsHandling;
  static const String tradeCopyComplaintSubmission =
      TradeComplianceRoutePaths.tradeCopyComplaintSubmission;
  static const String tradeCopyComplaintTrackingBase =
      TradeComplianceRoutePaths.tradeCopyComplaintTrackingBase;
  static String tradeCopyComplaintTracking(String complaintId) =>
      TradeComplianceRoutePaths.tradeCopyComplaintTracking(complaintId);
  static const String tradeCopyOmbudsmanReferral =
      TradeComplianceRoutePaths.tradeCopyOmbudsmanReferral;
  static const String tradeCopyAuditTrail =
      TradeComplianceRoutePaths.tradeCopyAuditTrail;
  static const String tradeCopyRegulatoryInspectionReady =
      TradeComplianceRoutePaths.tradeCopyRegulatoryInspectionReady;
  static const String settingsSecurity = ProfileRoutePaths.settingsSecurity;
  static const String tradeMargin = TradeRoutePaths.tradeMargin;
  static const String tradeMarginBtcusdt = TradeRoutePaths.tradeMarginBtcusdt;
  static const String tradeMarginAdvancedDemo =
      TradeTerminalRoutePaths.tradeMarginAdvancedDemo;
  static const String tradeMarginMarketDataAnalytics =
      TradeComplianceRoutePaths.tradeMarginMarketDataAnalytics;
  static const String tradeMarginHub = TradeRoutePaths.tradeMarginHub;
  static const String tradeMarginLiveMarketDataAnalytics =
      TradeComplianceRoutePaths.tradeMarginLiveMarketDataAnalytics;
  static const String tradeMarginAdvancedAnalytics =
      TradeTerminalRoutePaths.tradeMarginAdvancedAnalytics;
  static String tradeTrader(String traderId) =>
      TradeCopyRoutePaths.tradeTrader(traderId);

  // ==== DCA ====
  static const String dca = DcaRoutePaths.dca;
  static const String dcaPortfolioOptimizer =
      DcaRoutePaths.dcaPortfolioOptimizer;
  static const String dcaDynamicAmount = DcaRoutePaths.dcaDynamicAmount;
  static const String dcaRebalanceConfig = DcaRoutePaths.dcaRebalanceConfig;
  static const String dcaRebalanceDashboard =
      DcaRoutePaths.dcaRebalanceDashboard;
  static String dcaRebalanceEdit(String configId) =>
      DcaRoutePaths.dcaRebalanceEdit(configId);
  static String dcaRebalanceHistory(String configId) =>
      DcaRoutePaths.dcaRebalanceHistory(configId);
  static const String dcaScheduleConfig = DcaRoutePaths.dcaScheduleConfig;
  static const String dcaScheduleAnalytics = DcaRoutePaths.dcaScheduleAnalytics;
  static const String dcaBacktester = DcaRoutePaths.dcaBacktester;
  static const String dcaMultiAsset = DcaRoutePaths.dcaMultiAsset;
  static const String dcaPerformanceCompare =
      DcaRoutePaths.dcaPerformanceCompare;
  static const String dcaSmartRules = DcaRoutePaths.dcaSmartRules;

  // ==== ADMIN ====
  static const String admin = AdminRoutePaths.admin;
  static const String adminAnalytics = AdminRoutePaths.adminAnalytics;
  static const String adminAbtests = AdminRoutePaths.adminAbtests;
  static const String adminFunnels = AdminRoutePaths.adminFunnels;
  static const String adminSettings = AdminRoutePaths.adminSettings;

  // ==== LATE ADDITIONS — mixed features, added as single-route afterthoughts; check the path for the owning feature ====
  static const String profilePredictions = ProfileRoutePaths.profilePredictions;
  static const String rewards = UtilityRoutePaths.rewards;

  // ==== P2P ====
  static const String p2p = P2PRoutePaths.p2p;
  static const String p2pExpress = P2PRoutePaths.p2pExpress;
  static const String p2pExpressConfirm = P2PRoutePaths.p2pExpressConfirm;
  static String p2pOrder(String orderId) => P2PRoutePaths.p2pOrder(orderId);
  static String p2pOrderTimeline(String orderId) =>
      P2PRoutePaths.p2pOrderTimeline(orderId);
  static String p2pOrderRate(String orderId) =>
      P2PRoutePaths.p2pOrderRate(orderId);
  static String p2pOrderCancel(String orderId) =>
      P2PRoutePaths.p2pOrderCancel(orderId);
  static String p2pOrderProof(String orderId) =>
      P2PRoutePaths.p2pOrderProof(orderId);
  static String p2pChat(String orderId) => P2PRoutePaths.p2pChat(orderId);
  static String p2pDispute(String orderId) => P2PRoutePaths.p2pDispute(orderId);
  static String p2pDisputeDetail(String disputeId) =>
      P2PRoutePaths.p2pDisputeDetail(disputeId);
  static String p2pDisputeEvidence(String disputeId) =>
      P2PRoutePaths.p2pDisputeEvidence(disputeId);
  static String p2pDisputeResolution(String disputeId) =>
      P2PRoutePaths.p2pDisputeResolution(disputeId);
  static const String p2pDisputes = P2PRoutePaths.p2pDisputes;
  static String p2pAdAnalytics(String adId) =>
      P2PRoutePaths.p2pAdAnalytics(adId);
  static String p2pAd(String adId) => P2PRoutePaths.p2pAd(adId);
  static const String p2pMyAds = P2PRoutePaths.p2pMyAds;
  static const String p2pCreate = P2PRoutePaths.p2pCreate;
  static const String p2pMerchantApply = P2PRoutePaths.p2pMerchantApply;
  static const String p2pTradingLevel = P2PRoutePaths.p2pTradingLevel;
  static const String p2pReviews = P2PRoutePaths.p2pReviews;
  static const String p2pPaymentMethodAdd = P2PRoutePaths.p2pPaymentMethodAdd;
  static const String p2pPaymentMethods = P2PRoutePaths.p2pPaymentMethods;
  static String p2pPaymentMethodVerification(String methodId) =>
      P2PRoutePaths.p2pPaymentMethodVerification(methodId);
  static String p2pPaymentMethodOwnership(String methodId) =>
      P2PRoutePaths.p2pPaymentMethodOwnership(methodId);
  static const String p2pPaymentMethodCoolingPeriod =
      P2PRoutePaths.p2pPaymentMethodCoolingPeriod;
  static const String p2pPaymentMethodHistory =
      P2PRoutePaths.p2pPaymentMethodHistory;
  static const String p2pInsurance = P2PRoutePaths.p2pInsurance;
  static const String p2pInsuranceFundAlias =
      P2PRoutePaths.p2pInsuranceFundAlias;
  static const String p2pInsuranceCertificate =
      P2PRoutePaths.p2pInsuranceCertificate;
  static const String p2pInsuranceScore = P2PRoutePaths.p2pInsuranceScore;
  static const String p2pInsurancePolicy = P2PRoutePaths.p2pInsurancePolicy;
  static const String p2pContributionHistory =
      P2PRoutePaths.p2pContributionHistory;
  static String p2pClaim(String claimId) => P2PRoutePaths.p2pClaim(claimId);
  static const String p2pEscrowBalance = P2PRoutePaths.p2pEscrowBalance;
  static String p2pEscrow(String orderId) => P2PRoutePaths.p2pEscrow(orderId);
  static const String p2pKycRequirements = P2PRoutePaths.p2pKycRequirements;
  static const String p2pKycVerify = P2PRoutePaths.p2pKycVerify;
  static const String p2pKycStatus = P2PRoutePaths.p2pKycStatus;
  static const String p2pKycIdentity = P2PRoutePaths.p2pKycIdentity;
  static const String p2pKycAddress = P2PRoutePaths.p2pKycAddress;
  static const String p2pKycSelfie = P2PRoutePaths.p2pKycSelfie;
  static const String p2pKycVideo = P2PRoutePaths.p2pKycVideo;
  static const String p2pKycFaceMatch = P2PRoutePaths.p2pKycFaceMatch;
  static const String p2pSecurityCenter = P2PRoutePaths.p2pSecurityCenter;
  static const String p2pSecurity2fa = P2PRoutePaths.p2pSecurity2fa;
  static const String p2pSecurityDevices = P2PRoutePaths.p2pSecurityDevices;
  static const String p2pSecurityAntiPhishing =
      P2PRoutePaths.p2pSecurityAntiPhishing;
  static const String p2pSecurityLoginHistory =
      P2PRoutePaths.p2pSecurityLoginHistory;
  static const String p2pSecuritySuspiciousActivity =
      P2PRoutePaths.p2pSecuritySuspiciousActivity;
  static const String p2pSecurityWhitelist = P2PRoutePaths.p2pSecurityWhitelist;
  static const String settingsSecurityBiometric =
      ProfileRoutePaths.settingsSecurityBiometric;
  static const String settingsSecurityChangePassword =
      ProfileRoutePaths.settingsSecurityChangePassword;
  static String p2pMerchant(String merchantId) =>
      P2PRoutePaths.p2pMerchant(merchantId);
  static String p2pReport(String merchantId) =>
      P2PRoutePaths.p2pReport(merchantId);
  static const String p2pBlacklist = P2PRoutePaths.p2pBlacklist;
  static const String p2pBlacklistAdd = P2PRoutePaths.p2pBlacklistAdd;
  static const String p2pGuide = P2PRoutePaths.p2pGuide;
  static const String p2pSettings = P2PRoutePaths.p2pSettings;
  static const String p2pSettingsNotifications =
      P2PRoutePaths.p2pSettingsNotifications;
  static const String p2pE2EInfo = P2PRoutePaths.p2pE2EInfo;
  static const String p2pFraudPrevention = P2PRoutePaths.p2pFraudPrevention;
  static const String p2pWallet = P2PRoutePaths.p2pWallet;
  static const String p2pWalletTransfer = P2PRoutePaths.p2pWalletTransfer;
  static const String p2pWalletFundLockHistory =
      P2PRoutePaths.p2pWalletFundLockHistory;
  static const String p2pWalletHistory = P2PRoutePaths.p2pWalletHistory;
  static const String p2pLimits = P2PRoutePaths.p2pLimits;
  static const String p2pLimitsTracker = P2PRoutePaths.p2pLimitsTracker;
  static const String p2pComplianceOverview =
      P2PRoutePaths.p2pComplianceOverview;
  static const String p2pComplianceAmlScreening =
      P2PRoutePaths.p2pComplianceAmlScreening;
  static const String p2pComplianceSourceOfFunds =
      P2PRoutePaths.p2pComplianceSourceOfFunds;
  static const String p2pComplianceLargeTransaction =
      P2PRoutePaths.p2pComplianceLargeTransaction;
  static const String p2pComplianceRiskAssessment =
      P2PRoutePaths.p2pComplianceRiskAssessment;
  static const String p2pTaxReporting = P2PRoutePaths.p2pTaxReporting;
  static String p2pTaxReportDetailed(String year) =>
      P2PRoutePaths.p2pTaxReportDetailed(year);
  static const String p2pOrderBook = P2PRoutePaths.p2pOrderBook;
  static const String p2pDashboard = P2PRoutePaths.p2pDashboard;
  static const String p2pAchievements = P2PRoutePaths.p2pAchievements;
  static const String p2pMyOrders = P2PRoutePaths.p2pMyOrders;

  // ==== LATE ADDITIONS — mixed features, added as single-route afterthoughts; check the path for the owning feature ====
  static const String supportHelp = SupportRoutePaths.supportHelp;

  // ==== ARENA ====
  static const String arena = ArenaRoutePaths.arena;
  static const String arenaGuide = ArenaRoutePaths.arenaGuide;
  static const String arenaStudio = ArenaRoutePaths.arenaStudio;
  static const String arenaStudioSmartRules =
      ArenaRoutePaths.arenaStudioSmartRules;
  static const String arenaStudioPresets = ArenaRoutePaths.arenaStudioPresets;
  static const String arenaStudioGovernance =
      ArenaRoutePaths.arenaStudioGovernance;
  static const String arenaLeaderboard = ArenaRoutePaths.arenaLeaderboard;
  static const String arenaVerified = ArenaRoutePaths.arenaVerified;
  static const String arenaPoints = ArenaRoutePaths.arenaPoints;
  static const String arenaFlowMap = ArenaRoutePaths.arenaFlowMap;
  static const String arenaSafety = ArenaRoutePaths.arenaSafety;
  static const String arenaBlocked = ArenaRoutePaths.arenaBlocked;
  static const String arenaMyReports = ArenaRoutePaths.arenaMyReports;
  static const String arenaMy = ArenaRoutePaths.arenaMy;
  static const String arenaProduction = ArenaRoutePaths.arenaProduction;
  static const String arenaBridge = ArenaRoutePaths.arenaBridge;
  static const String arenaEcosystem = ArenaRoutePaths.arenaEcosystem;
  static String arenaReportCase(String caseId) =>
      ArenaRoutePaths.arenaReportCase(caseId);
  static String arenaChallenge(String challengeId) =>
      ArenaRoutePaths.arenaChallenge(challengeId);
  static String arenaJoin(String challengeId) =>
      ArenaRoutePaths.arenaJoin(challengeId);
  static const String arenaResolution = ArenaRoutePaths.arenaResolution;
  static const String arenaLedger = ArenaRoutePaths.arenaLedger;
  static String arenaLedgerEntry(String entryId) =>
      ArenaRoutePaths.arenaLedgerEntry(entryId);
  static String arenaMode(String modeId) => ArenaRoutePaths.arenaMode(modeId);
  static String arenaCreator(String creatorId) =>
      ArenaRoutePaths.arenaCreator(creatorId);
  static String arenaTrust(String userId) => ArenaRoutePaths.arenaTrust(userId);

  // ==== LATE ADDITIONS — mixed features, added as single-route afterthoughts; check the path for the owning feature ====
  static const String trade = TradeRoutePaths.trade;

  // ==== WALLET ====
  static const String wallet = WalletRoutePaths.wallet;
  static const String walletHistory = WalletRoutePaths.walletHistory;
  static const String walletDeposit = WalletRoutePaths.walletDeposit;
  static String walletDepositAsset(String asset) =>
      WalletRoutePaths.walletDepositAsset(asset);
  static const String walletWithdraw = WalletRoutePaths.walletWithdraw;
  static String walletWithdrawAsset(String asset) =>
      WalletRoutePaths.walletWithdrawAsset(asset);
  static String walletTransaction(String transactionId) =>
      WalletRoutePaths.walletTransaction(transactionId);
  static const String walletPortfolioAnalytics =
      WalletRoutePaths.walletPortfolioAnalytics;
  static const String walletAddressBook = WalletRoutePaths.walletAddressBook;
  static const String walletAddressBookAdd =
      WalletRoutePaths.walletAddressBookAdd;
  static const String walletBuyCrypto = WalletRoutePaths.walletBuyCrypto;
  static const String walletTransfer = WalletRoutePaths.walletTransfer;
  static String walletAsset(String assetId) =>
      WalletRoutePaths.walletAsset(assetId);
  static const String walletMultiManager = WalletRoutePaths.walletMultiManager;
  static const String walletGasOptimizer = WalletRoutePaths.walletGasOptimizer;
  static const String walletTokenApproval =
      WalletRoutePaths.walletTokenApproval;
  static const String walletHealthScore = WalletRoutePaths.walletHealthScore;
  static const String walletPendingDeposits =
      WalletRoutePaths.walletPendingDeposits;
  static const String walletLimits = WalletRoutePaths.walletLimits;
  static const String walletDustConverter =
      WalletRoutePaths.walletDustConverter;
  static const String walletNetworkStatus =
      WalletRoutePaths.walletNetworkStatus;

  // ==== PROFILE ====
  static const String profile = ProfileRoutePaths.profile;
  static const String profileEdit = ProfileRoutePaths.profileEdit;
  static const String profileKyc = ProfileRoutePaths.profileKyc;
  static const String profileSecurity = ProfileRoutePaths.profileSecurity;
  static const String profileVip = ProfileRoutePaths.profileVip;
  static const String profileApi = ProfileRoutePaths.profileApi;
  static const String profileApiCreate = ProfileRoutePaths.profileApiCreate;
  static const String profileDevices = ProfileRoutePaths.profileDevices;
  static const String profileSubAccounts = ProfileRoutePaths.profileSubAccounts;
  static const String profileSettings = ProfileRoutePaths.profileSettings;
  static const String profileActivity = ProfileRoutePaths.profileActivity;
  static const String profileArena = ProfileRoutePaths.profileArena;

  // ==== ONBOARDING ====
  static const String onboarding = AuthRoutePaths.onboarding;

  // ==== SYSTEM GATE (GĐ4-F1 kill-switch) ====
  static const String maintenanceGate = UtilityRoutePaths.maintenanceGate;
  static const String forceUpdateGate = UtilityRoutePaths.forceUpdateGate;
}
