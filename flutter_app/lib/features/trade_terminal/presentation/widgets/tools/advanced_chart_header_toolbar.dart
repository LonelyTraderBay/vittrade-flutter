part of '../../phone/pages/tools/advanced_chart_page.dart';

class _OhlcvBar extends StatelessWidget {
  const _OhlcvBar({required this.ohlcv});

  final TradeOhlcv ohlcv;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TradeSpacingTokens.tradeBotQuestionIconBox,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: TradeSpacingTokens.tradeReceiptSupportPadding,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          'Mới nhất',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.sell,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        const SizedBox(
                          width: TradeSpacingTokens.tradeBotCardIconGap,
                        ),
                        _OhlcvToken(
                          label: 'O',
                          value: _formatRawPrice(ohlcv.open),
                        ),
                        _OhlcvToken(
                          label: 'H',
                          value: _formatRawPrice(ohlcv.high),
                          valueColor: AppColors.buy,
                        ),
                        _OhlcvToken(
                          label: 'L',
                          value: _formatRawPrice(ohlcv.low),
                          valueColor: AppColors.sell,
                        ),
                        _OhlcvToken(
                          label: 'C',
                          value: _formatRawPrice(ohlcv.close),
                          valueColor: AppColors.sell,
                        ),
                        _OhlcvToken(label: 'Vol', value: ohlcv.volumeLabel),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            height: TradeSpacingTokens.tradeBotHairline,
            thickness: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }
}

class _OhlcvToken extends StatelessWidget {
  const _OhlcvToken({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          maxLines: 1,
          text: TextSpan(
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
            children: [
              TextSpan(
                text: '$label:',
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
              TextSpan(
                text: value,
                style: AppTextStyles.micro.copyWith(color: valueColor),
              ),
            ],
          ),
        ),
        const SizedBox(width: TradeSpacingTokens.tradeBotDisclosureGap),
      ],
    );
  }
}

class _ChartToolbar extends StatelessWidget {
  const _ChartToolbar({
    required this.timeframes,
    required this.activeTimeframe,
    required this.activeChartType,
    required this.activeIndicatorCount,
    required this.onTimeframeChanged,
    required this.onChartTypeChanged,
    required this.onIndicators,
  });

  final List<String> timeframes;
  final String activeTimeframe;
  final String activeChartType;
  final int activeIndicatorCount;
  final ValueChanged<String> onTimeframeChanged;
  final ValueChanged<String> onChartTypeChanged;
  final VoidCallback onIndicators;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TradeSpacingTokens.tradeBotClientMetricHeight,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: TradeSpacingTokens.tradeReceiptSupportPadding,
              child: Row(
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final timeframe in timeframes)
                              _TimeframeButton(
                                key: AdvancedChartPage.timeframeKey(timeframe),
                                label: timeframe,
                                active: activeTimeframe == timeframe,
                                onTap: () => onTimeframeChanged(timeframe),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: TradeSpacingTokens.tradeBotTinyGap),
                  const SizedBox(
                    width: AppSpacing.dividerHairline,
                    height: TradeSpacingTokens.tradeBotDisputeDropdownIcon,
                    child: ColoredBox(color: AppColors.borderSolid),
                  ),
                  const SizedBox(width: TradeSpacingTokens.tradeBotTinyGap),
                  VitIconButton(
                    key: AdvancedChartPage.chartTypeKey('candle'),
                    icon: Icons.show_chart_rounded,
                    tooltip: 'Show candle chart',
                    onPressed: () => onChartTypeChanged('candle'),
                    variant: activeChartType == 'candle'
                        ? VitIconButtonVariant.primary
                        : VitIconButtonVariant.transparent,
                    size: VitIconButtonSize.sm,
                  ),
                  VitIconButton(
                    key: AdvancedChartPage.chartTypeKey('line'),
                    icon: Icons.stacked_line_chart_rounded,
                    tooltip: 'Show line chart',
                    onPressed: () => onChartTypeChanged('line'),
                    variant: activeChartType == 'line'
                        ? VitIconButtonVariant.primary
                        : VitIconButtonVariant.transparent,
                    size: VitIconButtonSize.sm,
                  ),
                  VitIconButton(
                    key: AdvancedChartPage.chartTypeKey('area'),
                    icon: Icons.bar_chart_rounded,
                    tooltip: 'Show area chart',
                    onPressed: () => onChartTypeChanged('area'),
                    variant: activeChartType == 'area'
                        ? VitIconButtonVariant.primary
                        : VitIconButtonVariant.transparent,
                    size: VitIconButtonSize.sm,
                  ),
                  const SizedBox(width: TradeSpacingTokens.tradeBotTinyGap),
                  Tooltip(
                    message: 'Mở chỉ báo biểu đồ',
                    child: Semantics(
                      button: true,
                      label: 'Mở chỉ báo biểu đồ',
                      child: VitCard(
                        key: AdvancedChartPage.indicatorButtonKey,
                        onTap: onIndicators,
                        variant: VitCardVariant.ghost,
                        radius: VitCardRadius.tight,
                        padding: AppSpacing.zeroInsets,
                        child: VitStatusPill(
                          label: 'Chỉ báo',
                          icon: Icons.layers_outlined,
                          count: activeIndicatorCount,
                          status: VitStatusPillStatus.info,
                          size: VitStatusPillSize.md,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: TradeSpacingTokens.tradeBotHairline,
            thickness: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }
}

class _TimeframeButton extends StatelessWidget {
  const _TimeframeButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      width: AppSpacing.buttonCompact + AppSpacing.x2,
      height: AppSpacing.buttonCompact - AppSpacing.hairlineStroke,
      alignment: Alignment.center,
      radius: VitCardRadius.tight,
      variant: active ? VitCardVariant.standard : VitCardVariant.ghost,
      borderColor: active ? _tradePrimary : AppColors.transparent,
      background: ColoredBox(
        color: active ? _tradePrimary : AppColors.transparent,
      ),
      onTap: onTap,
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: active ? AppColors.onAccent : AppColors.text3,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}
