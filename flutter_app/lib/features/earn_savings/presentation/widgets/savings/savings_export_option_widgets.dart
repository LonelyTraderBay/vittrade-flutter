part of '../../phone/pages/savings/savings_export_page.dart';

class _FormatCards extends StatelessWidget {
  const _FormatCards({
    required this.formats,
    required this.selected,
    required this.onChanged,
  });

  final List<SavingsExportFormatDraft> formats;
  final SavingsExportFormat selected;
  final ValueChanged<SavingsExportFormat> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: SavingsExportPage.formatsKey,
      children: [
        for (final format in formats) ...[
          Expanded(
            child: _FormatCard(
              format: format,
              selected: format.id == selected,
              onTap: () => onChanged(format.id),
            ),
          ),
          if (format != formats.last) const SizedBox(width: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _FormatCard extends StatelessWidget {
  const _FormatCard({
    required this.format,
    required this.selected,
    required this.onTap,
  });

  final SavingsExportFormatDraft format;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppModuleAccents.earn : AppColors.text3;

    return VitCard(
      key: SavingsExportPage.formatKey(format.id),
      variant: selected ? VitCardVariant.inner : VitCardVariant.standard,
      radius: VitCardRadius.standard,
      borderColor: selected ? AppModuleAccents.earn : AppColors.cardBorder,
      onTap: onTap,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        children: [
          Icon(
            Icons.description_outlined,
            color: color,
            size: EarnSpacingTokens.earnExportFormatIcon,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            format.label,
            style: _captionBold.copyWith(
              color: selected ? AppModuleAccents.earn : AppColors.text2,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            format.description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: EarnSpacingTokens.earnExportCardLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodChips extends StatelessWidget {
  const _PeriodChips({
    required this.periods,
    required this.selected,
    required this.onChanged,
  });

  final List<SavingsExportPeriodDraft> periods;
  final SavingsExportPeriod selected;
  final ValueChanged<SavingsExportPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitPresetChipRow<SavingsExportPeriod>(
      key: SavingsExportPage.periodsKey,
      accentColor: AppModuleAccents.earn,
      selectedValue: selected,
      onTap: onChanged,
      items: [
        for (final period in periods)
          VitPresetChipItem(
            value: period.id,
            label: period.label,
            key: SavingsExportPage.periodKey(period.id),
          ),
      ],
    );
  }
}

class _ScopeChips extends StatelessWidget {
  const _ScopeChips({
    required this.scopes,
    required this.selected,
    required this.onChanged,
  });

  final List<SavingsExportScopeDraft> scopes;
  final SavingsExportScope selected;
  final ValueChanged<SavingsExportScope> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitPresetChipRow<SavingsExportScope>(
      key: SavingsExportPage.scopesKey,
      accentColor: AppModuleAccents.earn,
      selectedValue: selected,
      onTap: onChanged,
      items: [
        for (final scope in scopes)
          VitPresetChipItem(
            value: scope.id,
            label: scope.label,
            key: SavingsExportPage.scopeKey(scope.id),
          ),
      ],
    );
  }
}

class _OptionsList extends StatelessWidget {
  const _OptionsList({
    required this.options,
    required this.enabled,
    required this.onToggle,
  });

  final List<SavingsExportOptionDraft> options;
  final Set<String> enabled;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsExportPage.optionsKey,
      children: [
        for (final option in options) ...[
          _OptionRow(
            option: option,
            enabled: enabled.contains(option.id),
            onTap: () => onToggle(option.id),
          ),
          if (option != options.last) const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.option,
    required this.enabled,
    required this.onTap,
  });

  final SavingsExportOptionDraft option;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? AppModuleAccents.earn : AppColors.text3;

    return VitCard(
      key: SavingsExportPage.optionKey(option.id),
      variant: VitCardVariant.standard,
      radius: VitCardRadius.standard,
      onTap: onTap,
      padding: EarnSpacingTokens.earnCardPaddingX4X3,
      child: Row(
        children: [
          Icon(_iconFor(option.iconKey), color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.title,
                  style: _captionBold.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  option.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: (_) => onTap(),
            activeThumbColor: AppModuleAccents.earn,
            activeTrackColor: AppModuleAccents.earn.withValues(alpha: 0.2),
            inactiveThumbColor: AppColors.text3,
            inactiveTrackColor: AppColors.toggleTrackOff,
          ),
        ],
      ),
    );
  }
}
