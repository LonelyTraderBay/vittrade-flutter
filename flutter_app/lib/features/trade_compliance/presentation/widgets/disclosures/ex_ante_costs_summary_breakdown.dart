part of '../../phone/pages/disclosures/ex_ante_costs_page.dart';

class _Summary extends StatelessWidget {
  const _Summary({required this.snapshot});

  final TradeExAnteCostsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final categories = [
      (
        TradeExAnteCostCategory.oneOff,
        'One-off Costs',
        'Costs paid once when entering or exiting the investment',
        _costPrimary,
        _formatEur(snapshot.oneOffCosts),
      ),
      (
        TradeExAnteCostCategory.recurring,
        'Recurring Costs',
        'Costs paid every year while you hold the investment',
        _costAmber,
        '${_formatEur(snapshot.recurringCosts)}/year',
      ),
      (
        TradeExAnteCostCategory.incidental,
        'Incidental Costs',
        'Performance fees (only paid if investment performs well)',
        _costGreen,
        _formatEur(snapshot.incidentalCosts),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Cost Summary',
          accentColor: _costPrimary,
          density: VitDensity.tool,
          children: [
            for (final item in categories)
              _CategoryCard(
                color: item.$4,
                title: item.$2,
                description: item.$3,
                amount: item.$5,
              ),
          ],
        ),
        VitPageSection(
          label: 'Impact on Returns',
          accentColor: _costPrimary,
          density: VitDensity.tool,
          children: [
            _RiyCard(snapshot: snapshot),
            _FullWidthButton(
              key: ExAnteCostsPage.riyKey,
              icon: Icons.calculate_outlined,
              label: 'Use RIY Calculator',
              onPressed: () => context.go(AppRoutePaths.tradeCopyRiyCalculator),
            ),
          ],
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.color,
    required this.title,
    required this.description,
    required this.amount,
  });

  final Color color;
  final String title;
  final String description;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _costBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              VitCard(
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.tight,
                width: _costSwatchExtent,
                height: _costSwatchExtent,
                clip: true,
                background: ColoredBox(color: color),
                child: const SizedBox.shrink(),
              ),
              const SizedBox(width: _costSpace),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                amount,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: _costTinySpace),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              description,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: _costLineTight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiyCard extends StatelessWidget {
  const _RiyCard({required this.snapshot});

  final TradeExAnteCostsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _costBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              VitCard(
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.tight,
                width: _costIconTile,
                height: _costIconTile,
                clip: true,
                background: ColoredBox(color: _costRed.withValues(alpha: .13)),
                child: const Icon(Icons.trending_down_rounded, color: _costRed),
              ),
              const SizedBox(width: _costSpace),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reduction in Yield (RIY)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: _costTinySpace),
                    Text(
                      'How much costs reduce your returns over '
                      '${snapshot.holdingPeriodYears} years',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height: _costLineTight,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${snapshot.reductionInYield.toStringAsFixed(2)}%',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: _costRed,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: _costSpace),
          _WarningBox(
            text:
                'Example: If the investment returns 8% per year, after costs '
                'you would receive approximately '
                '${(8 - snapshot.reductionInYield).toStringAsFixed(2)}% per year.',
          ),
        ],
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.snapshot});

  final TradeExAnteCostsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Detailed Cost Breakdown',
          accentColor: _costPrimary,
          density: VitDensity.tool,
          children: [
            for (final cost in snapshot.costs) _CostItemCard(cost: cost),
          ],
        ),
      ],
    );
  }
}

class _CostItemCard extends StatelessWidget {
  const _CostItemCard({required this.cost});

  final TradeExAnteCostItem cost;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _costBorder.withValues(alpha: .72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cost.type,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            cost.description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _costLineTight,
            ),
          ),
          const SizedBox(height: _costSpace),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Amount',
                  value: _formatEur(cost.amountEur),
                ),
              ),
              const SizedBox(width: _costTinySpace),
              Expanded(
                child: _MetricBox(
                  label: '% of Investment',
                  value: '${cost.percentOfInvestment.toStringAsFixed(2)}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
