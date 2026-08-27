part of 'markets_pair_detail_pane.dart';

/// Port tablet của `_PriceOverview` Phone: giá hiện tại + pill biến động +
/// 3 chỉ số 24h, đóng bằng hairline divider.
class MarketsPairPriceOverviewPanel extends StatelessWidget {
  const MarketsPairPriceOverviewPanel({super.key, required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    final positive = pair.change24h >= 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: MarketsSpacingTokens.pairPriceOverviewPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      formatMarketPriceFixed2(pair.price),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.amountLg.copyWith(
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: MarketsSpacingTokens.pairPriceChangeGap,
                  ),
                  VitAccentPill(
                    label:
                        '${positive ? '▲' : '▼'} ${pair.change24h.abs().toStringAsFixed(2)}%',
                    accentColor: positive ? AppColors.buy : AppColors.sell,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Row(
                children: [
                  Expanded(
                    child: _PriceStat(
                      label: '24h Cao',
                      value: formatMarketPriceFixed2(pair.high24h),
                      color: AppColors.buy,
                    ),
                  ),
                  Expanded(
                    child: _PriceStat(
                      label: '24h Thấp',
                      value: formatMarketPriceFixed2(pair.low24h),
                      color: AppColors.sell,
                    ),
                  ),
                  Expanded(
                    child: _PriceStat(
                      label: 'KL 24h',
                      value: formatMarketCompact(pair.volume24h, prefix: '\$'),
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.divider,
          height: AppSpacing.dividerHairline,
        ),
      ],
    );
  }
}

class _PriceStat extends StatelessWidget {
  const _PriceStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.numericMicro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

/// Port tablet của `_ViewTabs` Phone — VitTabBar underline 3 khung nhìn,
/// key theo `MarketsTabletKeys.pairViewTab`.
class _PairViewTabs extends StatelessWidget {
  const _PairViewTabs({required this.activeView, required this.onChanged});

  final MarketsPairView activeView;
  final ValueChanged<MarketsPairView> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: MarketsSpacingTokens.marketDepthTabsHeight,
        child: Column(
          children: [
            Expanded(
              child: VitTabBar(
                activeKey: marketsPairViewKey(activeView),
                variant: VitTabBarVariant.underline,
                onChanged: (key) => onChanged(marketsPairViewFromKey(key)),
                tabs: [
                  VitTabItem(
                    key: 'chart',
                    label: 'Biểu đồ',
                    icon: Icons.show_chart_rounded,
                    widgetKey: MarketsTabletKeys.pairViewTab('chart'),
                  ),
                  VitTabItem(
                    key: 'orderBook',
                    label: 'Sổ lệnh',
                    icon: Icons.bar_chart_rounded,
                    widgetKey: MarketsTabletKeys.pairViewTab('orderBook'),
                  ),
                  VitTabItem(
                    key: 'trades',
                    label: 'Giao dịch',
                    icon: Icons.currency_exchange_rounded,
                    widgetKey: MarketsTabletKeys.pairViewTab('trades'),
                  ),
                ],
              ),
            ),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
          ],
        ),
      ),
    );
  }
}

/// Khung nhìn biểu đồ: hàng timeframe + hàng chỉ báo + chart sparkline lớn
/// (shared `VitSparkline` — tablet không tự vẽ painter riêng).
class _PairChartWorkspace extends StatelessWidget {
  const _PairChartWorkspace({
    required this.series,
    required this.positive,
    required this.timeframe,
    required this.onTimeframeChanged,
    required this.indicators,
    required this.onIndicatorToggle,
    required this.onAdvanced,
  });

  final List<double> series;
  final bool positive;
  final String timeframe;
  final ValueChanged<String> onTimeframeChanged;
  final Set<String> indicators;
  final ValueChanged<String> onIndicatorToggle;
  final VoidCallback onAdvanced;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: MarketsSpacingTokens.pairTimeframePadding,
          child: VitPresetChipRow<String>(
            selectedValue: timeframe,
            onTap: onTimeframeChanged,
            accentColor: marketListPrimary,
            height: MarketsSpacingTokens.pairTimeframeHeight,
            padding: EdgeInsets.zero,
            gap: AppSpacing.x1,
            items: const [
              VitPresetChipItem(value: '15m', label: '15m'),
              VitPresetChipItem(value: '1H', label: '1H'),
              VitPresetChipItem(value: '4H', label: '4H'),
              VitPresetChipItem(value: '1D', label: '1D'),
              VitPresetChipItem(value: '1W', label: '1W'),
              VitPresetChipItem(value: '1M', label: '1M'),
            ],
          ),
        ),
        SizedBox(
          height: VitDensity.compact.controlHeight,
          child: ListView(
            padding: MarketsSpacingTokens.pairIndicatorListPadding,
            scrollDirection: Axis.horizontal,
            children: [
              for (final item in [
                'MA',
                'EMA',
                'BOLL',
                'MACD',
                'RSI',
                'Vol',
              ]) ...[
                VitChoicePill(
                  label: item,
                  selected: indicators.contains(item),
                  onTap: () => onIndicatorToggle(item),
                  accentColor: marketListPrimary,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.x3,
                  ),
                  semanticLabel: item,
                ),
                const SizedBox(width: MarketsSpacingTokens.pairIndicatorGap),
              ],
              VitChoicePill(
                label: 'Nâng cao',
                selected: true,
                onTap: onAdvanced,
                tone: VitChoicePillTone.warning,
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.x3,
                ),
                semanticLabel: 'Nâng cao',
              ),
            ],
          ),
        ),
        SizedBox(
          key: MarketsTabletKeys.pairPaneChart,
          height: AppSpacing.buttonStandard * 3 + AppSpacing.x7,
          child: VitSparkline(
            values: series,
            color: positive ? AppColors.buy : AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _PairRiskWarning extends StatelessWidget {
  const _PairRiskWarning();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: MarketsSpacingTokens.pairRiskMargin,
      child: VitBanner(
        variant: VitBannerVariant.warning,
        icon: Icons.warning_amber_rounded,
        message: 'Giao dịch crypto có rủi ro cao.',
        detail: 'Chỉ đầu tư số tiền bạn có thể chịu mất.',
      ),
    );
  }
}

/// Port tablet của `_LinkCard` Phone — thẻ điều hướng section liên quan.
class MarketsPairLinkCard extends StatelessWidget {
  const MarketsPairLinkCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MarketsSpacingTokens.pairLinkMargin,
      child: VitCard(
        borderColor: iconColor.withValues(alpha: .12),
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: Padding(
          padding: MarketsSpacingTokens.pairLinkPadding,
          child: Row(
            children: [
              Material(
                color: iconColor.withValues(alpha: .12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.smRadius,
                ),
                child: SizedBox(
                  width: MarketsSpacingTokens.pairLinkIconBox,
                  height: MarketsSpacingTokens.pairLinkIconBox,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: MarketsSpacingTokens.pairLinkIcon,
                  ),
                ),
              ),
              const SizedBox(width: MarketsSpacingTokens.pairLinkGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: iconColor,
                size: MarketsSpacingTokens.pairLinkChevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PairTradeCtas extends StatelessWidget {
  const _PairTradeCtas({
    required this.pairId,
    required this.onBuy,
    required this.onSell,
  });

  final String pairId;
  final VoidCallback onBuy;
  final VoidCallback onSell;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MarketsSpacingTokens.pairTradeCtaPadding,
      child: Row(
        children: [
          Expanded(
            child: VitCtaButton(
              key: MarketsTabletKeys.pairPaneBuyCta,
              variant: VitCtaButtonVariant.success,
              density: VitDensity.compact,
              onPressed: onBuy,
              child: const Text('MUA'),
            ),
          ),
          const SizedBox(width: MarketsSpacingTokens.pairTradeCtaGap),
          Expanded(
            child: VitCtaButton(
              key: MarketsTabletKeys.pairPaneSellCta,
              variant: VitCtaButtonVariant.danger,
              density: VitDensity.compact,
              onPressed: onSell,
              child: const Text('BÁN'),
            ),
          ),
        ],
      ),
    );
  }
}
