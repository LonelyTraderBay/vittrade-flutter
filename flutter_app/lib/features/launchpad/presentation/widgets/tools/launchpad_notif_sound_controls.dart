part of '../../phone/pages/tools/launchpad_notif_sound_page.dart';

final class _CategoryState {
  const _CategoryState({
    required this.enabled,
    required this.soundType,
    required this.volume,
  });

  final bool enabled;
  final String soundType;
  final double volume;

  _CategoryState copyWith({bool? enabled, String? soundType, double? volume}) {
    return _CategoryState(
      enabled: enabled ?? this.enabled,
      soundType: soundType ?? this.soundType,
      volume: volume ?? this.volume,
    );
  }
}

class _MasterSoundHero extends StatelessWidget {
  const _MasterSoundHero({
    required this.masterEnabled,
    required this.volume,
    required this.onToggle,
    required this.onVolumeChanged,
  });

  final bool masterEnabled;
  final double volume;
  final VoidCallback onToggle;
  final ValueChanged<double> onVolumeChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadNotifSoundPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitAccentIconBox(
                icon: masterEnabled
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                color: masterEnabled
                    ? AppModuleAccents.launchpad
                    : AppColors.text3,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Âm thanh tổng',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      masterEnabled ? 'Đang bật' : 'Đã tắt',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextDim,
                      ),
                    ),
                  ],
                ),
              ),
              _SoundSwitch(
                key: LaunchpadNotifSoundPage.toggleKey('master'),
                enabled: masterEnabled,
                onTap: onToggle,
              ),
            ],
          ),
          if (masterEnabled) ...[
            const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Âm lượng tổng',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.portfolioTextDim,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Text(
                  '${volume.round()}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppModuleAccents.launchpad,
                inactiveTrackColor: AppColors.surface3,
                thumbColor: AppModuleAccents.launchpad,
                overlayColor: AppColors.primary12,
                trackHeight: LaunchpadSpacingTokens.launchpadGapXxs,
              ),
              child: Slider(
                value: volume,
                min: 0,
                max: 100,
                onChanged: onVolumeChanged,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickTogglesCard extends StatelessWidget {
  const _QuickTogglesCard({
    required this.vibrate,
    required this.doNotDisturb,
    required this.dndStartHour,
    required this.dndEndHour,
    required this.onVibrate,
    required this.onDoNotDisturb,
  });

  final bool vibrate;
  final bool doNotDisturb;
  final int dndStartHour;
  final int dndEndHour;
  final VoidCallback onVibrate;
  final VoidCallback onDoNotDisturb;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadNotifSoundPage.quickTogglesKey,
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          _QuickToggleRow(
            id: 'vibrate',
            icon: Icons.vibration_rounded,
            accent: AppColors.accent,
            label: 'Rung',
            description: 'Rung kèm âm thanh thông báo',
            enabled: vibrate,
            onTap: onVibrate,
          ),
          const Divider(
            color: AppColors.divider,
            height: AppSpacing.dividerHairline,
          ),
          _QuickToggleRow(
            id: 'dnd',
            icon: Icons.nightlight_round,
            accent: AppColors.warn,
            label: 'Không làm phiền',
            description: doNotDisturb
                ? '$dndStartHour:00 - $dndEndHour:00'
                : 'Tắt âm thanh theo lịch',
            enabled: doNotDisturb,
            onTap: onDoNotDisturb,
          ),
        ],
      ),
    );
  }
}

class _QuickToggleRow extends StatelessWidget {
  const _QuickToggleRow({
    required this.id,
    required this.icon,
    required this.accent,
    required this.label,
    required this.description,
    required this.enabled,
    required this.onTap,
  });

  final String id;
  final IconData icon;
  final Color accent;
  final String label;
  final String description;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Row(
        children: [
          VitAccentIconBox(
            icon: icon,
            color: accent,
            iconSize: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _SoundSwitch(
            key: LaunchpadNotifSoundPage.toggleKey(id),
            enabled: enabled,
            onTap: onTap,
            small: true,
          ),
        ],
      ),
    );
  }
}

class _DndScheduleCard extends StatelessWidget {
  const _DndScheduleCard({
    required this.startHour,
    required this.endHour,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  final int startHour;
  final int endHour;
  final ValueChanged<int> onStartChanged;
  final ValueChanged<int> onEndChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadNotifSoundPage.dndKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Lịch không làm phiền',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _HourSelector(
                  label: 'Từ',
                  value: startHour,
                  onChanged: onStartChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HourSelector(
                  label: 'Đến',
                  value: endHour,
                  onChanged: onEndChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HourSelector extends StatelessWidget {
  const _HourSelector({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      dropdownColor: AppColors.surface2,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.micro.copyWith(color: AppColors.text3),
        filled: true,
        fillColor: AppColors.surface2,
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadii.inputRadius,
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadii.inputRadius,
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
      style: AppTextStyles.caption.copyWith(color: AppColors.text1),
      items: [
        for (var hour = 0; hour < 24; hour++)
          DropdownMenuItem(value: hour, child: Text(_hourLabel(hour))),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
