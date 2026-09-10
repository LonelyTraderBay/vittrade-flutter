import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

final class P2PSpacingTokens {
  const P2PSpacingTokens._();

  static EdgeInsets p2pDashboardScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x5,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pDashboardPageScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pDashboardFilterChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pDashboardCompactCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pDashboardCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const double p2pDashboardMetricRowGap = AppSpacing.x3;

  static const double p2pDashboardDonutSize = 94;
  static const double p2pDashboardAssetSwatch = 10;
  static const EdgeInsets p2pDashboardAssetLinePadding = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );

  static const EdgeInsets p2pDashboardQuickActionPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const double p2pDashboardIconBubbleSmallIcon = 16;
  static const double p2pDashboardTrendIcon = 11;
  static const double p2pDashboardMerchantStar = 12;
  static const EdgeInsets p2pDashboardMerchantPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pDashboardActivityPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets p2pDashboardTextLinkPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const double p2pDashboardMonthlyBarWidth = AppSpacing.x3;
  static const double p2pDashboardMonthlyBarMinHeight = 6;

  static EdgeInsets p2pMarketplaceAnalyticsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pMarketplaceAnalyticsCompactPadding =
      EdgeInsets.all(AppSpacing.x3);

  static const EdgeInsets p2pMarketplaceAnalyticsTableCellPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x2);

  static const double p2pMarketplaceAnalyticsIdentityHeight =
      AppSpacing.x7 + AppSpacing.x3;
  static const double p2pMarketplaceAnalyticsMetricCardHeight =
      AppSpacing.buttonHero + AppSpacing.x4 + AppSpacing.x3;
  static const double p2pMarketplaceAnalyticsQuickStatsHeight =
      AppSpacing.x7 + AppSpacing.x6;

  static const double p2pMarketplaceAnalyticsLegendDot = AppSpacing.x3;

  static const double p2pMarketplaceAnalyticsDividerHeight =
      WalletSpacingTokens.walletHistoryDividerHeight;
  static const double p2pMarketplaceAnalyticsChartLargeHeight =
      AppSpacing.buttonHero * 2;
  static const double p2pMarketplaceAnalyticsChartTallHeight =
      AppSpacing.x7 * 3;
  static const double p2pMarketplaceAnalyticsRadarHeight =
      AppSpacing.buttonHero * 2 + AppSpacing.x6;
  static const double p2pMarketplaceAnalyticsTightLineHeight = 1;
  static const double p2pMarketplaceAnalyticsBodyLineHeight = 1.6;

  static EdgeInsets p2pHomeScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pHomeOfflinePadding = EdgeInsets.only(
    bottom: AppSpacing.x3,
  );
  static const EdgeInsets p2pHomeCardPadding = EdgeInsets.all(AppSpacing.x3);

  static const EdgeInsets p2pHomeClearFilterPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );

  static const double p2pHomeTinyIcon = 11;
  static const double p2pHomeSmallIcon = 12;
  static const double p2pHomeVerifiedIcon = AppSpacing.x4;
  static const double p2pHomeInlineIcon = 14;

  static EdgeInsets p2pE2EScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );

  static EdgeInsets p2pAddressProofScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pAddressProofCardPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsetsDirectional p2pAddressProofHeroIconPadding =
      EdgeInsetsDirectional.all(AppSpacing.x2);
  static const EdgeInsetsDirectional p2pAddressProofUploadVerticalPadding =
      EdgeInsetsDirectional.symmetric(vertical: AppSpacing.x3);
  static const EdgeInsets p2pAddressProofDocumentExamplePadding =
      EdgeInsets.only(left: AppSpacing.buttonCompact + AppSpacing.x2);
  static const EdgeInsets p2pAddressProofExamplePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets p2pAddressProofChecklistIconPadding = EdgeInsets.only(
    top: AppSpacing.dividerHairline,
  );
  static const EdgeInsets p2pAddressProofActionHorizontalPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3);
  static const EdgeInsetsDirectional p2pAddressProofExampleTilePadding =
      EdgeInsetsDirectional.all(AppSpacing.x2);
  static const EdgeInsetsDirectional p2pAddressProofUploadIconPadding =
      EdgeInsetsDirectional.all(AppSpacing.x3);
  static const double p2pAddressProofReadableLineHeight = 1.35;
  static const double p2pAddressProofChecklistIcon = p2pHomeVerifiedIcon;
  static const double p2pKycBottomInsetVisual = AppSpacing.x4;
  static const double p2pKycBottomInsetNative = AppSpacing.x4;
  static EdgeInsets p2pKycScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pKycStatusScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double p2pKycContentGap = 0;

  static const EdgeInsets p2pKycCompactCardPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets p2pKycNoticePadding = EdgeInsets.all(AppSpacing.x2);

  static const EdgeInsetsDirectional p2pKycRequirementsCardPadding =
      EdgeInsetsDirectional.all(AppSpacing.x3);
  static const EdgeInsetsDirectional p2pKycRequirementsNoticePadding =
      EdgeInsetsDirectional.all(AppSpacing.x3);
  static const EdgeInsetsDirectional p2pKycRequirementsTierSectionPadding =
      EdgeInsetsDirectional.all(AppSpacing.x3);
  static const EdgeInsetsDirectional p2pKycRequirementsTierActionPadding =
      EdgeInsetsDirectional.fromSTEB(
        AppSpacing.x3,
        AppSpacing.zero,
        AppSpacing.x3,
        AppSpacing.x3,
      );
  static const EdgeInsetsDirectional p2pKycRequirementsChecklistIconPadding =
      EdgeInsetsDirectional.only(top: AppSpacing.x1);
  static EdgeInsetsDirectional p2pKycRequirementsScrollPadding(
    double bottomInset,
  ) => EdgeInsetsDirectional.fromSTEB(
    AppSpacing.contentPad,
    AppSpacing.x3,
    AppSpacing.contentPad,
    bottomInset,
  );

  static const EdgeInsets p2pKycInlineActionPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x2,
  );

  static const EdgeInsets p2pKycStatusTimelineRowPadding = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );
  static const double p2pKycReadableLineHeight = 1.35;

  static const double p2pKycTimelineMetaIcon = p2pHomeTinyIcon;
  static const double p2pKycTimelineNodeBorder = AppSpacing.hairlineStroke;
  static const double p2pKycTimelineLineWidth = AppSpacing.hairlineStroke;

  static EdgeInsets p2pClaimScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pClaimHeroPadding = EdgeInsets.all(AppSpacing.x5);
  static const EdgeInsets p2pClaimCardPadding = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets p2pClaimCompactCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pClaimInfoRowPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pClaimActionPadding = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets p2pClaimChecklistPadding = EdgeInsets.only(
    bottom: AppSpacing.x1,
  );
  static EdgeInsets p2pClaimTimelineRowPadding(bool isLast) =>
      EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x4, top: AppSpacing.x1);
  static const double p2pClaimProgressLineHeight = AppSpacing.x1;
  static const double p2pClaimReasonLabelWidth = 72;
  static const double p2pClaimBodyLineHeight = 1.45;
  static const double p2pClaimDescriptionLineHeight = 1.55;
  static const double p2pClaimInlineIcon = p2pHomeSmallIcon;
  static const double p2pClaimSmallIcon = p2pHomeVerifiedIcon;
  static const double p2pClaimBenchmarkIcon = 15;
  static const double p2pClaimFeedbackIcon = 18;
  static const double p2pClaimTimelineNodeSize = AppSpacing.x7;
  static const double p2pClaimTimelineNodeIcon = 15;
  static const double p2pClaimTimelineConnectorWidth =
      AppSpacing.dividerHairline;
  static const double p2pClaimTimelineConnectorHeight = AppSpacing.x6;

  static EdgeInsets p2pBlacklistScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static EdgeInsets p2pBlacklistFormScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pBlacklistHorizontalPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
  );

  static const EdgeInsets p2pBlacklistFilterRailPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
  );

  static const EdgeInsets p2pBlacklistSmallReasonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );

  static const double p2pBlacklistReadableLineHeight = 1.35;

  static const EdgeInsetsDirectional p2pBlacklistListCardPadding =
      EdgeInsetsDirectional.all(AppSpacing.x2);
  static const EdgeInsetsDirectional p2pBlacklistListTinyPadding =
      EdgeInsetsDirectional.all(AppSpacing.x2);
  static const EdgeInsets p2pBlacklistListSummaryPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    0,
    AppSpacing.contentPad,
    AppSpacing.x1,
  );
  static const EdgeInsets p2pBlacklistListResultPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x1,
    AppSpacing.contentPad,
    0,
  );
  static const EdgeInsets p2pBlacklistListFilterChipPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: AppSpacing.x1);
  static EdgeInsets p2pBlacklistAddScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double p2pMerchantApplyBottomInsetVisual = AppSpacing.x5;
  static const double p2pMerchantApplyBottomInsetNative = AppSpacing.x4;
  static EdgeInsets p2pMerchantApplyScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x5,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pMerchantApplyProgressPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x4,
    AppSpacing.contentPad,
    AppSpacing.x3,
  );
  static const EdgeInsets p2pMerchantApplyConnectorPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2);

  static const EdgeInsets p2pMerchantApplyInfoPadding = EdgeInsets.all(
    AppSpacing.x3,
  );

  static const EdgeInsets p2pMerchantApplyInputPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets p2pMerchantApplyCheckboxMargin = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const EdgeInsets p2pMerchantApplyRowPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const double p2pMerchantApplyConnectorHeight = 2;
  static const double p2pMerchantApplyStepDotSize = 24;
  static const double p2pMerchantApplyIconBadgeSize = 32;
  static const double p2pMerchantApplyLargeIconBadgeSize = 48;
  static const double p2pMerchantApplyStatusIconSize = 28;
  static const int p2pMerchantApplyBenefitCrossAxisCount = 2;
  static const double p2pMerchantApplyBenefitMainAxisExtent = 112;
  static const double p2pMerchantApplyReadableLineHeight = 1.55;
  static const double p2pMerchantApplyCompactLineHeight = 1.35;
  static const double p2pMerchantApplyTightLineHeight = 1;

  static EdgeInsets p2pChatHeaderPadding(double topInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        topInset + AppSpacing.x3,
        AppSpacing.contentPad,
        AppSpacing.x3,
      );
  static const EdgeInsets p2pChatRiskBannerPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets p2pChatBannerPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
    vertical: AppSpacing.x3,
  );

  static const EdgeInsets p2pChatDatePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
  );
  static const EdgeInsets p2pChatMessageBottomPadding = EdgeInsets.only(
    bottom: AppSpacing.x4,
  );
  static const EdgeInsets p2pChatSystemMessagePadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pChatMessagePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static EdgeInsets p2pChatComposerBottomPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets p2pChatQuickReplyRailPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets p2pChatComposerInputPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x2,
    AppSpacing.contentPad,
    AppSpacing.x3,
  );
  static const EdgeInsets p2pChatComposerLabelPadding = EdgeInsets.only(
    left: AppSpacing.x3,
  );
  static const EdgeInsets p2pChatReplyChipOuterPadding = EdgeInsets.only(
    right: AppSpacing.x2,
  );

  static const double p2pChatHeaderAvatarRadius = 18;
  static const double p2pChatMerchantAvatarRadius = 14;
  static const double p2pChatOnlineBadgeSize = 9;
  static const double p2pChatOnlineBadgeOffset = -1;
  static const double p2pChatOnlineBadgeBorder = 2;
  static const double p2pChatSystemMessageMaxWidth = 340;
  static const double p2pChatMessageMaxWidth = 300;
  static const double p2pChatTinyIcon = 10;
  static const double p2pChatCloseIcon = AppSpacing.x4;
  static const double p2pChatReadIcon = 12;
  static const double p2pChatRoundIconButtonSize = 40;

  static EdgeInsets p2pExpressScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pExpressCompactCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pExpressSelectorPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pExpressEscrowPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pExpressHowStepPadding = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );
  static const EdgeInsets p2pExpressMerchantRowPadding = EdgeInsets.only(
    bottom: AppSpacing.x3,
  );
  static const EdgeInsets p2pExpressSmallChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const double p2pExpressAmountBorderWidth = 2;

  static const EdgeInsets p2pExpressTightCardPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets p2pExpressChoiceChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );
  static EdgeInsets p2pExpressConfirmScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pExpressConfirmCompactCardPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static EdgeInsets p2pAdDetailScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pAdDetailFlushScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pAdDetailFooterPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets p2pAdDetailCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets p2pAdDetailCompactCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pAdDetailInputPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
  );
  static const EdgeInsets p2pAdDetailPercentPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets p2pAdDetailSignalChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );

  static const double p2pAdDetailOnlineBadgeSize = AppSpacing.x4;
  static const double p2pAdDetailOnlineBadgeBorder = 2;

  static EdgeInsets p2pSettingsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pSettingsSwitchPadding = EdgeInsets.all(2);

  static EdgeInsets p2pSettingsPageScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pSettingsPageCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pSettingsPageCompactCardPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets p2pSettingsPageHorizontalCardPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2);
  static const EdgeInsets p2pSettingsPageRowPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static EdgeInsets p2pTwoFactorScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pTwoFactorCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pTwoFactorInnerPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static EdgeInsets p2pDevicesScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pDevicesCardPadding = EdgeInsets.all(AppSpacing.x3);
  static const EdgeInsets p2pDevicesInnerPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static EdgeInsets p2pNotificationsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pNotificationsCardPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsetsGeometry p2pNotificationsChannelPadding =
      EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x3,
      );
  static EdgeInsets p2pTaxScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pTaxCardPadding = EdgeInsets.all(AppSpacing.x3);
  static EdgeInsets p2pTradingLevelScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pTradingLevelHeroHeaderPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pTradingLevelHeroBodyPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pTradingLevelMetricPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pTradingLevelNextCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pTradingLevelCardHeaderPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pTradingLevelCardBodyPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pTradingLevelLimitPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const double p2pTradingLevelHeroBadgeSize = 44;
  static const double p2pTradingLevelLevelBadgeSize = 40;

  static const double p2pTradingLevelMetricIconSize = 20;
  static const double p2pTradingLevelMetricGlyphSize = 12;
  static const double p2pTradingLevelInlineIcon = 15;
  static const double p2pTradingLevelRequirementIcon = 14;

  static const double p2pTradingLevelDailyTrackHeight = 6;
  static const double p2pTradingLevelNextTrackHeight = 6;
  static const double p2pTradingLevelBadgeIconScale = 0.48;
  static const double p2pTradingLevelBadgeElevation = 2;
  static const double p2pTradingLevelTitleLineHeight = 1.15;
  static const double p2pTradingLevelMicroLineHeight = 1.15;
  static const double p2pTradingLevelRequirementLineHeight = 1.35;
  static const double p2pTradingLevelUpgradeButtonHeight = 36;
  static EdgeInsets p2pGuideScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pGuideTabsPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x3,
    AppSpacing.contentPad,
    0,
  );

  static const EdgeInsets p2pGuideCardPadding = EdgeInsets.all(AppSpacing.x3);

  static const EdgeInsets p2pGuideStepContentPadding = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const EdgeInsets p2pGuideSafetyTipPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pGuideVideoEmptyPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pGuideVideoCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pGuideConceptPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );

  static const double p2pGuidePillLineHeight = 1;
  static const double p2pGuideThumbWidth = AppSpacing.x6;

  static EdgeInsets p2pSelfieScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pSelfieReviewPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets p2pSelfieCardPadding = EdgeInsets.all(AppSpacing.x3);
  static const EdgeInsets p2pSelfieLargeCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets p2pSelfieResultIconMargin = EdgeInsets.symmetric(
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets p2pSelfieScoreRowPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pSelfieChecklistIconPadding = EdgeInsets.only(
    top: AppSpacing.x1,
  );

  static const double p2pSelfieSampleAspectRatio = 4 / 3;
  static const double p2pSelfieCaptureAspectRatio = 3 / 4;
  static const double p2pSelfieLivenessGridAspectRatio = 1.2;

  static const double p2pSelfieChecklistIconSize = AppSpacing.iconSm;
  static const int p2pSelfieLivenessGridColumns = 2;
  static EdgeInsets p2pVideoScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pVideoCardPadding = EdgeInsets.all(AppSpacing.x3);
  static const EdgeInsets p2pVideoCompactCardPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static EdgeInsets p2pRiskAssessmentScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pRiskAssessmentCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pRiskAssessmentInnerPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static EdgeInsets p2pLimitTrackerScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pLimitTrackerCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pLimitTrackerCompactPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets p2pLimitTrackerMetricPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pLimitTrackerPeriodTabPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: AppSpacing.x2);
  static EdgeInsets p2pAmlScreeningScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pAmlScreeningCardPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static EdgeInsets p2pComplianceOverviewScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsetsDirectional p2pComplianceOverviewItemPadding =
      EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      );
  static EdgeInsets p2pSourceOfFundsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pSuspiciousActivityScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pLargeTransactionScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pInsuranceScoreScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const double p2pInsuranceScoreFactorRailIndent = 46;

  static EdgeInsets p2pEscrowDetailScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pEscrowDetailHeroPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pEscrowDetailCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pEscrowDetailInnerPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets p2pEscrowDetailExplorerPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pEscrowDetailInfoRowPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pEscrowDetailTimelineRowPadding = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );
  static const double p2pEscrowDetailSignatureStroke = AppSpacing.x1;
  static const double p2pEscrowDetailTimelineIcon = 14;

  static EdgeInsets p2pEscrowBalanceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pEscrowBalanceLargePadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pEscrowBalanceCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pEscrowBalanceInnerPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static EdgeInsets p2pMyOrdersScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pMyOrdersStatPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pMyOrdersCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );

  static const EdgeInsets p2pMyOrdersLargePadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets p2pMyOrdersChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets p2pOrderBookCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pOrderBookCompactPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets p2pOrderBookSelectorPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pOrderBookRowPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
  );
  static EdgeInsets p2pOrderBookScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pFraudScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pFraudCardPadding = EdgeInsets.all(AppSpacing.x3);
  static const EdgeInsets p2pFraudInnerPadding = EdgeInsets.all(AppSpacing.x2);
  static const EdgeInsets p2pFraudPatternPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pFraudCategoryTabPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pFraudChecklistItemPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const double p2pFraudProgressHeight = AppSpacing.x2;
  static const double p2pFraudHeaderIcon = AppSpacing.iconMd;
  static const double p2pFraudActionIcon = AppSpacing.iconSm;
  static const double p2pFraudChecklistBox = 22;
  static const double p2pFraudChecklistCheckIcon = 14;
  static const double p2pFraudDetailIcon = AppSpacing.x4;

  static EdgeInsets p2pSecurityCenterScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pSecurityCenterNoticePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets p2pSecurityCenterViewAllPadding =
      EdgeInsets.symmetric(vertical: AppSpacing.x3, horizontal: AppSpacing.x4);

  static const double p2pSecurityCenterScoreStroke = 7;
  static const double p2pSecurityCenterIconBox = 40;
  static const double p2pSecurityCenterTimeIcon = 11;
  static const int p2pSecurityCenterQuickActionCrossAxisCount = 2;
  static const double p2pSecurityCenterQuickActionAspectRatio = 1.66;
  static const double p2pSecurityCenterLabelLineHeight = 1.3;
  static const double p2pSecurityCenterCompactLineHeight = 1.35;
  static const double p2pSecurityCenterBodyLineHeight = 1.45;
  static const double p2pSecurityCenterNumberLineHeight = 1;
  static EdgeInsets p2pLoginHistoryScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pLoginHistoryPageScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pAchievementsPageScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pFundLockScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pContributionScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pLoginHistoryNoticePadding = EdgeInsets.all(
    AppSpacing.x3,
  );

  static const EdgeInsets p2pLoginHistoryEmptyPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x7,
  );
  static const double p2pLoginHistoryIconBox = AppSpacing.inputHeight;
  static const double p2pLoginHistoryEventIcon = 22;
  static const double p2pLoginHistoryMetaIcon = 11;

  static const double p2pLoginHistoryTrailingMaxWidth = 92;
  static const double p2pLoginHistoryExpandIcon = 16;

  static EdgeInsets p2pTransactionLimitsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pTransactionLimitsCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pTransactionLimitsInnerPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets p2pTransactionLimitsBadgePadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x2);
  static const EdgeInsets p2pTransactionLimitsTrackerPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2);

  static EdgeInsets p2pTransactionLimitsUsageItemPadding(bool isLast) =>
      EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x4);
  static const double p2pTransactionLimitsIconBox = AppSpacing.inputHeight;
  static const double p2pTransactionLimitsDetailIcon = 20;
  static const double p2pTransactionLimitsRequirementIcon = AppSpacing.iconSm;

  static EdgeInsets p2pSecurityDetailsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pSecurityDetailsInnerPadding = EdgeInsets.all(
    AppSpacing.x3,
  );

  static const EdgeInsets p2pSecurityDetailsActionPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x3);
  static const EdgeInsets p2pSecurityDetailsEditPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static EdgeInsets p2pSecurityDetailsDeviceActionPadding(bool compact) =>
      EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.x4 : AppSpacing.x3,
        vertical: AppSpacing.x3,
      );
  static const EdgeInsets p2pSecurityDetailsBulletPadding = EdgeInsets.only(
    top: 7,
  );

  static const double p2pSecurityDetailsIconActionBox = 32;
  static const double p2pSecurityDetailsDeviceIcon = 24;
  static const double p2pSecurityDetailsTinyIcon = 14;
  static const double p2pSecurityDetailsMetaIcon = 11;
  static const double p2pSecurityDetailsInlineIcon = 12;
  static const double p2pSecurityDetailsCheckIcon = AppSpacing.x4;
  static const double p2pSecurityDetailsSmallBullet = 4;
  static const double p2pSecurityDetailsBullet = AppSpacing.x2;

  static EdgeInsets p2pRiskControlsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pRiskControlsReportScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x5,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pRiskControlsBottomScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);

  static const EdgeInsets p2pRiskControlsInnerPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pRiskControlsActionPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets p2pRiskControlsReasonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );

  static const EdgeInsets p2pRiskControlsSummaryRowPadding =
      EdgeInsets.symmetric(vertical: AppSpacing.x2);

  static const EdgeInsets p2pRiskControlsDetailBottomPadding = EdgeInsets.only(
    bottom: AppSpacing.x4,
  );

  static const double p2pRiskControlsAvatarSize = 48;

  static const double p2pRiskControlsReasonIconBox = 36;

  static const double p2pRiskControlsInfoIcon = 16;
  static const double p2pRiskControlsNoticeIcon = 14;
  static const double p2pRiskControlsReasonIcon = 16;

  static const double p2pRiskControlsOrderHeroMaxWidth = 280;

  static const double p2pRiskControlsNoticeLineHeight = 1.55;
  static EdgeInsets p2pDocumentScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pDocumentInfoRowPadding(double bottomGap) =>
      EdgeInsets.only(bottom: bottomGap);

  static const EdgeInsets p2pDocumentDownloadPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );

  static const EdgeInsets p2pDocumentBulletTopPadding = EdgeInsets.only(
    top: AppSpacing.x3,
  );

  static const double p2pDocumentHeroIconBox = AppSpacing.x7;
  static const double p2pDocumentBullet = AppSpacing.x2;
  static const double p2pDocumentTinyIcon = AppSpacing.x4;

  static const double p2pDocumentSmallIcon = 15;
  static const double p2pDocumentInlineIcon = 16;
  static const double p2pDocumentRowIcon = 17;
  static const double p2pDocumentCalloutIcon = 18;

  static const double p2pDocumentPrivacyLineHeight = 1.5;

  static EdgeInsets p2pInsuranceCertificateScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pInsuranceCertificateLargePadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pInsuranceCertificateCardPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets p2pInsuranceCertificateHeroPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pInsuranceCertificateDividerPadding =
      EdgeInsets.only(bottom: AppSpacing.x2);
  static const EdgeInsets p2pInsuranceCertificateBulletPadding =
      EdgeInsets.only(top: AppSpacing.x2);
  static const double p2pInsuranceCertificateBodyLineHeight = 1.35;
  static const EdgeInsets p2pInsuranceFundTourSkipPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x4);
  static EdgeInsets p2pFinancialSafetyScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pFinancialSafetyBottomPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets p2pFinancialSafetyHorizontalPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.contentPad);

  static const EdgeInsets p2pFinancialSafetyCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets p2pFinancialSafetyInnerPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pFinancialSafetyTilePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
  );

  static const double p2pFinancialSafetyIconBox = AppSpacing.inputHeight;
  static const double p2pFinancialSafetyCompactIconBox =
      AppSpacing.buttonCompact;

  static const double p2pFinancialSafetyProofThumb =
      AppSpacing.x7 + AppSpacing.x6;

  static const double p2pFinancialSafetyTinyIcon = 12;
  static const double p2pFinancialSafetyBodyLineHeight = 1.45;
  static EdgeInsets p2pMerchantCommerceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pMerchantCommerceRelaxedScrollPadding(
    double bottomInset,
  ) => EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x5,
    AppSpacing.contentPad,
    bottomInset,
  );
  static EdgeInsets p2pMerchantCommerceFooterPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets p2pMerchantCommerceSectionLabelPadding =
      EdgeInsets.only(bottom: AppSpacing.x2);
  static const EdgeInsets p2pMerchantCommerceCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets p2pMerchantCommerceCompactPadding = EdgeInsets.all(
    AppSpacing.x3,
  );

  static const EdgeInsets p2pMerchantCommerceChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pMerchantCommerceWideChipPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x4, vertical: AppSpacing.x2);
  static const EdgeInsets p2pMerchantCommerceTextAreaPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x4);
  static const EdgeInsets p2pMerchantCommerceQuickLinkPadding =
      EdgeInsets.symmetric(vertical: AppSpacing.x2);
  static const EdgeInsets p2pMerchantCommerceDetailRightPadding =
      EdgeInsets.only(right: AppSpacing.x2);
  static const EdgeInsets p2pMerchantCommerceStarPadding = EdgeInsets.only(
    right: AppSpacing.x1,
  );

  static const double p2pMerchantCommerceTextAreaMinHeight =
      AppSpacing.buttonHero + AppSpacing.x6;

  static const double p2pMerchantCommerceConfirmLabelWidth = 76;

  static const double p2pMerchantCommerceAvatarSize = AppSpacing.x6;
  static const double p2pMerchantCommerceMerchantAvatarSize =
      AppSpacing.buttonHero;
  static const EdgeInsets p2pMerchantCommerceOnlineIndicatorPadding =
      EdgeInsets.only(right: AppSpacing.x1, bottom: AppSpacing.x1);
  static const double p2pMerchantCommerceOnlineDot = AppSpacing.x4;
  static const double p2pMerchantCommerceOnlineBorderWidth = 2;

  static const double p2pMerchantCommerceSmallIcon = AppSpacing.x4;
  static const double p2pMerchantCommerceTinyIcon = 10;
  static const double p2pMerchantCommerceDividerHeight =
      WalletSpacingTokens.walletHistoryDividerHeight;

  static const double p2pMerchantCommerceBodyLineHeight = 1.45;
  static const double p2pMerchantCommerceWarningLineHeight = 1.55;
  static EdgeInsets p2pMerchantCommercePageScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pMerchantCommerceInnerPadding = EdgeInsets.all(
    AppSpacing.x2,
  );

  static const EdgeInsets p2pMerchantCommerceWarningPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x2);
  static EdgeInsets p2pTrustProgressScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pTrustProgressRelaxedScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x5,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pTrustProgressTabPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x3,
    AppSpacing.contentPad,
    AppSpacing.x2,
  );
  static const EdgeInsets p2pTrustProgressTourPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x7,
    AppSpacing.contentPad,
    AppSpacing.x5,
  );
  static const EdgeInsets p2pTrustProgressCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets p2pTrustProgressCompactPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pTrustProgressHeroPadding = EdgeInsets.all(
    AppSpacing.x5,
  );
  static const EdgeInsets p2pTrustProgressChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pTrustProgressSummaryMetricPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: AppSpacing.x3);

  static const EdgeInsets p2pTrustProgressInputPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
  );
  static const EdgeInsets p2pTrustProgressInfoRowPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets p2pTrustProgressNotificationRowPadding =
      EdgeInsets.symmetric(vertical: AppSpacing.x2);
  static const EdgeInsets p2pTrustProgressStepPadding = EdgeInsets.only(
    bottom: AppSpacing.x3,
  );
  static const double p2pTrustProgressChartHeight =
      AppSpacing.buttonHero * 1.55;
  static const double p2pTrustProgressInputHeight = AppSpacing.inputHeight;
  static const double p2pTrustProgressTourMaxHeight = 956;
  static const double p2pTrustProgressTourStepHeight = AppSpacing.x1;
  static const double p2pTrustProgressIconBox = 44;
  static const double p2pTrustProgressIconBoxLarge = 56;
  static const double p2pTrustProgressIcon = AppSpacing.x5;
  static const double p2pTrustProgressIconLarge = AppSpacing.x7;
  static const double p2pTrustProgressBadgeSize = AppSpacing.x4 + AppSpacing.x2;
  static const double p2pTrustProgressBadgeInset = -3;
  static const double p2pTrustProgressBadgeBorderWidth = 2;
  static const double p2pTrustProgressBadgeIcon = 10;

  static const double p2pTrustProgressSmallIcon = 18;
  static const double p2pTrustProgressContributionAmountWidth = 112;

  static const double p2pTrustProgressStepRadius = AppSpacing.x3;
  static const double p2pTrustProgressSummaryProgressHeight = AppSpacing.x2;
  static const double p2pTrustProgressCardProgressHeight = 6;
  static const double p2pTrustProgressAmountLineHeight = 1.05;
  static const double p2pTrustProgressBodyLineHeight = 1.45;
  static const double p2pTrustProgressCaptionLineHeight = 1.35;
  static const double p2pTrustProgressDotSize = AppSpacing.x2;

  static EdgeInsets p2pWalletScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pWalletHeroActionPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
  );

  static const EdgeInsets p2pWalletCompactCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pWalletNoticePadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pWalletTextActionPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
  );
  static const EdgeInsets p2pWalletTransferChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets p2pWalletTransferPercentPadding =
      EdgeInsets.symmetric(vertical: AppSpacing.x3);

  static EdgeInsets p2pWalletTransferScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pWalletTransferCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pWalletTransferDirectionSwitchPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2);
  static const EdgeInsets p2pWalletTransferConfirmSummaryPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x4, vertical: AppSpacing.x3);
  static const EdgeInsets p2pWalletTransferAssetChipPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: AppSpacing.x2);
  static const EdgeInsets p2pWalletTransferConfirmHeroPadding =
      EdgeInsets.symmetric(vertical: AppSpacing.x2);

  static const double p2pWalletMetaIcon = 11;
  static const double p2pWalletTransactionIcon = 20;
  static const double p2pWalletInfoIcon = 16;

  static EdgeInsets p2pOrderScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pOrderCompactCardPadding = EdgeInsets.all(
    AppSpacing.x2,
  );

  static const EdgeInsets p2pOrderEscrowActionPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pOrderQrTogglePadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pOrderQrPanelPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets p2pOrderQrInnerPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const double p2pOrderQrSize = 140;
  static const EdgeInsets p2pOrderPaymentFieldPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pOrderTimelineItemPadding = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );

  static const EdgeInsets p2pOrderSmallPillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets p2pOrderSmallButtonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );
  static const EdgeInsets p2pOrderQuickButtonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
  );
  static const EdgeInsets p2pOrderTextActionPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets p2pOrderInlineWarningPadding = EdgeInsets.all(
    AppSpacing.x3,
  );

  static const double p2pOrderStepperConnectorHeight =
      AppSpacing.hairlineStroke;
  static const double p2pOrderTimelineConnectorWidth =
      AppSpacing.hairlineStroke;
  static const double p2pOrderTimelineIcon = 15;
  static const double p2pOrderSmallPillIcon = 11;

  static const double p2pOrderTimelineEventIcon = 18;

  static const double p2pOrderRatingSuccessIconBox =
      AppSpacing.x7 + AppSpacing.x5;
  static EdgeInsets p2pOrderLifecycleScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets p2pOrderRateCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pOrderRateStarChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
  );
  static const EdgeInsets p2pOrderRateTagChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );
  static EdgeInsets p2pOrderTimelineRowPadding({required bool isLast}) =>
      EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x6);

  static const EdgeInsets p2pOrderLifecycleSuccessPadding = EdgeInsets.all(
    AppSpacing.contentPad,
  );

  static EdgeInsets p2pComplianceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pComplianceCardPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets p2pComplianceCompactCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );

  static const EdgeInsets p2pComplianceChecklistIconPadding = EdgeInsets.only(
    top: 2,
  );

  static const double p2pComplianceChecklistIcon = AppSpacing.x4;
  static const double p2pComplianceDismissButton =
      AppSpacing.x6 + AppSpacing.x2;
  static const double p2pComplianceMetaIcon = 11;
  static const double p2pComplianceCalendarIcon = 12;
  static const double p2pComplianceUnavailableIcon = 20;
  static const double p2pComplianceReadableLineHeight = 1.45;

  static EdgeInsets p2pPaymentScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const double p2pPaymentCardGap = AppSpacing.x2;

  static const EdgeInsets p2pPaymentCardPadding = EdgeInsets.all(AppSpacing.x3);
  static const EdgeInsets p2pPaymentCompactCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );

  static const double p2pPaymentVerifiedIcon = AppSpacing.x4;

  static EdgeInsets p2pPaymentAddScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );

  static EdgeInsets p2pPaymentFooterPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);

  static const double p2pPaymentHeroIcon = 28;
  static const double p2pPaymentMetaIcon = 11;
  static const double p2pPaymentChevronIcon = 20;
  static const double p2pPaymentVerificationIntroIconBox = 64;
  static const double p2pPaymentVerificationIntroIcon = 32;
  static const double p2pPaymentVerificationStepDot = 24;
  static const EdgeInsets p2pPaymentMethodsListCardPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets p2pPaymentMethodsListButtonPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: AppSpacing.x2);

  static const EdgeInsets p2pPaymentMethodsListEmptyPadding =
      EdgeInsets.symmetric(vertical: AppSpacing.x4);
  static const double p2pPaymentMethodsListSectionGap = AppSpacing.rowGap;
  static const double p2pPaymentMethodsListCardMinExtent = 80;
  static const EdgeInsets p2pPaymentAddFormCardPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets p2pPaymentAddFormOptionPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x2,
  );
  static EdgeInsets p2pPaymentAddFormScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pPaymentDialogActionPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
  );
  static const EdgeInsets p2pPaymentOwnershipCardPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets p2pPaymentOwnershipOptionPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: AppSpacing.x2);
  static EdgeInsets p2pPaymentOwnershipScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pPaymentCoolingScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets p2pPaymentCoolingHeroCountdownPadding =
      EdgeInsets.symmetric(vertical: AppSpacing.x3);
  static EdgeInsets p2pPaymentHistoryScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pPaymentVerificationScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double p2pDisputeBottomInsetVisual = AppSpacing.x4;
  static const double p2pDisputeBottomInsetNative = AppSpacing.x4;
  static EdgeInsets p2pDisputeScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pDisputesScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x5,
        AppSpacing.contentPad,
        bottomInset,
      );

  static const EdgeInsets p2pDisputeCardPadding = EdgeInsets.all(AppSpacing.x3);
  static const EdgeInsets p2pDisputeCompactCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets p2pDisputeEmptyPadding = EdgeInsets.all(
    AppSpacing.x5,
  );

  static const double p2pDisputeDashLength = AppSpacing.x3;
  static const double p2pDisputeDashGap = AppSpacing.x2;

  static const double p2pDisputeReadableLineHeight = 1.45;
  static const EdgeInsets p2pDisputeNoticeIconPadding = EdgeInsets.only(top: 3);
  static const double p2pDisputeNoticeBulletIcon = 12;
  static const double p2pDisputeMetaIcon = 11;
  static const double p2pDisputeStatusIconBox = 50;
  static const double p2pDisputeStatusIcon = 24;
  static const double p2pDisputeActionIconBox = 38;
  static const EdgeInsets p2pDisputeActionTilePadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const double p2pDisputeEvidenceThumb = 80;
  static const EdgeInsets p2pDisputeEvidenceButtonPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3);
  static const double p2pDisputeTimelineDot = 12;
  static const double p2pDisputeTimelineConnectorWidth =
      AppSpacing.hairlineStroke;
  static const double p2pDisputeTimelineConnectorHeight = AppSpacing.x6;
  static const EdgeInsets p2pDisputeTimelineItemPadding = EdgeInsets.only(
    bottom: AppSpacing.x3,
  );
  static const EdgeInsets p2pDisputeChatHeaderPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets p2pDisputeChatBodyPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets p2pDisputeChatInputPadding = EdgeInsets.fromLTRB(
    AppSpacing.x4,
    AppSpacing.x3,
    AppSpacing.x4,
    AppSpacing.x3,
  );
  static const double p2pDisputeSendButtonSize = 38;
  static const double p2pDisputeBubbleMaxWidth = 300;
  static const EdgeInsets p2pDisputeBubbleMargin = EdgeInsets.only(
    bottom: AppSpacing.x3,
  );
  static const EdgeInsets p2pDisputeBubblePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );

  static const EdgeInsets p2pDisputeLevelConnectorPadding = EdgeInsets.only(
    top: 17,
  );
  static const double p2pDisputeLevelConnectorHeight =
      AppSpacing.hairlineStroke;
  static const double p2pDisputeLevelNodeSize = 37;
  static const EdgeInsets p2pDisputeEscalatePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x3,
  );

  static EdgeInsets p2pDisputeResolutionScrollPadding(double bottomInset) =>
      p2pDisputeScrollPadding(bottomInset);
  static const EdgeInsets p2pDisputeResolutionCardPadding = EdgeInsets.all(
    AppSpacing.x2,
  );
  static const EdgeInsets p2pDisputeResolutionCompactCardPadding =
      EdgeInsets.all(AppSpacing.x2);
  static EdgeInsets p2pDisputeDetailScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets p2pDisputeEvidenceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x2,
        AppSpacing.contentPad,
        bottomInset,
      );
}
