part of '../../phone/pages/governance/arena_safety_center_page.dart';

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({required this.links});

  final List<ArenaSafetyQuickLinkDraft> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final link in links) ...[
          VitCard(
            key: link.route == AppRoutePaths.arenaBlocked
                ? ArenaSafetyCenterPage.blockedLinkKey
                : ArenaSafetyCenterPage.reportsLinkKey,
            onTap: () {
              unawaited(HapticFeedback.selectionClick());
              context.go(link.route);
            },
            density: VitDensity.compact,
            child: Row(
              children: [
                Icon(
                  _kindIcon(link.kind),
                  color: _kindColor(link.kind),
                  size: _safetyIcon,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    link.title,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
              ],
            ),
          ),
          if (link != links.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _ToneIcon extends StatelessWidget {
  const _ToneIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _safetyIconBox,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .14),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.smRadius,
            side: BorderSide(color: color.withValues(alpha: .18)),
          ),
        ),
        child: Center(
          child: Icon(icon, color: color, size: _safetyIcon),
        ),
      ),
    );
  }
}

IconData _kindIcon(ArenaSafetyKind kind) {
  switch (kind) {
    case ArenaSafetyKind.respect:
      return Icons.balance_outlined;
    case ArenaSafetyKind.offPlatform:
      return Icons.block_rounded;
    case ArenaSafetyKind.civil:
      return Icons.menu_book_outlined;
    case ArenaSafetyKind.privacy:
      return Icons.shield_outlined;
    case ArenaSafetyKind.report:
      return Icons.outlined_flag_rounded;
    case ArenaSafetyKind.block:
      return Icons.do_not_disturb_on_outlined;
    case ArenaSafetyKind.process:
      return Icons.fact_check_outlined;
    case ArenaSafetyKind.resolution:
      return Icons.balance_outlined;
    case ArenaSafetyKind.points:
      return Icons.redeem_outlined;
  }
}

Color _kindColor(ArenaSafetyKind kind) {
  switch (kind) {
    case ArenaSafetyKind.respect:
    case ArenaSafetyKind.resolution:
      return AppColors.primary;
    case ArenaSafetyKind.offPlatform:
    case ArenaSafetyKind.report:
      return AppColors.sell;
    case ArenaSafetyKind.civil:
    case ArenaSafetyKind.points:
      return AppColors.accent;
    case ArenaSafetyKind.privacy:
    case ArenaSafetyKind.process:
      return AppColors.buy;
    case ArenaSafetyKind.block:
      return AppModuleAccents.arena;
  }
}
