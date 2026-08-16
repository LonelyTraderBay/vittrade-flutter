part of '../../phone/pages/savings/savings_auto_rebalance_page.dart';

class _StrategyList extends StatelessWidget {
  const _StrategyList({
    required this.snapshot,
    required this.activeId,
    required this.onChanged,
  });

  final SavingsAutoRebalanceSnapshot snapshot;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Chiến lược đề xuất',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [
        for (final strategy in snapshot.strategies)
          _StrategyCard(
            strategy: strategy,
            active: strategy.id == activeId,
            onTap: () => onChanged(strategy.id),
          ),
      ],
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.strategy,
    required this.active,
    required this.onTap,
  });

  final SavingsRebalanceStrategyDraft strategy;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(strategy.riskLevel);

    return VitCard(
      key: SavingsAutoRebalancePage.strategyKey(strategy.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX3,
      borderColor: active ? color.withValues(alpha: .42) : null,
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: _savingsRebalanceIconBox,
                child: Material(
                  color: color.withValues(alpha: .14),
                  borderRadius: AppRadii.mdRadius,
                  child: Icon(_riskIcon(strategy.riskLevel), color: color),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            strategy.name,
                            style: _captionMedium.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        VitAccentPill(
                          label: _riskLabel(strategy.riskLevel),
                          accentColor: color,
                          size: VitStatusPillSize.sm,
                        ),
                        if (active) ...[
                          const SizedBox(width: AppSpacing.x2),
                          Icon(
                            Icons.check_circle_rounded,
                            color: color,
                            size: _savingsRebalanceSelectedIcon,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      strategy.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${strategy.expectedApy.toStringAsFixed(2)}%',
                    style: _captionMedium.copyWith(color: color),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          if (active) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            ClipRRect(
              borderRadius: AppRadii.xlRadius,
              child: Row(
                children: [
                  for (final entry in strategy.allocations.entries)
                    Expanded(
                      flex: entry.value.round().clamp(1, 100).toInt(),
                      child: ColoredBox(
                        color: _assetColorName(entry.key),
                        child: const SizedBox(
                          height: _savingsRebalanceTrackHeight,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StrategyComparison extends StatelessWidget {
  const _StrategyComparison({required this.strategies});

  final List<SavingsRebalanceStrategyDraft> strategies;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: _savingsRebalanceCardPadding,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        density: VitDensity.compact,
        children: [
          const VitSectionHeader(
            title: 'So sánh chiến lược',
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.primary,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          for (final row in [
            ('APY', [for (final item in strategies) '${item.expectedApy}%']),
            (
              'Rủi ro',
              [for (final item in strategies) _riskLabel(item.riskLevel)],
            ),
            (
              'Stablecoin',
              [
                for (final item in strategies)
                  '${item.allocations['USDT']?.toStringAsFixed(0)}%',
              ],
            ),
            (
              'BTC',
              [
                for (final item in strategies)
                  '${item.allocations['BTC']?.toStringAsFixed(0)}%',
              ],
            ),
          ])
            _CompareRow(label: row.$1, values: row.$2),
        ],
      ),
    );
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow({required this.label, required this.values});

  final String label;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnVerticalPaddingX2,
      child: Row(
        children: [
          SizedBox(
            width: _savingsRebalanceCompareLabelWidth,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          for (final value in values)
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: _captionMedium.copyWith(color: AppColors.text1),
              ),
            ),
        ],
      ),
    );
  }
}

Color _riskColor(SavingsRebalanceRiskLevel risk) {
  switch (risk) {
    case SavingsRebalanceRiskLevel.low:
      return AppColors.buy;
    case SavingsRebalanceRiskLevel.medium:
      return AppColors.primary;
    case SavingsRebalanceRiskLevel.high:
      return AppColors.sell;
  }
}

String _riskLabel(SavingsRebalanceRiskLevel risk) {
  switch (risk) {
    case SavingsRebalanceRiskLevel.low:
      return 'Thấp';
    case SavingsRebalanceRiskLevel.medium:
      return 'Trung bình';
    case SavingsRebalanceRiskLevel.high:
      return 'Cao';
  }
}

IconData _riskIcon(SavingsRebalanceRiskLevel risk) {
  switch (risk) {
    case SavingsRebalanceRiskLevel.low:
      return Icons.shield_outlined;
    case SavingsRebalanceRiskLevel.medium:
      return Icons.adjust_rounded;
    case SavingsRebalanceRiskLevel.high:
      return Icons.trending_up_rounded;
  }
}
