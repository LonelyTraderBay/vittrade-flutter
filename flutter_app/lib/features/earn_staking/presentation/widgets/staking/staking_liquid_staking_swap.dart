part of '../../phone/pages/staking/staking_liquid_staking_page.dart';

class _SwapTab extends StatelessWidget {
  const _SwapTab({
    required this.snapshot,
    required this.swapFrom,
    required this.swapTo,
    required this.amountController,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onAmountChanged,
    required this.onReverse,
  });

  final StakingLiquidStakingSnapshot snapshot;
  final String swapFrom;
  final String swapTo;
  final TextEditingController amountController;
  final ValueChanged<String> onFromChanged;
  final ValueChanged<String> onToChanged;
  final ValueChanged<String> onAmountChanged;
  final VoidCallback onReverse;

  @override
  Widget build(BuildContext context) {
    final fromToken = snapshot.tokenBySymbol(swapFrom);
    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    final receive = amount * (fromToken?.exchangeRate ?? 1);
    final minReceive = receive * (1 - snapshot.slippageTolerance / 100);
    final canSwap = amount > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          key: StakingLiquidStakingPage.swapCardKey,
          radius: VitCardRadius.large,
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SwapRow(
                label: 'Từ',
                selected: swapFrom,
                options: snapshot.swapFromOptions,
                amountController: amountController,
                amountKey: StakingLiquidStakingPage.swapAmountKey,
                onSelected: onFromChanged,
                onAmountChanged: onAmountChanged,
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Center(
                child: VitCtaButton(
                  variant: VitCtaButtonVariant.secondary,
                  fullWidth: false,
                  height: AppSpacing.buttonCompact,
                  padding: AppSpacing.zeroInsets.copyWith(
                    left: AppSpacing.x4,
                    right: AppSpacing.x4,
                  ),
                  onPressed: onReverse,
                  child: const Icon(Icons.swap_vert_rounded),
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              _ReceiveRow(
                label: 'Sang',
                selected: swapTo,
                options: snapshot.swapToOptions,
                receive: receive,
                onSelected: onToChanged,
              ),
              if (canSwap) ...[
                const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
                _SwapSummary(
                  key: StakingLiquidStakingPage.swapSummaryKey,
                  swapFrom: swapFrom,
                  swapTo: swapTo,
                  rate: fromToken?.exchangeRate ?? 1,
                  slippage: snapshot.slippageTolerance,
                  minReceive: minReceive,
                  gasFee: snapshot.estimatedGasFee,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCtaButton(
          onPressed: canSwap ? () {} : null,
          child: Text('Swap $swapFrom → $swapTo'),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.primary20,
          padding: AppSpacing.cardPadding,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Gợi ý: ',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                TextSpan(
                  text: snapshot.swapNote,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SwapSummary extends StatelessWidget {
  const _SwapSummary({
    super.key,
    required this.swapFrom,
    required this.swapTo,
    required this.rate,
    required this.slippage,
    required this.minReceive,
    required this.gasFee,
  });

  final String swapFrom;
  final String swapTo;
  final double rate;
  final double slippage;
  final double minReceive;
  final double gasFee;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: AppSpacing.cardPadding,
      child: Column(
        children: [
          _SheetRow(
            label: 'Exchange Rate',
            value: '1 $swapFrom = $rate $swapTo',
          ),
          _SheetRow(
            label: 'Slippage Tolerance',
            value: '${slippage.toStringAsFixed(1)}%',
          ),
          _SheetRow(
            label: 'Minimum Received',
            value: '${minReceive.toStringAsFixed(6)} $swapTo',
            valueColor: AppColors.warn,
          ),
          _SheetRow(label: 'Gas Fee', value: '~${_formatUsd(gasFee)}'),
        ],
      ),
    );
  }
}
