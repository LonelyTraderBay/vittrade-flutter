part of '../../phone/pages/schedule/dca_schedule_config_page.dart';

class _StrategySection extends StatelessWidget {
  const _StrategySection({
    required this.strategies,
    required this.active,
    required this.onChanged,
  });

  final List<DcaScheduleStrategyOption> strategies;
  final DcaScheduleStrategy active;
  final ValueChanged<DcaScheduleStrategy> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Chiến lược',
          icon: Icons.flash_on_outlined,
          iconColor: AppColors.text1,
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              for (var index = 0; index < strategies.length; index++) ...[
                _StrategyTile(
                  option: strategies[index],
                  selected: strategies[index].strategy == active,
                  onTap: () => onChanged(strategies[index].strategy),
                ),
                if (index < strategies.length - 1)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StrategyTile extends StatelessWidget {
  const _StrategyTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final DcaScheduleStrategyOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForStrategy(option.strategy);
    return SizedBox(
      width: _dcaScheduleStrategyChipWidth,
      child: VitChoicePill(
        key: DCAScheduleConfigPage.strategyKey(option.strategy),
        label: option.title,
        selected: selected,
        onTap: onTap,
        accentColor: accent,
        fullWidth: true,
        leading: Icon(_iconForOption(option.icon)),
        showSelectedIcon: selected,
        semanticLabel: '${option.title}: ${option.subtitle}',
      ),
    );
  }
}

class _TimePreferenceSection extends StatelessWidget {
  const _TimePreferenceSection({
    required this.preferences,
    required this.active,
    required this.activeAccent,
    required this.onChanged,
  });

  final List<DcaScheduleTimePreferenceOption> preferences;
  final DcaScheduleTimePreference active;
  final Color activeAccent;
  final ValueChanged<DcaScheduleTimePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Khung giờ ưu tiên',
          icon: Icons.schedule_outlined,
          iconColor: AppColors.text1,
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : AppSpacing.zero;
            final useTwoColumns =
                availableWidth >= _dcaScheduleTwoColumnMinWidth;
            final tileWidth = useTwoColumns
                ? (availableWidth - AppSpacing.x3) / 2
                : availableWidth;
            return Wrap(
              spacing: useTwoColumns ? AppSpacing.x3 : AppSpacing.zero,
              runSpacing: AppSpacing.x3,
              children: [
                for (final option in preferences)
                  SizedBox(
                    width: tileWidth,
                    child: _TimeTile(
                      option: option,
                      selected: option.preference == active,
                      accent: activeAccent,
                      onTap: () => onChanged(option.preference),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    required this.option,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final DcaScheduleTimePreferenceOption option;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DCAScheduleConfigPage.timeKey(option.preference),
      variant: VitCardVariant.inner,
      borderColor: selected ? accent.withValues(alpha: .72) : null,
      onTap: onTap,
      padding: _dcaScheduleCardPadding,
      child: Column(
        children: [
          Text(
            option.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: selected ? accent : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            option.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
