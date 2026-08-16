part of 'my_arena_page.dart';

class _TextIconButton extends StatelessWidget {
  const _TextIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      child: Padding(
        padding: ArenaSpacingTokens.arenaPresetPillPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: ArenaSpacingTokens.myArenaTextIconButtonIcon,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    );
  }
}

class _MetaDot extends StatelessWidget {
  const _MetaDot();

  @override
  Widget build(BuildContext context) {
    return Text(
      '·',
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    );
  }
}

String _stateLabel(ArenaChallengeState state) {
  return switch (state) {
    ArenaChallengeState.open => 'Đang mở',
    ArenaChallengeState.full => 'Đã đầy',
    ArenaChallengeState.live => 'Đang diễn ra',
    ArenaChallengeState.pendingResult => 'Chờ kết quả',
    ArenaChallengeState.resolved => 'Hoàn tất',
    ArenaChallengeState.canceled => 'Đã hủy',
  };
}

Color _stateColor(ArenaChallengeState state) {
  return switch (state) {
    ArenaChallengeState.open => AppColors.primary,
    ArenaChallengeState.full => AppColors.warn,
    ArenaChallengeState.live => AppColors.buy,
    ArenaChallengeState.pendingResult => AppColors.accent,
    ArenaChallengeState.resolved => AppColors.buy,
    ArenaChallengeState.canceled => AppColors.sell,
  };
}

Color _distributionColor(int index) {
  return switch (index % 5) {
    0 => AppColors.warn,
    1 => AppColors.sell,
    2 => AppColors.buy,
    3 => AppColors.primary,
    _ => AppColors.accent,
  };
}
