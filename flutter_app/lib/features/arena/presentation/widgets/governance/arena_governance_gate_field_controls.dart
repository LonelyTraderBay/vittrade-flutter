part of '../../phone/pages/governance/arena_governance_gate_page.dart';

class _FieldBlock extends StatelessWidget {
  const _FieldBlock({
    required this.label,
    required this.child,
    this.required = false,
  });

  final String label;
  final Widget child;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.base.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            if (required) ...[
              const SizedBox(width: AppSpacing.x1),
              Text(
                '*',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        child,
      ],
    );
  }
}

class _MiniOptionChip extends StatelessWidget {
  const _MiniOptionChip({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: selected ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: selected ? AppColors.warn : AppColors.borderSolid,
      radius: VitCardRadius.large,
      padding: ArenaSpacingTokens.arenaGovernanceOptionChipPadding,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selected ? AppColors.warn : AppColors.text3,
            size: ArenaSpacingTokens.arenaGovernanceSmallIcon,
          ),
          const SizedBox(width: AppSpacing.x1),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: ArenaSpacingTokens.arenaGovernanceOptionMaxWidth,
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: selected ? AppColors.warn : AppColors.text3,
                fontWeight: selected
                    ? AppTextStyles.bold
                    : AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuilderField extends StatelessWidget {
  const _BuilderField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        _DropdownCard(value: value, placeholder: 'Chọn...', onTap: onTap),
      ],
    );
  }
}

class _EdgeField extends StatelessWidget {
  const _EdgeField({
    required this.label,
    required this.publicRoom,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final String label;
  final bool publicRoom;
  final String value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaGovernanceEdgeFieldPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.x1,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              if (publicRoom)
                const _RequiredPill(text: 'PUBLIC', compact: true),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _DropdownCard(value: value, placeholder: placeholder, onTap: onTap),
        ],
      ),
    );
  }
}

class _DropdownCard extends StatelessWidget {
  const _DropdownCard({
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final String value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = value.isNotEmpty;
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: hasValue ? AppColors.accent20 : AppColors.borderSolid,
      padding: ArenaSpacingTokens.arenaGovernanceDropdownPadding,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              hasValue ? value : placeholder,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: hasValue ? AppColors.text1 : AppColors.text3,
                fontWeight: hasValue
                    ? AppTextStyles.bold
                    : AppTextStyles.medium,
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.text3,
            size: ArenaSpacingTokens.arenaGovernanceLargeIcon,
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.description,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String description;
  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaGovernanceSwitchRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (_) => onTap(),
            activeThumbColor: AppColors.warn,
            activeTrackColor: AppColors.warn15,
            inactiveThumbColor: AppColors.text2,
            inactiveTrackColor: AppColors.surface3,
          ),
        ],
      ),
    );
  }
}
