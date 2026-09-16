part of 'prediction_market_maker_tablet_page.dart';

class _Sc217PositionsTab extends StatelessWidget {
  const _Sc217PositionsTab({required this.snapshot});

  final PredictionMarketMakerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Các vị thế',
      accentColor: AppColors.primary,
      innerGap: TabletSpacingTokens.x4,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Row(
            children: [
              Expanded(
                child: _Sc217OverviewMetric(
                  label: 'Giá trị hiện tại',
                  value: VitFormat.usd(snapshot.totalValue),
                ),
              ),
              Expanded(
                child: _Sc217OverviewMetric(
                  label: 'Tổng phí',
                  value: VitFormat.usd(snapshot.totalFees),
                ),
              ),
            ],
          ),
        ),
        VitCard(
          density: VitDensity.compact,
          child: Row(
            children: [
              Expanded(
                child: _Sc217OverviewMetric(
                  label: 'Tổn thất tạm thời',
                  value: VitFormat.usd(snapshot.totalImpermanentLoss),
                ),
              ),
              Expanded(
                child: _Sc217OverviewMetric(
                  label: 'Lợi nhuận ròng',
                  value: VitFormat.usdSigned(snapshot.netReturn),
                  valueColor: snapshot.netReturn >= 0
                      ? AppColors.buy
                      : AppColors.sell,
                ),
              ),
            ],
          ),
        ),
        for (final position in snapshot.positions)
          VitCard(
            key: Key('sc217_position_${position.id}'),
            density: VitDensity.compact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position.eventName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                VitInfoRow(
                  label: 'Đã cung cấp',
                  value: VitFormat.usd(position.liquidityProvided),
                  density: VitDensity.compact,
                ),
                VitInfoRow(
                  label: 'Phí đã kiếm',
                  value: VitFormat.usdSigned(position.feesEarned),
                  valueColor: AppColors.buy,
                  density: VitDensity.compact,
                ),
                VitInfoRow(
                  label: 'APR',
                  value: VitFormat.percent(position.apr, fractionDigits: 1),
                  valueColor: AppColors.buy,
                  density: VitDensity.compact,
                ),
                VitInfoRow(
                  label: 'Lãi/lỗ ròng',
                  value: VitFormat.usdSigned(position.netPnl),
                  valueColor: position.netPnl >= 0
                      ? AppColors.buy
                      : AppColors.sell,
                  density: VitDensity.compact,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Sc217EarningsTab extends StatelessWidget {
  const _Sc217EarningsTab({required this.snapshot});

  final PredictionMarketMakerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final history = snapshot.earningsHistory;
    final maxFees = history.fold(
      0.0,
      (max, point) => point.fees > max ? point.fees : max,
    );

    return VitPageSection(
      label: 'Phân tích thu nhập',
      accentColor: AppColors.primary,
      innerGap: TabletSpacingTokens.x4,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              VitInfoRow(
                label: 'Tổng phí',
                value: VitFormat.usd(snapshot.totalFees),
                valueColor: AppColors.buy,
                density: VitDensity.compact,
              ),
              VitInfoRow(
                label: 'Phí trung bình mỗi ngày',
                value: VitFormat.usd(snapshot.totalFees / 60),
                density: VitDensity.compact,
              ),
            ],
          ),
        ),
        if (history.isNotEmpty)
          VitCard(
            density: VitDensity.compact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Phí theo ngày (60 ngày)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x3),
                SizedBox(
                  height: TabletSpacingTokens.x5 + TabletSpacingTokens.x5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final point in history)
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: maxFees <= 0
                                  ? 0
                                  : (point.fees / maxFees),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TabletSpacingTokens.x1,
                                ),
                                child: Material(
                                  color: AppColors.buy.withValues(alpha: .30),
                                  borderRadius: AppRadii.smRadius,
                                  child: const SizedBox.expand(),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

String _sc217FormatInput(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toString();
}
