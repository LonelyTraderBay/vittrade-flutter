part of '../../phone/pages/savings/auto_compound_settings_page.dart';

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet({
    required this.snapshot,
    required this.position,
    required this.onToggle,
    required this.onFrequency,
    required this.onThreshold,
    required this.onSave,
  });

  final AutoCompoundSettingsSnapshot snapshot;
  final AutoCompoundPositionDraft position;
  final VoidCallback onToggle;
  final ValueChanged<String> onFrequency;
  final ValueChanged<double> onThreshold;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final thresholds = _thresholdPresets(position.asset);
    final effectiveApy = position.autoCompound
        ? position.apy + position.estimatedBoost / 100
        : position.apy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Cài đặt lãi kép — ${position.product}',
                style: AppTextStyles.sectionTitle,
              ),
            ),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Đóng',
              onPressed: () => Navigator.of(context).pop(),
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.md,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _PositionSummary(position: position),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          variant: VitCardVariant.inner,
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              Icon(
                Icons.autorenew_rounded,
                color: position.autoCompound ? AppColors.buy : AppColors.text3,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Tự động lãi kép',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _ToggleSwitch(on: position.autoCompound, onTap: onToggle),
            ],
          ),
        ),
        if (position.autoCompound) ...[
          const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
          Text(
            'Tần suất compound',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final frequency in snapshot.frequencies) ...[
            _FrequencyTile(
              frequency: frequency,
              selected: frequency.id == position.compoundFrequency,
              onTap: () => onFrequency(frequency.id),
            ),
            if (frequency != snapshot.frequencies.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
          const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
          Text(
            'Ngưỡng tối thiểu',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              for (final threshold in thresholds) ...[
                Expanded(
                  child: _ThresholdChip(
                    value: threshold,
                    asset: position.asset,
                    selected: threshold == position.compoundThreshold,
                    onTap: () => onThreshold(threshold),
                  ),
                ),
                if (threshold != thresholds.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        VitCard(
          variant: VitCardVariant.inner,
          padding: AppSpacing.cardPadding,
          child: Column(
            children: [
              _SheetMetric(label: 'APY cơ bản', value: '${position.apy}%'),
              _SheetMetric(
                label: 'APY thực tế (compound)',
                value: position.autoCompound
                    ? '~${effectiveApy.toStringAsFixed(2)}%'
                    : '${position.apy}% (không compound)',
                color: position.autoCompound ? AppColors.buy : AppColors.text2,
              ),
              if (position.autoCompound)
                _SheetMetric(
                  label: 'Lợi ích thêm',
                  value:
                      '+${(position.estimatedBoost / 100).toStringAsFixed(2)}% APY',
                  color: AppColors.buy,
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        VitCtaButton(
          key: AutoCompoundSettingsPage.saveButtonKey,
          onPressed: onSave,
          child: const Text('Lưu cài đặt'),
        ),
      ],
    );
  }
}

class _PositionSummary extends StatelessWidget {
  const _PositionSummary({required this.position});

  final AutoCompoundPositionDraft position;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AssetBadge(asset: position.asset, color: _assetColor(position.asset)),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(position.product, style: AppTextStyles.baseMedium),
              Text(
                'Số dư: ${_formatAmount(position.amount)} ${position.asset}',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FrequencyTile extends StatelessWidget {
  const _FrequencyTile({
    required this.frequency,
    required this.selected,
    required this.onTap,
  });

  final AutoCompoundFrequencyDraft frequency;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: AutoCompoundSettingsPage.frequencyKey(frequency.id),
      variant: VitCardVariant.inner,
      borderColor: selected ? AppColors.buy : null,
      padding: AppSpacing.cardPadding,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            selected ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: selected ? AppColors.buy : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  frequency.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  frequency.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _SmallPill(label: frequency.boostLabel, color: AppColors.buy),
        ],
      ),
    );
  }
}

class _ThresholdChip extends StatelessWidget {
  const _ThresholdChip({
    required this.value,
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final double value;
  final String asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: AutoCompoundSettingsPage.thresholdKey(value),
      label: _formatAmount(value),
      selected: selected,
      onTap: onTap,
      tone: VitChoicePillTone.success,
      fullWidth: true,
      height: AppSpacing.buttonCompact,
    );
  }
}

class _SheetMetric extends StatelessWidget {
  const _SheetMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.zeroInsets.copyWith(
        top: AppSpacing.x2,
        bottom: AppSpacing.x2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
