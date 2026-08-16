part of '../../phone/pages/staking/staking_proof_of_reserves_page.dart';

class _InnerMetric extends StatelessWidget {
  const _InnerMetric({
    required this.label,
    required this.value,
    this.valueColor,
    this.subtleBuy = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool subtleBuy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: subtleBuy ? AppColors.buy20 : null,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: valueColor ?? AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingProofOfReservesPage.footerKey,
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: VitRiskDisclaimerNote(message: note),
    );
  }
}

String _tabLabel(_ReserveTab tab) {
  return switch (tab) {
    _ReserveTab.overview => 'Overview',
    _ReserveTab.assets => 'By Asset',
    _ReserveTab.verify => 'Verify',
  };
}

_ReserveTab _reserveTabFromKey(String key) {
  return _ReserveTab.values.firstWhere(
    (tab) => tab.name == key,
    orElse: () => _ReserveTab.overview,
  );
}
