import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/profile/presentation/tablet/widgets/profile_tablet_utility_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for Profile, Security and KYC sub-flows.
class ProfileTabletUtilityPage extends StatelessWidget {
  const ProfileTabletUtilityPage({
    super.key,
    required this.semanticIdentifier,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.facts,
    this.actionLabel,
    this.requiresConfirmation = false,
    this.confirmationTitle,
  });

  final String semanticIdentifier;
  final String title;
  final String subtitle;
  final String description;
  final List<ProfileTabletFact> facts;
  final String? actionLabel;
  final bool requiresConfirmation;
  final String? confirmationTitle;

  Key get contentKey => Key('$semanticIdentifier-tablet-content');
  Key get actionKey => Key('$semanticIdentifier-tablet-action');
  Key get cancelKey => Key('$semanticIdentifier-tablet-cancel');
  Key get confirmKey => Key('$semanticIdentifier-tablet-confirm');

  @override
  Widget build(BuildContext context) {
    return ProfileTabletUtilitySurface(
      title: title,
      subtitle: subtitle,
      semanticIdentifier: '$semanticIdentifier-TABLET',
      semanticLabel: '$title trên tablet',
      contentKey: contentKey,
      onBack: () => context.go(AppRoutePaths.profile),
      children: [
        VitCard(
          variant: VitCardVariant.hero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.manage_accounts_outlined,
                color: AppColors.primary,
                size: AppSpacing.iconLg,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  description,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (requiresConfirmation)
          VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Rà soát trước khi lưu',
            message:
                'Kiểm tra thay đổi bảo mật, quyền truy cập hoặc cấp xác minh trước khi xác nhận.',
            contractId: semanticIdentifier,
            density: VitDensity.compact,
          ),
        VitPageSection(
          label: 'Thông tin chính',
          headerIcon: Icons.fact_check_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: [
            VitCard(
              variant: VitCardVariant.inner,
              child: Column(
                children: [
                  for (var index = 0; index < facts.length; index++)
                    VitInfoRow(
                      label: facts[index].label,
                      value: facts[index].value,
                      valueColor: facts[index].valueColor,
                      density: VitDensity.compact,
                      showDivider: index < facts.length - 1,
                    ),
                ],
              ),
            ),
          ],
        ),
        if (actionLabel != null)
          VitCtaButton(
            key: actionKey,
            variant: requiresConfirmation
                ? VitCtaButtonVariant.primary
                : VitCtaButtonVariant.secondary,
            leading: Icon(
              requiresConfirmation
                  ? Icons.verified_user_outlined
                  : Icons.arrow_forward_rounded,
            ),
            onPressed: () => requiresConfirmation
                ? _showConfirmation(context)
                : _showNotice(context),
            child: Text(actionLabel!),
          ),
        const VitCard(
          variant: VitCardVariant.ghost,
          child: Text(
            'Thông tin nhạy cảm chỉ được thay đổi sau khi bạn kiểm tra lại phạm vi, quyền truy cập và bước xác nhận tiếp theo.',
          ),
        ),
      ],
    );
  }

  Future<void> _showConfirmation(BuildContext context) async {
    final confirmed = await showVitPreviewConfirmSheet(
      context: context,
      title: confirmationTitle ?? 'Xác nhận thay đổi',
      sheetKey: Key('$semanticIdentifier-tablet-confirm-sheet'),
      cancelKey: cancelKey,
      confirmKey: confirmKey,
      confirmLabel: actionLabel ?? 'Xác nhận',
      confirmVariant: VitCtaButtonVariant.danger,
      items: [
        for (final fact in facts)
          VitFinancialSafetyItem(
            label: fact.label,
            value: fact.value,
            valueColor: fact.valueColor,
          ),
      ],
    );
    if (!confirmed || !context.mounted) return;
    await showVitNoticeSheet(
      context: context,
      title: 'Đã ghi nhận thay đổi',
      message: 'Thay đổi sẽ có hiệu lực sau khi hệ thống hoàn tất kiểm tra.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }

  Future<void> _showNotice(BuildContext context) {
    return showVitNoticeSheet(
      context: context,
      title: 'Đã mở thao tác',
      message: 'Bạn có thể tiếp tục theo dõi trạng thái tại trang tài khoản.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }
}

/// One read-only fact shown by [ProfileTabletUtilityPage].
class ProfileTabletFact {
  const ProfileTabletFact({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
}
