part of '../../phone/pages/savings/savings_recommendations_page.dart';

class _CompareSheet extends StatelessWidget {
  const _CompareSheet({required this.strategies, required this.amount});

  final List<SavingsStrategyDraft> strategies;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'So sánh Chiến lược',
                style: AppTextStyles.sectionTitle,
              ),
            ),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Đóng',
              onPressed: () => Navigator.of(context).pop(),
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.md,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _CompareRow(
          label: '',
          values: [for (final strategy in strategies) strategy.title],
          header: true,
        ),
        _CompareRow(
          label: 'APY ước tính',
          values: [
            for (final strategy in strategies)
              _formatPercent(strategy.expectedApy),
          ],
          color: AppColors.buy,
        ),
        _CompareRow(
          label: 'Thanh khoản',
          values: [
            for (final strategy in strategies) '${strategy.liquidityRatio}%',
          ],
          color: AppColors.primary,
        ),
        _CompareRow(
          label: 'Match',
          values: [
            for (final strategy in strategies) '${strategy.matchScore}%',
          ],
          color: AppColors.accent,
        ),
        _CompareRow(
          label: 'Rủi ro',
          values: [
            for (final strategy in strategies)
              _strategyRiskLabel(strategy.riskLevel),
          ],
        ),
        _CompareRow(
          label: 'Lãi/năm',
          values: [
            for (final strategy in strategies)
              '+${_formatUsd(amount * strategy.expectedApy / 100)}',
          ],
          color: AppColors.buy,
        ),
      ],
    );
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow({
    required this.label,
    required this.values,
    this.color,
    this.header = false,
  });

  final String label;
  final List<String> values;
  final Color? color;
  final bool header;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EarnSpacingTokens.earnVerticalPaddingX2,
      child: Row(
        children: [
          SizedBox(
            width: EarnSpacingTokens.savingsRecommendationsMatrixLabelWidth,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          for (final value in values)
            Expanded(
              child: Text(
                value,
                maxLines: header ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: color ?? (header ? AppColors.text1 : AppColors.text2),
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
