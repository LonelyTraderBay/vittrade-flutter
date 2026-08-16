part of '../../phone/pages/portfolio/price_alerts_page.dart';

class _AddAlertNotice extends StatelessWidget {
  const _AddAlertNotice();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppColors.surface3,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: AppColors.cardBorder),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Padding(
          padding: _alertsNoticePadding,
          child: Text(
            'T\u1EA1o c\u1EA3nh b\u00E1o m\u1EDBi s\u1EBD \u0111\u01B0\u1EE3c b\u1ED5 sung sau',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              height: _alertsLineHeightCaption,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsSummary extends StatelessWidget {
  const _StatsSummary({
    required this.total,
    required this.active,
    required this.triggered,
  });

  final int total;
  final int active;
  final int triggered;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            label: 'T\u1ED5ng',
            value: '$total',
            valueKey: PriceAlertsPage.totalCountKey,
          ),
        ),
        const SizedBox(width: _alertsStatGap),
        Expanded(
          child: _StatBox(
            label: 'Ho\u1EA1t \u0111\u1ED9ng',
            value: '$active',
            valueColor: AppColors.buy,
            valueKey: PriceAlertsPage.activeCountKey,
          ),
        ),
        const SizedBox(width: _alertsStatGap),
        Expanded(
          child: _StatBox(
            label: '\u0110\u00E3 k\u00EDch ho\u1EA1t',
            value: '$triggered',
            valueColor: _marketPrimary,
            valueKey: PriceAlertsPage.triggeredCountKey,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.valueKey,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface3,
      borderRadius: AppRadii.cardRadius,
      child: SizedBox(
        height: _alertsStatHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: _alertsLineHeightTight,
              ),
            ),
            const SizedBox(height: _alertsStatLabelGap),
            Text(
              value,
              key: valueKey,
              style: AppTextStyles.sectionTitle.copyWith(
                color: valueColor,
                fontFeatures: AppTextStyles.tabularFigures,
                height: _alertsLineHeightTight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
