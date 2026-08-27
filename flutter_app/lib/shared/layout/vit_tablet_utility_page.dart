import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet-only composition for route families without a feature-specific page.
///
/// This is a presentation primitive, not a Phone fallback: it contains no
/// feature page imports and is configured by the active Tablet route group.
class VitTabletUtilityPage extends StatelessWidget {
  const VitTabletUtilityPage({
    super.key,
    required this.semanticIdentifier,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.facts,
    required this.onBack,
    this.actionLabel,
    this.requiresConfirmation = false,
    this.confirmationTitle,
    this.confirmationMessage,
    this.icon = Icons.dashboard_customize_outlined,
  });

  final String semanticIdentifier;
  final String title;
  final String subtitle;
  final String description;
  final List<VitTabletUtilityFact> facts;
  final VoidCallback onBack;
  final String? actionLabel;
  final bool requiresConfirmation;
  final String? confirmationTitle;
  final String? confirmationMessage;
  final IconData icon;

  Key get contentKey => Key('$semanticIdentifier-tablet-content');
  Key get actionKey => Key('$semanticIdentifier-tablet-action');
  Key get cancelKey => Key('$semanticIdentifier-tablet-cancel');
  Key get confirmKey => Key('$semanticIdentifier-tablet-confirm');

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: '$title trên tablet',
      semanticIdentifier: '$semanticIdentifier-TABLET',
      child: Column(
        children: [
          VitHeader(
            title: title,
            subtitle: subtitle,
            showBack: true,
            onBack: onBack,
            // Gutter-flush (S6): shell master-detail đã cấp outer margin —
            // header canh 0 cho thẳng hàng nội dung fullBleed bên dưới.
            horizontalPadding: AppSpacing.zero,
          ),
          Expanded(
            child: SingleChildScrollView(
              key: contentKey,
              child: VitPageContent(
                rhythm: VitPageRhythm.form,
                padding: VitContentPadding.compact,
                density: VitDensity.compact,
                fullBleed: true,
                children: [
                  VitCard(
                    variant: VitCardVariant.hero,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          icon,
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
                      title: 'Rà soát trước khi xác nhận',
                      message:
                          'Kiểm tra thông tin, điều kiện và phạm vi áp dụng trước khi tiếp tục.',
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
                            ? Icons.fact_check_outlined
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
                      'Nội dung được bố trí riêng cho Tablet. Điều kiện thực thi cuối cùng sẽ được xác nhận ở bước tiếp theo.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showConfirmation(BuildContext context) async {
    final confirmed = await showVitPreviewConfirmSheet(
      context: context,
      title: confirmationTitle ?? 'Xác nhận thao tác',
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
      title: 'Đã ghi nhận yêu cầu',
      message:
          confirmationMessage ??
          'Yêu cầu đã được ghi nhận và sẽ hiển thị trong lịch sử.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }

  Future<void> _showNotice(BuildContext context) {
    return showVitNoticeSheet(
      context: context,
      title: 'Đã mở thao tác',
      message: 'Bạn có thể tiếp tục theo dõi trạng thái tại trang này.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }
}

/// Read-only fact shown in [VitTabletUtilityPage].
class VitTabletUtilityFact {
  const VitTabletUtilityFact({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
}
