part of '../../phone/pages/schedule/dca_schedule_config_page.dart';

class _LimitsCard extends StatelessWidget {
  const _LimitsCard({
    required this.maxDelayHours,
    required this.maxAdvanceHours,
    required this.onDelayChanged,
    required this.onAdvanceChanged,
  });

  final double maxDelayHours;
  final double maxAdvanceHours;
  final ValueChanged<double> onDelayChanged;
  final ValueChanged<double> onAdvanceChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _dcaScheduleCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Giới hạn điều chỉnh',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _SliderField(
            key: DCAScheduleConfigPage.maxDelayKey,
            label: 'Trễ tối đa',
            valueLabel: '${maxDelayHours.round()}h',
            helper:
                'Cho phép trễ tối đa ${maxDelayHours.round()} giờ để đợi điều kiện tốt hơn',
            value: maxDelayHours,
            min: 1,
            max: 24,
            divisions: 23,
            onChanged: onDelayChanged,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _SliderField(
            key: DCAScheduleConfigPage.maxAdvanceKey,
            label: 'Sớm tối đa',
            valueLabel: '${maxAdvanceHours.round()}h',
            helper:
                'Cho phép thực thi sớm tối đa ${maxAdvanceHours.round()} giờ nếu điều kiện thuận lợi',
            value: maxAdvanceHours,
            min: 1,
            max: 24,
            divisions: 23,
            onChanged: onAdvanceChanged,
          ),
        ],
      ),
    );
  }
}

class _ThresholdCard extends StatelessWidget {
  const _ThresholdCard({
    super.key,
    required this.title,
    required this.icon,
    required this.accent,
    required this.label,
    required this.valueLabel,
    required this.min,
    required this.max,
    required this.divisions,
    required this.value,
    required this.helper,
    required this.onChanged,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final String label;
  final String valueLabel;
  final double min;
  final double max;
  final int divisions;
  final double value;
  final String helper;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _dcaScheduleCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: accent,
                size: DcaSpacingTokens.dcaScheduleSectionIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _SliderField(
            label: label,
            valueLabel: valueLabel,
            helper: helper,
            min: min,
            max: max,
            divisions: divisions,
            value: value,
            activeColor: accent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SliderField extends StatelessWidget {
  const _SliderField({
    super.key,
    required this.label,
    required this.valueLabel,
    required this.helper,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    this.activeColor = AppColors.primary,
  });

  final String label;
  final String valueLabel;
  final String helper;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              valueLabel,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: activeColor,
            inactiveTrackColor: AppColors.borderSolid,
            thumbColor: activeColor,
            overlayColor: activeColor.withValues(alpha: .12),
            trackHeight: DcaSpacingTokens.dcaScheduleSliderTrackHeight,
          ),
          child: Slider(
            value: value.clamp(min, max).toDouble(),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        Text(
          helper,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _EnableCard extends StatelessWidget {
  const _EnableCard({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _dcaScheduleCardPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kích hoạt Smart Scheduling',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Tự động tối ưu thời gian thực thi',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Switch(
            key: DCAScheduleConfigPage.enabledKey,
            value: enabled,
            activeThumbColor: AppColors.navCenterIcon,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: AppColors.text2,
            inactiveTrackColor: AppColors.surface3,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _FixedWarningCard extends StatelessWidget {
  const _FixedWarningCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: _dcaScheduleCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_outlined,
            color: AppColors.warningText,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Chiến lược "Cố định" sẽ không tối ưu thời gian thực thi. Khuyên dùng "Hybrid" để có kết quả tốt nhất.',
              style: AppTextStyles.micro.copyWith(color: AppColors.warningText),
            ),
          ),
        ],
      ),
    );
  }
}
