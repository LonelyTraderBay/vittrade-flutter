part of 'dca_page.dart';

class _CoinAvatar extends StatelessWidget {
  const _CoinAvatar({required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    final color = switch (symbol) {
      'BTC' => AppColors.warn,
      'ETH' => AppColors.text2,
      'SOL' => AppColors.accent,
      _ => AppColors.primary,
    };
    final icon = switch (symbol) {
      'BTC' => Icons.currency_bitcoin_rounded,
      'ETH' => Icons.diamond_outlined,
      'SOL' => Icons.blur_on_rounded,
      _ => Icons.token_rounded,
    };
    return SizedBox.square(
      dimension: AppSpacing.buttonCompact + AppSpacing.hairlineStroke,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .12),
          shape: CircleBorder(
            side: BorderSide(color: color.withValues(alpha: .24)),
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: DcaSpacingTokens.dcaMainAssetIcon,
        ),
      ),
    );
  }
}

class _PlanMetric extends StatelessWidget {
  const _PlanMetric({
    required this.label,
    required this.value,
    required this.unit,
    this.color = AppColors.text1,
    this.icon,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
            height: AppTextStyles.badge.height,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x1),
            ],
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                  height: AppTextStyles.badge.height,
                ),
              ),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.x1),
              Text(
                unit,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: AppTextStyles.badge.height,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _PlanIconButton extends StatelessWidget {
  const _PlanIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: VitDensity.compact.controlHeight,
      height: VitDensity.compact.controlHeight,
      child: VitCard(
        variant: VitCardVariant.inner,
        radius: VitCardRadius.standard,
        onTap: onTap,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel({super.key, required this.snapshot});

  final DcaDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Lịch sử danh mục',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const VitStatusPill(
                label: '90 ngày',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          SizedBox(
            height: VitDensity.compact.controlHeight * 2.6,
            child: CustomPaint(
              painter: _HistoryChartPainter(
                values: snapshot.history,
                lineColor: AppColors.buy,
                investedColor: AppColors.primary,
                gridColor: AppColors.divider,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _HistoryStat(
                  label: 'Giá trị',
                  value: _formatCompactVnd(snapshot.overview.currentValueVnd),
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _HistoryStat(
                  label: 'Đã đầu tư',
                  value: _formatCompactVnd(snapshot.overview.totalInvestedVnd),
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryStat extends StatelessWidget {
  const _HistoryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitMetricCard(label: label, value: value, accentColor: color);
  }
}

// notice-ack: allow-onboarding — intro overlay for the multi-step DCA
// creation wizard ("trong bước sau"); not a post-action acknowledgement.
class _CreatePlanSheet extends StatelessWidget {
  const _CreatePlanSheet({required this.bottomInset, required this.onClose});

  final double bottomInset;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: AppColors.dynamicIslandBg.withValues(alpha: .54),
        child: Column(
          children: [
            Expanded(
              child: VitCard(
                onTap: onClose,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.standard,
                padding: AppSpacing.zeroInsets,
                borderColor: AppColors.transparent,
                child: const SizedBox.expand(),
              ),
            ),
            Padding(
              padding: DcaSpacingTokens.dcaBottomSheetPadding(bottomInset),
              child: VitCard(
                key: DCAPage.createSheetKey,
                radius: VitCardRadius.large,
                density: VitDensity.compact,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VitSheetHandle(),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Row(
                      children: [
                        const SizedBox.square(
                          dimension:
                              AppSpacing.buttonCompact +
                              AppSpacing.hairlineStroke,
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              color: AppColors.primary12,
                              shape: CircleBorder(),
                            ),
                            child: Icon(
                              Icons.add_chart_rounded,
                              color: AppColors.primary,
                              size: DcaSpacingTokens.dcaMainToolIcon,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tạo kế hoạch DCA',
                                style: AppTextStyles.base.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              Text(
                                'Chọn coin, số tiền và lịch mua trong bước sau.',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    VitCtaButton(
                      onPressed: onClose,
                      leading: const Icon(Icons.check_rounded),
                      child: const Text('Đã hiểu'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
