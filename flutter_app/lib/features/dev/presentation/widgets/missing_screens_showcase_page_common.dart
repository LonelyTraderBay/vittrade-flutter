part of '../phone/pages/missing_screens_showcase_page.dart';

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.smRadius,
          side: BorderSide(color: _borderFromColor(color)),
        ),
      ),
      child: SizedBox(
        width: AppSpacing.ctaHeight,
        height: AppSpacing.ctaHeight,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _PreviewPill extends StatelessWidget {
  const _PreviewPill({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: _borderFromColor(color),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
          side: BorderSide(color: _borderFromColor(color)),
        ),
      ),
      child: Padding(
        padding: AdminSpacingTokens.devChipPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.visibility_outlined,
              color: color,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              'Preview',
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

class _StateChip extends StatelessWidget {
  const _StateChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.inputRadius,
          side: BorderSide(color: AppColors.borderSolid),
        ),
      ),
      child: Padding(
        padding: AdminSpacingTokens.devCompactChipPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _ChangeRow extends StatelessWidget {
  const _ChangeRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.auto_awesome_rounded, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: AdminSpacingTokens.devDividerHeight,
      color: AppColors.divider,
    );
  }
}

Color _accentForId(String id) {
  return switch (id) {
    'p2p_orders' || 'p2p' || 'reset_login' => AppColors.buy,
    'wallet_tx' || 'wallet' || 'order_detail' => AppColors.accent,
    'security' || 'security_activity' || 'security_orders' => AppColors.warn,
    _ => AppColors.primary,
  };
}

Color _backgroundForId(String id) {
  return switch (id) {
    'p2p_orders' || 'p2p' || 'reset_login' => AppColors.buy15,
    'wallet_tx' || 'wallet' || 'order_detail' => AppColors.accent15,
    'security' || 'security_activity' || 'security_orders' => AppColors.warn15,
    _ => AppColors.primary12,
  };
}

Color _borderForId(String id) {
  return switch (id) {
    'p2p_orders' || 'p2p' || 'reset_login' => AppColors.buy20,
    'wallet_tx' || 'wallet' || 'order_detail' => AppColors.accent20,
    'security' || 'security_activity' || 'security_orders' => AppColors.warn15,
    _ => AppColors.primary20,
  };
}

Color _borderFromColor(Color color) {
  if (color == AppColors.buy) return AppColors.buy20;
  if (color == AppColors.accent) return AppColors.accent20;
  if (color == AppColors.warn) return AppColors.warn15;
  return AppColors.primary20;
}

IconData _iconForId(String id) {
  return switch (id) {
    'reset_password' || 'otp_reset' || 'otp' => Icons.lock_outline_rounded,
    'p2p_orders' || 'p2p' => Icons.shopping_cart_outlined,
    'wallet_tx' || 'wallet' => Icons.receipt_long_outlined,
    'security' ||
    'security_activity' ||
    'security_orders' => Icons.verified_user_outlined,
    _ => Icons.layers_outlined,
  };
}
