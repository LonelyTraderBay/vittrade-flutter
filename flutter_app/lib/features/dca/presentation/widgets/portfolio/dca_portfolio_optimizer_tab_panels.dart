part of '../../phone/pages/portfolio/dca_portfolio_optimizer_page.dart';

class _CorrelationContent extends StatelessWidget {
  const _CorrelationContent();

  @override
  Widget build(BuildContext context) {
    const assets = ['BTC', 'ETH', 'SOL', 'BNB', 'ADA'];
    final correlations = [
      [1.00, .82, .71, .68, .65],
      [.82, 1.00, .78, .73, .70],
      [.71, .78, 1.00, .58, .62],
      [.68, .73, .58, 1.00, .55],
      [.65, .70, .62, .55, 1.00],
    ];

    return VitCard(
      padding: _dcaPortfolioHeroPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitSectionHeader(
            title: 'Ma trận tương quan',
            icon: Icons.hub_outlined,
            iconColor: AppColors.primary,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          Text(
            'Tương quan càng thấp = diversification tốt. Càng cao = di chuyển cùng hướng.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: _dcaPortfolioBodyLineHeight,
            ),
          ),
          const Padding(padding: DcaSpacingTokens.dcaTopPaddingX5),
          Row(
            children: [
              const SizedBox(width: AppSpacing.x7),
              for (final asset in assets)
                Expanded(
                  child: Text(
                    asset,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
            ],
          ),
          const Padding(padding: DcaSpacingTokens.dcaTopPaddingX2),
          for (var row = 0; row < assets.length; row++) ...[
            Row(
              children: [
                SizedBox(
                  width: AppSpacing.x7,
                  child: Text(
                    assets[row],
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                for (var col = 0; col < assets.length; col++)
                  Expanded(
                    child: _CorrelationCell(value: correlations[row][col]),
                  ),
              ],
            ),
            if (row != assets.length - 1)
              const Padding(padding: DcaSpacingTokens.dcaTopPaddingX2),
          ],
        ],
      ),
    );
  }
}

class _BacktestContent extends StatelessWidget {
  const _BacktestContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        VitCard(
          padding: _dcaPortfolioHeroPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitSectionHeader(
                title: 'DCA vs HODL (12 tháng)',
                icon: Icons.bar_chart_rounded,
                iconColor: AppColors.buy,
                bottomGap: AppSpacing.pageRhythmStandardInnerGap,
              ),
              SizedBox(
                height: _dcaPortfolioBacktestChartHeight,
                width: double.infinity,
                child: CustomPaint(painter: _BacktestChartPainter()),
              ),
            ],
          ),
        ),
        Padding(padding: DcaSpacingTokens.dcaTopPaddingX4),
        Row(
          children: [
            Expanded(
              child: _MiniStatCard(
                label: 'DCA Final',
                value: '12.9M',
                color: AppColors.buy,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _MiniStatCard(
                label: 'HODL Final',
                value: '11.2M',
                color: AppColors.warn,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _MiniStatCard(
                label: 'DCA trội hơn',
                value: '+14.7%',
                color: AppColors.accent,
              ),
            ),
          ],
        ),
        Padding(padding: DcaSpacingTokens.dcaTopPaddingX4),
        _DisclaimerCard(
          text:
              'Kết quả dựa trên dữ liệu lịch sử, không đảm bảo hiệu suất tương lai.',
        ),
      ],
    );
  }
}

class _RiskContent extends StatelessWidget {
  const _RiskContent({required this.snapshot});

  final DcaPortfolioOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      (
        'Biến động/năm',
        '${snapshot.optimalRiskPercent.toStringAsFixed(1)}%',
        AppColors.warn,
      ),
      ('Max Drawdown', '-27.8%', AppColors.sell),
      (
        'Sharpe Ratio',
        snapshot.optimalSharpe.toStringAsFixed(2),
        AppColors.accent,
      ),
      ('Sortino Ratio', '1.78', AppColors.primary),
      ('VaR 95%', '-7.5%', AppColors.sell),
      ('Beta', '1.20', AppColors.buy),
    ];

    return Column(
      children: [
        VitCard(
          padding: _dcaPortfolioHeroPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VitSectionHeader(
                title: 'Đánh giá rủi ro',
                icon: Icons.shield_outlined,
                iconColor: AppColors.sell,
                bottomGap: AppSpacing.pageRhythmStandardInnerGap,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: metrics.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _dcaPortfolioRiskGridColumns,
                  childAspectRatio: _dcaPortfolioRiskGridAspect,
                  crossAxisSpacing: AppSpacing.x3,
                  mainAxisSpacing: AppSpacing.x3,
                ),
                itemBuilder: (context, index) {
                  final metric = metrics[index];
                  return _MiniStatCard(
                    label: metric.$1,
                    value: metric.$2,
                    color: metric.$3,
                  );
                },
              ),
            ],
          ),
        ),
        const Padding(padding: DcaSpacingTokens.dcaTopPaddingX4),
        const _DisclaimerCard(
          text:
              'Các chỉ số dựa trên dữ liệu lịch sử. Hãy đa dạng hóa và chỉ đầu tư số tiền bạn chấp nhận mất.',
        ),
      ],
    );
  }
}
