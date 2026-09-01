import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

final class WalletSpacingTokens {
  const WalletSpacingTokens._();

  static const double walletHorizontalPadding = 20;
  static const double walletAssetHeroHeight = 238;
  static const double walletAssetHeroPaddingTop = 16;
  static const double walletAssetHeroPaddingBottom = 14;
  static const EdgeInsets walletAssetHeroPadding = EdgeInsets.fromLTRB(
    walletHorizontalPadding,
    walletAssetHeroPaddingTop,
    walletHorizontalPadding,
    walletAssetHeroPaddingBottom,
  );
  static const double walletAssetChartHeight = 209;
  static const EdgeInsets walletAssetStatPillPadding = EdgeInsets.fromLTRB(
    walletAssetPillHorizontalPad,
    walletAssetPillVerticalPad,
    AppSpacing.x3,
    walletAssetPillBottomPad,
  );
  static const double walletAssetLogoSize = 52;
  // A11Y-3: was 52 — raised so the label+value fit at the app-wide 1.3x
  // text-scaling clamp without overflowing (see homeRecentProductHeight).
  static const double walletAssetStatHeight = 60;
  static const double walletAssetActionHeight = 90;
  static const double walletAssetActionIcon = 40;
  static const double walletHistoryActionHeight = 30;
  static const double walletHistorySectionHeaderHeight = 41;
  static const double walletHistoryAmountColumnWidth = 126;
  static const double walletHistoryItemMinHeight = 84;
  static const double walletTransactionSummaryIconSize = 56;
  static const double walletTransactionSummaryBadgeHeight = AppSpacing.x6;
  static const double walletTransactionProgressDotSize = AppSpacing.x4;
  static const double walletHistoryDividerWidth = 31;
  static const double walletAssetHeroTopGap = 12;
  static const double walletAssetHeroValueGap = 6;
  static const double walletAssetSmallGap = 7;
  static const double walletAssetPillHorizontalPad = 10;
  static const double walletAssetPillVerticalPad = 6;
  static const double walletAssetPillBottomPad = 6;
  static const double walletAssetPillGap = 9;
  static const double walletAssetActionIconInner = 22;
  static const double walletAssetActionGap = 12;
  static const EdgeInsets walletAssetActionTilePadding = EdgeInsets.symmetric(
    vertical: AppSpacing.sectionGapCompact,
  );
  static const double walletAssetPeriodChipHeight = 27;
  static const double walletAssetPeriodChipPadX = 11;
  static const EdgeInsets walletAssetPeriodChipPadding = EdgeInsets.symmetric(
    horizontal: walletAssetPeriodChipPadX,
  );
  static const double walletAssetChartBottomPad = 14;
  static const double walletAssetChartBottomGap = 10;
  static const double walletAssetTransactionIcon = 36;
  static const double walletAssetTransactionGlyph = 18;
  static const double walletAssetTransactionsGap = 12;
  static const double walletHistoryExportBarPadH = 14;
  static const double walletHistoryExportBarPadV = 10;
  static const double walletHistoryFilterTextPadX = AppSpacing.x2;
  static const double walletHistoryExportIcon = 12;
  static const double walletHistoryExportIconGap = AppSpacing.x2;
  static const double walletHistoryExportChipPadX = 11;
  static const double walletHistorySectionPadLeft = 19;
  static const double walletHistoryTradeIcon = 24;
  static const double walletHistoryTradeIconGlyph = 14;
  static const double walletHistoryTradeBadgeRadius = 6;
  static const double walletHistoryStatusBadgePadH = 7;
  static const double walletHistoryStatusBadgePadV = AppSpacing.x1;
  static const double walletHistoryLineSpacing = 4;
  static const double walletHistoryTextSpacing = AppSpacing.x2;
  static const double walletHistoryStatusBadgeHeightGap = 6;
  static const double walletHistoryRowToChevronGap = 9;
  static const double walletHistoryRowChevronGap = 9;
  static const double walletHistoryEndListTopPad = 28;
  static const double walletHistoryEndListBottomPad = 20;
  static const double walletHistoryEndListGap = 10;
  static const double walletHistoryDividerHeight = 1;

  /// Tablet surface alias (2026-09-01): divider metrics stay in the Tablet
  /// namespace while Phone/shared history keeps the legacy token above.
  static const double walletTabletHistoryDividerHeight =
      TabletSpacingTokens.dividerHairline;
  static const double walletHistoryFilterTopPad = 24;
  static const double walletHistoryGroupTopPad = 22;
  static const double walletHistoryTitleSpacing = 17;
  static const double walletHistoryFilterGap = 12;
  static const double walletTransactionSummaryBadgePadH = AppSpacing.x4;
  static const double walletTransactionSummarySectionVPad = AppSpacing.x5;
  @Deprecated('Use AppSpacing.pageRhythmFormSectionGap')
  static const double walletAssetSectionGap =
      AppSpacing.pageRhythmFormSectionGap;
  static const double walletAssetTransactionsTopPad = 19;
  static const EdgeInsets walletTransactionSummaryPadding = EdgeInsets.fromLTRB(
    20,
    21,
    20,
    20,
  );
  static const double walletTransactionDetailsPadH = 20;
  static const double walletTransactionSummaryTopGap = 16;
  static const EdgeInsets walletTransactionSummaryHeaderPadding =
      EdgeInsets.fromLTRB(20, 20, 20, 12);
  static const EdgeInsets walletTransactionDetailRowPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 13);
  static const double walletTransactionSummaryStatusIcon = 29;
  static const double walletTransactionStepSpacing = 23;
  static const double walletTransactionStepLineHeight = 36;
  static const double walletDepositWarningCardMinHeight = 129;
  @Deprecated('Use AppSpacing.pageRhythmFormSectionGap')
  static const double walletDepositSectionGap =
      AppSpacing.pageRhythmFormSectionGap;
  static const double walletDepositTitleGap = 12;
  static const EdgeInsets walletDepositSelectorPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const EdgeInsets walletDepositWarningPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: AppSpacing.rowPy,
  );
  static const double walletDepositCopyIcon = 15;
  static const double walletDepositCopyButtonHeight = 42;
  static const EdgeInsets walletDepositCopyButtonPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const double walletDepositQrCodeSize = 180;
  static const double walletDepositQrShadowBlur = 32;
  static const double walletDepositQrShadowOffsetY = AppSpacing.x3;
  static const double walletDepositTopGap = 24;
  static const double walletTransactionProgressLineWidth = 2;
  static const double walletTransactionProgressLineSpacing = 4;
  static const double walletTransactionProgressVerticalGap = 9;
  static const double walletTransactionAfterHashGap = 18;
  static const double walletTransactionProgressBottomGap = 17;
  static const double walletTransactionStatusBadgeIcon = 15;
  static const double walletTransactionInfoRowMinHeight = 44;
  static const double walletTransactionCopyIconSize = 27;
  static const double walletTransactionExplorerHeight = 48;
  static const double walletTransactionExplorerLabelGap = AppSpacing.x3;
  static const double walletTransactionActionIcon = 16;
  static const double walletTransactionCopyIconGlyph = 14;
  static const double walletTransactionDetailsPadVertical = AppSpacing.x4;
  static const double walletTransactionDetailsBottomPad = 12;
  static const EdgeInsets walletTransactionProgressCardPadding =
      EdgeInsets.fromLTRB(16, 17, 16, 18);
  static const double walletTransactionMissingTopPad = 56;
  static const double walletTransactionMissingIcon = 64;
  static const double walletTransactionMissingActionHeight = 42;
  static const double walletTransactionMissingActionPad = 20;

  static const double walletVisualChromePad = 92;
  static const double walletNativeChromePad = 28;
  static const double walletBuyBannerHeight = 57;
  static const double walletBuyBannerGap = 17;
  static const double walletBuyAmountCardMinHeight = 252;
  static const double walletBuyAmountCardGap = 19;
  static const double walletBuyPaymentTitleGap = 18;
  @Deprecated('Use AppSpacing.pageRhythmFormSectionGap')
  static const double walletBuySectionGap = AppSpacing.pageRhythmFormSectionGap;
  static const double walletBuyAmountLabelGap = AppSpacing.x5;
  static const double walletBuyPresetGap = 24;
  static const double walletBuyReceiveGap = 17;
  static const double walletBuyPresetChipHeight = 30;
  static const double walletBuyReceivePanelHeight = 66;
  static const double walletBuySelectorHeight = 42;
  static const double walletBuyPaymentCardHeight = 64;
  static const double walletBuyPaymentLogoSize = 40;
  static const double walletBuySuccessIconSize = 88;
  static const double walletBuySuccessIconRadius = 44;
  static const double walletBuySuccessGlyph = 46;
  static const double walletBuyCryptoLogoSize = 40;
  static const double walletBuyCryptoLogoCompact = 25;
  static const double walletBuyInlineGap = 12;
  static const double walletBuyCompactGap = 10;
  static const double walletBuyMicroGap = 7;
  static const double walletBuyGroupIconGap = 6;
  static const double walletBuyPaymentMetaGap = AppSpacing.x2;
  static const double walletBuyPaymentPopularGap = AppSpacing.x3;
  static const double walletBuyPaymentCardGap = AppSpacing.rowGap;
  static const double walletBuyConfirmAmountGap = 20;
  static const double walletBuySuccessTopPad = 40;
  static const double walletBuySuccessBottomPad = 120;
  static const double walletBuySuccessTitleGap = 22;
  static const double walletBuySuccessCtaGap = 24;
  static const double walletBuyAmountLineHeight =
      TradeSpacingTokens.tradeBotLineHeightTight;
  static const double walletBuyReceiveLineHeight = 1.1;
  static const double walletBuyMetaLineHeight =
      TradeSpacingTokens.tradeBotLineHeightCaption;
  static const double walletBuyBannerLineHeight =
      TradeSpacingTokens.tradeBotLineHeightReadable;
  static const EdgeInsets walletBuyBannerPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const EdgeInsets walletBuyAmountCardPadding = EdgeInsets.fromLTRB(
    20,
    22,
    20,
    20,
  );
  static const EdgeInsets walletBuyReceivePanelPadding = EdgeInsets.fromLTRB(
    14,
    10,
    14,
    10,
  );
  static const EdgeInsets walletBuySelectorPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const EdgeInsets walletBuyPopularBadgePadding = EdgeInsets.symmetric(
    horizontal: 7,
    vertical: 4,
  );
  static const EdgeInsets walletBuyPaymentCardPadding = EdgeInsets.fromLTRB(
    12,
    10,
    13,
    10,
  );
  static const EdgeInsets walletBuyRateInfoPadding = EdgeInsets.fromLTRB(
    16,
    15,
    16,
    15,
  );
  static const EdgeInsets walletBuyConfirmPadding = EdgeInsets.all(20);
  static const EdgeInsets walletBuySuccessPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    walletBuySuccessTopPad,
    AppSpacing.contentPad,
    walletBuySuccessBottomPad,
  );
  static const EdgeInsets walletBuyOptionRowMargin = EdgeInsets.only(
    bottom: walletBuyPaymentCardGap,
  );
  static const EdgeInsets walletBuyOptionRowPadding = EdgeInsets.all(12);
  static const EdgeInsets walletNetworkStatusPageScrollPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        0,
      );
  static const EdgeInsets walletMultiManagerPageScrollPadding =
      EdgeInsets.fromLTRB(AppSpacing.contentPad, 12, AppSpacing.contentPad, 0);
  static const double transferSectionGap = 18;
  static const double transferCardGap = 9;
  static const double transferHintGap = 6;
  static const double transferTileGap = 7;
  static const double transferInputGap = 12;
  static const double transferInfoGap = 14;
  static const double transferCardHeight = 99;
  static const double transferAmountCardHeight = 90;
  static const double transferNoticeMinHeight = 59;
  static const EdgeInsets transferCardPadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    14,
  );
  static const EdgeInsets transferCardInnerPadding = EdgeInsets.symmetric(
    vertical: 12,
    horizontal: 16,
  );
  static const EdgeInsets transferNoticePadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets transferSuccessPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  );
  static const double transferIcon = 40;
  static const double transferActionIcon = 20;
  static const double transferSwapButton = 40;
  static const double transferSwapButtonShadow = 14;
  static const double transferSwapButtonShadowOffset = 4;
  static const double transferListIcon = 36;
  static const double transferBadgeIcon = 18;
  static const double transferHistoryRowPadding = 12;
  static const EdgeInsets transferSheetPadding = EdgeInsets.fromLTRB(
    20,
    16,
    20,
    24,
  );
  static EdgeInsets transferSheetPaddingWithAdditionalBottom(
    double bottomInset,
  ) => EdgeInsets.fromLTRB(
    transferSheetPadding.left,
    transferSheetPadding.top,
    transferSheetPadding.right,
    transferSheetPadding.bottom + bottomInset,
  );
  static const double walletWithdrawPrimaryGap = 16;
  static const double walletWithdrawSectionGap = 14;
  static const EdgeInsets walletWithdrawBalancePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.contentPad,
  );
  static const EdgeInsets walletWithdrawSelectorPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const EdgeInsets walletWithdrawScanButtonPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.rowGap);
  static const EdgeInsets walletWithdrawInputSuffixPadding = EdgeInsets.only(
    left: AppSpacing.searchBarHorizontalTrailingPadding,
  );
  static const EdgeInsets walletWithdrawRecentAddressPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x2);
  static const EdgeInsets walletWithdrawSupportPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: AppSpacing.x2,
  );
  static const EdgeInsets walletWithdrawNetworkOptionMargin = EdgeInsets.only(
    bottom: AppSpacing.x2,
  );
  static const EdgeInsets walletWithdrawNetworkOptionPadding =
      EdgeInsets.symmetric(
        horizontal: AppSpacing.searchBarHorizontalPadding,
        vertical: AppSpacing.rowGap,
      );
  static const EdgeInsets walletWithdrawPreviewRowPadding = EdgeInsets.only(
    bottom: AppSpacing.rowGap,
  );
  static const double walletAllocationChartSize = 92;
  static const double walletAllocationChartStroke = 16;
  static const double walletAllocationChartInset = AppSpacing.x3;

  /// Tablet surface alias (2026-09-01): keep the chart geometry owned by the
  /// Tablet namespace while the shared/Phone counterpart stays on AppSpacing.
  static const double walletTabletAllocationChartInset = TabletSpacingTokens.x3;
  static const double walletAllocationCenterRadius = 22;
  static const double walletAllocationLegendMarker = 10;
  static const double walletAllocationLegendGap = AppSpacing.x3;
  static const double walletAllocationLegendItemGap = 10;
  static const EdgeInsets walletTransferHistoryRowPadding =
      EdgeInsets.symmetric(vertical: transferHistoryRowPadding);
  static const EdgeInsets walletTransferConfirmRowPadding =
      EdgeInsets.symmetric(vertical: transferTileGap);
  static const EdgeInsets walletTransferNoteIconPadding = EdgeInsets.only(
    top: AppSpacing.x1,
  );
  static const double walletAddressCardHeight = 168;
  static const EdgeInsets walletAddressCardPadding = EdgeInsets.all(16);
  static const double walletAddressIconSize = 40;
  static const double walletAddressShieldIcon = 19;
  static const double walletAddressPrimaryGap = AppSpacing.x4;
  static const double walletAddressMetaGap = 6;
  static const double walletAddressCompactGap = 4;
  static const double walletAddressActionGap = 10;
  static const double walletAddressCopyHeight = 36;
  static const double walletAddressActionSize = 36;
  static const double walletAddressActionIcon = 17;
  static const EdgeInsets walletAddressEmptyPadding = EdgeInsets.symmetric(
    vertical: 42,
  );
  static const double walletAddressEmptyIconSize = 64;
  static const double walletAddressEmptyIconGlyph = 32;
  static const double walletAddressFilterHeight = 30;
  static const EdgeInsets walletAddressFilterPadding = EdgeInsets.symmetric(
    horizontal: 13,
  );

  /// Tablet-only control inset (2026-09-01): the address-book ghost action
  /// uses the Tablet block token 12dp; the Phone counterpart keeps 13dp.
  static const EdgeInsets walletAddressTabletFilterPadding =
      EdgeInsets.symmetric(horizontal: TabletSpacingTokens.x4);
  static const double walletAddressFilterGap = 16;
  static const double walletAddressStatsHeight = 70;
  static const double walletAddressStatsGap = AppSpacing.x3;
  static const double walletAddressStatsValueGap = 9;
  static const double walletAddressSectionIcon = 15;
  static const double walletAddressSectionGap = 6;
  static const double walletAddressSecurityCardHeight = 74;
  static const EdgeInsets walletAddressSecurityPadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    14,
  );
  static const double walletAddressSwitchBorder = 1.4;
  static const EdgeInsets walletAddressAddSheetPadding = transferSheetPadding;
  static const double walletAddressAddSheetTitleGap = AppSpacing.x3;
  static const double walletAddressAddSheetSectionGap = 14;
  static const double walletAddressAddFooterHeight = 72;
  static const EdgeInsets walletAddressAddFooterPadding = EdgeInsets.fromLTRB(
    20,
    16,
    20,
    8,
  );
  static const EdgeInsets walletAddressAddSuccessPadding = EdgeInsets.symmetric(
    horizontal: 32,
  );
  static const double walletAddressAddSuccessIconSize = 80;
  static const double walletAddressAddSuccessIconGlyph = 42;
  static const double walletAddressAddSuccessTitleGap = 20;
  static const double walletAddressAddSuccessMessageGap = AppSpacing.x3;
  static const double walletAddressAddSuccessPillGap = 18;
  static const EdgeInsets walletAddressAddStatusPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 10,
  );
  static const double walletAddressAddWhitelistHeight = 80;
  static const double walletAddressAddSwitchWidth = 44;
  static const double walletAddressAddSwitchHeight = 24;
  static const double walletAddressAddSwitchKnob = 18;
  static const EdgeInsets walletAddressAddSwitchKnobMargin =
      EdgeInsets.symmetric(horizontal: 3);
  static const double walletAddressAddSwitchBorder = 1.5;
  static const EdgeInsets walletAddressAddWarningIconPadding = EdgeInsets.only(
    top: 2,
  );
  static const double walletAddressAddAgreementBox = 24;
  static const EdgeInsets walletAddressAddAgreementBoxMargin = EdgeInsets.only(
    top: 2,
  );
  static const double walletAddressAddAgreementRadius = 9;
  static const double walletAddressAddAgreementBorder = 2;
  static const double walletAddressAddAgreementIcon = 16;
  static const EdgeInsets walletAddressAddInputPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const EdgeInsets walletAddressAddWalletInputPadding = EdgeInsets.only(
    left: 16,
    right: 9,
  );
  static const double walletAddressAddIconButton = 32;
  static const double walletAddressAddIcon = 16;
  static const EdgeInsets walletAddressAddHelperPadding = EdgeInsets.fromLTRB(
    4,
    6,
    4,
    0,
  );
  static const EdgeInsets walletAddressAddHintPadding = EdgeInsets.only(
    left: 4,
  );
  static const double walletAddressAddFormSectionGap = 26;
  static const double walletAddressAddAssetLabelGap = 12;
  static const double walletAddressAddAddressSectionGap = AppSpacing.x6;
  static const double walletAddressAddHintGap = AppSpacing.x2;
  static const double walletAddressAddMemoGap = 28;
  static const double walletAddressAddAgreementGap = 24;
  static const double walletAddressAddPreviewGap = 18;
  static const double walletAddressAddMemoHeight = 48;
  static const double walletAddressAddNetworkSpacing = 10;
  static const double walletAddressAddNetworkRunSpacing = AppSpacing.x3;
  static const double walletAddressAddNetworkChipWidth = 126.5;
  static const double walletAddressAddNetworkChipHeight = 40;
  static const EdgeInsets walletAddressAddNetworkChipPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const double walletAddressAddNetworkDot = 12;
  static const double walletAddressAddAssetSpacing = 17;
  static const double walletAddressAddAssetRunSpacing = 12;
  static const double walletAddressAddAssetChipWidth = 53;
  static const double walletAddressAddAssetChipWideWidth = 64;
  static const double walletAddressAddAssetChipHeight = AppSpacing.x6;
  static const double walletAddressAddScrollBottomExtra = 112;
  static EdgeInsets walletAddressAddScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(20, 14, 20, bottomInset);
  static const double walletTokenSectionGap = 18;
  static const double walletTokenAlertGap = 17;
  static const double walletTokenLabelGap = 11;
  static const double walletTokenCardGap = AppSpacing.rowGap;
  static const double walletTokenNoticeGap = 16;
  static const double walletTokenOverviewHeight = 203;
  static const EdgeInsets walletTokenOverviewPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    16,
  );
  static const double walletTokenHeroIcon = 48;
  static const double walletTokenHeroIconGlyph = 25;
  static const double walletTokenHeroGap = AppSpacing.x4;
  static const double walletTokenTitleGap = AppSpacing.x3;
  static const double walletTokenMetricTopGap = 14;
  static const double walletTokenMetricValueGap = AppSpacing.x3;
  static const double walletTokenAlertHeight = 104;
  static const EdgeInsets walletTokenAlertPadding = EdgeInsets.fromLTRB(
    16,
    18,
    16,
    16,
  );
  static const double walletTokenAlertIcon = 17;
  static const double walletTokenSectionMarkerWidth = 4;
  static const double walletTokenSectionMarkerHeight = 14;
  static const double walletTokenSectionMarkerRadius = 2;
  static const double walletTokenApprovalMinHeight = 212;
  static const double walletTokenApprovalWarningMinHeight = 252;
  static const EdgeInsets walletTokenApprovalPadding = EdgeInsets.fromLTRB(
    16,
    16,
    16,
    14,
  );
  static const double walletTokenApprovalHeaderGap = 10;
  static const double walletTokenApprovalActionGap = AppSpacing.x3;
  static const double walletTokenApprovalActionSize = 32;
  static const double walletTokenApprovalActionIcon = 16;
  static const double walletTokenApprovalContentGap = 18;
  static const double walletTokenApprovalAmountGap = 15;
  static const double walletTokenApprovalUnusedGap = 16;
  static const double walletTokenApprovalUnusedHeight = 30;
  static const EdgeInsets walletTokenApprovalUnusedPadding =
      EdgeInsets.symmetric(horizontal: 10);
  static const double walletTokenApprovalUnusedIcon = 12;
  static const double walletTokenApprovalUnusedTextGap = 6;
  static const double walletTokenCategoryIcon = 32;
  static const double walletTokenCategoryGlyph = 17;
  static const double walletTokenHeaderWrapSpacing = AppSpacing.x3;
  static const double walletTokenHeaderRunSpacing = 6;
  static const double walletTokenVerifiedIcon = AppSpacing.x4;
  static const double walletTokenSpenderGap = 11;
  static const double walletTokenMaskedGap = 14;
  static const double walletTokenRiskBadgeHeight = 17;
  static const EdgeInsets walletTokenRiskBadgePadding = EdgeInsets.symmetric(
    horizontal: 8,
  );
  static const double walletTokenAmountHeight = 36;
  static const EdgeInsets walletTokenAmountPadding = EdgeInsets.symmetric(
    horizontal: 10,
  );
  static const double walletTokenStatValueGap = 10;
  static const double walletTokenNoticeMinHeight = 58;
  static const EdgeInsets walletTokenNoticePadding = EdgeInsets.fromLTRB(
    14,
    12,
    14,
    12,
  );
  static const double walletTokenNoticeIcon = 14;
  static const double walletTokenSheetButtonHeight = 46;
  static const double walletTokenScanButtonHeight = 48;
  static const EdgeInsets walletTokenSwitchPadding = EdgeInsets.all(2);
  static const double walletTokenSwitchKnob = 24;
  static const EdgeInsets walletTokenHistoryRowPadding = EdgeInsets.all(14);
  static const double walletTokenTabsHeight = 54;
  static const double walletTokenTabIndicatorInset = 7;
  static const double walletNetworkActionIconBox = 32;
  static const double walletNetworkActionIcon = 18;
  static const double walletNetworkStatHeight = 48;
  static const EdgeInsets walletNetworkStatPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 5,
  );
  static const double walletNetworkStatTextGap = AppSpacing.x2;
  static const double walletNetworkProgressHeight = AppSpacing.x2;
  static const double walletNetworkAvailabilityHeight = 30;
  static const EdgeInsets walletNetworkNotePadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 9,
  );
  static const EdgeInsets walletNetworkSummaryPadding = EdgeInsets.fromLTRB(
    20,
    21,
    20,
    20,
  );
  static const double walletNetworkSummaryIcon = 44;
  static const double walletNetworkSummaryIconGlyph = 23;
  static const double walletNetworkSummaryStatHeight = 59;
  static const double walletNetworkLegendIcon = 22;
  static const double walletNetworkLegendIconGlyph = 12;
  static const EdgeInsets walletNetworkDisclaimerPadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    14,
  );
  static const EdgeInsets walletNetworkHealthPillPadding = EdgeInsets.symmetric(
    horizontal: 7,
    vertical: 4,
  );
  static const double walletNetworkHealthPillRadius = 7;
  static const double walletPendingBottomInsetVisual = walletVisualChromePad;
  static const double walletPendingBottomInsetNative = walletNativeChromePad;
  static const double walletPendingProgressHeight = 6;
  static const double walletAnalyticsBottomInsetVisual = walletVisualChromePad;
  static const double walletAnalyticsBottomInsetNative = walletNativeChromePad;
  static const double walletAnalyticsPageTopPadding = AppSpacing.x4;
  static const double walletAnalyticsContentGap = 18;
  static EdgeInsets walletAnalyticsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        walletAnalyticsPageTopPadding,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double walletAnalyticsSummaryHeight = 252;
  static const EdgeInsets walletAnalyticsSummaryPadding = EdgeInsets.fromLTRB(
    20,
    22,
    20,
    20,
  );
  static const double walletAnalyticsSummaryGap = 16;
  static const double walletAnalyticsReturnPillWidth = 164;
  static const double walletAnalyticsReturnPillHeight = 23;
  static const EdgeInsets walletAnalyticsReturnPillPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.rowGap);
  static const double walletAnalyticsReturnPillIcon = AppSpacing.x4;
  static const double walletAnalyticsReturnPillGap = AppSpacing.x1;
  static const double walletAnalyticsReturnMetaGap = 9;
  static const double walletAnalyticsQuickStatGap = 12;
  static const double walletAnalyticsQuickStatHeight = 78;
  static const EdgeInsets walletAnalyticsQuickStatPadding = EdgeInsets.fromLTRB(
    12,
    8,
    12,
    7,
  );
  static const double walletAnalyticsQuickStatTextGap = AppSpacing.x2;
  static const double walletAnalyticsSwitcherHeight = 46;
  static const EdgeInsets walletAnalyticsSwitcherPadding = EdgeInsets.all(4);
  static const double walletAnalyticsSwitcherIcon = 14;
  static const double walletAnalyticsSwitcherIconGap = walletAssetSmallGap;
  static const double walletAnalyticsOverviewPeriodGap = 14;
  static const double walletAnalyticsOverviewChartGap = 16;
  static const double walletAnalyticsOverviewMetricsGap = 18;
  static const double walletAnalyticsPeriodHeight = 29;
  static const double walletAnalyticsChartHeight = 214;
  static const EdgeInsets walletAnalyticsChartPadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    15,
  );
  static const EdgeInsets walletAnalyticsMetricsPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    13,
  );
  static const double walletAnalyticsMetricsTitleGap = 17;
  static const double walletAnalyticsMetricRowHeight = 36;
  static const EdgeInsets walletAnalyticsAssetsHeaderPadding =
      walletAnalyticsMetricsPadding;
  static const double walletAnalyticsAssetRowMinHeight = 91;
  static const EdgeInsets walletAnalyticsAssetRowPadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    13,
  );
  static const double walletAnalyticsAssetAvatar = 36;
  static const double walletAnalyticsAssetGap = 16;
  static const double walletAnalyticsAssetValueGap = 10;
  static const double walletAnalyticsAssetProgressHeight = 4;
  static const double walletAnalyticsAssetTopGap = 11;
  static const double walletAnalyticsAssetBottomGap = AppSpacing.x4;
  static const EdgeInsets walletAnalyticsPlaceholderPadding = EdgeInsets.all(
    20,
  );
  static const double walletHealthBottomInsetVisual = walletVisualChromePad;
  static const double walletHealthBottomInsetNative = walletNativeChromePad;
  static const double walletHealthPageTopPadding = 12;
  static EdgeInsets walletHealthScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        walletHealthPageTopPadding,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double walletHealthContentGap = 16;
  static const EdgeInsets walletHealthSheetPadding = EdgeInsets.fromLTRB(
    20,
    16,
    20,
    24,
  );
  static const double walletHealthSheetGap = 16;
  static const double walletHealthTabsHeight = 54;
  static const double walletHealthTabIndicatorInset = 7;
  static const double walletHealthTabIndicatorHeight = 2;
  static const double walletHealthOverallHeight = 292;
  static const EdgeInsets walletHealthOverallPadding = EdgeInsets.fromLTRB(
    16,
    22,
    16,
    20,
  );
  static const double walletHealthCardGap = 10;
  static const double walletHealthGaugeSize = 160;
  static const double walletHealthScoreGap = AppSpacing.rowGap;
  static const double walletHealthRadarHeight = 325;
  static const EdgeInsets walletHealthRadarPadding = EdgeInsets.fromLTRB(
    16,
    18,
    16,
    16,
  );
  static const double walletHealthMetricHeight = 60;
  static const EdgeInsets walletHealthMetricPadding = EdgeInsets.fromLTRB(
    12,
    12,
    12,
    11,
  );
  static const double walletHealthMetricValueGap = AppSpacing.rowGap;
  static const double walletHealthProgressHeight = 6;
  static const double walletHealthTrendHeight = 205;
  static const EdgeInsets walletHealthTrendPadding = EdgeInsets.fromLTRB(
    16,
    18,
    16,
    14,
  );
  static const double walletHealthTrendGap = 12;
  static const EdgeInsets walletHealthCardPadding = EdgeInsets.all(16);
  static const EdgeInsets walletHealthCompactCardPadding = EdgeInsets.all(12);
  static const double walletHealthRecommendationGap = 12;
  static const double walletHealthActionHeight = AppSpacing.x6;
  static const double walletHealthActionIcon = 14;
  static const double walletHealthInlineGap = AppSpacing.rowGap;
  static const double walletHealthNoticeGap = 10;
  static const double walletHealthSummaryIconBox = 48;
  static const double walletHealthSummaryIconGlyph = 24;
  static const double walletHealthSummaryTextGap = 6;
  static const double walletHealthChecklistIconBox = 24;
  static const double walletHealthChecklistIconGlyph = 14;
  static const double walletHealthPieHeight = 200;
  static const double walletHealthSectionGap = 12;
  static const double walletHealthLegendSpacing = 20;
  static const double walletHealthLegendRunSpacing = 10;
  static const double walletHealthLegendWidth = 156;
  static const double walletHealthLegendSwatch = 12;
  static const double walletHealthConcentrationGap = 14;
  static const double walletHealthAllocationGap = 10;
  static const double walletHealthSectionMarkerWidth = 4;
  static const double walletHealthSectionMarkerHeight = 14;
  static const double walletHealthSectionLabelGap = 6;
  static const EdgeInsets walletHealthBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.rowGap,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets walletDustScrollPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    14,
    AppSpacing.contentPad,
    16,
  );
  static const double walletDustContentGap = 16;
  static const double walletDustInlineFooterHeightThreshold = 1000;
  static const double walletDustInlineFooterBottomGap = 96;
  static const EdgeInsets walletDustSheetPadding = EdgeInsets.fromLTRB(
    20,
    18,
    20,
    20,
  );
  static const double walletDustSheetGap = 16;
  static const EdgeInsets walletDustPreviewPadding = EdgeInsets.all(14);
  static const double walletDustPreviewGap = 14;
  static const EdgeInsets walletDustHeroPadding = EdgeInsets.all(20);
  static const double walletDustHeroIconBox = 48;
  static const double walletDustHeroIconGlyph = 25;
  static const double walletDustHeroHeaderGap = AppSpacing.x4;
  static const double walletDustHeroTitleGap = AppSpacing.rowGap;
  static const double walletDustHeroStatsGap = 11;
  static const double walletDustHeroStatGap = AppSpacing.rowGap;
  static const double walletDustHeroStatHeight = 52;
  static const EdgeInsets walletDustHeroStatPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.rowGap,
    vertical: AppSpacing.x2,
  );
  static const double walletDustAssetRowHeight = 59;
  static const EdgeInsets walletDustAssetRowPadding = EdgeInsets.fromLTRB(
    12,
    walletAssetSmallGap,
    12,
    walletAssetSmallGap,
  );
  static const double walletDustCheckboxIcon = 18;
  static const double walletDustAssetCheckboxGap = AppSpacing.x4;
  static const double walletDustTokenLogo = AppSpacing.x6;
  static const double walletDustAssetInfoGap = 12;
  static const double walletDustTextGap = walletAssetSmallGap;
  static const double walletDustTargetGap = 10;
  static const double walletDustTargetHeight =
      AppSpacing.buttonStandard + AppSpacing.x2;
  static const EdgeInsets walletDustTargetPadding = EdgeInsets.fromLTRB(
    14,
    AppSpacing.rowGap,
    14,
    AppSpacing.rowGap,
  );
  static const double walletDustTargetLogoGap = 11;
  static const double walletDustTargetTextGap = walletAssetSmallGap;
  static const double walletDustSelectAllHeight = AppSpacing.x6;
  static const EdgeInsets walletDustSelectAllPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double walletDustSelectAllIcon = 17;
  static const double walletDustSelectAllGap = 10;
  static const double walletDustAssetListTopGap = 16;
  static const double walletDustAssetRowGap = AppSpacing.rowGap;
  static const double walletDustFooterHorizontalPadding = AppSpacing.contentPad;
  static const double walletDustFooterTopPadding = 16;
  static const double walletDustFooterBottomPadding = 6;
  static const double walletDustButtonHeight = AppSpacing.ctaHeight;
  static const double walletDustPreviewRowGap = 11;
  static const EdgeInsets walletDustConvertedPadding = EdgeInsets.all(13);
  static const double walletDustConvertedIcon = 19;
  static const double walletDustConvertedGap = 10;
  static const double walletDustSectionMarkerWidth = 4;
  static const double walletDustSectionMarkerHeight = 15;
  static const double walletDustSectionLabelGap = walletAssetSmallGap;
  static const double walletGasBottomInsetVisual = walletVisualChromePad;
  static const double walletGasBottomInsetNative = walletNativeChromePad;
  static const double walletGasPageTopPadding = AppSpacing.x4;
  static EdgeInsets walletGasScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        walletGasPageTopPadding,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double walletGasContentGap = 16;
  static const double walletGasSecondaryContentGap = 14;
  static const double walletGasTabsHeight = 54;
  static const double walletGasTabIndicatorInset = 7;
  static const double walletGasTabIndicatorHeight = 2;
  static const double walletGasStatusHeight = 88;
  static const EdgeInsets walletGasStatusPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    14,
  );
  static const double walletGasIcon = 17;
  static const double walletGasIconGap = AppSpacing.rowGap;
  static const double walletGasSectionMarkerWidth = 4;
  static const double walletGasSectionMarkerHeight = 14;
  static const double walletGasSectionLabelGap = 6;
  static const double walletGasLevelHeight = 85;
  static const EdgeInsets walletGasLevelPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    15,
  );
  static const double walletGasLevelBadgeGap = AppSpacing.rowGap;
  static const double walletGasLevelMetaGap = 12;
  static const double walletGasLevelValueGap = 10;
  static const double walletGasLevelProgressHeight = 4;
  static const double walletGasBadgeHeight = 18;
  static const double walletGasRecommendedBadgeHeight = 17;
  static const EdgeInsets walletGasBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.rowGap,
  );
  static const EdgeInsets walletGasSmallBadgePadding = EdgeInsets.symmetric(
    horizontal: walletAssetSmallGap,
  );
  static const double walletGasComparisonHeight = 260;
  static const EdgeInsets walletGasComparisonPadding = EdgeInsets.fromLTRB(
    16,
    20,
    16,
    17,
  );
  static const double walletGasComparisonTitleGap = 17;
  static const double walletGasComparisonRowGap = 15;
  static const double walletGasComparisonTextGap = walletAssetSmallGap;
  static const double walletGasRefreshHeight = 41;
  static const double walletGasRefreshIcon = 15;
  static const double walletGasChartLargeHeight = 254;
  static const double walletGasChartSmallHeight = 194;
  static const EdgeInsets walletGasChartPadding = EdgeInsets.fromLTRB(
    16,
    18,
    16,
    16,
  );
  static const double walletGasChartGap = 14;
  static const EdgeInsets walletGasBestTimePadding = EdgeInsets.all(16);
  static const double walletGasBestTimeTextGap = 6;
  static const double walletGasBestTimeMetricGap = 14;
  static const double walletGasBestTimeColumnGap = 12;
  static const double walletGasBestTimeValueGap = AppSpacing.rowGap;
  static const EdgeInsets walletGasTipPadding = EdgeInsets.all(16);
  static const double walletGasTipIconBox = 32;
  static const double walletGasTipIcon = 17;
  static const double walletGasTipIconGap = 10;
  static const double walletGasTipTitleGap = AppSpacing.rowGap;
  static const double walletGasTipFooterGap = 10;
  static const double walletGasSavingIcon = AppSpacing.x4;
  static const double walletGasQuickActionsTitleGap = 12;
  static const double walletGasQuickActionBottomGap = AppSpacing.rowGap;
  static const double walletGasQuickActionHeight = 44;
  static const EdgeInsets walletGasQuickActionPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double walletGasQuickActionIcon = 16;
  static const double walletGasQuickActionIconGap = 9;
  static const double walletGasQuickActionArrow = 15;
  static const double walletGasLineChartInsetX = 10;
  static const double walletGasLineChartInsetTop = 4;
  static const double walletGasLineChartInsetBottom = 24;
  static const double walletGasChartStroke = 2;
  static const double walletGasNetworkBarHeightInset = 10;
  static const double walletGasNetworkBarLeftPadding = 12;
  static const double walletGasNetworkBarWidthDivisor = 2.2;
  static const double walletGasNetworkBarGapMultiplier = 1.2;
  static const double walletManagerRiskGap = 14;
  static const double walletManagerTabsHeight = 54;
  static const double walletManagerTabIndicatorInset = 7;
  static const double walletManagerTabIndicatorHeight = 2;
  static const double walletManagerSectionMarkerWidth = 4;
  static const double walletManagerSectionMarkerHeight = 14;
  static const double walletManagerSectionLabelGap = 6;
  static const double walletManagerTinyButton = 14;
  static const double walletManagerTinyIcon = 11;
  static const double walletManagerDefaultBadgeHeight = 17;
  static const double walletManagerAssetChipHeight = 18;
  static const double walletManagerTypeBadgeHeight = 19;
  static const EdgeInsets walletManagerCompactBadgePadding =
      EdgeInsets.symmetric(horizontal: walletAssetSmallGap);
  static const EdgeInsets walletManagerBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.rowGap,
  );
  static const double walletManagerButtonIcon = 18;
  static const double walletManagerButtonIconGap = AppSpacing.rowGap;
  static const double walletManagerSecurityMinHeight = 58;
  static const EdgeInsets walletManagerSecurityPadding = EdgeInsets.fromLTRB(
    14,
    12,
    14,
    12,
  );
  static const double walletManagerSecurityIconTop = 1;
  static const double walletManagerSecurityIcon = 14;
  static const double walletManagerSecurityGap = 10;
  static const double walletManagerSummaryHeight = 148;
  static const EdgeInsets walletManagerSummaryPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    16,
  );
  static const double walletManagerSummaryTitleGap = 14;
  static const double walletManagerSummaryValueGap = 9;
  static const double walletManagerSummaryTrendIcon = 15;
  static const double walletManagerSummaryTrendGap = 4;
  static const double walletManagerSummaryMetricGap = 10;
  static const double walletManagerDistributionHeight = 245;
  static const EdgeInsets walletManagerDistributionPadding =
      EdgeInsets.fromLTRB(16, 18, 16, 16);
  static const double walletManagerDistributionTitleGap = 12;
  static const double walletManagerDistributionCenterY = .54;
  static const double walletManagerDistributionRadiusFactor = .315;
  static const double walletManagerDistributionStroke = 27;
  static const double walletManagerDistributionArcGap = .033;
  static const double walletManagerAllSummaryGap = 16;
  static const double walletManagerAllDistributionGap = 17;
  static const double walletManagerAllSectionGap = AppSpacing.rowGap;
  static const double walletManagerAllWalletGap = AppSpacing.rowGap;
  static const double walletManagerAllAddTopGap = 18;
  static const double walletManagerAllSecurityTopGap = 16;
  static const double walletManagerWalletCardHeight = 200;
  static const EdgeInsets walletManagerWalletCardPadding = EdgeInsets.fromLTRB(
    16,
    16,
    16,
    14,
  );
  static const double walletManagerWalletIconGap = 10;
  static const double walletManagerWalletBadgeGap = walletAssetSmallGap;
  static const double walletManagerWalletFavoriteIcon = AppSpacing.x4;
  static const double walletManagerWalletAddressGap = 9;
  static const double walletManagerWalletInlineGap = AppSpacing.rowGap;
  static const double walletManagerWalletActionGap = walletAssetSmallGap;
  static const double walletManagerWalletMoreGap = 6;
  static const double walletManagerWalletMoreIcon = 18;
  static const double walletManagerWalletBalanceBlockGap = 20;
  static const double walletManagerWalletBalanceLabelGap = 9;
  static const double walletManagerWalletBalanceValueGap = AppSpacing.rowGap;
  static const double walletManagerWalletTrendIcon = AppSpacing.x4;
  static const double walletManagerWalletTrendGap = AppSpacing.x1;
  static const double walletManagerWalletAssetTopGap = 17;
  static const double walletManagerWalletAssetGap = AppSpacing.rowGap;
  static const double walletManagerWalletDividerHeight = 1;
  static const double walletManagerWalletFooterGap = 10;
  static const double walletManagerWalletFooterIcon = 11;
  static const double walletManagerWalletFooterIconGap = AppSpacing.x2;
  static const double walletManagerWalletTypeIconBox = 36;
  static const double walletManagerWalletTypeIcon = 18;
  static const double walletManagerGroupsSectionGap = 10;
  static const double walletManagerGroupCardGap = AppSpacing.rowGap;
  static const double walletManagerGroupCreateTopGap = 14;
  static const double walletManagerGroupCreateHeight = 46;
  static const double walletManagerGroupCreateIcon = 16;
  static const double walletManagerGroupCreateIconGap = AppSpacing.rowGap;
  static const EdgeInsets walletManagerGroupCardPadding = EdgeInsets.all(16);
  static const double walletManagerGroupSwatch = 12;
  static const double walletManagerGroupSwatchGap = AppSpacing.rowGap;
  static const double walletManagerGroupMoreIcon = 18;
  static const double walletManagerGroupMetaGap = AppSpacing.x4;
  static const double walletManagerGroupValueGap = AppSpacing.rowGap;
  static const double walletManagerGroupWalletGap = AppSpacing.rowGap;
  static const double walletManagerGroupWalletRowHeight = 48;
  static const EdgeInsets walletManagerGroupWalletRowPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const double walletManagerGroupWalletTextGap = 6;
  static const double walletManagerActivitySectionGap = 10;
  static const double walletManagerActivityRowGap = AppSpacing.rowGap;
  static const double walletManagerActivityRowHeight = 62;
  static const EdgeInsets walletManagerActivityRowPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const double walletManagerActivityIconBox = 32;
  static const double walletManagerActivityIcon = 16;
  static const double walletManagerActivityIconGap = 10;
  static const double walletManagerActivityTextGap = walletAssetSmallGap;
  static const double walletManagerActivityTimeGap = AppSpacing.rowGap;
  static const EdgeInsetsDirectional kidGeneratorPreviewPadding =
      EdgeInsetsDirectional.all(AppSpacing.x4);
  static const EdgeInsetsDirectional kidGeneratorSectionCardPadding =
      EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      );
  static const EdgeInsetsDirectional kidGeneratorMetricPadding =
      EdgeInsetsDirectional.fromSTEB(
        AppSpacing.x3,
        AppSpacing.x1,
        AppSpacing.x3,
        AppSpacing.x1,
      );
  static EdgeInsets kidGeneratorScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x3,
        AppSpacing.contentPad,
        bottomInset,
      );
}
