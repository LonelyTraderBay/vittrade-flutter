import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_section_header.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_notice_sheet.dart';

/// Tablet-only composition boundary for authentication flows.
///
/// The Phone auth pages do not import this file. Domain repositories,
/// controllers and route contracts remain the shared application boundary;
/// this surface owns the two-column/tablet form composition and its rhythm.
class AuthTabletSurface extends StatelessWidget {
  const AuthTabletSurface({
    super.key,
    required this.semanticLabel,
    required this.semanticIdentifier,
    required this.title,
    required this.subtitle,
    required this.child,
    this.onBack,
    this.brandTitle = 'Giao dịch an toàn hơn',
    this.brandDescription =
        'Bảo vệ tài khoản và mọi thao tác quan trọng bằng các lớp xác thực rõ ràng.',
  });

  final String semanticLabel;
  final String semanticIdentifier;
  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback? onBack;
  final String brandTitle;
  final String brandDescription;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      semanticLabel: semanticLabel,
      semanticIdentifier: semanticIdentifier,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.x6,
              AppSpacing.x6,
              AppSpacing.x6,
              AppSpacing.x7,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: VitPageContent(
                  rhythm: VitPageRhythm.form,
                  padding: VitContentPadding.none,
                  fullBleed: true,
                  children: [
                    _AuthTabletColumns(
                      wide: constraints.maxWidth >= 860,
                      brandTitle: brandTitle,
                      brandDescription: brandDescription,
                      form: VitCard(
                        padding: const EdgeInsets.all(AppSpacing.x6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (onBack != null) ...[
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: VitCtaButton(
                                  onPressed: onBack,
                                  fullWidth: false,
                                  height: AppSpacing.buttonCompact,
                                  padding: const EdgeInsetsDirectional.only(
                                    end: AppSpacing.x3,
                                  ),
                                  variant: VitCtaButtonVariant.ghost,
                                  leading: const Icon(Icons.arrow_back_rounded),
                                  child: const Text('Quay lại'),
                                ),
                              ),
                              const SizedBox(
                                height: AppSpacing.pageRhythmStandardSectionGap,
                              ),
                            ],
                            VitSectionHeader(
                              title: title,
                              subtitle: subtitle,
                              variant: VitSectionHeaderVariant.accentBar,
                              bottomGap: AppSpacing.pageRhythmFormInnerGap,
                            ),
                            child,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AuthTabletColumns extends StatelessWidget {
  const _AuthTabletColumns({
    required this.wide,
    required this.brandTitle,
    required this.brandDescription,
    required this.form,
  });

  final bool wide;
  final String brandTitle;
  final String brandDescription;
  final Widget form;

  @override
  Widget build(BuildContext context) {
    final brand = VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: _AuthTabletBrandPanel(
        title: brandTitle,
        description: brandDescription,
      ),
    );

    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          brand,
          const SizedBox(height: AppSpacing.x4),
          form,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: brand),
        const SizedBox(width: AppSpacing.x4),
        Expanded(flex: 7, child: form),
      ],
    );
  }
}

class _AuthTabletBrandPanel extends StatelessWidget {
  const _AuthTabletBrandPanel({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.shield_outlined,
          color: AppColors.onAccent,
          size: AppSpacing.iconLg,
        ),
        const SizedBox(height: AppSpacing.x4),
        const Text('VitTrade', style: AppTextStyles.pageTitle),
        const SizedBox(height: AppSpacing.x4),
        Text(title, style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSpacing.x4),
        Text(
          description,
          style: AppTextStyles.body.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _AuthTabletTrustLine(
          icon: Icons.verified_user_outlined,
          text: 'Xác minh rõ ràng trước khi tiếp tục',
        ),
        const SizedBox(height: AppSpacing.x4),
        const _AuthTabletTrustLine(
          icon: Icons.visibility_off_outlined,
          text: 'Thông tin nhạy cảm luôn được bảo vệ',
        ),
        const SizedBox(height: AppSpacing.x4),
        const _AuthTabletTrustLine(
          icon: Icons.devices_outlined,
          text: 'Tối ưu cho màn hình tablet và bàn phím',
        ),
      ],
    );
  }
}

class _AuthTabletTrustLine extends StatelessWidget {
  const _AuthTabletTrustLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.onAccent, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class AuthTabletErrorBanner extends StatelessWidget {
  const AuthTabletErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitBanner(
      variant: VitBannerVariant.error,
      message: message,
      icon: Icons.error_outline_rounded,
    );
  }
}

class AuthTabletInfoBanner extends StatelessWidget {
  const AuthTabletInfoBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitBanner(
      variant: VitBannerVariant.info,
      message: message,
      icon: Icons.info_outline_rounded,
    );
  }
}
