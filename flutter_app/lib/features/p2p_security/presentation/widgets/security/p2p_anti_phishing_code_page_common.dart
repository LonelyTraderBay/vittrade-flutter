part of '../../phone/pages/security/p2p_anti_phishing_code_page.dart';

class _SoftActionButton extends StatelessWidget {
  const _SoftActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: true,
      onTap: onTap,
      fullWidth: true,
      padding: P2PSpacingTokens.p2pSecurityDetailsActionPadding,
      accentColor: color,
      leading: Icon(icon),
      semanticLabel: label,
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: P2PSpacingTokens.p2pSecurityDetailsIconActionBox,
      height: P2PSpacingTokens.p2pSecurityDetailsIconActionBox,
      child: VitIconButton(
        icon: icon,
        tooltip: 'Toggle anti-phishing code visibility',
        onPressed: onTap,
        size: VitIconButtonSize.sm,
        variant: VitIconButtonVariant.transparent,
      ),
    );
  }
}
