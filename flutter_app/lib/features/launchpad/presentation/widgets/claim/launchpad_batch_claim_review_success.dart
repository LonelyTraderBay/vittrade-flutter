part of '../../phone/pages/claim/launchpad_batch_claim_page.dart';

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({
    required this.positions,
    required this.summary,
    required this.onBack,
    required this.onConfirm,
  });

  final List<LaunchpadBatchClaimPositionDraft> positions;
  final LaunchpadBatchClaimSummaryDraft summary;
  final VoidCallback onBack;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: LaunchpadBatchClaimPage.reviewKey,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: LaunchpadSpacingTokens.launchpadPaddingX5,
          child: Column(
            children: [
              const Icon(
                Icons.layers_outlined,
                color: AppColors.buy,
                size: AppSpacing.iconLg,
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Text(
                'Xác nhận nhận hàng loạt',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'Nhận phần thưởng từ ${positions.length} vị trí cùng lúc',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
              for (final entry in summary.totalClaimable.entries)
                _ReviewTotalRow(token: entry.key, amount: entry.value),
              const Divider(color: AppColors.divider),
              _ReviewTotalRow(
                token: 'Tổng giá trị',
                amount: summary.totalClaimableUsd,
                usd: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitHighRiskStatePanel(
          key: LaunchpadBatchClaimPage.reviewStateKey,
          state: VitHighRiskUiState.riskReview,
          title: 'Rà soát trước khi nhận',
          message:
              'Kiểm tra token, chuỗi, gas và tổng giá trị trước khi xác nhận nhận hàng loạt.',
          contractId:
              'SC-304 / ${positions.length} positions / ${summary.chains.join(', ')}',
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Row(
          children: [
            Expanded(
              child: VitCtaButton(
                variant: VitCtaButtonVariant.ghost,
                onPressed: onBack,
                child: const Text('Quay lại'),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                variant: VitCtaButtonVariant.success,
                onPressed: onConfirm,
                child: const Text('Nhận tất cả'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewTotalRow extends StatelessWidget {
  const _ReviewTotalRow({
    required this.token,
    required this.amount,
    this.usd = false,
  });

  final String token;
  final double amount;
  final bool usd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX2,
      child: Row(
        children: [
          Expanded(
            child: Text(
              token,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            usd ? _formatUsd(amount) : _formatNumber(amount),
            style: AppTextStyles.base.copyWith(
              color: usd ? AppColors.buy : AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

LaunchpadBatchClaimSummaryDraft _summaryFor(
  List<LaunchpadBatchClaimPositionDraft> positions,
) {
  final totals = <String, double>{};
  var totalUsd = 0.0;
  final chains = <String>{};
  for (final position in positions) {
    totals[position.rewardToken] =
        (totals[position.rewardToken] ?? 0) + position.claimableAmount;
    totalUsd += position.claimableUsd;
    chains.add(position.chain);
  }
  final individualGas = positions.length * .18;
  final batchGas = positions.isEmpty ? 0.0 : .18 + (positions.length - 1) * .06;
  final savings = individualGas - batchGas;
  return LaunchpadBatchClaimSummaryDraft(
    totalClaimable: totals,
    totalClaimableUsd: _round2(totalUsd),
    estimatedGasIndividual: _formatUsd(individualGas),
    estimatedGasBatch: _formatUsd(batchGas),
    gasSavingsPercent: individualGas == 0
        ? 0
        : ((savings / individualGas) * 100).round(),
    gasSavingsUsd: _round2(savings),
    chains: chains.toList(),
  );
}

String _avatarLabel(String symbol) {
  return symbol.length > 2 ? symbol.substring(0, 2) : symbol;
}

String _formatUsd(double value) {
  final formatted = _trimDouble(value);
  return '\$$formatted';
}

String _formatNumber(num value) {
  final fixed = value is int || value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1 && parts.last.isNotEmpty) {
    buffer.write('.');
    buffer.write(parts.last);
  }
  return buffer.toString();
}

String _trimDouble(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
}

double _round2(double value) => (value * 100).round() / 100;
