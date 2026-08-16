part of '../../phone/pages/security/p2p_2fa_settings_page.dart';

class _TwoFactorStatusCard extends StatelessWidget {
  const _TwoFactorStatusCard({
    required this.enabledMethods,
    required this.primaryMethod,
  });

  final int enabledMethods;
  final String primaryMethod;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2P2FASettingsPage.statusKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pTwoFactorCardPadding,
      borderColor: AppColors.buy,
      background: ColoredBox(color: AppColors.buy.withValues(alpha: .9)),
      child: Row(
        children: [
          SizedBox.square(
            dimension: _p2pTwoFactorHeroIconBox,
            child: Material(
              type: MaterialType.transparency,
              color: AppColors.onAccent.withValues(alpha: .18),
              borderRadius: AppRadii.inputRadius,
              child: const Icon(
                Icons.shield_outlined,
                color: AppColors.onAccent,
                size: AppSpacing.iconLg,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2FA đã bật ($enabledMethods phương thức)',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.onAccent,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'Phương thức chính: $primaryMethod',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.onAccent.withValues(alpha: .9),
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodSection extends StatelessWidget {
  const _MethodSection({
    required this.methods,
    required this.onToggle,
    required this.onSetPrimary,
  });

  final List<P2PTwoFactorMethodDraft> methods;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onSetPrimary;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2P2FASettingsPage.methodsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Phương thức xác thực',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
        ),
        VitCard(
          radius: VitCardRadius.large,
          padding: AppSpacing.zeroInsets,
          child: Column(
            children: [
              for (var index = 0; index < methods.length; index++) ...[
                _MethodRow(
                  method: methods[index],
                  onToggle: () => onToggle(methods[index].id),
                  onSetPrimary: () => onSetPrimary(methods[index].id),
                ),
                if (index != methods.length - 1)
                  const Divider(
                    height: AppSpacing.dividerHairline,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MethodRow extends StatelessWidget {
  const _MethodRow({
    required this.method,
    required this.onToggle,
    required this.onSetPrimary,
  });

  final P2PTwoFactorMethodDraft method;
  final VoidCallback onToggle;
  final VoidCallback onSetPrimary;

  @override
  Widget build(BuildContext context) {
    final color = _methodColor(method.colorKey);

    return Padding(
      key: P2P2FASettingsPage.methodKey(method.id),
      padding: P2PSpacingTokens.p2pTwoFactorCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitAccentIconBox(
                icon: _methodIcon(method.iconKey),
                color: method.enabled ? color : AppColors.text3,
                bordered: false,
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
                            method.label,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (method.isPrimary) ...[
                          const SizedBox(width: AppSpacing.x2),
                          const _SmallBadge(
                            label: 'Chính',
                            color: AppColors.buy,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      method.description,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                key: P2P2FASettingsPage.methodSwitchKey(method.id),
                value: method.enabled,
                onChanged: (_) => onToggle(),
                activeThumbColor: AppColors.onAccent,
                activeTrackColor: color,
                inactiveThumbColor: AppColors.onAccent,
                inactiveTrackColor: AppColors.surface3,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
          if (method.setupRequired && !method.enabled) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            const _InlineNotice(
              text: 'Cần setup Authenticator App trước khi sử dụng',
              color: AppColors.warn,
            ),
          ],
          if (method.enabled && !method.isPrimary) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            VitCard(
              radius: VitCardRadius.standard,
              variant: VitCardVariant.inner,
              padding: P2PSpacingTokens.p2pSecurityDetailsActionPadding,
              onTap: onSetPrimary,
              child: Center(
                child: Text(
                  'Đặt làm phương thức chính',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ThresholdSection extends StatelessWidget {
  const _ThresholdSection({required this.thresholds, required this.onToggle});

  final List<P2PTransactionThresholdDraft> thresholds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2P2FASettingsPage.thresholdsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: VitSectionHeader(
                title: 'Ngưỡng giao dịch',
                bottomGap: AppSpacing.pageRhythmStandardInnerGap,
              ),
            ),
            Icon(
              Icons.info_outline_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
          ],
        ),
        VitCard(
          radius: VitCardRadius.large,
          padding: AppSpacing.zeroInsets,
          child: Column(
            children: [
              for (var index = 0; index < thresholds.length; index++) ...[
                _ThresholdRow(
                  threshold: thresholds[index],
                  onToggle: () => onToggle(thresholds[index].id),
                ),
                if (index != thresholds.length - 1)
                  const Divider(
                    height: AppSpacing.dividerHairline,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ThresholdRow extends StatelessWidget {
  const _ThresholdRow({required this.threshold, required this.onToggle});

  final P2PTransactionThresholdDraft threshold;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: P2P2FASettingsPage.thresholdKey(threshold.id),
      padding: P2PSpacingTokens.p2pTwoFactorCardPadding,
      child: Row(
        children: [
          VitAccentIconBox(
            icon: Icons.lock_outline_rounded,
            color: threshold.enabled ? AppModuleAccents.p2p : AppColors.text3,
            bordered: false,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  threshold.label,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  threshold.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                if (threshold.enabled && threshold.valueLabel.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    threshold.valueLabel,
                    style: AppTextStyles.micro.copyWith(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (threshold.editable) ...[
            VitCard(
              radius: VitCardRadius.standard,
              variant: VitCardVariant.inner,
              padding: P2PSpacingTokens.p2pSecurityDetailsEditPadding,
              child: Text(
                'Sửa',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
          Switch(
            key: P2P2FASettingsPage.thresholdSwitchKey(threshold.id),
            value: threshold.enabled,
            onChanged: (_) => onToggle(),
            activeThumbColor: AppColors.onAccent,
            activeTrackColor: AppColors.buy,
            inactiveThumbColor: AppColors.onAccent,
            inactiveTrackColor: AppColors.surface3,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
