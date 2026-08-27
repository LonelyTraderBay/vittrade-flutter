import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

final class ProfileSpacingTokens {
  const ProfileSpacingTokens._();

  static const double profileBottomInsetVisual = 92;
  static const double profileBottomInsetNative = 28;
  static EdgeInsets profileScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double profileHeroToVipGap = 24;
  static const double profileVipToSectionGap = 26;
  static const double profileSectionLabelGap = 11;
  static const double profilePredictionToArenaGap = 14;
  static const double profileSectionGap = 25;
  static const double profileActivityGap = 28;
  static const double profileFooterGap = 38;
  static const double profileHeroHeight = 216;
  static const EdgeInsets profileHeroPadding = EdgeInsets.all(16);
  static const double profileHeroAvatar = 58;
  static const double profileHeroTextGap = AppSpacing.x3;
  static const double profileHeroEmailGap = 12;
  static const double profileHeroPillGap = AppSpacing.x3;
  static const double profileHeroPillRunGap = 6;
  static const double profileEditButton = 40;
  static const double profileEditIcon = AppSpacing.iconMd;
  static const double profileHeroInfoGap = 12;
  static const EdgeInsets profileHeroPillPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 6,
  );
  static const double profileHeroInfoHeight = 66;
  static const EdgeInsets profileHeroInfoPadding = EdgeInsets.fromLTRB(
    14,
    13,
    14,
    12,
  );
  static const double profileHeroInfoTrailingGap = 6;
  static const double profileProductGridGap = 10;
  static const double profileProductTileHeight = 74;
  static const EdgeInsets profileProductTilePadding = EdgeInsets.all(12);
  static const double profileProductIconBox = AppSpacing.x6;
  static const double profileProductIcon = 19;
  static const double profileProductGap = 10;
  static const double profileProductLabelGap = 7;
  static const double profileMenuRowHeight = 62;
  static const EdgeInsets profileMenuRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const double profileMenuIconBox = 36;
  static const double profileMenuIcon = 20;
  static const double profileMenuGap = 14;
  static const double profileMenuSubtitleGap = AppSpacing.x3;
  static const double profileMenuChevron = 20;

  /// Tablet master menu overrides (2026-08-27 spacing review) — the shared
  /// phone tokens above stay untouched per R2. The tablet menu's icon box
  /// slims 36 → 32 (glyph 20 → 18) so the 13px labels lead the row's visual
  /// weight (financial info first, decoration second), and the group gap
  /// between the master menu's business sections widens from the compact
  /// rhythm's 8 to 16 — one deliberate rhythm break so the eye can
  /// partition Tài khoản / Bảo mật / Portfolio at a glance while keeping
  /// the financial-app density (reference platforms use 24-35).
  static const double profileMenuTabletIconBox = 32;
  static const double profileMenuTabletIcon = 18;
  static const double profileMenuSectionGap = 16;
  static const double profileActivityButtonHeight = 44;
  static const double profileLogoutButtonHeight = 54;
  static const double profileLogoutIcon = AppSpacing.iconMd;
  static const double profileLogoutGap = 10;
  static const double profileSectionAccentWidth = 4;
  static const double profileSectionAccentHeight = 15;
  static const double profileSectionAccentGap = 7;
  static const double profileModuleCardHeight = 137;
  static const double profileVipCardHeight = 92;
  static const EdgeInsets profileModuleCardPadding = EdgeInsets.all(16);
  static const double profileModuleIcon = 15;
  static const double profileModuleGap = AppSpacing.x3;
  static const double profileModuleStatGap = 12;
  static const double profileModuleLinkIcon = 14;
  static const double profileModuleEndGap = 20;
  static const EdgeInsets profileTinyTagPadding = EdgeInsets.symmetric(
    horizontal: 9,
    vertical: 5,
  );
  static const double profileVipProgressGap = 12;
  static const double profileVipProgressHeight = AppSpacing.x3;
  static const double profileEditBottomInsetVisual = 42;
  static const double profileEditBottomInsetNative = 24;
  static const double profileEditScrollTop = 36;
  static EdgeInsets profileEditScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        profileEditScrollTop,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double profileEditAvatarFormGap = 52;
  static const double profileEditFieldGap = 18;
  static const double profileEditRiskGap = 14;
  static const double profileEditAvatarSize = 96;
  static const double profileEditCameraOffsetEnd = -1;
  static const double profileEditCameraOffsetBottom = 1;
  static const double profileEditAvatarCaptionGap = 10;
  static const EdgeInsets profileEditActionPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const double profileEditFieldLabelGap = 10;
  static const double profileEditFieldNoteGap = 7;
  static const double profileEditAvatarCaptionLineHeight = 1.1;
  static const double profileEditTightLineHeight = 1;
  static const double settingsBottomInsetVisual = 124;
  static const double settingsBottomInsetNative = 32;
  static EdgeInsets settingsScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        14,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double settingsSectionTitleGap = AppSpacing.x3;
  static const double settingsCurrencyToLanguageGap = 27;
  static const double settingsSectionGap = 28;
  static const double settingsNotificationsToInfoGap = 26;
  static const double settingsCurrencyCardHeight = 92;
  static const EdgeInsets settingsCurrencyCardPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    15,
  );
  static const double settingsCurrencyIcon = AppSpacing.x5;
  static const double settingsCurrencyIconGap = 16;
  static const double settingsCurrencyTitleGap = 12;
  static const double settingsCurrencyChipGap = AppSpacing.x2;
  static const double settingsCurrencyChipHeight = 24;
  static const double settingsCurrencyChipMinWidth = 48;
  static const EdgeInsets settingsCurrencyChipPadding = EdgeInsets.symmetric(
    horizontal: 13,
  );
  static const double settingsLanguageRowHeight = 54;
  static const EdgeInsets settingsLanguageRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const double settingsLanguageSelectedDot = 10;
  static const double settingsTradeSecurityRowHeight = 72;
  static const double settingsNotificationRowHeight = 68;
  static const EdgeInsets settingsRowPaddingWithIcon = EdgeInsets.fromLTRB(
    16,
    0,
    16,
    0,
  );
  static const EdgeInsets settingsRowPaddingNoIcon = EdgeInsets.fromLTRB(
    20,
    0,
    16,
    0,
  );
  static const double settingsRowIcon = 20;
  static const double settingsRowIconGap = 16;
  static const double settingsRowSubtitleGap = AppSpacing.x2;
  static const double settingsRowSwitchGap = 12;
  static const double settingsSwitchWidth = 48;
  static const double settingsSwitchHeight = 28;
  static const double settingsSwitchKnob = 22;
  static const EdgeInsets settingsSwitchKnobMargin = EdgeInsets.all(3);
  static const double settingsAppInfoHeight = 172;
  static const EdgeInsets settingsAppInfoPadding = EdgeInsets.fromLTRB(
    16,
    18,
    16,
    14,
  );
  static const double settingsAppInfoTitleGap = 10;
  static const double settingsAppInfoRowHeight = 36;
  static const double settingsAppInfoValueGap = 16;
  static const double securityBottomInsetVisual = 58;
  static const double securityBottomInsetNative = 24;
  static EdgeInsets securityScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        14,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double securityContentGap = 18;
  static const double securityScoreHeight = 140;
  static const EdgeInsets securityCardPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    16,
  );
  static const double securityScoreBarsGap = 17;
  static const double securityScoreBarHeight = 7;
  static const double securityScoreBarGap = AppSpacing.x3;
  static const double securityScoreAlertGap = AppSpacing.x4;
  static const double securityScoreAlertHeight = 53;
  static const EdgeInsets securityScoreAlertPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
    vertical: 10,
  );
  static const double securitySmallIcon = 14;
  static const double securityIconGap = AppSpacing.x3;
  static const double securityRowHeight = 76;
  static const EdgeInsets securityRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const double securityRowIconBox = 40;
  static const double securityRowIcon = AppSpacing.iconMd;
  static const double securityRowGap = 16;
  static const double securityRowSubtitleGap = AppSpacing.x3;
  static const double securityStatusGap = AppSpacing.x3;
  static const double securityChevronGap = 11;
  static const double securityChevron = 19;
  static const EdgeInsets securityStatusPillPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
    vertical: 6,
  );
  static const double securityDeviceHeaderGap = AppSpacing.x3;
  static const double securityDeviceMinHeight = 73;
  static const EdgeInsets securityDevicePadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: AppSpacing.x4,
  );
  static const double securityDeviceIcon = 20;
  static const double securityDeviceGap = 12;
  static const double securityDeviceNameGap = 7;
  static const double securityDeviceMetaGap = 6;
  static const double securityAntiPhishingHeight =
      AppSpacing.buttonHero + AppSpacing.inputHeight;
  static const double securityAntiPhishingIcon = 18;
  static const double securityAntiPhishingTitleGap = 7;
  static const double securityAntiPhishingInputGap = 14;
  static const double securitySaveButtonWidth = 58;
  static const double securitySaveButtonHeight = 32;
  static const double securitySupportHeight = 68;
  static const EdgeInsets securitySupportPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const double securitySupportIconBox = 38;
  static const double securitySupportIcon = 20;
  static const double securitySupportGap = 14;
  static const double securitySupportTextGap = AppSpacing.x3;
  static const double kycBottomInsetVisual = 120;
  static const double kycBottomInsetNative = 32;
  static EdgeInsets kycScrollPadding(double bottomInset) => EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    31,
    AppSpacing.contentPad,
    bottomInset,
  );
  static const double kycStatusToReviewGap = 18;
  static const double kycReviewToLevelsGap = 33;
  static const double kycLevelGap = 25;
  static const double kycPrivacyGap = 29;
  static const double kycStatusHeight = 81;
  static const EdgeInsets kycStatusPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const double kycStatusIconBox = 48;
  static const double kycStatusIcon = 25;
  static const double kycStatusGap = 14;
  static const double kycStatusTextGap = AppSpacing.x3;
  static const double kycStatusCheckGap = 4;
  static const double kycStatusCheckIcon = 14;
  static const double kycLevelRowHeight = 73;
  static const EdgeInsets kycLevelRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );
  static const double kycLevelRowGap = 16;
  static const double kycLevelChevron = 19;
  static const EdgeInsets kycLevelDetailsPadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    16,
  );
  static const double kycLevelDetailsGap = 14;
  static const double kycLevelIconBox = 40;
  static const double kycLevelIconBorder = AppSpacing.hairlineStroke;
  static const double kycLevelDoneIcon = 24;
  static const double kycDetailTitleGap = AppSpacing.x3;
  static const double kycDetailIcon = 12;
  static const double kycDetailIconGap = AppSpacing.x3;
  static const double kycDetailLineGap = 6;
  static const double kycPrivacyHeight = 95;
  static const EdgeInsets kycPrivacyPadding = EdgeInsets.fromLTRB(
    16,
    15,
    16,
    14,
  );
  static const double kycPrivacyIcon = 15;
  static const double kycPrivacyGapHorizontal = AppSpacing.x3;
  static const double kycPrivacyTitleGap = 10;
  static const double profileApiBottomInsetVisual = 126;
  static const double profileApiBottomInsetNative = 32;
  static EdgeInsets profileApiScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        14,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double profileApiContentGap = 18;
  static const double profileApiCardGap = 18;
  static const EdgeInsets profileApiKeyCardPadding = EdgeInsets.all(16);
  static const double profileApiKeySecretGap = 12;
  static const double profileApiSecretRowsGap = AppSpacing.x2;
  static const double profileApiPermissionGap = 12;
  static const double profileApiUsageGap = AppSpacing.x4;
  static const double profileApiActionsGapTop = 14;
  static const double profileApiActionGap = 10;
  static const double profileApiIconBox = 40;
  static const double profileApiIcon = 19;
  static const double profileApiHeaderGap = 12;
  static const double profileApiTitleStatusGap = 7;
  static const double profileApiMetaGap = AppSpacing.x1;
  static const double profileApiToggleWidth = 27;
  static const double profileApiToggleHeight = 16;
  static const double profileApiToggleKnob = 6;
  static const EdgeInsets profileApiToggleKnobMargin = EdgeInsets.all(2);
  static const double profileApiSecretRowHeight = 32;
  static const double profileApiSecretLabelWidth = 48;
  static const double profileApiSecretTrailingGap = AppSpacing.x2;
  static const EdgeInsets profileApiSecretPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double profileApiIconAction = 14;
  static const double profileApiPermissionSpacing = 6;
  static const double profileApiPermissionRunSpacing = 6;
  static const double profileApiSmallBadgeHeight = 26;
  static const EdgeInsets profileApiSmallBadgePadding = EdgeInsets.symmetric(
    horizontal: 9,
  );
  static const double profileApiSmallBadgeIcon = 12;
  static const double profileApiSmallBadgeIconGap = AppSpacing.x1;
  static const double profileApiUsageIcon = 11;
  static const double profileApiUsageGapInline = AppSpacing.x1;
  static const double profileApiActionHeight = 36;
  static const double profileApiDeleteIcon = 17;
  static const double profileApiDocsHeight = 96;
  static const EdgeInsets profileApiDocsPadding = EdgeInsets.fromLTRB(
    16,
    16,
    14,
    16,
  );
  static const double profileApiDocsIconBox = 40;
  static const double profileApiDocsIcon = AppSpacing.iconMd;
  static const double profileApiDocsGap = 12;
  static const double profileApiDocsTitleGap = AppSpacing.x2;
  static const double profileApiDocsChevron = 18;
  static const double profileApiCreateBottomInsetVisual = 120;
  static const double profileApiCreateBottomInsetNative = 32;
  static EdgeInsets profileApiCreateScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        17,
        AppSpacing.contentPad,
        bottomInset,
      );
  static EdgeInsets profileApiCreateStepScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        28,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double profileApiCreateContentGap = 24;
  static const double profileApiCreateStepGap = 18;
  static const double profileApiCreateFieldGap = 10;
  static const double profileApiCreateHintGap = AppSpacing.x2;
  static const double profileApiCreatePermissionGap = 12;
  static const double profileApiCreatePermissionHeight = 73;
  static const EdgeInsets profileApiCreatePermissionPadding =
      EdgeInsets.fromLTRB(16, 13, 16, 13);
  static const double profileApiCreatePermissionIconBox = 40;
  static const double profileApiCreatePermissionIcon = 18;
  static const double profileApiCreatePermissionIconGap = AppSpacing.x4;
  static const double profileApiCreatePermissionDescriptionGap = AppSpacing.x2;
  static const double profileApiCreatePermissionTrailingGap = 10;
  static const double profileApiCreatePermissionCheck = 24;
  static const double profileApiCreatePermissionCheckIcon = 15;
  static const double profileApiCreatePermissionCheckBorder =
      AppSpacing.hairlineStroke;
  static const double profileApiCreateIpInputGap = AppSpacing.x2;
  static const double profileApiCreateIpAddWidth = 56;
  static const double profileApiCreateIpAddIcon = AppSpacing.iconMd + 1;
  static const double profileApiCreateIpWarningGap = AppSpacing.x2;
  static const double profileApiCreateIpListGap = 10;
  static const double profileApiCreateIpChipGap = 6;
  static const EdgeInsets profileApiCreateIpChipPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 7,
  );
  static const int profileApiCreateExpiryCrossAxisCount = 2;
  static const double profileApiCreateExpirySpacing = AppSpacing.x2;
  static const double profileApiCreateExpiryExtent = 62;
  static const EdgeInsets profileApiCreateExpiryPadding = EdgeInsets.fromLTRB(
    13,
    10,
    13,
    9,
  );
  static const double profileApiCreateExpiryDescriptionGap = AppSpacing.x2;
  static const double profileApiCreateTipsHeight = 160;
  static const EdgeInsets profileApiCreateTipsPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    16,
  );
  static const double profileApiCreateTipsIcon = 15;
  static const double profileApiCreateTipsTitleGap = AppSpacing.x2;
  static const double profileApiCreateTipsListGap = 14;
  static const double profileApiCreateTipsBullet = 16;
  static const double profileApiCreateTipsBulletGap = 9;
  static const double profileApiCreateTipsItemGap = 9;
  static const double profileApiCreateSuccessIconBox = 80;
  static const double profileApiCreateSuccessIcon = 42;
  static const double profileApiCreateSuccessTitleGap = 14;
  static const EdgeInsets profileApiCreateSummaryPadding = EdgeInsets.all(16);
  static const double profileApiCreateSummaryDivider = 18;
  static const EdgeInsets profileApiCreateWarningPadding = EdgeInsets.all(14);
  static const double profileApiCreateWarningIcon = 17;
  static const double profileApiCreateWarningGap = 10;
  static const EdgeInsets profileApiCreateResultCardPadding = EdgeInsets.all(
    16,
  );
  static const double profileApiCreateResultValueGap = AppSpacing.x2;
  static const double profileActivityBottomInsetVisual = 126;
  static const double profileActivityBottomInsetNative = 32;
  static EdgeInsets profileActivityScrollPadding(double bottomInset) =>
      EdgeInsets.only(bottom: bottomInset);
  static const EdgeInsets profileActivityListPadding = EdgeInsets.fromLTRB(
    20,
    32,
    20,
    37,
  );
  static const double profileActivityCardGap = AppSpacing.x4;
  static const double profileActivityFilterHeight = 148;
  static const EdgeInsets profileActivityFilterPadding = EdgeInsets.fromLTRB(
    20,
    25,
    20,
    13,
  );
  static const double profileActivitySuspiciousHeight = 64;
  static const EdgeInsets profileActivitySuspiciousPadding =
      EdgeInsets.fromLTRB(12, 10, 12, 10);
  static const double profileActivityFilterGap = AppSpacing.x4;
  static const double profileActivityFilterRailHeight = 30;
  static const double profileActivityFilterChipGap = 12;
  static const double profileActivityFilterChipHeight = 30;
  static const EdgeInsets profileActivityFilterChipPadding =
      EdgeInsets.symmetric(horizontal: 13);
  static const double profileActivityBannerIcon = 17;
  static const double profileActivityBannerIconGap = 9;
  static const double profileActivityBannerTitleGap = AppSpacing.x2;
  static const double profileActivityCardHeight = 226;
  static const EdgeInsets profileActivityCardPadding = EdgeInsets.fromLTRB(
    16,
    13,
    16,
    12,
  );
  static const double profileActivityIconBox = 40;
  static const double profileActivityIcon = 19;
  static const double profileActivityIconGap = 12;
  static const double profileActivityTitleStatusGap = AppSpacing.x2;
  static const double profileActivityDescriptionGap = AppSpacing.x2;
  static const double profileActivityWarningGap = AppSpacing.x2;
  static const double profileActivityWarningIcon = 17;
  static const double profileActivityDetailsGap = AppSpacing.x4;
  static const double profileActivityDividerTopGap = AppSpacing.x2;
  static const double profileActivityDividerBottomGap = 11;
  static const double profileActivityDetailsHeight = 108;
  static const EdgeInsets profileActivityDetailsPadding = EdgeInsets.fromLTRB(
    13,
    12,
    13,
    12,
  );
  static const double profileActivityDetailsColumnGap = 16;
  static const double profileActivityDetailsRowGap = 14;
  static const double profileActivityDetailIcon = 12;
  static const double profileActivityDetailIconGap = AppSpacing.x2;
  static const double profileActivityDetailValueGap = AppSpacing.x2;
  static const double profileActivityStatusHeight = 22;
  static const EdgeInsets profileActivityStatusPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x2,
  );
  static const double profileActivityFooterHeight = 64;
  static const EdgeInsets profileActivityFooterPadding = EdgeInsets.fromLTRB(
    20,
    12,
    20,
    12,
  );
  static const double profileActivityFooterIcon = 14;
  static const double profileActivityFooterGap = AppSpacing.x2;
  static const double profileSubAccountBottomInsetVisual = 126;
  static const double profileSubAccountBottomInsetNative = 32;
  static EdgeInsets profileSubAccountScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        14,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double profileSubAccountSummaryRiskGap = 18;
  static const double profileSubAccountRiskCreateGap = 26;
  static const double profileSubAccountCreateFormGap = AppSpacing.x4;
  static const double profileSubAccountAccountsHeaderGap = 24;
  static const double profileSubAccountAccountsListGap = 10;
  static const double profileSubAccountCardGap = AppSpacing.x4;
  static const double profileSubAccountInfoNoteGap = 25;
  static const EdgeInsets profileSubAccountSummaryPadding = EdgeInsets.all(20);
  static const double profileSubAccountSummaryIcon = 18;
  static const double profileSubAccountSummaryIconGap = 10;
  static const double profileSubAccountSummaryBalanceGap = 17;
  static const double profileSubAccountSummaryPnlGap = 14;
  static const double profileSubAccountSummaryMetricTopGap = 20;
  static const double profileSubAccountSummaryMetricGap = 12;
  static const double profileSubAccountSummaryMetricHeight = 68;
  static const EdgeInsets profileSubAccountSummaryMetricPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 10);
  static const double profileSubAccountSummaryMetricValueGap = AppSpacing.x3;
  static const EdgeInsets profileSubAccountCardTapPadding = EdgeInsets.all(16);
  static const double profileSubAccountAvatarSize = 45;
  static const double profileSubAccountAvatarGap = AppSpacing.x4;
  static const double profileSubAccountTitlePillGap = 7;
  static const double profileSubAccountStatusTopGap = 9;
  static const double profileSubAccountStatusIcon = 12;
  static const double profileSubAccountStatusIconGap = AppSpacing.x2;
  static const double profileSubAccountStatusMetaGap = 6;
  static const double profileSubAccountTrailingGap = 10;
  static const double profileSubAccountTrailingPnlGap = AppSpacing.x3;
  static const EdgeInsets profileSubAccountCreatePadding = EdgeInsets.all(16);
  static const double profileSubAccountCreateTitleGap = 14;
  static const double profileSubAccountCreateSectionGap = 12;
  static const double profileSubAccountCreateCtaGap = 14;
  static const double profileSubAccountFormLabelGap = 7;
  static const double profileSubAccountFormPillLabelGap = AppSpacing.x3;
  static const double profileSubAccountFormPillGap = AppSpacing.x3;
  static const EdgeInsets profileSubAccountFormInputPadding =
      EdgeInsets.symmetric(horizontal: 14);
  static const EdgeInsets profileSubAccountDetailsPadding = EdgeInsets.fromLTRB(
    16,
    0,
    16,
    16,
  );
  static const double profileSubAccountDetailsDividerHeight =
      AppSpacing.dividerHairline;
  static const double profileSubAccountDetailsTopGap = 14;
  static const double profileSubAccountDetailsMetricGap = AppSpacing.x4;
  static const double profileSubAccountDetailLabelGap = 7;
  static const double profileSubAccountPermissionLabelGap = AppSpacing.x3;
  static const double profileSubAccountPermissionGap = 7;
  static const double profileSubAccountEmailGap = AppSpacing.x4;
  static const double profileSubAccountActionsGap = AppSpacing.x4;
  static const double profileSubAccountActionGap = AppSpacing.x3;
  static const double profileSubAccountActionHeight = 36;
  static const double profileSubAccountActionIcon = 14;
  static const double profileSubAccountActionIconGap = AppSpacing.x2;
  static const EdgeInsets profileSubAccountInfoNotePadding =
      EdgeInsets.fromLTRB(14, 13, 14, 13);
  static const double profileSubAccountInfoNoteIcon = 16;
  static const double profileSubAccountInfoNoteGapInline = 9;
  static const double profileVipBottomInsetVisual = 110;
  static const double profileVipBottomInsetNative = 30;
  static const double profileVipContentGap = AppSpacing.x5;
  static const double profileVipHeroHeight = 186;
  static const EdgeInsets profileVipHeroPadding = EdgeInsets.all(
    AppSpacing.contentPad,
  );
  static const double profileVipHeroBadgeIcon = 16;
  static const double profileVipHeroTitleGap = AppSpacing.x2;
  static const double profileVipHeroMemberGap = AppSpacing.x3;
  static const double profileVipHeroStatusGap = AppSpacing.x3;
  static const EdgeInsets profileVipFeePadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x4,
  );
  static const double profileVipFeeValueGap = AppSpacing.x3;
  static const EdgeInsets profileVipTabsPadding = EdgeInsets.all(AppSpacing.x2);
  static const EdgeInsets profileVipProgressPadding = EdgeInsets.all(16);
  static const double profileVipProgressTitleGap = 16;
  static const double profileVipProgressLineGap = 17;
  static const double profileVipProgressBarGap = AppSpacing.x3;
  static const double profileVipProgressBarHeight = 10;
  static const EdgeInsets profileVipTableTitlePadding = EdgeInsets.fromLTRB(
    16,
    16,
    16,
    14,
  );
  static const double profileVipTableDividerHeight = AppSpacing.dividerHairline;
  static const EdgeInsets profileVipTableHeaderPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  );
  static const EdgeInsets profileVipTableRowPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );
  static const double profileVipTierNameGap = AppSpacing.x3;
  static const double profileVipActiveDotGap = AppSpacing.x2;
  static const double profileVipActiveDot = 6;
  static const EdgeInsets profileVipSavingsPadding = EdgeInsets.all(16);
  static const double profileVipSavingsIcon = 17;
  static const double profileVipSavingsIconGap = AppSpacing.x3;
  static const double profileVipSavingsBoxGap = AppSpacing.x4;
  static const EdgeInsets profileVipSavingBoxPadding = EdgeInsets.all(
    AppSpacing.x4,
  );
  static const double profileVipSavingBoxValueGap = AppSpacing.x3;
  static const double profileVipBenefitCardGap = AppSpacing.x4;
  static const EdgeInsets profileVipBenefitHeaderPadding = EdgeInsets.all(16);
  static const EdgeInsets profileVipBenefitBodyPadding = EdgeInsets.all(16);
  static const double profileVipBenefitIconGap = AppSpacing.x4;
  static const double profileVipBenefitTitleGap = AppSpacing.x3;
  static const double profileVipBenefitStateIcon = 19;
  static const double profileVipBenefitFeatureGap = AppSpacing.x3;
  static const double profileVipBenefitFeatureIconBox = 18;
  static const double profileVipBenefitFeatureIcon = 11;
  static const double profileVipBenefitFeatureIconGap = AppSpacing.x3;
  static const double profileVipBenefitMetricsGap = AppSpacing.x4;
  static const double profileVipBenefitMetricColumnGap = AppSpacing.x5;
  static const double profileVipBenefitMetricValueGap = AppSpacing.x2;
  static const EdgeInsets profileVipUpgradePadding = EdgeInsets.all(16);
  static const double profileVipUpgradeIconBox = 40;
  static const double profileVipUpgradeIcon = AppSpacing.iconMd;
  static const double profileVipUpgradeIconGap = AppSpacing.x4;
  static const double profileVipUpgradeTextGap = AppSpacing.x3;
  static const double profileVipUpgradeCtaGap = AppSpacing.x3;
  static const EdgeInsets profileVipUpgradeCtaPadding = EdgeInsets.symmetric(
    horizontal: 13,
  );
  static const double profileVipTierIconLarge = 56;
  static const double profileVipTierIconSmall = 18;
  static const double profileVipTierIconGlyphLarge = 29;
  static const double profileVipTierIconGlyphSmall = 14;
  static const EdgeInsets profileVipHistoryCardPadding = EdgeInsets.all(16);
  static const double profileDevicesBottomInsetVisual = 126;
  static const double profileDevicesBottomInsetNative = 32;
  static EdgeInsets profileDevicesScrollPadding(double bottomInset) =>
      EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        14,
        AppSpacing.contentPad,
        bottomInset,
      );
  static const double profileDevicesSummaryGap = 18;
  static const double profileDevicesRiskGap = 27;
  static const double profileDevicesCurrentHeaderGap = 10;
  static const double profileDevicesOtherHeaderGap = 26;
  static const double profileDevicesOtherListGap = 10;
  static const double profileDevicesCardGap = AppSpacing.x4;
  static const double profileDevicesFooterSummaryGap = 27;
  static const EdgeInsets profileDevicesSummaryPadding = EdgeInsets.fromLTRB(
    16,
    17,
    16,
    16,
  );
  static const double profileDevicesSummaryIconBox = 44;
  static const double profileDevicesSummaryIcon = 23;
  static const double profileDevicesSummaryGapInline = 12;
  static const double profileDevicesSummaryTitleGap = 7;
  static const double profileDevicesSummaryStatsGapTop = 16;
  static const double profileDevicesSummaryStatGap = 12;
  static const double profileDevicesSummaryStatHeight = 58;
  static const EdgeInsets profileDevicesSummaryStatPadding =
      EdgeInsets.fromLTRB(12, 10, 8, 8);
  static const EdgeInsets profileDevicesCardPadding = EdgeInsets.all(16);
  static const double profileDevicesIconBox = 44;
  static const double profileDevicesIcon = AppSpacing.iconMd;
  static const double profileDevicesIconGap = 12;
  static const double profileDevicesActionTopGap = 14;
  static const double profileDevicesActionDividerGap = AppSpacing.x4;
  static const double profileDevicesActionGap = 9;
  static const EdgeInsets profileDevicesLogoutButtonPadding =
      EdgeInsets.symmetric(horizontal: 14);
  static const double profileDevicesActionIcon = 15;
  static const double profileDevicesTrustIcon = 14;
  static const double profileDevicesMetaIcon = 12;
  static const double profileDevicesMetaIconGap = AppSpacing.x1;
  static const double profileDevicesNamePillGap = AppSpacing.x2;
  static const double profileDevicesWarningIcon = 15;
  static const double profileDevicesBrowserGap = 7;
  static const double profileDevicesMetaGap = AppSpacing.x2;
  static const double profileDevicesMetaSpacing = 11;
  static const double profileDevicesMetaRunSpacing = AppSpacing.x2;
  static const double profileDevicesIpGap = 7;
}
