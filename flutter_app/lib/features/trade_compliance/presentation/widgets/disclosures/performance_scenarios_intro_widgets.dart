part of '../../phone/pages/disclosures/performance_scenarios_page.dart';

class _WarningNotice extends StatelessWidget {
  const _WarningNotice();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _scenarioAmber.withValues(alpha: .38),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _scenarioAmber,
            size: AppSpacing.x4,
          ),
          const SizedBox(width: _scenarioSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Not a Guarantee',
                  style: AppTextStyles.badge.copyWith(
                    color: _scenarioAmber,
                    height: _scenarioLineTight,
                  ),
                ),
                const SizedBox(height: _scenarioTinySpace),
                Text(
                  'These scenarios are illustrations based on past '
                  'performance and statistical models. Actual results may '
                  'differ significantly.',
                  style: AppTextStyles.micro.copyWith(
                    color: _scenarioAmber,
                    fontWeight: AppTextStyles.medium,
                    height: _scenarioLineTight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvestmentCard extends StatelessWidget {
  const _InvestmentCard({required this.investment});

  final double investment;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _scenarioBorder.withValues(alpha: .76),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: _scenarioPrimary,
            size: AppSpacing.x4,
          ),
          const SizedBox(width: _scenarioSpace),
          Expanded(
            child: Text(
              'Example Investment',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: _scenarioLineTight,
              ),
            ),
          ),
          Text(
            _formatEur(investment),
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _HoldingPeriodSelector extends StatelessWidget {
  const _HoldingPeriodSelector({
    required this.periods,
    required this.selectedPeriod,
    required this.onChanged,
  });

  final List<int> periods;
  final int selectedPeriod;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      tabs: [
        for (final period in periods)
          VitTabItem(
            key: '$period',
            label: '$period ${period == 1 ? 'Year' : 'Years'}',
            widgetKey: PerformanceScenariosPage.periodKey(period),
          ),
      ],
      activeKey: '$selectedPeriod',
      onChanged: (value) => onChanged(int.parse(value)),
    );
  }
}
