part of '../../phone/pages/hub/dca_overview_demo.dart';

class _ProfitRow extends StatelessWidget {
  const _ProfitRow({required this.data, required this.balanceHidden});

  final DcaOverviewDemoData data;
  final bool balanceHidden;

  @override
  Widget build(BuildContext context) {
    final isProfit = data.isProfit;
    return Row(
      children: [
        DecoratedBox(
          decoration: ShapeDecoration(
            color: isProfit ? AppColors.buy20 : AppColors.sell20,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.smRadius,
            ),
          ),
          child: Padding(
            padding: AdminSpacingTokens.devCompactChipPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isProfit
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  color: isProfit ? AppColors.buy : AppColors.sell,
                  size: DcaSpacingTokens.dcaOverviewMetaIcon,
                ),
                const SizedBox(width: AppSpacing.x1),
                Text(
                  balanceHidden
                      ? '•••'
                      : '${isProfit ? '+' : '-'} ${_formatFullVnd(data.profitLossVnd.abs())} (${_formatPercent(data.profitLossPercent)})',
                  style: AppTextStyles.caption.copyWith(
                    color: isProfit ? AppColors.buy : AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Flexible(
          child: Text(
            'tổng lãi/lỗ',
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.data, required this.balanceHidden});

  final DcaOverviewDemoData data;
  final bool balanceHidden;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            icon: Icons.sync_rounded,
            label: 'Kế\nhoạch',
            value: balanceHidden ? '•' : '${data.totalPlans}',
            subtitle: '${data.activePlans} đang chạy',
            accent: AppModuleAccents.trade,
            accentBg: AppColors.primary15,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _MetricTile(
            icon: Icons.trending_up_rounded,
            label: 'Đã đầu\ntư',
            value: balanceHidden
                ? '•••'
                : _formatCompactVnd(data.totalInvestedVnd),
            subtitle: balanceHidden
                ? '•••••'
                : _formatFullVnd(data.totalInvestedVnd),
            accent: AppColors.buy,
            accentBg: AppColors.buy15,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _MetricTile(
            icon: Icons.bar_chart_rounded,
            label: 'TB/plan',
            value: balanceHidden
                ? '•••'
                : _formatCompactVnd(data.averagePerPlanVnd),
            subtitle: 'VND / kế hoạch',
            accent: AppColors.accent,
            accentBg: AppColors.accent15,
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.accent,
    required this.accentBg,
  });

  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color accent;
  final Color accentBg;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.portfolioBtnGhost,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      ),
      child: Padding(
        padding: AdminSpacingTokens.devCompactPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: ShapeDecoration(
                    color: accentBg,
                    shape: const CircleBorder(),
                  ),
                  child: Padding(
                    padding: AdminSpacingTokens.devTinyPadding,
                    child: Icon(
                      icon,
                      color: accent,
                      size: DcaSpacingTokens.dcaOverviewMetricIcon,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.portfolioTextDim,
                      fontWeight: AppTextStyles.bold,
                      height: DcaSpacingTokens.dcaOverviewMetricLabelLineHeight,
                    ),
                  ),
                ),
                const Icon(
                  Icons.help_outline_rounded,
                  color: AppColors.portfolioTextMuted,
                  size: DcaSpacingTokens.dcaOverviewMetricIcon,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                maxLines: 1,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: accent,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.portfolioTextMuted,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextExecutionRow extends StatelessWidget {
  const _NextExecutionRow({required this.data});

  final DcaOverviewDemoData data;

  @override
  Widget build(BuildContext context) {
    final hasNext = data.nextRelativeTime != null && data.nextAmountVnd != null;
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.portfolioBtnGhost,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      ),
      child: Padding(
        padding: AdminSpacingTokens.devCompactPadding,
        child: Row(
          children: [
            const DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.primary15,
                shape: CircleBorder(),
              ),
              child: Padding(
                padding: AdminSpacingTokens.devCompactPadding,
                child: Icon(
                  Icons.schedule_rounded,
                  color: AppColors.primary,
                  size: DcaSpacingTokens.dcaOverviewInlineIcon,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasNext ? 'Lần mua tiếp' : 'Không có lịch mua',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.portfolioTextMuted,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    hasNext
                        ? '${data.nextRelativeTime} · ${_formatCompactVnd(data.nextAmountVnd!)}'
                        : 'Tất cả kế hoạch đang tạm dừng',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            _StatusBadge(
              icon: Icons.play_arrow_rounded,
              count: data.activePlans,
              bg: AppColors.buy15,
              color: AppColors.buy,
            ),
            if (data.pausedPlans > 0) ...[
              const SizedBox(width: AppSpacing.x2),
              _StatusBadge(
                icon: Icons.pause_rounded,
                count: data.pausedPlans,
                bg: AppColors.warn15,
                color: AppColors.warn,
              ),
            ],
            if (data.errorPlans > 0) ...[
              const SizedBox(width: AppSpacing.x2),
              _StatusBadge(
                icon: Icons.error_outline_rounded,
                count: data.errorPlans,
                bg: AppColors.sell15,
                color: AppColors.sell,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.icon,
    required this.count,
    required this.bg,
    required this.color,
  });

  final IconData icon;
  final int count;
  final Color bg;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: bg,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: AdminSpacingTokens.devInlinePillPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: DcaSpacingTokens.dcaOverviewMetricIcon,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              '$count',
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
