part of 'app_route_contracts.dart';

final class AppRouteNames {
  const AppRouteNames._();

  // ==== AUTH ====
  static const String sc001Login = AuthRouteNames.sc001Login;
  static const String sc002Register = AuthRouteNames.sc002Register;
  static const String sc003Otp = AuthRouteNames.sc003Otp;
  static const String sc004TwoFaSetup = AuthRouteNames.sc004TwoFaSetup;
  static const String sc005ForgotPassword = AuthRouteNames.sc005ForgotPassword;
  static const String sc006ResetPassword = AuthRouteNames.sc006ResetPassword;

  // ==== HOME ====
  static const String sc007Home = HomeRouteNames.sc007Home;

  // ==== MARKETS ====
  static const String sc008MarketList = MarketsRouteNames.sc008MarketList;
  static const String sc009MarketOverview =
      MarketsRouteNames.sc009MarketOverview;
  static const String sc010MarketMovers = MarketsRouteNames.sc010MarketMovers;
  static const String sc011MarketSectors = MarketsRouteNames.sc011MarketSectors;
  static const String sc012Watchlist = MarketsRouteNames.sc012Watchlist;
  static const String sc013MarketHeatmap = MarketsRouteNames.sc013MarketHeatmap;
  static const String sc014PriceAlerts = MarketsRouteNames.sc014PriceAlerts;
  static const String sc015MarketScreener =
      MarketsRouteNames.sc015MarketScreener;
  static const String sc016ComparisonTool =
      MarketsRouteNames.sc016ComparisonTool;
  static const String sc017MarketCalendar =
      MarketsRouteNames.sc017MarketCalendar;
  static const String sc018DerivativesOverview =
      MarketsRouteNames.sc018DerivativesOverview;
  static const String sc019MarketDepth = MarketsRouteNames.sc019MarketDepth;
  static const String sc020SocialSentiment =
      MarketsRouteNames.sc020SocialSentiment;
  static const String sc021PortfolioTracker =
      MarketsRouteNames.sc021PortfolioTracker;
  static const String sc022MarketNews = MarketsRouteNames.sc022MarketNews;
  static const String sc023AdvancedCharts =
      MarketsRouteNames.sc023AdvancedCharts;
  static const String sc024TokenUnlocks = MarketsRouteNames.sc024TokenUnlocks;
  static const String sc025SocialSignals = MarketsRouteNames.sc025SocialSignals;
  static const String sc026MarketCorrelations =
      MarketsRouteNames.sc026MarketCorrelations;

  // ==== PREDICTIONS ====
  static const String sc027PredictionsHome =
      PredictionsRouteNames.sc027PredictionsHome;
  static const String sc028PredictionsSearch =
      PredictionsRouteNames.sc028PredictionsSearch;
  static const String sc029PredictionsBreaking =
      PredictionsRouteNames.sc029PredictionsBreaking;
  static const String sc030PredictionEventDetail =
      PredictionsRouteNames.sc030PredictionEventDetail;
  static const String sc031PredictionsPortfolio =
      PredictionsRouteNames.sc031PredictionsPortfolio;
  static const String sc032PredictionsRewards =
      PredictionsRouteNames.sc032PredictionsRewards;
  static const String sc033PredictionsLeaderboard =
      PredictionsRouteNames.sc033PredictionsLeaderboard;
  static const String sc034PredictionsGlobalActivity =
      PredictionsRouteNames.sc034PredictionsGlobalActivity;
  static const String sc035PredictionOrderReceipt =
      PredictionsRouteNames.sc035PredictionOrderReceipt;
  static const String sc036PredictionRiskCalculator =
      PredictionsRouteNames.sc036PredictionRiskCalculator;
  static const String sc037PredictionMarketMaker =
      PredictionsRouteNames.sc037PredictionMarketMaker;
  static const String sc038PredictionPortfolioAnalyzer =
      PredictionsRouteNames.sc038PredictionPortfolioAnalyzer;
  static const String sc039PredictionEventCalendar =
      PredictionsRouteNames.sc039PredictionEventCalendar;
  static const String sc040PredictionSocial =
      PredictionsRouteNames.sc040PredictionSocial;
  static const String sc041PredictionAdvancedChart =
      PredictionsRouteNames.sc041PredictionAdvancedChart;
  static const String sc042PredictionTournaments =
      PredictionsRouteNames.sc042PredictionTournaments;
  static const String sc043PredictionDataIntegration =
      PredictionsRouteNames.sc043PredictionDataIntegration;

  // ==== MARKETS (pair/token detail) ====
  static const String sc044PairDetail = MarketsRouteNames.sc044PairDetail;
  static const String sc045TokenInfo = MarketsRouteNames.sc045TokenInfo;
  static const String sc046PairDepth = MarketsRouteNames.sc046PairDepth;

  // ==== NEWS ====
  static const String sc047News = HomeRouteNames.sc047News;

  // ==== TRADE FAMILY (trade, trade_bots, trade_compliance, trade_copy, trade_terminal — heavily interleaved by historical rollout order, not split further) ====
  static const String sc048Trade = TradeRouteNames.sc048Trade;
  static const String sc049TradePair = TradeRouteNames.sc049TradePair;
  static const String sc050OrdersHistory = TradeRouteNames.sc050OrdersHistory;
  static const String sc051OrderReceipt = TradeRouteNames.sc051OrderReceipt;
  static const String sc052TradeSettings = TradeRouteNames.sc052TradeSettings;
  static const String sc053PositionDashboard =
      TradeRouteNames.sc053PositionDashboard;
  static const String sc054TradeHistoryExport =
      TradeRouteNames.sc054TradeHistoryExport;
  static const String sc055AdvancedChart =
      TradeTerminalRouteNames.sc055AdvancedChart;
  static const String sc056Convert = TradeRouteNames.sc056Convert;
  static const String sc057Futures = TradeRouteNames.sc057Futures;
  static const String sc058Leverage = TradeRouteNames.sc058Leverage;
  static const String sc059TradingBots = TradeBotsRouteNames.sc059TradingBots;
  static const String sc060RiskManagement =
      TradeTerminalRouteNames.sc060RiskManagement;
  static const String sc061ExecutionQuality =
      TradeTerminalRouteNames.sc061ExecutionQuality;
  static const String sc062AdvancedTools =
      TradeTerminalRouteNames.sc062AdvancedTools;
  static const String sc063CopyTrading = TradeCopyRouteNames.sc063CopyTrading;
  static const String sc065CopyEducation =
      TradeCopyRouteNames.sc065CopyEducation;
  static const String sc066ActiveCopies = TradeCopyRouteNames.sc066ActiveCopies;
  static const String sc067CopySettings = TradeCopyRouteNames.sc067CopySettings;
  static const String sc068CopyNotifications =
      TradeCopyRouteNames.sc068CopyNotifications;
  static const String sc069ProviderApplication =
      TradeCopyRouteNames.sc069ProviderApplication;
  static const String sc070CopyProviderDetail =
      TradeCopyRouteNames.sc070CopyProviderDetail;
  static const String sc071PreCopyAssessment =
      TradeCopyRouteNames.sc071PreCopyAssessment;
  static const String sc072CopyConfiguration =
      TradeCopyRouteNames.sc072CopyConfiguration;
  static const String sc073CopyConfirmation =
      TradeCopyRouteNames.sc073CopyConfirmation;
  static const String sc074CopyPerformance =
      TradeCopyRouteNames.sc074CopyPerformance;
  static const String sc075PerformanceAttribution =
      TradeCopyRouteNames.sc075PerformanceAttribution;
  static const String sc076ProviderComparison =
      TradeCopyRouteNames.sc076ProviderComparison;
  static const String sc077CopyAuditLog = TradeCopyRouteNames.sc077CopyAuditLog;
  static const String sc078PortfolioRiskAnalysis =
      TradeCopyRouteNames.sc078PortfolioRiskAnalysis;
  static const String sc079ProviderLeaderboard =
      TradeCopyRouteNames.sc079ProviderLeaderboard;
  static const String sc080SafetyEducation =
      TradeCopyRouteNames.sc080SafetyEducation;
  static const String sc081ProviderGovernance =
      TradeCopyRouteNames.sc081ProviderGovernance;
  static const String sc082DisputeResolution =
      TradeCopyRouteNames.sc082DisputeResolution;
  static const String sc083CopySafetyCenter =
      TradeCopyRouteNames.sc083CopySafetyCenter;
  static const String sc084RegulatoryDisclosures =
      TradeComplianceRouteNames.sc084RegulatoryDisclosures;
  static const String sc085MarginTrading = TradeRouteNames.sc085MarginTrading;
  static const String sc086MarginTradingPair =
      TradeRouteNames.sc086MarginTradingPair;
  static const String sc087TraderProfile =
      TradeCopyRouteNames.sc087TraderProfile;
  static const String sc088AdvancedTradingDemo =
      TradeTerminalRouteNames.sc088AdvancedTradingDemo;
  static const String sc089MarketDataAnalytics =
      TradeComplianceRouteNames.sc089MarketDataAnalytics;
  static const String sc090MarginTradingHub =
      TradeRouteNames.sc090MarginTradingHub;
  static const String sc091LiveMarketDataAnalytics =
      TradeComplianceRouteNames.sc091LiveMarketDataAnalytics;
  static const String sc092AdvancedAnalytics =
      TradeTerminalRouteNames.sc092AdvancedAnalytics;
  static const String sc093TransactionReporting =
      TradeComplianceRouteNames.sc093TransactionReporting;
  static const String sc094RegulatoryReportsDashboard =
      TradeComplianceRouteNames.sc094RegulatoryReportsDashboard;
  static const String sc095ArmIntegrationStatus =
      TradeComplianceRouteNames.sc095ArmIntegrationStatus;
  static const String sc096BestExecutionReports =
      TradeComplianceRouteNames.sc096BestExecutionReports;
  static const String sc097ExecutionVenueAnalysis =
      TradeComplianceRouteNames.sc097ExecutionVenueAnalysis;
  static const String sc098SlippageMonitoring =
      TradeComplianceRouteNames.sc098SlippageMonitoring;
  static const String sc099ClientCategorization =
      TradeComplianceRouteNames.sc099ClientCategorization;
  static const String sc100ProductGovernance =
      TradeComplianceRouteNames.sc100ProductGovernance;
  static const String sc101TargetMarketDefinition =
      TradeComplianceRouteNames.sc101TargetMarketDefinition;
  static const String sc102ClientMoneyProtection =
      TradeComplianceRouteNames.sc102ClientMoneyProtection;
  static const String sc103CassReconciliation =
      TradeComplianceRouteNames.sc103CassReconciliation;
  static const String sc104InvestorCompensation =
      TradeComplianceRouteNames.sc104InvestorCompensation;
  static const String sc105ExAnteCosts =
      TradeComplianceRouteNames.sc105ExAnteCosts;
  static const String sc106RiyCalculator =
      TradeComplianceRouteNames.sc106RiyCalculator;
  static const String sc107ExPostCostsReport =
      TradeComplianceRouteNames.sc107ExPostCostsReport;
  static const String sc108KidGenerator =
      TradeComplianceRouteNames.sc108KidGenerator;
  static const String sc109PerformanceScenarios =
      TradeComplianceRouteNames.sc109PerformanceScenarios;
  static const String sc110RiskIndicatorExplainer =
      TradeComplianceRouteNames.sc110RiskIndicatorExplainer;
  static const String sc111ComplaintsHandling =
      TradeComplianceRouteNames.sc111ComplaintsHandling;
  static const String sc112ComplaintSubmission =
      TradeComplianceRouteNames.sc112ComplaintSubmission;
  static const String sc113ComplaintTracking =
      TradeComplianceRouteNames.sc113ComplaintTracking;
  static const String sc114OmbudsmanReferral =
      TradeComplianceRouteNames.sc114OmbudsmanReferral;
  static const String sc115AuditTrail =
      TradeComplianceRouteNames.sc115AuditTrail;
  static const String sc116RegulatoryInspectionReady =
      TradeComplianceRouteNames.sc116RegulatoryInspectionReady;
  static const String sc117BotTermsOfService =
      TradeBotsRouteNames.sc117BotTermsOfService;
  static const String sc118BotRiskDisclosure =
      TradeBotsRouteNames.sc118BotRiskDisclosure;
  static const String sc119BotSuitabilityAssessment =
      TradeBotsRouteNames.sc119BotSuitabilityAssessment;
  static const String sc120BotRiskDashboard =
      TradeBotsRouteNames.sc120BotRiskDashboard;
  static const String sc121BotEmergencyStop =
      TradeBotsRouteNames.sc121BotEmergencyStop;
  static const String sc122BotSecuritySettings =
      TradeBotsRouteNames.sc122BotSecuritySettings;
  static const String sc123BotHistory = TradeBotsRouteNames.sc123BotHistory;
  static const String sc124BotPerformanceAnalytics =
      TradeBotsRouteNames.sc124BotPerformanceAnalytics;
  static const String sc125BotBacktesting =
      TradeBotsRouteNames.sc125BotBacktesting;
  static const String sc126BotStrategyCompare =
      TradeBotsRouteNames.sc126BotStrategyCompare;
  static const String sc127BotOptimization =
      TradeBotsRouteNames.sc127BotOptimization;
  static const String sc128BotPortfolioDashboard =
      TradeBotsRouteNames.sc128BotPortfolioDashboard;
  static const String sc129BotDrawdownAnalyzer =
      TradeBotsRouteNames.sc129BotDrawdownAnalyzer;
  static const String sc130BotEquityCurve =
      TradeBotsRouteNames.sc130BotEquityCurve;
  static const String sc131BotGuide = TradeBotsRouteNames.sc131BotGuide;
  static const String sc132BotFaq = TradeBotsRouteNames.sc132BotFaq;
  static const String sc133BotTaxReporting =
      TradeBotsRouteNames.sc133BotTaxReporting;
  static const String sc134BotApiDocumentation =
      TradeBotsRouteNames.sc134BotApiDocumentation;

  // ==== WALLET ====
  static const String sc135Wallet = WalletRouteNames.sc135Wallet;
  static const String sc136TxHistory = WalletRouteNames.sc136TxHistory;
  static const String sc137Deposit = WalletRouteNames.sc137Deposit;
  static const String sc138DepositUsdt = WalletRouteNames.sc138DepositUsdt;
  static const String sc139Withdraw = WalletRouteNames.sc139Withdraw;
  static const String sc140WithdrawUsdt = WalletRouteNames.sc140WithdrawUsdt;
  static const String sc141TransactionDetail =
      WalletRouteNames.sc141TransactionDetail;
  static const String sc142PortfolioAnalytics =
      WalletRouteNames.sc142PortfolioAnalytics;
  static const String sc143AddressAdd = WalletRouteNames.sc143AddressAdd;
  static const String sc144AddressBook = WalletRouteNames.sc144AddressBook;
  static const String sc145BuyCrypto = WalletRouteNames.sc145BuyCrypto;
  static const String sc146Transfer = WalletRouteNames.sc146Transfer;
  static const String sc147AssetDetail = WalletRouteNames.sc147AssetDetail;
  static const String sc148MultiManager = WalletRouteNames.sc148MultiManager;
  static const String sc149GasOptimizer = WalletRouteNames.sc149GasOptimizer;
  static const String sc150TokenApproval = WalletRouteNames.sc150TokenApproval;
  static const String sc151HealthScore = WalletRouteNames.sc151HealthScore;
  static const String sc152PendingDeposits =
      WalletRouteNames.sc152PendingDeposits;
  static const String sc153WithdrawLimits =
      WalletRouteNames.sc153WithdrawLimits;
  static const String sc154DustConverter = WalletRouteNames.sc154DustConverter;
  static const String sc155NetworkStatus = WalletRouteNames.sc155NetworkStatus;

  // ==== PROFILE ====
  static const String sc156Profile = ProfileRouteNames.sc156Profile;
  static const String sc157EditProfile = ProfileRouteNames.sc157EditProfile;
  static const String sc158Security = ProfileRouteNames.sc158Security;
  static const String sc159Kyc = ProfileRouteNames.sc159Kyc;
  static const String sc160Settings = ProfileRouteNames.sc160Settings;
  static const String sc161ActivityLog = ProfileRouteNames.sc161ActivityLog;
  static const String sc162ApiKeyCreate = ProfileRouteNames.sc162ApiKeyCreate;
  static const String sc163ApiManagement = ProfileRouteNames.sc163ApiManagement;
  static const String sc164Vip = ProfileRouteNames.sc164Vip;
  static const String sc165DeviceManagement =
      ProfileRouteNames.sc165DeviceManagement;
  static const String sc166SubAccount = ProfileRouteNames.sc166SubAccount;
  static const String sc167ProfilePredictions =
      ProfileRouteNames.sc167ProfilePredictions;
  static const String sc168MyArena = ProfileRouteNames.sc168MyArena;

  // ==== DCA ====
  static const String sc169Dca = DcaRouteNames.sc169Dca;
  static const String sc170DcaRebalanceConfig =
      DcaRouteNames.sc170DcaRebalanceConfig;
  static const String sc171DcaRebalanceDashboard =
      DcaRouteNames.sc171DcaRebalanceDashboard;
  static const String sc172DcaScheduleConfig =
      DcaRouteNames.sc172DcaScheduleConfig;
  static const String sc173DcaScheduleAnalytics =
      DcaRouteNames.sc173DcaScheduleAnalytics;
  static const String sc174DcaPortfolioOptimizer =
      DcaRouteNames.sc174DcaPortfolioOptimizer;
  static const String sc175DcaDynamicAmount =
      DcaRouteNames.sc175DcaDynamicAmount;
  static const String sc176DcaBacktester = DcaRouteNames.sc176DcaBacktester;
  static const String sc177DcaMultiAsset = DcaRouteNames.sc177DcaMultiAsset;
  static const String sc178DcaPerformanceCompare =
      DcaRouteNames.sc178DcaPerformanceCompare;
  static const String sc179DcaSmartRules = DcaRouteNames.sc179DcaSmartRules;

  // ==== ADMIN ====
  static const String sc180AdminHome = AdminRouteNames.sc180AdminHome;
  static const String sc181AnalyticsDashboard =
      AdminRouteNames.sc181AnalyticsDashboard;
  static const String sc182AbTestDashboard =
      AdminRouteNames.sc182AbTestDashboard;
  static const String sc183FunnelDashboard =
      AdminRouteNames.sc183FunnelDashboard;

  // ==== ARENA ====
  static const String sc184ArenaHome = ArenaRouteNames.sc184ArenaHome;
  static const String sc185ArenaStudio = ArenaRouteNames.sc185ArenaStudio;
  static const String sc186ArenaSmartRules =
      ArenaRouteNames.sc186ArenaSmartRules;
  static const String sc187ArenaPresetLibrary =
      ArenaRouteNames.sc187ArenaPresetLibrary;
  static const String sc188ArenaGovernanceGate =
      ArenaRouteNames.sc188ArenaGovernanceGate;
  static const String sc189ArenaModeDetail =
      ArenaRouteNames.sc189ArenaModeDetail;
  static const String sc190ArenaChallengeDetail =
      ArenaRouteNames.sc190ArenaChallengeDetail;
  static const String sc191ArenaJoin = ArenaRouteNames.sc191ArenaJoin;
  static const String sc192ArenaResolutionCenter =
      ArenaRouteNames.sc192ArenaResolutionCenter;
  static const String sc193ArenaCreator = ArenaRouteNames.sc193ArenaCreator;
  static const String sc194ArenaLeaderboard =
      ArenaRouteNames.sc194ArenaLeaderboard;
  static const String sc195VerifiedChallenges =
      ArenaRouteNames.sc195VerifiedChallenges;
  static const String sc196ArenaPoints = ArenaRouteNames.sc196ArenaPoints;
  static const String sc197ArenaFlowMap = ArenaRouteNames.sc197ArenaFlowMap;
  static const String sc198ArenaSafetyCenter =
      ArenaRouteNames.sc198ArenaSafetyCenter;
  static const String sc199ArenaTrustBreakdown =
      ArenaRouteNames.sc199ArenaTrustBreakdown;
  static const String sc200ArenaPointsEntryDetail =
      ArenaRouteNames.sc200ArenaPointsEntryDetail;
  static const String sc201ArenaPointsLedger =
      ArenaRouteNames.sc201ArenaPointsLedger;
  static const String sc202ArenaReportCase =
      ArenaRouteNames.sc202ArenaReportCase;
  static const String sc203ArenaBlockedUsers =
      ArenaRouteNames.sc203ArenaBlockedUsers;
  static const String sc204MyArenaReports = ArenaRouteNames.sc204MyArenaReports;
  static const String sc205MyArena = ArenaRouteNames.sc205MyArena;
  static const String sc206ArenaProductionReady =
      ArenaRouteNames.sc206ArenaProductionReady;
  static const String sc207ArenaPredictionBridgeFoundation =
      ArenaRouteNames.sc207ArenaPredictionBridgeFoundation;
  static const String sc208ConnectedEcosystemProduction =
      ArenaRouteNames.sc208ConnectedEcosystemProduction;
  static const String sc209ArenaGuide = ArenaRouteNames.sc209ArenaGuide;

  // ==== P2P ====
  static const String sc210P2PExpressConfirm =
      P2PRouteNames.sc210P2PExpressConfirm;
  static const String sc211P2PExpress = P2PRouteNames.sc211P2PExpress;
  static const String sc212P2POrderTimeline =
      P2PRouteNames.sc212P2POrderTimeline;
  static const String sc213P2POrderRate = P2PRouteNames.sc213P2POrderRate;
  static const String sc214P2POrderCancel = P2PRouteNames.sc214P2POrderCancel;
  static const String sc215P2POrderProof = P2PRouteNames.sc215P2POrderProof;
  static const String sc216P2POrder = P2PRouteNames.sc216P2POrder;
  static const String sc217P2PChat = P2PRouteNames.sc217P2PChat;
  static const String sc218P2PDisputeDetail =
      P2PRouteNames.sc218P2PDisputeDetail;
  static const String sc219P2PDisputeEvidence =
      P2PRouteNames.sc219P2PDisputeEvidence;
  static const String sc220P2PDisputeResolution =
      P2PRouteNames.sc220P2PDisputeResolution;
  static const String sc221P2PDispute = P2PRouteNames.sc221P2PDispute;
  static const String sc222P2PDisputes = P2PRouteNames.sc222P2PDisputes;
  static const String sc223P2PAdAnalytics = P2PRouteNames.sc223P2PAdAnalytics;
  static const String sc224P2PAdDetail = P2PRouteNames.sc224P2PAdDetail;
  static const String sc225P2PMyAds = P2PRouteNames.sc225P2PMyAds;
  static const String sc226P2PCreateAd = P2PRouteNames.sc226P2PCreateAd;
  static const String sc227P2PMerchantApply =
      P2PRouteNames.sc227P2PMerchantApply;
  static const String sc228P2PMerchantProfile =
      P2PRouteNames.sc228P2PMerchantProfile;
  static const String sc229P2PReportMerchant =
      P2PRouteNames.sc229P2PReportMerchant;
  static const String sc230P2PTradingLevel = P2PRouteNames.sc230P2PTradingLevel;
  static const String sc231P2PReviews = P2PRouteNames.sc231P2PReviews;
  static const String sc232P2PPaymentMethodAdd =
      P2PRouteNames.sc232P2PPaymentMethodAdd;
  static const String sc233P2PPaymentMethodVerification =
      P2PRouteNames.sc233P2PPaymentMethodVerification;
  static const String sc234P2PPaymentMethodOwnership =
      P2PRouteNames.sc234P2PPaymentMethodOwnership;
  static const String sc235P2PPaymentMethodCoolingPeriod =
      P2PRouteNames.sc235P2PPaymentMethodCoolingPeriod;
  static const String sc236P2PPaymentMethodHistory =
      P2PRouteNames.sc236P2PPaymentMethodHistory;
  static const String sc237P2PPaymentMethods =
      P2PRouteNames.sc237P2PPaymentMethods;
  static const String sc238P2PInsuranceFund =
      P2PRouteNames.sc238P2PInsuranceFund;
  static const String sc239P2PInsuranceCertificate =
      P2PRouteNames.sc239P2PInsuranceCertificate;
  static const String sc240P2PInsuranceScore =
      P2PRouteNames.sc240P2PInsuranceScore;
  static const String sc241P2PInsurancePolicy =
      P2PRouteNames.sc241P2PInsurancePolicy;
  static const String sc242P2PContributionHistory =
      P2PRouteNames.sc242P2PContributionHistory;
  static const String sc243P2PClaimDetail = P2PRouteNames.sc243P2PClaimDetail;
  static const String sc244P2PInsuranceFundAlias =
      P2PRouteNames.sc244P2PInsuranceFundAlias;
  static const String sc245P2PEscrowBalance =
      P2PRouteNames.sc245P2PEscrowBalance;
  static const String sc246P2PEscrowDetail = P2PRouteNames.sc246P2PEscrowDetail;
  static const String sc247P2PKycRequirements =
      P2PRouteNames.sc247P2PKycRequirements;
  static const String sc248P2PKycStatus = P2PRouteNames.sc248P2PKycStatus;
  static const String sc249P2PIdentityVerification =
      P2PRouteNames.sc249P2PIdentityVerification;
  static const String sc250P2PAddressProof = P2PRouteNames.sc250P2PAddressProof;
  static const String sc251P2PSelfieVerification =
      P2PRouteNames.sc251P2PSelfieVerification;
  static const String sc252P2PVideoVerification =
      P2PRouteNames.sc252P2PVideoVerification;
  static const String sc253P2PSecurityCenter =
      P2PRouteNames.sc253P2PSecurityCenter;
  static const String sc254P2P2FASettings = P2PRouteNames.sc254P2P2FASettings;
  static const String sc255P2PDeviceManagement =
      P2PRouteNames.sc255P2PDeviceManagement;
  static const String sc256P2PAntiPhishingCode =
      P2PRouteNames.sc256P2PAntiPhishingCode;
  static const String sc257P2PLoginHistory = P2PRouteNames.sc257P2PLoginHistory;
  static const String sc258P2PSuspiciousActivity =
      P2PRouteNames.sc258P2PSuspiciousActivity;
  static const String sc259P2PE2EInfo = P2PRouteNames.sc259P2PE2EInfo;
  static const String sc260P2PFraudPrevention =
      P2PRouteNames.sc260P2PFraudPrevention;
  static const String sc261P2PWalletTransfer =
      P2PRouteNames.sc261P2PWalletTransfer;
  static const String sc262P2PFundLockHistory =
      P2PRouteNames.sc262P2PFundLockHistory;
  static const String sc263P2PWalletHistoryAlias =
      P2PRouteNames.sc263P2PWalletHistoryAlias;
  static const String sc264P2PWallet = P2PRouteNames.sc264P2PWallet;
  static const String sc265P2PLimitTracker = P2PRouteNames.sc265P2PLimitTracker;
  static const String sc266P2PTransactionLimits =
      P2PRouteNames.sc266P2PTransactionLimits;
  static const String sc267P2PComplianceOverview =
      P2PRouteNames.sc267P2PComplianceOverview;
  static const String sc268P2PAmlScreening = P2PRouteNames.sc268P2PAmlScreening;
  static const String sc269P2PSourceOfFunds =
      P2PRouteNames.sc269P2PSourceOfFunds;
  static const String sc270P2PLargeTransaction =
      P2PRouteNames.sc270P2PLargeTransaction;
  static const String sc271P2PRiskAssessment =
      P2PRouteNames.sc271P2PRiskAssessment;
  static const String sc272P2PTaxReporting = P2PRouteNames.sc272P2PTaxReporting;
  static const String sc273P2POrderBook = P2PRouteNames.sc273P2POrderBook;
  static const String sc274P2PDashboard = P2PRouteNames.sc274P2PDashboard;
  static const String sc275P2PAchievements = P2PRouteNames.sc275P2PAchievements;
  static const String sc276P2PBlacklistAdd = P2PRouteNames.sc276P2PBlacklistAdd;
  static const String sc277P2PBlacklist = P2PRouteNames.sc277P2PBlacklist;
  static const String sc278P2PNotificationsSettings =
      P2PRouteNames.sc278P2PNotificationsSettings;
  static const String sc279P2PSettings = P2PRouteNames.sc279P2PSettings;
  static const String sc280P2PGuide = P2PRouteNames.sc280P2PGuide;
  static const String sc281P2PMyOrders = P2PRouteNames.sc281P2PMyOrders;
  static const String sc282P2PHome = P2PRouteNames.sc282P2PHome;

  // ==== DISCOVERY ====
  static const String sc283UnifiedSearch = UtilityRouteNames.sc283UnifiedSearch;
  static const String sc284TopicHub = UtilityRouteNames.sc284TopicHub;
  static const String sc285TopicCrypto = UtilityRouteNames.sc285TopicCrypto;

  // ==== REFERRAL ====
  static const String sc286ReferralHistory =
      UtilityRouteNames.sc286ReferralHistory;
  static const String sc287ReferralRewards =
      UtilityRouteNames.sc287ReferralRewards;
  static const String sc288ReferralRules = UtilityRouteNames.sc288ReferralRules;
  static const String sc289ReferralFriendDetail =
      UtilityRouteNames.sc289ReferralFriendDetail;
  static const String sc290ReferralHome = UtilityRouteNames.sc290ReferralHome;

  // ==== NOTIFICATIONS ====
  static const String sc291Notifications = UtilityRouteNames.sc291Notifications;

  // ==== SUPPORT ====
  static const String sc292HelpCenter = SupportRouteNames.sc292HelpCenter;
  static const String sc293Announcements = SupportRouteNames.sc293Announcements;
  static const String sc294Support = SupportRouteNames.sc294Support;

  // ==== LAUNCHPAD ====
  static const String sc295Launchpad = LaunchpadRouteNames.sc295Launchpad;
  static const String sc296LaunchpadPortfolio =
      LaunchpadRouteNames.sc296LaunchpadPortfolio;
  static const String sc297LaunchpadPerformance =
      LaunchpadRouteNames.sc297LaunchpadPerformance;
  static const String sc298LaunchpadStaking =
      LaunchpadRouteNames.sc298LaunchpadStaking;
  static const String sc299LaunchpadIdoBridge =
      LaunchpadRouteNames.sc299LaunchpadIdoBridge;
  static const String sc300LaunchpadContract =
      LaunchpadRouteNames.sc300LaunchpadContract;
  static const String sc301LaunchpadReceipt =
      LaunchpadRouteNames.sc301LaunchpadReceipt;
  static const String sc302LaunchpadClaimReceipt =
      LaunchpadRouteNames.sc302LaunchpadClaimReceipt;
  static const String sc303LaunchpadBridgeOrder =
      LaunchpadRouteNames.sc303LaunchpadBridgeOrder;
  static const String sc304LaunchpadBatchClaim =
      LaunchpadRouteNames.sc304LaunchpadBatchClaim;
  static const String sc305LaunchpadBridgeCompare =
      LaunchpadRouteNames.sc305LaunchpadBridgeCompare;
  static const String sc306LaunchpadNotifSound =
      LaunchpadRouteNames.sc306LaunchpadNotifSound;
  static const String sc307LaunchpadEventLog =
      LaunchpadRouteNames.sc307LaunchpadEventLog;
  static const String sc308LaunchpadAbiDiff =
      LaunchpadRouteNames.sc308LaunchpadAbiDiff;
  static const String sc309LaunchpadAddressBook =
      LaunchpadRouteNames.sc309LaunchpadAddressBook;
  static const String sc310LaunchpadWebhooks =
      LaunchpadRouteNames.sc310LaunchpadWebhooks;
  static const String sc311LaunchpadGasTracker =
      LaunchpadRouteNames.sc311LaunchpadGasTracker;
  static const String sc312LaunchpadRebalance =
      LaunchpadRouteNames.sc312LaunchpadRebalance;
  static const String sc313LaunchpadMultisig =
      LaunchpadRouteNames.sc313LaunchpadMultisig;
  static const String sc314LaunchpadSwapAggregator =
      LaunchpadRouteNames.sc314LaunchpadSwapAggregator;
  static const String sc315LaunchpadLimitOrders =
      LaunchpadRouteNames.sc315LaunchpadLimitOrders;
  static const String sc316LaunchpadDcaBuilder =
      LaunchpadRouteNames.sc316LaunchpadDcaBuilder;
  static const String sc317LaunchpadRiskAnalytics =
      LaunchpadRouteNames.sc317LaunchpadRiskAnalytics;
  static const String sc318LaunchpadDetail =
      LaunchpadRouteNames.sc318LaunchpadDetail;

  // ==== REWARDS ====
  static const String sc319RewardsHub = UtilityRouteNames.sc319RewardsHub;

  // ==== CROSS_MODULE ====
  static const String sc320EnterpriseStates =
      UtilityRouteNames.sc320EnterpriseStates;
  static const String sc321UnifiedPortfolio =
      UtilityRouteNames.sc321UnifiedPortfolio;
  static const String sc322CrossModuleAnalytics =
      UtilityRouteNames.sc322CrossModuleAnalytics;
  static const String sc323SmartAlertCenter =
      UtilityRouteNames.sc323SmartAlertCenter;
  static const String sc324TaxReportCenter =
      UtilityRouteNames.sc324TaxReportCenter;

  // ==== DEV ====
  static const String sc325RouteChecker = UtilityRouteNames.sc325RouteChecker;
  static const String sc326PerformanceMonitor =
      UtilityRouteNames.sc326PerformanceMonitor;
  static const String sc398MissingScreensShowcase =
      UtilityRouteNames.sc398MissingScreensShowcase;
  static const String sc399DesignSystem = UtilityRouteNames.sc399DesignSystem;
  static const String sc400DcaOverviewDemo =
      UtilityRouteNames.sc400DcaOverviewDemo;
  static const String sc401CopyTradingCardDemo =
      TradeCopyRouteNames.sc401CopyTradingCardDemo;

  // ==== EARN (staking + savings) ====
  static const String sc327StakingEarn = EarnRouteNames.sc327StakingEarn;
  static const String sc328StakingEarnStaking =
      EarnRouteNames.sc328StakingEarnStaking;
  static const String sc329Savings = EarnRouteNames.sc329Savings;
  static const String sc330SavingsProductDetail =
      EarnRouteNames.sc330SavingsProductDetail;
  static const String sc331SavingsRedeem = EarnRouteNames.sc331SavingsRedeem;
  static const String sc332SavingsReceipt = EarnRouteNames.sc332SavingsReceipt;
  static const String sc333SavingsPortfolio =
      EarnRouteNames.sc333SavingsPortfolio;
  static const String sc334SavingsHistory = EarnRouteNames.sc334SavingsHistory;
  static const String sc335SavingsGuide = EarnRouteNames.sc335SavingsGuide;
  static const String sc336SavingsFAQ = EarnRouteNames.sc336SavingsFAQ;
  static const String sc337SavingsNotifications =
      EarnRouteNames.sc337SavingsNotifications;
  static const String sc338SavingsRecommendations =
      EarnRouteNames.sc338SavingsRecommendations;
  static const String sc339SavingsRiskAssessment =
      EarnRouteNames.sc339SavingsRiskAssessment;
  static const String sc340SavingsComparison =
      EarnRouteNames.sc340SavingsComparison;
  static const String sc341AutoCompoundSettings =
      EarnRouteNames.sc341AutoCompoundSettings;
  static const String sc342SavingsGoal = EarnRouteNames.sc342SavingsGoal;
  static const String sc343SavingsAnalytics =
      EarnRouteNames.sc343SavingsAnalytics;
  static const String sc344SavingsAutoRebalance =
      EarnRouteNames.sc344SavingsAutoRebalance;
  static const String sc345SavingsNotificationPreferences =
      EarnRouteNames.sc345SavingsNotificationPreferences;
  static const String sc346SavingsDca = EarnRouteNames.sc346SavingsDca;
  static const String sc347SavingsSmartSuggestions =
      EarnRouteNames.sc347SavingsSmartSuggestions;
  static const String sc348SavingsExport = EarnRouteNames.sc348SavingsExport;
  static const String sc349SavingsBacktest =
      EarnRouteNames.sc349SavingsBacktest;
  static const String sc350SavingsAutoPilot =
      EarnRouteNames.sc350SavingsAutoPilot;
  static const String sc351SavingsLadder = EarnRouteNames.sc351SavingsLadder;
  static const String sc352SavingsWhatIf = EarnRouteNames.sc352SavingsWhatIf;
  static const String sc353StakingTerms = EarnRouteNames.sc353StakingTerms;
  static const String sc354StakingRiskDisclosure =
      EarnRouteNames.sc354StakingRiskDisclosure;
  static const String sc355StakingWithdrawalPolicy =
      EarnRouteNames.sc355StakingWithdrawalPolicy;
  static const String sc356StakingTaxGuide =
      EarnRouteNames.sc356StakingTaxGuide;
  static const String sc357StakingRiskAssessment =
      EarnRouteNames.sc357StakingRiskAssessment;
  static const String sc358StakingDashboard =
      EarnRouteNames.sc358StakingDashboard;
  static const String sc359StakingAnalytics =
      EarnRouteNames.sc359StakingAnalytics;
  static const String sc360StakingHistory = EarnRouteNames.sc360StakingHistory;
  static const String sc361StakingEarningsCalendar =
      EarnRouteNames.sc361StakingEarningsCalendar;
  static const String sc362StakingValidatorSelection =
      EarnRouteNames.sc362StakingValidatorSelection;
  static const String sc363StakingAutoCompound =
      EarnRouteNames.sc363StakingAutoCompound;
  static const String sc364StakingLiquidStaking =
      EarnRouteNames.sc364StakingLiquidStaking;
  static const String sc365StakingInsurance =
      EarnRouteNames.sc365StakingInsurance;
  static const String sc366StakingAdvancedOrders =
      EarnRouteNames.sc366StakingAdvancedOrders;
  static const String sc367StakingMultiChain =
      EarnRouteNames.sc367StakingMultiChain;
  static const String sc368StakingInstitutional =
      EarnRouteNames.sc368StakingInstitutional;
  static const String sc369StakingGuide = EarnRouteNames.sc369StakingGuide;
  static const String sc370StakingFAQ = EarnRouteNames.sc370StakingFAQ;
  static const String sc371StakingNotifications =
      EarnRouteNames.sc371StakingNotifications;
  static const String sc372StakingRecommendations =
      EarnRouteNames.sc372StakingRecommendations;
  static const String sc373StakingRegulatoryFramework =
      EarnRouteNames.sc373StakingRegulatoryFramework;
  static const String sc374StakingAuditReports =
      EarnRouteNames.sc374StakingAuditReports;
  static const String sc375StakingCustody = EarnRouteNames.sc375StakingCustody;
  static const String sc376StakingSuitabilityAssessment =
      EarnRouteNames.sc376StakingSuitabilityAssessment;
  static const String sc377StakingInsuranceFundTransparency =
      EarnRouteNames.sc377StakingInsuranceFundTransparency;
  static const String sc378StakingTransactionReporting =
      EarnRouteNames.sc378StakingTransactionReporting;
  static const String sc379StakingApiDocumentation =
      EarnRouteNames.sc379StakingApiDocumentation;
  static const String sc380StakingProofOfReserves =
      EarnRouteNames.sc380StakingProofOfReserves;
  static const String sc381StakingRiskDashboard =
      EarnRouteNames.sc381StakingRiskDashboard;
  static const String sc382StakingSlashingHistory =
      EarnRouteNames.sc382StakingSlashingHistory;
  static const String sc383StakingValidatorHealthMonitor =
      EarnRouteNames.sc383StakingValidatorHealthMonitor;
  static const String sc384StakingRiskScoreCalculator =
      EarnRouteNames.sc384StakingRiskScoreCalculator;
  static const String sc385StakingEmergencyActions =
      EarnRouteNames.sc385StakingEmergencyActions;
  static const String sc386StakingContingencyPlan =
      EarnRouteNames.sc386StakingContingencyPlan;
  static const String sc387StakingSocialFeed =
      EarnRouteNames.sc387StakingSocialFeed;
  static const String sc388StakingCommunityGovernance =
      EarnRouteNames.sc388StakingCommunityGovernance;
  static const String sc389StakingProposals =
      EarnRouteNames.sc389StakingProposals;
  static const String sc390StakingVotingDetail =
      EarnRouteNames.sc390StakingVotingDetail;
  static const String sc391StakingVoting = EarnRouteNames.sc391StakingVoting;
  static const String sc392StakingForum = EarnRouteNames.sc392StakingForum;
  static const String sc393StakingWebhooks =
      EarnRouteNames.sc393StakingWebhooks;
  static const String sc394StakingDataExport =
      EarnRouteNames.sc394StakingDataExport;
  static const String sc395StakingThirdPartyIntegrations =
      EarnRouteNames.sc395StakingThirdPartyIntegrations;
  static const String sc396StakingDeveloperConsole =
      EarnRouteNames.sc396StakingDeveloperConsole;

  // ==== ONBOARDING ====
  static const String sc397Onboarding = AuthRouteNames.sc397Onboarding;

  // ==== LATE ADDITIONS — mixed features, added as detail-page afterthoughts; check the path for the owning feature ====
  static const String sc402P2PKycVerify = P2PRouteNames.sc402P2PKycVerify;
  static const String sc403P2PKycFaceMatch = P2PRouteNames.sc403P2PKycFaceMatch;
  static const String sc404P2PWhitelistMode =
      P2PRouteNames.sc404P2PWhitelistMode;
  static const String sc405SettingsSecurityBiometric =
      ProfileRouteNames.sc405SettingsSecurityBiometric;
  static const String sc406SettingsSecurityChangePassword =
      ProfileRouteNames.sc406SettingsSecurityChangePassword;
  static const String sc407P2PTaxReportDetail =
      P2PRouteNames.sc407P2PTaxReportDetail;
  static const String sc408DcaRebalanceEdit =
      DcaRouteNames.sc408DcaRebalanceEdit;
  static const String sc409DcaRebalanceHistory =
      DcaRouteNames.sc409DcaRebalanceHistory;
  static const String sc410AdminSettings = AdminRouteNames.sc410AdminSettings;
  static const String sc411ClientOptUpRequest =
      TradeComplianceRouteNames.sc411ClientOptUpRequest;
  static const String sc412TradeCopyRegulatoryDisclosuresAlias =
      TradeRouteNames.sc412TradeCopyRegulatoryDisclosuresAlias;
  static const String sc413SettingsSecurity =
      ProfileRouteNames.sc413SettingsSecurity;
  static const String sc414PredictionTournamentDetail =
      PredictionsRouteNames.sc414PredictionTournamentDetail;
  static const String sc415TargetMarketDefinitionDetail =
      TradeComplianceRouteNames.sc415TargetMarketDefinitionDetail;
  static const String sc416ComplaintTrackingDetail =
      TradeComplianceRouteNames.sc416ComplaintTrackingDetail;

  // ==== SYSTEM GATE (GĐ4-F1 kill-switch) ====
  static const String sc417MaintenanceGate =
      UtilityRouteNames.sc417MaintenanceGate;
  static const String sc418ForceUpdateGate =
      UtilityRouteNames.sc418ForceUpdateGate;
}
