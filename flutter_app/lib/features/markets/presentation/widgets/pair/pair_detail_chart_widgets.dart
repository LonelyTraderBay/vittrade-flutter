part of '../../phone/pages/pair/pair_detail_page.dart';

String _pairViewKey(_PairView view) => switch (view) {
  _PairView.chart => 'chart',
  _PairView.orderBook => 'orderBook',
  _PairView.trades => 'trades',
};

_PairView _pairViewFromKey(String key) => switch (key) {
  'orderBook' => _PairView.orderBook,
  'trades' => _PairView.trades,
  _ => _PairView.chart,
};

class _ViewTabs extends StatelessWidget {
  const _ViewTabs({required this.activeView, required this.onChanged});

  final _PairView activeView;
  final ValueChanged<_PairView> onChanged;

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
                activeKey: _pairViewKey(activeView),
                variant: VitTabBarVariant.underline,
                onChanged: (key) => onChanged(_pairViewFromKey(key)),
                tabs: const [
                  VitTabItem(
                    key: 'chart',
                    label: 'Biểu đồ',
                    icon: Icons.show_chart_rounded,
                    widgetKey: PairDetailPage.chartTabKey,
                  ),
                  VitTabItem(
                    key: 'orderBook',
                    label: 'Sổ lệnh',
                    icon: Icons.bar_chart_rounded,
                    widgetKey: PairDetailPage.orderBookTabKey,
                  ),
                  VitTabItem(
                    key: 'trades',
                    label: 'Giao dịch',
                    icon: Icons.currency_exchange_rounded,
                    widgetKey: PairDetailPage.tradesTabKey,
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

class _TimeframeRow extends StatelessWidget {
  const _TimeframeRow({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MarketsSpacingTokens.pairTimeframePadding,
      child: VitPresetChipRow<String>(
        selectedValue: active,
        onTap: onChanged,
        accentColor: _marketPrimary,
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
    );
  }
}

class _IndicatorRow extends StatelessWidget {
  const _IndicatorRow({
    required this.active,
    required this.onToggle,
    required this.onAdvanced,
  });

  final Set<String> active;
  final ValueChanged<String> onToggle;
  final VoidCallback onAdvanced;

  @override
  Widget build(BuildContext context) {
    const items = ['MA', 'EMA', 'BOLL', 'MACD', 'RSI', 'Vol'];
    return SizedBox(
      height: VitDensity.compact.controlHeight,
      child: ListView(
        padding: MarketsSpacingTokens.pairIndicatorListPadding,
        scrollDirection: Axis.horizontal,
        children: [
          for (final item in items) ...[
            _IndicatorChip(
              label: item,
              selected: active.contains(item),
              onTap: () => onToggle(item),
            ),
            const SizedBox(width: MarketsSpacingTokens.pairIndicatorGap),
          ],
          _AdvancedChip(onTap: onAdvanced),
        ],
      ),
    );
  }
}

class _IndicatorChip extends StatelessWidget {
  const _IndicatorChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: selected,
      onTap: onTap,
      accentColor: _marketPrimary,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x3),
      semanticLabel: label,
    );
  }
}

class _AdvancedChip extends StatelessWidget {
  const _AdvancedChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: 'Nâng cao',
      selected: true,
      onTap: onTap,
      tone: VitChoicePillTone.warning,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x3),
      semanticLabel: 'Nâng cao',
    );
  }
}

class _PairChart extends StatelessWidget {
  const _PairChart({required this.series});

  final List<double> series;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: PairDetailPage.chartContentKey,
      height: _pairChartExtent,
      child: CustomPaint(
        painter: _PairChartPainter(series),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _RiskWarning extends StatelessWidget {
  const _RiskWarning();

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

class _LinkCard extends StatelessWidget {
  const _LinkCard({
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
        borderColor: iconColor.withValues(alpha: .18),
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

class _TradeCtas extends StatelessWidget {
  const _TradeCtas({required this.pairId});

  final String pairId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MarketsSpacingTokens.pairTradeCtaPadding,
      child: Row(
        children: [
          Expanded(
            child: VitCtaButton(
              key: PairDetailPage.buyButtonKey,
              variant: VitCtaButtonVariant.success,
              density: VitDensity.compact,
              onPressed: () =>
                  context.go('${AppRoutePaths.tradePair(pairId)}?side=buy'),
              child: const Text('MUA'),
            ),
          ),
          const SizedBox(width: MarketsSpacingTokens.pairTradeCtaGap),
          Expanded(
            child: VitCtaButton(
              key: PairDetailPage.sellButtonKey,
              variant: VitCtaButtonVariant.danger,
              density: VitDensity.compact,
              onPressed: () =>
                  context.go('${AppRoutePaths.tradePair(pairId)}?side=sell'),
              child: const Text('BÁN'),
            ),
          ),
        ],
      ),
    );
  }
}
