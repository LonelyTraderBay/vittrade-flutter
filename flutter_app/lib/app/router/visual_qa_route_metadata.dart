import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

VitBottomNavDestination activeDestinationForPath(String path) {
  if (path == AppRoutePaths.news ||
      path == AppRoutePaths.search ||
      path == AppRoutePaths.notifications ||
      path == AppRoutePaths.topics ||
      path.startsWith('/topic/') ||
      path == AppRoutePaths.support ||
      path.startsWith('/support/')) {
    return VitBottomNavDestination.home;
  }
  if (path == AppRoutePaths.enterpriseStates ||
      path == AppRoutePaths.unifiedPortfolio ||
      path == AppRoutePaths.crossModuleAnalytics ||
      path == AppRoutePaths.smartAlerts ||
      path == AppRoutePaths.taxReports ||
      path == AppRoutePaths.routeChecker ||
      path == AppRoutePaths.performanceMonitor ||
      path == AppRoutePaths.devShowcase ||
      path == AppRoutePaths.devDesignSystem ||
      path == AppRoutePaths.devDcaOverview ||
      path == AppRoutePaths.demoCopyCard ||
      path == AppRoutePaths.launchpad ||
      path.startsWith('/launchpad/')) {
    return VitBottomNavDestination.trade;
  }
  if (path.startsWith(AppRoutePaths.markets)) {
    return VitBottomNavDestination.markets;
  }
  if (path.startsWith(AppRoutePaths.trade)) {
    return VitBottomNavDestination.trade;
  }
  if (path == AppRoutePaths.dca || path.startsWith('/dca/')) {
    return VitBottomNavDestination.trade;
  }
  if (path == AppRoutePaths.earn || path.startsWith('/earn/')) {
    return VitBottomNavDestination.trade;
  }
  if (path == AppRoutePaths.admin || path.startsWith('/admin/')) {
    return VitBottomNavDestination.trade;
  }
  if (path == AppRoutePaths.rewards) {
    return VitBottomNavDestination.trade;
  }
  if (path == AppRoutePaths.p2p || path.startsWith('/p2p/')) {
    return VitBottomNavDestination.trade;
  }
  if (path == AppRoutePaths.arena || path.startsWith('/arena/')) {
    return VitBottomNavDestination.trade;
  }
  if (path.startsWith('/pair/')) {
    return VitBottomNavDestination.markets;
  }
  if (path.startsWith(AppRoutePaths.wallet)) {
    return VitBottomNavDestination.wallet;
  }
  if (path == AppRoutePaths.referral || path.startsWith('/referral/')) {
    return VitBottomNavDestination.profile;
  }
  if (path == AppRoutePaths.settingsSecurity ||
      path.startsWith('/settings/security/')) {
    return VitBottomNavDestination.profile;
  }
  if (path.startsWith(AppRoutePaths.profile)) {
    return VitBottomNavDestination.profile;
  }
  return VitBottomNavDestination.home;
}

String visualQaStatusBarTimeForUri(Uri uri) {
  final path = uri.path;
  if (path == AppRoutePaths.rewards) {
    return uri.queryParameters['tab'] == 'arena' ? '23:34' : '23:38';
  }
  if (path == AppRoutePaths.enterpriseStates) return '23:38';
  if (path == AppRoutePaths.unifiedPortfolio) return '23:38';
  if (path == AppRoutePaths.crossModuleAnalytics) return '23:38';
  if (path == AppRoutePaths.smartAlerts) return '23:38';
  if (path == AppRoutePaths.taxReports) return '08:40';
  if (path == AppRoutePaths.routeChecker) return '08:49';
  if (path == AppRoutePaths.performanceMonitor) return '09:01';
  if (path == AppRoutePaths.devShowcase) return '21:37';
  if (path == AppRoutePaths.devDesignSystem) return '21:44';
  if (path == AppRoutePaths.devDcaOverview) return '21:53';
  if (path == AppRoutePaths.demoCopyCard) return '22:04';
  if (path == AppRoutePaths.earn) return '09:11';
  if (path == AppRoutePaths.earnStaking) return '09:18';
  if (path == AppRoutePaths.earnStakingTerms) return '14:20';
  if (path == AppRoutePaths.earnStakingRiskDisclosure) return '14:33';
  if (path == AppRoutePaths.earnStakingWithdrawalPolicy) return '14:52';
  if (path == AppRoutePaths.earnStakingTaxGuide) return '15:02';
  if (path == AppRoutePaths.earnHistory) return '15:46';
  if (path == AppRoutePaths.earnStakingRiskAssessment) return '15:12';
  if (path == AppRoutePaths.earnDashboard) return '15:21';
  if (path == AppRoutePaths.earnAnalytics) return '15:34';
  if (path == AppRoutePaths.earnCalendar) return '15:56';
  if (path == AppRoutePaths.earnValidatorSelection) return '16:12';
  if (path == AppRoutePaths.earnAutoCompound) return '16:22';
  if (path == AppRoutePaths.earnLiquidStaking) return '16:31';
  if (path == AppRoutePaths.earnInsurance) return '16:42';
  if (path == AppRoutePaths.earnAdvancedOrders) return '16:54';
  if (path == AppRoutePaths.earnMultiChain) return '17:01';
  if (path == AppRoutePaths.earnInstitutional) return '17:09';
  if (path == AppRoutePaths.earnGuide) return '17:16';
  if (path == AppRoutePaths.earnFAQ) return '17:23';
  if (path == AppRoutePaths.earnNotifications) return '17:29';
  if (path == AppRoutePaths.earnRecommendations) return '17:37';
  if (path == AppRoutePaths.earnRegulatoryFramework) return '17:47';
  if (path == AppRoutePaths.earnAuditReports) return '17:56';
  if (path == AppRoutePaths.earnCustody) return '18:09';
  if (path == AppRoutePaths.earnSuitabilityAssessment) return '18:18';
  if (path == AppRoutePaths.earnInsuranceFundTransparency) return '18:29';
  if (path == AppRoutePaths.earnTransactionReporting) return '18:37';
  if (path == AppRoutePaths.earnApiDocumentation) return '18:47';
  if (path == AppRoutePaths.earnProofOfReserves) return '18:58';
  if (path == AppRoutePaths.earnRiskDashboard) return '19:08';
  if (path == AppRoutePaths.earnSlashingHistory) return '19:17';
  if (path == AppRoutePaths.earnValidatorHealthMonitor) return '19:25';
  if (path == AppRoutePaths.earnRiskScoreCalculator) return '19:37';
  if (path == AppRoutePaths.earnEmergencyActions) return '19:51';
  if (path == AppRoutePaths.earnContingencyPlan) return '19:58';
  if (path == AppRoutePaths.earnSocialFeed) return '20:05';
  if (path == AppRoutePaths.earnCommunityGovernance) return '20:12';
  if (path == AppRoutePaths.earnProposals) return '20:20';
  if (path == AppRoutePaths.earnVotingProposal('prop001')) return '20:29';
  if (path == AppRoutePaths.earnVoting) return '20:43';
  if (path == AppRoutePaths.earnForum) return '20:47';
  if (path == AppRoutePaths.earnWebhooks) return '20:55';
  if (path == AppRoutePaths.earnDataExport) return '21:04';
  if (path == AppRoutePaths.earnThirdPartyIntegrations) return '21:12';
  if (path == AppRoutePaths.earnDeveloperConsole) return '21:17';
  if (path == AppRoutePaths.earnSavings) return '09:22';
  if (path == AppRoutePaths.earnSavingsPortfolio) return '09:51';
  if (path == AppRoutePaths.earnSavingsHistory) return '09:59';
  if (path == AppRoutePaths.earnSavingsGuide) return '10:08';
  if (path == AppRoutePaths.earnSavingsFAQ) return '10:19';
  if (path == AppRoutePaths.earnSavingsNotifications) return '10:29';
  if (path == AppRoutePaths.earnSavingsRecommendations) return '10:38';
  if (path == AppRoutePaths.earnSavingsRiskAssessment) return '10:46';
  if (path == AppRoutePaths.earnSavingsComparison) return '10:58';
  if (path == AppRoutePaths.earnSavingsAutoCompound) return '11:11';
  if (path == AppRoutePaths.earnSavingsGoals) return '11:19';
  if (path == AppRoutePaths.earnSavingsAnalytics) return '11:29';
  if (path == AppRoutePaths.earnSavingsRebalance) return '11:45';
  if (path == AppRoutePaths.earnSavingsNotificationPreferences) return '11:58';
  if (path == AppRoutePaths.earnSavingsDca) return '12:08';
  if (path == AppRoutePaths.earnSavingsSmartSuggestions) return '12:18';
  if (path == AppRoutePaths.earnSavingsExport) return '12:29';
  if (path == AppRoutePaths.earnSavingsBacktest) return '12:43';
  if (path == AppRoutePaths.earnSavingsAutoPilot) return '12:55';
  if (path == AppRoutePaths.earnSavingsLadder) return '13:12';
  if (path == AppRoutePaths.earnSavingsWhatIf) return '14:06';
  if (path == AppRoutePaths.earnSavingsProductSample) return '09:32';
  if (path == AppRoutePaths.earnSavingsRedeemPos001) return '09:39';
  if (path == AppRoutePaths.earnSavingsReceipt) return '09:44';
  if (path == AppRoutePaths.rewards ||
      path == AppRoutePaths.arenaPoints ||
      path == AppRoutePaths.arenaFlowMap ||
      path == AppRoutePaths.arenaSafety ||
      path == AppRoutePaths.arenaBlocked ||
      path == AppRoutePaths.arenaMyReports ||
      path == AppRoutePaths.arenaMy ||
      path == AppRoutePaths.arenaProduction ||
      path == AppRoutePaths.arenaBridge ||
      path == AppRoutePaths.arenaEcosystem ||
      path == AppRoutePaths.arenaGuide ||
      path == AppRoutePaths.arenaLedger ||
      path.startsWith('/arena/report/') ||
      path.startsWith('/arena/trust/') ||
      path.startsWith('/arena/ledger/entry/')) {
    return '23:34';
  }
  if (path == AppRoutePaths.marketsSocialSentiment) return '23:28';
  if (path == AppRoutePaths.marketsPortfolioTracker) return '23:28';
  if (path == AppRoutePaths.marketsNews) return '23:28';
  if (path == AppRoutePaths.marketsAdvancedCharts) return '23:28';
  if (path == AppRoutePaths.marketsUnlocks) return '23:28';
  if (path == AppRoutePaths.marketsSignals) return '23:28';
  if (path == AppRoutePaths.marketsCorrelations) return '23:28';
  if (path == AppRoutePaths.marketsPredictions) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsSearch) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsBreaking) return '23:28';
  if (path.startsWith('/markets/predictions/event/')) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsPortfolio) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsRewards) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsLeaderboard) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsActivity) return '23:28';
  if (path.startsWith('/markets/predictions/receipt/')) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsRiskCalculator) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsMarketMaker) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsPortfolioAnalyzer) {
    return '23:28';
  }
  if (path == AppRoutePaths.marketsPredictionsEventCalendar) return '23:28';
  if (path == AppRoutePaths.marketsPredictionsSocial) return '23:28';
  if (path.startsWith('/markets/predictions/advanced-chart/')) return '23:29';
  if (path == AppRoutePaths.marketsPredictionsTournaments) return '23:29';
  if (path.startsWith('/markets/predictions/tournament/')) return '23:29';
  if (path == AppRoutePaths.marketsPredictionsDataIntegration) return '23:29';
  if (path.startsWith('/pair/')) return '23:29';
  if (path == AppRoutePaths.news) return '23:29';
  if (path == AppRoutePaths.trade) return '23:29';
  if (path == AppRoutePaths.tradeBotTermsOfService) return '23:31';
  if (path == AppRoutePaths.tradeBotRiskDisclosure) return '23:31';
  if (path == AppRoutePaths.tradeBotSuitabilityAssessment) return '23:31';
  if (path == AppRoutePaths.tradeBotRiskDashboard) return '23:31';
  if (path == AppRoutePaths.tradeBotEmergencyStop) return '23:31';
  if (path == AppRoutePaths.tradeBotSecuritySettings) return '23:31';
  if (path == AppRoutePaths.tradeBotHistory) return '23:31';
  if (path == AppRoutePaths.tradeBotPerformanceAnalytics) return '23:31';
  if (path == AppRoutePaths.tradeBotBacktesting) return '23:31';
  if (path == AppRoutePaths.tradeBotStrategyCompare) return '23:31';
  if (path == AppRoutePaths.tradeBotOptimization) return '23:31';
  if (path == AppRoutePaths.tradeBotPortfolioDashboard) return '23:31';
  if (path == AppRoutePaths.tradeBotDrawdownAnalyzer) return '23:32';
  if (path == AppRoutePaths.tradeBotEquityCurve) return '23:32';
  if (path == AppRoutePaths.tradeBotGuide) return '23:32';
  if (path == AppRoutePaths.tradeBotFaq) return '23:32';
  if (path == AppRoutePaths.tradeBotTaxReporting) return '23:32';
  if (path == AppRoutePaths.tradeBotApiDocumentation) return '23:32';
  if (path.startsWith('/trade/advanced-chart/')) return '23:29';
  if (path.startsWith(AppRoutePaths.tradeCopyTargetMarketDefinition)) {
    return '23:31';
  }
  if (path == AppRoutePaths.tradeCopyClientMoneyProtection) return '23:31';
  if (path == AppRoutePaths.tradeCopyCassReconciliation) return '23:31';
  if (path == AppRoutePaths.tradeCopyInvestorCompensation) return '23:31';
  if (path == AppRoutePaths.tradeCopyExAnteCosts) return '23:31';
  if (path == AppRoutePaths.tradeCopyRiyCalculator) return '23:31';
  if (path == AppRoutePaths.tradeCopyExPostCostsReport) return '23:31';
  if (path == AppRoutePaths.tradeCopyKidGenerator) return '23:31';
  if (path == AppRoutePaths.tradeCopyPerformanceScenarios) return '23:31';
  if (path == AppRoutePaths.tradeCopyRiskIndicatorExplainer) return '23:31';
  if (path == AppRoutePaths.tradeCopyComplaintsHandling) return '23:31';
  if (path == AppRoutePaths.tradeCopyComplaintSubmission) return '23:31';
  if (path == AppRoutePaths.tradeCopyComplaintTrackingBase ||
      path.startsWith('${AppRoutePaths.tradeCopyComplaintTrackingBase}/')) {
    return '23:31';
  }
  if (path == AppRoutePaths.tradeCopyOmbudsmanReferral) return '23:31';
  if (path == AppRoutePaths.tradeCopyAuditTrail) return '23:31';
  if (path == AppRoutePaths.tradeCopyRegulatoryInspectionReady) return '23:31';
  if (path == AppRoutePaths.tradeCopyRegulatoryDisclosures) return '23:30';
  if (path.startsWith('/trade/margin')) return '23:30';
  if (path.startsWith('/trade/trader/')) return '23:30';
  if (path.startsWith('/trade/copy-provider/')) return '23:30';
  if (path.startsWith('/trade/copy-performance/')) return '23:30';
  if (path.startsWith('/trade/')) return '23:29';
  if (path.startsWith('/p2p/order/proof/')) return '23:35';
  if (path.startsWith('/p2p/order/') && path.split('/').length == 4) {
    return '23:35';
  }
  if (path.startsWith('/p2p/chat/')) return '23:35';
  if (path.startsWith('/p2p/dispute/detail/')) return '23:35';
  if (path.startsWith('/p2p/dispute/evidence/')) return '23:35';
  if (path.startsWith('/p2p/dispute/resolution/')) return '23:35';
  if (path.startsWith('/p2p/dispute/')) return '23:35';
  if (path == AppRoutePaths.p2pDisputes) return '23:35';
  if (path.startsWith('/p2p/ad-analytics/')) return '23:35';
  if (path.startsWith('/p2p/ad/')) return '23:35';
  if (path == AppRoutePaths.p2pMyAds) return '23:35';
  if (path == AppRoutePaths.p2pCreate) return '23:35';
  if (path == AppRoutePaths.p2pMerchantApply) return '23:35';
  if (path.startsWith('/p2p/merchant/')) return '23:35';
  if (path.startsWith('/p2p/report/')) return '23:35';
  if (path == AppRoutePaths.p2p) return '23:37';
  if (path == AppRoutePaths.p2pTradingLevel) return '23:35';
  if (path == AppRoutePaths.p2pReviews) return '23:35';
  if (path == AppRoutePaths.p2pBlacklist) return '23:37';
  if (path == AppRoutePaths.p2pBlacklistAdd) return '23:37';
  if (path == AppRoutePaths.p2pGuide) return '23:37';
  if (path == AppRoutePaths.p2pMyOrders) return '23:37';
  if (path == AppRoutePaths.p2pSettings) return '23:37';
  if (path == AppRoutePaths.p2pSettingsNotifications) return '23:37';
  if (path == AppRoutePaths.p2pPaymentMethodAdd) return '23:35';
  if (path.startsWith('/p2p/payment-method/verification/')) return '23:35';
  if (path.startsWith('/p2p/payment-method/ownership/')) return '23:35';
  if (path == AppRoutePaths.p2pPaymentMethodCoolingPeriod) return '23:35';
  if (path == AppRoutePaths.p2pPaymentMethodHistory) return '23:35';
  if (path == AppRoutePaths.p2pPaymentMethods) return '23:35';
  if (path == AppRoutePaths.p2pEscrowBalance) return '23:36';
  if (path.startsWith('/p2p/escrow/')) return '23:36';
  if (path == AppRoutePaths.p2pKycRequirements) return '23:36';
  if (path == AppRoutePaths.p2pKycStatus) return '23:36';
  if (path == AppRoutePaths.p2pKycIdentity) return '23:36';
  if (path == AppRoutePaths.p2pKycAddress) return '23:36';
  if (path == AppRoutePaths.p2pKycSelfie) return '23:36';
  if (path == AppRoutePaths.p2pKycVideo) return '23:36';
  if (path == AppRoutePaths.p2pSecurityCenter) return '23:36';
  if (path == AppRoutePaths.p2pSecurity2fa) return '23:36';
  if (path == AppRoutePaths.p2pSecurityDevices) return '23:36';
  if (path == AppRoutePaths.p2pSecurityAntiPhishing) return '23:36';
  if (path == AppRoutePaths.p2pSecurityLoginHistory) return '23:36';
  if (path == AppRoutePaths.p2pSecuritySuspiciousActivity) return '23:36';
  if (path == AppRoutePaths.p2pE2EInfo) return '23:36';
  if (path == AppRoutePaths.p2pFraudPrevention) return '23:36';
  if (path == AppRoutePaths.p2pWallet ||
      path == AppRoutePaths.p2pWalletTransfer ||
      path == AppRoutePaths.p2pWalletFundLockHistory ||
      path == AppRoutePaths.p2pWalletHistory ||
      path == AppRoutePaths.p2pLimits ||
      path == AppRoutePaths.p2pLimitsTracker ||
      path == AppRoutePaths.p2pComplianceOverview ||
      path == AppRoutePaths.p2pComplianceAmlScreening ||
      path == AppRoutePaths.p2pComplianceSourceOfFunds ||
      path == AppRoutePaths.p2pComplianceLargeTransaction ||
      path == AppRoutePaths.p2pComplianceRiskAssessment ||
      path == AppRoutePaths.p2pTaxReporting ||
      path == AppRoutePaths.p2pOrderBook ||
      path == AppRoutePaths.p2pDashboard ||
      path == AppRoutePaths.p2pAchievements ||
      path.startsWith('/p2p/tax-report/detailed/') ||
      path == AppRoutePaths.p2pMyOrders) {
    return path == AppRoutePaths.p2pAchievements ? '23:37' : '23:36';
  }
  if (path == AppRoutePaths.p2pInsurance ||
      path == AppRoutePaths.p2pInsuranceFundAlias ||
      path == AppRoutePaths.p2pInsuranceCertificate ||
      path == AppRoutePaths.p2pInsuranceScore ||
      path == AppRoutePaths.p2pInsurancePolicy ||
      path == AppRoutePaths.p2pContributionHistory ||
      path.startsWith('/p2p/insurance/claim/')) {
    return '23:35';
  }
  if (path == AppRoutePaths.p2p || path.startsWith('/p2p/')) return '23:34';
  if (path == AppRoutePaths.search) return '23:37';
  if (path == AppRoutePaths.notifications) return '23:37';
  if (path == AppRoutePaths.topics || path.startsWith('/topic/')) {
    return '23:37';
  }
  if (path == AppRoutePaths.referral || path.startsWith('/referral/')) {
    return '23:37';
  }
  if (path == AppRoutePaths.support || path.startsWith('/support/')) {
    return '23:37';
  }
  if (path == AppRoutePaths.launchpad || path.startsWith('/launchpad/')) {
    return '23:37';
  }
  if (path == AppRoutePaths.dca || path.startsWith('/dca/')) return '23:33';
  if (path == AppRoutePaths.admin || path.startsWith('/admin/')) return '23:33';
  if (path == AppRoutePaths.arena || path.startsWith('/arena/')) return '23:33';
  if (path.startsWith(AppRoutePaths.wallet)) return '23:32';
  if (path.startsWith(AppRoutePaths.profile)) return '23:33';
  if (path == AppRoutePaths.marketsDepth) return '23:28';
  if (path == AppRoutePaths.marketsDerivatives) return '23:28';
  if (path == AppRoutePaths.marketsCalendar) return '23:28';
  if (path == AppRoutePaths.marketsCompare) return '23:28';
  if (path == AppRoutePaths.marketsScreener) return '23:28';
  if (path == AppRoutePaths.marketsAlerts) return '23:28';
  if (path == AppRoutePaths.marketsHeatmap) return '23:28';
  if (path == AppRoutePaths.marketsWatchlist) return '23:28';
  return '23:27';
}
