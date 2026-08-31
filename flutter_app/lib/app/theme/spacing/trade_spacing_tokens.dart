import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/spacing/trade_bots_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_compliance_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_copy_spacing_tokens.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

final class TradeSpacingTokens {
  const TradeSpacingTokens._();

  static const EdgeInsets tradeBotHeroSecondaryPadding =
      TradeBotsSpacingTokens.tradeBotHeroSecondaryPadding;
  static const EdgeInsets tradeBotFaqAnswerPadding =
      TradeBotsSpacingTokens.tradeBotFaqAnswerPadding;
  static const double tradeBottomInsetVisual =
      TradeBotsSpacingTokens.tradeBottomInsetVisual;
  static const double tradeBottomInsetNative =
      TradeBotsSpacingTokens.tradeBottomInsetNative;
  static const double tradeHistoryBottomInsetVisual = 42;
  static const double tradeHistoryBottomInsetNative = 20;
  static const double tradeHorizontalPadding = AppSpacing.contentPad;
  static const EdgeInsets tradeMarketPanelPadding = EdgeInsets.fromLTRB(
    tradeHorizontalPadding,
    0,
    tradeHorizontalPadding,
    12,
  );
  static const EdgeInsets tradeHorizontalInsets = EdgeInsets.symmetric(
    horizontal: tradeHorizontalPadding,
  );
  static const EdgeInsets tradeRiskPanelPadding = tradeMarketPanelPadding;

  // Terminal 3 vùng (SC-048 tablet, hướng Bybit 2026-08-31): grid cố định
  // không cuộn trang, panel phẳng viền hairline — mật độ trùng chuẩn
  // terminal Markets (SC-044 hướng C) để hai terminal của app đọc cùng một
  // nhịp; giữ token riêng vì guardrail cross-feature cấm dùng token
  // Markets từ trade.
  //
  // LUẬT 13dp (user chốt 2026-08-31): mọi khoảng trắng DỌC của terminal
  // đều là 13dp — gutter panel↔panel, mép panel→nội dung đầu, nhãn→nội
  // dung, giữa hai khối trong panel, nội dung cuối→viền dưới. Một giá
  // trị, không ngoại lệ; inset NGANG và extent hàng dữ liệu không thuộc
  // phạm vi luật (không phải khoảng trắng dọc).
  /// Gutter đều giữa các panel phẳng của terminal.
  static const double tradeTerminalGutter = AppSpacing.cardGap;
  static const EdgeInsets tradeTerminalMetaStripPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x4,
  );
  static const double tradeTerminalMetaGap = AppSpacing.x3;
  static const double tradeTerminalMetaDividerHeight = AppSpacing.x5;
  static const EdgeInsets tradeTerminalPanelHeaderPadding = EdgeInsets.fromLTRB(
    AppSpacing.x3,
    AppSpacing.x4,
    AppSpacing.x3,
    AppSpacing.x4,
  );

  /// Body panel: CHỈ inset ngang — mọi khoảng dọc do luật 13dp đảm nhiệm
  /// (header padding bottom 13 với panel có nhãn; body top/bottom padding
  /// với panel không nhãn). Cấm bọc thêm padding dọc ở child.
  static const EdgeInsets tradeTerminalPanelBodyPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );
  static const EdgeInsets tradeTerminalPanelBodyTopPadding =
      EdgeInsets.fromLTRB(AppSpacing.x3, AppSpacing.x4, AppSpacing.x3, 0);
  static const EdgeInsets tradeTerminalPanelBodyBottomPadding =
      EdgeInsets.fromLTRB(AppSpacing.x3, 0, AppSpacing.x3, AppSpacing.x4);

  /// Mức sổ lệnh của terminal (12 mức/bên).
  static const double tradeTerminalBookRowExtent = 26;
  static const EdgeInsets tradeTerminalBookRowPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x1,
  );

  /// Dòng giao dịch gần đây của terminal (24 dòng).
  static const double tradeTerminalTradeRowExtent = 24;

  /// Inset ngang của hàng header cột (Khối lượng/Thời gian) trong tape —
  /// chỉ ngang, không dọc (luật 13dp: khoảng nhãn → header do label
  /// padding bottom đảm nhiệm).
  static const EdgeInsets tradeTerminalColumnHeaderPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2);

  /// Cột sổ lệnh + tape của terminal ở tầng đầy đủ.
  static const double tradeTerminalBookColumnWidth = 300;

  /// Cột đặt lệnh luôn hiện của terminal.
  static const double tradeTerminalEntryColumnWidth = 320;

  /// Thanh công cụ khung giờ + chỉ báo trong panel chart.
  static const EdgeInsets tradeTerminalChartToolbarPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x3,
        AppSpacing.x4,
        AppSpacing.x3,
        AppSpacing.x4,
      );
  static const double tradeTerminalIntervalGap = AppSpacing.x2;
  static const EdgeInsets tradeTerminalIntervalButtonPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: AppSpacing.x1);

  /// Vùng tab dưới chart (Lệnh mở | Vị thế | Sổ lệnh tùy tầng).
  /// Chiều cao vùng dưới chart sau luật 13dp: 13 (mép→tab) + tab (~29) +
  /// 13 (tab→bảng) + 8 hàng × 24 + 13 (hàng cuối→viền).
  static const double tradeTerminalBottomPanelHeight = 260;

  /// Chiều cao phần bảng trong panel dưới chart = 8 hàng × extent 24.
  static const double tradeTerminalBottomTableHeight =
      tradeTerminalBottomPanelHeight -
      AppSpacing.x4 * 3 -
      (AppSpacing.x5 + AppSpacing.x2 + AppSpacing.x1);
  static const double tradeTerminalBottomTabGap = AppSpacing.x2;
  static const EdgeInsets tradeTerminalBottomRowPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.x1,
  );

  /// Cột "MUA/BÁN + symbol" của các bảng dưới chart — đủ chỗ cho nhãn dài
  /// nhất ("MUA BTC/USDT") không ellipsis sớm.
  static const double tradeTerminalSymbolColumnWidth =
      AppSpacing.x7 + AppSpacing.x5 + AppSpacing.x3;

  /// Nút đổi cặp + hàng cặp trong sheet chọn (padding dùng token, không
  /// EdgeInsets thô — home-reference consistency).
  static const EdgeInsets tradeTerminalPickerButtonPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: AppSpacing.x1);
  static const EdgeInsets tradeTerminalPickerRowPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x2,
  );

  /// Tầng đầy đủ (chart | sổ lệnh | đặt lệnh) — điểm chạm ĐO THỰC bằng
  /// widget test ở mặt QA (xem trade_tablet_page_test), không ước lượng.
  static const double tradeTerminalFullSplitMinWidth = 1000;

  /// Tầng gọn (chart | đặt lệnh+tape) cho tablet portrait thật; dưới mốc
  /// này là vùng resize cửa sổ → stack cuộn.
  static const double tradeTerminalSplitMinWidth = 620;

  /// Chiều cao chart ở tầng stack (resize cửa sổ) — panel fill cần cao độ
  /// giới hạn trong cuộn dọc.
  static const double tradeTerminalStackedChartHeight = 300;

  /// Home-aligned section rhythm for L2 trade pages (8px).
  static const double tradePageContentGap = AppSpacing.x3;

  @Deprecated(
    'Use AppSpacing.sectionGap or AppSpacing.pageRhythmStandardSectionGap',
  )
  static const double tradeSectionGap = AppSpacing.sectionGap;
  static const double tradeHeaderLogo = 32;
  static const EdgeInsets tradeHeaderBodyPadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: AppSpacing.rowGap,
  );
  static const double tradeHeaderChevronGap = AppSpacing.x2;
  static const double tradeHeaderChevron = 18;
  static const double tradeHeaderTrailingWidth = 128;
  static const double tradeQuickNavHeight = 74;
  static const EdgeInsets tradeQuickNavPadding = EdgeInsets.symmetric(
    horizontal: tradeHorizontalPadding,
    vertical: 6,
  );
  static const double tradeQuickNavGap = AppSpacing.rowGap;
  static const double tradeQuickChipWidth = 96;
  static const EdgeInsets tradeQuickChipPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: WalletSpacingTokens.walletAssetSmallGap,
  );
  static const double tradeQuickChipIcon = 15;
  static const double tradeQuickChipIconGap = AppSpacing.x2;
  static const double tradeQuickChipBadgeGap = 6;
  static const double tradeQuickChipBadgeMaxWidth = 74;
  static const EdgeInsets tradeQuickChipBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.hairlineStroke,
  );
  static const EdgeInsets tradeDataTabsPadding = EdgeInsets.fromLTRB(
    tradeHorizontalPadding,
    4,
    tradeHorizontalPadding,
    AppSpacing.rowGap,
  );
  static const double tradeDataTabsHeight = AppSpacing.x6;
  static const double tradeChartHeight = 122;
  static const double tradeChartOverlayInset = 10;
  static const double tradeChartOverlayTop = 12;
  static const double tradeChartLogoSize = 44;
  static const double copyTradingBottomInsetVisual =
      TradeCopySpacingTokens.copyTradingBottomInsetVisual;
  static const double copyTradingBottomInsetNative =
      TradeCopySpacingTokens.copyTradingBottomInsetNative;
  static const double copyTradingHeroPanelPaddingValue =
      TradeCopySpacingTokens.copyTradingHeroPanelPaddingValue;
  static const double copyTradingHeroAumPaddingValue = 16;
  static const double copyTradingHeroMetricPaddingValue =
      TradeCopySpacingTokens.copyTradingHeroMetricPaddingValue;
  static const double copyTradingHeroGap =
      TradeCopySpacingTokens.copyTradingHeroGap;
  static const double copyTradingHeroMetricGap =
      TradeCopySpacingTokens.copyTradingHeroMetricGap;
  static const double copyTradingHeroLabelGap =
      TradeCopySpacingTokens.copyTradingHeroLabelGap;
  static const double copyTradingMetricIcon =
      tradeBotSmallIcon + AppSpacing.hairlineStroke / 2;
  static const double copyTradingMetricIconGap = tradeBotNarrowIconGap;
  static const double copyTradingMetricCellGap =
      TradeCopySpacingTokens.copyTradingMetricCellGap;
  static const double copyTradingWeeklyTitleGap = tradeBotNarrowIconGap;
  static const double copyTradingWeeklyChartHeight =
      AppSpacing.buttonCompact - tradeBotNarrowIconGap;
  static const double copyTradingWeeklyStrokeWidth =
      TradeCopySpacingTokens.copyTradingWeeklyStrokeWidth;
  static const double copyTradingDisclaimerLineHeight =
      TradeCopySpacingTokens.copyTradingDisclaimerLineHeight;
  static const double copyTradingDisclaimerTopPad =
      TradeCopySpacingTokens.copyTradingDisclaimerTopPad;
  static const double copyTradingDisclaimerBottomPad =
      TradeCopySpacingTokens.copyTradingDisclaimerBottomPad;
  static const EdgeInsets copyTradingHeroPanelPadding =
      TradeCopySpacingTokens.copyTradingHeroPanelPadding;
  static const EdgeInsets copyTradingHeroAumPadding = EdgeInsets.all(
    copyTradingHeroAumPaddingValue,
  );
  static const EdgeInsets copyTradingHeroMetricPadding =
      TradeCopySpacingTokens.copyTradingHeroMetricPadding;
  static const EdgeInsets copyTradingDisclaimerPadding =
      TradeCopySpacingTokens.copyTradingDisclaimerPadding;
  static EdgeInsets copyTradingScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double preCopyAssessmentBottomInsetVisualExtra = 104;
  static const double preCopyAssessmentBottomInsetNativeExtra = 28;
  static const double preCopyAssessmentContentTopPadding =
      AppSpacing.x4 + AppSpacing.x1;
  static const double preCopyAssessmentContentGap =
      AppSpacing.x4 + AppSpacing.x1 - AppSpacing.hairlineStroke;
  static const double preCopyAssessmentCtaGap = 12;
  static const EdgeInsets preCopyAssessmentCardPadding = EdgeInsets.all(
    AppSpacing.x4 + AppSpacing.x1,
  );
  static const EdgeInsets preCopyAssessmentOptionMargin = EdgeInsets.only(
    bottom: AppSpacing.x3,
  );
  static const EdgeInsets preCopyAssessmentOptionCardPadding = EdgeInsets.all(
    AppSpacing.x4 - AppSpacing.x1,
  );
  static EdgeInsets preCopyAssessmentScrollPadding(double bottomInset) =>
      AppSpacing.contentInsets.copyWith(
        top: preCopyAssessmentContentTopPadding,
        bottom: bottomInset,
      );
  static const double copyProviderDetailBottomInsetVisualExtra =
      TradeCopySpacingTokens.copyProviderDetailBottomInsetVisualExtra;
  static const double copyProviderDetailBottomInsetNativeExtra =
      TradeCopySpacingTokens.copyProviderDetailBottomInsetNativeExtra;
  static const double copyProviderDetailDisclaimerLineHeight =
      tradeBotLineHeightReadable;
  static const double copyProviderDetailRiskLineHeight =
      tradeBotLineHeightMedium;
  static const int copyProviderDetailMetricColumns =
      TradeCopySpacingTokens.copyProviderDetailMetricColumns;
  static const double copyProviderDetailMetricAspectRatio =
      TradeCopySpacingTokens.copyProviderDetailMetricAspectRatio;
  static const EdgeInsets copyProviderDetailNotFoundPadding =
      TradeCopySpacingTokens.copyProviderDetailNotFoundPadding;
  static EdgeInsets copyProviderDetailScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double positionDashboardLabelLineHeight = 1.1;
  static const double positionDashboardTightLineHeight =
      tradeBotLineHeightTight;
  static const double futuresPriceLineHeight = tradeBotLineHeightTight;
  static const double futuresMarketStatCardHeight =
      WalletSpacingTokens.walletAddressStatsHeight;
  static const double futuresSideSwitchHeight = 56;
  static const double futuresOrderTypeSelectorHeight =
      AppSpacing.searchBarCompactHeight;
  static const double futuresPercentButtonLineHeight = tradeBotLineHeightTight;
  static const double futuresSafetyTitleLineHeight = 1.1;
  static const double convertPairSparklineWidth = 72;
  static const double convertPairSparklineHeight = 31;
  static const double convertSlippageCardHeight = 108;
  static const double convertModeTabHeight = AppSpacing.searchBarCompactHeight;
  static const double convertControlHeight =
      AppSpacing.buttonCompact + AppSpacing.x1;
  static const double convertChipHeight =
      AppSpacing.buttonCompact - AppSpacing.x3;
  static const double convertFavoriteChipHeight =
      AppSpacing.searchBarCompactHeight;
  static const double convertHeroFlipSize =
      AppSpacing.buttonCompact + AppSpacing.x1;
  static const double convertSubmitHeight = AppSpacing.searchBarCompactHeight;
  static const double convertStickyCtaClearance =
      AppSpacing.ctaHeight + AppSpacing.x5;
  static const double leverageControlButtonLineHeight = tradeBotLineHeightTight;
  static const double leverageImpactRowLineHeight = tradeBotLineHeightShort;
  static const double leverageHeroHeight = 178;
  static const double leverageHeroValueLineHeight = tradeBotLineHeightTight;
  static const int leveragePresetGridColumns = 5;
  static const double leveragePresetGridAspectRatio = 1.78;
  static const double botDrawdownUnderwaterChartHeight = 200;
  static const double botDrawdownDurationChartHeight = 160;
  static const double copyPerformanceBottomInsetVisualExtra =
      TradeCopySpacingTokens.copyPerformanceBottomInsetVisualExtra;
  static const double copyPerformanceBottomInsetNativeExtra =
      TradeCopySpacingTokens.copyPerformanceBottomInsetNativeExtra;
  static const double copyPerformanceReturnCardHeight =
      TradeCopySpacingTokens.copyPerformanceReturnCardHeight;
  static const double copyPerformanceTabsHeight =
      TradeCopySpacingTokens.copyPerformanceTabsHeight;
  static const double copyPerformanceEquityChartHeight =
      TradeCopySpacingTokens.copyPerformanceEquityChartHeight;
  static const double copyPerformanceInfoLineHeight = tradeBotLineHeightCompact;
  static EdgeInsets copyPerformanceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.cardGap,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets copyPerformanceTradeCardPadding =
      TradeCopySpacingTokens.copyPerformanceTradeCardPadding;
  static const EdgeInsets copyPerformanceCostItemPadding =
      TradeCopySpacingTokens.copyPerformanceCostItemPadding;
  static const EdgeInsets copyPerformanceMetricItemPadding =
      TradeCopySpacingTokens.copyPerformanceMetricItemPadding;
  static const EdgeInsets copyPerformanceInfoBoxPadding =
      TradeCopySpacingTokens.copyPerformanceInfoBoxPadding;
  static const EdgeInsets copyPerformanceInfoLinePadding =
      TradeCopySpacingTokens.copyPerformanceInfoLinePadding;
  static const EdgeInsets copyPerformanceReturnCardPadding =
      TradeCopySpacingTokens.copyPerformanceReturnCardPadding;
  static const double providerComparisonBottomInsetVisualExtra =
      TradeCopySpacingTokens.providerComparisonBottomInsetVisualExtra;
  static const double providerComparisonBottomInsetNativeExtra =
      TradeCopySpacingTokens.providerComparisonBottomInsetNativeExtra;
  static const double providerComparisonWarningLineHeight =
      tradeBotLineHeightReadable;
  static const double providerComparisonLegendLineHeight =
      tradeBotLineHeightBody;
  static EdgeInsets providerComparisonScrollPadding(double bottomInset) =>
      AppSpacing.contentInsets.copyWith(
        top: AppSpacing.x4 - AppSpacing.x1,
        bottom: bottomInset,
      );
  static const EdgeInsets providerComparisonPanelPadding =
      TradeCopySpacingTokens.providerComparisonPanelPadding;
  static const EdgeInsets providerComparisonMetricHeaderPadding =
      TradeCopySpacingTokens.providerComparisonMetricHeaderPadding;
  static const EdgeInsets providerComparisonMetricLabelPadding =
      TradeCopySpacingTokens.providerComparisonMetricLabelPadding;
  static const EdgeInsets providerComparisonCategoryPadding =
      TradeCopySpacingTokens.providerComparisonCategoryPadding;
  static const double bestExecutionActionButtonHeight = 40;
  static const double bestExecutionSummaryLineHeight = 1;
  static const double bestExecutionReportTitleLineHeight =
      tradeBotLineHeightCaption;
  static const double bestExecutionReportMetaLineHeight =
      tradeBotLineHeightBody;
  static const EdgeInsets bestExecutionSummaryCardPadding = EdgeInsets.fromLTRB(
    AppSpacing.x4 - AppSpacing.x1,
    AppSpacing.x4,
    AppSpacing.x4 - AppSpacing.x1,
    AppSpacing.x4 - AppSpacing.x1,
  );
  static const EdgeInsets bestExecutionReportActionsPadding = EdgeInsets.all(
    AppSpacing.x4 + AppSpacing.x1,
  );
  static const EdgeInsets bestExecutionArchiveReportPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const EdgeInsets bestExecutionNoticePadding = EdgeInsets.fromLTRB(
    AppSpacing.x4 - AppSpacing.x1,
    AppSpacing.x3 + AppSpacing.x1,
    AppSpacing.x3,
    AppSpacing.x3 + AppSpacing.x1,
  );
  static const double providerApplicationIntroTitleLineHeight =
      TradeCopySpacingTokens.providerApplicationIntroTitleLineHeight;
  static const double providerApplicationIntroDescriptionLineHeight =
      TradeCopySpacingTokens.providerApplicationIntroDescriptionLineHeight;
  static const double providerApplicationBenefitDescriptionLineHeight =
      TradeCopySpacingTokens.providerApplicationBenefitDescriptionLineHeight;
  static const double providerApplicationResponsibilityLineHeight =
      TradeCopySpacingTokens.providerApplicationResponsibilityLineHeight;
  static const double providerApplicationConsentLineHeight =
      TradeCopySpacingTokens.providerApplicationConsentLineHeight;
  static const double providerApplicationPanelDescriptionLineHeight =
      TradeCopySpacingTokens.providerApplicationPanelDescriptionLineHeight;
  static const BoxConstraints providerApplicationBenefitCardConstraints =
      TradeCopySpacingTokens.providerApplicationBenefitCardConstraints;
  static EdgeInsets providerApplicationFooterPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets providerApplicationStepTitlePadding =
      TradeCopySpacingTokens.providerApplicationStepTitlePadding;
  static const EdgeInsets providerApplicationConsentPadding =
      TradeCopySpacingTokens.providerApplicationConsentPadding;
  static const EdgeInsets providerApplicationPanelPadding =
      TradeCopySpacingTokens.providerApplicationPanelPadding;
  static const EdgeInsets providerApplicationInputContentPadding =
      TradeCopySpacingTokens.providerApplicationInputContentPadding;
  static const EdgeInsets providerApplicationBenefitCardPadding =
      TradeCopySpacingTokens.providerApplicationBenefitCardPadding;
  static const EdgeInsets providerApplicationResponsibilityItemPadding =
      TradeCopySpacingTokens.providerApplicationResponsibilityItemPadding;
  static const EdgeInsets providerApplicationRequirementPreviewPadding =
      TradeCopySpacingTokens.providerApplicationRequirementPreviewPadding;
  static const double copyAuditBottomInsetVisualExtra =
      TradeCopySpacingTokens.copyAuditBottomInsetVisualExtra;
  static const double copyAuditBottomInsetNativeExtra =
      TradeCopySpacingTokens.copyAuditBottomInsetNativeExtra;
  static EdgeInsets copyAuditScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets copyAuditSheetPadding =
      TradeCopySpacingTokens.copyAuditSheetPadding;
  static const EdgeInsets copyAuditNoticePadding =
      TradeCopySpacingTokens.copyAuditNoticePadding;
  static const EdgeInsets copyAuditSummaryTitlePadding =
      TradeCopySpacingTokens.copyAuditSummaryTitlePadding;
  static const EdgeInsets copyAuditMetadataConfigPadding =
      TradeCopySpacingTokens.copyAuditMetadataConfigPadding;
  static const EdgeInsets copyAuditMetadataPanelPadding =
      TradeCopySpacingTokens.copyAuditMetadataPanelPadding;
  static const EdgeInsets copyAuditExportButtonPadding =
      TradeCopySpacingTokens.copyAuditExportButtonPadding;
  static const double copyAuditNoticeLineHeight = tradeBotLineHeightBody;
  static const double copyAuditSheetTitleLineHeight = tradeBotLineHeightCompact;
  static const double copyAuditEventTitleLineHeight = tradeBotLineHeightCaption;
  static const double copyAuditEventDescriptionLineHeight =
      tradeBotLineHeightCompact;
  static const double copyAuditMetaLineHeight = tradeBotLineHeightTight;
  static const double copyAuditExportLineHeight = tradeBotLineHeightShort;
  static const double copyAuditMetadataConfigHeight =
      TradeCopySpacingTokens.copyAuditMetadataConfigHeight;
  static const double copyAuditSummaryCardHeight =
      TradeCopySpacingTokens.copyAuditSummaryCardHeight;
  static const double exPostCostsReportNoticeIcon =
      AppSpacing.x4 + AppSpacing.x1;
  static const double exPostCostsReportNoticeIconGap =
      AppSpacing.x3 + AppSpacing.hairlineStroke;
  static const double exPostCostsReportNoticeBodyGap = AppSpacing.x3;
  static const double exPostCostsReportSummaryHeight = 46;
  static const double exPostCostsReportSummaryLineHeight =
      tradeBotLineHeightCaption;
  static const double exPostCostsReportBreakdownTitleTop =
      AppSpacing.x3 + AppSpacing.hairlineStroke;
  static const double exPostCostsReportBreakdownEstimateGap =
      AppSpacing.rowGap + AppSpacing.dividerHairline;
  static const double exPostCostsReportBreakdownNoteGap =
      AppSpacing.x5 + AppSpacing.dividerHairline;
  static const double exPostCostsReportVarianceNoteIcon =
      AppSpacing.rowGap + AppSpacing.x1;
  static const double exPostCostsReportVarianceNoteIconGap =
      AppSpacing.x1 + AppSpacing.hairlineStroke;
  static const double exPostCostsReportLineHeightTight =
      tradeBotLineHeightTight;
  static const double exPostCostsReportLineHeightBody = tradeBotLineHeightBody;
  static const double exPostCostsReportVarianceGap = AppSpacing.contentPad;
  static const EdgeInsets exPostCostsReportNoticePadding = EdgeInsets.fromLTRB(
    AppSpacing.x3 + AppSpacing.hairlineStroke,
    0,
    AppSpacing.x3,
    0,
  );
  static const EdgeInsets exPostCostsReportSummaryPadding = EdgeInsets.fromLTRB(
    AppSpacing.x3 + AppSpacing.hairlineStroke,
    AppSpacing.x4 + AppSpacing.hairlineStroke,
    AppSpacing.x3 + AppSpacing.hairlineStroke,
    AppSpacing.x4,
  );
  static const EdgeInsets exPostCostsReportBreakdownPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x4 + AppSpacing.x1,
        AppSpacing.x4 + AppSpacing.x1,
        AppSpacing.x4 + AppSpacing.x1,
        AppSpacing.x4 + AppSpacing.hairlineStroke,
      );
  static const EdgeInsets exPostCostsReportBreakdownTitlePadding =
      EdgeInsets.only(top: exPostCostsReportBreakdownTitleTop);
  static const EdgeInsets exPostCostsReportVarianceNoteHigherPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x3 + AppSpacing.hairlineStroke,
        AppSpacing.x3,
        AppSpacing.x3 + AppSpacing.hairlineStroke,
        AppSpacing.x3,
      );
  static const EdgeInsets exPostCostsReportVarianceNoteLowerPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x3,
        AppSpacing.x3,
        AppSpacing.x3 + AppSpacing.hairlineStroke,
        AppSpacing.x3,
      );
  static const EdgeInsets exPostCostsReportVariancePadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x4 + AppSpacing.x1,
        AppSpacing.x5,
        AppSpacing.x4 + AppSpacing.x1,
        AppSpacing.x4 + AppSpacing.x1,
      );
  static const EdgeInsets exPostCostsReportVarianceBodyPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x4 - AppSpacing.x1,
        AppSpacing.x4,
        AppSpacing.x4 - AppSpacing.x1,
        AppSpacing.x4 - AppSpacing.x1,
      );
  static const double copySettingsBottomInsetVisual =
      TradeCopySpacingTokens.copySettingsBottomInsetVisual;
  static const double copySettingsBottomInsetNative =
      TradeCopySpacingTokens.copySettingsBottomInsetNative;
  static const double copySettingsCircuitBreakerExpandedHeight =
      TradeCopySpacingTokens.copySettingsCircuitBreakerExpandedHeight;
  static const double copySettingsCircuitBreakerCollapsedHeight =
      TradeCopySpacingTokens.copySettingsCircuitBreakerCollapsedHeight;
  static const double copySettingsNotificationRowHeight =
      TradeCopySpacingTokens.copySettingsNotificationRowHeight;
  static const double copySettingsModeCardHeight =
      TradeCopySpacingTokens.copySettingsModeCardHeight;
  static const double copySettingsSliderCardHeight =
      TradeCopySpacingTokens.copySettingsSliderCardHeight;
  static const double copySettingsSliderCardWithSubtextHeight =
      TradeCopySpacingTokens.copySettingsSliderCardWithSubtextHeight;
  static const double copySettingsPrivacyCardHeight =
      TradeCopySpacingTokens.copySettingsPrivacyCardHeight;
  static const double copySettingsLineHeightTight =
      TradeCopySpacingTokens.copySettingsLineHeightTight;
  static const double copySettingsLineHeightDense =
      TradeCopySpacingTokens.copySettingsLineHeightDense;
  static const double copySettingsLineHeightCompact =
      TradeCopySpacingTokens.copySettingsLineHeightCompact;
  static const double copySettingsLineHeightBody =
      TradeCopySpacingTokens.copySettingsLineHeightBody;
  static const double copySettingsLineHeightReadable =
      TradeCopySpacingTokens.copySettingsLineHeightReadable;
  static const double copySettingsLineHeightLoose =
      TradeCopySpacingTokens.copySettingsLineHeightLoose;
  static const EdgeInsets copySettingsSectionPadding =
      TradeCopySpacingTokens.copySettingsSectionPadding;
  static const EdgeInsets copySettingsModeButtonPadding =
      TradeCopySpacingTokens.copySettingsModeButtonPadding;
  static const EdgeInsets copySettingsNotificationPadding =
      TradeCopySpacingTokens.copySettingsNotificationPadding;
  static const EdgeInsets copySettingsToggleKnobMargin =
      TradeCopySpacingTokens.copySettingsToggleKnobMargin;
  static const EdgeInsets copySettingsChannelPadding =
      TradeCopySpacingTokens.copySettingsChannelPadding;
  static EdgeInsets copySettingsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double complaintSubmissionBottomInsetVisual =
      TradeComplianceSpacingTokens.complaintSubmissionBottomInsetVisual;
  static const double complaintSubmissionBottomInsetNative =
      TradeComplianceSpacingTokens.complaintSubmissionBottomInsetNative;
  static const double complaintSubmissionTopInset =
      AppSpacing.x5 + AppSpacing.x2 + AppSpacing.hairlineStroke;
  static const double complaintSubmissionSectionGap =
      TradeComplianceSpacingTokens.complaintSubmissionSectionGap;
  static const double complaintSubmissionFooterHeight =
      TradeComplianceSpacingTokens.complaintSubmissionFooterHeight;
  static const double complaintSubmissionLineHeightTight =
      TradeComplianceSpacingTokens.complaintSubmissionLineHeightTight;
  static const double complaintSubmissionLineHeightShort =
      TradeComplianceSpacingTokens.complaintSubmissionLineHeightShort;
  static const double complaintSubmissionLineHeightBody = 1.35;
  static const double complaintSubmissionLineHeightHint =
      TradeComplianceSpacingTokens.complaintSubmissionLineHeightHint;
  static const double complaintSubmissionLineHeightReadable = 1.45;
  static const double complaintSubmissionLineHeightLong =
      TradeComplianceSpacingTokens.complaintSubmissionLineHeightLong;
  static const double complaintSubmissionMultilineHeight =
      TradeComplianceSpacingTokens.complaintSubmissionMultilineHeight;
  static const double complaintSubmissionSingleLineHeight =
      TradeComplianceSpacingTokens.complaintSubmissionSingleLineHeight;
  static const double complaintSubmissionEvidenceHeight =
      WalletSpacingTokens.walletDepositWarningCardMinHeight + tradeBotRowGap;
  static const double complaintSubmissionCheckboxSize =
      TradeComplianceSpacingTokens.complaintSubmissionCheckboxSize;
  static const EdgeInsets complaintSubmissionFooterPadding =
      TradeComplianceSpacingTokens.complaintSubmissionFooterPadding;
  static const EdgeInsets complaintSubmissionNoticePadding =
      TradeComplianceSpacingTokens.complaintSubmissionNoticePadding;
  static const EdgeInsets complaintSubmissionCategoryPadding =
      TradeComplianceSpacingTokens.complaintSubmissionCategoryPadding;
  static const EdgeInsets complaintSubmissionEvidencePadding = EdgeInsets.all(
    copyTradingHeroAumPaddingValue,
  );
  static const EdgeInsets complaintSubmissionTermsPadding = EdgeInsets.fromLTRB(
    copyTradingHeroAumPaddingValue,
    tradeQuickChipIcon,
    copyTradingHeroAumPaddingValue,
    tradeQuickChipIcon,
  );
  static const EdgeInsets complaintSubmissionMultilineContentPadding =
      EdgeInsets.fromLTRB(
        tradeBotCardGap,
        tradeBotSectionMarkerHeight,
        tradeBotCardGap,
        tradeBotCardGap,
      );
  static const EdgeInsets complaintSubmissionSingleLineContentPadding =
      EdgeInsets.symmetric(horizontal: tradeBotCardGap);
  static EdgeInsets complaintSubmissionScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        complaintSubmissionTopInset,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets complaintSubmissionFooterInset(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double complaintCaseBottomInsetVisual =
      TradeComplianceSpacingTokens.complaintCaseBottomInsetVisual;
  static const double complaintCaseBottomInsetNative =
      TradeComplianceSpacingTokens.complaintCaseBottomInsetNative;
  static const double complaintCaseCompactGap =
      AppSpacing.contentPad - AppSpacing.x3;
  static const double complaintCaseLineHeightTight =
      TradeComplianceSpacingTokens.complaintCaseLineHeightTight;
  static const double complaintCaseLineHeightSlight =
      TradeComplianceSpacingTokens.complaintCaseLineHeightSlight;
  static const double complaintCaseLineHeightTitle =
      TradeComplianceSpacingTokens.complaintCaseLineHeightTitle;
  static const double complaintCaseLineHeightBody =
      TradeComplianceSpacingTokens.complaintCaseLineHeightBody;
  static const double complaintCaseLineHeightDense = 1.25;
  static const double complaintCaseLineHeightReadable =
      TradeComplianceSpacingTokens.complaintCaseLineHeightReadable;
  static const double complaintCaseIconNudge =
      TradeComplianceSpacingTokens.complaintCaseIconNudge;
  static const double complaintCaseSmallIcon =
      TradeComplianceSpacingTokens.complaintCaseSmallIcon;
  static const double complaintCaseActionIcon =
      TradeComplianceSpacingTokens.complaintCaseActionIcon;
  static const double complaintCaseTrailingIcon = tradeBotDisputeTabBadgeSize;
  static const EdgeInsets complaintCaseCardPadding =
      TradeComplianceSpacingTokens.complaintCaseCardPadding;
  static const EdgeInsets complaintCaseTitleNudgePadding =
      TradeComplianceSpacingTokens.complaintCaseTitleNudgePadding;
  static const EdgeInsets complaintCaseIconNudgePadding =
      TradeComplianceSpacingTokens.complaintCaseIconNudgePadding;
  static EdgeInsets complaintTrackingScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.sectionGapCompact,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double complaintTrackingSectionGap =
      TradeComplianceSpacingTokens.complaintTrackingSectionGap;
  static const double complaintTrackingActionHeight =
      TradeComplianceSpacingTokens.complaintTrackingActionHeight;
  static const double complaintTrackingTimelineRailWidth =
      TradeComplianceSpacingTokens.complaintTrackingTimelineRailWidth;
  static const double complaintTrackingTimelineConnectorHeight =
      TradeComplianceSpacingTokens.complaintTrackingTimelineConnectorHeight;
  static const EdgeInsets complaintTrackingStatusCardPadding =
      EdgeInsets.fromLTRB(
        WalletSpacingTokens.walletAddressActionIcon,
        WalletSpacingTokens.walletAddressActionIcon,
        WalletSpacingTokens.walletAddressActionIcon,
        copyTradingHeroAumPaddingValue,
      );
  static const EdgeInsets complaintTrackingMetricPadding =
      TradeComplianceSpacingTokens.complaintTrackingMetricPadding;
  static const EdgeInsets complaintTrackingConnectorPadding =
      TradeComplianceSpacingTokens.complaintTrackingConnectorPadding;
  static const EdgeInsets complaintTrackingStepContentPadding =
      TradeComplianceSpacingTokens.complaintTrackingStepContentPadding;
  static EdgeInsets ombudsmanScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double ombudsmanSectionGap = complaintCaseCompactGap;
  static const EdgeInsets ombudsmanEligibilityPadding = EdgeInsets.fromLTRB(
    copyTradingHeroAumPaddingValue,
    AppSpacing.contentPad - AppSpacing.x2,
    copyTradingHeroAumPaddingValue,
    AppSpacing.rowPy,
  );
  static const EdgeInsets ombudsmanProcessPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const double ombudsmanContactIconBox =
      AppSpacing.buttonCompact + AppSpacing.formFieldLabelGap;
  static const double complaintsHandlingBottomInsetVisual =
      TradeComplianceSpacingTokens.complaintsHandlingBottomInsetVisual;
  static const double complaintsHandlingBottomInsetNative =
      TradeComplianceSpacingTokens.complaintsHandlingBottomInsetNative;
  static const double complaintsHandlingTopInset =
      AppSpacing.buttonCompact -
      AppSpacing.formFieldLabelGap -
      AppSpacing.hairlineStroke;
  static const double complaintsHandlingPrimaryGap =
      TradeComplianceSpacingTokens.complaintsHandlingPrimaryGap;
  static const double complaintsHandlingReviewGap =
      TradeComplianceSpacingTokens.complaintsHandlingReviewGap;
  static const double complaintsHandlingStatsGap =
      TradeComplianceSpacingTokens.complaintsHandlingStatsGap;
  static const double complaintsHandlingTabGap =
      TradeComplianceSpacingTokens.complaintsHandlingTabGap;
  static const double complaintsHandlingGridGap = complaintCaseCompactGap;
  static const double complaintsHandlingCategoryWidth =
      TradeComplianceSpacingTokens.complaintsHandlingCategoryWidth;
  static const double complaintsHandlingCategoryHeight =
      TradeComplianceSpacingTokens.complaintsHandlingCategoryHeight;
  static const double complaintsHandlingTimelineStepSize =
      TradeComplianceSpacingTokens.complaintsHandlingTimelineStepSize;
  static const double complaintsHandlingTimelineItemGap =
      copyTradingHeroAumPaddingValue;
  static const double complaintsHandlingTimelineLabelGap =
      TradeComplianceSpacingTokens.complaintsHandlingTimelineLabelGap;
  static const double complaintsHandlingRightsIconGap =
      TradeComplianceSpacingTokens.complaintsHandlingRightsIconGap;
  static const double complaintsHandlingRightsBodyLineHeight =
      complaintSubmissionLineHeightBody;
  static const double complaintsHandlingOmbudsmanLineHeight =
      complaintSubmissionLineHeightReadable;
  static const EdgeInsets complaintsHandlingRightsPadding = EdgeInsets.fromLTRB(
    complaintCaseCompactGap,
    0,
    AppSpacing.x3,
    0,
  );
  static const EdgeInsets complaintsHandlingCategoryPadding =
      TradeComplianceSpacingTokens.complaintsHandlingCategoryPadding;
  static const EdgeInsets complaintsHandlingTimelinePadding =
      EdgeInsets.fromLTRB(
        copyTradingHeroAumPaddingValue,
        WalletSpacingTokens.walletAddressActionIcon,
        copyTradingHeroAumPaddingValue,
        WalletSpacingTokens.walletAddressActionIcon,
      );
  static EdgeInsets complaintsHandlingScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        complaintsHandlingTopInset,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double copyTradingV2GlassHeroHeight =
      TradeCopySpacingTokens.copyTradingV2GlassHeroHeight;
  static const double copyTradingV2BoldHeroHeight =
      TradeCopySpacingTokens.copyTradingV2BoldHeroHeight;
  static const double copyTradingV2VariantMinHeight =
      TradeCopySpacingTokens.copyTradingV2VariantMinHeight;
  static const double copyTradingV2VariantButtonHeight =
      TradeCopySpacingTokens.copyTradingV2VariantButtonHeight;
  static const double copyTradingV2VariantButtonMinWidth =
      TradeCopySpacingTokens.copyTradingV2VariantButtonMinWidth;
  static const double copyTradingV2SortTopRoiWidth =
      TradeCopySpacingTokens.copyTradingV2SortTopRoiWidth;
  static const double copyTradingV2SortAumWidth =
      TradeCopySpacingTokens.copyTradingV2SortAumWidth;
  static const double copyTradingV2SortCopiersWidth =
      TradeCopySpacingTokens.copyTradingV2SortCopiersWidth;
  static const double copyTradingV2SortDefaultWidth =
      TradeCopySpacingTokens.copyTradingV2SortDefaultWidth;
  static const double copyTradingV2SortChipHeight =
      TradeCopySpacingTokens.copyTradingV2SortChipHeight;
  static const double copyTradingV2TraderCardHeight =
      TradeCopySpacingTokens.copyTradingV2TraderCardHeight;
  static const double copyTradingV2TraderAvatarStackWidth =
      TradeCopySpacingTokens.copyTradingV2TraderAvatarStackWidth;
  static const double copyTradingV2TraderAvatarStackHeight =
      TradeCopySpacingTokens.copyTradingV2TraderAvatarStackHeight;
  static const double copyTradingV2TraderAvatarSize =
      TradeCopySpacingTokens.copyTradingV2TraderAvatarSize;
  static const double copyTradingV2TraderTierBadgeSize =
      TradeCopySpacingTokens.copyTradingV2TraderTierBadgeSize;
  static const double copyTradingV2TraderTierBadgeIcon =
      TradeCopySpacingTokens.copyTradingV2TraderTierBadgeIcon;
  static const double copyTradingV2RoiMaxWidth =
      TradeCopySpacingTokens.copyTradingV2RoiMaxWidth;
  static const double copyTradingV2DetailsButtonHeight =
      TradeCopySpacingTokens.copyTradingV2DetailsButtonHeight;
  static const double copyTradingV2HeroIconBox =
      TradeCopySpacingTokens.copyTradingV2HeroIconBox;
  static const double copyTradingV2HeroIconGlyph =
      TradeCopySpacingTokens.copyTradingV2HeroIconGlyph;
  static const double copyTradingV2GlassStatHeight =
      TradeCopySpacingTokens.copyTradingV2GlassStatHeight;
  static const double copyTradingV2GlassStatIconBox =
      TradeCopySpacingTokens.copyTradingV2GlassStatIconBox;
  static const double copyTradingV2GlassStatIconGlyph =
      TradeCopySpacingTokens.copyTradingV2GlassStatIconGlyph;
  static const double copyTradingV2BoldStatHeight =
      TradeCopySpacingTokens.copyTradingV2BoldStatHeight;
  static const double copyEducationIntroMinHeight =
      TradeCopySpacingTokens.copyEducationIntroMinHeight;
  static const double copyEducationModeMinHeight =
      TradeCopySpacingTokens.copyEducationModeMinHeight;
  static const double copyEducationTabHeight =
      TradeCopySpacingTokens.copyEducationTabHeight;
  static const EdgeInsets copyEducationStepNumberPadding =
      TradeCopySpacingTokens.copyEducationStepNumberPadding;
  static const double marginTradingHubHeroStatHeight = 85;
  static const double marginTradingHubMenuItemMinHeight = 92;
  static const double marginTradingHubNavIconSize =
      AppSpacing.iconMd + AppSpacing.hairlineStroke / 2;
  static const double marginTradingHubChevronIcon =
      AppSpacing.iconMd + AppSpacing.hairlineStroke;
  static const double marginTradingHubFeatureCheckIcon =
      AppSpacing.x4 + AppSpacing.x1;
  static const double marginTradingHubComplianceIcon =
      AppSpacing.x4 + AppSpacing.x1;
  static const double marginTradingHubComplianceGap =
      AppSpacing.rowGap + AppSpacing.dividerHairline;
  static const double marginTradingHubComplianceBodyGap = tradeBotNarrowIconGap;
  static const int marginTradingHubComplianceGridColumns = 2;
  static const double marginTradingHubComplianceGridExtent =
      AppSpacing.buttonCompact + AppSpacing.hairlineStroke;
  static const double marginTradingHubComplianceGridCrossGap = tradeBotRowGap;
  static const double marginTradingHubComplianceGridMainGap = AppSpacing.x3;
  static const double marginTradingHubLineHeightTight = tradeBotLineHeightTight;
  static const double marginTradingHubLineHeightTitle = 1.1;
  static const double marginTradingHubLineHeightCaption =
      tradeBotLineHeightCaption;
  static const double marginTradingHubLineHeightBody =
      tradeBotLineHeightReadable;
  static const EdgeInsets marginTradingHubComplianceInfoPadding =
      tradeToolAlertPadding;
  static EdgeInsets transactionReportingScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets transactionReportingStatsPanelPadding =
      EdgeInsets.all(AppSpacing.contentPad - AppSpacing.x1);
  static const EdgeInsets transactionReportingStatCardPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.rowGapRegular,
        AppSpacing.rowGapRegular + AppSpacing.x1,
      );
  static const EdgeInsets transactionReportingReportCardPadding =
      EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets transactionReportingErrorPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x3);
  static const EdgeInsets transactionReportingActionPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.x3);
  static const EdgeInsets transactionReportingQuickActionCardPadding =
      EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets transactionReportingComplianceNoticePadding =
      EdgeInsets.all(AppSpacing.x4);
  static const double transactionReportingLineHeightTight =
      tradeBotLineHeightTight;
  static const double transactionReportingNoticeLineHeight =
      tradeBotLineHeightMedium;
  static const double transactionReportingErrorLineHeight = 1.3;
  static const double transactionReportingStatIcon =
      AppSpacing.x4 + AppSpacing.x1;
  static const double transactionReportingStatusIcon =
      AppSpacing.x4 + AppSpacing.x3;
  static const double transactionReportingErrorIcon =
      AppSpacing.x3 + AppSpacing.hairlineStroke;
  static const EdgeInsets tradeBodyReviewCardPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static EdgeInsets copySafetyScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double copySafetyHeroMinHeight =
      TradeCopySpacingTokens.copySafetyHeroMinHeight;
  static const double copySafetyTierBasicMinHeight =
      TradeCopySpacingTokens.copySafetyTierBasicMinHeight;
  static const double copySafetyTierVerifiedMinHeight =
      TradeCopySpacingTokens.copySafetyTierVerifiedMinHeight;
  static const double copySafetyTierProMinHeight =
      TradeCopySpacingTokens.copySafetyTierProMinHeight;
  static const EdgeInsets copySafetyHeroPadding =
      TradeCopySpacingTokens.copySafetyHeroPadding;
  static const EdgeInsets copySafetyTierPadding =
      TradeCopySpacingTokens.copySafetyTierPadding;
  static const EdgeInsets copySafetyListIndentPadding =
      TradeCopySpacingTokens.copySafetyListIndentPadding;
  static const EdgeInsets copySafetyListItemPadding =
      TradeCopySpacingTokens.copySafetyListItemPadding;
  static const EdgeInsets copySafetyMetricExpandedPadding =
      TradeCopySpacingTokens.copySafetyMetricExpandedPadding;
  static const EdgeInsets copySafetyMetricInfoPadding =
      TradeCopySpacingTokens.copySafetyMetricInfoPadding;
  static const EdgeInsets copySafetyActionCardPadding =
      TradeCopySpacingTokens.copySafetyActionCardPadding;
  static const EdgeInsets copySafetyIconTextPadding =
      TradeCopySpacingTokens.copySafetyIconTextPadding;
  static const double copySafetyHeroTitleLineHeight =
      TradeCopySpacingTokens.copySafetyHeroTitleLineHeight;
  static const double copySafetyListItemLineHeight = tradeBotLineHeightCaption;
  static const double copySafetyDescriptionLineHeight =
      tradeBotLineHeightCompact;
  static const double copySafetyBodyLineHeight = tradeBotLineHeightBody;
  static const double copySafetyIntroLineHeight = tradeBotLineHeightMedium;
  static const double copySafetyLineHeightTight = tradeBotLineHeightTight;
  static const double copySafetyTierIcon =
      TradeCopySpacingTokens.copySafetyTierIcon;
  static const double copySafetyIconTextIcon =
      TradeCopySpacingTokens.copySafetyIconTextIcon;
  static const double copySafetyIconTextGap =
      TradeCopySpacingTokens.copySafetyIconTextGap;
  static const double tradeChartTvLeft = 12;
  static const double tradeChartTvBottom = AppSpacing.rowGap;
  static const double tradeChartPriceRight = AppSpacing.rowGap;
  static const double tradeChartPriceTopDefault = 38;
  static const double tradeChartPriceTopDefaultSecond = 60;
  static const double tradeChartPriceTopPair = 18;
  static const double tradeChartPriceTopPairSecond = 40;
  static const double tradeChartPriceRightTop = 46;
  static const double tradeChartPriceRightBottom = 22;
  static const EdgeInsets tradePriceBadgePadding = EdgeInsets.symmetric(
    horizontal: WalletSpacingTokens.walletAssetSmallGap,
    vertical: AppSpacing.x1,
  );
  static const EdgeInsets tradeMarketListPadding = EdgeInsets.all(14);
  static const double tradeBookRowTopGap =
      WalletSpacingTokens.walletAssetSmallGap;
  static const double tradeBookDividerHeight = 16;
  static const double tradeTapeRowBottomGap = AppSpacing.rowGap;
  static const int tradeHubPrimaryCount = 6;
  static const double tradeHubTileExtent =
      AppSpacing.buttonCompact + AppSpacing.x2;
  static const double tradeChartPanelHeight =
      AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x4;
  static const double tradeOrderTabsHeight = 44;
  static const EdgeInsets tradeOrderTabsInnerPadding = EdgeInsets.all(4);
  static const double tradeFormGap = 16;
  static const double tradeFormSmallGap = 14;
  static const double tradePctGap = 10;
  static const double tradeSideSwitchHeight = 46;
  static const double tradeOrderTypeSize = 39;
  static const double tradePctButtonHeight = 38;
  static const double tradeTpslHeight = 38;
  static const EdgeInsets tradeTpslPadding = EdgeInsets.symmetric(
    horizontal: 14,
  );
  static const double tradeTpslIcon = 16;
  static const double tradeTpslGap = AppSpacing.rowGap;
  static const EdgeInsets tradeFeeCardPadding = EdgeInsets.all(16);
  static const double tradeFeeRowGap = 10;
  static const EdgeInsets tradeFeeBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
    vertical: AppSpacing.hairlineStroke,
  );
  static const double tradeCtaHeight = AppSpacing.ctaHeight;
  static const double tradeListGap = 12;
  static const EdgeInsets tradeListCardPadding = EdgeInsets.all(14);
  static const double tradeHistoryTabGap = AppSpacing.rowGap;
  static const EdgeInsets tradeHistoryTopTabsPadding = EdgeInsets.fromLTRB(
    16,
    12,
    16,
    12,
  );
  static const double tradeHistoryTopTabHeight = 40;
  static const EdgeInsets tradeHistoryBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.rowGap,
    vertical: 4,
  );
  static const double tradeHistoryTypeBadgeMinWidth = 18;
  static const double tradeHistoryInfoGap = AppSpacing.x2;
  static const EdgeInsets tradeHistoryEmptyPadding = EdgeInsets.symmetric(
    vertical: 84,
  );
  static const double tradeHistoryEmptyIcon = 48;
  static const double tradeHistoryEmptyGap = 12;
  static const EdgeInsets tradeHistoryFilterPadding = EdgeInsets.fromLTRB(
    16,
    AppSpacing.rowGap,
    16,
    AppSpacing.rowGap,
  );
  static const double tradeHistoryFilterGap = 10;
  static const double tradeHistoryFilterHeight = AppSpacing.x6;
  static const double tradeHistoryFilterWidth = 58;
  static const double tradeHistoryFilterCompactWidth = 61;
  static const EdgeInsets tradeHistoryFilterPaddingCompact =
      EdgeInsets.symmetric(horizontal: 10);
  static const EdgeInsets tradeHistoryTilePadding = EdgeInsets.fromLTRB(
    tradeHorizontalPadding,
    14,
    tradeHorizontalPadding,
    12,
  );
  static const double tradeHistorySymbolGap = AppSpacing.rowGap;
  static const double tradeHistoryTypeGap = 6;
  static const double tradeHistoryStatusWidth = 118;
  static const double tradeHistoryStatusIcon = 15;
  static const double tradeHistoryStatusGap = AppSpacing.x2;
  static const double tradeHistoryTileGap = 12;
  static const double tradeHistoryTileSmallGap = 10;
  static const double tradeHistoryProgressHeight = AppSpacing.x2;
  static const double tradeHistoryCancelHeight = 36;
  static const double tradeReceiptScrollBottom = 22;
  static const EdgeInsets tradeReceiptRiskPadding = EdgeInsets.all(12);
  static const EdgeInsets tradeReceiptHeroPadding = EdgeInsets.fromLTRB(
    40,
    34,
    40,
    38,
  );
  static const double tradeReceiptHeroIconBox = 64;
  static const double tradeReceiptHeroIcon = AppSpacing.x6;
  static const double tradeReceiptHeroGlowSpread = 12;
  static const double tradeReceiptHeroTitleGap = 22;
  static const double tradeReceiptHeroSubtitleGap = 4;
  static const EdgeInsets tradeReceiptHorizontalMargin = EdgeInsets.symmetric(
    horizontal: 40,
  );
  static const EdgeInsets tradeReceiptCardPadding = EdgeInsets.fromLTRB(
    16,
    16,
    16,
    17,
  );
  static const double tradeReceiptHeaderGap = 10;
  static const double tradeReceiptSectionGap = AppSpacing.x4;
  static const double tradeReceiptDividerGap = 15;
  static const double tradeReceiptSmallDividerGap = 4;
  static const double tradeReceiptTotalGap = 9;
  static const double tradeReceiptRiskTitleGap = 11;
  static const double tradeReceiptRiskColumnGap = 12;
  static const EdgeInsets tradeReceiptSideBadgePadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 6,
  );
  static const EdgeInsets tradeReceiptStatusBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.rowGap,
    vertical: 6,
  );
  static const double tradeReceiptStatusIcon = 12;
  static const double tradeReceiptStatusGap = 4;
  static const EdgeInsets tradeReceiptDetailPadding = EdgeInsets.symmetric(
    vertical: 6,
  );
  static const double tradeReceiptDetailLabelWidth = 116;
  static const double tradeReceiptDetailGap = 10;
  static const double tradeReceiptDetailTrailingGap = 4;
  static const double tradeReceiptCopyButton = 18;
  static const double tradeReceiptCopyIcon = 12;
  static const double tradeReceiptRiskBoxHeight = 62;
  static const EdgeInsets tradeReceiptRiskBoxPadding = EdgeInsets.fromLTRB(
    12,
    10,
    10,
    AppSpacing.rowGap,
  );
  static const double tradeReceiptRiskValueGap = AppSpacing.x2;
  static const EdgeInsets tradeReceiptNoticePadding = EdgeInsets.fromLTRB(
    12,
    10,
    12,
    10,
  );
  static const double tradeReceiptNoticeIconTop = 2;
  static const double tradeReceiptNoticeIcon = 14;
  static const double tradeReceiptNoticeGap = AppSpacing.rowGap;
  static const double tradeReceiptSupportHeight = 46;
  static const EdgeInsets tradeReceiptSupportPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double tradeReceiptSupportIcon = 16;
  static const double tradeReceiptSupportGap = 9;
  static const double tradeReceiptSupportChevronGap = 4;
  static const EdgeInsets tradeReceiptFooterPadding = EdgeInsets.fromLTRB(
    40,
    16,
    40,
    AppSpacing.rowGap,
  );
  static const double tradeReceiptFooterButtonHeight = 48;
  static const double tradeReceiptFooterGap = 12;
  static const double tradeReceiptFooterIcon = 16;
  static const double tradeBotBottomInsetVisual =
      TradeBotsSpacingTokens.tradeBotBottomInsetVisual;
  static const double tradeBotBottomInsetNative =
      TradeBotsSpacingTokens.tradeBotBottomInsetNative;
  static const double tradeBotFooterBottomInsetVisual =
      TradeBotsSpacingTokens.tradeBotFooterBottomInsetVisual;
  static const double tradeBotFooterBottomInsetNative =
      TradeBotsSpacingTokens.tradeBotFooterBottomInsetNative;
  static const double tradeBotPageTopGap = 14;
  static const double tradeBotContentGap = 18;
  static const double tradeBotSmallGap = AppSpacing.x3;
  static const double tradeBotTinyGap = TradeBotsSpacingTokens.tradeBotTinyGap;
  static const double tradeBotRowGap = 10;
  static const double tradeBotCardGap = 12;
  static const double tradeBotPanelGap = 16;
  static const double tradeBotHairline =
      TradeBotsSpacingTokens.tradeBotHairline;
  static const double tradeBotSectionMarkerWidth =
      TradeBotsSpacingTokens.tradeBotSectionMarkerWidth;
  static const double tradeBotSectionMarkerHeight = 15;
  static const double tradeBotNoticeIconTop =
      TradeBotsSpacingTokens.tradeBotNoticeIconTop;
  static const double tradeBotIntroIconTop =
      TradeBotsSpacingTokens.tradeBotIntroIconTop;
  static const double tradeBotRecordIconTop =
      TradeBotsSpacingTokens.tradeBotRecordIconTop;
  static const double tradeBotCardIconGap =
      TradeBotsSpacingTokens.tradeBotCardIconGap;
  static const double tradeBotInlineIconGap =
      TradeBotsSpacingTokens.tradeBotInlineIconGap;
  static const double tradeBotNarrowIconGap = 6;
  static const double tradeBotMetricGap =
      TradeBotsSpacingTokens.tradeBotMetricGap;
  static const double tradeBotLabelGap =
      TradeBotsSpacingTokens.tradeBotLabelGap;
  static const double tradeBotDisclosureGap =
      TradeBotsSpacingTokens.tradeBotDisclosureGap;
  static const double tradeBotStatusGap =
      TradeBotsSpacingTokens.tradeBotStatusGap;
  static const double tradeBotControlHeight =
      TradeBotsSpacingTokens.tradeBotControlHeight;
  static const double tradeBotControlTall =
      TradeBotsSpacingTokens.tradeBotControlTall;
  static const double tradeBotControlCompact =
      TradeBotsSpacingTokens.tradeBotControlCompact;
  static const double tradeBotLanguageTabWidth =
      TradeBotsSpacingTokens.tradeBotLanguageTabWidth;
  static const double tradeBotFooterButtonHeight =
      TradeBotsSpacingTokens.tradeBotFooterButtonHeight;
  static const double tradeBotMethodTextIndent =
      TradeBotsSpacingTokens.tradeBotMethodTextIndent;
  static const double tradeBotSelectionDot =
      TradeBotsSpacingTokens.tradeBotSelectionDot;
  static const double tradeBotSelectionDotInner =
      TradeBotsSpacingTokens.tradeBotSelectionDotInner;
  static const double tradeBotCheckbox = 24;
  static const double tradeBotCheckboxIcon = 16;
  static const double tradeBotSmallIcon = 14;
  static const double tradeBotMediumIcon = 17;
  static const double tradeBotActionIcon = 20;
  static const double tradeBotCardIcon =
      TradeBotsSpacingTokens.tradeBotCardIcon;
  static const double tradeBotHeroIcon =
      TradeBotsSpacingTokens.tradeBotHeroIcon;
  static const double tradeBotProgressHeight =
      TradeBotsSpacingTokens.tradeBotProgressHeight;
  static const double tradeBotScoreProgressHeight =
      TradeBotsSpacingTokens.tradeBotScoreProgressHeight;
  static const double tradeBotCompactProgressHeight =
      TradeBotsSpacingTokens.tradeBotCompactProgressHeight;
  static const int tradeBotGridColumns =
      TradeBotsSpacingTokens.tradeBotGridColumns;
  static const double tradeBotGridAspectRatio =
      TradeBotsSpacingTokens.tradeBotGridAspectRatio;
  static const double tradeBotStrategyGridAspectRatio =
      TradeBotsSpacingTokens.tradeBotStrategyGridAspectRatio;
  static const double tradeBotAnalyticsMetricAspectRatio =
      TradeBotsSpacingTokens.tradeBotAnalyticsMetricAspectRatio;
  static const double tradeBotPortfolioMetricAspectRatio =
      TradeBotsSpacingTokens.tradeBotPortfolioMetricAspectRatio;
  static const double tradeBotRiskMetricAspectRatio =
      TradeBotsSpacingTokens.tradeBotRiskMetricAspectRatio;
  static const double tradeBotCriticalMetricAspectRatio =
      TradeBotsSpacingTokens.tradeBotCriticalMetricAspectRatio;
  static const double tradeBotEquityPerformanceAspectRatio =
      TradeBotsSpacingTokens.tradeBotEquityPerformanceAspectRatio;
  static const double tradeBotAllocationLegendAspectRatio =
      TradeBotsSpacingTokens.tradeBotAllocationLegendAspectRatio;
  static const double tradeBotResultIconBox =
      TradeBotsSpacingTokens.tradeBotResultIconBox;
  static const double tradeBotResultIcon =
      TradeBotsSpacingTokens.tradeBotResultIcon;
  static const double tradeBotQuestionIconBox =
      TradeBotsSpacingTokens.tradeBotQuestionIconBox;
  static const double tradeBotQuestionIcon =
      TradeBotsSpacingTokens.tradeBotQuestionIcon;
  static const double tradeBotOptionMinHeight =
      TradeBotsSpacingTokens.tradeBotOptionMinHeight;
  static const double tradeBotSecurityCardMinHeight =
      TradeBotsSpacingTokens.tradeBotSecurityCardMinHeight;
  static const double tradeBotApiKeyCardMinHeight =
      TradeBotsSpacingTokens.tradeBotApiKeyCardMinHeight;
  static const double tradeBotIpCardMinHeight =
      TradeBotsSpacingTokens.tradeBotIpCardMinHeight;
  static const double tradeBotAnalyticsChartHeight =
      TradeBotsSpacingTokens.tradeBotAnalyticsChartHeight;
  static const double tradeBotRadarChartHeight =
      TradeBotsSpacingTokens.tradeBotRadarChartHeight;
  static const double tradeBotTermsCardHeight =
      TradeBotsSpacingTokens.tradeBotTermsCardHeight;
  static const double tradeBotDistributionChartHeight =
      TradeBotsSpacingTokens.tradeBotDistributionChartHeight;
  static const double tradeBotDashboardChartHeight =
      TradeBotsSpacingTokens.tradeBotDashboardChartHeight;
  static const double tradeBotEquityChartHeight =
      TradeBotsSpacingTokens.tradeBotEquityChartHeight;
  static const double tradeBotEquitySharpeChartHeight =
      TradeBotsSpacingTokens.tradeBotEquitySharpeChartHeight;
  static const double tradeBotEquitySummaryMetricHeight =
      TradeBotsSpacingTokens.tradeBotEquitySummaryMetricHeight;
  static const double tradeBotCompactChartHeight =
      TradeBotsSpacingTokens.tradeBotCompactChartHeight;
  static const double tradeBotRiskRingSize =
      TradeBotsSpacingTokens.tradeBotRiskRingSize;
  static const double tradeBotRiskRingInnerSize =
      TradeBotsSpacingTokens.tradeBotRiskRingInnerSize;
  static const double tradeBotCorrelationColumnWidth =
      TradeBotsSpacingTokens.tradeBotCorrelationColumnWidth;
  static const double tradeBotDisclosureIconBox =
      TradeBotsSpacingTokens.tradeBotDisclosureIconBox;
  static const double tradeBotCorrelationLegendDot =
      TradeBotsSpacingTokens.tradeBotCorrelationLegendDot;
  static const double tradeBotChartLegendSwatchWidth =
      TradeBotsSpacingTokens.tradeBotChartLegendSwatchWidth;
  static const double tradeBotChartLegendSwatchHeight =
      TradeBotsSpacingTokens.tradeBotChartLegendSwatchHeight;
  static const double tradeBotRecommendationIconBox =
      TradeBotsSpacingTokens.tradeBotRecommendationIconBox;
  static const double tradeBotMetricTableColumnWidth =
      TradeBotsSpacingTokens.tradeBotMetricTableColumnWidth;
  static const double tradeBotCassSummaryHeight =
      TradeBotsSpacingTokens.tradeBotCassSummaryHeight;
  static const double tradeBotCassMetricHeight = 47;
  static const double tradeBotCassTabsHeight =
      TradeBotsSpacingTokens.tradeBotCassTabsHeight;
  static const double tradeBotClientQuickLinkHeight =
      TradeBotsSpacingTokens.tradeBotClientQuickLinkHeight;
  static const double tradeBotClientMetricHeight =
      TradeBotsSpacingTokens.tradeBotClientMetricHeight;
  static const double tradeBotClientCategoryHeroIcon =
      TradeBotsSpacingTokens.tradeBotClientCategoryHeroIcon;
  static const double tradeBotClientCategoryHeroIconGlyph =
      TradeBotsSpacingTokens.tradeBotClientCategoryHeroIconGlyph;
  static const double tradeBotClientCategoryIcon =
      TradeBotsSpacingTokens.tradeBotClientCategoryIcon;
  static const double tradeBotClientCategoryIconGlyph =
      TradeBotsSpacingTokens.tradeBotClientCategoryIconGlyph;
  static const double tradeBotClientHistoryIcon =
      TradeBotsSpacingTokens.tradeBotClientHistoryIcon;
  static const double tradeBotClientHistoryIconGlyph =
      TradeBotsSpacingTokens.tradeBotClientHistoryIconGlyph;
  static const double tradeBotClientMarker =
      TradeBotsSpacingTokens.tradeBotClientMarker;
  static const double tradeBotClientCurrentIcon =
      TradeBotsSpacingTokens.tradeBotClientCurrentIcon;
  static const double tradeBotClientMoneyTopGap = 27;
  static const double tradeBotClientMoneyRiskGap =
      TradeBotsSpacingTokens.tradeBotClientMoneyRiskGap;
  static const double tradeBotClientMoneyNoticeIcon =
      TradeBotsSpacingTokens.tradeBotClientMoneyNoticeIcon;
  static const double tradeBotClientMoneyBalanceIcon =
      TradeBotsSpacingTokens.tradeBotClientMoneyBalanceIcon;
  static const double tradeBotClientMoneyBalanceGlyph =
      TradeBotsSpacingTokens.tradeBotClientMoneyBalanceGlyph;
  static const double tradeBotClientMoneyMetricHeight =
      TradeBotsSpacingTokens.tradeBotClientMoneyMetricHeight;
  static const double tradeBotClientMoneyDocumentIcon =
      TradeBotsSpacingTokens.tradeBotClientMoneyDocumentIcon;
  static const double tradeBotClientMoneyDocumentGlyph =
      TradeBotsSpacingTokens.tradeBotClientMoneyDocumentGlyph;
  static const double tradeBotClientMoneyInsolvencyIcon =
      TradeBotsSpacingTokens.tradeBotClientMoneyInsolvencyIcon;
  static const double tradeBotClientMoneyProtectionGap =
      TradeBotsSpacingTokens.tradeBotClientMoneyProtectionGap;
  static const double tradeBotDisputeTabsHeight =
      TradeBotsSpacingTokens.tradeBotDisputeTabsHeight;
  static const double tradeBotDisputeFileTopGap =
      TradeBotsSpacingTokens.tradeBotDisputeFileTopGap;
  static const double tradeBotDisputeCasesTopGap =
      TradeBotsSpacingTokens.tradeBotDisputeCasesTopGap;
  static const double tradeBotDisputeFileBottomGap =
      TradeBotsSpacingTokens.tradeBotDisputeFileBottomGap;
  static const double tradeBotDisputeCasesBottomGap =
      TradeBotsSpacingTokens.tradeBotDisputeCasesBottomGap;
  static const double tradeBotDisputeFooterNativeGap =
      TradeBotsSpacingTokens.tradeBotDisputeFooterNativeGap;
  static const double tradeBotDisputeFooterVisualGap =
      TradeBotsSpacingTokens.tradeBotDisputeFooterVisualGap;
  static const double tradeBotDisputeUploadTallGap =
      TradeBotsSpacingTokens.tradeBotDisputeUploadTallGap;
  static const double tradeBotDisputeUploadCompactGap =
      TradeBotsSpacingTokens.tradeBotDisputeUploadCompactGap;
  static const double tradeBotDisputeTabIndicatorWidth =
      TradeBotsSpacingTokens.tradeBotDisputeTabIndicatorWidth;
  static const double tradeBotDisputeTabBadgeSize = 18;
  static const double tradeBotDisputeComplaintHeight =
      TradeBotsSpacingTokens.tradeBotDisputeComplaintHeight;
  static const double tradeBotDisputeProviderHeight =
      TradeBotsSpacingTokens.tradeBotDisputeProviderHeight;
  static const double tradeBotDisputeDropdownIcon =
      TradeBotsSpacingTokens.tradeBotDisputeDropdownIcon;
  static const double tradeBotDisputeEvidenceHeight =
      TradeBotsSpacingTokens.tradeBotDisputeEvidenceHeight;
  static const double tradeBotDisputeEscalateHeight =
      TradeBotsSpacingTokens.tradeBotDisputeEscalateHeight;
  static const double tradeBotAttributionMetricAspectRatio =
      TradeBotsSpacingTokens.tradeBotAttributionMetricAspectRatio;
  static const double tradeBotAttributionTabHeight =
      TradeBotsSpacingTokens.tradeBotAttributionTabHeight;
  static const double tradeBotAttributionTabIndicatorWidth =
      TradeBotsSpacingTokens.tradeBotAttributionTabIndicatorWidth;
  static const double tradeBotAttributionReturnsChartHeight =
      TradeBotsSpacingTokens.tradeBotAttributionReturnsChartHeight;
  static const double tradeBotAttributionDrawdownChartHeight =
      TradeBotsSpacingTokens.tradeBotAttributionDrawdownChartHeight;
  static const double tradeBotAttributionProjectionChartHeight =
      TradeBotsSpacingTokens.tradeBotAttributionProjectionChartHeight;
  static const double tradeBotAttributionCorrelationChartHeight =
      TradeBotsSpacingTokens.tradeBotAttributionCorrelationChartHeight;
  static const double tradeBotAttributionCompactChartHeight =
      TradeBotsSpacingTokens.tradeBotAttributionCompactChartHeight;
  static const double tradeBotAttributionReturnsCompactChartHeight =
      TradeBotsSpacingTokens.tradeBotAttributionReturnsCompactChartHeight;
  static const double tradeBotAttributionProgressHeight =
      TradeBotsSpacingTokens.tradeBotAttributionProgressHeight;
  static const double tradeBotAttributionLegendLineWidth =
      TradeBotsSpacingTokens.tradeBotAttributionLegendLineWidth;
  static const double tradeBotAttributionLegendLineHeight =
      TradeBotsSpacingTokens.tradeBotAttributionLegendLineHeight;
  static const double tradeBotAttributionLegendItemGap =
      TradeBotsSpacingTokens.tradeBotAttributionLegendItemGap;
  static const double tradeBotAttributionLegendGroupGap =
      TradeBotsSpacingTokens.tradeBotAttributionLegendGroupGap;
  static const double tradeBotMiniStatHeight =
      TradeBotsSpacingTokens.tradeBotMiniStatHeight;
  static const double tradeBotLineHeightTight = 1;
  static const double tradeBotSuitabilityResultTitleLineHeight =
      TradeBotsSpacingTokens.tradeBotSuitabilityResultTitleLineHeight;
  static const double tradeBotLineHeightShort = 1.15;
  static const double tradeBotLineHeightCaption = 1.2;
  static const double tradeBotLineHeightCompact = 1.25;
  static const double tradeBotLineHeightBody = 1.35;
  static const double tradeBotLineHeightMedium = 1.4;
  static const double tradeBotLineHeightReadable = 1.45;
  static const double tradeBotLineHeightLoose =
      TradeBotsSpacingTokens.tradeBotLineHeightLoose;
  static const double tradeBotLineHeightRelaxed =
      TradeBotsSpacingTokens.tradeBotLineHeightRelaxed;
  static const double tradeBotLineHeightLong =
      TradeBotsSpacingTokens.tradeBotLineHeightLong;
  static const double tradeBotLineHeightLegal =
      TradeBotsSpacingTokens.tradeBotLineHeightLegal;
  static EdgeInsets traderProfileScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4 + AppSpacing.x1 - AppSpacing.hairlineStroke,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const EdgeInsets traderProfileHeroPadding =
      TradeCopySpacingTokens.traderProfileHeroPadding;
  static const EdgeInsets traderProfilePanelPadding =
      TradeCopySpacingTokens.traderProfilePanelPadding;
  static const EdgeInsets traderProfileRiskPanelPadding =
      TradeCopySpacingTokens.traderProfileRiskPanelPadding;
  static const EdgeInsets traderProfileTradeCardPadding =
      TradeCopySpacingTokens.traderProfileTradeCardPadding;
  static const EdgeInsets traderProfileMetricPadding =
      TradeCopySpacingTokens.traderProfileMetricPadding;
  static const EdgeInsets traderProfileStatsLinePadding =
      TradeCopySpacingTokens.traderProfileStatsLinePadding;
  static const double traderProfileAvatarSize =
      TradeCopySpacingTokens.traderProfileAvatarSize;
  static const double traderProfileHeaderGap =
      TradeCopySpacingTokens.traderProfileHeaderGap;
  static const double traderProfileSectionGap =
      TradeCopySpacingTokens.traderProfileSectionGap;
  static const double traderProfilePanelInnerGap =
      TradeCopySpacingTokens.traderProfilePanelInnerGap;
  static const double traderProfileWrapGap =
      TradeCopySpacingTokens.traderProfileWrapGap;
  static const double traderProfileTinyGap =
      TradeCopySpacingTokens.traderProfileTinyGap;
  static const double traderProfileChartHeight =
      TradeCopySpacingTokens.traderProfileChartHeight;
  static const double traderProfileDailyChartHeight =
      TradeCopySpacingTokens.traderProfileDailyChartHeight;
  static const double traderProfileMetricHeight =
      TradeCopySpacingTokens.traderProfileMetricHeight;
  static const double traderProfileProgressHeight =
      TradeCopySpacingTokens.traderProfileProgressHeight;
  static const double traderProfileWinLossBarHeight =
      TradeCopySpacingTokens.traderProfileWinLossBarHeight;
  static const double traderProfileStatsValueWidth =
      TradeCopySpacingTokens.traderProfileStatsValueWidth;
  static const double traderProfileDetailIcon =
      TradeCopySpacingTokens.traderProfileDetailIcon;
  static const double traderProfileActionIcon = tradeBotMediumIcon;
  static const double productGovernanceBottomInsetVisual =
      TradeComplianceSpacingTokens.productGovernanceBottomInsetVisual;
  static const double productGovernanceBottomInsetNative =
      TradeComplianceSpacingTokens.productGovernanceBottomInsetNative;
  static const double productGovernanceTopInset =
      AppSpacing.x6 + AppSpacing.hairlineStroke;
  static const double productGovernanceContentGap =
      TradeComplianceSpacingTokens.productGovernanceContentGap;
  static const double productGovernanceInlineGap = tradeBotRowGap;
  static const double productGovernancePillGap =
      TradeComplianceSpacingTokens.productGovernancePillGap;
  static const double productGovernanceTagGap = tradeBotNarrowIconGap;
  static const double productGovernanceTargetGap =
      TradeComplianceSpacingTokens.productGovernanceTargetGap;
  static const double productGovernanceDateSectionGap = tradeBotMediumIcon;
  static const double productGovernanceNegativeTagGap = tradeBotContentGap;
  static const double productGovernanceReviewGap =
      TradeComplianceSpacingTokens.productGovernanceReviewGap;
  static const double productGovernanceReviewActionGap = tradeBotNarrowIconGap;
  static const double productGovernanceReviewTextGap =
      TradeComplianceSpacingTokens.productGovernanceReviewTextGap;
  static const double productGovernanceActionIcon = tradeBotMediumIcon;
  static const double productGovernanceNoticeIcon = tradeBotMediumIcon;
  static const double productGovernanceChannelIconBox =
      TradeComplianceSpacingTokens.productGovernanceChannelIconBox;
  static const double productGovernanceChannelStatusIcon = 19;
  static const double productGovernanceDateBoxHeight = tradeBotCassMetricHeight;
  static const double productGovernanceLineHeightTight =
      tradeBotLineHeightTight;
  static const EdgeInsets productGovernanceNoticePadding =
      TradeComplianceSpacingTokens.productGovernanceNoticePadding;
  static const EdgeInsets productGovernanceCardPadding =
      TradeComplianceSpacingTokens.productGovernanceCardPadding;
  static const EdgeInsets productGovernanceReviewRowPadding =
      TradeComplianceSpacingTokens.productGovernanceReviewRowPadding;
  static const EdgeInsets productGovernanceDistributionCardPadding =
      TradeComplianceSpacingTokens.productGovernanceDistributionCardPadding;
  static const EdgeInsets productGovernanceDateBoxPadding = EdgeInsets.fromLTRB(
    tradeBotRowGap,
    AppSpacing.x2,
    tradeBotRowGap,
    AppSpacing.x2,
  );
  static EdgeInsets productGovernanceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        productGovernanceTopInset,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double activeCopiesBottomInsetVisual = 104;
  static const double activeCopiesBottomInsetNative = 28;
  static const double activeCopiesPortfolioHeight = 194;
  static const double activeCopiesPnlHeight = 62;
  static const double activeCopiesTabsHeight =
      AppSpacing.inputHeight - AppSpacing.x4;
  static const double activeCopiesMiniValueHeight =
      AppSpacing.inputHeight - AppSpacing.hairlineStroke;
  static const double activeCopiesReturnHeight =
      LaunchpadSpacingTokens.launchpadBox40 + AppSpacing.hairlineStroke;
  static const double activeCopiesPerformanceHeight =
      AppSpacing.x7 - AppSpacing.hairlineStroke;
  static const double activeCopiesActionHeight =
      WalletSpacingTokens.walletDepositCopyButtonHeight;
  static const double activeCopiesPnlIcon = tradeBotMediumIcon;
  static const double activeCopiesVerifiedIcon =
      AppSpacing.x3 + AppSpacing.x4 - AppSpacing.x1;
  static const double activeCopiesExpandIcon =
      productGovernanceChannelStatusIcon;
  static const double activeCopiesExpandPadding = 4.5;
  static const double activeCopiesLineHeightTight = tradeBotLineHeightTight;
  static const double activeCopiesLineHeightShort = 1.1;
  static const double activeCopiesLineHeightCompact = tradeBotLineHeightShort;
  static const double activeCopiesLineHeightCaption = tradeBotLineHeightCaption;
  static const double activeCopiesLineHeightNotice = tradeBotLineHeightReadable;
  static const EdgeInsets activeCopiesPnlPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.rowPy,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets activeCopiesTabsPadding = EdgeInsets.all(
    AppSpacing.x1,
  );
  static const EdgeInsets activeCopiesMiniValuePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: AppSpacing.x3,
  );
  static const EdgeInsets activeCopiesReturnPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const EdgeInsets activeCopiesDetailsPadding = EdgeInsets.only(
    top: AppSpacing.rowPy,
  );
  static const EdgeInsets activeCopiesSmallCardPadding = EdgeInsets.all(
    WalletSpacingTokens.walletAssetPillGap,
  );
  static const EdgeInsets activeCopiesActionPadding = EdgeInsets.symmetric(
    horizontal: WalletSpacingTokens.walletAssetPillGap,
  );
  static EdgeInsets activeCopiesScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets activeCopiesStopSheetPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        AppSpacing.x5 + bottomInset,
      );
  static const double copyConfigurationBottomInsetVisual =
      TradeCopySpacingTokens.copyConfigurationBottomInsetVisual;
  static const double copyConfigurationBottomInsetNative =
      TradeCopySpacingTokens.copyConfigurationBottomInsetNative;
  static const double copyConfigurationAvatarSize =
      TradeCopySpacingTokens.copyConfigurationAvatarSize;
  static const double copyConfigurationPrimaryGap =
      TradeCopySpacingTokens.copyConfigurationPrimaryGap;
  static const double copyConfigurationTinyGap =
      TradeCopySpacingTokens.copyConfigurationTinyGap;
  static const double copyConfigurationSmallGap =
      TradeCopySpacingTokens.copyConfigurationSmallGap;
  static const double copyConfigurationMediumGap =
      TradeCopySpacingTokens.copyConfigurationMediumGap;
  static const double copyConfigurationInlineGap =
      TradeCopySpacingTokens.copyConfigurationInlineGap;
  static const double copyConfigurationCardPaddingValue =
      TradeCopySpacingTokens.copyConfigurationCardPaddingValue;
  static const double copyConfigurationInnerPaddingValue =
      TradeCopySpacingTokens.copyConfigurationInnerPaddingValue;
  static const double copyConfigurationValidationPaddingValue =
      TradeCopySpacingTokens.copyConfigurationValidationPaddingValue;
  static const double copyConfigurationProgressHeight =
      TradeCopySpacingTokens.copyConfigurationProgressHeight;
  static const double copyConfigurationDividerHeight =
      TradeCopySpacingTokens.copyConfigurationDividerHeight;
  static const double copyConfigurationModeIcon = tradeBotActionIcon;
  static const double copyConfigurationRiskIcon =
      TradeCopySpacingTokens.copyConfigurationRiskIcon;
  static const double copyConfigurationValidationIcon = tradeBotCheckboxIcon;
  static const double copyConfigurationPresetHeight =
      TradeCopySpacingTokens.copyConfigurationPresetHeight;
  static const double copyConfigurationRatioWidth =
      TradeCopySpacingTokens.copyConfigurationRatioWidth;
  static const double copyConfigurationDescriptionLineHeight =
      tradeBotLineHeightBody;
  static const EdgeInsets copyConfigurationCardPadding =
      TradeCopySpacingTokens.copyConfigurationCardPadding;
  static const EdgeInsets copyConfigurationInnerPadding =
      TradeCopySpacingTokens.copyConfigurationInnerPadding;
  static const EdgeInsets copyConfigurationRiskTogglePadding =
      TradeCopySpacingTokens.copyConfigurationRiskTogglePadding;
  static const EdgeInsets copyConfigurationValidationPadding =
      TradeCopySpacingTokens.copyConfigurationValidationPadding;
  static const EdgeInsets copyConfigurationSummaryRowPadding =
      TradeCopySpacingTokens.copyConfigurationSummaryRowPadding;
  static EdgeInsets copyConfigurationScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4 + AppSpacing.x1,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets copyConfigurationFooterPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const double copyConfirmationBottomInsetVisual =
      TradeCopySpacingTokens.copyConfirmationBottomInsetVisual;
  static const double copyConfirmationBottomInsetNative =
      TradeCopySpacingTokens.copyConfirmationBottomInsetNative;
  static const double copyConfirmationSectionGap =
      TradeCopySpacingTokens.copyConfirmationSectionGap;
  static const double copyConfirmationCardPaddingValue =
      TradeCopySpacingTokens.copyConfirmationCardPaddingValue;
  static const double copyConfirmationSoftPaddingValue =
      TradeCopySpacingTokens.copyConfirmationSoftPaddingValue;
  static const double copyConfirmationCompactPaddingValue =
      TradeCopySpacingTokens.copyConfirmationCompactPaddingValue;
  static const double copyConfirmationTinyGap =
      TradeCopySpacingTokens.copyConfirmationTinyGap;
  static const double copyConfirmationSmallGap =
      TradeCopySpacingTokens.copyConfirmationSmallGap;
  static const double copyConfirmationInlineGap =
      TradeCopySpacingTokens.copyConfirmationInlineGap;
  static const double copyConfirmationRowGap =
      TradeCopySpacingTokens.copyConfirmationRowGap;
  static const double copyConfirmationIconGap =
      TradeCopySpacingTokens.copyConfirmationIconGap;
  static const double copyConfirmationLabelGap =
      TradeCopySpacingTokens.copyConfirmationLabelGap;
  static const double copyConfirmationDividerHeight =
      TradeCopySpacingTokens.copyConfirmationDividerHeight;
  static const double copyConfirmationCheckboxIcon =
      TradeCopySpacingTokens.copyConfirmationCheckboxIcon;
  static const double copyConfirmationWarningIcon =
      TradeCopySpacingTokens.copyConfirmationWarningIcon;
  static const double copyConfirmationCoolingIcon = tradeBotDisputeTabBadgeSize;
  static const double copyConfirmationProviderAvatarRadius =
      TradeCopySpacingTokens.copyConfirmationProviderAvatarRadius;
  static const double copyConfirmationStepRadius =
      TradeCopySpacingTokens.copyConfirmationStepRadius;
  static const double copyConfirmationLineHeightDense =
      complaintCaseLineHeightDense;
  static const double copyConfirmationLineHeightBody =
      complaintsHandlingRightsBodyLineHeight;
  static const double copyConfirmationLineHeightReadable =
      complaintsHandlingOmbudsmanLineHeight;
  static const EdgeInsets copyConfirmationCardPadding =
      TradeCopySpacingTokens.copyConfirmationCardPadding;
  static const EdgeInsets copyConfirmationSoftPadding =
      TradeCopySpacingTokens.copyConfirmationSoftPadding;
  static const EdgeInsets copyConfirmationCompactPadding =
      TradeCopySpacingTokens.copyConfirmationCompactPadding;
  static const EdgeInsets copyConfirmationSummaryRowPadding =
      TradeCopySpacingTokens.copyConfirmationSummaryRowPadding;
  static EdgeInsets copyConfirmationScrollPadding(double bottomInset) =>
      copyConfigurationScrollPadding(bottomInset);
  static EdgeInsets copyConfirmationFooterPadding(double bottomInset) =>
      copyConfigurationFooterPadding(bottomInset);
  static const double regulatoryInspectionBottomInsetVisualExtra =
      TradeComplianceSpacingTokens.regulatoryInspectionBottomInsetVisualExtra;
  static const double regulatoryInspectionBottomInsetNativeExtra =
      TradeComplianceSpacingTokens.regulatoryInspectionBottomInsetNativeExtra;
  static const double regulatoryInspectionContentGap =
      TradeComplianceSpacingTokens.regulatoryInspectionContentGap;
  static const double regulatoryInspectionScoreMinHeight =
      TradeComplianceSpacingTokens.regulatoryInspectionScoreMinHeight;
  static const double regulatoryInspectionCardPaddingHorizontal =
      TradeComplianceSpacingTokens.regulatoryInspectionCardPaddingHorizontal;
  static const double regulatoryInspectionCardPaddingVertical =
      TradeComplianceSpacingTokens.regulatoryInspectionCardPaddingVertical;
  static const double regulatoryInspectionMetricGap =
      TradeComplianceSpacingTokens.regulatoryInspectionMetricGap;
  static const double regulatoryInspectionCompactGap =
      TradeComplianceSpacingTokens.regulatoryInspectionCompactGap;
  static const double regulatoryInspectionInlineGap =
      TradeComplianceSpacingTokens.regulatoryInspectionInlineGap;
  static const double regulatoryInspectionSmallGap =
      TradeComplianceSpacingTokens.regulatoryInspectionSmallGap;
  static const double regulatoryInspectionMediumGap =
      TradeComplianceSpacingTokens.regulatoryInspectionMediumGap;
  static const double regulatoryInspectionLargeGap =
      TradeComplianceSpacingTokens.regulatoryInspectionLargeGap;
  static const double regulatoryInspectionLooseGap =
      TradeComplianceSpacingTokens.regulatoryInspectionLooseGap;
  static const double regulatoryInspectionScoreIconBox =
      TradeComplianceSpacingTokens.regulatoryInspectionScoreIconBox;
  static const double regulatoryInspectionScoreIcon =
      TradeComplianceSpacingTokens.regulatoryInspectionScoreIcon;
  static const double regulatoryInspectionProgressHeight =
      TradeComplianceSpacingTokens.regulatoryInspectionProgressHeight;
  static const double regulatoryInspectionReadyIconTop =
      TradeComplianceSpacingTokens.regulatoryInspectionReadyIconTop;
  static const double regulatoryInspectionTinyIcon =
      TradeComplianceSpacingTokens.regulatoryInspectionTinyIcon;
  static const double regulatoryInspectionRequirementIcon =
      TradeComplianceSpacingTokens.regulatoryInspectionRequirementIcon;
  static const double regulatoryInspectionQuickStatIcon =
      TradeComplianceSpacingTokens.regulatoryInspectionQuickStatIcon;
  static const double regulatoryInspectionBodyIcon =
      TradeComplianceSpacingTokens.regulatoryInspectionBodyIcon;
  static const double regulatoryInspectionStandardIcon =
      TradeComplianceSpacingTokens.regulatoryInspectionStandardIcon;
  static const double regulatoryInspectionQuickStatHeight =
      TradeComplianceSpacingTokens.regulatoryInspectionQuickStatHeight;
  static const double regulatoryInspectionDocumentHeight =
      TradeComplianceSpacingTokens.regulatoryInspectionDocumentHeight;
  static const double regulatoryInspectionDocumentIconBox =
      TradeComplianceSpacingTokens.regulatoryInspectionDocumentIconBox;
  static const double regulatoryInspectionPortalIconBox =
      TradeComplianceSpacingTokens.regulatoryInspectionPortalIconBox;
  static const double regulatoryInspectionPortalIcon =
      TradeComplianceSpacingTokens.regulatoryInspectionPortalIcon;
  static const double regulatoryInspectionPortalGap =
      TradeComplianceSpacingTokens.regulatoryInspectionPortalGap;
  static const double regulatoryInspectionActionHeight =
      TradeComplianceSpacingTokens.regulatoryInspectionActionHeight;
  static const double regulatoryInspectionLineHeightTight =
      TradeComplianceSpacingTokens.regulatoryInspectionLineHeightTight;
  static const double regulatoryInspectionLineHeightCompact =
      TradeComplianceSpacingTokens.regulatoryInspectionLineHeightCompact;
  static const double regulatoryInspectionLineHeightNote =
      TradeComplianceSpacingTokens.regulatoryInspectionLineHeightNote;
  static const double regulatoryInspectionLineHeightReadable =
      TradeComplianceSpacingTokens.regulatoryInspectionLineHeightReadable;
  static const EdgeInsets regulatoryInspectionCardPadding =
      TradeComplianceSpacingTokens.regulatoryInspectionCardPadding;
  static const EdgeInsets regulatoryInspectionQuickStatPadding =
      TradeComplianceSpacingTokens.regulatoryInspectionQuickStatPadding;
  static const EdgeInsets regulatoryInspectionDocumentPadding =
      TradeComplianceSpacingTokens.regulatoryInspectionDocumentPadding;
  static const EdgeInsets regulatoryInspectionPortalPadding =
      TradeComplianceSpacingTokens.regulatoryInspectionPortalPadding;
  static const EdgeInsets regulatoryInspectionScoreTextPadding =
      TradeComplianceSpacingTokens.regulatoryInspectionScoreTextPadding;
  static const EdgeInsets regulatoryInspectionReadyIconPadding =
      TradeComplianceSpacingTokens.regulatoryInspectionReadyIconPadding;
  static EdgeInsets regulatoryInspectionScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double executionVenueBottomInsetVisualExtra =
      AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x5 + AppSpacing.x3;
  static const double executionVenueBottomInsetNativeExtra =
      AppSpacing.x6 - AppSpacing.formFieldLabelGap;
  static const double executionVenueContentGap = 0;
  static const double executionVenueSectionGap = AppSpacing.x4 + AppSpacing.x1;
  static const double executionVenueControlGap =
      AppSpacing.x5 + AppSpacing.x3 - AppSpacing.x2 + AppSpacing.hairlineStroke;
  static const double executionVenueTabBodyGap =
      AppSpacing.x5 + AppSpacing.x3 - AppSpacing.x2 + AppSpacing.x1;
  static const double executionVenueNoticeTopOffset = AppSpacing.ctaLoadingIcon;
  static const double executionVenueNoticeIcon = AppSpacing.ctaLoadingIcon;
  static const double executionVenueBodyIcon =
      AppSpacing.ctaLoadingIcon - AppSpacing.x1;
  static const double executionVenueSummaryGap = AppSpacing.x4 - AppSpacing.x1;
  static const double executionVenueSummaryHeight =
      AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x1 - AppSpacing.hairlineStroke;
  static const double executionVenueSortIcon =
      AppSpacing.ctaLoadingIcon - AppSpacing.dividerHairline;
  static const double executionVenueSortLabelWidth =
      AppSpacing.buttonCompact + AppSpacing.x3;
  static const double executionVenueSortLabelGap =
      AppSpacing.x2 + AppSpacing.hairlineStroke;
  static const double executionVenueLineHeightTight = 1;
  static const double executionVenueLineHeightControl = 1.15;
  static const double executionVenueCardPaddingValue = AppSpacing.x4;
  static const double executionVenuePanelPaddingValue =
      AppSpacing.x4 + AppSpacing.x1 - AppSpacing.hairlineStroke;
  static const double executionVenueCompactPanelPaddingValue =
      AppSpacing.x4 - AppSpacing.x1;
  static const double executionVenueRankGap =
      AppSpacing.x4 - AppSpacing.hairlineStroke;
  static const double executionVenueWinnerIcon = AppSpacing.x4 + AppSpacing.x1;
  static const double executionVenueMetricBoxHeight =
      AppSpacing.buttonCompact + AppSpacing.x4 + AppSpacing.x1;
  static const double executionVenueMetricBoxBottomPadding =
      AppSpacing.x3 - AppSpacing.hairlineStroke + AppSpacing.x1;
  static const double executionVenueMetricGap =
      AppSpacing.x3 - AppSpacing.hairlineStroke + AppSpacing.x1;
  static const double executionVenueProgressGap =
      AppSpacing.x3 + AppSpacing.hairlineStroke;
  static const double executionVenueProgressHeight =
      AppSpacing.x2 + AppSpacing.hairlineStroke;
  static const double executionVenueTrendBarHeight = AppSpacing.x3;
  static const EdgeInsets executionVenueNoticePadding = EdgeInsets.fromLTRB(
    AppSpacing.x4 - AppSpacing.x1,
    AppSpacing.x3 + AppSpacing.x1,
    AppSpacing.x3,
    AppSpacing.x3 + AppSpacing.x1,
  );
  static const EdgeInsets executionVenueSummaryCardPadding =
      EdgeInsets.fromLTRB(
        AppSpacing.x4 - AppSpacing.x1,
        AppSpacing.x4,
        AppSpacing.x4 - AppSpacing.x1,
        AppSpacing.x4 - AppSpacing.x1,
      );
  static const EdgeInsets executionVenueCardPadding = EdgeInsets.all(
    executionVenueCardPaddingValue,
  );
  static const EdgeInsets executionVenueMetricBoxPadding = EdgeInsets.fromLTRB(
    AppSpacing.x3,
    AppSpacing.x3,
    AppSpacing.x3,
    executionVenueMetricBoxBottomPadding,
  );
  static const EdgeInsets executionVenuePanelPadding = EdgeInsets.all(
    executionVenuePanelPaddingValue,
  );
  static const EdgeInsets executionVenueCompactPanelPadding = EdgeInsets.all(
    executionVenueCompactPanelPaddingValue,
  );
  static EdgeInsets executionVenueScrollPadding(double bottomInset) =>
      AppSpacing.contentInsets.copyWith(
        top: AppSpacing.x4,
        bottom: bottomInset,
      );
  static const double providerGovernanceBottomInsetVisualExtra =
      TradeCopySpacingTokens.providerGovernanceBottomInsetVisualExtra;
  static const double providerGovernanceBottomInsetNativeExtra =
      TradeCopySpacingTokens.providerGovernanceBottomInsetNativeExtra;
  static const double providerGovernanceContentGap =
      TradeCopySpacingTokens.providerGovernanceContentGap;
  static const double providerGovernanceDashboardHeight =
      TradeCopySpacingTokens.providerGovernanceDashboardHeight;
  static const double providerGovernanceDashboardIconBox =
      TradeCopySpacingTokens.providerGovernanceDashboardIconBox;
  static const double providerGovernanceDashboardIcon =
      TradeCopySpacingTokens.providerGovernanceDashboardIcon;
  static const double providerGovernanceDashboardGap =
      TradeCopySpacingTokens.providerGovernanceDashboardGap;
  static const double providerGovernanceDashboardMetricGap =
      TradeCopySpacingTokens.providerGovernanceDashboardMetricGap;
  static const double providerGovernanceCompactGap =
      TradeCopySpacingTokens.providerGovernanceCompactGap;
  static const double providerGovernanceSmallGap =
      TradeCopySpacingTokens.providerGovernanceSmallGap;
  static const double providerGovernanceMediumGap =
      TradeCopySpacingTokens.providerGovernanceMediumGap;
  static const double providerGovernanceSectionGap =
      TradeCopySpacingTokens.providerGovernanceSectionGap;
  static const double providerGovernanceControlGap =
      TradeCopySpacingTokens.providerGovernanceControlGap;
  static const double providerGovernanceTabHeight =
      TradeCopySpacingTokens.providerGovernanceTabHeight;
  static const double providerGovernanceTabBodyGap =
      TradeCopySpacingTokens.providerGovernanceTabBodyGap;
  static const double providerGovernanceNoticeMinHeight =
      TradeCopySpacingTokens.providerGovernanceNoticeMinHeight;
  static const double providerGovernanceNoticeIcon =
      TradeCopySpacingTokens.providerGovernanceNoticeIcon;
  static const double providerGovernanceNoticeGap =
      TradeCopySpacingTokens.providerGovernanceNoticeGap;
  static const double providerGovernanceModificationHeight =
      TradeCopySpacingTokens.providerGovernanceModificationHeight;
  static const double providerGovernanceModificationIcon =
      TradeCopySpacingTokens.providerGovernanceModificationIcon;
  static const double providerGovernanceMetaIcon =
      TradeCopySpacingTokens.providerGovernanceMetaIcon;
  static const double providerGovernanceMetaGap =
      TradeCopySpacingTokens.providerGovernanceMetaGap;
  static const double providerGovernancePanelIcon =
      TradeCopySpacingTokens.providerGovernancePanelIcon;
  static const double providerGovernanceRequestHeight =
      TradeCopySpacingTokens.providerGovernanceRequestHeight;
  static const double providerGovernanceLineHeightTight =
      tradeBotLineHeightTight;
  static const double providerGovernanceLineHeightReadable =
      tradeBotLineHeightReadable;
  static const double providerLeaderboardBottomInsetVisualExtra =
      TradeCopySpacingTokens.providerLeaderboardBottomInsetVisualExtra;
  static const double providerLeaderboardBottomInsetNativeExtra =
      TradeCopySpacingTokens.providerLeaderboardBottomInsetNativeExtra;
  static const double providerLeaderboardTopInset =
      AppSpacing.x4 + AppSpacing.x1 - AppSpacing.hairlineStroke;
  static const double providerLeaderboardContentGap =
      TradeCopySpacingTokens.providerLeaderboardContentGap;
  static const double providerLeaderboardReviewPaddingValue =
      TradeCopySpacingTokens.providerLeaderboardReviewPaddingValue;
  static const double providerLeaderboardWarningPaddingStart =
      TradeCopySpacingTokens.providerLeaderboardWarningPaddingStart;
  static const double providerLeaderboardWarningPaddingEnd =
      TradeCopySpacingTokens.providerLeaderboardWarningPaddingEnd;
  static const double providerLeaderboardWarningPaddingBottom =
      TradeCopySpacingTokens.providerLeaderboardWarningPaddingBottom;
  static const double providerLeaderboardWarningIcon =
      TradeCopySpacingTokens.providerLeaderboardWarningIcon;
  static const double providerLeaderboardWarningGap =
      TradeCopySpacingTokens.providerLeaderboardWarningGap;
  static const double providerLeaderboardWarningTitleGap =
      TradeCopySpacingTokens.providerLeaderboardWarningTitleGap;
  static const double providerLeaderboardCardPaddingStart =
      TradeCopySpacingTokens.providerLeaderboardCardPaddingStart;
  static const double providerLeaderboardCardPaddingEnd =
      TradeCopySpacingTokens.providerLeaderboardCardPaddingEnd;
  static const double providerLeaderboardCardPaddingBottom =
      TradeCopySpacingTokens.providerLeaderboardCardPaddingBottom;
  static const double providerLeaderboardCardTitleGap =
      TradeCopySpacingTokens.providerLeaderboardCardTitleGap;
  static const double providerLeaderboardCardMetricsGap =
      TradeCopySpacingTokens.providerLeaderboardCardMetricsGap;
  static const double providerLeaderboardCardTrailingTop =
      TradeCopySpacingTokens.providerLeaderboardCardTrailingTop;
  static const double providerLeaderboardVerifiedIconGap =
      TradeCopySpacingTokens.providerLeaderboardVerifiedIconGap;
  static const double providerLeaderboardVerifiedIcon =
      TradeCopySpacingTokens.providerLeaderboardVerifiedIcon;
  static const double providerLeaderboardFollowersIcon =
      TradeCopySpacingTokens.providerLeaderboardFollowersIcon;
  static const double providerLeaderboardFiltersLabelGap =
      TradeCopySpacingTokens.providerLeaderboardFiltersLabelGap;
  static const double providerLeaderboardVerifiedPaddingStart =
      TradeCopySpacingTokens.providerLeaderboardVerifiedPaddingStart;
  static const double providerLeaderboardVerifiedPaddingEnd =
      TradeCopySpacingTokens.providerLeaderboardVerifiedPaddingEnd;
  static const double providerLeaderboardDisclaimerPaddingStart =
      TradeCopySpacingTokens.providerLeaderboardDisclaimerPaddingStart;
  static const double providerLeaderboardDisclaimerPaddingTop =
      TradeCopySpacingTokens.providerLeaderboardDisclaimerPaddingTop;
  static const double providerLeaderboardDisclaimerPaddingBottom =
      TradeCopySpacingTokens.providerLeaderboardDisclaimerPaddingBottom;
  static const double providerLeaderboardLineHeightFlat =
      TradeCopySpacingTokens.providerLeaderboardLineHeightFlat;
  static const double providerLeaderboardLineHeightReadable =
      TradeCopySpacingTokens.providerLeaderboardLineHeightReadable;
  static const double providerLeaderboardLineHeightLoose =
      TradeCopySpacingTokens.providerLeaderboardLineHeightLoose;
  static const EdgeInsets providerGovernanceDashboardPadding =
      TradeCopySpacingTokens.providerGovernanceDashboardPadding;
  static const EdgeInsets providerGovernanceSectionTitlePadding =
      TradeCopySpacingTokens.providerGovernanceSectionTitlePadding;
  static const EdgeInsets providerGovernanceNoticePadding =
      TradeCopySpacingTokens.providerGovernanceNoticePadding;
  static const EdgeInsets providerGovernanceModificationPadding =
      TradeCopySpacingTokens.providerGovernanceModificationPadding;
  static const EdgeInsets providerGovernancePanelPadding =
      TradeCopySpacingTokens.providerGovernancePanelPadding;
  static const EdgeInsets providerGovernanceMessagePanelPadding =
      TradeCopySpacingTokens.providerGovernanceMessagePanelPadding;
  static const EdgeInsets providerLeaderboardReviewPadding =
      TradeCopySpacingTokens.providerLeaderboardReviewPadding;
  static const EdgeInsets providerLeaderboardWarningPadding =
      TradeCopySpacingTokens.providerLeaderboardWarningPadding;
  static const EdgeInsets providerLeaderboardCardPadding =
      TradeCopySpacingTokens.providerLeaderboardCardPadding;
  static const EdgeInsets providerLeaderboardTrailingIconPadding =
      TradeCopySpacingTokens.providerLeaderboardTrailingIconPadding;
  static const EdgeInsets providerLeaderboardVerifiedPadding =
      TradeCopySpacingTokens.providerLeaderboardVerifiedPadding;
  static const EdgeInsets providerLeaderboardDisclaimerPadding =
      TradeCopySpacingTokens.providerLeaderboardDisclaimerPadding;
  static EdgeInsets providerLeaderboardScrollPadding(double bottomInset) =>
      AppSpacing.contentInsets.copyWith(
        top: providerLeaderboardTopInset,
        bottom: bottomInset,
      );
  static EdgeInsets providerGovernanceScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double armIntegrationBottomInsetVisualExtra =
      AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x5 + AppSpacing.x3;
  static const double armIntegrationBottomInsetNativeExtra =
      AppSpacing.x6 - AppSpacing.formFieldLabelGap;
  static const double armIntegrationContentGap = AppSpacing.rowPy;
  static const double armIntegrationCardPaddingValue =
      AppSpacing.contentPad - AppSpacing.x1;
  static const double armIntegrationProviderIconBox =
      AppSpacing.inputHeight - AppSpacing.x2;
  static const double armIntegrationProviderIcon =
      AppSpacing.iconMd + AppSpacing.x1;
  static const double armIntegrationInlineGap = AppSpacing.x4;
  static const double armIntegrationLabelGap =
      AppSpacing.rowGapRegular + AppSpacing.x1;
  static const double armIntegrationMetricRowGap = AppSpacing.rowPy;
  static const double armIntegrationCardSectionGap = AppSpacing.x4;
  static const double armIntegrationMetricHeight = AppSpacing.buttonStandard;
  static const double armIntegrationMetricPaddingHorizontal =
      AppSpacing.rowGapRegular + AppSpacing.x1;
  static const double armIntegrationMetricPaddingTop =
      AppSpacing.rowGapRegular + AppSpacing.x1;
  static const double armIntegrationMetricPaddingBottom = AppSpacing.x3;
  static const double armIntegrationDetailsGap = AppSpacing.rowGapRegular;
  static const double armIntegrationTestIcon =
      AppSpacing.x4 + AppSpacing.hairlineStroke;
  static const double armIntegrationLogsIcon =
      AppSpacing.x4 + AppSpacing.dividerHairline;
  static const double armIntegrationLineHeightTight = tradeBotLineHeightTight;
  static const double armIntegrationChartHeight =
      WalletSpacingTokens.walletAssetChartHeight - AppSpacing.rowGapRegular;
  static const double armIntegrationDividerHeight = AppSpacing.dividerHairline;
  static const double armIntegrationLegendGap = AppSpacing.ctaLoadingIcon;
  static const double armIntegrationSlaGap =
      AppSpacing.ctaLoadingIcon - AppSpacing.x1;
  static const double armIntegrationProgressLabelGap = AppSpacing.x4;
  static const double armIntegrationProgressHeight = AppSpacing.x3;
  static const double armIntegrationQuickActionIcon =
      AppSpacing.ctaLoadingIcon - AppSpacing.dividerHairline;
  static const EdgeInsets armIntegrationCardPadding = EdgeInsets.all(
    armIntegrationCardPaddingValue,
  );
  static const EdgeInsets armIntegrationMetricPadding = EdgeInsets.fromLTRB(
    armIntegrationMetricPaddingHorizontal,
    armIntegrationMetricPaddingTop,
    armIntegrationMetricPaddingHorizontal,
    armIntegrationMetricPaddingBottom,
  );
  static const EdgeInsets armIntegrationDetailsPadding = EdgeInsets.symmetric(
    horizontal: armIntegrationMetricPaddingHorizontal,
    vertical: armIntegrationMetricPaddingTop,
  );
  static const EdgeInsets armIntegrationLatencyPadding = EdgeInsets.fromLTRB(
    armIntegrationCardPaddingValue,
    AppSpacing.rowPy,
    armIntegrationCardPaddingValue,
    AppSpacing.rowPy,
  );
  static const EdgeInsets armIntegrationSlaPadding = EdgeInsets.fromLTRB(
    armIntegrationCardPaddingValue,
    armIntegrationSlaGap,
    armIntegrationCardPaddingValue,
    armIntegrationSlaGap,
  );
  static EdgeInsets armIntegrationScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double regulatoryDisclosuresBottomInsetVisualExtra =
      TradeComplianceSpacingTokens.regulatoryDisclosuresBottomInsetVisualExtra;
  static const double regulatoryDisclosuresBottomInsetNativeExtra =
      TradeComplianceSpacingTokens.regulatoryDisclosuresBottomInsetNativeExtra;
  static const double regulatoryDisclosuresContentGap =
      TradeComplianceSpacingTokens.regulatoryDisclosuresContentGap;
  static const double regulatoryDisclosuresReviewGap =
      TradeComplianceSpacingTokens.regulatoryDisclosuresReviewGap;
  static const double regulatoryDisclosuresReviewInnerGap =
      TradeComplianceSpacingTokens.regulatoryDisclosuresReviewInnerGap;
  static const double regulatoryDisclosuresHeroPaddingValue =
      TradeComplianceSpacingTokens.regulatoryDisclosuresHeroPaddingValue;
  static const double regulatoryDisclosuresHeroIconBox =
      TradeComplianceSpacingTokens.regulatoryDisclosuresHeroIconBox;
  static const double regulatoryDisclosuresHeroIcon =
      TradeComplianceSpacingTokens.regulatoryDisclosuresHeroIcon;
  static const double regulatoryDisclosuresHeroGap =
      TradeComplianceSpacingTokens.regulatoryDisclosuresHeroGap;
  static const double regulatoryDisclosuresHeroSubtitleGap =
      TradeComplianceSpacingTokens.regulatoryDisclosuresHeroSubtitleGap;
  static const double regulatoryDisclosuresHeroTitleLineHeight =
      TradeComplianceSpacingTokens.regulatoryDisclosuresHeroTitleLineHeight;
  static const double regulatoryDisclosuresLineHeightCompact =
      tradeBotLineHeightCaption;
  static const double regulatoryDisclosuresActionPaddingValue =
      TradeComplianceSpacingTokens.regulatoryDisclosuresActionPaddingValue;
  static const double regulatoryDisclosuresContactPaddingValue =
      TradeComplianceSpacingTokens.regulatoryDisclosuresContactPaddingValue;
  static const double regulatoryDisclosuresNoticePaddingValue =
      TradeComplianceSpacingTokens.regulatoryDisclosuresNoticePaddingValue;
  static const double regulatoryDisclosuresActionIcon =
      TradeComplianceSpacingTokens.regulatoryDisclosuresActionIcon;
  static const double regulatoryDisclosuresExternalIcon =
      TradeComplianceSpacingTokens.regulatoryDisclosuresExternalIcon;
  static const double regulatoryDisclosuresContactIcon =
      TradeComplianceSpacingTokens.regulatoryDisclosuresContactIcon;
  static const double regulatoryDisclosuresActionGap =
      TradeComplianceSpacingTokens.regulatoryDisclosuresActionGap;
  static const double regulatoryDisclosuresContactGap = tradeBotCardGap;
  static const double regulatoryDisclosuresContactTextGap =
      TradeComplianceSpacingTokens.regulatoryDisclosuresContactTextGap;
  static const double regulatoryDisclosuresNoticeTitleGap =
      TradeComplianceSpacingTokens.regulatoryDisclosuresNoticeTitleGap;
  static const double regulatoryDisclosuresNoticeActionGap = tradeBotPanelGap;
  static const EdgeInsets regulatoryDisclosuresHeroPadding =
      TradeComplianceSpacingTokens.regulatoryDisclosuresHeroPadding;
  static const EdgeInsets regulatoryDisclosuresActionPadding =
      TradeComplianceSpacingTokens.regulatoryDisclosuresActionPadding;
  static const EdgeInsets regulatoryDisclosuresContactPadding =
      TradeComplianceSpacingTokens.regulatoryDisclosuresContactPadding;
  static const EdgeInsets regulatoryDisclosuresNoticePadding =
      TradeComplianceSpacingTokens.regulatoryDisclosuresNoticePadding;
  static EdgeInsets regulatoryDisclosuresScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.rowPy,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double tradeBotTermsReadThreshold =
      TradeBotsSpacingTokens.tradeBotTermsReadThreshold;
  static const double tradeBotSheetActionHeight =
      TradeBotsSpacingTokens.tradeBotSheetActionHeight;
  static const double tradeBotFooterTopOffset =
      TradeBotsSpacingTokens.tradeBotFooterTopOffset;
  static const EdgeInsets tradeBotScrollPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    tradeBotPageTopGap,
    AppSpacing.contentPad,
    0,
  );
  static const EdgeInsets tradeBotPageBodyPadding =
      TradeBotsSpacingTokens.tradeBotPageBodyPadding;
  static const EdgeInsets tradeBotHeroPadding =
      TradeBotsSpacingTokens.tradeBotHeroPadding;
  static const EdgeInsets tradeBotTabShellPadding =
      TradeBotsSpacingTokens.tradeBotTabShellPadding;
  static const EdgeInsets tradeBotCardPadding =
      TradeBotsSpacingTokens.tradeBotCardPadding;
  static const EdgeInsets tradeBotCardPaddingLoose =
      TradeBotsSpacingTokens.tradeBotCardPaddingLoose;
  static const EdgeInsets tradeBotCardPaddingTall =
      TradeBotsSpacingTokens.tradeBotCardPaddingTall;
  static const EdgeInsets tradeBotStrategyCardPadding =
      TradeBotsSpacingTokens.tradeBotStrategyCardPadding;
  static const EdgeInsets tradeBotInnerPanelPadding =
      TradeBotsSpacingTokens.tradeBotInnerPanelPadding;
  static const EdgeInsets tradeBotCompactPanelPadding =
      TradeBotsSpacingTokens.tradeBotCompactPanelPadding;
  static const EdgeInsets tradeBotControlPadding =
      TradeBotsSpacingTokens.tradeBotControlPadding;
  static const EdgeInsets tradeBotCompactCardPadding =
      TradeBotsSpacingTokens.tradeBotCompactCardPadding;
  static const EdgeInsets tradeBotMetricBoxPadding =
      TradeBotsSpacingTokens.tradeBotMetricBoxPadding;
  static const EdgeInsets tradeBotMiniStatPadding =
      TradeBotsSpacingTokens.tradeBotMiniStatPadding;
  static const EdgeInsets tradeBotClientMetricPadding =
      TradeBotsSpacingTokens.tradeBotClientMetricPadding;
  static const EdgeInsets tradeBotClientMoneyNoticePadding =
      TradeBotsSpacingTokens.tradeBotClientMoneyNoticePadding;
  static const EdgeInsets tradeBotClientMoneyBalancePadding =
      TradeBotsSpacingTokens.tradeBotClientMoneyBalancePadding;
  static const EdgeInsets tradeBotClientMoneyOverviewPadding =
      TradeBotsSpacingTokens.tradeBotClientMoneyOverviewPadding;
  static const EdgeInsets tradeBotClientMoneyInsolvencyPadding =
      TradeBotsSpacingTokens.tradeBotClientMoneyInsolvencyPadding;
  static const EdgeInsets tradeBotClientMoneyMetricPadding =
      TradeBotsSpacingTokens.tradeBotClientMoneyMetricPadding;
  static const EdgeInsets tradeBotClientMoneyRowPadding =
      TradeBotsSpacingTokens.tradeBotClientMoneyRowPadding;
  static const EdgeInsets tradeBotClientMoneyDocumentsPadding =
      TradeBotsSpacingTokens.tradeBotClientMoneyDocumentsPadding;
  static const EdgeInsets tradeBotDisputeNoticePadding =
      TradeBotsSpacingTokens.tradeBotDisputeNoticePadding;
  static const EdgeInsets tradeBotDisputeComplaintPadding =
      TradeBotsSpacingTokens.tradeBotDisputeComplaintPadding;
  static const EdgeInsets tradeBotDisputeProviderPadding =
      TradeBotsSpacingTokens.tradeBotDisputeProviderPadding;
  static const EdgeInsets tradeBotDisputeDescriptionLabelPadding =
      EdgeInsets.only(top: tradeBotSmallGap);
  static const EdgeInsets tradeBotDisputeTextFieldPadding =
      TradeBotsSpacingTokens.tradeBotDisputeTextFieldPadding;
  static const EdgeInsets tradeBotAttributionMetricPadding =
      TradeBotsSpacingTokens.tradeBotAttributionMetricPadding;
  static const EdgeInsets tradeBotAttributionPanelPadding =
      TradeBotsSpacingTokens.tradeBotAttributionPanelPadding;
  static const EdgeInsets tradeBotAttributionProjectionPadding =
      TradeBotsSpacingTokens.tradeBotAttributionProjectionPadding;
  static const EdgeInsets tradeBotCopyDemoPanelPadding =
      TradeBotsSpacingTokens.tradeBotCopyDemoPanelPadding;
  static const EdgeInsets tradeBotCopyDemoCardPadding =
      TradeBotsSpacingTokens.tradeBotCopyDemoCardPadding;
  static const EdgeInsets tradeBotCopyDemoCompactPadding =
      TradeBotsSpacingTokens.tradeBotCopyDemoCompactPadding;
  static const EdgeInsets tradeBotCopyDemoInlinePadding =
      TradeBotsSpacingTokens.tradeBotCopyDemoInlinePadding;
  static const EdgeInsets tradeBotCopyDemoBadgePadding =
      TradeBotsSpacingTokens.tradeBotCopyDemoBadgePadding;
  static const EdgeInsets tradeBotCopyDemoLinePadding =
      TradeBotsSpacingTokens.tradeBotCopyDemoLinePadding;
  static const EdgeInsets tradeBotCopyDemoCompactLinePadding =
      TradeBotsSpacingTokens.tradeBotCopyDemoCompactLinePadding;
  static const EdgeInsets tradeBotCopyDemoDividerPadding =
      TradeBotsSpacingTokens.tradeBotCopyDemoDividerPadding;
  static const EdgeInsets tradeBotCopyDemoRowPadding =
      TradeBotsSpacingTokens.tradeBotCopyDemoRowPadding;
  static const EdgeInsets tradeBotCopyDemoSectionBottomPadding =
      TradeBotsSpacingTokens.tradeBotCopyDemoSectionBottomPadding;
  static const EdgeInsets tradeBotCopyDemoHeaderBottomPadding =
      TradeBotsSpacingTokens.tradeBotCopyDemoHeaderBottomPadding;
  static const EdgeInsets tradeBotTermsScrollPadding =
      TradeBotsSpacingTokens.tradeBotTermsScrollPadding;
  static const EdgeInsets tradeBotTermsWarningPadding =
      TradeBotsSpacingTokens.tradeBotTermsWarningPadding;
  static const EdgeInsets tradeBotAgreementPadding =
      TradeBotsSpacingTokens.tradeBotAgreementPadding;
  static const EdgeInsets tradeBotAgreementIconMargin =
      TradeBotsSpacingTokens.tradeBotAgreementIconMargin;
  static const EdgeInsets tradeBotIntroIconTopPadding =
      TradeBotsSpacingTokens.tradeBotIntroIconTopPadding;
  static const EdgeInsets tradeBotNoticeIconTopPadding =
      TradeBotsSpacingTokens.tradeBotNoticeIconTopPadding;
  static const EdgeInsets tradeBotRecordIconTopPadding =
      TradeBotsSpacingTokens.tradeBotRecordIconTopPadding;
  static const EdgeInsets tradeBotMetricTableHeaderPadding = EdgeInsets.only(
    bottom: tradeBotRowGap,
  );
  static const EdgeInsets tradeBotMetricTableRowPadding = EdgeInsets.symmetric(
    vertical: tradeBotRowGap,
  );
  static const EdgeInsets tradeBotMetricTableStarGap =
      TradeBotsSpacingTokens.tradeBotMetricTableStarGap;
  static const EdgeInsets tradeBotTermsBulletPadding = EdgeInsets.only(
    left: tradeBotCardGap,
    bottom: tradeBotSmallGap,
  );
  static const EdgeInsets tradeBotClientQuickLinkPadding =
      TradeBotsSpacingTokens.tradeBotClientQuickLinkPadding;
  static const EdgeInsets tradeBotOptionPadding =
      TradeBotsSpacingTokens.tradeBotOptionPadding;
  static const EdgeInsets tradeBotFooterPadding =
      TradeBotsSpacingTokens.tradeBotFooterPadding;
  static const EdgeInsets tradeBotSheetPadding =
      TradeBotsSpacingTokens.tradeBotSheetPadding;
  static const EdgeInsets tradeBotChipPadding =
      TradeBotsSpacingTokens.tradeBotChipPadding;
  static const EdgeInsets tradeBotCodeBlockPadding =
      TradeBotsSpacingTokens.tradeBotCodeBlockPadding;
  static const EdgeInsets tradeBotCodeBlockCompactPadding =
      TradeBotsSpacingTokens.tradeBotCodeBlockCompactPadding;
  static EdgeInsets tradeBotScrollPaddingWithBottom(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        tradeBotPageTopGap,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets tradeBotClientMoneyScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        tradeBotClientMoneyTopGap,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets tradeBotDisputeScrollPadding(
    double topInset,
    double bottomInset,
  ) => EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    topInset,
    AppSpacing.contentPad,
    bottomInset,
  );
  static EdgeInsets tradeBotDisputeUploadPadding(double topGap) =>
      EdgeInsets.only(top: topGap);
  static EdgeInsets tradeBotAttributionScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        tradeBotCardGap,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets tradeBotCopyDemoScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static EdgeInsets tradeBotSecurityScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets tradeBotActionButtonPadding(bool compact) =>
      EdgeInsets.symmetric(horizontal: compact ? AppSpacing.x3 : AppSpacing.x4);
  static EdgeInsets tradeBotSheetPaddingWithBottom(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        AppSpacing.contentPad,
        tradeBotCheckbox + bottomInset,
      );
  static const double tradeToolBottomInsetSlippageVisual = 118;
  static const double tradeToolBottomInsetSlippageNative = 28;
  static const double tradeToolBottomInsetRiskVisual = 97;
  static const double tradeToolBottomInsetRiskNative = 24;
  static const double tradeToolBottomInsetExport = 126;
  static const double tradeToolPageTopGap = 14;
  static const double tradeToolSectionGap = 26;
  static const double tradeToolContentGap = 24;
  static const double tradeToolReviewGap = 22;
  static const double tradeToolCardGap = 12;
  static const double tradeToolInlineGap = AppSpacing.x3;
  static const double tradeToolTinyGap = AppSpacing.x2;
  static const double tradeToolMicroGap = 2;
  static const double tradeToolIconGap = 10;
  static const double tradeToolSectionHeaderGap = 12;
  static const double tradeToolTabHeight = 53;
  static const double tradeToolRiskTabHeight = 44;
  static const double tradeToolStatCardHeight = 150;
  static const double tradeToolStatValueHeight = 52;
  static const double tradeToolMetricHeight = 60;
  static const double tradeToolMetricRowHeight = 30;
  static const double tradeToolDateColumnWidth = 46;
  static const double tradeToolExportSummaryHeight = 132;
  static const double tradeToolFormatHeight = 118;
  static const double tradeToolIncludeRowHeight = 41;
  static const double tradeToolProgressHeight = AppSpacing.x3;
  static const double tradeToolIconTileSm = 40;
  static const double tradeToolIconTileMd = 48;
  static const double tradeToolAlertIcon = 17;
  static const double tradeToolBodyIcon = 18;
  static const double tradeToolPanelIcon = 19;
  static const double tradeToolFormatIcon = 24;
  static const double tradeToolFooterIcon = 17;
  static const double tradeToolCloseIcon = 16;
  static const double tradeToolFooterReadyHeight = 42;
  static const int tradeToolFooterButtonFlex = 2;
  static const EdgeInsets tradeToolAlertPadding = EdgeInsets.fromLTRB(
    12,
    12,
    12,
    12,
  );
  static const EdgeInsets tradeToolCardPadding = EdgeInsets.all(14);
  static const EdgeInsets tradeToolCardPaddingCompact = EdgeInsets.all(13);
  static const EdgeInsets tradeToolMetricPadding = EdgeInsets.fromLTRB(
    8,
    8,
    8,
    7,
  );
  static const EdgeInsets tradeToolMetricRowPadding = EdgeInsets.symmetric(
    horizontal: 10,
  );
  static const EdgeInsets tradeToolNoticePadding = EdgeInsets.fromLTRB(
    12,
    9,
    8,
    9,
  );
  static const EdgeInsets tradeToolRiskReviewPadding = EdgeInsets.all(12);
  static const EdgeInsets tradeToolRiskIntroPadding = EdgeInsets.all(16);
  static const EdgeInsets tradeToolSheetRowPadding = EdgeInsets.symmetric(
    vertical: 7,
  );
  static const EdgeInsets tradeToolToastPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  );
  static const EdgeInsets tradeToolExportSummaryPadding = EdgeInsets.fromLTRB(
    16,
    16,
    16,
    15,
  );
  static const EdgeInsets tradeToolFormatPadding = EdgeInsets.fromLTRB(
    12,
    16,
    12,
    14,
  );
  static const EdgeInsets tradeToolIncludeListPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const EdgeInsets tradeToolTaxNotePadding = EdgeInsets.fromLTRB(
    12,
    11,
    12,
    11,
  );
  static const EdgeInsets tradeToolFooterPaddingStandard = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    16,
    AppSpacing.contentPad,
    tradeToolPageTopGap,
  );
  static const EdgeInsets tradeToolFooterPaddingExported = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    12,
    AppSpacing.contentPad,
    tradeToolPageTopGap,
  );
  static EdgeInsets tradeToolScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        tradeToolPageTopGap,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets tradeToolExportScrollPadding(double bottomChrome) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        tradeToolPageTopGap,
        AppSpacing.contentPad,
        bottomChrome + tradeToolBottomInsetExport,
      );
  static const double tradeSettingsChipHeight = AppSpacing.x6;
  static const double tradeSettingsChipHeightSm = 30;
  static const double tradeSettingsToggleWidth = 42;
  static const double tradeSettingsToggleHeight = 24;
  static const double tradeSettingsToggleKnob = 18;
  static const double tradeSettingsButtonHeight = 44;
}
