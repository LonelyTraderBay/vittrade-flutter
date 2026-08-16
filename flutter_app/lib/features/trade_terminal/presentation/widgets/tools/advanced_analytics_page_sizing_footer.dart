part of '../../phone/pages/tools/advanced_analytics_page.dart';

class _PositionSizingTab extends StatelessWidget {
  const _PositionSizingTab({required this.snapshot});

  final TradeAdvancedAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final sizing = snapshot.sizing;
    final riskAmount = sizing.accountBalance * sizing.recommendedRiskPct / 100;
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        _Card(
          child: VitPageContent(
            rhythm: VitPageRhythm.standard,
            padding: VitContentPadding.none,
            fullBleed: true,
            density: VitDensity.tool,
            children: [
              const _SectionHeader(
                icon: Icons.calculate_outlined,
                color: _advancedAmber,
                title: 'Position Sizing Calculator',
                subtitle: 'Kelly Criterion optimization',
              ),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'Balance',
                      value: '\$${_formatCompact(sizing.accountBalance)}',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBox(
                      label: 'Risk',
                      value: '${sizing.recommendedRiskPct.toStringAsFixed(0)}%',
                      valueColor: _advancedAmber,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBox(
                      label: 'Max Loss',
                      value: '\$${riskAmount.toStringAsFixed(0)}',
                      valueColor: _advancedRed,
                    ),
                  ),
                ],
              ),
              _MetricBox(
                label: 'Suggested Position Size',
                value: '${sizing.positionSize.toStringAsFixed(2)} BTC',
                valueColor: _advancedPrimary,
                alignLeft: true,
              ),
            ],
          ),
        ),
        const _InfoCard(
          color: _advancedAmber,
          icon: Icons.calculate_outlined,
          title: 'Kelly Criterion Optimization',
          body:
              'Kelly percent is capped at half-Kelly for safety and adjusted by your actual win rate and R:R ratio.',
        ),
      ],
    );
  }
}

class _ModelInfoCard extends StatelessWidget {
  const _ModelInfoCard();

  @override
  Widget build(BuildContext context) {
    return const _InfoCard(
      color: _advancedPurple,
      icon: Icons.psychology_rounded,
      title: 'AI Model: GPT-4 + TradingView Integration',
      body:
          'Signals generated using technical indicators, on-chain data, sentiment analysis and volume profiling.',
    );
  }
}

class _FeaturesCard extends StatelessWidget {
  const _FeaturesCard({required this.features});

  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          Text(
            'Features Included',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          GridView.builder(
            itemCount: features.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: TradeSpacingTokens.tradeBotGridColumns,
              mainAxisExtent:
                  AppSpacing.buttonCompact + AppSpacing.hairlineStroke * 2,
              crossAxisSpacing: TradeSpacingTokens.tradeBotSmallGap,
              mainAxisSpacing: TradeSpacingTokens.tradeBotSmallGap,
            ),
            itemBuilder: (context, index) {
              return VitCard(
                variant: VitCardVariant.inner,
                density: VitDensity.tool,
                radius: VitCardRadius.tight,
                child: Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: _advancedGreen,
                      size: AppSpacing.x2 + AppSpacing.hairlineStroke,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        features[index],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
