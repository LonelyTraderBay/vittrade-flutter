import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';

/// Surface-aware adapter for shared feature widgets.
///
/// Presentation code that is intentionally shared by Phone and Tablet must
/// read geometry through this boundary. Phone keeps [AppSpacing]; Tablet gets
/// [TabletSpacingTokens]. Surface selection is resolved once at bootstrap.
final class AppSurfaceSpacing {
  const AppSurfaceSpacing._();

  static bool get _isTablet => TabletSpacingTokens.tabletSurfaceActive;

  static double get x1 => _isTablet ? TabletSpacingTokens.x1 : AppSpacing.x1;
  static double get x2 => _isTablet ? TabletSpacingTokens.x2 : AppSpacing.x2;
  static double get x3 => _isTablet ? TabletSpacingTokens.x3 : AppSpacing.x3;
  static double get x4 => _isTablet ? TabletSpacingTokens.x4 : AppSpacing.x4;
  static double get x5 => _isTablet ? TabletSpacingTokens.x5 : AppSpacing.x5;
  static double get x6 => _isTablet ? TabletSpacingTokens.x6 : AppSpacing.x6;
  static double get x7 => _isTablet ? TabletSpacingTokens.x7 : AppSpacing.x7;

  static double get buttonCompact =>
      _isTablet ? TabletSpacingTokens.buttonCompact : AppSpacing.buttonCompact;
  static double get buttonStandard => _isTablet
      ? TabletSpacingTokens.buttonStandard
      : AppSpacing.buttonStandard;
  static double get ctaHeight =>
      _isTablet ? TabletSpacingTokens.ctaHeight : AppSpacing.ctaHeight;
  static double get contentPad =>
      _isTablet ? TabletSpacingTokens.contentPad : AppSpacing.contentPad;
  static double get zero =>
      _isTablet ? TabletSpacingTokens.zero : AppSpacing.zero;
  static EdgeInsets get zeroInsets =>
      _isTablet ? TabletSpacingTokens.zeroInsets : AppSpacing.zeroInsets;
  static double get dividerHairline => _isTablet
      ? TabletSpacingTokens.dividerHairline
      : AppSpacing.dividerHairline;
  static double get formFieldLabelGap => _isTablet
      ? TabletSpacingTokens.formFieldLabelGap
      : AppSpacing.formFieldLabelGap;
  static double get rowPy =>
      _isTablet ? TabletSpacingTokens.rowPy : AppSpacing.rowPy;
  static double get iconSm =>
      _isTablet ? TabletSpacingTokens.iconSm : AppSpacing.iconSm;
  static double get iconMd =>
      _isTablet ? TabletSpacingTokens.iconMd : AppSpacing.iconMd;
  static double get iconLg =>
      _isTablet ? TabletSpacingTokens.iconLg : AppSpacing.iconLg;
  static double get inputHeight =>
      _isTablet ? TabletSpacingTokens.inputHeight : AppSpacing.inputHeight;
  static double get hairlineStroke => _isTablet
      ? TabletSpacingTokens.hairlineStroke
      : AppSpacing.hairlineStroke;
  static double get borderWidth =>
      _isTablet ? TabletSpacingTokens.borderWidth : AppSpacing.borderWidth;
  static double get minTapTarget =>
      _isTablet ? TabletSpacingTokens.minTapTarget : AppSpacing.minTapTarget;
  static double get ctaLoadingIcon => _isTablet
      ? TabletSpacingTokens.ctaLoadingIcon
      : AppSpacing.ctaLoadingIcon;
  static double get ctaStrokeWidth => _isTablet
      ? TabletSpacingTokens.ctaStrokeWidth
      : AppSpacing.ctaStrokeWidth;
  static double get ctaElevationBlur => _isTablet
      ? TabletSpacingTokens.ctaElevationBlur
      : AppSpacing.ctaElevationBlur;
  static double get ctaElevationSpread => _isTablet
      ? TabletSpacingTokens.ctaElevationSpread
      : AppSpacing.ctaElevationSpread;
  static double get ctaElevationYOffset => _isTablet
      ? TabletSpacingTokens.ctaElevationYOffset
      : AppSpacing.ctaElevationYOffset;
  static double get accentIconBoxSize => _isTablet
      ? TabletSpacingTokens.accentIconBoxSize
      : AppSpacing.accentIconBoxSize;
  static double get accentIconFillAlpha => _isTablet
      ? TabletSpacingTokens.accentIconFillAlpha
      : AppSpacing.accentIconFillAlpha;
  static double get accentIconBorderAlpha => _isTablet
      ? TabletSpacingTokens.accentIconBorderAlpha
      : AppSpacing.accentIconBorderAlpha;
  static double get sectionGapCompact => _isTablet
      ? TabletSpacingTokens.sectionGapCompact
      : AppSpacing.sectionGapCompact;
  static double get sectionGapRegular => _isTablet
      ? TabletSpacingTokens.sectionGapRegular
      : AppSpacing.sectionGapRegular;
  static double get sectionGapRelaxed => _isTablet
      ? TabletSpacingTokens.sectionGapRelaxed
      : AppSpacing.sectionGapRelaxed;
  static EdgeInsetsGeometry get cardPadding =>
      _isTablet ? TabletSpacingTokens.cardPadding : AppSpacing.cardPadding;
  static EdgeInsetsGeometry get cardPaddingHero => _isTablet
      ? TabletSpacingTokens.cardPaddingHero
      : AppSpacing.cardPaddingHero;
  static EdgeInsetsGeometry get homeCardPaddingDefault => _isTablet
      ? TabletSpacingTokens.cardPaddingStandardDensity
      : SharedSpacingTokens.homeCardPaddingDefault;
  static EdgeInsetsGeometry get homeAnnouncementCardPaddingCompact => _isTablet
      ? TabletSpacingTokens.cardPaddingCompactDensity
      : SharedSpacingTokens.homeAnnouncementCardPaddingCompact;
  static double get homeAnnouncementIconGap => _isTablet
      ? TabletSpacingTokens.x3
      : SharedSpacingTokens.homeAnnouncementIconGap;
  static double get homeAnnouncementArrowGap => _isTablet
      ? TabletSpacingTokens.x3
      : SharedSpacingTokens.homeAnnouncementArrowGap;
  static double get homeNextActionCardPadding => _isTablet
      ? TabletSpacingTokens.cardPaddingStandardDensity.horizontal / 2
      : SharedSpacingTokens.homeNextActionCardPadding;
  static double get homeNextActionIconGap => _isTablet
      ? TabletSpacingTokens.x3
      : SharedSpacingTokens.homeCommandRowSpacing;
  static double get homeNextActionTitleSubtitleGap => _isTablet
      ? TabletSpacingTokens.x3
      : SharedSpacingTokens.homeSectionInnerGap;
  static double get homeNextActionChevronGap =>
      _isTablet ? TabletSpacingTokens.x1 : SharedSpacingTokens.homeChevronGap;
  static EdgeInsetsGeometry get cardTilePadding => _isTablet
      ? TabletSpacingTokens.cardTilePadding
      : AppSpacing.cardTilePadding;
  static double get cardTileInnerGap => _isTablet
      ? TabletSpacingTokens.cardTileInnerGap
      : AppSpacing.cardTileInnerGap;
  static EdgeInsetsGeometry get taskCardPadding => _isTablet
      ? TabletSpacingTokens.taskCardPadding
      : AppSpacing.taskCardPadding;
  static double get taskCardProgressHeight => _isTablet
      ? TabletSpacingTokens.taskCardProgressHeight
      : AppSpacing.taskCardProgressHeight;
  static int get taskCardSubtitleMaxLines => _isTablet
      ? TabletSpacingTokens.taskCardSubtitleMaxLines
      : AppSpacing.taskCardSubtitleMaxLines;
  static double get taskCardTitleSubtitleGap => _isTablet
      ? TabletSpacingTokens.taskCardTitleSubtitleGap
      : AppSpacing.taskCardTitleSubtitleGap;
  static double get taskCardProgressSectionGap => _isTablet
      ? TabletSpacingTokens.taskCardProgressSectionGap
      : AppSpacing.taskCardProgressSectionGap;
  static double get taskCardRewardRowGap => _isTablet
      ? TabletSpacingTokens.taskCardRewardRowGap
      : AppSpacing.taskCardRewardRowGap;
  static double get taskCardListGap => _isTablet
      ? TabletSpacingTokens.taskCardListGap
      : AppSpacing.taskCardListGap;
  static double get searchBarCompactHeight => _isTablet
      ? TabletSpacingTokens.searchBarCompactHeight
      : AppSpacing.searchBarCompactHeight;
  static double get searchBarCompactFont => _isTablet
      ? TabletSpacingTokens.searchBarCompactFont
      : AppSpacing.searchBarCompactFont;
  static double get searchBarFont =>
      _isTablet ? TabletSpacingTokens.searchBarFont : AppSpacing.searchBarFont;
  static double get searchBarHorizontalPadding => _isTablet
      ? TabletSpacingTokens.searchBarHorizontalPadding
      : AppSpacing.searchBarHorizontalPadding;
  static double get searchBarHorizontalTrailingPadding => _isTablet
      ? TabletSpacingTokens.searchBarHorizontalTrailingPadding
      : AppSpacing.searchBarHorizontalTrailingPadding;
  static double get searchBarFocusBorder => _isTablet
      ? TabletSpacingTokens.searchBarFocusBorder
      : AppSpacing.searchBarFocusBorder;
  static double get searchBarNormalBorder => _isTablet
      ? TabletSpacingTokens.searchBarNormalBorder
      : AppSpacing.searchBarNormalBorder;
  static double get searchBarIcon =>
      _isTablet ? TabletSpacingTokens.searchBarIcon : AppSpacing.searchBarIcon;
  static double get tabBarPillRadius => _isTablet
      ? TabletSpacingTokens.tabBarPillRadius
      : AppSpacing.tabBarPillRadius;
  static double get statusPillHeightSm => _isTablet
      ? TabletSpacingTokens.statusPillHeightSm
      : AppSpacing.statusPillHeightSm;
  static double get statusPillHeightMd => _isTablet
      ? TabletSpacingTokens.statusPillHeightMd
      : AppSpacing.statusPillHeightMd;
  static double get statusPillHeightLg => _isTablet
      ? TabletSpacingTokens.statusPillHeightLg
      : AppSpacing.statusPillHeightLg;
  static double get statusPillGapSm => _isTablet
      ? TabletSpacingTokens.statusPillGapSm
      : AppSpacing.statusPillGapSm;
  static double get statusPillGapMd => _isTablet
      ? TabletSpacingTokens.statusPillGapMd
      : AppSpacing.statusPillGapMd;
  static double get statusPillGapLg => _isTablet
      ? TabletSpacingTokens.statusPillGapLg
      : AppSpacing.statusPillGapLg;
  static double get statusPillHorizontalPaddingSm => _isTablet
      ? TabletSpacingTokens.statusPillHorizontalPaddingSm
      : AppSpacing.statusPillHorizontalPaddingSm;
  static double get statusPillHorizontalPaddingMd => _isTablet
      ? TabletSpacingTokens.statusPillHorizontalPaddingMd
      : AppSpacing.statusPillHorizontalPaddingMd;
  static double get statusPillHorizontalPaddingLg => _isTablet
      ? TabletSpacingTokens.statusPillHorizontalPaddingLg
      : AppSpacing.statusPillHorizontalPaddingLg;
  static double get statusPillIconSizeSm => _isTablet
      ? TabletSpacingTokens.statusPillIconSizeSm
      : AppSpacing.statusPillIconSizeSm;
  static double get statusPillIconSizeMd => _isTablet
      ? TabletSpacingTokens.statusPillIconSizeMd
      : AppSpacing.statusPillIconSizeMd;
  static double get statusPillIconSizeLg => _isTablet
      ? TabletSpacingTokens.statusPillIconSizeLg
      : AppSpacing.statusPillIconSizeLg;
  static double get statusPillBadgeOffset => _isTablet
      ? TabletSpacingTokens.statusPillBadgeOffset
      : AppSpacing.statusPillBadgeOffset;
  static double get statusPillBadgeBlur => _isTablet
      ? TabletSpacingTokens.statusPillBadgeBlur
      : AppSpacing.statusPillBadgeBlur;
  static double get statusPillCountPadding => _isTablet
      ? TabletSpacingTokens.statusPillCountPadding
      : AppSpacing.statusPillCountPadding;
  static double get statusPillCountMinWidthFactor => _isTablet
      ? TabletSpacingTokens.statusPillCountMinWidthFactor
      : AppSpacing.statusPillCountMinWidthFactor;
  static double get statusPillCountHeightFactor => _isTablet
      ? TabletSpacingTokens.statusPillCountHeightFactor
      : AppSpacing.statusPillCountHeightFactor;
  static double get serviceTileTopStripeHeight => _isTablet
      ? TabletSpacingTokens.serviceTileTopStripeHeight
      : AppSpacing.serviceTileTopStripeHeight;
  static double get serviceTileContentPadding => _isTablet
      ? TabletSpacingTokens.serviceTileContentPadding
      : AppSpacing.serviceTileContentPadding;
  static double get serviceTileContentPaddingCompact => _isTablet
      ? TabletSpacingTokens.serviceTileContentPaddingCompact
      : AppSpacing.serviceTileContentPaddingCompact;
  static double get serviceTileBadgeOffset => _isTablet
      ? TabletSpacingTokens.serviceTileBadgeOffset
      : AppSpacing.serviceTileBadgeOffset;
  static double get serviceTileBadgeMaxWidth => _isTablet
      ? TabletSpacingTokens.serviceTileBadgeMaxWidth
      : AppSpacing.serviceTileBadgeMaxWidth;
  static double get serviceTileRiskBadgeMaxWidth => _isTablet
      ? TabletSpacingTokens.serviceTileRiskBadgeMaxWidth
      : AppSpacing.serviceTileRiskBadgeMaxWidth;
  static double get serviceTileBadgePaddingHorizontal => _isTablet
      ? TabletSpacingTokens.serviceTileBadgePaddingHorizontal
      : AppSpacing.serviceTileBadgePaddingHorizontal;
  static double get serviceTileBadgePaddingVertical => _isTablet
      ? TabletSpacingTokens.serviceTileBadgePaddingVertical
      : AppSpacing.serviceTileBadgePaddingVertical;
  static double get serviceTileBadgeFont => _isTablet
      ? TabletSpacingTokens.serviceTileBadgeFont
      : AppSpacing.serviceTileBadgeFont;
  static double get serviceTileBadgeReserveVertical => _isTablet
      ? TabletSpacingTokens.serviceTileBadgeReserveVertical
      : AppSpacing.serviceTileBadgeReserveVertical;
  static double get serviceTileBadgeReserveHorizontal => _isTablet
      ? TabletSpacingTokens.serviceTileBadgeReserveHorizontal
      : AppSpacing.serviceTileBadgeReserveHorizontal;
  static double get serviceTileIconContainer => _isTablet
      ? TabletSpacingTokens.serviceTileIconContainer
      : AppSpacing.serviceTileIconContainer;
  static double get serviceTileIconContainerCompact => _isTablet
      ? TabletSpacingTokens.serviceTileIconContainerCompact
      : AppSpacing.serviceTileIconContainerCompact;
  static double get serviceTileIconSize => _isTablet
      ? TabletSpacingTokens.serviceTileIconSize
      : AppSpacing.serviceTileIconSize;
  static double get serviceTileIconSizeCompact => _isTablet
      ? TabletSpacingTokens.serviceTileIconSizeCompact
      : AppSpacing.serviceTileIconSizeCompact;
  static double get serviceTileGridAspectStandard => _isTablet
      ? TabletSpacingTokens.serviceTileGridAspectStandard
      : AppSpacing.serviceTileGridAspectStandard;
  static double get serviceTileGridAspectCompact => _isTablet
      ? TabletSpacingTokens.serviceTileGridAspectCompact
      : AppSpacing.serviceTileGridAspectCompact;
  static double get serviceTileLabelGap => _isTablet
      ? TabletSpacingTokens.serviceTileLabelGap
      : AppSpacing.serviceTileLabelGap;
  static double get serviceTileLabelGapCompact => _isTablet
      ? TabletSpacingTokens.serviceTileLabelGapCompact
      : AppSpacing.serviceTileLabelGapCompact;
  static int get serviceTileCrossAxisCount => _isTablet
      ? TabletSpacingTokens.serviceTileCrossAxisCount
      : AppSpacing.serviceTileCrossAxisCount;
  static double get serviceTileAccentBarThickness => _isTablet
      ? TabletSpacingTokens.serviceTileAccentBarThickness
      : AppSpacing.serviceTileAccentBarThickness;
  static double get serviceTileAccentBarHeight => _isTablet
      ? TabletSpacingTokens.serviceTileAccentBarHeight
      : AppSpacing.serviceTileAccentBarHeight;
  static double get serviceTileSectionBarHeight => _isTablet
      ? TabletSpacingTokens.serviceTileSectionBarHeight
      : AppSpacing.serviceTileSectionBarHeight;
  static double get serviceTileCompactLabelHeight => _isTablet
      ? TabletSpacingTokens.serviceTileCompactLabelHeight
      : AppSpacing.serviceTileCompactLabelHeight;
  static double get inputPrefixIcon => _isTablet
      ? TabletSpacingTokens.inputPrefixIcon
      : AppSpacing.inputPrefixIcon;
  static double get sheetPanelMaxHeightFactor => _isTablet
      ? TabletSpacingTokens.sheetPanelMaxHeightFactor
      : AppSpacing.sheetPanelMaxHeightFactor;
  static double get vitPresetChipRowGap => _isTablet
      ? TabletSpacingTokens.vitPresetChipRowGap
      : AppSpacing.vitPresetChipRowGap;
  static double get vitPresetChipRowHeight => _isTablet
      ? TabletSpacingTokens.vitPresetChipRowHeight
      : AppSpacing.vitPresetChipRowHeight;
  static EdgeInsetsGeometry get vitChoicePillCompactPadding => _isTablet
      ? TabletSpacingTokens.vitChoicePillCompactPadding
      : AppSpacing.vitChoicePillCompactPadding;
  static EdgeInsetsGeometry get vitChoicePillComfortablePadding => _isTablet
      ? TabletSpacingTokens.vitChoicePillComfortablePadding
      : AppSpacing.vitChoicePillComfortablePadding;
  static EdgeInsetsGeometry get vitFilterChipPadding => _isTablet
      ? TabletSpacingTokens.vitFilterChipPadding
      : AppSpacing.vitFilterChipPadding;

  static double get bottomNavHorizontalInset => _isTablet
      ? TabletSpacingTokens.bottomNavHorizontalInset
      : AppSpacing.bottomNavHorizontalInset;
  static double get bottomNavCapsuleHeightNative => _isTablet
      ? TabletSpacingTokens.bottomNavCapsuleHeightNative
      : AppSpacing.bottomNavCapsuleHeightNative;
  static double get bottomNavCapsuleHeightVisual => _isTablet
      ? TabletSpacingTokens.bottomNavCapsuleHeightVisual
      : AppSpacing.bottomNavCapsuleHeightVisual;
  static double get bottomNavBottomGapNative => _isTablet
      ? TabletSpacingTokens.bottomNavBottomGapNative
      : AppSpacing.bottomNavBottomGapNative;
  static double get bottomNavBottomGapVisual => _isTablet
      ? TabletSpacingTokens.bottomNavBottomGapVisual
      : AppSpacing.bottomNavBottomGapVisual;
  static double get bottomNavHorizontalPadCompact => _isTablet
      ? TabletSpacingTokens.bottomNavHorizontalPadCompact
      : AppSpacing.bottomNavHorizontalPadCompact;
  static double get bottomNavHorizontalPad => _isTablet
      ? TabletSpacingTokens.bottomNavHorizontalPad
      : AppSpacing.bottomNavHorizontalPad;
  static double get bottomNavCenterButtonSizeNative => _isTablet
      ? TabletSpacingTokens.bottomNavCenterButtonSizeNative
      : AppSpacing.bottomNavCenterButtonSizeNative;
  static double get bottomNavCenterButtonSizeVisual => _isTablet
      ? TabletSpacingTokens.bottomNavCenterButtonSizeVisual
      : AppSpacing.bottomNavCenterButtonSizeVisual;
  static double get bottomNavCenterButtonTopNative => _isTablet
      ? TabletSpacingTokens.bottomNavCenterButtonTopNative
      : AppSpacing.bottomNavCenterButtonTopNative;
  static double get bottomNavCenterButtonTopVisual => _isTablet
      ? TabletSpacingTokens.bottomNavCenterButtonTopVisual
      : AppSpacing.bottomNavCenterButtonTopVisual;
  static double get bottomNavCenterIconSize => _isTablet
      ? TabletSpacingTokens.bottomNavCenterIconSize
      : AppSpacing.bottomNavCenterIconSize;
  static double get bottomNavItemHeight => _isTablet
      ? TabletSpacingTokens.bottomNavItemHeight
      : AppSpacing.bottomNavItemHeight;
  static double get bottomNavActiveDotOffset => _isTablet
      ? TabletSpacingTokens.bottomNavActiveDotOffset
      : AppSpacing.bottomNavActiveDotOffset;
  static double get bottomNavActiveDotSize => _isTablet
      ? TabletSpacingTokens.bottomNavActiveDotSize
      : AppSpacing.bottomNavActiveDotSize;
  static double get bottomNavLabelGap => _isTablet
      ? TabletSpacingTokens.bottomNavLabelGap
      : AppSpacing.bottomNavLabelGap;
  static double get bottomNavBadgeMinWidth => _isTablet
      ? TabletSpacingTokens.bottomNavBadgeMinWidth
      : AppSpacing.bottomNavBadgeMinWidth;
  static double get bottomNavBadgeHeight => _isTablet
      ? TabletSpacingTokens.bottomNavBadgeHeight
      : AppSpacing.bottomNavBadgeHeight;
  static double get bottomNavBadgeHorizontalPadding => _isTablet
      ? TabletSpacingTokens.bottomNavBadgeHorizontalPadding
      : AppSpacing.bottomNavBadgeHorizontalPadding;
  static double get bottomNavBadgeTopOffset => _isTablet
      ? TabletSpacingTokens.bottomNavBadgeTopOffset
      : AppSpacing.bottomNavBadgeTopOffset;
  static double get bottomNavBadgeRightOffset => _isTablet
      ? TabletSpacingTokens.bottomNavBadgeRightOffset
      : AppSpacing.bottomNavBadgeRightOffset;
  static double get bottomNavBottomOffsetCompact => _isTablet
      ? TabletSpacingTokens.bottomNavBottomOffsetCompact
      : AppSpacing.bottomNavBottomOffsetCompact;
  static double get bottomNavBottomOffsetRegular => _isTablet
      ? TabletSpacingTokens.bottomNavBottomOffsetRegular
      : AppSpacing.bottomNavBottomOffsetRegular;
  static double get bottomNavSurfaceShadowBlur => _isTablet
      ? TabletSpacingTokens.bottomNavSurfaceShadowBlur
      : AppSpacing.bottomNavSurfaceShadowBlur;
  static double get bottomNavSurfaceShadowOffsetY => _isTablet
      ? TabletSpacingTokens.bottomNavSurfaceShadowOffsetY
      : AppSpacing.bottomNavSurfaceShadowOffsetY;
  static double get bottomNavPrimaryShadowBlur => _isTablet
      ? TabletSpacingTokens.bottomNavPrimaryShadowBlur
      : AppSpacing.bottomNavPrimaryShadowBlur;
  static double get bottomNavPrimaryShadowOffsetY => _isTablet
      ? TabletSpacingTokens.bottomNavPrimaryShadowOffsetY
      : AppSpacing.bottomNavPrimaryShadowOffsetY;
  static double get bottomNavCenterGlowBlur => _isTablet
      ? TabletSpacingTokens.bottomNavCenterGlowBlur
      : AppSpacing.bottomNavCenterGlowBlur;
  static double get bottomNavCenterGlowOffsetY => _isTablet
      ? TabletSpacingTokens.bottomNavCenterGlowOffsetY
      : AppSpacing.bottomNavCenterGlowOffsetY;
  static double get bottomNavCenterGlowWeakBlur => _isTablet
      ? TabletSpacingTokens.bottomNavCenterGlowWeakBlur
      : AppSpacing.bottomNavCenterGlowWeakBlur;
  static double get bottomNavActiveDotBlur => _isTablet
      ? TabletSpacingTokens.bottomNavActiveDotBlur
      : AppSpacing.bottomNavActiveDotBlur;

  static double get pageContentTopCompact => _isTablet
      ? TabletSpacingTokens.pageContentTopCompact
      : AppSpacing.pageContentTopCompact;
  static double get pageContentTopDefault => _isTablet
      ? TabletSpacingTokens.pageContentTopDefault
      : AppSpacing.pageContentTopDefault;
  static double get pageContentTopRelaxed => _isTablet
      ? TabletSpacingTokens.pageContentTopRelaxed
      : AppSpacing.pageContentTopRelaxed;
  static double get pageContentGapTight => _isTablet
      ? TabletSpacingTokens.pageContentGapTight
      : AppSpacing.pageContentGapTight;
  static double get pageContentGapDefault => _isTablet
      ? TabletSpacingTokens.pageContentGapDefault
      : AppSpacing.pageContentGapDefault;
  static double get pageContentGapRelaxed => _isTablet
      ? TabletSpacingTokens.pageContentGapRelaxed
      : AppSpacing.pageContentGapRelaxed;
  static double get pageContentGapLoose => _isTablet
      ? TabletSpacingTokens.pageContentGapLoose
      : AppSpacing.pageContentGapLoose;
  static double get pageEndBreathing => _isTablet
      ? TabletSpacingTokens.pageEndBreathing
      : AppSpacing.pageContentGapLoose;

  static double get pageRhythmCompactInnerGap => _isTablet
      ? TabletSpacingTokens.pageRhythmCompactInnerGap
      : AppSpacing.pageRhythmCompactInnerGap;
  static double get pageRhythmFormInnerGap => _isTablet
      ? TabletSpacingTokens.pageRhythmFormInnerGap
      : AppSpacing.pageRhythmFormInnerGap;
  static double get pageRhythmStandardInnerGap => _isTablet
      ? TabletSpacingTokens.pageRhythmStandardInnerGap
      : AppSpacing.pageRhythmStandardInnerGap;
  static double get pageRhythmStandardSectionGap => _isTablet
      ? TabletSpacingTokens.pageRhythmStandardSectionGap
      : AppSpacing.pageRhythmStandardSectionGap;
  static double get pageRhythmFormSectionGap => _isTablet
      ? TabletSpacingTokens.pageRhythmFormSectionGap
      : AppSpacing.pageRhythmFormSectionGap;
  static double get rowGap =>
      _isTablet ? TabletSpacingTokens.rowGap : AppSpacing.rowGap;
  static double get rowGapRegular =>
      _isTablet ? TabletSpacingTokens.rowGapRegular : AppSpacing.rowGapRegular;
  static double get cardGap =>
      _isTablet ? TabletSpacingTokens.cardGap : AppSpacing.cardGap;
  static double get gridGap =>
      _isTablet ? TabletSpacingTokens.gridGap : AppSpacing.gridGap;
  static double get pageSectionAccentHeight => _isTablet
      ? TabletSpacingTokens.pageSectionAccentHeight
      : AppSpacing.pageSectionAccentHeight;
  static double get pageSectionAccentWidth => _isTablet
      ? TabletSpacingTokens.pageSectionAccentWidth
      : AppSpacing.pageSectionAccentWidth;

  static EdgeInsetsGeometry get cardPaddingCompact => _isTablet
      ? TabletSpacingTokens.cardPaddingCompact
      : AppSpacing.cardPaddingCompact;

  static double get tabBarPillVertical =>
      _isTablet ? TabletSpacingTokens.x3 : AppSpacing.tabBarPillVertical;
  static double get tabBarUnderlineHeight => _isTablet
      ? TabletSpacingTokens.hairlineStroke
      : AppSpacing.tabBarUnderlineHeight;
  static double get tabBarUnderlineWidth =>
      _isTablet ? TabletSpacingTokens.x7 / 2 : AppSpacing.tabBarUnderlineWidth;
}
