part of '../../phone/pages/portfolio/dca_portfolio_optimizer_page.dart';

class _DriftBanner extends StatelessWidget {
  const _DriftBanner({
    required this.snapshot,
    required this.onDismiss,
    required this.onSettings,
  });

  final DcaPortfolioOptimizerSnapshot snapshot;
  final VoidCallback onDismiss;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.sell20,
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.x3,
        AppSpacing.x2,
        AppSpacing.x2,
        AppSpacing.x2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: _dcaPortfolioAlertIconExtent,
            height: _dcaPortfolioAlertIconExtent,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.sell10,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                  side: BorderSide(color: AppColors.sell20),
                ),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: AppColors.sell,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Danh mục lệch cao',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    _SmallPill(
                      label: '${snapshot.driftPercent.toStringAsFixed(1)}%',
                      color: AppColors.sell,
                    ),
                  ],
                ),
                const Padding(padding: DcaSpacingTokens.dcaTopPaddingX1),
                Text(
                  'Drift ${snapshot.driftPercent.toStringAsFixed(1)}% > ngưỡng ${snapshot.driftThresholdPercent.toStringAsFixed(0)}%; kiểm tra trước khi áp dụng.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _dcaPortfolioBodyLineHeight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          _MiniButton(
            key: DCAPortfolioOptimizerPage.driftSettingsKey,
            label: 'Cài đặt',
            icon: Icons.tune_rounded,
            color: AppColors.sell,
            onTap: onSettings,
          ),
          VitInlineIconAction(
            icon: Icons.close_rounded,
            tooltip: 'Dismiss drift alert',
            onPressed: onDismiss,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
            padding: AppSpacing.x1,
          ),
        ],
      ),
    );
  }
}
