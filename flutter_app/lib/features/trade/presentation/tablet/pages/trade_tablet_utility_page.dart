import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Shared Tablet composition for Trade L2 utility and review screens.
///
/// The page intentionally owns a Tablet-only composition contract while
/// keeping product-specific data in the route configuration. It is not a
/// wrapper around any Phone page and keeps high-risk actions behind the same
/// preview/confirm boundary as the main Tablet order flow.
class TradeTabletUtilityPage extends StatelessWidget {
  const TradeTabletUtilityPage({
    super.key,
    required this.semanticIdentifier,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.facts,
    this.actionLabel,
    this.requiresConfirmation = false,
    this.confirmationTitle,
    this.confirmationMessage,
  });

  final String semanticIdentifier;
  final String title;
  final String subtitle;
  final String description;
  final List<TradeTabletFact> facts;
  final String? actionLabel;
  final bool requiresConfirmation;
  final String? confirmationTitle;
  final String? confirmationMessage;

  Key get contentKey => Key('$semanticIdentifier-tablet-content');
  Key get actionKey => Key('$semanticIdentifier-tablet-action');
  Key get confirmKey => Key('$semanticIdentifier-tablet-confirm');
  Key get cancelKey => Key('$semanticIdentifier-tablet-cancel');

  @override
  Widget build(BuildContext context) {
    return VitTradeDetailScaffold(
      title: title,
      subtitle: subtitle,
      semanticLabel: '$title trên tablet',
      semanticIdentifier: '$semanticIdentifier-TABLET',
      contentKey: contentKey,
      onBack: () => context.go(AppRoutePaths.trade),
      children: [
        VitCard(
          variant: VitCardVariant.hero,
          child: Row(
            // AIB-R6: khối mô tả căn giữa dọc theo ô icon.
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // AIB-R6: icon leading cạnh mô tả nhiều dòng phải nằm trong
              // VitAccentIconBox — icon trần trông nhỏ so với khối chữ.
              const VitAccentIconBox(
                icon: Icons.insights_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.x4),
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
            title: 'Xem lại trước khi tiếp tục',
            message:
                'Kiểm tra thông tin, phí và điều kiện áp dụng trước khi gửi yêu cầu.',
            contractId: semanticIdentifier,
            density: VitDensity.compact,
          ),
        VitPageSection(
          label: 'Thông tin chính',
          headerIcon: Icons.receipt_long_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
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
            'Thông tin hiển thị là bản xem trước theo dữ liệu hiện có. Điều kiện thực thi cuối cùng sẽ được xác nhận ở bước tiếp theo.',
          ),
        ),
      ],
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
          'Yêu cầu đã được ghi nhận và sẽ hiển thị trong lịch sử giao dịch.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }

  Future<void> _showNotice(BuildContext context) {
    return showVitNoticeSheet(
      context: context,
      title: 'Đã tiếp nhận thao tác',
      message:
          'Thao tác đã được ghi nhận. Bạn có thể tiếp tục theo dõi tại khu vực giao dịch.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }
}

/// One read-only fact displayed by [TradeTabletUtilityPage].
class TradeTabletFact {
  const TradeTabletFact({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
}
