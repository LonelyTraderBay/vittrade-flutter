part of '../../phone/pages/staking/staking_social_feed_page.dart';

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final StakingSocialFeedStatDraft stat;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(stat.tone);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: stat.tone == 'success' ? AppColors.primary20 : null,
      padding: EarnSpacingTokens.earnCardPaddingX2X4,
      child: Column(
        children: [
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              color: stat.tone == 'success' ? color : AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSocialFeedPage.footerKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.color,
    this.emphasis = false,
  });

  final String label;
  final Color color;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: _softBackground(color),
        shape: RoundedRectangleBorder(
          side: emphasis
              ? BorderSide(color: _softBorder(color))
              : BorderSide.none,
          borderRadius: AppRadii.smRadius,
        ),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
          ),
        ),
      ),
    );
  }
}

final class _PostTypeMeta {
  const _PostTypeMeta({
    required this.label,
    required this.icon,
    required this.avatarIcon,
    required this.color,
    required this.background,
    required this.border,
  });

  final String label;
  final IconData icon;
  final IconData avatarIcon;
  final Color color;
  final Color background;
  final Color border;

  factory _PostTypeMeta.fromType(String type) {
    switch (type) {
      case 'tip':
        return const _PostTypeMeta(
          label: 'Pro Tip',
          icon: Icons.trending_up_rounded,
          avatarIcon: Icons.insert_chart_outlined_rounded,
          color: AppColors.accent,
          background: AppColors.accent12,
          border: AppColors.accent20,
        );
      case 'achievement':
        return const _PostTypeMeta(
          label: 'Achievement',
          icon: Icons.workspace_premium_outlined,
          avatarIcon: Icons.shield_outlined,
          color: AppModuleAccents.earn,
          background: AppColors.warningBg,
          border: AppColors.warningBorder,
        );
      case 'discussion':
        return const _PostTypeMeta(
          label: 'Discussion',
          icon: Icons.chat_bubble_outline_rounded,
          avatarIcon: Icons.construction_rounded,
          color: AppColors.buy,
          background: AppColors.buy10,
          border: AppColors.primary20,
        );
      case 'milestone':
      default:
        return const _PostTypeMeta(
          label: 'Milestone',
          icon: Icons.chat_bubble_outline_rounded,
          avatarIcon: Icons.savings_outlined,
          color: AppColors.buy,
          background: AppColors.buy10,
          border: AppColors.primary20,
        );
    }
  }
}

Color _toneColor(String tone) {
  switch (tone) {
    case 'success':
      return AppColors.buy;
    case 'warning':
      return AppColors.warn;
    case 'danger':
      return AppColors.sell;
    default:
      return AppColors.text2;
  }
}

Color _softBackground(Color color) {
  if (color == AppColors.buy) return AppColors.buy10;
  if (color == AppColors.primary || color == AppModuleAccents.earn) {
    return AppColors.primary12;
  }
  if (color == AppColors.sell) return AppColors.sell10;
  if (color == AppColors.accent) return AppColors.accent12;
  return AppColors.surface2;
}

Color _softBorder(Color color) {
  if (color == AppColors.buy) return AppColors.primary20;
  if (color == AppColors.primary || color == AppModuleAccents.earn) {
    return AppColors.primary20;
  }
  if (color == AppColors.sell) return AppColors.sell20;
  if (color == AppColors.accent) return AppColors.accent20;
  return AppColors.cardBorder;
}
