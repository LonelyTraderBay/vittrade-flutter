part of '../../phone/pages/points/arena_points_entry_detail_page.dart';

class _LinkedRow extends StatelessWidget {
  const _LinkedRow({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaPointsEntryRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          VitCard(
            onTap: () {
              unawaited(HapticFeedback.selectionClick());
              onTap();
            },
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            child: Padding(
              padding: ArenaSpacingTokens.arenaPointsEntryLinkPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: ArenaSpacingTokens.arenaPointsEntryLinkMaxWidth,
                    ),
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.accent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.accent,
                    size: ArenaSpacingTokens.arenaPointsSmallIcon,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceColumn extends StatelessWidget {
  const _BalanceColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

VitStatusPillStatus _status(ArenaPointsEntryStatus status) {
  switch (status) {
    case ArenaPointsEntryStatus.completed:
      return VitStatusPillStatus.success;
    case ArenaPointsEntryStatus.pending:
      return VitStatusPillStatus.warning;
    case ArenaPointsEntryStatus.reversed:
      return VitStatusPillStatus.error;
  }
}

String _formatPoints(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final left = text.length - i;
    buffer.write(text[i]);
    if (left > 1 && left % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
