part of '../../phone/pages/dashboard/bot_risk_dashboard_page.dart';

class _CriticalMetricsGrid extends StatelessWidget {
  const _CriticalMetricsGrid({required this.snapshot});

  final TradeBotRiskDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricData(
        icon: Icons.trending_down_rounded,
        label: 'Sụt giảm vốn',
        value: '${snapshot.currentDrawdown.toStringAsFixed(1)}%',
        limit: 'Giới hạn: ${snapshot.maxDrawdownLimit.toStringAsFixed(0)}%',
        color: _riskRed,
        percent: (snapshot.currentDrawdown / snapshot.maxDrawdownLimit).abs(),
      ),
      _MetricData(
        icon: Icons.attach_money_rounded,
        label: 'Lỗ trong ngày',
        value: _formatSignedMoney(snapshot.dailyLoss),
        limit: 'Giới hạn: ${_formatSignedMoney(snapshot.dailyLossLimit)}',
        color: _riskAmber,
        percent: (snapshot.dailyLoss / snapshot.dailyLossLimit).abs(),
      ),
      _MetricData(
        icon: Icons.monitor_heart_outlined,
        label: 'Tổng mức phơi nhiễm',
        value: _formatMoney(snapshot.totalExposure),
        limit: 'Tối đa: ${_formatMoney(snapshot.maxExposure)}',
        color: _riskPrimary,
        percent: snapshot.totalExposure / snapshot.maxExposure,
      ),
      _MetricData(
        icon: Icons.bolt_rounded,
        label: 'VaR (95%)',
        value: _formatMoney(snapshot.var95),
        limit: 'Ước lỗ 1 ngày (95%)',
        color: _riskPurple,
        percent: (snapshot.var95 / snapshot.maxExposure).clamp(0.0, 1.0),
      ),
    ];

    final rows = <Widget>[];
    for (var i = 0; i < metrics.length; i += 2) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _MetricCard(metric: metrics[i])),
            const SizedBox(width: TradeSpacingTokens.tradeBotCardGap),
            Expanded(
              child: i + 1 < metrics.length
                  ? _MetricCard(metric: metrics[i + 1])
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
      if (i + 2 < metrics.length) {
        rows.add(const SizedBox(height: TradeSpacingTokens.tradeBotCardGap));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.icon,
    required this.label,
    required this.value,
    required this.limit,
    required this.color,
    required this.percent,
  });

  final IconData icon;
  final String label;
  final String value;
  final String limit;
  final Color color;
  final double percent;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _MetricData metric;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotMetricBoxPadding,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              VitAccentIconBox(icon: metric.icon, color: metric.color),
              const SizedBox(width: TradeSpacingTokens.tradeBotTinyGap),
              Expanded(
                child: Text(
                  metric.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
          Text(
            metric.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: metric.color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
          Text(
            metric.limit,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
          VitProgressBar(
            progress: metric.percent.clamp(0.0, 1.0),
            color: metric.color,
            height: AppSpacing.x2,
            trackColor: _riskTrack,
            borderRadius: AppRadii.pillRadius,
          ),
        ],
      ),
    );
  }
}

class _ExposureCard extends StatelessWidget {
  const _ExposureCard({required this.exposures});

  final List<TradeBotExposure> exposures;

  @override
  Widget build(BuildContext context) {
    final maxPct = exposures.fold<int>(
      0,
      (max, item) => item.percentage > max ? item.percentage : max,
    );
    final diversification = (100 - maxPct + 22).clamp(0, 100);
    final grade = diversification >= 70
        ? 'Tốt'
        : diversification >= 40
        ? 'Trung bình'
        : 'Yếu';

    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      density: VitDensity.tool,
      child: Column(
        children: [
          for (final exposure in exposures) ...[
            Row(
              children: [
                DecoratedBox(
                  decoration: ShapeDecoration(
                    color: Color(exposure.colorHex),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.smRadius,
                    ),
                  ),
                  child: const SizedBox(
                    width: AppSpacing.x3,
                    height: AppSpacing.x3,
                  ),
                ),
                const SizedBox(width: TradeSpacingTokens.tradeBotTinyGap),
                Text(
                  exposure.asset,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: TradeSpacingTokens.tradeBotTinyGap),
                Text(
                  '${exposure.percentage}%',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatMoney(exposure.exposure),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
            VitProgressBar(
              progress: exposure.percentage / 100,
              color: Color(exposure.colorHex),
              height: AppSpacing.x2,
              trackColor: _riskTrack,
              borderRadius: AppRadii.pillRadius,
            ),
            if (exposure != exposures.last)
              const SizedBox(height: TradeSpacingTokens.tradeBotCardGap),
          ],
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const Divider(
            color: AppColors.borderSolid,
            thickness: AppSpacing.hairlineStroke,
            height: AppSpacing.dividerHairline,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Điểm đa dạng hóa',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                '$diversification/100 ($grade)',
                style: AppTextStyles.caption.copyWith(
                  color: _riskGreen,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
