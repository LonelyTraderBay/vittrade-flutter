part of '../../phone/pages/settings/bot_security_settings_page.dart';

class _DashedActionButton extends StatelessWidget {
  const _DashedActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      alignment: Alignment.center,
      borderColor: _securityPrimary.withValues(alpha: .72),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _securityPrimary, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: _securityPrimary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _Switch extends StatelessWidget {
  const _Switch({super.key, required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: enabled,
      child: VitCard(
        key: key,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.tight,
        onTap: onTap,
        child: VitTogglePill(
          enabled: enabled,
          activeColor: _securityGreen,
          inactiveColor: _securityPanel2,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: child,
    );
  }
}
