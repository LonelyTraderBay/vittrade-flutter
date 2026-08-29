import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

final class MarketsSpacingTokens {
  const MarketsSpacingTokens._();

  static const EdgeInsets liveMarketPairCardPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad - AppSpacing.x4,
    AppSpacing.rowPy + AppSpacing.hairlineStroke / 2,
    AppSpacing.contentPad - AppSpacing.x4,
    AppSpacing.sectionGapCompact,
  );
  static const double liveMarketPairCardHeight =
      AppSpacing.buttonHero + AppSpacing.x6 - AppSpacing.x1;
  static const double liveMarketHeaderIcon = AppSpacing.inputPrefixIcon;
  static const double liveMarketInlineIcon = AppSpacing.statusPillIconSizeLg;
  static const double liveMarketTrendIcon =
      AppSpacing.statusPillIconSizeLg + AppSpacing.x1 / 2;
  static const double liveMarketTrendActionIcon =
      AppSpacing.iconMd + AppSpacing.hairlineStroke;
  static const double liveMarketRatioBarHeight =
      AppSpacing.statusPillIconSizeMd;
  static const double liveMarketMetricMinHeight =
      AppSpacing.buttonStandard + AppSpacing.hairlineStroke;
  static const EdgeInsets liveMarketMetricPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.statusPillHorizontalPaddingMd,
    vertical: AppSpacing.statusPillHorizontalPaddingMd,
  );
  static const double liveMarketToggleHeight =
      AppSpacing.buttonCompact + AppSpacing.rowGap;
  static const EdgeInsets liveMarketTogglePadding = EdgeInsets.all(
    AppSpacing.hairlineStroke * 2,
  );
  static const double liveMarketFundingCountdownHeight =
      AppSpacing.buttonStandard - AppSpacing.x1;
  static const EdgeInsets liveMarketFundingCountdownPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.rowPy);
  static const double liveMarketFundingChartHeight =
      AppSpacing.buttonStandard + AppSpacing.x4 - AppSpacing.x1;
  static const EdgeInsets liveMarketFundingChartPadding = EdgeInsets.fromLTRB(
    0,
    AppSpacing.rowGap,
    0,
    AppSpacing.formFieldLabelGap,
  );
  static const double liveMarketTopTraderHighlightHeight =
      AppSpacing.buttonHero + AppSpacing.buttonCompact;
  static const double liveMarketTrendActionBox =
      AppSpacing.buttonCompact + AppSpacing.rowGap;
  static const EdgeInsets liveMarketInfoPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.rowGapRelaxed,
    vertical: AppSpacing.statusPillHorizontalPaddingMd,
  );
  static const EdgeInsets liveMarketRowPadding = EdgeInsets.all(
    AppSpacing.rowGapRegular,
  );
  static const double liveMarketPairValueGap =
      AppSpacing.statusPillHorizontalPaddingMd;
  static const double liveMarketCardGap = AppSpacing.rowGapRelaxed;
  static EdgeInsets marketScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double marketNativeBottomExtra = 18;
  static const double marketVisualBottomExtra = 40;
  static const double marketColumnHeaderHeight = 46;
  static const EdgeInsets marketColumnHeaderPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
  );
  static const EdgeInsets marketPairRowPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
    vertical: 14,
  );
  static const double marketPairGap = 12;
  static const double marketPairMicroGap = 4;
  static const double marketPairPriceGap = AppSpacing.x2;
  static const double marketPairFavoriteGap = AppSpacing.x3;
  static const double marketPairSparklineWidth = 70;
  static const double marketPairSparklineHeight = 32;
  static const double marketPairPriceColumnWidth = 74;
  static const double marketPairFavoriteWidth = 28;
  static const double marketPairFavoriteHeight = 32;
  static const double marketPairFavoriteRadius = 18;
  static const double marketPairFavoriteIcon = 18;
  static const double marketPairAvatar = AppSpacing.x6;
  static const double marketPairAvatarBorder = 1.5;
  static const EdgeInsets marketPairChangePadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 5,
  );
  static const EdgeInsets marketListPairCompactHeaderPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.contentPad - AppSpacing.x3);
  static const EdgeInsets marketListPairCompactRowPadding =
      EdgeInsets.symmetric(
        horizontal: AppSpacing.contentPad - AppSpacing.x3,
        vertical: AppSpacing.x4 - AppSpacing.x1,
      );
  static const EdgeInsets marketListPairChangePillPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: AppSpacing.x1);
  static const EdgeInsets marketListFilterCompactPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets marketListMoverCompactPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets marketListToolCompactPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );
  static const EdgeInsets marketFilterSheetPadding = EdgeInsets.all(12);
  static const double marketFilterGap = AppSpacing.x3;
  static const double marketCategoryGap = 9;
  static const double marketCategoryHeight = 38;
  static const double marketTimeframeLabelGap = 10;
  static const double marketTimeframeSelectorHeight = 32;
  static const double marketCategoryDropdownHeight = 44;
  static const EdgeInsets marketCategoryDropdownPadding = EdgeInsets.symmetric(
    horizontal: 14,
  );
  static const double marketFilterChipMinHeight = AppSpacing.x6;
  static const double marketCategoryChipMinHeight = 36;
  static const EdgeInsets marketFilterChipPadding = EdgeInsets.symmetric(
    horizontal: 13,
    vertical: 8,
  );
  static const double marketToolsHeight = 36;
  static const double marketToolHeight = AppSpacing.x6;
  static const double marketToolGap = AppSpacing.x3;
  static const EdgeInsets marketToolPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double marketToolIcon = 14;
  static const double marketToolIconGap = 7;
  static const double marketMoverGap = 12;
  static const double marketMoverCardHeight = 130;
  static const EdgeInsets marketMoverCardPadding = EdgeInsets.fromLTRB(
    12,
    12,
    12,
    11,
  );
  static const double marketMoverIcon = 14;
  static const double marketMoverIconGap = 6;
  static const double marketMoverHeaderGap = 10;
  static const double marketMoverRowGap = AppSpacing.x3;
  static const double marketMoverRowHeight = 65;
  static const EdgeInsets marketMoverRowPadding = EdgeInsets.symmetric(
    horizontal: 10,
  );
  static const double marketMoverRankWidth = 20;
  static const double marketMoverAvatar = 35;
  static const double marketMoverSparklineWidth = 66;
  static const double marketMoverSparklineHeight = 30;
  static const double marketMoverPriceColumnWidth = 74;
  static const double marketMoverIdentityBadgeGap = AppSpacing.x2;
  static const double marketMoverMetricGap = 7;
  static const EdgeInsets marketMoverRankBadgePadding = EdgeInsets.symmetric(
    horizontal: 5,
    vertical: 2,
  );
  static const EdgeInsets watchlistCardPadding = EdgeInsets.all(16);
  static const EdgeInsets watchlistPairTextPadding = EdgeInsets.symmetric(
    vertical: 3,
  );
  static const EdgeInsets watchlistToolbarPadding = EdgeInsets.fromLTRB(
    20,
    12,
    20,
    13,
  );
  static const EdgeInsets watchlistNotePadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets watchlistActionPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets watchlistEmptyPadding = EdgeInsets.only(top: 70);
  static const double watchlistTinyGap = AppSpacing.x1;
  static const double watchlistPairTextGap = 4;
  static const double watchlistStatGap = AppSpacing.x2;
  static const double watchlistSmallGap = 6;
  static const double watchlistCountGap = 7;
  static const double watchlistActionGap = AppSpacing.x3;
  @Deprecated('Use AppSpacing.pageRhythmStandardInnerGap or AppSpacing.x3')
  static const double watchlistSectionGap = 12;
  static const double watchlistSparklineHeight = 42;
  static const double watchlistAvatar = 44;
  static const double watchlistTrendIcon = 15;
  static const double watchlistRemoveButton = 38;
  static const double watchlistRemoveIcon = 18;
  static const double watchlistNoteHeight = 36;
  static const double watchlistNoteIcon = 16;
  static const double watchlistActionHeight = 38;
  static const double watchlistActionMinWidth = 102;
  static const double watchlistAddButton = 40;
  static const double watchlistAddIcon = 22;
  static const double watchlistCountIcon = 15;
  static const double marketDiscoverLabelGap = AppSpacing.x3;
  static const double marketDiscoverAccentWidth = 4;
  static const double marketDiscoverAccentHeight = 17;
  static const double marketDiscoverLabelTextGap = 7;
  static const EdgeInsets marketDiscoverRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );
  static const double marketDiscoverIconBox = 40;
  static const double marketDiscoverIcon = 18;
  static const double marketDiscoverRowGap = 12;
  static const double marketDiscoverTitleBadgeGap = 7;
  static const EdgeInsets marketDiscoverBadgePadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 2,
  );
  static const double marketDiscoverSubtitleGap = AppSpacing.x2;
  static const double marketDiscoverChevron = 16;
  static const double marketAnalyticsTinyGap = AppSpacing.x1;
  static const double marketAnalyticsMicroGap = 4;
  static const double marketAnalyticsSmallGap = 6;
  static const double marketAnalyticsCompactGap = AppSpacing.x3;
  static const double marketAnalyticsMediumGap = 10;
  static const double marketAnalyticsGap = 12;
  static const double marketAnalyticsBreadthGap = 9;
  static const double marketAnalyticsFooterGap = AppSpacing.x4;
  static const double marketAnalyticsLargeGap = 16;
  static const double marketAnalyticsHeroHeight = 170;
  static const double marketAnalyticsStatCardHeight = 96;
  static const double marketAnalyticsSentimentCardHeight = 183;
  static const double marketAnalyticsStatIcon = 14;
  static const double marketAnalyticsTrendIcon = 12;
  static const double marketAnalyticsBreadthDot = AppSpacing.x3;
  static const double marketAnalyticsBreadthTrackHeight = 6;
  static const double marketAnalyticsGaugeWidth = 120;
  static const double marketAnalyticsGaugeHeight = 64;
  static const double marketOverviewQuickNavHeight = 90;
  static const double marketOverviewQuickNavGlyph = 18;
  static const double marketOverviewMoverCardHeight = 272;
  static const double marketOverviewMoverHeaderIcon = 14;
  static const double marketOverviewMoverChevron = 15;
  static const double marketOverviewMoverAvatar = 25;
  static const double marketOverviewMoverPriceWidth = AppSpacing.x6;
  static const double marketOverviewMoverChangeWidth = 58;
  static const double marketOverviewSectorRowHeight = 61;
  static const double marketOverviewSectorGlyph = 18;
  static const double marketOverviewSectorChevron = 16;
  static const double marketOverviewHistoryHeight = 128;
  static const double marketOverviewHistoryBarMaxHeight = 64;
  static const double marketOverviewToolHeight = 60;
  static const double marketOverviewToolIcon = 22;
  static const double marketOverviewMiniHeaderIcon = 14;
  static const double marketOverviewMiniHeaderGap = 7;
  static const double marketAdvancedTabsHeight = 54;
  static const double marketAdvancedTabIndicatorHeight =
      AppSpacing.hairlineStroke;
  static const double marketAdvancedActionMinHeight = 30;
  static const double marketAdvancedChipRemoveIcon = 12;
  static const double marketAdvancedSignalAccentWidth = AppSpacing.x1;
  static const double marketAdvancedSignalAccentHeight = 14;
  static const int marketAdvancedGridColumns = 3;
  static const double marketAdvancedGridAspectRatio = .92;
  static const double marketAdvancedIndicatorAvatar = 32;
  static const double marketAdvancedToggleSize = 32;
  static const double marketAdvancedToggleIcon = 16;
  static const double marketAdvancedInfoIcon = 17;
  static const double marketAdvancedToolIcon = 25;
  static const double marketAdvancedTipIcon = 18;
  static const double marketAdvancedDisclaimerIcon = 14;
  static const double marketAdvancedSignalBarHeight = AppSpacing.x3;
  static const double marketHeatmapSectionGap = 28;
  static const double marketHeatmapSummaryGap = 12;
  static const double marketHeatmapSummaryHeight = 62;
  static const double marketHeatmapControlsHeight = 42;
  static const double marketHeatmapFilterHeight = AppSpacing.x6;
  static const double marketHeatmapLegendDot = 12;
  static const double marketHeatmapAvatar = 40;
  static const double marketHeatmapDetailButtonHeight = 36;
  static const double marketHeatmapTrendCardHeight = 156;
  static const double marketHeatmapTrendIcon = 15;
  static const double marketHeatmapTrendRowHeight = 32;
  static const double marketHeatmapTreemapHeight = 360;
  static const int marketHeatmapTreemapColumns = 5;
  static const double marketHeatmapTreemapCellHeight = 50;
  static const double marketHeatmapTreemapGap = 4;
  @Deprecated('Use AppSpacing.pageRhythmFormSectionGap')
  static const double marketDepthSectionGap =
      AppSpacing.pageRhythmFormSectionGap;
  static const double marketDepthTabsHeight = 54;
  static const double marketDepthTabIndicatorHeight = AppSpacing.hairlineStroke;
  static const double marketDepthAvatar = 40;
  static const double marketDepthTrendIcon = 12;
  static const double marketDepthChartHeight = 200;
  static const double marketDepthPainterPadding = AppSpacing.x3;
  static const double marketDepthPainterDash = 4;
  static const double marketDepthPainterDashGap = AppSpacing.x3;
  static const double marketDepthStroke = AppSpacing.borderWidth;
  static const double marketDepthDashedStroke = AppSpacing.dividerHairline;
  static const double marketDepthLegendDot = 12;
  static const double marketDepthRatioBarHeight = AppSpacing.x5;
  static const double marketDepthOrderRowHeight = 28;
  static const double marketDepthWhaleIconBox = 40;
  static const double marketSocialTabsHeight = 54;
  static const double marketSocialTabIndicatorHeight =
      AppSpacing.hairlineStroke;
  static const double marketSocialSectionGap = 12;
  static const double marketSocialTinyGap = 2;
  static const double marketSocialSmallGap = 4;
  static const double marketSocialCompactGap = 6;
  static const double marketSocialGap = AppSpacing.x3;
  static const double marketSocialMediumGap = 10;
  static const double marketSocialLargeGap = 14;
  static const double marketSocialFilterHeight = 36;
  static const double marketSocialCategoryHeight = AppSpacing.x6;
  static const double marketSocialTinyBadgeHeight = 16;
  static const double marketSocialTinyBadgeHeightMd = 18;
  static const double marketSocialTinyBadgeHeightLg = 20;
  static const double marketSocialTargetHeight = 44;
  static const double marketSocialProviderRank = 28;
  static const double marketSocialDividerHeight = AppSpacing.dividerHairline;
  static const double marketSocialStatusBarHeight = 12;
  static const double marketSocialLegendDot = 10;
  static const double marketSocialResultIcon = 16;
  static const double marketSocialSectionBarWidth = AppSpacing.x1;
  static const double marketSocialSectionBarHeight = 16;
  static const double marketSocialEmptyHeight = 180;
  static const double marketSocialEmptyIcon = 32;
  static const double marketDerivativesNativeBottomExtra =
      AppSpacing.contentPad;
  static const double marketDerivativesVisualBottomExtra = 54;
  static const double marketDerivativesPageGap = 10;
  static const double marketDerivativesHeroLabelGap = 10;
  static const double marketDerivativesHeroValueGap = 10;
  static const double marketDerivativesHeroDeltaBottom = AppSpacing.x2;
  static const int marketDerivativesStatGridColumns = 2;
  static const double marketDerivativesStatGridGap = AppSpacing.x3;
  static const double marketDerivativesStatGridAspectRatio = 2;
  static const double marketDerivativesStatIconBox = 24;
  static const double marketDerivativesStatIcon = 14;
  static const double marketDerivativesSplitBarHeight = 6;
  static const double marketDerivativesSplitBarCompactHeight = 4;
  static const double marketDerivativesSplitLabelGap = 6;
  static const double marketDerivativesMetricGap = AppSpacing.x1;
  static const double marketDerivativesTimelineTimeWidth = 48;
  static const double marketDerivativesTimelineTimeGap = AppSpacing.x3;
  static const double marketDerivativesTimelineItemGap = AppSpacing.x3;
  static const double marketDerivativesTimelineDividerHeight = 18;
  static const double marketDerivativesTimelineBarHeight = 12;
  static const double marketDerivativesLegendDot = 10;
  static const double marketDerivativesLegendGap = 7;
  static const double marketDerivativesLegendItemGap = 18;
  static const double marketDerivativesPairAvatarSm = 30;
  static const double marketDerivativesPairAvatarMd = AppSpacing.x6;
  static const double marketDerivativesPairGap = 12;
  static const double marketDerivativesOiRowGap = 2;
  static const double marketDerivativesSummaryLabelGap = AppSpacing.x3;
  static const double marketDerivativesSummarySplitGap = 14;
  static const double marketDerivativesLiquidationRowGap = 7;
  static const double marketDerivativesRiskIcon = 18;
  static const double marketDerivativesRiskIconGap = 10;
  static const double marketDerivativesRiskTitleGap = 4;
  static const double marketDerivativesRiskLineHeight = 1.45;
  static const double marketDerivativesSortGap = AppSpacing.x3;
  static const double marketDerivativesLeverageGap = 7;
  static const double marketDerivativesPerpetualMetaGap = 14;
  static const double marketDerivativesPerpetualSplitGap = 12;
  static const double marketDerivativesTabsHeight = 54;
  static const double marketDerivativesTabIndicatorHeight =
      AppSpacing.hairlineStroke;
  static const EdgeInsets marketDerivativesHeroPadding = EdgeInsets.all(16);
  static const EdgeInsets marketDerivativesStatCardPadding = EdgeInsets.all(12);
  static const EdgeInsets marketDerivativesHeroDeltaPadding = EdgeInsets.only(
    bottom: marketDerivativesHeroDeltaBottom,
  );
  static const EdgeInsets marketDerivativesTimelinePadding = EdgeInsets.all(16);
  static const EdgeInsets marketDerivativesOiRowPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  );
  static const EdgeInsets marketDerivativesLiquidationSummaryPadding =
      EdgeInsets.all(16);
  static const EdgeInsets marketDerivativesPairCardPadding = EdgeInsets.all(12);
  static const EdgeInsets marketDerivativesRiskPadding = EdgeInsets.all(14);
  static const EdgeInsets marketDerivativesSortChipPadding =
      EdgeInsets.symmetric(horizontal: 13, vertical: 8);
  static EdgeInsets marketDerivativesScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double tokenUnlocksNativeBottomExtra = AppSpacing.contentPad;
  static const double tokenUnlocksVisualBottomExtra = 54;
  static const double tokenUnlocksPageGap = 12;
  static const double tokenUnlocksTabsHeight = 54;
  static const double tokenUnlocksTabIndicatorHeight =
      AppSpacing.hairlineStroke;
  static const double tokenUnlocksHeroLabelGap = 6;
  static const double tokenUnlocksHeroValueGap = 9;
  static const double tokenUnlocksHeroMetaGap = 18;
  static const double tokenUnlocksFilterGap = 2;
  static const double tokenUnlocksListGap = 4;
  static const double tokenUnlocksAvatarLg = 40;
  static const double tokenUnlocksAvatarMd = 36;
  static const double tokenUnlocksAvatarSm = 28;
  static const double tokenUnlocksCardGap = 12;
  static const double tokenUnlocksBadgeSpacing = 6;
  static const double tokenUnlocksBadgeRunSpacing = 4;
  static const double tokenUnlocksDateIcon = 12;
  static const double tokenUnlocksDateGap = 6;
  static const double tokenUnlocksValueGap = 4;
  static const double tokenUnlocksDetailMetricGap = 2;
  static const double tokenUnlocksExpandedMetricGap = 12;
  static const double tokenUnlocksPriceWarningGap = 12;
  static const double tokenUnlocksPriceWarningIcon = 14;
  static const double tokenUnlocksPriceWarningIconGap = AppSpacing.x3;
  static const double tokenUnlocksImpactTitleGap = 12;
  static const double tokenUnlocksImpactStatGap = AppSpacing.x3;
  static const double tokenUnlocksImpactStatValueGap = 4;
  static const double tokenUnlocksCategoryGap = 12;
  static const double tokenUnlocksCategoryDot = 10;
  static const double tokenUnlocksCategoryDotGap = AppSpacing.x3;
  static const double tokenUnlocksCategoryProgressGap = 6;
  static const double tokenUnlocksCategoryProgressHeight = AppSpacing.x2;
  static const double tokenUnlocksDilutionRankWidth = 14;
  static const double tokenUnlocksDilutionRankGap = 10;
  static const double tokenUnlocksDilutionRowGap = 2;
  static const double tokenUnlocksWarningIcon = 18;
  static const double tokenUnlocksWarningIconGap = 12;
  static const double tokenUnlocksWarningTitleGap = AppSpacing.x1;
  static const double tokenUnlocksWarningLineHeight = 1.55;
  static const double tokenUnlocksScheduleGap = AppSpacing.x3;
  static const double tokenUnlocksScheduleSupplyGap = 14;
  static const double tokenUnlocksScheduleProgressGap = 6;
  static const double tokenUnlocksScheduleTitleGap = 14;
  static const double tokenUnlocksVestingMarker = 24;
  static const double tokenUnlocksVestingLine = AppSpacing.dividerHairline;
  static const double tokenUnlocksVestingIconOpen = 12;
  static const double tokenUnlocksVestingIconLocked = 9;
  static const double tokenUnlocksVestingContentGap = 12;
  static const double tokenUnlocksVestingBottomGap = AppSpacing.x4;
  static const double tokenUnlocksTinyBadgeLineHeight = 1.2;
  static const double tokenUnlocksSectionBarWidth = AppSpacing.x1;
  static const double tokenUnlocksSectionBarHeight = 14;
  static const double tokenUnlocksSectionHeaderGap = AppSpacing.x3;
  static const double tokenUnlocksEmptyIcon = AppSpacing.x6;
  static const double tokenUnlocksEmptyGap = 12;
  static const EdgeInsets tokenUnlocksHeroPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenUnlocksFilterPadding = EdgeInsets.symmetric(
    horizontal: 2,
    vertical: 6,
  );
  static const EdgeInsets tokenUnlocksCardHeaderPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 13,
  );
  static const EdgeInsets tokenUnlocksExpandedPadding = EdgeInsets.fromLTRB(
    16,
    12,
    16,
    14,
  );
  static const EdgeInsets tokenUnlocksPriceWarningPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const EdgeInsets tokenUnlocksAnalysisCardPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenUnlocksImpactStatPadding = EdgeInsets.symmetric(
    vertical: 12,
  );
  static const EdgeInsets tokenUnlocksDilutionRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets tokenUnlocksWarningPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenUnlocksScheduleCardPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenUnlocksVestingEventPadding = EdgeInsets.only(
    bottom: tokenUnlocksVestingBottomGap,
  );
  static const EdgeInsets tokenUnlocksTinyBadgePadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 2,
  );
  static const EdgeInsets tokenUnlocksEmptyPadding = EdgeInsets.symmetric(
    vertical: 48,
  );
  static EdgeInsets tokenUnlocksScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double socialSentimentNativeBottomExtra = AppSpacing.contentPad;
  static const double socialSentimentVisualBottomExtra = 54;
  static const double socialSentimentPageGap = 12;
  static const double socialSentimentTabsHeight = 54;
  static const double socialSentimentTabIndicatorHeight =
      AppSpacing.hairlineStroke;
  static const double socialSentimentHeroHeaderGap = 16;
  static const double socialSentimentHeroScoreGap = 6;
  static const double socialSentimentHeroScoreBottom = 6;
  static const double socialSentimentHeroGaugeGap = 12;
  static const double socialSentimentHeroGaugeHeight = AppSpacing.x3;
  static const double socialSentimentHeroLegendGap = 4;
  static const double socialSentimentStatGap = AppSpacing.x3;
  static const double socialSentimentStatIcon = 12;
  static const double socialSentimentStatIconGap = 6;
  static const double socialSentimentStatValueGap = AppSpacing.x3;
  static const double socialSentimentStatSubGap = 2;
  static const double socialSentimentDominanceTitleGap = 10;
  static const double socialSentimentDominanceBarHeight = 20;
  static const double socialSentimentDominanceLegendGap = 16;
  static const double socialSentimentLegendDot = 10;
  static const double socialSentimentLegendGap = 6;
  static const double socialSentimentTimelineRowGap = AppSpacing.x1;
  static const double socialSentimentTimelineTimeWidth = 56;
  static const double socialSentimentTimelineTimeGap = AppSpacing.x3;
  static const double socialSentimentTimelineScoreGap = 10;
  static const double socialSentimentTimelineScoreWidth = 24;
  static const double socialSentimentTimelineBarHeight = 6;
  static const double socialSentimentSectionGap = 6;
  static const double socialSentimentListGap = 4;
  static const double socialSentimentAvatarLg = 40;
  static const double socialSentimentAvatarMd = 36;
  static const double socialSentimentRowGap = 12;
  static const double socialSentimentStatusDot = 10;
  static const double socialSentimentStatusShadowBlur = AppSpacing.x3;
  static const double socialSentimentSortGap = AppSpacing.x3;
  static const double socialSentimentSplitBarHeight = 6;
  static const double socialSentimentTokenMetricGap = 10;
  static const double socialSentimentTopicGap = AppSpacing.x3;
  static const int socialSentimentHeatmapCrossAxisCount = 4;
  static const double socialSentimentHeatmapGap = 6;
  static const double socialSentimentHeatmapAspectRatio = .95;
  static const double socialSentimentLeaderboardGap = AppSpacing.x3;
  static const double socialSentimentLeaderboardRowGap = 4;
  static const double socialSentimentLeaderboardRankWidth = 16;
  static const double socialSentimentVelocitySymbolWidth = 44;
  static const double socialSentimentVelocityBarHeight = AppSpacing.x2;
  static const double socialSentimentVelocityGap = 10;
  static const double socialSentimentVelocityValueWidth = 52;
  static const EdgeInsets socialSentimentHeroPadding = EdgeInsets.all(16);
  static const EdgeInsets socialSentimentHeroScorePadding = EdgeInsets.only(
    bottom: socialSentimentHeroScoreBottom,
  );
  static const EdgeInsets socialSentimentStatPadding = EdgeInsets.all(12);
  static const EdgeInsets socialSentimentDominancePadding = EdgeInsets.all(14);
  static const EdgeInsets socialSentimentTimelinePadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    14,
  );
  static const EdgeInsets socialSentimentTimelineRowPadding =
      EdgeInsets.symmetric(vertical: socialSentimentTimelineRowGap);
  static const EdgeInsets socialSentimentRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets socialSentimentSortChipPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );
  static const EdgeInsets socialSentimentTokenDetailPadding = EdgeInsets.all(
    16,
  );
  static const EdgeInsets socialSentimentTopicCardPadding = EdgeInsets.all(16);
  static const EdgeInsets socialSentimentTopicChipPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const EdgeInsets socialSentimentLeaderboardRowPadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 8);
  static const EdgeInsets socialSentimentVelocityRowPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 10);
  static EdgeInsets socialSentimentScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double tokenInfoNativeBottomExtra = AppSpacing.contentPad;
  static const double tokenInfoVisualBottomExtra = 54;
  static const double tokenInfoPageGap = 14;
  static const double tokenInfoTabsHeight = 54;
  static const double tokenInfoTabIndicatorHeight = AppSpacing.hairlineStroke;
  static const double tokenInfoTabIndicatorWidth = 116;
  static const double tokenInfoSectionGap = 14;
  static const double tokenInfoHeroAvatar = 44;
  static const double tokenInfoHeroAvatarGap = 12;
  static const double tokenInfoHeroSubtitleGap = 2;
  static const double tokenInfoHeroPriceGap = 16;
  static const double tokenInfoInfoIcon = AppSpacing.x4;
  static const double tokenInfoInfoIconGap = 9;
  static const double tokenInfoSupplyProgressGap = AppSpacing.x3;
  static const double tokenInfoSupplyProgressHeight = 6;
  static const double tokenInfoMetricGap = 12;
  static const double tokenInfoDonutSize = 80;
  static const double tokenInfoDonutStroke = 18;
  static const double tokenInfoDonutInset = 9;
  static const double tokenInfoDistributionGap = 18;
  static const double tokenInfoDistributionDot = 10;
  static const double tokenInfoDistributionDotGap = AppSpacing.x3;
  static const double tokenInfoRecordCardGap = 12;
  static const double tokenInfoRecordIcon = AppSpacing.x4;
  static const double tokenInfoRecordIconGap = 6;
  static const double tokenInfoRecordValueGap = 10;
  static const double tokenInfoRecordDeltaGap = AppSpacing.x3;
  static const double tokenInfoChartIconBox = 42;
  static const double tokenInfoChartIconGap = 12;
  static const double tokenInfoChartSubtitleGap = 2;
  static const double tokenInfoOnchainIcon = 16;
  static const double tokenInfoOnchainIconGap = AppSpacing.x3;
  static const double tokenInfoOnchainTitleGap = 14;
  static const double tokenInfoMiniStatGap = 10;
  static const double tokenInfoMiniStatValueGap = 4;
  static const double tokenInfoProjectTitleGap = 10;
  static const double tokenInfoProjectLinkGap = AppSpacing.x3;
  static const double tokenInfoProjectLinkIcon = 18;
  static const double tokenInfoProjectLinkIconGap = 10;
  static const double tokenInfoProjectLinkOpenIcon = 15;
  static const double tokenInfoDisclaimerIcon = 14;
  static const double tokenInfoDisclaimerIconGap = AppSpacing.x3;
  static const double tokenInfoDisclaimerLineHeight = 1.35;
  static const EdgeInsets tokenInfoTabPadding = EdgeInsets.symmetric(
    vertical: 14,
  );
  static const EdgeInsets tokenInfoHeroPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenInfoInfoCardPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const EdgeInsets tokenInfoInfoRowPadding = EdgeInsets.symmetric(
    vertical: 11,
  );
  static const EdgeInsets tokenInfoSupplyCardPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenInfoMetricLinePadding = EdgeInsets.symmetric(
    vertical: 5,
  );
  static const EdgeInsets tokenInfoRecordCardPadding = EdgeInsets.all(14);
  static const EdgeInsets tokenInfoChartCardPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenInfoOnchainCardPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenInfoMiniStatPadding = EdgeInsets.all(12);
  static const EdgeInsets tokenInfoProjectCardPadding = EdgeInsets.all(16);
  static const EdgeInsets tokenInfoProjectLinkPadding = EdgeInsets.all(12);
  static const EdgeInsets tokenInfoDisclaimerPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );
  static EdgeInsets tokenInfoScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double marketCorrelationsNativeBottomExtra =
      AppSpacing.contentPad;
  static const double marketCorrelationsVisualBottomExtra = 54;
  static const double marketCorrelationsPageGap = 14;
  static const double marketCorrelationsTabsHeight = 54;
  static const double marketCorrelationsTabIndicatorHeight =
      AppSpacing.hairlineStroke;
  static const double marketCorrelationsChipGap = AppSpacing.x3;
  static const double marketCorrelationsTimeframeChipHeight = 36;
  static const double marketCorrelationsSortChipHeight = 32;
  static const double marketCorrelationsMatrixGap = 12;
  static const double marketCorrelationsHeatmapLabelSize = 28;
  static const double marketCorrelationsLegendGap = 4;
  static const double marketCorrelationsLegendDot = 10;
  static const double marketCorrelationsInfoIcon = 14;
  static const double marketCorrelationsInfoIconGap = 12;
  static const double marketCorrelationsInfoTitleGap = AppSpacing.x1;
  static const double marketCorrelationsBodyLineHeight = 1.55;
  static const double marketCorrelationsInsightGap = 10;
  static const double marketCorrelationsInsightValueGap = 6;
  static const double marketCorrelationsInsightSubGap = 2;
  static const double marketCorrelationsRecommendationIcon = 16;
  static const double marketCorrelationsRecommendationIconGap = 12;
  static const double marketCorrelationsRecommendationTitleGap = AppSpacing.x2;
  static const double marketCorrelationsHeroLabelGap = 6;
  static const double marketCorrelationsHeroMetaGap = AppSpacing.x3;
  static const double marketCorrelationsHeroPillGap = 12;
  static const double marketCorrelationsHeroProgressGap = 12;
  static const double marketCorrelationsHeroProgressHeight = AppSpacing.x3;
  static const double marketCorrelationsHeroScaleGap = AppSpacing.x2;
  static const double marketCorrelationsMetricGap = 10;
  static const double marketCorrelationsMetricValueGap = AppSpacing.x2;
  static const double marketCorrelationsTimelineRowGap = 12;
  static const double marketCorrelationsScoreLabelWidth = 30;
  static const double marketCorrelationsScoreValueWidth = 30;
  static const double marketCorrelationsScoreBarHeight = AppSpacing.x3;
  static const double marketCorrelationsScoreGap = 10;
  static const double marketCorrelationsDisclaimerIcon = 12;
  static const double marketCorrelationsDisclaimerIconGap = AppSpacing.x3;
  static const double marketCorrelationsRankWidth = 18;
  static const double marketCorrelationsRankGap = 10;
  static const double marketCorrelationsAssetDot = 24;
  static const double marketCorrelationsAssetDotGap = AppSpacing.x2;
  static const double marketCorrelationsPairGap = 12;
  static const EdgeInsets marketCorrelationsTimeframeChipPadding =
      EdgeInsets.symmetric(horizontal: 14);
  static const EdgeInsets marketCorrelationsSortChipPadding =
      EdgeInsets.symmetric(horizontal: 13);
  static const EdgeInsets marketCorrelationsMatrixPadding = EdgeInsets.all(12);
  static const EdgeInsets marketCorrelationsInfoPadding = EdgeInsets.all(16);
  static const EdgeInsets marketCorrelationsInsightPadding = EdgeInsets.all(14);
  static const EdgeInsets marketCorrelationsRecommendationPadding =
      EdgeInsets.all(16);
  static const EdgeInsets marketCorrelationsHeroPadding = EdgeInsets.all(16);
  static const EdgeInsets marketCorrelationsHeroMetaPadding = EdgeInsets.only(
    bottom: marketCorrelationsHeroMetaGap,
  );
  static const EdgeInsets marketCorrelationsMetricPadding = EdgeInsets.all(14);
  static const EdgeInsets marketCorrelationsScoreCardPadding = EdgeInsets.all(
    16,
  );
  static const EdgeInsets marketCorrelationsScoreRowPadding = EdgeInsets.only(
    bottom: marketCorrelationsTimelineRowGap,
  );
  static const EdgeInsets marketCorrelationsDisclaimerPadding = EdgeInsets.all(
    12,
  );
  static const EdgeInsets marketCorrelationsPairRowPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static EdgeInsets marketCorrelationsScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double portfolioTrackerNativeBottomExtra = AppSpacing.contentPad;
  static const double portfolioTrackerVisualBottomExtra = 54;
  static const double portfolioTrackerPageGap = 12;
  static const double portfolioTrackerTabsHeight = 54;
  static const double portfolioTrackerTabIndicatorHeight =
      AppSpacing.hairlineStroke;
  static const double portfolioTrackerHeroTitleGap = 6;
  static const double portfolioTrackerHeroPnlGap = 4;
  static const double portfolioTrackerHeroTogglePadding = 4;
  static const double portfolioTrackerHeroToggleIcon = 16;
  static const double portfolioTrackerHeroPnlIcon = 15;
  static const double portfolioTrackerHeroPnlIconGap = AppSpacing.x3;
  static const double portfolioTrackerQuickStatGap = AppSpacing.x3;
  static const double portfolioTrackerMiniStatValueGap = AppSpacing.x2;
  static const double portfolioTrackerAllocationTitleGap = 14;
  static const double portfolioTrackerDonutSize = 120;
  static const double portfolioTrackerDonutGap = 28;
  static const double portfolioTrackerLegendGap = AppSpacing.x3;
  static const double portfolioTrackerLegendDot = 10;
  static const double portfolioTrackerSectionGap = 4;
  static const double portfolioTrackerSectionHeaderGap = 6;
  static const double portfolioTrackerHoldingAvatarSm = 28;
  static const double portfolioTrackerHoldingAvatarMd = 32;
  static const double portfolioTrackerHoldingAvatarLg = 36;
  static const double portfolioTrackerHoldingRowGap = 12;
  static const double portfolioTrackerHoldingSparklineWidth = 54;
  static const double portfolioTrackerHoldingSparklineHeight = 22;
  static const double portfolioTrackerHoldingSparklineGap = AppSpacing.x3;
  static const double portfolioTrackerHoldingValueWidth = 86;
  static const double portfolioTrackerRiskTitleGap = 12;
  static const double portfolioTrackerRiskProgressLabelGap = AppSpacing.x2;
  static const double portfolioTrackerRiskProgressHeight = AppSpacing.x2;
  static const double portfolioTrackerRiskCopyGap = AppSpacing.x3;
  static const double portfolioTrackerRiskLineHeight = 1.45;
  static const double portfolioTrackerChipGap = AppSpacing.x3;
  static const double portfolioTrackerHoldingDetailGap = 14;
  static const double portfolioTrackerHoldingMetricGap = 2;
  static const double portfolioTrackerChartTitleGap = 12;
  static const double portfolioTrackerChartHeight = 160;
  static const double portfolioTrackerPnlRowGap = 4;
  static const double portfolioTrackerPnlAvatarGap = 12;
  static const double portfolioTrackerPnlProgressGap = 6;
  static const double portfolioTrackerPnlProgressHeight = 4;
  static const double portfolioTrackerSummaryGap = AppSpacing.x3;
  static const double portfolioTrackerSummaryValueGap = 4;
  static const double portfolioTrackerAllocationDonutInset = AppSpacing.x3;
  static const double portfolioTrackerAllocationDonutStroke = 16;
  static const double portfolioTrackerPerformanceTopPadding = AppSpacing.x3;
  static const double portfolioTrackerPerformanceBottomPadding = 24;
  static const double portfolioTrackerPerformanceLineStroke = 2;
  static const double portfolioTrackerPerformanceLastPoint = 4;
  static const double portfolioTrackerPerformanceInnerPoint = 2;
  static const double portfolioTrackerPerformanceDateBottom = 16;
  static const double portfolioTrackerSparklineStroke = 1.4;
  static const EdgeInsets portfolioTrackerHeroPadding = EdgeInsets.all(14);
  static const EdgeInsets portfolioTrackerHeroTogglePaddingInsets =
      EdgeInsets.all(portfolioTrackerHeroTogglePadding);
  static const EdgeInsets portfolioTrackerMiniStatPadding =
      EdgeInsets.symmetric(horizontal: 8, vertical: 10);
  static const EdgeInsets portfolioTrackerAllocationPadding =
      EdgeInsets.fromLTRB(16, 16, 16, 18);
  static const EdgeInsets portfolioTrackerHoldingRowPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const EdgeInsets portfolioTrackerRiskPadding = EdgeInsets.all(16);
  static const EdgeInsets portfolioTrackerChipPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );
  static const EdgeInsets portfolioTrackerHoldingDetailPadding = EdgeInsets.all(
    16,
  );
  static const EdgeInsets portfolioTrackerChartCardPadding = EdgeInsets.all(16);
  static const EdgeInsets portfolioTrackerPnlRowPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  );
  static const EdgeInsets portfolioTrackerSummaryPadding = EdgeInsets.all(12);
  static EdgeInsets portfolioTrackerScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double marketScreenerNativeBottomExtra = AppSpacing.contentPad;
  static const double marketScreenerVisualBottomExtra = 54;
  static const double marketScreenerPageGap = 16;
  static const double marketScreenerPresetHeight = 36;
  static const double marketScreenerPresetGap = AppSpacing.x3;
  static const double marketScreenerPresetIcon = 14;
  static const double marketScreenerPresetIconGap = AppSpacing.x3;
  static const double marketScreenerPresetLineHeight = 1.0;
  static const double marketScreenerAdvancedTitleGap = 12;
  static const double marketScreenerAdvancedCategoryGap = AppSpacing.x3;
  static const double marketScreenerAdvancedRangeGap = 12;
  static const double marketScreenerAdvancedRangeRowGap = 10;
  static const double marketScreenerResetIcon = 14;
  static const double marketScreenerResetHeight = 32;
  static const double marketScreenerCategoryChipHeight = AppSpacing.x6;
  static const double marketScreenerCategoryChipLineHeight = 1.0;
  static const double marketScreenerInputVerticalPadding = 10;
  static const double marketScreenerSortHeight = 38;
  static const double marketScreenerSortChipHeight = 36;
  static const double marketScreenerSortGap = 4;
  static const double marketScreenerSortResultGap = 6;
  static const double marketScreenerSortResultWidth = 62;
  static const double marketScreenerSortIconGap = 2;
  static const double marketScreenerSortIcon = 15;
  static const double marketScreenerRowGap = 4;
  static const double marketScreenerRowHeight = 62;
  static const double marketScreenerRowRankWidth = 22;
  static const double marketScreenerRowAvatar = 32;
  static const double marketScreenerRowGapMain = 10;
  static const double marketScreenerSparklineWidth = 58;
  static const double marketScreenerSparklineHeight = 24;
  static const double marketScreenerSparklineGap = 16;
  static const double marketScreenerValueWidth = 82;
  static const double marketScreenerTextGap = AppSpacing.x2;
  static const double marketScreenerTrendIcon = 12;
  static const double marketScreenerTrendGap = AppSpacing.x1;
  static const double marketScreenerRowTitleLineHeight = 1.1;
  static const double marketScreenerRowMetaLineHeight = 1.3;
  static const double marketScreenerTrendLineHeight = 1.2;
  static const double marketScreenerEmptyIcon = 36;
  static const double marketScreenerEmptyGap = 12;
  static const double marketScreenerSparklineStroke = 1.7;
  static const EdgeInsets marketScreenerAdvancedPadding = EdgeInsets.all(16);
  static const EdgeInsets marketScreenerResetPadding = EdgeInsets.symmetric(
    horizontal: 8,
  );
  static const EdgeInsets marketScreenerPresetPadding = EdgeInsets.symmetric(
    horizontal: 11,
  );
  static const EdgeInsets marketScreenerCategoryChipPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets marketScreenerInputPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: marketScreenerInputVerticalPadding,
  );
  static const EdgeInsets marketScreenerSortChipPadding = EdgeInsets.symmetric(
    horizontal: 6,
  );
  static const EdgeInsets marketScreenerRowPadding = EdgeInsets.fromLTRB(
    14,
    9,
    14,
    9,
  );
  static const EdgeInsets marketScreenerEmptyPadding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 42,
  );
  static EdgeInsets marketScreenerScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double marketNewsNativeBottomExtra = AppSpacing.contentPad;
  static const double marketNewsVisualBottomExtra = 54;
  static const double marketNewsPageGap = 14;
  static const double marketNewsBreakingTimeGap = 10;
  static const double marketNewsBreakingTitleGap = 10;
  static const double marketNewsBreakingTitleLineHeight = 1.38;
  static const double marketNewsBreakingDot = AppSpacing.x3;
  static const double marketNewsBreakingDotGap = 6;
  static const double marketNewsBreakingTokenGap = AppSpacing.x3;
  static const double marketNewsFilterGap = AppSpacing.x3;
  static const double marketNewsSentimentIcon = 12;
  static const double marketNewsSentimentIconGap = AppSpacing.x2;
  static const double marketNewsFeedGap = 6;
  static const double marketNewsCardIcon = 40;
  static const double marketNewsCardIconGlyph = AppSpacing.x5;
  static const double marketNewsCardIconGap = 12;
  static const double marketNewsCardTagGap = AppSpacing.x2;
  static const double marketNewsCardTitleGap = 6;
  static const double marketNewsCardTitleLineHeight = 1.35;
  static const double marketNewsSaveGap = AppSpacing.x3;
  static const double marketNewsSavePadding = 4;
  static const double marketNewsSaveIcon = 18;
  static const double marketNewsTagSpacing = 6;
  static const double marketNewsTagRunSpacing = 4;
  static const double marketNewsTagIcon = AppSpacing.x3;
  static const double marketNewsTagIconGap = 2;
  static const double marketNewsMetaIcon = 10;
  static const double marketNewsMetaIconGap = 4;
  static const double marketNewsMetaSeparatorGap = 7;
  static const double marketNewsExpandedSummaryLineHeight = 1.55;
  static const double marketNewsExpandedGap = 12;
  static const double marketNewsExpandedTokenGap = AppSpacing.x3;
  static const double marketNewsExpandedTokenIconGap = 4;
  static const double marketNewsExpandedTokenIcon = 14;
  static const double marketNewsEmptyVerticalPadding = 48;
  static const double marketNewsEmptyIcon = 40;
  static const double marketNewsEmptyGap = 12;
  static const EdgeInsets marketNewsBreakingPadding = EdgeInsets.all(16);
  static const EdgeInsets marketNewsBreakingBadgePadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 3,
  );
  static const EdgeInsets marketNewsBreakingTokenPadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 3,
  );
  static const EdgeInsets marketNewsCategoryChipPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );
  static const EdgeInsets marketNewsSentimentChipPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 7,
  );
  static const EdgeInsets marketNewsCardPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 13,
  );
  static const EdgeInsets marketNewsSavePaddingInsets = EdgeInsets.all(
    marketNewsSavePadding,
  );
  static const EdgeInsets marketNewsTagPadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 2,
  );
  static const EdgeInsets marketNewsMetaSeparatorPadding = EdgeInsets.symmetric(
    horizontal: marketNewsMetaSeparatorGap,
  );
  static const EdgeInsets marketNewsExpandedPadding = EdgeInsets.fromLTRB(
    16,
    12,
    16,
    14,
  );
  static const EdgeInsets marketNewsExpandedTokenPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 6,
  );
  static const EdgeInsets marketNewsEmptyPadding = EdgeInsets.symmetric(
    vertical: marketNewsEmptyVerticalPadding,
  );
  static const EdgeInsets marketNewsEmptyCtaPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  );
  static EdgeInsets marketNewsScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double marketCalendarNativeBottomExtra = AppSpacing.contentPad;
  static const double marketCalendarVisualBottomExtra = 54;
  static const double marketCalendarPageGap = 16;
  static EdgeInsets marketCalendarScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double marketCalendarGroupGap = AppSpacing.x3;
  static const double marketCalendarDateHeaderGap = AppSpacing.x3;
  static const double marketCalendarEventIcon = 36;
  static const double marketCalendarEventIconGlyph = 18;
  static const double marketCalendarEventIconGap = 12;
  static const double marketCalendarBadgeSpacing = 6;
  static const double marketCalendarBadgeRunSpacing = 4;
  static const double marketCalendarEventTitleGap = 6;
  static const double marketCalendarEventMetaGap = AppSpacing.x3;
  static const double marketCalendarEventTimeIcon = AppSpacing.x4;
  static const double marketCalendarEventTimeGap = AppSpacing.x2;
  static const double marketCalendarEventImpactGap = 6;
  static const double marketCalendarEventCountdownGap = AppSpacing.x3;
  static const double marketCalendarEventSourceGap = AppSpacing.x3;
  static const double marketCalendarEventTitleLineHeight = 1.25;
  static const double marketCalendarEventDescriptionLineHeight = 1.5;
  static const double marketCalendarViewTabHeight = 54;
  static const double marketCalendarViewUnderlineHeight =
      AppSpacing.hairlineStroke;
  static const double marketCalendarStatsGap = AppSpacing.x3;
  static const double marketCalendarMiniStatHeight = 73;
  static const double marketCalendarMiniStatValueGap = AppSpacing.x3;
  static const double marketCalendarFilterGap = AppSpacing.x3;
  static const double marketCalendarFilterChipHeight = 36;
  static const double marketCalendarImpactDot = 6;
  static const double marketCalendarMonthTitleGap = 16;
  static const double marketCalendarGridSpacing = AppSpacing.hairlineStroke * 2;
  static const double marketCalendarGridAspect = 1.0;
  static const int marketCalendarGridColumns = 7;
  static const double marketCalendarMonthDividerTopGap = 14;
  static const double marketCalendarMonthLegendTopGap = 12;
  static const double marketCalendarEventDot = AppSpacing.hairlineStroke * 2;
  static const double marketCalendarEventDotGap = AppSpacing.hairlineStroke;
  static const double marketCalendarLegendSpacing = 12;
  static const double marketCalendarLegendRunSpacing = AppSpacing.x3;
  static const double marketCalendarLegendDot = AppSpacing.x3;
  static const double marketCalendarLegendGap = AppSpacing.x2;
  static const double marketCalendarDayBorderWidth = 1.5;
  static const EdgeInsets marketCalendarEventCardPadding = EdgeInsets.all(14);
  static const EdgeInsets marketCalendarEventExpandedPadding =
      EdgeInsets.fromLTRB(14, 12, 14, 14);
  static const EdgeInsets marketCalendarMiniStatPadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 10,
  );
  static const EdgeInsets marketCalendarFilterChipPadding =
      EdgeInsets.symmetric(horizontal: 13, vertical: 8);
  static const EdgeInsets marketCalendarImpactChipPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 6);
  static const EdgeInsets marketCalendarMonthPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const double marketSectorsNativeBottomExtra =
      AppSpacing.contentPad + AppSpacing.x1;
  static const double marketSectorsVisualBottomExtra = 52;
  static EdgeInsets marketSectorsScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double marketSectorCardIcon = 42;
  static const double marketSectorCardIconGlyph = AppSpacing.x5;
  static const double marketSectorDetailIcon = 46;
  static const double marketSectorDetailIconGlyph = 24;
  static const double marketSectorDistributionIcon = 26;
  static const double marketSectorDistributionIconGlyph = 16;
  static const double marketSectorTopCoinAvatar = 32;
  static const double marketSectorTopCoinRowHeight = 52;
  static const double marketSectorDistributionHeight = 132;
  static const double marketSectorDistributionBarHeight = 12;
  static const double marketSectorDominanceHeight = 6;
  static const double marketSectorLegendDot = AppSpacing.x3;
  static const double marketSectorControlHeight = 32;
  static const double marketSectorControlChipGap = AppSpacing.x3;
  static const double marketSectorControlGroupGap = 10;
  static const double marketSectorControlChipPadX = 10;
  static const double marketSectorComparisonCellWidth = 54;
  static const double marketSectorComparisonRowHeight = AppSpacing.x6;
  static const double marketSectorComparisonMarker = AppSpacing.x3;
  static const double marketSectorCardHeaderGap = 12;
  static const double marketSectorTitleGap = 4;
  static const double marketSectorCardSectionGap = 16;
  static const double marketSectorMetricGap = 14;
  static const double marketSectorMetricInlineGap = 6;
  static const double marketSectorDominanceLabelGap = 6;
  static const double marketSectorChipGap = AppSpacing.x3;
  static const double marketSectorDistributionHeaderGap = 10;
  static const double marketSectorDistributionBarGap = 14;
  static const double marketSectorLegendGap = AppSpacing.x2;
  static const double marketSectorComparisonHeaderGap = 10;
  static const double marketSectorComparisonMarkerGap = AppSpacing.x3;
  static const double marketSectorTopCoinPriceGap = 10;
  static const double marketSectorLineHeightTight = 1.0;
  static const double marketSectorLineHeightCompact = 1.1;
  static const double marketSectorLineHeightTitle = 1.2;
  static const EdgeInsets marketSectorCardPadding = EdgeInsets.all(16);
  static const EdgeInsets marketSectorTopCoinsPadding = EdgeInsets.all(12);
  static const EdgeInsets marketSectorDetailMetricPadding = EdgeInsets.all(12);
  static const EdgeInsets marketSectorComparisonPadding = EdgeInsets.all(14);
  static const EdgeInsets marketSectorComparisonRowPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.hairlineStroke);
  static const EdgeInsets marketSectorRefreshFooterPadding = EdgeInsets.only(
    top: AppSpacing.hairlineStroke,
  );
  static const EdgeInsets marketSectorControlChipPadding = EdgeInsets.symmetric(
    horizontal: marketSectorControlChipPadX,
  );
  static const double priceAlertsNativeBottomExtra = AppSpacing.contentPad;
  static const double priceAlertsVisualBottomExtra = 48;
  static const double priceAlertsSectionGap = AppSpacing.x4;
  static const double priceAlertsCardGap = 12;
  static const double priceAlertsAddNoticeGap = 10;
  static const double priceAlertsBottomReviewGap = 16;
  static const double priceAlertsFilterGap = AppSpacing.x3;
  static const double priceAlertsFilterHeight = 36;
  static const double priceAlertsStatGap = 12;
  static const double priceAlertsStatHeight = 72;
  static const double priceAlertsStatLabelGap = 9;
  static const double priceAlertsAvatar = 36;
  static const double priceAlertsHeaderGap = 10;
  static const double priceAlertsTrendIcon = 14;
  static const double priceAlertsTrendGap = 4;
  static const double priceAlertsToggleIcon = AppSpacing.x6;
  static const double priceAlertsActionGap = AppSpacing.x3;
  static const double priceAlertsDeleteIcon = 16;
  static const double priceAlertsProgressGap = 9;
  static const double priceAlertsProgressHeight = 7;
  static const double priceAlertsTargetGap = 17;
  static const double priceAlertsTargetWidth = 60;
  static const double priceAlertsTriggeredGap = AppSpacing.x4;
  static const double priceAlertsTriggeredDividerGap = 11;
  static const double priceAlertsTriggeredIcon = 15;
  static const double priceAlertsTriggeredIconGap = 7;
  static const double priceAlertsEmptyIcon = AppSpacing.x6;
  static const double priceAlertsEmptyGap = 10;
  static const double priceAlertsAddIcon = 18;
  static const double priceAlertsAddGap = AppSpacing.x3;
  static const double comparisonToolNativeBottomExtra = AppSpacing.contentPad;
  static const double comparisonToolVisualBottomExtra = 54;
  static const double comparisonToolPageGap = 18;
  static const double comparisonToolStripHeight = 52;
  static const double comparisonToolStripGap = 10;
  static const double comparisonToolAddWidth = 82;
  static const double comparisonToolAddIcon = 16;
  static const double comparisonToolAddGap = 6;
  static const double comparisonToolTokenAvatar = 28;
  static const double comparisonToolTokenTextGap = 9;
  static const double comparisonToolTokenMetricGap = AppSpacing.x2;
  static const double comparisonToolRemoveGap = AppSpacing.x3;
  static const double comparisonToolRemoveIcon = 14;
  static const double comparisonToolSparklineHeight = 48;
  static const double comparisonToolSparklineGap = 14;
  static const double comparisonToolSparklinePairGap = 18;
  static const double comparisonToolMetricSectionGap = 10;
  static const double comparisonToolMetricCardGap = 4;
  static const double comparisonToolMetricMinHeight = 66;
  static const double comparisonToolMetricValueGap = 12;
  static const double comparisonToolBestGap = 9;
  static const double comparisonToolDistributionHeight = 24;
  static const double comparisonToolDistributionGap = 12;
  static const double comparisonToolDistributionLegendGap = 14;
  static const double comparisonToolDistributionLegendRunGap = AppSpacing.x3;
  static const double comparisonToolLegendDot = 10;
  static const double comparisonToolLegendGap = 6;
  static const double comparisonToolMarketCapRowGap = AppSpacing.x2;
  static const double comparisonToolMarketCapBarHeight = 6;
  static const double comparisonToolNeedIcon = 42;
  static const double comparisonToolNeedGap = 12;
  static const double comparisonToolPickerSearchHeight = 40;
  static const double comparisonToolPickerIcon = 15;
  static const double comparisonToolPickerGap = 12;
  static const double comparisonToolPickerSearchIconGap = AppSpacing.x3;
  static const double comparisonToolPickerQuickHeight = AppSpacing.x6;
  static const double comparisonToolPickerQuickGap = AppSpacing.x3;
  static const double comparisonToolPickerListGap = 10;
  static const double comparisonToolPickerListMaxHeight = 190;
  static const double comparisonToolPickerRowHeight = 40;
  static const double comparisonToolPickerRowAvatar = 26;
  static const double comparisonToolPickerRowGap = 10;
  static const EdgeInsets comparisonToolSparklineCardPadding =
      EdgeInsets.fromLTRB(16, 16, 16, 14);
  static const EdgeInsets comparisonToolTokenPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets comparisonToolMetricCardPadding = EdgeInsets.fromLTRB(
    16,
    12,
    16,
    12,
  );
  static const EdgeInsets comparisonToolDistributionPadding = EdgeInsets.all(
    16,
  );
  static const EdgeInsets comparisonToolNeedPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
    vertical: 48,
  );
  static const EdgeInsets comparisonToolPickerPadding = EdgeInsets.all(16);
  static const EdgeInsets comparisonToolPickerSearchPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets comparisonToolPickerQuickPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets comparisonToolPickerRowPadding = EdgeInsets.symmetric(
    horizontal: 8,
  );
  static EdgeInsets comparisonToolScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets priceAlertsNoticePadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  );
  static const EdgeInsets priceAlertsFilterHeaderPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    13,
    AppSpacing.contentPad,
    13,
  );
  static const EdgeInsets priceAlertsFilterTabPadding = EdgeInsets.symmetric(
    horizontal: 13,
  );
  static const EdgeInsets priceAlertsCardPadding = EdgeInsets.fromLTRB(
    16,
    13,
    16,
    13,
  );
  static const EdgeInsets priceAlertsEmptyPadding = EdgeInsets.symmetric(
    vertical: 48,
    horizontal: 18,
  );
  static EdgeInsets priceAlertsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets marketAnalyticsHeroPadding = EdgeInsets.all(16);
  static const EdgeInsets marketAnalyticsStatPadding = EdgeInsets.all(12);
  static const EdgeInsets marketHeatmapSummaryPadding = EdgeInsets.all(13);
  static const EdgeInsets marketHeatmapControlsPadding = EdgeInsets.all(4);
  static const EdgeInsets marketHeatmapFilterPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets marketHeatmapLegendPadding = EdgeInsets.only(
    top: 4,
    bottom: 2,
  );
  static const EdgeInsets marketHeatmapSelectedCardPadding = EdgeInsets.all(15);
  static const EdgeInsets marketHeatmapDetailButtonPadding =
      EdgeInsets.symmetric(horizontal: 13);
  static const EdgeInsets marketHeatmapTrendCardPadding = EdgeInsets.all(13);
  static const EdgeInsets marketHeatmapTilePaddingLarge = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 5,
  );
  static const EdgeInsets marketHeatmapTilePaddingSmall = EdgeInsets.symmetric(
    horizontal: 4,
    vertical: 5,
  );
  static const EdgeInsets marketDepthPairSummaryPadding = EdgeInsets.all(16);
  static const EdgeInsets marketDepthHeaderPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );
  static const EdgeInsets marketDepthOrderRowPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets marketDepthMidPricePadding = EdgeInsets.symmetric(
    vertical: 10,
  );
  static const EdgeInsets marketDepthMiniStatPadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 13,
  );
  static const EdgeInsets marketDepthChartPadding = EdgeInsets.fromLTRB(
    16,
    16,
    16,
    12,
  );
  static const EdgeInsets marketDepthLevelChipPadding = EdgeInsets.symmetric(
    horizontal: 9,
    vertical: 6,
  );
  static const EdgeInsets marketDepthRatioPadding = EdgeInsets.all(16);
  static const EdgeInsets marketDepthWhaleCardPadding = EdgeInsets.all(16);
  static const EdgeInsets marketDepthWhaleSummaryPadding = EdgeInsets.all(12);
  static const EdgeInsets marketSocialDisclaimerPadding = EdgeInsets.all(12);
  static const EdgeInsets marketSocialDisclaimerIconPadding = EdgeInsets.only(
    top: 2,
  );
  static const EdgeInsets marketSocialFilterPadding = EdgeInsets.symmetric(
    horizontal: 13,
  );
  static const EdgeInsets marketSocialTinyBadgePadding = EdgeInsets.symmetric(
    horizontal: 5,
  );
  static const EdgeInsets marketSocialTinyBadgePaddingWide =
      EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets marketSocialSignalCardPadding = EdgeInsets.fromLTRB(
    16,
    12,
    16,
    14,
  );
  static const EdgeInsets marketSocialExpandedPadding = EdgeInsets.fromLTRB(
    16,
    10,
    16,
    14,
  );
  static const EdgeInsets marketSocialTargetSpacing = EdgeInsets.only(right: 8);
  static const EdgeInsets marketSocialCardPadding = EdgeInsets.all(16);
  static const EdgeInsets marketSocialResultPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets marketOverviewHistoryPadding = EdgeInsets.fromLTRB(
    16,
    18,
    16,
    14,
  );
  static const EdgeInsets marketOverviewToolPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 10,
  );
  static const EdgeInsets marketBodyReviewCardPadding = EdgeInsets.all(12);
  static const EdgeInsets marketMetricDeltaPillPadding = EdgeInsets.only(
    bottom: AppSpacing.dividerHairline,
  );
  static const EdgeInsets marketAdvancedClearButtonPadding =
      EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets marketAdvancedActiveChipPadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  static const EdgeInsets marketAdvancedFilterChipPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 7);
  static const EdgeInsets marketAdvancedIndicatorHeaderPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const EdgeInsets marketAdvancedCategoryBadgePadding =
      EdgeInsets.symmetric(horizontal: 6, vertical: 2);
  static const EdgeInsets marketAdvancedDetailsPadding = EdgeInsets.fromLTRB(
    16,
    10,
    16,
    14,
  );
  static const EdgeInsets marketAdvancedParamPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 6,
  );
  static const EdgeInsets marketAdvancedSignalMetricPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 9);
  static const EdgeInsets marketAdvancedPivotPadding = EdgeInsets.symmetric(
    vertical: 6,
  );
  static const EdgeInsets marketAdvancedCardPadding = EdgeInsets.all(16);
  static const EdgeInsets marketAdvancedCardPaddingCompact = EdgeInsets.all(12);
  static const EdgeInsets marketOverviewMoverCardPadding = EdgeInsets.fromLTRB(
    12,
    12,
    8,
    11,
  );
  static const EdgeInsets marketOverviewMoverHeaderPadding = EdgeInsets.only(
    right: 2,
  );
  static const EdgeInsets marketOverviewSectorListPadding =
      EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets marketOverviewSectorActionPadding =
      EdgeInsets.symmetric(vertical: 13);
  static const EdgeInsets marketAnalyticsMetricPadding = EdgeInsets.symmetric(
    horizontal: 9,
    vertical: 10,
  );
  static const double marketLineHeightTight =
      TradeSpacingTokens.tradeBotLineHeightTight;
  static const double marketLineHeightShort =
      TradeSpacingTokens.tradeBotLineHeightShort;
  static const double marketLineHeightCaption =
      TradeSpacingTokens.tradeBotLineHeightCaption;
  static const double marketLineHeightReadable =
      TradeSpacingTokens.tradeBotLineHeightReadable;
  static EdgeInsets pairDetailScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  // S7 (2026-08-29): children trực tiếp của pane scaffold chỉ được inset
  // NGANG — scaffold owns section gap dọc (13dp tier standard). Token này là
  // vai trò flush ngang của pane tablet SC-044; margin dọc Phone
  // (pairRiskMargin/pairLinkMargin/pairTradeCtaPadding) không được mang
  // sang children list — từng stack thành gap 23–29dp.
  static const EdgeInsets pairPaneChildFlushPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
  );
  // Hàng điều khiển (khung giờ/chú giải) trong khung chart của pane — lề
  // trái contentPad thẳng hàng khối giá, đáy x2 (5) tạo nhịp giữa các hàng.
  static const EdgeInsets pairPaneChartRowPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    0,
    AppSpacing.contentPad,
    AppSpacing.x2,
  );
  // Hướng 1 "Trading Desk" (2026-08-29): pane ≥ 700dp tách 2 cột — chart
  // nến cao 400 + cột phụ 300 (sổ lệnh + giao dịch luôn hiện); dưới ngưỡng
  // giữ khuôn 1 cột 4 tab như cũ. Ngưỡng ĐO THỰC (widget test, không ước
  // lượng): mặt 600/768/1024 → pane 464/632/556 (hẹp); mặt 1180/1280 →
  // pane 712/812 (desk) — tablet 1280dp thực luôn vào desk.
  static const double pairDeskSplitMinWidth = 700;
  static const double pairDeskChartHeight = 400;
  static const double pairDeskSideWidth = 300;
  static const double pairDeskGutter = AppSpacing.pageRhythmStandardSectionGap;
  // Dải đáy ghim của desk: giá gọn + MUA/BÁN luôn nhìn thấy, không cuộn.
  static const EdgeInsets pairDeskFooterPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    AppSpacing.x2,
    AppSpacing.contentPad,
    AppSpacing.x2,
  );
  static const double pairDeskFooterGap = AppSpacing.x3;
  // V2 Bybit (2026-08-30): thanh công cụ MỘT hàng trong panel chart — nút
  // khung giờ text phẳng thay 3 hàng rời (chips + pills + legend) từng bị
  // gạch là "dính nhau".
  static const EdgeInsets pairChartToolbarPadding = EdgeInsets.fromLTRB(
    AppSpacing.x3,
    AppSpacing.x2,
    AppSpacing.x3,
    AppSpacing.x2,
  );
  static const double pairIntervalGap = AppSpacing.x2;
  static const double pairIntervalDividerHeight = AppSpacing.x5;
  static const EdgeInsets pairIntervalButtonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );
  static const double pairIndicatorDot = AppSpacing.x1;
  // Terminal thuần (hướng C 2026-08-30): gutter đều giữa các panel phẳng,
  // hàng meta dày, mức sổ lệnh 26dp, dòng giao dịch 24dp.
  static const double pairTerminalGutter = AppSpacing.cardGap;
  static const EdgeInsets pairMetaStripPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x2,
  );
  static const double pairMetaGap = AppSpacing.x3;
  static const double pairMetaDividerHeight = AppSpacing.x5;
  static const EdgeInsets pairPanelHeaderPadding = EdgeInsets.fromLTRB(
    AppSpacing.x3,
    AppSpacing.x2,
    AppSpacing.x3,
    AppSpacing.x1,
  );
  static const double pairBookRowExtent = 26;
  static const EdgeInsets pairBookRowPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x1,
  );
  static const double pairTradeRowExtent = 24;
  // Panel tabbed cột phụ (V2-C): nội dung thụng lề, gạch chân tab active.
  static const EdgeInsets pairBookContentPadding = EdgeInsets.fromLTRB(
    AppSpacing.x3,
    AppSpacing.x2,
    AppSpacing.x3,
    AppSpacing.x3,
  );
  static const double pairBookTabUnderline = AppSpacing.x6;
  static const double pairDetailNativeBottomExtra = AppSpacing.contentPad;
  static const double pairDetailVisualBottomExtra = 54;
  // A11Y-2: matches VitHeaderActionButton's 44dp minimum tap target so the
  // back/action buttons' hit-test region isn't clamped by a fixed-width
  // ancestor sized for the older 40dp visual box.
  static const double pairHeaderLeadingWidth = AppSpacing.minTapTarget;
  static const EdgeInsets pairHeaderSymbolPadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: 8,
  );
  static const double pairHeaderLogo = 28;
  static const double pairHeaderSymbolGap = 9;
  static const double pairHeaderChevronGap = AppSpacing.x2;
  static const double pairHeaderChevron = 17;
  static const double pairHeaderTrailingGap = AppSpacing.x3;
  // A11Y-2: 2 md-size action buttons at their 44dp tap target width, plus
  // the gap — was hardcoded to fit the old 40dp visual width (88), which
  // overflowed by 8dp once the tap target grew.
  static const double pairHeaderTrailingWidth =
      AppSpacing.minTapTarget * 2 + pairHeaderTrailingGap;
  static const EdgeInsets pairPriceOverviewPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    16,
    AppSpacing.contentPad,
    14,
  );
  static const double pairPriceChangeGap = 12;
  static const EdgeInsets pairPriceChangePadding = EdgeInsets.symmetric(
    horizontal: 9,
    vertical: 6,
  );
  static const double pairPriceStatsGap = 15;
  static const double pairPriceStatGap = 2;
  static const EdgeInsets pairViewTabsPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    10,
    AppSpacing.contentPad,
    8,
  );
  static const double pairViewTabGap = AppSpacing.x3;
  static const double pairViewTabHeight = 38;
  static const EdgeInsets pairViewTabPadding = EdgeInsets.symmetric(
    horizontal: 8,
  );
  static const double pairViewTabIcon = 15;
  static const double pairViewTabIconGap = 6;
  static const EdgeInsets pairTimeframePadding = EdgeInsets.fromLTRB(
    24,
    0,
    AppSpacing.contentPad,
    5,
  );
  static const double pairTimeframeHeight = 36;
  // Chiều cao khung chart giá của pane chi tiết cặp — thay công thức magic
  // `buttonStandard*3 + x7` (172) khi nâng cấp chart thật 2026-08-29.
  static const double pairDetailChartHeight = 220;
  static const double pairIndicatorHeight = 42;
  static const EdgeInsets pairIndicatorListPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
  );
  static const double pairIndicatorGap = AppSpacing.x3;
  static const double pairIndicatorChipHeight = 36;
  static const EdgeInsets pairIndicatorChipPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
  );
  static const double pairChartHeight = 230;
  static const EdgeInsets pairRiskMargin = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    10,
    AppSpacing.contentPad,
    AppSpacing.x4,
  );
  static const EdgeInsets pairRiskPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );
  static const double pairRiskIcon = 14;
  static const double pairRiskGap = 9;
  static const EdgeInsets pairLinkMargin = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    0,
    AppSpacing.contentPad,
    AppSpacing.x4,
  );
  static const EdgeInsets pairLinkPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );
  static const double pairLinkIconBox = 40;
  static const double pairLinkIcon = 19;
  static const double pairLinkGap = AppSpacing.x4;
  static const double pairLinkSubtitleGap = AppSpacing.hairlineStroke;
  static const double pairLinkChevron = 20;
  static const EdgeInsets pairTradeCtaPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    0,
    AppSpacing.contentPad,
    16,
  );
  static const double pairTradeCtaGap = 12;
  static const double pairTradeButtonHeight = AppSpacing.x7;
  static const EdgeInsets pairOrderPanelPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    4,
    AppSpacing.contentPad,
    8,
  );
  static const EdgeInsets pairOrderCardPadding = EdgeInsets.all(14);
  static const double pairOrderSectionGap = 12;
  static const double pairOrderDividerHeight = AppSpacing.contentPad;
  static const EdgeInsets pairDepthRowPadding = EdgeInsets.symmetric(
    vertical: 4,
  );
  static const EdgeInsets pairTradeHeaderPadding = EdgeInsets.only(bottom: 8);
  static const EdgeInsets pairTradeRowPadding = EdgeInsets.symmetric(
    vertical: 5,
  );
}
