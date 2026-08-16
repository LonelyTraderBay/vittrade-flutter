part of '../../phone/pages/tools/launchpad_gas_tracker_page.dart';

const double _gasChartExtent =
    AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x5 + AppSpacing.x4;

class _PricesTab extends StatelessWidget {
  const _PricesTab({
    required this.prices,
    required this.selectedGas,
    required this.selectedChain,
    required this.onSelected,
  });

  final List<LaunchpadGasPriceDraft> prices;
  final LaunchpadGasPriceDraft selectedGas;
  final String selectedChain;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChainSelector(
          prices: prices,
          selectedChain: selectedChain,
          onSelected: onSelected,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _GasChartCard(price: selectedGas),
        if (selectedGas.baseFee != null && selectedGas.priorityFee != null) ...[
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _Eip1559Card(price: selectedGas),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _AllChainsSection(
          prices: prices,
          selectedChain: selectedChain,
          onSelected: onSelected,
        ),
      ],
    );
  }
}

class _ChainSelector extends StatelessWidget {
  const _ChainSelector({
    required this.prices,
    required this.selectedChain,
    required this.onSelected,
  });

  final List<LaunchpadGasPriceDraft> prices;
  final String selectedChain;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: LaunchpadGasTrackerPage.chainSelectorKey,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final price in prices) ...[
            VitChoicePill(
              key: LaunchpadGasTrackerPage.chainKey(price.chain),
              label: price.chain,
              accentColor: price.accent.resolve(),
              selected: selectedChain == price.chain,
              onTap: () => onSelected(price.chain),
              padding: LaunchpadSpacingTokens.launchpadPillPadding,
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _GasChartCard extends StatelessWidget {
  const _GasChartCard({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.chartKey,
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gas 24h - ${price.chain}',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          SizedBox(
            height: _gasChartExtent,
            child: CustomPaint(
              painter: _GasChartPainter(price),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Eip1559Card extends StatelessWidget {
  const _Eip1559Card({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.eipKey,
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EIP-1559',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _FeeBox(
                  label: 'Base Fee',
                  value: _formatGasValue(price.baseFee ?? 0),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _FeeBox(
                  label: 'Priority Fee',
                  value: _formatGasValue(price.priorityFee ?? 0),
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeeBox extends StatelessWidget {
  const _FeeBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .08),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadPaddingX3,
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.base.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}
