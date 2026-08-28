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

/// Web-only composition for route families without a feature-specific page.
///
/// The page uses a wider information hierarchy than Tablet and does not
/// import any device-specific presentation module.
class VitWebUtilityPage extends StatelessWidget {
  const VitWebUtilityPage({
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
  final List<VitWebUtilityFact> facts;
  final VoidCallback onBack;
  final String? actionLabel;
  final bool requiresConfirmation;
  final String? confirmationTitle;
  final String? confirmationMessage;
  final IconData icon;

  Key get contentKey => Key('$semanticIdentifier-web-content');
  Key get actionKey => Key('$semanticIdentifier-web-action');
  Key get cancelKey => Key('$semanticIdentifier-web-cancel');
  Key get confirmKey => Key('$semanticIdentifier-web-confirm');

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: '$title trên Web',
      semanticIdentifier: '$semanticIdentifier-WEB',
      child: Column(
        children: [
          VitHeader(
            title: title,
            subtitle: subtitle,
            showBack: true,
            onBack: onBack,
          ),
          Expanded(
            child: SingleChildScrollView(
              key: contentKey,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.form,
                    padding: VitContentPadding.relaxed,
                    density: VitDensity.relaxed,
                    children: [
                      VitCard(
                        variant: VitCardVariant.hero,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AIB-R6: icon leading cạnh mô tả nhiều dòng phải
                            // nằm trong VitAccentIconBox (twin của tablet).
                            VitAccentIconBox(
                              icon: icon,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: AppSpacing.x4),
                            Expanded(
                              child: Text(
                                description,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.text1,
                                  height: 1.45,
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
                          density: VitDensity.relaxed,
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
                            child: Wrap(
                              spacing: AppSpacing.x7,
                              runSpacing: AppSpacing.x4,
                              children: [
                                for (final fact in facts)
                                  SizedBox(
                                    width: 280,
                                    child: VitInfoRow(
                                      label: fact.label,
                                      value: fact.value,
                                      valueColor: fact.valueColor,
                                      density: VitDensity.relaxed,
                                    ),
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
                          'Nội dung được bố trí riêng cho Web. Điều kiện thực thi cuối cùng sẽ được xác nhận ở bước tiếp theo.',
                        ),
                      ),
                    ],
                  ),
                ),
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
      sheetKey: Key('$semanticIdentifier-web-confirm-sheet'),
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

/// Read-only fact shown in [VitWebUtilityPage].
class VitWebUtilityFact {
  const VitWebUtilityFact({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
}
