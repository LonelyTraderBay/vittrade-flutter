part of '../../phone/pages/disclosures/ex_ante_costs_page.dart';

class _Scenarios extends StatelessWidget {
  const _Scenarios({
    required this.snapshot,
    required this.holdingPeriod,
    required this.onChanged,
  });

  final TradeExAnteCostsSnapshot snapshot;
  final int holdingPeriod;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final total =
        snapshot.oneOffCosts +
        (snapshot.recurringCosts * holdingPeriod) +
        (snapshot.incidentalCosts * holdingPeriod);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Cost Scenarios by Holding Period',
          accentColor: _costPrimary,
          density: VitDensity.tool,
          children: [
            Row(
              children: [
                for (final period in const [1, 3, 5]) ...[
                  Expanded(
                    child: _PeriodButton(
                      label: '$period ${period == 1 ? 'Year' : 'Years'}',
                      selected: holdingPeriod == period,
                      onPressed: () => onChanged(period),
                    ),
                  ),
                  if (period != 5) const SizedBox(width: _costTinySpace),
                ],
              ],
            ),
            VitCard(
              radius: VitCardRadius.tight,
              density: VitDensity.tool,
              padding: AppSpacing.cardPaddingCompact,
              borderColor: _costBorder.withValues(alpha: .72),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Total Costs Over $holdingPeriod '
                    '${holdingPeriod == 1 ? 'Year' : 'Years'}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: _costSpace),
                  _ScenarioRow(
                    label: 'One-off Costs',
                    value: snapshot.oneOffCosts,
                  ),
                  _ScenarioRow(
                    label: 'Recurring Costs ($holdingPeriod years)',
                    value: snapshot.recurringCosts * holdingPeriod,
                  ),
                  _ScenarioRow(
                    label: 'Incidental Costs (estimated)',
                    value: snapshot.incidentalCosts * holdingPeriod,
                  ),
                  VitCard(
                    variant: VitCardVariant.inner,
                    radius: VitCardRadius.tight,
                    margin: AppSpacing.zeroInsets.copyWith(top: _costTinySpace),
                    padding: AppSpacing.cardPaddingCompact,
                    borderColor: _costRed.withValues(alpha: .28),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Total',
                            style: AppTextStyles.caption.copyWith(
                              color: _costRed,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        Text(
                          _formatEur(total),
                          style: AppTextStyles.baseMedium.copyWith(
                            color: _costRed,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickLinkButton(
            key: ExAnteCostsPage.exPostKey,
            icon: Icons.description_outlined,
            label: 'Ex-Post Report',
            color: _costPrimary,
            onPressed: () =>
                context.go(AppRoutePaths.tradeCopyExPostCostsReport),
          ),
        ),
        const SizedBox(width: _costSpace),
        Expanded(
          child: _QuickLinkButton(
            key: ExAnteCostsPage.kidKey,
            icon: Icons.bar_chart_rounded,
            label: 'View KID',
            color: _costGreen,
            onPressed: () => context.go(AppRoutePaths.tradeCopyKidGenerator),
          ),
        ),
      ],
    );
  }
}

class _QuickLinkButton extends StatelessWidget {
  const _QuickLinkButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onPressed,
      variant: VitCtaButtonVariant.secondary,
      height: _costButtonExtent,
      density: VitDensity.tool,
      leading: Icon(icon, color: color, size: AppSpacing.x4),
      trailing: const Icon(Icons.chevron_right_rounded),
      child: Text(label),
    );
  }
}

class _FullWidthButton extends StatelessWidget {
  const _FullWidthButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onPressed,
      variant: VitCtaButtonVariant.secondary,
      height: _costButtonExtent,
      density: VitDensity.tool,
      leading: Icon(icon, size: AppSpacing.x4),
      child: Text(label),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _costLineTight,
            ),
          ),
          const SizedBox(height: _costTinySpace),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _costAmber.withValues(alpha: .28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _costAmber,
            size: AppSpacing.x4,
          ),
          const SizedBox(width: _costSpace),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _costAmber,
                fontWeight: AppTextStyles.bold,
                height: _costLineTight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  const _PeriodButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: selected,
      onTap: onPressed,
      accentColor: _costPrimary,
      fullWidth: true,
    );
  }
}

class _ScenarioRow extends StatelessWidget {
  const _ScenarioRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      margin: AppSpacing.zeroInsets.copyWith(bottom: _costTinySpace),
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            _formatEur(value),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
