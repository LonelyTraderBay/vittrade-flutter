part of '../../phone/pages/portfolio/prediction_market_maker_page.dart';

class _MarketMakerTabBar extends StatelessWidget {
  const _MarketMakerTabBar({required this.activeTab, required this.onChanged});

  final _MarketMakerTab activeTab;
  final ValueChanged<_MarketMakerTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return PredictionEnumTabBar<_MarketMakerTab>(
      activeTab: activeTab,
      onChanged: onChanged,
      showBottomBorder: true,
      items: const [
        (
          PredictionMarketMakerPage.provideTabKey,
          _MarketMakerTab.provide,
          'Cung cap',
        ),
        (
          PredictionMarketMakerPage.positionsTabKey,
          _MarketMakerTab.positions,
          'Vi the',
        ),
        (
          PredictionMarketMakerPage.earningsTabKey,
          _MarketMakerTab.earnings,
          'Thu nhap',
        ),
      ],
    );
  }
}

class _LiquidityOverview extends StatelessWidget {
  const _LiquidityOverview({required this.snapshot});

  final PredictionMarketMakerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: VitDensity.compact.controlHeight,
                child: const Material(
                  color: AppColors.primary08,
                  borderRadius: AppRadii.inputRadius,
                  child: Icon(
                    Icons.water_drop_outlined,
                    color: _predictionPrimary,
                    size: PredictionsSpacingTokens
                        .predictionMarketMakerOverviewIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Liquidity Provider',
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Thu nhap tu phi giao dich',
                      style: AppTextStyles.badge.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Total Provided',
                  value: _formatMoney(snapshot.totalLiquidity),
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Avg APR',
                  value: '${snapshot.averageApr.toStringAsFixed(1)}%',
                  valueColor: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddLiquidityForm extends StatelessWidget {
  const _AddLiquidityForm({
    required this.eventController,
    required this.amountController,
    required this.minDepthController,
    required this.spreadBps,
    required this.onSpreadChanged,
  });

  final TextEditingController eventController;
  final TextEditingController amountController;
  final TextEditingController minDepthController;
  final int spreadBps;
  final ValueChanged<int> onSpreadChanged;

  @override
  Widget build(BuildContext context) {
    final hasAmount = amountController.text.trim().isNotEmpty;
    final amount = double.tryParse(amountController.text) ?? 0;

    return VitPageSection(
      label: 'Them thanh khoan',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              _MarketInput(
                label: 'Liquidity Amount (USD)',
                controller: amountController,
                fieldKey: PredictionMarketMakerPage.amountFieldKey,
                hintText: '0.00',
                numeric: true,
                prefix: const Icon(
                  Icons.attach_money_rounded,
                  color: AppColors.text3,
                  size: PredictionsSpacingTokens
                      .predictionMarketMakerInputPrefixIcon,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _MarketInput(label: 'Select Event', controller: eventController),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _SpreadSelector(value: spreadBps, onChanged: onSpreadChanged),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _MarketInput(
                label: 'Minimum Depth (USD)',
                controller: minDepthController,
                numeric: true,
              ),
              const SizedBox(height: AppSpacing.x1),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Thanh khoan toi thieu moi ben',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              if (hasAmount) ...[
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                _EstimatedReturns(amount: amount),
              ],
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _AddLiquidityButton(enabled: hasAmount),
            ],
          ),
        ),
      ],
    );
  }
}

class _MarketInput extends StatelessWidget {
  const _MarketInput({
    required this.label,
    required this.controller,
    this.fieldKey,
    this.hintText = '',
    this.numeric = false,
    this.prefix,
  });

  final String label;
  final TextEditingController controller;
  final Key? fieldKey;
  final String hintText;
  final bool numeric;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.badge.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x1),
        VitInput(
          fieldKey: fieldKey,
          controller: controller,
          keyboardType: numeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          inputFormatters: numeric
              ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
              : null,
          semanticLabel: label,
          hintText: hintText,
          prefix: prefix,
          textStyle: AppTextStyles.body.copyWith(
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ],
    );
  }
}

class _SpreadSelector extends StatelessWidget {
  const _SpreadSelector({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Spread (basis points)',
          style: AppTextStyles.badge.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x1),
        Row(
          children: [
            for (final bps in [25, 50, 100, 200]) ...[
              Expanded(
                child: _SpreadButton(
                  key: _spreadKey(bps),
                  value: bps,
                  selected: value == bps,
                  onTap: () => onChanged(bps),
                ),
              ),
              if (bps != 200) const SizedBox(width: AppSpacing.x2),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Hieu gia bid/ask: ${(value / 100).toStringAsFixed(2)}%',
          style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _SpreadButton extends StatelessWidget {
  const _SpreadButton({
    super.key,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final int value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: '$value',
      selected: selected,
      onTap: onTap,
      accentColor: _predictionPrimary,
      fullWidth: true,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x2),
    );
  }
}
