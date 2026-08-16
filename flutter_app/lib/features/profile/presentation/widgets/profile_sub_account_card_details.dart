part of '../phone/pages/sub_account_page.dart';

class _SubAccountDetails extends StatelessWidget {
  const _SubAccountDetails({required this.account, required this.typeColor});

  final ProfileSubAccount account;
  final Color typeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProfileSpacingTokens.profileSubAccountDetailsPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            height: ProfileSpacingTokens.profileSubAccountDetailsDividerHeight,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: VitMetricColumn(
                  label: 'Volume 30d',
                  value: _formatCompact(account.tradingVolume30d, prefix: r'$'),
                  valueColor: AppColors.text1,
                ),
              ),
              Expanded(
                child: VitMetricColumn(
                  label: 'API Keys',
                  value: '${account.apiKeyCount}',
                  valueColor: AppColors.warn,
                ),
              ),
              Expanded(
                child: VitMetricColumn(
                  label: 'T\u1EA1o ng\u00E0y',
                  value: account.createdAt,
                  valueColor: AppColors.text2,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Quy\u1EC1n h\u1EA1n:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Wrap(
            spacing: ProfileSpacingTokens.profileSubAccountPermissionGap,
            runSpacing: ProfileSpacingTokens.profileSubAccountPermissionGap,
            children: [
              for (final permission in account.permissions)
                VitAccentPill(
                  label: _permissionLabel(permission),
                  accentColor: AppColors.text3,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text.rich(
            TextSpan(
              text: 'Email: ',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              children: [
                TextSpan(
                  text: VitFormat.email(account.email),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Row(
            children: [
              Expanded(
                child: _ActionChip(
                  icon: Icons.swap_horiz_rounded,
                  label: 'Chuy\u1EC3n ti\u1EC1n',
                  color: AppColors.primary,
                  background: AppColors.primary08,
                ),
              ),
              SizedBox(width: ProfileSpacingTokens.profileSubAccountActionGap),
              Expanded(
                child: _ActionChip(
                  icon: Icons.key_rounded,
                  label: 'API Key',
                  color: AppColors.warn,
                  background: AppColors.warn08,
                ),
              ),
              SizedBox(width: ProfileSpacingTokens.profileSubAccountActionGap),
              Expanded(
                child: _ActionChip(
                  icon: Icons.settings_outlined,
                  label: 'C\u00E0i \u0111\u1EB7t',
                  color: AppColors.sell,
                  background: AppColors.sell10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: VitDensity.compact.controlHeight),
      child: Material(
        color: background,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: ProfileSpacingTokens.profileSubAccountActionIcon,
            ),
            const SizedBox(
              width: ProfileSpacingTokens.profileSubAccountActionIconGap,
            ),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
