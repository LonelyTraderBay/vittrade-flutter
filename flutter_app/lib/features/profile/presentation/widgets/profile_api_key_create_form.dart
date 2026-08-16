part of '../phone/pages/api_key_create_page.dart';

class _NameSection extends StatelessWidget {
  const _NameSection({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldSection(
      label: 'T\u00EAn API Key',
      required: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TextInput(
            key: ApiKeyCreatePage.nameFieldKey,
            controller: controller,
            hint: 'VD: Trading Bot Alpha, Portfolio Tracker...',
            maxLength: 30,
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Text(
                'T\u1ED1i thi\u1EC3u 3 k\u00FD t\u1EF1',
                style: AppTextStyles.micro.copyWith(color: _apiMuted),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Expanded(child: SizedBox.shrink()),
              Text(
                '${controller.text.length}/30',
                style: AppTextStyles.micro.copyWith(color: _apiMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PermissionsSection extends StatelessWidget {
  const _PermissionsSection({
    required this.permissions,
    required this.selected,
    required this.onToggle,
  });

  final List<ProfileApiPermission> permissions;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return _FieldSection(
      label: 'Quy\u1EC1n truy c\u1EADp',
      required: true,
      child: Column(
        children: [
          for (final permission in permissions) ...[
            _PermissionCard(
              permission: permission,
              selected: selected.contains(permission.id),
              onTap: () => onToggle(permission.id),
            ),
            if (permission != permissions.last)
              SizedBox(height: VitDensity.compact.verticalSpace),
          ],
        ],
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.permission,
    required this.selected,
    required this.onTap,
  });

  final ProfileApiPermission permission;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Color(permission.colorHex);

    return VitCard(
      key: ApiKeyCreatePage.permissionKey(permission.id),
      onTap: onTap,
      density: VitDensity.compact,
      variant: selected ? VitCardVariant.standard : VitCardVariant.inner,
      borderColor: selected ? accent.withValues(alpha: .42) : _apiBorder,
      child: Row(
        children: [
          SizedBox(
            width: ProfileSpacingTokens.profileApiCreatePermissionIconBox,
            height: ProfileSpacingTokens.profileApiCreatePermissionIconBox,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: selected ? accent.withValues(alpha: .12) : _apiPanel,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.smRadius,
                  side: BorderSide(
                    color: selected
                        ? accent.withValues(alpha: .25)
                        : _apiBorder,
                  ),
                ),
              ),
              child: Icon(
                _apiPermissionIcon(permission.iconKey),
                color: selected ? accent : _apiMuted,
                size: ProfileSpacingTokens.profileApiCreatePermissionIcon,
              ),
            ),
          ),
          const SizedBox(
            width: ProfileSpacingTokens.profileApiCreatePermissionIconGap,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        permission.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: selected ? AppColors.text1 : AppColors.text2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (permission.required)
                      Text(
                        ' (b\u1EAFt bu\u1ED9c)',
                        style: AppTextStyles.caption.copyWith(color: _apiMuted),
                      ),
                  ],
                ),
                SizedBox(height: VitDensity.compact.verticalSpace),
                Text(
                  permission.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: _apiMuted),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: ProfileSpacingTokens.profileApiCreatePermissionTrailingGap,
          ),
          _PermissionCheck(selected: selected, color: accent),
        ],
      ),
    );
  }
}

class _PermissionCheck extends StatelessWidget {
  const _PermissionCheck({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ProfileSpacingTokens.profileApiCreatePermissionCheck,
      height: ProfileSpacingTokens.profileApiCreatePermissionCheck,
      child: Material(
        color: selected ? color : AppColors.transparent,
        shape: CircleBorder(
          side: BorderSide(
            color: selected ? color : _apiBorder,
            width: ProfileSpacingTokens.profileApiCreatePermissionCheckBorder,
          ),
        ),
        child: selected
            ? const Icon(
                Icons.check_rounded,
                color: AppColors.onAccent,
                size: ProfileSpacingTokens.profileApiCreatePermissionCheckIcon,
              )
            : null,
      ),
    );
  }
}

class _IpWhitelistSection extends StatelessWidget {
  const _IpWhitelistSection({
    required this.controller,
    required this.ips,
    required this.onAdd,
    required this.onRemove,
  });

  final TextEditingController controller;
  final List<String> ips;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return _FieldSection(
      label: 'IP Whitelist',
      optional: 'khuy\u1EBFn ngh\u1ECB',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _TextInput(
                  key: ApiKeyCreatePage.ipFieldKey,
                  controller: controller,
                  hint: 'VD: 192.168.1.100',
                  onSubmitted: (_) => onAdd(),
                ),
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileApiCreateIpInputGap,
              ),
              SizedBox(
                width: ProfileSpacingTokens.profileApiCreateIpAddWidth,
                child: VitIconButton(
                  icon: Icons.add_rounded,
                  tooltip: 'Th\u00EAm IP whitelist',
                  onPressed: onAdd,
                  variant: VitIconButtonVariant.primary,
                  size: VitIconButtonSize.lg,
                ),
              ),
            ],
          ),
          if (ips.isEmpty) ...[
            SizedBox(height: VitDensity.compact.verticalSpace),
            Text(
              'Kh\u00F4ng c\u00F3 IP whitelist \u2014 key c\u00F3 th\u1EC3 \u0111\u01B0\u1EE3c d\u00F9ng t\u1EEB b\u1EA5t k\u1EF3 \u0111\u00E2u',
              style: AppTextStyles.micro.copyWith(
                color: _apiAmber,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            SizedBox(height: VitDensity.compact.verticalSpace),
            Wrap(
              spacing: ProfileSpacingTokens.profileApiCreateIpChipGap,
              runSpacing: ProfileSpacingTokens.profileApiCreateIpChipGap,
              children: [
                for (final ip in ips)
                  VitChoicePill(
                    label: ip,
                    selected: true,
                    onTap: () => onRemove(ip),
                    tone: VitChoicePillTone.success,
                    height: SharedSpacingTokens.homeChipMinHeight,
                    padding: ProfileSpacingTokens.profileApiCreateIpChipPadding,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ExpirySection extends StatelessWidget {
  const _ExpirySection({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final List<ProfileApiExpiryOption> options;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return _FieldSection(
      label: 'Th\u1EDDi h\u1EA1n',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              ProfileSpacingTokens.profileApiCreateExpiryCrossAxisCount,
          mainAxisSpacing: ProfileSpacingTokens.profileApiCreateExpirySpacing,
          crossAxisSpacing: ProfileSpacingTokens.profileApiCreateExpirySpacing,
          mainAxisExtent: ProfileSpacingTokens.profileApiCreateExpiryExtent,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option.id == selected;
          return VitCard(
            key: ApiKeyCreatePage.expiryKey(option.id),
            onTap: () => onSelect(option.id),
            density: VitDensity.compact,
            variant: isSelected
                ? VitCardVariant.standard
                : VitCardVariant.inner,
            borderColor: isSelected
                ? _apiPrimary.withValues(alpha: .55)
                : _apiBorder,
            padding: ProfileSpacingTokens.profileApiCreateExpiryPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  option.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: isSelected ? _apiPrimary : AppColors.text2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  option.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: _apiMuted),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SecurityTips extends StatelessWidget {
  const _SecurityTips({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _apiBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: _apiPrimary,
                size: ProfileSpacingTokens.profileApiCreateTipsIcon,
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileApiCreateTipsTitleGap,
              ),
              Text(
                'M\u1EB9o b\u1EA3o m\u1EADt',
                style: AppTextStyles.caption.copyWith(
                  color: _apiPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: VitDensity.compact.verticalSpace),
          for (var i = 0; i < tips.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: ProfileSpacingTokens.profileApiCreateTipsBullet,
                  height: ProfileSpacingTokens.profileApiCreateTipsBullet,
                  child: Material(
                    color: _apiPrimary.withValues(alpha: .14),
                    shape: const CircleBorder(),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: AppTextStyles.micro.copyWith(
                          color: _apiPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: ProfileSpacingTokens.profileApiCreateTipsBulletGap,
                ),
                Expanded(
                  child: Text(
                    tips[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (i != tips.length - 1)
              SizedBox(height: VitDensity.compact.verticalSpace),
          ],
        ],
      ),
    );
  }
}
