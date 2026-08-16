part of '../../phone/pages/tools/advanced_chart_page.dart';

class _ChartArea extends StatelessWidget {
  const _ChartArea({
    required this.candles,
    required this.indicators,
    required this.chartType,
  });

  final List<TradeCandle> candles;
  final List<TradeChartIndicator> indicators;
  final String chartType;

  @override
  Widget build(BuildContext context) {
    final legend = indicators
        .where((indicator) => indicator.enabled && indicator.id != 'vol')
        .toList(growable: false);

    return SizedBox(
      height:
          TradeSpacingTokens.tradeBotCompactChartHeight +
          TradeSpacingTokens.tradeBotRowGap,
      child: ColoredBox(
        color: _chartBlack,
        child: Stack(
          children: [
            Positioned.fill(
              // PERF-HN5: isolate the heavy candle painter into its own
              // compositor layer so sibling repaints (legend chips,
              // indicator sheet) don't force it to redraw.
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _AdvancedTradeChartPainter(
                    candles: candles,
                    indicators: indicators,
                    chartType: chartType,
                  ),
                ),
              ),
            ),
            Positioned(
              left: TradeSpacingTokens.tradeBotSmallGap,
              top: TradeSpacingTokens.tradeBotDisclosureGap,
              child: Row(
                children: [
                  for (final indicator in legend) ...[
                    _LegendChip(indicator: indicator),
                    const SizedBox(width: TradeSpacingTokens.tradeBotTinyGap),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.indicator});

  final TradeChartIndicator indicator;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: indicator.label,
      accentColor: Color(indicator.colorHex),
      size: VitStatusPillSize.sm,
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.pairId});

  final String pairId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.x7 + TradeSpacingTokens.tradeBotDisclosureGap,
      child: Column(
        children: [
          const Divider(
            height: TradeSpacingTokens.tradeBotHairline,
            thickness: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          Expanded(
            child: Padding(
              padding: TradeSpacingTokens.tradeReceiptSupportPadding,
              child: Row(
                children: [
                  Expanded(
                    child: VitCtaButton(
                      key: AdvancedChartPage.buyKey,
                      height: TradeSpacingTokens.tradeBotControlCompact,
                      density: VitDensity.tool,
                      variant: VitCtaButtonVariant.success,
                      onPressed: () =>
                          context.go(AppRoutePaths.tradePair(pairId)),
                      child: const Text('MUA'),
                    ),
                  ),
                  const SizedBox(width: TradeSpacingTokens.tradeBotSmallGap),
                  Expanded(
                    child: VitCtaButton(
                      key: AdvancedChartPage.sellKey,
                      height: TradeSpacingTokens.tradeBotControlCompact,
                      density: VitDensity.tool,
                      variant: VitCtaButtonVariant.danger,
                      onPressed: () => context.go(
                        '${AppRoutePaths.tradePair(pairId)}?side=sell',
                      ),
                      child: const Text('BÁN'),
                    ),
                  ),
                  const SizedBox(width: TradeSpacingTokens.tradeBotSmallGap),
                  VitIconButton(
                    key: AdvancedChartPage.alertKey,
                    icon: Icons.error_outline_rounded,
                    tooltip: 'Open alerts',
                    onPressed: () => context.go(AppRoutePaths.marketsAlerts),
                    variant: VitIconButtonVariant.primary,
                    size: VitIconButtonSize.lg,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicatorSheet extends StatelessWidget {
  const _IndicatorSheet({
    required this.indicators,
    required this.onToggle,
    required this.onClose,
  });

  final List<TradeChartIndicator> indicators;
  final ValueChanged<String> onToggle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          ModalBarrier(
            color: AppColors.dynamicIslandBg.withValues(alpha: .68),
            dismissible: true,
            onDismiss: onClose,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: LaunchpadSpacingTokens.launchpadSheetMaxWidth,
              ),
              child: VitSheetSurface(
                color: AppColors.surface,
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const VitSheetHandle(),
                      const SizedBox(
                        height: TradeSpacingTokens.tradeBotPanelGap,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Chỉ báo kỹ thuật',
                              style: AppTextStyles.baseMedium.copyWith(
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          VitIconButton(
                            key: AdvancedChartPage.closeIndicatorsKey,
                            icon: Icons.close_rounded,
                            tooltip: 'Close indicators',
                            onPressed: onClose,
                            variant: VitIconButtonVariant.transparent,
                            size: VitIconButtonSize.md,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: TradeSpacingTokens.tradeBotSmallGap,
                      ),
                      for (final indicator in indicators) ...[
                        _IndicatorOption(
                          key: AdvancedChartPage.indicatorKey(indicator.id),
                          indicator: indicator,
                          onTap: () => onToggle(indicator.id),
                        ),
                        const SizedBox(
                          height: TradeSpacingTokens.tradeBotSmallGap,
                        ),
                      ],
                      const SizedBox(
                        height:
                            AppSpacing.bottomNavCapsuleHeightVisual +
                            AppSpacing.bottomNavBottomGapVisual +
                            AppSpacing.x3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicatorOption extends StatelessWidget {
  const _IndicatorOption({
    super.key,
    required this.indicator,
    required this.onTap,
  });

  final TradeChartIndicator indicator;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(indicator.colorHex);

    return VitCard(
      height: AppSpacing.inputHeight,
      padding: TradeSpacingTokens.tradeReceiptSupportPadding,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      borderColor: indicator.enabled
          ? color.withValues(alpha: .34)
          : AppColors.borderSolid,
      clip: true,
      onTap: onTap,
      background: ColoredBox(
        color: indicator.enabled ? AppColors.surface2 : AppColors.surface,
      ),
      child: Row(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            width: TradeSpacingTokens.tradeReceiptStatusIcon,
            height: TradeSpacingTokens.tradeReceiptStatusIcon,
            padding: AppSpacing.zeroInsets,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.tight,
            clip: true,
            background: ColoredBox(color: color),
            child: const SizedBox.shrink(),
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotCardIconGap),
          Expanded(
            child: Text(
              indicator.label,
              style: AppTextStyles.body.copyWith(
                color: indicator.enabled ? AppColors.text1 : AppColors.text2,
                fontWeight: indicator.enabled
                    ? AppTextStyles.medium
                    : AppTextStyles.normal,
              ),
            ),
          ),
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            width: TradeSpacingTokens.tradeBotCheckbox,
            height: TradeSpacingTokens.tradeBotCheckbox,
            alignment: Alignment.center,
            padding: AppSpacing.zeroInsets,
            variant: VitCardVariant.ghost,
            borderColor: indicator.enabled ? color : AppColors.borderSolid,
            radius: VitCardRadius.tight,
            clip: true,
            background: ColoredBox(
              color: indicator.enabled ? color : AppColors.transparent,
            ),
            child: indicator.enabled
                ? const Icon(
                    Icons.check_rounded,
                    color: AppColors.onAccent,
                    size: TradeSpacingTokens.tradeBotSmallIcon,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
