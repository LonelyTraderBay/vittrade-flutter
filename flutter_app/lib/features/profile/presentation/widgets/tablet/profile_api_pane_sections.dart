part of 'profile_api_pane.dart';

class _ApiPaneKeyCard extends StatelessWidget {
  const _ApiPaneKeyCard({
    required this.apiKey,
    required this.showSecret,
    required this.copiedId,
    required this.onToggle,
    required this.onReveal,
    required this.onCopy,
    required this.onDelete,
  });

  final ProfileApiKey apiKey;
  final bool showSecret;
  final String? copiedId;
  final VoidCallback onToggle;
  final VoidCallback onReveal;
  final void Function(String id, String value) onCopy;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final active = apiKey.isActive;
    return Opacity(
      opacity: active ? 1 : .65,
      child: VitCard(
        key: ProfileTabletKeys.apiKeyCard(apiKey.id),
        density: VitDensity.compact,
        borderColor: active
            ? AppColors.cardBorder
            : AppColors.sell.withValues(alpha: .12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ApiPaneKeyHeader(apiKey: apiKey, onToggle: onToggle),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            _ApiPaneSecretRow(
              label: 'API KEY',
              value: _maskedKey(apiKey.key),
              labelColor: AppColors.text3,
              trailing: _ApiPaneIconTap(
                icon: copiedId == '${apiKey.id}_key'
                    ? Icons.check_circle_outline_rounded
                    : Icons.copy_rounded,
                onTap: () => onCopy('${apiKey.id}_key', apiKey.key),
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            _ApiPaneSecretRow(
              label: 'SECRET',
              value: showSecret ? apiKey.secret : '••••••••••••••••••••••',
              labelColor: AppColors.sell,
              redBorder: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ApiPaneIconTap(
                    buttonKey: ProfileTabletKeys.apiKeyReveal(apiKey.id),
                    icon: showSecret
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    tooltip: showSecret ? 'Ẩn secret' : 'Hiện secret',
                    onTap: onReveal,
                  ),
                  if (showSecret) ...[
                    const SizedBox(width: AppSpacing.x1),
                    _ApiPaneIconTap(
                      icon: copiedId == '${apiKey.id}_secret'
                          ? Icons.check_circle_outline_rounded
                          : Icons.copy_rounded,
                      onTap: () => onCopy('${apiKey.id}_secret', apiKey.secret),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            _ApiPanePermissionBadges(apiKey: apiKey),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            _ApiPaneUsageRow(apiKey: apiKey),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Row(
              children: [
                Expanded(
                  child: VitCtaButton(
                    onPressed: () {
                      unawaited(HapticFeedback.selectionClick());
                      unawaited(
                        showVitNoticeSheet(
                          context: context,
                          title: 'Sắp ra mắt',
                          message: 'Tạo lại Secret sẽ sớm ra mắt',
                        ),
                      );
                    },
                    density: VitDensity.compact,
                    variant: VitCtaButtonVariant.secondary,
                    leading: const Icon(Icons.sync_rounded),
                    child: const Text('Tạo lại Secret'),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                VitIconButton(
                  key: ProfileTabletKeys.apiKeyDelete(apiKey.id),
                  icon: Icons.delete_outline_rounded,
                  tooltip: 'Xóa API key',
                  onPressed: onDelete,
                  variant: VitIconButtonVariant.danger,
                  size: VitIconButtonSize.md,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ApiPaneKeyHeader extends StatelessWidget {
  const _ApiPaneKeyHeader({required this.apiKey, required this.onToggle});

  final ProfileApiKey apiKey;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final active = apiKey.isActive;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: ProfileSpacingTokens.profileApiIconBox,
          height: ProfileSpacingTokens.profileApiIconBox,
          child: VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.tight,
            clip: true,
            padding: EdgeInsets.zero,
            borderColor: active
                ? AppColors.primary.withValues(alpha: .22)
                : AppColors.sell.withValues(alpha: .22),
            background: ColoredBox(
              color: active
                  ? AppColors.primary.withValues(alpha: .15)
                  : AppColors.sell.withValues(alpha: .12),
            ),
            child: Icon(
              Icons.key_rounded,
              color: active ? AppColors.primary : AppColors.sell,
              size: ProfileSpacingTokens.profileApiIcon,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      apiKey.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.extraBold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  VitAccentPill(
                    label: active ? '• Active' : '• Disabled',
                    accentColor: active ? AppColors.buy : AppColors.sell,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                'Tạo: ${apiKey.createdAt} • ${apiKey.expiresAt == null ? 'Không hết hạn' : 'Hết hạn: ${apiKey.expiresAt}'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        VitTogglePill(
          key: ProfileTabletKeys.apiKeyToggle(apiKey.id),
          enabled: active,
          onChanged: (_) => onToggle(),
          width: ProfileSpacingTokens.profileApiToggleWidth,
          height: ProfileSpacingTokens.profileApiToggleHeight,
          knobSize: ProfileSpacingTokens.profileApiToggleKnob,
          knobMargin: ProfileSpacingTokens.profileApiToggleKnobMargin,
          activeColor: AppColors.buy.withValues(alpha: .16),
          activeKnobColor: AppColors.buy,
          inactiveColor: AppColors.transparent,
          inactiveKnobColor: AppColors.borderSolid,
        ),
      ],
    );
  }
}

class _ApiPaneSecretRow extends StatelessWidget {
  const _ApiPaneSecretRow({
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
          ? AppColors.sell.withValues(alpha: .12)
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

class _ApiPaneIconTap extends StatelessWidget {
  const _ApiPaneIconTap({
    this.buttonKey,
    required this.icon,
    required this.onTap,
    this.tooltip = 'Sao chép',
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

class _ApiPanePermissionBadges extends StatelessWidget {
  const _ApiPanePermissionBadges({required this.apiKey});

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
            accentColor: AppColors.buy,
          )
        else
          const VitAccentPill(
            label: 'Không giới hạn IP',
            accentColor: AppColors.warn,
          ),
      ],
    );
  }
}

class _ApiPaneUsageRow extends StatelessWidget {
  const _ApiPaneUsageRow({required this.apiKey});

  final ProfileApiKey apiKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          color: AppColors.text3,
          size: ProfileSpacingTokens.profileApiUsageIcon,
        ),
        const SizedBox(width: ProfileSpacingTokens.profileApiUsageGapInline),
        Expanded(
          child: Text(
            'Dùng lần cuối: ${apiKey.lastUsed ?? 'Chưa dùng'}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          '${VitFormat.count(apiKey.requestCount)} requests',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _ApiDocsCard extends StatelessWidget {
  const _ApiDocsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        unawaited(
          showVitNoticeSheet(
            context: context,
            title: 'Sắp ra mắt',
            message: 'Tài liệu API sẽ sớm ra mắt',
          ),
        );
      },
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: VitIconListRow(
        gap: AppSpacing.x3,
        leading: SizedBox(
          width: ProfileSpacingTokens.profileApiDocsIconBox,
          height: ProfileSpacingTokens.profileApiDocsIconBox,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: AppColors.primary.withValues(alpha: .1),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: AppColors.primary,
              size: ProfileSpacingTokens.profileApiDocsIcon,
            ),
          ),
        ),
        title: Text(
          'Tài liệu API',
          style: AppTextStyles.body.copyWith(
            fontWeight: AppTextStyles.extraBold,
          ),
        ),
        subtitle: Text(
          'Xem hướng dẫn tích hợp và endpoint',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.text3,
          size: ProfileSpacingTokens.profileApiDocsChevron,
        ),
      ),
    );
  }
}

String _maskedKey(String value) {
  if (value.length <= 18) return value;
  return '${value.substring(0, 12)}••••••••••••${value.substring(value.length - 6)}';
}

String _permissionLabel(String id) {
  return switch (id) {
    'trade' => 'Giao dịch',
    'withdraw' => 'Rút tiền',
    _ => 'Đọc',
  };
}

Color _permissionColor(String id) {
  return switch (id) {
    'trade' => AppColors.warn,
    'withdraw' => AppColors.sell,
    _ => AppColors.primary,
  };
}
