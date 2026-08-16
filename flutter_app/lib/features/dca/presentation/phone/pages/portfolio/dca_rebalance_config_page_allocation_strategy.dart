part of 'dca_rebalance_config_page.dart';

class _AllocationSummary extends StatelessWidget {
  const _AllocationSummary({
    required this.targets,
    required this.totalPercent,
    required this.onAdd,
  });

  final List<DcaRebalanceTarget> targets;
  final double totalPercent;
  final VoidCallback onAdd;

  bool get _valid => (totalPercent - 100).abs() < 0.01;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: _dcaRebalanceCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            icon: Icons.bar_chart_rounded,
            title: 'Phân bổ mục tiêu',
            trailing: VitChoicePill(
              key: DCARebalanceConfigPage.addTargetKey,
              label: 'Thêm',
              selected: true,
              onTap: onAdd,
              enabled: targets.length < 4,
              accentColor: AppColors.accent,
              leading: const Icon(
                Icons.add_rounded,
                color: AppColors.accent,
                size: DcaSpacingTokens.dcaRebalanceIconSm,
              ),
              padding: DcaSpacingTokens.dcaPrimaryChipPadding,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              SizedBox(
                width: _dcaRebalanceSummaryRingSize,
                height: _dcaRebalanceSummaryRingSize,
                child: CustomPaint(
                  painter: _DonutPainter(targets: targets),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${totalPercent.toStringAsFixed(0)}%',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text1,
                            height: _dcaRebalanceTightLineHeight,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          'Tổng phân bổ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  children: targets
                      .map(
                        (target) => Padding(
                          padding: DcaSpacingTokens.dcaBottomPaddingX3,
                          child: _LegendRow(target: target),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          DecoratedBox(
            decoration: ShapeDecoration(
              color: _valid ? AppColors.buy10 : AppColors.sell10,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.inputRadius,
                side: BorderSide(
                  color: _valid ? AppColors.buy20 : AppColors.sell20,
                ),
              ),
            ),
            child: Padding(
              padding: DcaSpacingTokens.dcaPrimaryChipPadding,
              child: Row(
                children: [
                  Icon(
                    _valid
                        ? Icons.check_circle_outline_rounded
                        : Icons.error_outline_rounded,
                    color: _valid ? AppColors.buy : AppColors.sell,
                    size: DcaSpacingTokens.dcaRebalanceIcon,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Text(
                    'Tổng: ${totalPercent.toStringAsFixed(0)}%',
                    style: AppTextStyles.caption.copyWith(
                      color: _valid ? AppColors.buy : AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _valid
                              ? 'Hợp lệ - sẵn sàng lưu'
                              : 'Tổng phải bằng 100%',
                          style: AppTextStyles.micro.copyWith(
                            color: _valid ? AppColors.buy : AppColors.text3,
                          ),
                        ),
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

class _TargetList extends StatelessWidget {
  const _TargetList({
    required this.targets,
    required this.onPercentChanged,
    required this.onToleranceChanged,
    required this.onRemove,
  });

  final List<DcaRebalanceTarget> targets;
  final void Function(String id, double value) onPercentChanged;
  final void Function(String id, double value) onToleranceChanged;
  final void Function(String id) onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < targets.length; index++) ...[
          _TargetCard(
            target: targets[index],
            canRemove: targets.length > 2,
            onPercentChanged: (value) =>
                onPercentChanged(targets[index].id, value),
            onToleranceChanged: (value) =>
                onToleranceChanged(targets[index].id, value),
            onRemove: () => onRemove(targets[index].id),
          ),
          if (index < targets.length - 1)
            const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _TargetCard extends StatelessWidget {
  const _TargetCard({
    required this.target,
    required this.canRemove,
    required this.onPercentChanged,
    required this.onToleranceChanged,
    required this.onRemove,
  });

  final DcaRebalanceTarget target;
  final bool canRemove;
  final ValueChanged<double> onPercentChanged;
  final ValueChanged<double> onToleranceChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(target.accent);
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      child: Column(
        children: [
          SizedBox(
            height: AppSpacing.x1,
            child: ColoredBox(color: accent),
          ),
          Padding(
            padding: _dcaRebalanceCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _CoinBadge(symbol: target.symbol, accent: accent),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                target.symbol,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.baseMedium.copyWith(
                                  color: AppColors.text1,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x2),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.text3,
                                size: DcaSpacingTokens.dcaRebalanceIcon,
                              ),
                            ],
                          ),
                          Text(
                            target.assetName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      target.targetPercent.toStringAsFixed(0),
                      style: AppTextStyles.pageTitle.copyWith(color: accent),
                    ),
                    Text(
                      '%',
                      style: AppTextStyles.base.copyWith(
                        color: accent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    if (canRemove) ...[
                      const SizedBox(width: AppSpacing.x3),
                      _IconBadgeButton(
                        icon: Icons.delete_outline_rounded,
                        onTap: onRemove,
                        color: AppColors.sell,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'Tỷ lệ mục tiêu',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                _TokenSlider(
                  key: DCARebalanceConfigPage.targetSliderKey(target.id),
                  value: target.targetPercent,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  accent: accent,
                  onChanged: onPercentChanged,
                ),
                const SizedBox(height: AppSpacing.x1),
                DecoratedBox(
                  decoration: const ShapeDecoration(
                    color: AppColors.surface2,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.inputRadius,
                    ),
                  ),
                  child: Padding(
                    padding: DcaSpacingTokens.dcaPrimaryChipPadding,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                'Dung sai',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x2),
                              const Icon(
                                Icons.help_outline_rounded,
                                size: DcaSpacingTokens.dcaRebalanceIconXs,
                                color: AppColors.text3,
                              ),
                            ],
                          ),
                        ),
                        _IconBadgeButton(
                          icon: Icons.remove_rounded,
                          onTap: () => onToleranceChanged(target.tolerance - 1),
                          color: AppColors.text1,
                          neutral: true,
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        Text(
                          '±${target.tolerance.toStringAsFixed(0)}%',
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        _IconBadgeButton(
                          icon: Icons.add_rounded,
                          onTap: () => onToleranceChanged(target.tolerance + 1),
                          color: AppColors.text1,
                          neutral: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StrategySection extends StatelessWidget {
  const _StrategySection({
    required this.options,
    required this.active,
    required this.onChanged,
  });

  final List<DcaRebalanceStrategyOption> options;
  final DcaRebalanceStrategy active;
  final ValueChanged<DcaRebalanceStrategy> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(
          icon: Icons.track_changes_rounded,
          title: 'Chiến lược',
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Row(
          children: [
            for (var index = 0; index < options.length; index++) ...[
              Expanded(
                child: _StrategyOptionTile(
                  option: options[index],
                  selected: active == options[index].strategy,
                  onTap: () => onChanged(options[index].strategy),
                ),
              ),
              if (index < options.length - 1)
                const SizedBox(width: AppSpacing.x2),
            ],
          ],
        ),
      ],
    );
  }
}

class _StrategyOptionTile extends StatelessWidget {
  const _StrategyOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final DcaRebalanceStrategyOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: DCARebalanceConfigPage.strategyKey(option.strategy),
      label: _strategyChoiceLabel(option),
      selected: selected,
      onTap: onTap,
      accentColor: AppColors.accent,
      fullWidth: true,
      leading: Icon(_strategyIcon(option.icon)),
      showSelectedIcon: selected,
      semanticLabel: '${option.title}: ${option.subtitle}',
    );
  }
}
