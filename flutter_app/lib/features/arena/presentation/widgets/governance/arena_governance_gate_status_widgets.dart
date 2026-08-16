part of '../../phone/pages/governance/arena_governance_gate_page.dart';

class _MiniHeader extends StatelessWidget {
  const _MiniHeader({required this.icon, required this.label, this.pill});

  final IconData icon;
  final String label;
  final String? pill;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: _arenaAccent,
          size: ArenaSpacingTokens.arenaGovernanceIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.base.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        if (pill != null) _StatusPill(label: pill!, color: AppColors.accent),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaGovernanceSummaryRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequiredPill extends StatelessWidget {
  const _RequiredPill({required this.text, this.compact = false});

  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _StatusPill(label: text, color: AppColors.sell, compact: compact);
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
    this.compact = false,
  });

  final String label;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color == AppColors.sell
            ? AppColors.sell10
            : color == AppColors.buy
            ? AppColors.buy10
            : AppColors.warn10,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
      ),
      child: Padding(
        padding: ArenaSpacingTokens.arenaGovernancePillPadding(
          compact: compact,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _NextActionChip extends StatelessWidget {
  const _NextActionChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.accent20,
      padding: ArenaSpacingTokens.arenaGovernanceNextActionPadding,
      child: Row(
        children: [
          const Icon(
            Icons.add_rounded,
            color: AppColors.accent,
            size: ArenaSpacingTokens.arenaGovernanceAddIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.accent,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModerationNote extends StatelessWidget {
  const _ModerationNote();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.accent20,
      padding: ArenaSpacingTokens.arenaGovernanceInnerPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.accent,
            size: ArenaSpacingTokens.arenaGovernanceIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Governance Gate giúp bạn tạo room chất lượng, không cản bạn sáng tạo. Custom mode vẫn mở cho mọi lĩnh vực, nhưng room public cần rule rõ ràng để bảo vệ người tham gia.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: _governanceNoticeLineRatio,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
