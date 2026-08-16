part of '../phone/pages/api_management_page.dart';

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({super.key, required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitTogglePill(
      enabled: active,
      onChanged: (_) => onTap(),
      width: ProfileSpacingTokens.profileApiToggleWidth,
      height: ProfileSpacingTokens.profileApiToggleHeight,
      knobSize: ProfileSpacingTokens.profileApiToggleKnob,
      knobMargin: ProfileSpacingTokens.profileApiToggleKnobMargin,
      activeColor: _apiGreen.withValues(alpha: .16),
      activeKnobColor: _apiGreen,
      inactiveColor: AppColors.transparent,
      inactiveKnobColor: AppColors.borderSolid,
    );
  }
}

class _SecretRow extends StatelessWidget {
  const _SecretRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.trailing,
    this.redBorder = false,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Widget trailing;
  final bool redBorder;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      variant: VitCardVariant.inner,
      borderColor: redBorder
          ? _apiRed.withValues(alpha: .1)
          : AppColors.transparent,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.x6 + AppSpacing.x4,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: labelColor,
                fontWeight: AppTextStyles.extraBold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.extraBold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          trailing,
        ],
      ),
    );
  }
}

class _IconTap extends StatelessWidget {
  const _IconTap({
    this.buttonKey,
    required this.icon,
    required this.onTap,
    this.tooltip = 'Sao ch\u00E9p',
  });

  final Key? buttonKey;
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      key: buttonKey,
      icon: icon,
      tooltip: tooltip,
      onPressed: onTap,
      variant: VitIconButtonVariant.ghost,
      size: VitIconButtonSize.sm,
    );
  }
}

class _PermissionBadges extends StatelessWidget {
  const _PermissionBadges({required this.apiKey});

  final ProfileApiKey apiKey;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: ProfileSpacingTokens.profileApiPermissionSpacing,
      runSpacing: ProfileSpacingTokens.profileApiPermissionRunSpacing,
      children: [
        for (final permission in apiKey.permissions)
          VitAccentPill(
            label: _permissionLabel(permission),
            accentColor: _permissionColor(permission),
          ),
        if (apiKey.ipWhitelist.isNotEmpty)
          VitAccentPill(
            label: '${apiKey.ipWhitelist.length} IPs',
            accentColor: _apiGreen,
          )
        else
          const VitAccentPill(
            label: 'Kh\u00F4ng gi\u1EDBi h\u1EA1n IP',
            accentColor: _apiAmber,
          ),
      ],
    );
  }
}

class _UsageRow extends StatelessWidget {
  const _UsageRow({required this.apiKey});

  final ProfileApiKey apiKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          color: _apiMuted,
          size: ProfileSpacingTokens.profileApiUsageIcon,
        ),
        const SizedBox(width: ProfileSpacingTokens.profileApiUsageGapInline),
        Expanded(
          child: Text(
            'D\u00F9ng l\u1EA7n cu\u1ED1i: ${apiKey.lastUsed ?? 'Ch\u01B0a d\u00F9ng'}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: _apiMuted),
          ),
        ),
        Text(
          '${_formatInt(apiKey.requestCount)} requests',
          style: AppTextStyles.micro.copyWith(color: _apiMuted),
        ),
      ],
    );
  }
}

class _RegenerateButton extends StatelessWidget {
  const _RegenerateButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      density: VitDensity.compact,
      variant: VitCtaButtonVariant.secondary,
      leading: const Icon(Icons.sync_rounded),
      child: const Text('T\u1EA1o l\u1EA1i Secret'),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap, required this.id});

  final VoidCallback onTap;
  final String id;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      key: ApiManagementPage.deleteKey(id),
      icon: Icons.delete_outline_rounded,
      tooltip: 'Xo\u00E1 API key',
      onPressed: onTap,
      variant: VitIconButtonVariant.danger,
      size: VitIconButtonSize.md,
    );
  }
}
