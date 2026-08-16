part of '../../phone/pages/governance/arena_governance_gate_page.dart';

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Mô tả ngắn',
      child: TextFormField(
        initialValue: value,
        onChanged: onChanged,
        maxLines: 2,
        style: AppTextStyles.base.copyWith(color: AppColors.text1),
        decoration: _inputDecoration(
          'Mô tả bối cảnh nếu cần. Không cần lặp lại luật chơi.',
        ),
      ),
    );
  }
}

class _ResolutionSourceField extends StatelessWidget {
  const _ResolutionSourceField({
    required this.publicRoom,
    required this.value,
    required this.options,
    required this.onTap,
  });

  final bool publicRoom;
  final String value;
  final List<String> options;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Cách chốt kết quả',
      required: publicRoom,
      child: _DropdownCard(
        value: value,
        placeholder: 'Chọn resolution source...',
        onTap: onTap,
      ),
    );
  }
}

class _TimingRulesCard extends StatelessWidget {
  const _TimingRulesCard({
    required this.snapshot,
    required this.endDate,
    required this.tieRule,
    required this.voidRule,
    required this.resultDeadline,
    required this.rematchEnabled,
    required this.saveAsMode,
    required this.publicRoom,
    required this.onDate,
    required this.onTieRule,
    required this.onVoidRule,
    required this.onResultDeadline,
    required this.onRematch,
    required this.onSaveAsMode,
  });

  final ArenaGovernanceSnapshot snapshot;
  final String endDate;
  final String tieRule;
  final String voidRule;
  final String resultDeadline;
  final bool rematchEnabled;
  final bool saveAsMode;
  final bool publicRoom;
  final ValueChanged<String> onDate;
  final VoidCallback onTieRule;
  final VoidCallback onVoidRule;
  final VoidCallback onResultDeadline;
  final VoidCallback onRematch;
  final VoidCallback onSaveAsMode;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ArenaSpacingTokens.arenaGovernanceCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_outlined,
                color: AppColors.buy,
                size: ArenaSpacingTokens.arenaGovernanceIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Timing & Edge Rules',
                style: AppTextStyles.base.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _FieldBlock(
            label: 'Thời hạn kết thúc',
            child: TextFormField(
              initialValue: formatArenaDateInput(endDate),
              onChanged: (value) => onDate(normalizeArenaDateInput(value)),
              style: AppTextStyles.base.copyWith(color: AppColors.text1),
              decoration: _inputDecoration('03/15/2026').copyWith(
                suffixIcon: const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.text3,
                  size: ArenaSpacingTokens.arenaGovernanceIcon,
                ),
              ),
            ),
          ),
          _EdgeField(
            label: 'Luật hòa',
            publicRoom: publicRoom,
            value: tieRule,
            placeholder: 'Chọn tie rule...',
            onTap: onTieRule,
          ),
          _EdgeField(
            label: 'Luật hủy bỏ',
            publicRoom: publicRoom,
            value: voidRule,
            placeholder: 'Chọn void rule...',
            onTap: onVoidRule,
          ),
          _EdgeField(
            label: 'Hạn chốt kết quả',
            publicRoom: publicRoom,
            value: resultDeadline,
            placeholder: 'Chọn result deadline...',
            onTap: onResultDeadline,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _SwitchRow(
            label: 'Cho phép rematch',
            description: 'Người chơi có thể yêu cầu chơi lại',
            value: rematchEnabled,
            onTap: onRematch,
          ),
          _SwitchRow(
            label: 'Lưu thành reusable mode',
            description: 'Người khác có thể clone luật chơi',
            value: saveAsMode,
            onTap: onSaveAsMode,
          ),
        ],
      ),
    );
  }
}

class _WarningStack extends StatelessWidget {
  const _WarningStack({required this.result});

  final _GovernanceResult result;

  @override
  Widget build(BuildContext context) {
    if (result.warnings.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        for (final warning in result.warnings)
          Padding(
            padding: ArenaSpacingTokens.arenaGovernanceListItemPadding,
            child: VitCard(
              variant: VitCardVariant.inner,
              borderColor: AppColors.warningBorder,
              padding: ArenaSpacingTokens.arenaGovernanceInnerPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warn,
                    size: ArenaSpacingTokens.arenaGovernanceIcon,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      warning,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height: _governanceBodyLineRatio,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
