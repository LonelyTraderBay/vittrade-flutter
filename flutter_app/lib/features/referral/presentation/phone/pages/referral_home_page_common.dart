part of 'referral_home_page.dart';

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.icon,
    required this.text,
    required this.color,
    required this.background,
    required this.border,
    this.dense = false,
  });

  final IconData icon;
  final String text;
  final Color color;
  final Color background;
  final Color border;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final bannerVariant = _noticeBannerVariant(color, border);
    if (!dense && bannerVariant != null) {
      return VitBanner(variant: bannerVariant, icon: icon, message: text);
    }

    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: border,
      clip: true,
      background: ColoredBox(color: background),
      padding: dense
          ? const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x2,
            )
          : AppSpacing.cardPaddingCompact,
      child: Row(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: dense ? color : AppColors.text2,
                fontWeight: dense ? AppTextStyles.bold : AppTextStyles.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactAction extends StatelessWidget {
  const _CompactAction({
    required this.onTap,
    required this.icon,
    required this.label,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: label,
      icon: icon,
      status: VitStatusPillStatus.info,
      size: VitStatusPillSize.sm,
      onTap: onTap,
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: label,
      accentColor: _pillAccentColor(color, background),
      size: VitStatusPillSize.sm,
      semanticStatus: _pillSemanticStatus(color),
    );
  }
}

VitBannerVariant? _noticeBannerVariant(Color color, Color border) {
  if (color == AppColors.warn || border == AppColors.warningBorder) {
    return VitBannerVariant.warning;
  }
  if (color == AppColors.sell || border == AppColors.sell20) {
    return VitBannerVariant.error;
  }
  if (color == AppColors.primary || border == AppColors.primary20) {
    return VitBannerVariant.info;
  }
  return null;
}

Color _pillAccentColor(Color color, Color background) {
  if (color == AppColors.bg && background == AppColors.primarySoft) {
    return AppColors.primary;
  }
  return color;
}

VitStatusPillStatus? _pillSemanticStatus(Color color) {
  if (color == AppColors.buy) return VitStatusPillStatus.success;
  if (color == AppColors.warn) return VitStatusPillStatus.warning;
  if (color == AppColors.primary || color == AppColors.primarySoft) {
    return VitStatusPillStatus.info;
  }
  if (color == AppColors.accent) return VitStatusPillStatus.purple;
  return null;
}

class _InlineIconText extends StatelessWidget {
  const _InlineIconText({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x1),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial, required this.color});

  final String initial;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _avatarExtent,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .12),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: color.withValues(alpha: .24)),
            borderRadius: AppRadii.lgRadius,
          ),
        ),
        child: Center(
          child: Text(
            initial,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _SharePreview extends StatelessWidget {
  const _SharePreview({required this.link});

  final String link;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.cardPaddingCompact,
      child: Text(
        'Mình đang dùng VitTrade để giao dịch crypto. Đăng ký qua link của mình, cả hai nhận 5 USDT miễn phí.\n$link',
        style: AppTextStyles.caption.copyWith(color: AppColors.text2),
      ),
    );
  }
}

final class _DetailStyle {
  const _DetailStyle({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}

_DetailStyle _detailStyle(String id) {
  return switch (id) {
    'friends' => const _DetailStyle(
      icon: Icons.groups_rounded,
      color: AppColors.accent,
    ),
    'rewards' => const _DetailStyle(
      icon: Icons.card_giftcard_rounded,
      color: AppColors.buy,
    ),
    'rules' => const _DetailStyle(
      icon: Icons.workspace_premium_rounded,
      color: AppColors.warn,
    ),
    _ => const _DetailStyle(
      icon: Icons.chevron_right_rounded,
      color: AppColors.text2,
    ),
  };
}

String _formatUsd(double value) => VitFormat.usd(value);

String _formatCompactInt(int value) {
  if (value < 1000) return '$value';
  final text = (value / 1000).toStringAsFixed(1);
  return '${text.endsWith('.0') ? text.substring(0, text.length - 2) : text}K';
}
