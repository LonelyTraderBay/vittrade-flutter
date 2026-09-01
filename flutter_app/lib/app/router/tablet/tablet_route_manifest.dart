// GENERATED FILE - do not edit by hand.
//
// Source: docs/02_FLUTTER_MIGRATION/Flutter-Route-Coverage-Truth-Table.md
// Regenerate from flutter_app/ with:
//   dart run tool/generate_tablet_route_manifest.dart

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';

/// Surface-neutral route declarations consumed by the Tablet composition.
///
/// The manifest keeps path/name/redirect parity with the audited route tree;
/// the Tablet router decides independently which page or utility composition
/// renders each declaration.
final class TabletRouteSpec {
  const TabletRouteSpec({required this.path, this.name, this.redirectTarget});

  final String path;
  final String? name;
  final String? redirectTarget;

  bool get isRedirectAlias => redirectTarget != null;
}

const List<TabletRouteSpec> tabletRouteManifest = [
  TabletRouteSpec(
    path: AppRoutePaths.admin,
    name: AppRouteNames.sc180AdminHome,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.adminAnalytics,
    name: AppRouteNames.sc181AnalyticsDashboard,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.adminAbtests,
    name: AppRouteNames.sc182AbTestDashboard,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.adminFunnels,
    name: AppRouteNames.sc183FunnelDashboard,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.adminSettings,
    name: AppRouteNames.sc410AdminSettings,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arena,
    name: AppRouteNames.sc184ArenaHome,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaGuide,
    name: AppRouteNames.sc209ArenaGuide,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaStudio,
    name: AppRouteNames.sc185ArenaStudio,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaStudioSmartRules,
    name: AppRouteNames.sc186ArenaSmartRules,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaStudioPresets,
    name: AppRouteNames.sc187ArenaPresetLibrary,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaStudioGovernance,
    name: AppRouteNames.sc188ArenaGovernanceGate,
  ),
  TabletRouteSpec(
    path: '/arena/mode/:modeId',
    name: AppRouteNames.sc189ArenaModeDetail,
  ),
  TabletRouteSpec(
    path: '/arena/challenge/:challengeId',
    name: AppRouteNames.sc190ArenaChallengeDetail,
  ),
  TabletRouteSpec(
    path: '/arena/join/:challengeId',
    name: AppRouteNames.sc191ArenaJoin,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaResolution,
    name: AppRouteNames.sc192ArenaResolutionCenter,
  ),
  TabletRouteSpec(
    path: '/arena/creator/:creatorId',
    name: AppRouteNames.sc193ArenaCreator,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaLeaderboard,
    name: AppRouteNames.sc194ArenaLeaderboard,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaVerified,
    name: AppRouteNames.sc195VerifiedChallenges,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaPoints,
    redirectTarget: '${AppRoutePaths.rewards}?tab=arena',
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaFlowMap,
    name: AppRouteNames.sc197ArenaFlowMap,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaSafety,
    name: AppRouteNames.sc198ArenaSafetyCenter,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaBlocked,
    name: AppRouteNames.sc203ArenaBlockedUsers,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaMyReports,
    name: AppRouteNames.sc204MyArenaReports,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaMy,
    name: AppRouteNames.sc205MyArena,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaProduction,
    name: AppRouteNames.sc206ArenaProductionReady,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaBridge,
    name: AppRouteNames.sc207ArenaPredictionBridgeFoundation,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaEcosystem,
    name: AppRouteNames.sc208ConnectedEcosystemProduction,
  ),
  TabletRouteSpec(
    path: '/arena/trust/:userId',
    name: AppRouteNames.sc199ArenaTrustBreakdown,
  ),
  TabletRouteSpec(
    path: '/arena/ledger/entry/:entryId',
    name: AppRouteNames.sc200ArenaPointsEntryDetail,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.arenaLedger,
    name: AppRouteNames.sc201ArenaPointsLedger,
  ),
  TabletRouteSpec(
    path: '/arena/report/:caseId',
    name: AppRouteNames.sc202ArenaReportCase,
  ),
  TabletRouteSpec(path: AppRoutePaths.root, redirectTarget: AppRoutePaths.home),
  TabletRouteSpec(
    path: AppRoutePaths.authLogin,
    name: AppRouteNames.sc001Login,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.authRegister,
    name: AppRouteNames.sc002Register,
  ),
  TabletRouteSpec(path: AppRoutePaths.authOtp, name: AppRouteNames.sc003Otp),
  TabletRouteSpec(
    path: AppRoutePaths.auth2faSetup,
    name: AppRouteNames.sc004TwoFaSetup,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.authForgotPassword,
    name: AppRouteNames.sc005ForgotPassword,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.authResetPassword,
    name: AppRouteNames.sc006ResetPassword,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.onboarding,
    name: AppRouteNames.sc397Onboarding,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.maintenanceGate,
    name: AppRouteNames.sc417MaintenanceGate,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.forceUpdateGate,
    name: AppRouteNames.sc418ForceUpdateGate,
  ),
  TabletRouteSpec(path: AppRoutePaths.dca, name: AppRouteNames.sc169Dca),
  TabletRouteSpec(
    path: AppRoutePaths.dcaPortfolioOptimizer,
    name: AppRouteNames.sc174DcaPortfolioOptimizer,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.dcaDynamicAmount,
    name: AppRouteNames.sc175DcaDynamicAmount,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.dcaBacktester,
    name: AppRouteNames.sc176DcaBacktester,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.dcaMultiAsset,
    name: AppRouteNames.sc177DcaMultiAsset,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.dcaPerformanceCompare,
    name: AppRouteNames.sc178DcaPerformanceCompare,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.dcaSmartRules,
    name: AppRouteNames.sc179DcaSmartRules,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.dcaRebalanceConfig,
    name: AppRouteNames.sc170DcaRebalanceConfig,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.dcaRebalanceDashboard,
    name: AppRouteNames.sc171DcaRebalanceDashboard,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.dcaScheduleConfig,
    name: AppRouteNames.sc172DcaScheduleConfig,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.dcaScheduleAnalytics,
    name: AppRouteNames.sc173DcaScheduleAnalytics,
  ),
  TabletRouteSpec(
    path: '/dca/rebalance/:configId/edit',
    name: AppRouteNames.sc408DcaRebalanceEdit,
  ),
  TabletRouteSpec(
    path: '/dca/rebalance/:configId/history',
    name: AppRouteNames.sc409DcaRebalanceHistory,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavings,
    name: AppRouteNames.sc329Savings,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsPortfolio,
    name: AppRouteNames.sc333SavingsPortfolio,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsHistory,
    name: AppRouteNames.sc334SavingsHistory,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsGuide,
    name: AppRouteNames.sc335SavingsGuide,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsFAQ,
    name: AppRouteNames.sc336SavingsFAQ,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsNotifications,
    name: AppRouteNames.sc337SavingsNotifications,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsRecommendations,
    name: AppRouteNames.sc338SavingsRecommendations,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsRiskAssessment,
    name: AppRouteNames.sc339SavingsRiskAssessment,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsComparison,
    name: AppRouteNames.sc340SavingsComparison,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsAutoCompound,
    name: AppRouteNames.sc341AutoCompoundSettings,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsGoals,
    name: AppRouteNames.sc342SavingsGoal,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsAnalytics,
    name: AppRouteNames.sc343SavingsAnalytics,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsRebalance,
    name: AppRouteNames.sc344SavingsAutoRebalance,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsNotificationPreferences,
    name: AppRouteNames.sc345SavingsNotificationPreferences,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsDca,
    name: AppRouteNames.sc346SavingsDca,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsSmartSuggestions,
    name: AppRouteNames.sc347SavingsSmartSuggestions,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsExport,
    name: AppRouteNames.sc348SavingsExport,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsBacktest,
    name: AppRouteNames.sc349SavingsBacktest,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsAutoPilot,
    name: AppRouteNames.sc350SavingsAutoPilot,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsLadder,
    name: AppRouteNames.sc351SavingsLadder,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsWhatIf,
    name: AppRouteNames.sc352SavingsWhatIf,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsProductSample,
    name: AppRouteNames.sc330SavingsProductDetail,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsRedeemPos001,
    name: AppRouteNames.sc331SavingsRedeem,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSavingsReceipt,
    name: AppRouteNames.sc332SavingsReceipt,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earn,
    name: AppRouteNames.sc327StakingEarn,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnStaking,
    name: AppRouteNames.sc328StakingEarnStaking,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnStakingTerms,
    name: AppRouteNames.sc353StakingTerms,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnStakingRiskDisclosure,
    name: AppRouteNames.sc354StakingRiskDisclosure,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnStakingWithdrawalPolicy,
    name: AppRouteNames.sc355StakingWithdrawalPolicy,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnStakingTaxGuide,
    name: AppRouteNames.sc356StakingTaxGuide,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnHistory,
    name: AppRouteNames.sc360StakingHistory,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnStakingRiskAssessment,
    name: AppRouteNames.sc357StakingRiskAssessment,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnDashboard,
    name: AppRouteNames.sc358StakingDashboard,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnAnalytics,
    name: AppRouteNames.sc359StakingAnalytics,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnCalendar,
    name: AppRouteNames.sc361StakingEarningsCalendar,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnValidatorSelection,
    name: AppRouteNames.sc362StakingValidatorSelection,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnAutoCompound,
    name: AppRouteNames.sc363StakingAutoCompound,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnLiquidStaking,
    name: AppRouteNames.sc364StakingLiquidStaking,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnInsurance,
    name: AppRouteNames.sc365StakingInsurance,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnAdvancedOrders,
    name: AppRouteNames.sc366StakingAdvancedOrders,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnMultiChain,
    name: AppRouteNames.sc367StakingMultiChain,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnInstitutional,
    name: AppRouteNames.sc368StakingInstitutional,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnGuide,
    name: AppRouteNames.sc369StakingGuide,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnFAQ,
    name: AppRouteNames.sc370StakingFAQ,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnNotifications,
    name: AppRouteNames.sc371StakingNotifications,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnRecommendations,
    name: AppRouteNames.sc372StakingRecommendations,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnRegulatoryFramework,
    name: AppRouteNames.sc373StakingRegulatoryFramework,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnAuditReports,
    name: AppRouteNames.sc374StakingAuditReports,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnCustody,
    name: AppRouteNames.sc375StakingCustody,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSuitabilityAssessment,
    name: AppRouteNames.sc376StakingSuitabilityAssessment,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnInsuranceFundTransparency,
    name: AppRouteNames.sc377StakingInsuranceFundTransparency,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnTransactionReporting,
    name: AppRouteNames.sc378StakingTransactionReporting,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnApiDocumentation,
    name: AppRouteNames.sc379StakingApiDocumentation,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnProofOfReserves,
    name: AppRouteNames.sc380StakingProofOfReserves,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnRiskDashboard,
    name: AppRouteNames.sc381StakingRiskDashboard,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSlashingHistory,
    name: AppRouteNames.sc382StakingSlashingHistory,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnValidatorHealthMonitor,
    name: AppRouteNames.sc383StakingValidatorHealthMonitor,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnRiskScoreCalculator,
    name: AppRouteNames.sc384StakingRiskScoreCalculator,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnEmergencyActions,
    name: AppRouteNames.sc385StakingEmergencyActions,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnContingencyPlan,
    name: AppRouteNames.sc386StakingContingencyPlan,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnSocialFeed,
    name: AppRouteNames.sc387StakingSocialFeed,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnCommunityGovernance,
    name: AppRouteNames.sc388StakingCommunityGovernance,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnProposals,
    name: AppRouteNames.sc389StakingProposals,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnVotingProposalRoute,
    name: AppRouteNames.sc390StakingVotingDetail,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnVoting,
    name: AppRouteNames.sc391StakingVoting,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnForum,
    name: AppRouteNames.sc392StakingForum,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnWebhooks,
    name: AppRouteNames.sc393StakingWebhooks,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnDataExport,
    name: AppRouteNames.sc394StakingDataExport,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnThirdPartyIntegrations,
    name: AppRouteNames.sc395StakingThirdPartyIntegrations,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.earnDeveloperConsole,
    name: AppRouteNames.sc396StakingDeveloperConsole,
  ),
  TabletRouteSpec(path: AppRoutePaths.home, name: AppRouteNames.sc007Home),
  TabletRouteSpec(path: AppRoutePaths.news, name: AppRouteNames.sc047News),
  TabletRouteSpec(
    path: AppRoutePaths.launchpad,
    name: AppRouteNames.sc295Launchpad,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadPortfolio,
    name: AppRouteNames.sc296LaunchpadPortfolio,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadPerformance,
    name: AppRouteNames.sc297LaunchpadPerformance,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadStaking,
    name: AppRouteNames.sc298LaunchpadStaking,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadIdoBridgeSample,
    name: AppRouteNames.sc299LaunchpadIdoBridge,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadContractSample,
    name: AppRouteNames.sc300LaunchpadContract,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadReceiptSub001,
    name: AppRouteNames.sc301LaunchpadReceipt,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadClaimReceiptPos001,
    name: AppRouteNames.sc302LaunchpadClaimReceipt,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadBatchClaim,
    name: AppRouteNames.sc304LaunchpadBatchClaim,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadBridgeCompare,
    name: AppRouteNames.sc305LaunchpadBridgeCompare,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadNotifSound,
    name: AppRouteNames.sc306LaunchpadNotifSound,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadEventLog,
    name: AppRouteNames.sc307LaunchpadEventLog,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadAbiDiff,
    name: AppRouteNames.sc308LaunchpadAbiDiff,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadAddressBook,
    name: AppRouteNames.sc309LaunchpadAddressBook,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadWebhooks,
    name: AppRouteNames.sc310LaunchpadWebhooks,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadGasTracker,
    name: AppRouteNames.sc311LaunchpadGasTracker,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadRebalance,
    name: AppRouteNames.sc312LaunchpadRebalance,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadMultisig,
    name: AppRouteNames.sc313LaunchpadMultisig,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadSwapAggregator,
    name: AppRouteNames.sc314LaunchpadSwapAggregator,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadLimitOrders,
    name: AppRouteNames.sc315LaunchpadLimitOrders,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadDcaBuilder,
    name: AppRouteNames.sc316LaunchpadDcaBuilder,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadRiskAnalytics,
    name: AppRouteNames.sc317LaunchpadRiskAnalytics,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadSample,
    name: AppRouteNames.sc318LaunchpadDetail,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.launchpadBridgeOrderTx001,
    name: AppRouteNames.sc303LaunchpadBridgeOrder,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.markets,
    name: AppRouteNames.sc008MarketList,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsOverview,
    name: AppRouteNames.sc009MarketOverview,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsMovers,
    name: AppRouteNames.sc010MarketMovers,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsSectors,
    name: AppRouteNames.sc011MarketSectors,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsWatchlist,
    name: AppRouteNames.sc012Watchlist,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsHeatmap,
    name: AppRouteNames.sc013MarketHeatmap,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsAlerts,
    name: AppRouteNames.sc014PriceAlerts,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsScreener,
    name: AppRouteNames.sc015MarketScreener,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsCompare,
    name: AppRouteNames.sc016ComparisonTool,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsCalendar,
    name: AppRouteNames.sc017MarketCalendar,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsDerivatives,
    name: AppRouteNames.sc018DerivativesOverview,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsDepth,
    name: AppRouteNames.sc019MarketDepth,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsSocialSentiment,
    name: AppRouteNames.sc020SocialSentiment,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPortfolioTracker,
    name: AppRouteNames.sc021PortfolioTracker,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsNews,
    name: AppRouteNames.sc022MarketNews,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsAdvancedCharts,
    name: AppRouteNames.sc023AdvancedCharts,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsUnlocks,
    name: AppRouteNames.sc024TokenUnlocks,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsSignals,
    name: AppRouteNames.sc025SocialSignals,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsCorrelations,
    name: AppRouteNames.sc026MarketCorrelations,
  ),
  TabletRouteSpec(path: '/pair/:pairId', name: AppRouteNames.sc044PairDetail),
  TabletRouteSpec(
    path: '/pair/:pairId/info',
    name: AppRouteNames.sc045TokenInfo,
  ),
  TabletRouteSpec(
    path: '/pair/:pairId/depth',
    name: AppRouteNames.sc046PairDepth,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pMerchantApply,
    name: AppRouteNames.sc227P2PMerchantApply,
  ),
  TabletRouteSpec(
    path: '/p2p/merchant/:merchantId',
    name: AppRouteNames.sc228P2PMerchantProfile,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pKycRequirements,
    name: AppRouteNames.sc247P2PKycRequirements,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pKycStatus,
    name: AppRouteNames.sc248P2PKycStatus,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pKycIdentity,
    name: AppRouteNames.sc249P2PIdentityVerification,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pKycAddress,
    name: AppRouteNames.sc250P2PAddressProof,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pKycVerify,
    name: AppRouteNames.sc402P2PKycVerify,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pKycFaceMatch,
    name: AppRouteNames.sc403P2PKycFaceMatch,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pKycSelfie,
    name: AppRouteNames.sc251P2PSelfieVerification,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pKycVideo,
    name: AppRouteNames.sc252P2PVideoVerification,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pPaymentMethodAdd,
    name: AppRouteNames.sc232P2PPaymentMethodAdd,
  ),
  TabletRouteSpec(
    path: '/p2p/payment-method/verification/:methodId',
    name: AppRouteNames.sc233P2PPaymentMethodVerification,
  ),
  TabletRouteSpec(
    path: '/p2p/payment-method/ownership/:methodId',
    name: AppRouteNames.sc234P2PPaymentMethodOwnership,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pPaymentMethodCoolingPeriod,
    name: AppRouteNames.sc235P2PPaymentMethodCoolingPeriod,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pPaymentMethodHistory,
    name: AppRouteNames.sc236P2PPaymentMethodHistory,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pPaymentMethods,
    name: AppRouteNames.sc237P2PPaymentMethods,
  ),
  TabletRouteSpec(
    path: '/p2p/dispute/detail/:disputeId',
    name: AppRouteNames.sc218P2PDisputeDetail,
  ),
  TabletRouteSpec(
    path: '/p2p/dispute/evidence/:disputeId',
    name: AppRouteNames.sc219P2PDisputeEvidence,
  ),
  TabletRouteSpec(
    path: '/p2p/dispute/resolution/:disputeId',
    name: AppRouteNames.sc220P2PDisputeResolution,
  ),
  TabletRouteSpec(
    path: '/p2p/dispute/:orderId',
    name: AppRouteNames.sc221P2PDispute,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pDisputes,
    name: AppRouteNames.sc222P2PDisputes,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pInsurance,
    name: AppRouteNames.sc238P2PInsuranceFund,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pInsuranceFundAlias,
    name: AppRouteNames.sc244P2PInsuranceFundAlias,
    redirectTarget: AppRoutePaths.p2pInsurance,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pInsuranceCertificate,
    name: AppRouteNames.sc239P2PInsuranceCertificate,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pInsuranceScore,
    name: AppRouteNames.sc240P2PInsuranceScore,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pInsurancePolicy,
    name: AppRouteNames.sc241P2PInsurancePolicy,
  ),
  TabletRouteSpec(
    path: '/p2p/insurance/claim/:claimId',
    name: AppRouteNames.sc243P2PClaimDetail,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pExpress,
    name: AppRouteNames.sc211P2PExpress,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pExpressConfirm,
    name: AppRouteNames.sc210P2PExpressConfirm,
  ),
  TabletRouteSpec(
    path: '/p2p/ad-analytics/:adId',
    name: AppRouteNames.sc223P2PAdAnalytics,
  ),
  TabletRouteSpec(path: '/p2p/ad/:adId', name: AppRouteNames.sc224P2PAdDetail),
  TabletRouteSpec(
    path: AppRoutePaths.p2pMyAds,
    name: AppRouteNames.sc225P2PMyAds,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pCreate,
    name: AppRouteNames.sc226P2PCreateAd,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pTradingLevel,
    name: AppRouteNames.sc230P2PTradingLevel,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pGuide,
    name: AppRouteNames.sc280P2PGuide,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pSettings,
    name: AppRouteNames.sc279P2PSettings,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pSettingsNotifications,
    name: AppRouteNames.sc278P2PNotificationsSettings,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pOrderBook,
    name: AppRouteNames.sc273P2POrderBook,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pDashboard,
    name: AppRouteNames.sc274P2PDashboard,
  ),
  TabletRouteSpec(path: AppRoutePaths.p2p, name: AppRouteNames.sc282P2PHome),
  TabletRouteSpec(
    path: '/p2p/order/timeline/:orderId',
    name: AppRouteNames.sc212P2POrderTimeline,
  ),
  TabletRouteSpec(
    path: '/p2p/order/rate/:orderId',
    name: AppRouteNames.sc213P2POrderRate,
  ),
  TabletRouteSpec(
    path: '/p2p/order/cancel/:orderId',
    name: AppRouteNames.sc214P2POrderCancel,
  ),
  TabletRouteSpec(
    path: '/p2p/order/proof/:orderId',
    name: AppRouteNames.sc215P2POrderProof,
  ),
  TabletRouteSpec(
    path: '/p2p/order/:orderId',
    name: AppRouteNames.sc216P2POrder,
  ),
  TabletRouteSpec(path: '/p2p/chat/:orderId', name: AppRouteNames.sc217P2PChat),
  TabletRouteSpec(
    path: AppRoutePaths.p2pEscrowBalance,
    name: AppRouteNames.sc245P2PEscrowBalance,
  ),
  TabletRouteSpec(
    path: '/p2p/escrow/:orderId',
    name: AppRouteNames.sc246P2PEscrowDetail,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pWallet,
    name: AppRouteNames.sc264P2PWallet,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pWalletTransfer,
    name: AppRouteNames.sc261P2PWalletTransfer,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pWalletFundLockHistory,
    name: AppRouteNames.sc262P2PFundLockHistory,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pWalletHistory,
    name: AppRouteNames.sc263P2PWalletHistoryAlias,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pMyOrders,
    name: AppRouteNames.sc281P2PMyOrders,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pSecurityCenter,
    name: AppRouteNames.sc253P2PSecurityCenter,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pSecurity2fa,
    name: AppRouteNames.sc254P2P2FASettings,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pSecurityDevices,
    name: AppRouteNames.sc255P2PDeviceManagement,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pSecurityAntiPhishing,
    name: AppRouteNames.sc256P2PAntiPhishingCode,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pSecurityLoginHistory,
    name: AppRouteNames.sc257P2PLoginHistory,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pSecuritySuspiciousActivity,
    name: AppRouteNames.sc258P2PSuspiciousActivity,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pSecurityWhitelist,
    name: AppRouteNames.sc404P2PWhitelistMode,
  ),
  TabletRouteSpec(
    path: '/p2p/report/:merchantId',
    name: AppRouteNames.sc229P2PReportMerchant,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pReviews,
    name: AppRouteNames.sc231P2PReviews,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pContributionHistory,
    name: AppRouteNames.sc242P2PContributionHistory,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pBlacklistAdd,
    name: AppRouteNames.sc276P2PBlacklistAdd,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pBlacklist,
    name: AppRouteNames.sc277P2PBlacklist,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pE2EInfo,
    name: AppRouteNames.sc259P2PE2EInfo,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pFraudPrevention,
    name: AppRouteNames.sc260P2PFraudPrevention,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pLimits,
    name: AppRouteNames.sc266P2PTransactionLimits,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pLimitsTracker,
    name: AppRouteNames.sc265P2PLimitTracker,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pComplianceOverview,
    name: AppRouteNames.sc267P2PComplianceOverview,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pComplianceAmlScreening,
    name: AppRouteNames.sc268P2PAmlScreening,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pComplianceSourceOfFunds,
    name: AppRouteNames.sc269P2PSourceOfFunds,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pComplianceLargeTransaction,
    name: AppRouteNames.sc270P2PLargeTransaction,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pComplianceRiskAssessment,
    name: AppRouteNames.sc271P2PRiskAssessment,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pTaxReporting,
    name: AppRouteNames.sc272P2PTaxReporting,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.p2pAchievements,
    name: AppRouteNames.sc275P2PAchievements,
  ),
  TabletRouteSpec(
    path: '/p2p/tax-report/detailed/:year',
    name: AppRouteNames.sc407P2PTaxReportDetail,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPredictions,
    name: AppRouteNames.sc027PredictionsHome,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPredictionsSearch,
    name: AppRouteNames.sc028PredictionsSearch,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPredictionsBreaking,
    name: AppRouteNames.sc029PredictionsBreaking,
  ),
  TabletRouteSpec(
    path: '/markets/predictions/event/:eventId',
    name: AppRouteNames.sc030PredictionEventDetail,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPredictionsPortfolio,
    name: AppRouteNames.sc031PredictionsPortfolio,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPredictionsRewards,
    name: AppRouteNames.sc032PredictionsRewards,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPredictionsLeaderboard,
    name: AppRouteNames.sc033PredictionsLeaderboard,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPredictionsActivity,
    name: AppRouteNames.sc034PredictionsGlobalActivity,
  ),
  TabletRouteSpec(
    path: '/markets/predictions/receipt/:receiptId',
    name: AppRouteNames.sc035PredictionOrderReceipt,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPredictionsRiskCalculator,
    name: AppRouteNames.sc036PredictionRiskCalculator,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPredictionsMarketMaker,
    name: AppRouteNames.sc037PredictionMarketMaker,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPredictionsPortfolioAnalyzer,
    name: AppRouteNames.sc038PredictionPortfolioAnalyzer,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPredictionsEventCalendar,
    name: AppRouteNames.sc039PredictionEventCalendar,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPredictionsSocial,
    name: AppRouteNames.sc040PredictionSocial,
  ),
  TabletRouteSpec(
    path: '/markets/predictions/advanced-chart/:eventId',
    name: AppRouteNames.sc041PredictionAdvancedChart,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPredictionsTournaments,
    name: AppRouteNames.sc042PredictionTournaments,
  ),
  TabletRouteSpec(
    path: '/markets/predictions/tournament/:tournamentId',
    name: AppRouteNames.sc414PredictionTournamentDetail,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.marketsPredictionsDataIntegration,
    name: AppRouteNames.sc043PredictionDataIntegration,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.profile,
    name: AppRouteNames.sc156Profile,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.profileEdit,
    name: AppRouteNames.sc157EditProfile,
  ),
  TabletRouteSpec(path: AppRoutePaths.profileKyc, name: AppRouteNames.sc159Kyc),
  TabletRouteSpec(
    path: AppRoutePaths.profileSecurity,
    name: AppRouteNames.sc158Security,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.profileSettings,
    name: AppRouteNames.sc160Settings,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.profileActivity,
    name: AppRouteNames.sc161ActivityLog,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.profileApi,
    name: AppRouteNames.sc163ApiManagement,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.profileApiCreate,
    name: AppRouteNames.sc162ApiKeyCreate,
  ),
  TabletRouteSpec(path: AppRoutePaths.profileVip, name: AppRouteNames.sc164Vip),
  TabletRouteSpec(
    path: AppRoutePaths.profileDevices,
    name: AppRouteNames.sc165DeviceManagement,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.profileSubAccounts,
    name: AppRouteNames.sc166SubAccount,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.profilePredictions,
    name: AppRouteNames.sc167ProfilePredictions,
    redirectTarget: AppRoutePaths.marketsPredictionsPortfolio,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.profileArena,
    name: AppRouteNames.sc168MyArena,
    redirectTarget: AppRoutePaths.arenaMy,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.support,
    name: AppRouteNames.sc294Support,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.supportHelp,
    name: AppRouteNames.sc292HelpCenter,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.supportAnnouncements,
    name: AppRouteNames.sc293Announcements,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBots,
    name: AppRouteNames.sc059TradingBots,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotTermsOfService,
    name: AppRouteNames.sc117BotTermsOfService,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotRiskDisclosure,
    name: AppRouteNames.sc118BotRiskDisclosure,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotSuitabilityAssessment,
    name: AppRouteNames.sc119BotSuitabilityAssessment,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotRiskDashboard,
    name: AppRouteNames.sc120BotRiskDashboard,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotEmergencyStop,
    name: AppRouteNames.sc121BotEmergencyStop,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotSecuritySettings,
    name: AppRouteNames.sc122BotSecuritySettings,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotHistory,
    name: AppRouteNames.sc123BotHistory,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotPerformanceAnalytics,
    name: AppRouteNames.sc124BotPerformanceAnalytics,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotBacktesting,
    name: AppRouteNames.sc125BotBacktesting,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotStrategyCompare,
    name: AppRouteNames.sc126BotStrategyCompare,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotOptimization,
    name: AppRouteNames.sc127BotOptimization,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotPortfolioDashboard,
    name: AppRouteNames.sc128BotPortfolioDashboard,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotDrawdownAnalyzer,
    name: AppRouteNames.sc129BotDrawdownAnalyzer,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotEquityCurve,
    name: AppRouteNames.sc130BotEquityCurve,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotGuide,
    name: AppRouteNames.sc131BotGuide,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotFaq,
    name: AppRouteNames.sc132BotFaq,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotTaxReporting,
    name: AppRouteNames.sc133BotTaxReporting,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeBotApiDocumentation,
    name: AppRouteNames.sc134BotApiDocumentation,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyRegulatoryDisclosures,
    name: AppRouteNames.sc084RegulatoryDisclosures,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyTransactionReporting,
    name: AppRouteNames.sc093TransactionReporting,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
    name: AppRouteNames.sc094RegulatoryReportsDashboard,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyArmIntegrationStatus,
    name: AppRouteNames.sc095ArmIntegrationStatus,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyBestExecutionReports,
    name: AppRouteNames.sc096BestExecutionReports,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyExecutionVenueAnalysis,
    name: AppRouteNames.sc097ExecutionVenueAnalysis,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopySlippageMonitoring,
    name: AppRouteNames.sc098SlippageMonitoring,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyClientCategorization,
    name: AppRouteNames.sc099ClientCategorization,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyProductGovernance,
    name: AppRouteNames.sc100ProductGovernance,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyTargetMarketDefinition,
    name: AppRouteNames.sc101TargetMarketDefinition,
  ),
  TabletRouteSpec(
    path: '${AppRoutePaths.tradeCopyTargetMarketDefinition}/:productId',
    name: AppRouteNames.sc415TargetMarketDefinitionDetail,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyClientMoneyProtection,
    name: AppRouteNames.sc102ClientMoneyProtection,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyCassReconciliation,
    name: AppRouteNames.sc103CassReconciliation,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyInvestorCompensation,
    name: AppRouteNames.sc104InvestorCompensation,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyExAnteCosts,
    name: AppRouteNames.sc105ExAnteCosts,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyRiyCalculator,
    name: AppRouteNames.sc106RiyCalculator,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyExPostCostsReport,
    name: AppRouteNames.sc107ExPostCostsReport,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyKidGenerator,
    name: AppRouteNames.sc108KidGenerator,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyPerformanceScenarios,
    name: AppRouteNames.sc109PerformanceScenarios,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyRiskIndicatorExplainer,
    name: AppRouteNames.sc110RiskIndicatorExplainer,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyComplaintsHandling,
    name: AppRouteNames.sc111ComplaintsHandling,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyComplaintSubmission,
    name: AppRouteNames.sc112ComplaintSubmission,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyComplaintTrackingBase,
    name: AppRouteNames.sc113ComplaintTracking,
  ),
  TabletRouteSpec(
    path: '/trade/copy-trading/complaint-tracking/:complaintId',
    name: AppRouteNames.sc416ComplaintTrackingDetail,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyOmbudsmanReferral,
    name: AppRouteNames.sc114OmbudsmanReferral,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyAuditTrail,
    name: AppRouteNames.sc115AuditTrail,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyRegulatoryInspectionReady,
    name: AppRouteNames.sc116RegulatoryInspectionReady,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyClientOptUpRequest,
    name: AppRouteNames.sc411ClientOptUpRequest,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeMarginMarketDataAnalytics,
    name: AppRouteNames.sc089MarketDataAnalytics,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeMarginLiveMarketDataAnalytics,
    name: AppRouteNames.sc091LiveMarketDataAnalytics,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyTrading,
    name: AppRouteNames.sc063CopyTrading,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyEducation,
    name: AppRouteNames.sc065CopyEducation,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyActive,
    name: AppRouteNames.sc066ActiveCopies,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopySettings,
    name: AppRouteNames.sc067CopySettings,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyNotifications,
    name: AppRouteNames.sc068CopyNotifications,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyProviderApply,
    name: AppRouteNames.sc069ProviderApplication,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyComparison,
    name: AppRouteNames.sc076ProviderComparison,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyRiskAnalysis,
    name: AppRouteNames.sc078PortfolioRiskAnalysis,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyLeaderboard,
    name: AppRouteNames.sc079ProviderLeaderboard,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopySafety,
    name: AppRouteNames.sc080SafetyEducation,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyProviderGovernance,
    name: AppRouteNames.sc081ProviderGovernance,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyDisputeResolution,
    name: AppRouteNames.sc082DisputeResolution,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopySafetyCenter,
    name: AppRouteNames.sc083CopySafetyCenter,
  ),
  TabletRouteSpec(
    path: '/trade/trader/:traderId',
    name: AppRouteNames.sc087TraderProfile,
  ),
  TabletRouteSpec(
    path: '/trade/copy-provider/:providerId/assessment',
    name: AppRouteNames.sc071PreCopyAssessment,
  ),
  TabletRouteSpec(
    path: '/trade/copy-provider/:providerId/configuration',
    name: AppRouteNames.sc072CopyConfiguration,
  ),
  TabletRouteSpec(
    path: '/trade/copy-provider/:providerId/confirmation',
    name: AppRouteNames.sc073CopyConfirmation,
  ),
  TabletRouteSpec(
    path: '/trade/copy-provider/:providerId',
    name: AppRouteNames.sc070CopyProviderDetail,
  ),
  TabletRouteSpec(
    path: '/trade/copy-performance/:copyId',
    name: AppRouteNames.sc074CopyPerformance,
  ),
  TabletRouteSpec(
    path: '/trade/copy-performance/:copyId/attribution',
    name: AppRouteNames.sc075PerformanceAttribution,
  ),
  TabletRouteSpec(
    path: '/trade/copy-audit-log/:copyId',
    name: AppRouteNames.sc077CopyAuditLog,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.demoCopyCard,
    name: AppRouteNames.sc401CopyTradingCardDemo,
  ),
  TabletRouteSpec(path: AppRoutePaths.trade, name: AppRouteNames.sc048Trade),
  TabletRouteSpec(
    path: AppRoutePaths.tradeConvert,
    name: AppRouteNames.sc056Convert,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeCopyRegulatoryDisclosuresAlias,
    name: AppRouteNames.sc412TradeCopyRegulatoryDisclosuresAlias,
    redirectTarget: AppRoutePaths.tradeCopyRegulatoryDisclosures,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeMargin,
    name: AppRouteNames.sc085MarginTrading,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeMarginBtcusdt,
    name: AppRouteNames.sc086MarginTradingPair,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeMarginHub,
    name: AppRouteNames.sc090MarginTradingHub,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeOrderReceipt,
    name: AppRouteNames.sc051OrderReceipt,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeOrdersHistory,
    name: AppRouteNames.sc050OrdersHistory,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradePositions,
    name: AppRouteNames.sc053PositionDashboard,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeSettings,
    name: AppRouteNames.sc052TradeSettings,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeExport,
    name: AppRouteNames.sc054TradeHistoryExport,
  ),
  TabletRouteSpec(
    path: '/trade/:pairId/futures/leverage',
    name: AppRouteNames.sc058Leverage,
  ),
  TabletRouteSpec(
    path: '/trade/:pairId/futures',
    name: AppRouteNames.sc057Futures,
  ),
  TabletRouteSpec(path: '/trade/:pairId', name: AppRouteNames.sc049TradePair),
  TabletRouteSpec(
    path: '/trade/advanced-chart/:pairId',
    name: AppRouteNames.sc055AdvancedChart,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeRiskManagement,
    name: AppRouteNames.sc060RiskManagement,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeExecutionQuality,
    name: AppRouteNames.sc061ExecutionQuality,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeAdvancedTools,
    name: AppRouteNames.sc062AdvancedTools,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeMarginAdvancedDemo,
    name: AppRouteNames.sc088AdvancedTradingDemo,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.tradeMarginAdvancedAnalytics,
    name: AppRouteNames.sc092AdvancedAnalytics,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.rewards,
    name: AppRouteNames.sc319RewardsHub,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.enterpriseStates,
    name: AppRouteNames.sc320EnterpriseStates,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.unifiedPortfolio,
    name: AppRouteNames.sc321UnifiedPortfolio,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.crossModuleAnalytics,
    name: AppRouteNames.sc322CrossModuleAnalytics,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.smartAlerts,
    name: AppRouteNames.sc323SmartAlertCenter,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.taxReports,
    name: AppRouteNames.sc324TaxReportCenter,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.routeChecker,
    name: AppRouteNames.sc325RouteChecker,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.performanceMonitor,
    name: AppRouteNames.sc326PerformanceMonitor,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.devShowcase,
    name: AppRouteNames.sc398MissingScreensShowcase,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.devDesignSystem,
    name: AppRouteNames.sc399DesignSystem,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.devDcaOverview,
    name: AppRouteNames.sc400DcaOverviewDemo,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.search,
    name: AppRouteNames.sc283UnifiedSearch,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.notifications,
    name: AppRouteNames.sc291Notifications,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.topics,
    name: AppRouteNames.sc284TopicHub,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.topicCrypto,
    name: AppRouteNames.sc285TopicCrypto,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.referral,
    name: AppRouteNames.sc290ReferralHome,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.referralHistory,
    name: AppRouteNames.sc286ReferralHistory,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.referralRewards,
    name: AppRouteNames.sc287ReferralRewards,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.referralRules,
    name: AppRouteNames.sc288ReferralRules,
  ),
  TabletRouteSpec(
    path: '/referral/friend/:friendId',
    name: AppRouteNames.sc289ReferralFriendDetail,
  ),
  TabletRouteSpec(path: AppRoutePaths.wallet, name: AppRouteNames.sc135Wallet),
  TabletRouteSpec(
    path: AppRoutePaths.walletHistory,
    name: AppRouteNames.sc136TxHistory,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletDeposit,
    name: AppRouteNames.sc137Deposit,
  ),
  TabletRouteSpec(
    path: '${AppRoutePaths.walletDeposit}/:asset',
    name: AppRouteNames.sc138DepositUsdt,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletWithdraw,
    name: AppRouteNames.sc139Withdraw,
  ),
  TabletRouteSpec(
    path: '${AppRoutePaths.walletWithdraw}/:asset',
    name: AppRouteNames.sc140WithdrawUsdt,
  ),
  TabletRouteSpec(
    path: '/wallet/transaction/:txId',
    name: AppRouteNames.sc141TransactionDetail,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletPortfolioAnalytics,
    name: AppRouteNames.sc142PortfolioAnalytics,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletAddressBookAdd,
    name: AppRouteNames.sc143AddressAdd,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletAddressBook,
    name: AppRouteNames.sc144AddressBook,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletBuyCrypto,
    name: AppRouteNames.sc145BuyCrypto,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletTransfer,
    name: AppRouteNames.sc146Transfer,
  ),
  TabletRouteSpec(
    path: '/wallet/asset/:assetId',
    name: AppRouteNames.sc147AssetDetail,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletMultiManager,
    name: AppRouteNames.sc148MultiManager,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletGasOptimizer,
    name: AppRouteNames.sc149GasOptimizer,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletTokenApproval,
    name: AppRouteNames.sc150TokenApproval,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletHealthScore,
    name: AppRouteNames.sc151HealthScore,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletPendingDeposits,
    name: AppRouteNames.sc152PendingDeposits,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletLimits,
    name: AppRouteNames.sc153WithdrawLimits,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletDustConverter,
    name: AppRouteNames.sc154DustConverter,
  ),
  TabletRouteSpec(
    path: AppRoutePaths.walletNetworkStatus,
    name: AppRouteNames.sc155NetworkStatus,
  ),
];
