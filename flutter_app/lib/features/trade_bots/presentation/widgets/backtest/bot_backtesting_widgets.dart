part of '../../phone/pages/backtest/bot_backtesting_page.dart';

class _StrategyGrid extends StatelessWidget {
  const _StrategyGrid({
    required this.strategies,
    required this.selectedId,
    required this.onChanged,
  });

  final List<TradeBotBacktestStrategy> strategies;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - TradeSpacingTokens.tradeBotRowGap) /
            TradeSpacingTokens.tradeBotGridColumns;
        return Wrap(
          spacing: TradeSpacingTokens.tradeBotRowGap,
          runSpacing: TradeSpacingTokens.tradeBotRowGap,
          children: [
            for (final strategy in strategies)
              _StrategyButton(
                width: itemWidth,
                widgetKey: BotBacktestingPage.strategyKey(strategy.id),
                strategy: strategy,
                selected: strategy.id == selectedId,
                onTap: () => onChanged(strategy.id),
              ),
          ],
        );
      },
    );
  }
}

class _StrategyButton extends StatelessWidget {
  const _StrategyButton({
    required this.widgetKey,
    required this.width,
    required this.strategy,
    required this.selected,
    required this.onTap,
  });

  final Key widgetKey;
  final double width;
  final TradeBotBacktestStrategy strategy;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    return VitCard(
      key: widgetKey,
      width: width,
      onTap: onTap,
      variant: selected ? VitCardVariant.ghost : VitCardVariant.inner,
      radius: VitCardRadius.tight,
      borderColor: selected ? color : AppColors.borderSolid,
      padding: TradeSpacingTokens.tradeBotChipPadding,
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: TradeSpacingTokens.tradeBotInlineIconGap),
          Expanded(
            child: Text(
              strategy.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: selected ? color : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PairGrid extends StatelessWidget {
  const _PairGrid({
    required this.pairs,
    required this.selectedPair,
    required this.onChanged,
  });

  final List<String> pairs;
  final String selectedPair;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: TradeSpacingTokens.tradeBotRowGap,
      children: [
        for (final pair in pairs)
          VitChoicePill(
            key: BotBacktestingPage.pairKey(pair),
            label: pair,
            selected: pair == selectedPair,
            onTap: () => onChanged(pair),
            accentColor: _backtestPrimary,
          ),
      ],
    );
  }
}

class _DateRangeGrid extends StatelessWidget {
  const _DateRangeGrid({
    required this.ranges,
    required this.selectedId,
    required this.onChanged,
  });

  final List<TradeBotBacktestDateRange> ranges;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final range in ranges) ...[
          Expanded(
            child: VitChoicePill(
              key: BotBacktestingPage.rangeKey(range.id),
              label: range.label,
              selected: range.id == selectedId,
              onTap: () => onChanged(range.id),
              accentColor: _backtestPrimary,
              fullWidth: true,
            ),
          ),
          if (range != ranges.last)
            const SizedBox(width: TradeSpacingTokens.tradeBotSmallGap),
        ],
      ],
    );
  }
}

class _CapitalInput extends StatelessWidget {
  const _CapitalInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return VitInput(
      controller: controller,
      fieldKey: BotBacktestingPage.capitalKey,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      suffix: Text(
        'USDT',
        style: AppTextStyles.caption.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _BacktestPeriodCard extends StatelessWidget {
  const _BacktestPeriodCard({
    required this.strategyId,
    required this.pair,
    required this.range,
    required this.capital,
  });

  final String strategyId;
  final String pair;
  final TradeBotBacktestDateRange range;
  final String capital;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPadding,
      borderColor: _backtestPrimary.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: _backtestPrimary,
            size: 18,
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotCardIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Giai đoạn kiểm thử',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TradeSpacingTokens.tradeBotSmallGap),
                Text(
                  'Đang kiểm thử chiến lược ${strategyId.toUpperCase()} trên $pair từ ${range.periodLabel} với vốn ban đầu \$$capital.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RunFooter extends StatelessWidget {
  const _RunFooter({required this.onRun});

  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: TradeSpacingTokens.tradeBotControlTall,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotFooterPadding,
      child: VitCtaButton(
        key: BotBacktestingPage.runKey,
        onPressed: onRun,
        height: TradeSpacingTokens.tradeBotFooterButtonHeight,
        leading: const Icon(Icons.play_arrow_outlined, size: 19),
        child: Text(
          'Chạy kiểm thử chiến lược',
          style: AppTextStyles.control.copyWith(
            color: AppColors.onAccent,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
