part of '../../phone/pages/savings/savings_auto_rebalance_page.dart';

class _DriftHistoryCard extends StatelessWidget {
  const _DriftHistoryCard({required this.points});

  final List<SavingsRebalanceDriftPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsAutoRebalancePage.driftChartKey,
      radius: VitCardRadius.large,
      padding: _savingsRebalanceCardPadding,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        density: VitDensity.compact,
        children: [
          const VitSectionHeader(
            title: 'Lịch sử Drift',
            icon: Icons.bar_chart_rounded,
            iconColor: AppColors.primary,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          SizedBox(
            height: _savingsRebalanceDriftChartHeight,
            child: _DriftBarChart(points: points),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VitLegendItem(
                label: '< 3% Tốt',
                color: AppColors.buy,
                dotSize: _savingsRebalanceLegendDot,
              ),
              SizedBox(width: AppSpacing.x3),
              VitLegendItem(
                label: '3-8% Lệch',
                color: AppColors.primary,
                dotSize: _savingsRebalanceLegendDot,
              ),
              SizedBox(width: AppSpacing.x3),
              VitLegendItem(
                label: '> 8% Cao',
                color: AppColors.sell,
                dotSize: _savingsRebalanceLegendDot,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DriftBarChart extends StatelessWidget {
  const _DriftBarChart({required this.points});

  final List<SavingsRebalanceDriftPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const labels = [8, 6, 4, 2, 0];
        final chartTop = 8.0;
        final chartHeight = constraints.maxHeight - 28;
        final step = (constraints.maxWidth - 42) / points.length;
        const labelWidth = 54.0;
        const labelIndexes = [1, 3, 5, 7, 9];

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _DriftBarPainter(points: points)),
            ),
            for (final label in labels)
              Positioned(
                left: 0,
                top: chartTop + chartHeight * (1 - label / 8) - 6,
                child: _AxisText('$label%'),
              ),
            for (final i in labelIndexes)
              Positioned(
                left: math
                    .max(
                      0,
                      math.min(
                        constraints.maxWidth - labelWidth,
                        34 + step * i + step / 2 - labelWidth / 2,
                      ),
                    )
                    .toDouble(),
                bottom: 0,
                width: labelWidth,
                child: _AxisText(points[i].date, align: TextAlign.center),
              ),
          ],
        );
      },
    );
  }
}

class _AutoStatusCard extends StatelessWidget {
  const _AutoStatusCard({
    required this.autoEnabled,
    required this.settings,
    required this.onChanged,
  });

  final bool autoEnabled;
  final SavingsRebalanceSettingsDraft settings;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsAutoRebalancePage.autoStatusKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Row(
        children: [
          SizedBox.square(
            dimension: _savingsRebalanceIconBox,
            child: Material(
              color: autoEnabled ? AppColors.buy10 : AppColors.hoverBg,
              borderRadius: AppRadii.mdRadius,
              child: Icon(
                autoEnabled ? Icons.play_arrow_rounded : Icons.pause_rounded,
                color: autoEnabled ? AppColors.buy : AppColors.text3,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tự động tái cân bằng',
                  style: _captionMedium.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  autoEnabled
                      ? '${settings.frequencyLabel} · Ngưỡng ${settings.driftThreshold.toStringAsFixed(0)}%'
                      : 'Đã tắt',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: autoEnabled,
            activeThumbColor: AppColors.buy,
            activeTrackColor: AppColors.buy20,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.snapshot, required this.strategy});

  final SavingsAutoRebalanceSnapshot snapshot;
  final SavingsRebalanceStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    final completed = snapshot.history
        .where((item) => item.status == SavingsRebalanceHistoryStatus.completed)
        .length;
    final totalMoved = snapshot.history.fold<double>(
      0,
      (sum, item) => sum + item.totalMoved,
    );

    return Row(
      key: SavingsAutoRebalancePage.statsKey,
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.sync_rounded,
            color: AppColors.primary,
            value: '$completed',
            label: 'Lần cân bằng',
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _MetricCard(
            icon: Icons.compare_arrows_rounded,
            color: AppColors.buy,
            value: _formatUsd(totalMoved),
            label: 'Tổng di chuyển',
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _MetricCard(
            icon: Icons.trending_up_rounded,
            color: AppColors.warn,
            value: '${strategy.expectedApy.toStringAsFixed(2)}%',
            label: 'APY kỳ vọng',
          ),
        ),
      ],
    );
  }
}
