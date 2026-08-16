import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

final class AuthSpacingTokens {
  const AuthSpacingTokens._();

  static const double authScrollBottomInset = AppSpacing.x6;
  static const EdgeInsets authScrollBottomPadding = EdgeInsets.only(
    bottom: authScrollBottomInset,
  );
  static const double authStandaloneTopInset = 52;
  static const double authStandaloneBottomInset = AppSpacing.x3;
  static const EdgeInsets authStandaloneContentPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    authStandaloneTopInset,
    AppSpacing.contentPad,
    authStandaloneBottomInset,
  );
  static const EdgeInsets authTopGapX1 = EdgeInsets.only(top: AppSpacing.x1);
  static const EdgeInsets authTopGapX2 = EdgeInsets.only(top: AppSpacing.x2);
  static const EdgeInsets authTopGapX3 = EdgeInsets.only(top: AppSpacing.x3);
  static const EdgeInsets authTopGapX4 = EdgeInsets.only(top: AppSpacing.x4);
  static const EdgeInsets authTopGapX5 = EdgeInsets.only(top: AppSpacing.x5);
  static const EdgeInsets authTopGapX6 = EdgeInsets.only(top: AppSpacing.x6);
  @Deprecated('Use AppSpacing.pageRhythmFormSectionGap')
  static const double authPageContentGap = AppSpacing.pageRhythmFormSectionGap;
  static const double authHeroFormGap = 49;
  static const double authFormFooterGap = 52;
  static const EdgeInsets authHeroFormTopPadding = EdgeInsets.only(
    top: authHeroFormGap,
  );
  static const EdgeInsets authFormFooterTopPadding = EdgeInsets.only(
    top: authFormFooterGap,
  );
  static const EdgeInsets authSurfacePadding = EdgeInsets.all(AppSpacing.x4);
  static const EdgeInsets authSurfaceCompactPadding = EdgeInsets.all(
    AppSpacing.x3,
  );
  static const double authLogoBoxSize = 64;
  static const double authLogoMarkSize = 36;
  static const double authLogoElevation = AppSpacing.x3;
  static const double authHeroIconBoxSm = 64;
  static const double authHeroIconBoxMd = 80;
  static const double authStateIconBox = 96;
  static const double authHeroPainterSize = 32;
  static const double authHeroIconMd = AppSpacing.x6;
  static const double authHeroIconLg = 40;
  static const double authStateIconLg = 48;
  static const double authErrorIcon = 14;
  static const double authInlineIcon = 12;
  static const double authInlineIconSm = 10;
  static const double authInlineCheckIcon = 14;
  static const double authSegmentedHeight = 48;
  static const double authSegmentedPaddingValue = 4;
  static const EdgeInsets authSegmentedPadding = EdgeInsets.all(
    authSegmentedPaddingValue,
  );
  static const double authTextButtonHeight = 32;
  static const double authTextButtonHeightLg = 36;
  static const double authInlineTextButtonPadX = 4;
  static const EdgeInsets authInlineTextButtonPadding = EdgeInsets.symmetric(
    horizontal: authInlineTextButtonPadX,
  );
  static const EdgeInsets authDividerLabelPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.x4,
  );
  static const EdgeInsets authErrorBannerPaddingSm = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );
  static const EdgeInsets authErrorBannerPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const double authAgreementCheckSize = 20;
  static const double authAgreementCheckTop = 2;
  static const EdgeInsets authAgreementCheckMargin = EdgeInsets.only(
    top: authAgreementCheckTop,
  );
  static const double authAgreementCheckBorder = 1.3;
  static const double authPasswordStrengthHeight = 4;
  static const double authPasswordStrengthIcon = 11;
  static const double authOtpBoxSize = 48;
  static const double authOtpBoxHeight = 56;
  static const double authOtpDigitGap = 12;
  static const EdgeInsets authOtpDigitTopPadding = EdgeInsets.only(
    top: authOtpDigitGap,
  );
  static const double authOtpProgressHeight = 2;
  static const double authInputTopGap = 17;
  static const EdgeInsets authInputTopPadding = EdgeInsets.only(
    top: authInputTopGap,
  );
  static const double authCompactVerticalGap = 6;
  static const EdgeInsets authCompactTopPadding = EdgeInsets.only(
    top: authCompactVerticalGap,
  );
  static const EdgeInsets authStateVerticalPadding = EdgeInsets.symmetric(
    vertical: AppSpacing.x6,
  );
  static const double authTextLetterSpacing = AppSpacing.x3;
  static const double authReadableLineHeight = 1.6;
  static const double authAgreementLineHeight = 1.45;
  static const double authFooterLineHeight = 1.5;
  static const double authTwoFaContentGap = AppSpacing.contentPad;
  static const double authTwoFaStepperTop = 16;
  static const double authTwoFaStepperBottom = 12;
  static const EdgeInsets authTwoFaStepperPadding = EdgeInsets.fromLTRB(
    AppSpacing.contentPad,
    authTwoFaStepperTop,
    AppSpacing.contentPad,
    authTwoFaStepperBottom,
  );
  static const EdgeInsets authTwoFaProgressMargin = EdgeInsets.symmetric(
    horizontal: AppSpacing.x3,
  );
  static const double authTwoFaStepDotSize = 32;
  static const double authTwoFaStepIcon = 17;
  static const double authTwoFaHeroTopGap = 18;
  static const EdgeInsets authTwoFaHeroTopPadding = EdgeInsets.only(
    top: authTwoFaHeroTopGap,
  );
  static const double authTwoFaQrTopGap = 22;
  static const EdgeInsets authTwoFaQrTopPadding = EdgeInsets.only(
    top: authTwoFaQrTopGap,
  );
  static const double authTwoFaSectionTopGap = AppSpacing.contentPad;
  static const EdgeInsets authTwoFaSectionTopPadding = EdgeInsets.only(
    top: authTwoFaSectionTopGap,
  );
  static const double authTwoFaBackupActionTopGap = 16;
  static const EdgeInsets authTwoFaBackupActionTopPadding = EdgeInsets.only(
    top: authTwoFaBackupActionTopGap,
  );
  static const double authTwoFaQrSize = 192;
  static const double authTwoFaCardPaddingValue = 16;
  static const EdgeInsets authTwoFaQrPadding = EdgeInsets.all(
    authTwoFaCardPaddingValue,
  );
  static const EdgeInsets authTwoFaSecretPadding = EdgeInsets.fromLTRB(
    authTwoFaCardPaddingValue,
    AppSpacing.rowPy,
    authTwoFaCardPaddingValue,
    authTwoFaCardPaddingValue,
  );
  static const double authTwoFaCopyIcon = 15;
  static const EdgeInsets authTwoFaCopyButtonPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double authTwoFaWarningIcon = 16;
  static const EdgeInsets authTwoFaBannerPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  );
  static const double authTwoFaBackupIndexSize = 24;
  static const double authTwoFaBackupCheckSize = 22;
  static const double authTwoFaBackupCheckTop = 1;
  static const EdgeInsets authTwoFaBackupCheckMargin = EdgeInsets.only(
    top: authTwoFaBackupCheckTop,
  );
  static const double authTwoFaBackupCheckBorder = 1.4;
  static const double authTwoFaBackupCheckIcon = 15;
  static const double authTwoFaVerifyCodeTopGap = 28;
  static const EdgeInsets authTwoFaVerifyCodeTopPadding = EdgeInsets.only(
    top: authTwoFaVerifyCodeTopGap,
  );
  static const double authTwoFaCodeDigitGap = 10;
  static const double authTwoFaHiddenInputSize = AppSpacing.dividerHairline;
  static const double authTwoFaCodeDigitWidth = 44;
  static const double authTwoFaCodeDigitHeight = 56;
}
