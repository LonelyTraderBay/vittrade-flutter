part of '../phone/pages/settings_page.dart';

class _CurrencyCard extends StatelessWidget {
  const _CurrencyCard({
    required this.currencies,
    required this.selectedCurrency,
    required this.onChanged,
  });

  final List<String> currencies;
  final String selectedCurrency;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      radius: VitCardRadius.large,
      borderColor: AppColors.cardBorder,
      child: Row(
        children: [
          const Icon(
            Icons.language_rounded,
            color: AppColors.primary,
            size: ProfileSpacingTokens.settingsCurrencyIcon,
          ),
          const SizedBox(width: ProfileSpacingTokens.settingsCurrencyIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u0110\u01A1n v\u1ECB ti\u1EC1n t\u1EC7 hi\u1EC3n th\u1ECB',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                VitPresetChipRow<String>(
                  gap: ProfileSpacingTokens.settingsCurrencyChipGap,
                  selectedValue: selectedCurrency,
                  onTap: onChanged,
                  items: [
                    for (final currency in currencies)
                      VitPresetChipItem<String>(
                        key: SettingsPage.currencyKey(currency),
                        value: currency,
                        label: currency,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.languages,
    required this.selectedId,
    required this.onChanged,
  });

  final List<ProfileLanguageOption> languages;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: AppColors.cardBorder,
      clip: true,
      child: Column(
        children: [
          for (final language in languages) ...[
            _LanguageRow(
              language: language,
              selected: language.id == selectedId,
              onTap: () => onChanged(language.id),
            ),
            if (language != languages.last)
              const Divider(
                height: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final ProfileLanguageOption language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SettingsPage.languageKey(language.id),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.transparent,
      padding: EdgeInsets.zero,
      child: Material(
        color: selected ? AppColors.surface2 : AppColors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: VitDensity.compact.controlHeight + AppSpacing.x2,
          ),
          child: Padding(
            padding: ProfileSpacingTokens.settingsLanguageRowPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    language.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                if (selected)
                  const SizedBox(
                    width: ProfileSpacingTokens.settingsLanguageSelectedDot,
                    height: ProfileSpacingTokens.settingsLanguageSelectedDot,
                    child: Material(
                      color: AppColors.primary,
                      shape: CircleBorder(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsListCard extends StatelessWidget {
  const _SettingsListCard({
    required this.rows,
    required this.toggles,
    required this.onToggle,
  });

  final List<ProfileSettingsItem> rows;
  final Map<String, bool> toggles;
  final void Function(String id, bool value) onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: AppColors.cardBorder,
      clip: true,
      child: Column(
        children: [
          for (final row in rows) ...[
            _SettingsRow(
              row: row,
              enabled: toggles[row.id] ?? false,
              onToggle: (value) => onToggle(row.id, value),
            ),
            if (row != rows.last)
              const Divider(
                height: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.row,
    required this.enabled,
    required this.onToggle,
  });

  final ProfileSettingsItem row;
  final bool enabled;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final hasIcon = row.iconKey != 'none';

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: VitDensity.compact.controlHeight + AppSpacing.x5,
      ),
      child: Padding(
        padding: hasIcon
            ? ProfileSpacingTokens.settingsRowPaddingWithIcon
            : ProfileSpacingTokens.settingsRowPaddingNoIcon,
        child: Row(
          children: [
            if (hasIcon) ...[
              Icon(
                profileIconFor(row.iconKey),
                color: AppColors.primary,
                size: ProfileSpacingTokens.settingsRowIcon,
              ),
              const SizedBox(width: ProfileSpacingTokens.settingsRowIconGap),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    row.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
            ),
            if (row.canToggle && row.enabled != null) ...[
              const SizedBox(width: ProfileSpacingTokens.settingsRowSwitchGap),
              _SettingsSwitch(
                key: SettingsPage.toggleKey(row.id),
                value: enabled,
                label: row.title,
                onChanged: onToggle,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTogglePill(
      enabled: value,
      onChanged: onChanged,
      semanticLabel: label,
      width: ProfileSpacingTokens.settingsSwitchWidth,
      height: ProfileSpacingTokens.settingsSwitchHeight,
      knobSize: ProfileSpacingTokens.settingsSwitchKnob,
      knobMargin: ProfileSpacingTokens.settingsSwitchKnobMargin,
      activeColor: AppColors.buy,
      inactiveColor: AppColors.toggleTrackOff,
    );
  }
}
