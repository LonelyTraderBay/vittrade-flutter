part of '../../phone/pages/tools/wallet_gas_optimizer_page.dart';

class _TrendsTab extends StatelessWidget {
  const _TrendsTab({required this.snapshot});

  final WalletGasOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: sectionChildren,
    );
  }

  List<Widget> get sectionChildren => [
    _ChartCard(
      title: '24h Gas Price Trends',
      height: VitDensity.compact.controlHeight * 3.2,
      child: CustomPaint(
        painter: _GasLineChartPainter(points: snapshot.history),
      ),
    ),
    _ChartCard(
      title: 'Network Activity',
      height: VitDensity.compact.controlHeight * 2.5,
      child: CustomPaint(
        painter: _NetworkBarChartPainter(points: snapshot.networkActivity),
      ),
    ),
    const _BestTimeCard(),
  ];
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.height,
    required this.child,
  });

  final String title;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: height,
      density: VitDensity.compact,
      borderColor: _gasBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _BestTimeCard extends StatelessWidget {
  const _BestTimeCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _gasGreen.withValues(alpha: .22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: _gasGreen,
                size: WalletSpacingTokens.walletGasIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lower Activity Window',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Historically, fees have often been lower between 2 AM - 6 AM UTC. Confirm live fees before signing.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const Row(
            children: [
              Expanded(
                child: _BestTimeMetric(
                  label: 'Historical low',
                  value: '12 Gwei',
                ),
              ),
              SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _BestTimeMetric(
                  label: 'Observed variance',
                  value: '~52%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BestTimeMetric extends StatelessWidget {
  const _BestTimeMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: _gasGreen,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
