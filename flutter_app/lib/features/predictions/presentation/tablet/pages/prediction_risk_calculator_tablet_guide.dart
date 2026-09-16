part of 'prediction_risk_calculator_tablet_page.dart';

class _Sc216ScenariosTab extends StatelessWidget {
  const _Sc216ScenariosTab({required this.inputs, required this.metrics});

  final _Sc216RiskInputs inputs;
  final _Sc216RiskMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final scenarios = [
      (
        outcome: 'Thắng (Yes chốt)',
        settlementValue: inputs.shares,
        probability: inputs.currentPrice * 100,
        positive: true,
      ),
      (
        outcome: 'Thua (No chốt)',
        settlementValue: 0.0,
        probability: (1 - inputs.currentPrice) * 100,
        positive: false,
      ),
    ];

    return VitPageSection(
      label: 'Phân tích kịch bản',
      accentColor: AppColors.primary,
      innerGap: TabletSpacingTokens.x4,
      children: [
        for (final scenario in scenarios)
          VitCard(
            density: VitDensity.compact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scenario.outcome,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: AppTextStyles.medium,
                            ),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x1),
                          Text(
                            'Xác suất ngụ ý: '
                            '${scenario.probability.toStringAsFixed(1)}%',
                            style: AppTextStyles.numericMicro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      scenario.positive
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: scenario.positive ? AppColors.buy : AppColors.sell,
                    ),
                  ],
                ),
                const SizedBox(height: TabletSpacingTokens.x3),
                VitInfoRow(
                  label: 'Giá trị thanh toán',
                  value: VitFormat.usd(scenario.settlementValue),
                  density: VitDensity.compact,
                ),
                VitInfoRow(
                  label: 'Lãi/lỗ',
                  value: VitFormat.usdSigned(
                    scenario.settlementValue - inputs.cost,
                  ),
                  valueColor: scenario.settlementValue - inputs.cost >= 0
                      ? AppColors.buy
                      : AppColors.sell,
                  density: VitDensity.compact,
                ),
              ],
            ),
          ),
        VitCard(
          density: VitDensity.compact,
          child: VitInfoRow(
            label: 'Giá trị kỳ vọng ròng',
            value: VitFormat.usdSigned(metrics.expectedValue),
            valueColor: metrics.expectedValue >= 0
                ? AppColors.buy
                : AppColors.sell,
            density: VitDensity.compact,
          ),
        ),
      ],
    );
  }
}

class _Sc216GuideTab extends StatelessWidget {
  const _Sc216GuideTab();

  @override
  Widget build(BuildContext context) {
    return const VitPageSection(
      label: 'Cách dùng',
      accentColor: AppColors.primary,
      innerGap: TabletSpacingTokens.x4,
      children: [
        _Sc216GuideCard(
          title: '1. Nhập thông tin vị thế',
          body: 'Nhập sự kiện, kết quả, số cổ phần, giá vào và giá hiện tại.',
        ),
        _Sc216GuideCard(
          title: '2. Xem chỉ số rủi ro',
          body: 'Xem phân tích: tối đa mất/được, hòa vốn, giá trị kỳ vọng.',
        ),
        _Sc216GuideCard(
          title: '3. Kiểm tra định cỡ vị thế',
          body:
              'Tham khảo Kelly criterion để xác định kích thước vị thế tối ưu.',
        ),
        _Sc216GuideCard(
          title: 'Giá trị kỳ vọng',
          body:
              'Công cụ tính toán chỉ là tham khảo. Xác suất không phải sự chắc chắn.',
        ),
      ],
    );
  }
}

class _Sc216GuideCard extends StatelessWidget {
  const _Sc216GuideCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Text(
            body,
            style: AppTextStyles.badge.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}
