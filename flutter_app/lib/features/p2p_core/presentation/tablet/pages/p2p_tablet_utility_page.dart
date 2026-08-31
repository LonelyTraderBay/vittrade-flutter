import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/widgets/p2p_tablet_utility_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for P2P account and high-risk utility flows.
///
/// Route-specific data is supplied by the route group. Phone pages remain
/// untouched and high-risk actions always stop at preview/confirm.
class P2PTabletUtilityPage extends StatelessWidget {
  const P2PTabletUtilityPage({
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
    this.icon = Icons.handshake_outlined,
  });

  final String semanticIdentifier;
  final String title;
  final String subtitle;
  final String description;
  final List<P2PTabletFact> facts;
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
    return P2PTabletUtilitySurface(
      title: title,
      subtitle: subtitle,
      semanticIdentifier: '$semanticIdentifier-TABLET',
      semanticLabel: '$title trên tablet',
      contentKey: contentKey,
      onBack: () => context.go(AppRoutePaths.p2p),
      children: [
        VitCard(
          variant: VitCardVariant.hero,
          child: Row(
            // AIB-R6: khối mô tả căn giữa dọc theo ô icon.
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // AIB-R6: icon leading cạnh mô tả nhiều dòng phải nằm trong
              // VitAccentIconBox — icon trần trông nhỏ so với khối chữ.
              VitAccentIconBox(icon: icon, color: AppColors.primary),
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
            title: 'Rà soát trước khi xác nhận',
            message:
                'Kiểm tra danh tính, quyền truy cập, bằng chứng và phạm vi áp dụng trước khi tiếp tục.',
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
            'Thông tin P2P hiển thị theo phạm vi hiện tại. Hệ thống sẽ kiểm tra lại điều kiện cuối cùng trước khi ghi nhận thay đổi.',
          ),
        ),
      ],
    );
  }

  Future<void> _showConfirmation(BuildContext context) async {
    final confirmed = await showVitPreviewConfirmSheet(
      context: context,
      title: confirmationTitle ?? 'Xác nhận thao tác P2P',
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
          'Yêu cầu đã được ghi nhận và sẽ hiển thị trong lịch sử P2P.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }

  Future<void> _showNotice(BuildContext context) {
    return showVitNoticeSheet(
      context: context,
      title: 'Đã mở thao tác',
      message: 'Bạn có thể tiếp tục theo dõi trạng thái trong khu vực P2P.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }
}

/// One read-only fact displayed by [P2PTabletUtilityPage].
class P2PTabletFact {
  const P2PTabletFact({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
}

/// Creates a route-configured P2P Tablet utility composition.
P2PTabletUtilityPage p2pTabletUtility({
  required String semanticIdentifier,
  required String title,
  required String subtitle,
  required String description,
  required List<P2PTabletFact> facts,
  String? actionLabel,
  bool requiresConfirmation = false,
  String? confirmationTitle,
  String? confirmationMessage,
  IconData icon = Icons.handshake_outlined,
}) {
  return P2PTabletUtilityPage(
    semanticIdentifier: semanticIdentifier,
    title: title,
    subtitle: subtitle,
    description: description,
    facts: facts,
    actionLabel: actionLabel,
    requiresConfirmation: requiresConfirmation,
    confirmationTitle: confirmationTitle,
    confirmationMessage: confirmationMessage,
    icon: icon,
  );
}
