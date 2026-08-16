part of 'dca_dynamic_amount_page.dart';

class _DynamicHero extends StatelessWidget {
  const _DynamicHero({
    required this.option,
    required this.adjustment,
    required this.onChangeStrategy,
  });

  final DcaDynamicStrategyOption option;
  final DcaDynamicAdjustment adjustment;
  final VoidCallback onChangeStrategy;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(option.accent);
    final statusColor = _actionColor(adjustment.action);
    final paused =
        adjustment.action == DcaDynamicAdjustmentAction.paused ||
        adjustment.action == DcaDynamicAdjustmentAction.skipped;
    final amountLabel = paused
        ? adjustment.action == DcaDynamicAdjustmentAction.skipped
              ? 'Bỏ qua lần này'
              : 'Tạm dừng'
        : _formatVnd(adjustment.adjustedAmountVnd);

    return VitCard(
      variant: VitCardVariant.hero,
      padding: _dcaDynamicHeroPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _TinyPill(
                      label: option.title,
                      icon: _iconFor(option.icon),
                      color: accent,
                      filled: true,
                    ),
                    VitCard(
                      onTap: onChangeStrategy,
                      variant: VitCardVariant.ghost,
                      radius: VitCardRadius.standard,
                      padding: EdgeInsets.zero,
                      borderColor: AppColors.transparent,
                      clip: true,
                      child: const _TinyPill(
                        label: 'Đổi',
                        icon: Icons.swap_horiz_rounded,
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              _TinyPill(
                label: _actionLabel(adjustment.action),
                icon: _actionIcon(adjustment.action),
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lần mua tiếp theo',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                        height: DcaSpacingTokens.dcaDynamicCaptionLineHeight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      amountLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          (paused
                                  ? AppTextStyles.sectionTitle
                                  : AppTextStyles.heroNumber)
                              .copyWith(
                                color: paused ? statusColor : AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                    ),
                  ],
                ),
              ),
              if (!paused) ...[
                const SizedBox(width: AppSpacing.x3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Gốc',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.portfolioTextMuted,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      _formatVnd(adjustment.originalAmountVnd),
                      style: AppTextStyles.baseMedium.copyWith(
                        color: adjustment.multiplier == 1
                            ? AppColors.text2
                            : AppColors.portfolioTextMuted,
                        decoration: adjustment.multiplier == 1
                            ? null
                            : TextDecoration.lineThrough,
                        decorationColor: AppColors.portfolioTextMuted,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.surface2,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
            ),
            child: Padding(
              padding: DcaSpacingTokens.dcaPaddingX3,
              child: Row(
                children: [
                  Icon(
                    _actionIcon(adjustment.action),
                    color: statusColor,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  if (adjustment.multiplier != 1 && !paused) ...[
                    Text(
                      'x${adjustment.multiplier.toStringAsFixed(2)}',
                      style: AppTextStyles.caption.copyWith(
                        color: statusColor,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Text(
                      '·',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                  ],
                  Expanded(
                    child: Text(
                      adjustment.reason,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextDim,
                        height: DcaSpacingTokens.dcaDynamicBodyLineHeight,
                      ),
                    ),
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

class _TinyPill extends StatelessWidget {
  const _TinyPill({
    required this.label,
    required this.icon,
    required this.color,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: filled ? AppColors.portfolioBtnGhost : AppColors.hoverBg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
          side: BorderSide(
            color: filled
                ? AppColors.portfolioBtnGhostBorder
                : AppColors.border,
          ),
        ),
      ),
      child: Padding(
        padding: DcaSpacingTokens.dcaButtonChipPadding,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 132),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: filled ? AppColors.portfolioTextDim : color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StrategyStrip extends StatelessWidget {
  const _StrategyStrip({
    required this.strategies,
    required this.activeStrategy,
    required this.onChanged,
  });

  final List<DcaDynamicStrategyOption> strategies;
  final DcaDynamicStrategy activeStrategy;
  final ValueChanged<DcaDynamicStrategy> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHIẾN LƯỢC',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.sectionLabel,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              for (final option in strategies) ...[
                _StrategyChip(
                  option: option,
                  selected: option.strategy == activeStrategy,
                  onTap: () => onChanged(option.strategy),
                ),
                const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StrategyChip extends StatelessWidget {
  const _StrategyChip({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final DcaDynamicStrategyOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(option.accent);

    return VitChoicePill(
      key: DCADynamicAmountPage.strategyKey(option.strategy),
      label: option.title,
      selected: selected,
      onTap: onTap,
      accentColor: accent,
      padding: DcaSpacingTokens.dcaPrimaryChipPadding,
      leading: Icon(_iconFor(option.icon)),
      semanticLabel: option.title,
    );
  }
}

class _StrategyVisualization extends StatelessWidget {
  const _StrategyVisualization({
    required this.strategy,
    required this.option,
    required this.volatilityHistory,
  });

  final DcaDynamicStrategy strategy;
  final DcaDynamicStrategyOption option;
  final List<DcaVolatilitySnapshot> volatilityHistory;

  @override
  Widget build(BuildContext context) {
    if (strategy != DcaDynamicStrategy.volatility) {
      return _GenericStrategyCard(option: option);
    }

    return VitCard(
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: DcaSpacingTokens.dcaSectionHeaderPadding,
            child: _SectionHeader(
              icon: Icons.show_chart_rounded,
              title: 'Biến động & Hệ số',
              subtitle: '30 ngày gần nhất',
              color: AppColors.accent,
            ),
          ),
          Padding(
            padding: DcaSpacingTokens.dcaChartPadding,
            child: SizedBox(
              height: _dcaDynamicChartHeight,
              child: CustomPaint(
                painter: _VolatilityChartPainter(points: volatilityHistory),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const Padding(
            padding: DcaSpacingTokens.dcaChartFooterPadding,
            child: Wrap(
              spacing: AppSpacing.x4,
              runSpacing: AppSpacing.x2,
              children: [
                _LegendItem(color: AppColors.accent, label: 'Volatility'),
                _LegendItem(color: AppColors.buy, label: 'Hệ số'),
                _LegendItem(color: AppColors.sell, label: 'High'),
                _LegendItem(color: AppColors.primary, label: 'Low'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GenericStrategyCard extends StatelessWidget {
  const _GenericStrategyCard({required this.option});

  final DcaDynamicStrategyOption option;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(option.accent);

    return VitCard(
      padding: _dcaDynamicCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: _iconFor(option.icon),
            title: option.title,
            subtitle: option.subtitle,
            color: accent,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          DecoratedBox(
            decoration: ShapeDecoration(
              color: _accentSoft(option.accent),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.cardRadius,
                side: BorderSide(color: accent.withValues(alpha: .24)),
              ),
            ),
            child: Padding(
              padding: DcaSpacingTokens.dcaPaddingX4,
              child: Text(
                option.description,
                style: AppTextStyles.base.copyWith(
                  color: AppColors.text2,
                  height: DcaSpacingTokens.dcaDynamicDescriptionLineHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
