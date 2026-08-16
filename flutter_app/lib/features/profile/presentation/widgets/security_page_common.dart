part of '../phone/pages/security_page.dart';

class _AntiPhishingCard extends StatelessWidget {
  const _AntiPhishingCard({
    required this.controller,
    required this.saving,
    required this.onSave,
  });

  final TextEditingController controller;
  final bool saving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _securityBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: _securityPrimary,
                size: ProfileSpacingTokens.securityAntiPhishingIcon,
              ),
              const SizedBox(width: ProfileSpacingTokens.securityIconGap),
              Text(
                'M\u00E3 ch\u1ED1ng l\u1EEBa \u0111\u1EA3o',
                style: AppTextStyles.control.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            '\u0110\u1EB7t m\u00E3 c\u00E1 nh\u00E2n. Email t\u1EEB VitTrade s\u1EBD lu\u00F4n hi\u1EC3n th\u1ECB m\u00E3 n\u00E0y.',
            style: AppTextStyles.numericMicro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Tr\u01B0\u1EDBc khi L\u01B0u: xem tr\u01B0\u1EDBc m\u00E3 \u00B7 ch\u1EC9 d\u00F9ng email VitTrade th\u1EADt \u00B7 kh\u00F4ng ho\u00E0n t\u00E1c ngay sau x\u00E1c nh\u1EADn.',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitInput(
            fieldKey: SecurityPage.antiPhishingFieldKey,
            controller: controller,
            semanticLabel: 'Mã chống lừa đảo',
            hintText: 'Nh\u1EADp m\u00E3 4\u20138 k\u00FD t\u1EF1',
            inputFormatters: [LengthLimitingTextInputFormatter(8)],
            suffix: SizedBox(
              width: ProfileSpacingTokens.securitySaveButtonWidth,
              child: Semantics(
                button: true,
                enabled: !saving,
                label: saving
                    ? 'Đang lưu mã chống lừa đảo'
                    : 'Lưu mã chống lừa đảo',
                child: VitCtaButton(
                  key: SecurityPage.antiPhishingSaveKey,
                  onPressed: saving ? null : onSave,
                  loading: saving,
                  density: VitDensity.compact,
                  padding: EdgeInsets.zero,
                  child: Text(saving ? '...' : 'L\u01B0u'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecuritySupportCard extends StatelessWidget {
  const _SecuritySupportCard({required this.supportRoute});

  final String supportRoute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SecurityPage.supportKey,
      onTap: () => context.go(supportRoute),
      density: VitDensity.compact,
      borderColor: _securityBorder,
      child: VitIconListRow(
        gap: ProfileSpacingTokens.securitySupportGap,
        leading: SizedBox(
          width: ProfileSpacingTokens.securitySupportIconBox,
          height: ProfileSpacingTokens.securitySupportIconBox,
          child: Material(
            color: _securityPrimary.withValues(alpha: .13),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.lgRadius,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: _securityPrimary,
              size: ProfileSpacingTokens.securitySupportIcon,
            ),
          ),
        ),
        title: Text(
          'Hỗ trợ bảo mật',
          style: AppTextStyles.control.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        subtitle: Text(
          'Mở hồ sơ hỗ trợ kèm ngữ cảnh tài khoản',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.numericMicro.copyWith(
            color: _securityMuted,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.text3,
          size: ProfileSpacingTokens.securityChevron,
        ),
      ),
    );
  }
}
