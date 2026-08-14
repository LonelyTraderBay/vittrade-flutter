# VitTrade UI Fullscreen Density Audit

Generated from `flutter_app/tool/ui_fullscreen_density_audit.dart`.

```text
total_routed_screens=412
P1_density_refactor=0
P1_fullscreen_tool_visual_qa=5
P2_visual_density_review=41
P3_followup_review=19
Pass_or_low_signal=347
```

## Priority Counts

| Priority | Count |
| --- | ---: |
| `P1_density_refactor` | 0 |
| `P1_fullscreen_tool_visual_qa` | 5 |
| `P2_visual_density_review` | 41 |
| `P3_followup_review` | 19 |
| `Pass_or_low_signal` | 347 |

## Flagged Routes

| Priority | Score | Feature | Page | Route | Reason | Page file |
| --- | ---: | --- | --- | --- | --- | --- |
| P1_fullscreen_tool_visual_qa | 16 | enterprise_states | EnterpriseStatesPage | `AppRoutePaths.enterpriseStates` | body Tool; few dense sections/cards=1 | `flutter_app/lib/features/enterprise_states/presentation/pages/enterprise_states_page.dart` |
| P1_fullscreen_tool_visual_qa | 16 | trade | FuturesPage | `'/trade/:pairId/futures'` | body Tool; few dense sections/cards=2 | `flutter_app/lib/features/trade/presentation/pages/futures/futures_page.dart` |
| P1_fullscreen_tool_visual_qa | 14 | p2p_orders | P2PChatPage | `'/p2p/chat/:orderId'` | body Tool; few dense sections/cards=1 | `flutter_app/lib/features/p2p_orders/presentation/pages/orders/p2p_chat_page.dart` |
| P2_visual_density_review | 13 | arena | ArenaBlockedUsersPage | `AppRoutePaths.arenaBlocked` | body B; few dense sections/cards=2 | `flutter_app/lib/features/arena/presentation/pages/governance/arena_blocked_users_page.dart` |
| P2_visual_density_review | 13 | arena | VerifiedChallengesPage | `AppRoutePaths.arenaVerified` | body B; few dense sections/cards=1 | `flutter_app/lib/features/arena/presentation/pages/challenge/verified_challenges_page.dart` |
| P1_fullscreen_tool_visual_qa | 13 | trade_terminal | AdvancedChartPage | `'/trade/advanced-chart/:pairId'` | body Tool | `flutter_app/lib/features/trade_terminal/presentation/pages/tools/advanced_chart_page.dart` |
| P2_visual_density_review | 12 | arena | ArenaResolutionCenterPage | `AppRoutePaths.arenaResolution` | body B; few dense sections/cards=1 | `flutter_app/lib/features/arena/presentation/pages/governance/arena_resolution_center_page.dart` |
| P2_visual_density_review | 12 | auth | ForgotPasswordPage | `AppRoutePaths.authForgotPassword` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/phone/pages/forgot_password_page.dart` |
| P2_visual_density_review | 12 | auth | OTPPage | `AppRoutePaths.authOtp` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/phone/pages/otp_page.dart` |
| P2_visual_density_review | 12 | auth | RegisterPage | `AppRoutePaths.authRegister` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/phone/pages/register_page.dart` |
| P2_visual_density_review | 12 | auth | ResetPasswordPage | `AppRoutePaths.authResetPassword` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/phone/pages/reset_password_page.dart` |
| P2_visual_density_review | 12 | dca | DCARebalanceDashboardPage | `'/dca/rebalance/:configId/history'` | body B; few dense sections/cards=2 | `flutter_app/lib/features/dca/presentation/pages/portfolio/dca_rebalance_dashboard_page.dart` |
| P2_visual_density_review | 12 | dca | DCARebalanceDashboardPage | `AppRoutePaths.dcaRebalanceDashboard` | body B; few dense sections/cards=2 | `flutter_app/lib/features/dca/presentation/pages/portfolio/dca_rebalance_dashboard_page.dart` |
| P2_visual_density_review | 12 | dca | DCAScheduleAnalyticsPage | `AppRoutePaths.dcaScheduleAnalytics` | body B; few dense sections/cards=2 | `flutter_app/lib/features/dca/presentation/pages/schedule/dca_schedule_analytics_page.dart` |
| P2_visual_density_review | 12 | earn_savings | SavingsHistoryPage | `AppRoutePaths.earnSavingsHistory` | body B; few dense sections/cards=1 | `flutter_app/lib/features/earn_savings/presentation/pages/savings/savings_history_page.dart` |
| P2_visual_density_review | 12 | enterprise_states | ForceUpdateGatePage | `AppRoutePaths.forceUpdateGate` | body B; few dense sections/cards=0 | `flutter_app/lib/features/enterprise_states/presentation/pages/force_update_gate_page.dart` |
| P2_visual_density_review | 12 | enterprise_states | MaintenanceGatePage | `AppRoutePaths.maintenanceGate` | body B; few dense sections/cards=0 | `flutter_app/lib/features/enterprise_states/presentation/pages/maintenance_gate_page.dart` |
| P2_visual_density_review | 12 | markets | PriceAlertsPage | `AppRoutePaths.marketsAlerts` | body B; few dense sections/cards=1 | `flutter_app/lib/features/markets/presentation/pages/portfolio/price_alerts_page.dart` |
| P2_visual_density_review | 12 | markets | WatchlistPage | `AppRoutePaths.marketsWatchlist` | body B; few dense sections/cards=1 | `flutter_app/lib/features/markets/presentation/pages/hub/watchlist_page.dart` |
| P2_visual_density_review | 12 | p2p_dispute | P2PDisputeResolutionPage | `'/p2p/dispute/resolution/:disputeId'` | body B; few dense sections/cards=1 | `flutter_app/lib/features/p2p_dispute/presentation/pages/dispute/p2p_dispute_resolution_page.dart` |
| P2_visual_density_review | 12 | p2p_marketplace | P2PNotificationsSettingsPage | `AppRoutePaths.p2pSettingsNotifications` | body B; few dense sections/cards=1 | `flutter_app/lib/features/p2p_marketplace/presentation/pages/hub/p2p_notifications_settings_page.dart` |
| P2_visual_density_review | 12 | p2p_orders | P2POrderTimelinePage | `'/p2p/order/timeline/:orderId'` | body B; few dense sections/cards=2 | `flutter_app/lib/features/p2p_orders/presentation/pages/orders/p2p_order_timeline_page.dart` |
| P2_visual_density_review | 12 | p2p_security | P2PAmlScreeningPage | `AppRoutePaths.p2pComplianceAmlScreening` | body B; few dense sections/cards=2 | `flutter_app/lib/features/p2p_security/presentation/pages/security/p2p_aml_screening_page.dart` |
| P2_visual_density_review | 12 | p2p_security | P2PComplianceOverviewPage | `AppRoutePaths.p2pComplianceOverview` | body B; few dense sections/cards=1 | `flutter_app/lib/features/p2p_security/presentation/pages/security/p2p_compliance_overview_page.dart` |
| P2_visual_density_review | 12 | p2p_security | P2PLargeTransactionJustificationPage | `AppRoutePaths.p2pComplianceLargeTransaction` | body B; few dense sections/cards=1 | `flutter_app/lib/features/p2p_security/presentation/pages/security/p2p_large_transaction_justification_page.dart` |
| P2_visual_density_review | 12 | p2p_security | P2PRiskAssessmentPage | `AppRoutePaths.p2pComplianceRiskAssessment` | body B; few dense sections/cards=1 | `flutter_app/lib/features/p2p_security/presentation/pages/security/p2p_risk_assessment_page.dart` |
| P2_visual_density_review | 12 | p2p_security | P2PSourceOfFundsPage | `AppRoutePaths.p2pComplianceSourceOfFunds` | body B; few dense sections/cards=1 | `flutter_app/lib/features/p2p_security/presentation/pages/security/p2p_source_of_funds_page.dart` |
| P2_visual_density_review | 12 | predictions | PredictionsSearchPage | `AppRoutePaths.marketsPredictionsSearch` | body B; few dense sections/cards=1 | `flutter_app/lib/features/predictions/presentation/pages/hub/predictions_search_page.dart` |
| P2_visual_density_review | 12 | profile | EditProfilePage | `AppRoutePaths.profileEdit` | body B; few dense sections/cards=2 | `flutter_app/lib/features/profile/presentation/pages/edit_profile_page.dart` |
| P2_visual_density_review | 12 | referral | ReferralFriendDetailPage | `'/referral/friend/:friendId'` | body B; few dense sections/cards=0 | `flutter_app/lib/features/referral/presentation/pages/referral_friend_detail_page.dart` |
| P2_visual_density_review | 12 | referral | ReferralHistoryPage | `AppRoutePaths.referralHistory` | body B; few dense sections/cards=2 | `flutter_app/lib/features/referral/presentation/pages/referral_history_page.dart` |
| P2_visual_density_review | 12 | support | AnnouncementsPage | `AppRoutePaths.supportAnnouncements` | body B; few dense sections/cards=1 | `flutter_app/lib/features/support/presentation/pages/announcements_page.dart` |
| P2_visual_density_review | 12 | trade | TradePage | `AppRoutePaths.trade` | body B; few dense sections/cards=0 | `flutter_app/lib/features/trade/presentation/phone/pages/trade_page.dart` |
| P2_visual_density_review | 12 | trade | TradePage | `'/trade/:pairId'` | body B; few dense sections/cards=0 | `flutter_app/lib/features/trade/presentation/phone/pages/trade_page.dart` |
| P2_visual_density_review | 12 | trade_bots | BotFaqPage | `AppRoutePaths.tradeBotFaq` | body B; few dense sections/cards=1 | `flutter_app/lib/features/trade_bots/presentation/pages/settings/bot_faq_page.dart` |
| P1_fullscreen_tool_visual_qa | 12 | trade_bots | TradingBotsPage | `AppRoutePaths.tradeBots` | body Tool | `flutter_app/lib/features/trade_bots/presentation/pages/hub/trading_bots_page.dart` |
| P2_visual_density_review | 12 | trade_compliance | ComplaintTrackingPage | `AppRoutePaths.tradeCopyComplaintTrackingBase` | body B; few dense sections/cards=1 | `flutter_app/lib/features/trade_compliance/presentation/pages/complaints/complaint_tracking_page.dart` |
| P2_visual_density_review | 12 | trade_compliance | ComplaintTrackingPage | `'/trade/copy-trading/complaint-tracking/:complaintId'` | body B; few dense sections/cards=1 | `flutter_app/lib/features/trade_compliance/presentation/pages/complaints/complaint_tracking_page.dart` |
| P2_visual_density_review | 12 | trade_compliance | LiveMarketDataAnalyticsPage | `AppRoutePaths.tradeMarginLiveMarketDataAnalytics` | body B; few dense sections/cards=0 | `flutter_app/lib/features/trade_compliance/presentation/pages/execution/live_market_data_analytics_page.dart` |
| P2_visual_density_review | 12 | trade_compliance | TargetMarketDefinitionPage | `'${AppRoutePaths.tradeCopyTargetMarketDefinition}/:productId'` | body B; few dense sections/cards=1 | `flutter_app/lib/features/trade_compliance/presentation/pages/governance/target_market_definition_page.dart` |
| P2_visual_density_review | 12 | trade_compliance | TargetMarketDefinitionPage | `AppRoutePaths.tradeCopyTargetMarketDefinition` | body B; few dense sections/cards=1 | `flutter_app/lib/features/trade_compliance/presentation/pages/governance/target_market_definition_page.dart` |
| P2_visual_density_review | 12 | trade_copy | TraderProfilePage | `'/trade/trader/:traderId'` | body B; few dense sections/cards=1 | `flutter_app/lib/features/trade_copy/presentation/pages/provider/trader_profile_page.dart` |
| P2_visual_density_review | 12 | wallet | WalletMultiManagerPage | `AppRoutePaths.walletMultiManager` | body B; few dense sections/cards=0 | `flutter_app/lib/features/wallet/presentation/pages/tools/wallet_multi_manager_page.dart` |
| P2_visual_density_review | 11 | profile | ProfilePage | `AppRoutePaths.profile` | body B | `flutter_app/lib/features/profile/presentation/phone/pages/profile_page.dart` |
| P2_visual_density_review | 10 | profile | SettingsPage | `AppRoutePaths.profileSettings` | body B | `flutter_app/lib/features/profile/presentation/pages/settings_page.dart` |
| P2_visual_density_review | 10 | profile | SubAccountPage | `AppRoutePaths.profileSubAccounts` | body B | `flutter_app/lib/features/profile/presentation/pages/sub_account_page.dart` |
| P3_followup_review | 9 | auth | LoginPage | `AppRoutePaths.authLogin` | body B; few dense sections/cards=0 | `flutter_app/lib/features/auth/presentation/phone/pages/login_page.dart` |
| P3_followup_review | 9 | profile | SecurityPage | `AppRoutePaths.profileSecurity` | body B | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |
| P3_followup_review | 9 | profile | SecurityPage | `AppRoutePaths.settingsSecurity` | body B | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |
| P3_followup_review | 9 | profile | SecurityPage | `AppRoutePaths.settingsSecurityChangePassword` | body B | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |
| P3_followup_review | 9 | profile | SecurityPage | `AppRoutePaths.settingsSecurityBiometric` | body B | `flutter_app/lib/features/profile/presentation/pages/security_page.dart` |
| P3_followup_review | 9 | wallet | WalletPage | `AppRoutePaths.wallet` | body B | `flutter_app/lib/features/wallet/presentation/phone/pages/wallet_page.dart` |
| P3_followup_review | 8 | admin | ABTestDashboardPage | `AppRoutePaths.adminAbtests` | body B | `flutter_app/lib/features/admin/presentation/pages/ab_test_dashboard_page.dart` |
| P3_followup_review | 8 | admin | AnalyticsDashboardPage | `AppRoutePaths.adminAnalytics` | body B | `flutter_app/lib/features/admin/presentation/pages/analytics_dashboard_page.dart` |
| P3_followup_review | 8 | admin | FunnelDashboardPage | `AppRoutePaths.adminFunnels` | body B | `flutter_app/lib/features/admin/presentation/pages/funnel_dashboard_page.dart` |
| P3_followup_review | 8 | home | HomePage | `AppRoutePaths.home` | body B | `flutter_app/lib/features/home/presentation/phone/pages/home_page.dart` |
| P3_followup_review | 8 | p2p_security | P2PAchievementsPage | `AppRoutePaths.p2pAchievements` | body B | `flutter_app/lib/features/p2p_security/presentation/pages/security/p2p_achievements_page.dart` |
| P3_followup_review | 8 | p2p_security | P2PTaxReportingPage | `'/p2p/tax-report/detailed/:year'` | body B | `flutter_app/lib/features/p2p_security/presentation/pages/security/p2p_tax_reporting_page.dart` |
| P3_followup_review | 8 | p2p_security | P2PTaxReportingPage | `AppRoutePaths.p2pTaxReporting` | body B | `flutter_app/lib/features/p2p_security/presentation/pages/security/p2p_tax_reporting_page.dart` |
| P3_followup_review | 8 | predictions | PredictionEventDetailPage | `'/markets/predictions/event/:eventId'` | body B | `flutter_app/lib/features/predictions/presentation/pages/event/prediction_event_detail_page.dart` |
| P3_followup_review | 8 | profile | ActivityLogPage | `AppRoutePaths.profileActivity` | body B | `flutter_app/lib/features/profile/presentation/pages/activity_log_page.dart` |
| P3_followup_review | 8 | wallet | AssetDetailPage | `'/wallet/asset/:assetId'` | body B | `flutter_app/lib/features/wallet/presentation/pages/assets/asset_detail_page.dart` |
| P3_followup_review | 8 | wallet | DustConverterPage | `AppRoutePaths.walletDustConverter` | body B | `flutter_app/lib/features/wallet/presentation/pages/assets/dust_converter_page.dart` |
| P3_followup_review | 8 | wallet | NetworkStatusPage | `AppRoutePaths.walletNetworkStatus` | body B | `flutter_app/lib/features/wallet/presentation/pages/tools/network_status_page.dart` |
| P3_followup_review | 8 | wallet | PortfolioAnalyticsPage | `AppRoutePaths.walletPortfolioAnalytics` | body B | `flutter_app/lib/features/wallet/presentation/pages/tools/portfolio_analytics_page.dart` |
