part of 'dca_rebalance_config_page.dart';

class _ThresholdCard extends StatelessWidget {
  const _ThresholdCard({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: VitDensity.compact.cardPadding,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        gap: VitContentGap.tight,
        fullBleed: true,
        children: [
          const _SectionHeader(icon: Icons.tune_rounded, title: 'Ngưỡng drift'),
          Row(
            children: [
              Text(
                '${value.toStringAsFixed(0)}%',
                style: AppTextStyles.pageTitle.copyWith(
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitStatusPill(
                label: _driftLabel(value),
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.sm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Trigger khi drift > ${value.toStringAsFixed(0)}%',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          _TokenSlider(
            value: value,
            min: 1,
            max: 50,
            divisions: 49,
            accent: AppColors.accent,
            onChanged: onChanged,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_FinePrint('1% Chặt chẽ'), _FinePrint('50% Linh hoạt')],
          ),
        ],
      ),
    );
  }
}

class _FrequencyCard extends StatelessWidget {
  const _FrequencyCard({
    required this.options,
    required this.active,
    required this.onChanged,
  });

  final List<DcaRebalanceFrequencyOption> options;
  final DcaRebalanceFrequency active;
  final ValueChanged<DcaRebalanceFrequency> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: VitDensity.compact.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            icon: Icons.calendar_month_rounded,
            title: 'Tần suất',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              for (var index = 0; index < options.length; index++) ...[
                Expanded(
                  child: _FrequencyOptionTile(
                    option: options[index],
                    selected: active == options[index].frequency,
                    onTap: () => onChanged(options[index].frequency),
                  ),
                ),
                if (index < options.length - 1)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _FrequencyOptionTile extends StatelessWidget {
  const _FrequencyOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final DcaRebalanceFrequencyOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: EdgeInsets.zero,
      borderColor: AppColors.transparent,
      clip: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: selected ? AppColors.accent10 : AppColors.surface2,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.inputRadius,
            side: BorderSide(
              color: selected ? AppColors.accent : AppColors.transparent,
              width: DcaSpacingTokens.dcaRebalanceConnectorWidth,
            ),
          ),
        ),
        child: Padding(
          padding: DcaSpacingTokens.dcaFrequencyTilePadding,
          child: Column(
            children: [
              Text(
                option.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? AppColors.accent : AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                option.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdvancedSettings extends StatelessWidget {
  const _AdvancedSettings({
    required this.expanded,
    required this.minTradeAmountUsd,
    required this.autoExecute,
    required this.onToggleExpanded,
    required this.onMinTradeChanged,
    required this.onAutoExecuteChanged,
  });

  final bool expanded;
  final double minTradeAmountUsd;
  final bool autoExecute;
  final VoidCallback onToggleExpanded;
  final ValueChanged<double> onMinTradeChanged;
  final ValueChanged<bool> onAutoExecuteChanged;

  // DEBT-88: build tách thành 3 khối con (toggle header, min-trade card,
  // auto-execute card) — không đổi hành vi/layout, chỉ trích xuất.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AdvancedToggleHeader(
          expanded: expanded,
          onToggleExpanded: onToggleExpanded,
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 180),
          crossFadeState: expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: [
              _MinTradeCard(
                minTradeAmountUsd: minTradeAmountUsd,
                onMinTradeChanged: onMinTradeChanged,
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _AutoExecuteCard(
                autoExecute: autoExecute,
                onAutoExecuteChanged: onAutoExecuteChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdvancedToggleHeader extends StatelessWidget {
  const _AdvancedToggleHeader({
    required this.expanded,
    required this.onToggleExpanded,
  });

  final bool expanded;
  final VoidCallback onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DCARebalanceConfigPage.advancedToggleKey,
      onTap: onToggleExpanded,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: DcaSpacingTokens.dcaVerticalPaddingX3,
      borderColor: AppColors.transparent,
      child: Row(
        children: [
          const Icon(
            Icons.settings_suggest_outlined,
            color: AppColors.text3,
            size: DcaSpacingTokens.dcaRebalanceIconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Cài đặt nâng cao',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          AnimatedRotation(
            turns: expanded ? .5 : 0,
            duration: const Duration(milliseconds: 160),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text3,
              size: DcaSpacingTokens.dcaRebalanceIcon,
            ),
          ),
        ],
      ),
    );
  }
}

class _MinTradeCard extends StatelessWidget {
  const _MinTradeCard({
    required this.minTradeAmountUsd,
    required this.onMinTradeChanged,
  });

  final double minTradeAmountUsd;
  final ValueChanged<double> onMinTradeChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: VitDensity.compact.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Giao dịch tối thiểu',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: const ShapeDecoration(
                  color: AppColors.surface2,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.smRadius,
                  ),
                ),
                child: Padding(
                  padding: DcaSpacingTokens.dcaScoreChipPadding,
                  child: Text(
                    '\$${minTradeAmountUsd.toStringAsFixed(0)}',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          _TokenSlider(
            value: minTradeAmountUsd,
            min: 10,
            max: 500,
            divisions: 49,
            accent: AppModuleAccents.trade,
            onChanged: onMinTradeChanged,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_FinePrint('\$10'), _FinePrint('\$500')],
          ),
        ],
      ),
    );
  }
}
