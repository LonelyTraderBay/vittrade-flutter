part of 'profile_sub_accounts_pane.dart';

class _SubsAccountCard extends StatelessWidget {
  const _SubsAccountCard({
    required this.account,
    required this.isExpanded,
    required this.isBalanceHidden,
    required this.onTap,
  });

  final ProfileSubAccount account;
  final bool isExpanded;
  final bool isBalanceHidden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(account.type);
    final statusColor = _statusColor(account.status);
    final pnlColor = account.pnl30d >= 0 ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: ProfileTabletKeys.subAccountsCard(account.id),
      padding: TabletSpacingTokens.zeroInsets,
      borderColor: AppColors.cardBorder,
      clip: true,
      child: Column(
        children: [
          Material(
            color: AppColors.transparent,
            child: InkWell(
              key: ProfileTabletKeys.subAccountsExpand(account.id),
              onTap: onTap,
              child: Padding(
                padding: ProfileSpacingTokens.profileSubAccountCardTapPadding,
                child: Row(
                  children: [
                    VitAssetAvatar(
                      label: account.name.isEmpty
                          ? '?'
                          : account.name.substring(0, 1),
                      accentColor: typeColor,
                      size: ProfileSpacingTokens.profileSubAccountAvatarSize,
                      radius: AppRadii.cardRadius,
                    ),
                    const SizedBox(width: TabletSpacingTokens.x4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  account.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.baseMedium.copyWith(
                                    fontWeight: AppTextStyles.extraBold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: TabletSpacingTokens.x4),
                              VitAccentPill(
                                label: _typeLabel(account.type),
                                accentColor: typeColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: TabletSpacingTokens.x4),
                          Row(
                            children: [
                              Icon(
                                _statusIcon(account.status),
                                color: statusColor,
                                size: ProfileSpacingTokens
                                    .profileSubAccountStatusIcon,
                              ),
                              const SizedBox(width: TabletSpacingTokens.x4),
                              Text(
                                _statusLabel(account.status),
                                style: AppTextStyles.micro.copyWith(
                                  color: statusColor,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              const SizedBox(width: TabletSpacingTokens.x4),
                              Flexible(
                                child: Text(
                                  '· ${account.lastActive}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.text3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: TabletSpacingTokens.x4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isBalanceHidden
                              ? '••••'
                              : VitFormat.usd(account.balance),
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.extraBold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x4),
                        Text(
                          isBalanceHidden
                              ? '••'
                              : VitFormat.usdSigned(account.pnl30d),
                          style: AppTextStyles.micro.copyWith(
                            color: pnlColor,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded) _SubsDetails(account: account, typeColor: typeColor),
        ],
      ),
    );
  }
}

class _SubsDetails extends StatelessWidget {
  const _SubsDetails({required this.account, required this.typeColor});

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
          const SizedBox(height: TabletSpacingTokens.x4),
          Row(
            children: [
              Expanded(
                child: VitMetricColumn(
                  label: 'Volume 30d',
                  value: VitFormat.compactSuffix(
                    account.tradingVolume30d,
                    prefix: r'$',
                  ),
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
                  label: 'Tạo ngày',
                  value: account.createdAt,
                  valueColor: AppColors.text2,
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Text(
            'Quyền hạn:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x3,
            children: [
              for (final permission in account.permissions)
                VitAccentPill(
                  label: _permissionLabel(permission),
                  accentColor: AppColors.text3,
                ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
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
          const SizedBox(height: TabletSpacingTokens.x4),
          const Row(
            children: [
              Expanded(
                child: _SubsActionChip(
                  icon: Icons.swap_horiz_rounded,
                  label: 'Chuyển tiền',
                  color: AppColors.primary,
                  background: AppColors.primary08,
                ),
              ),
              SizedBox(width: TabletSpacingTokens.x4),
              Expanded(
                child: _SubsActionChip(
                  icon: Icons.key_rounded,
                  label: 'API Key',
                  color: AppColors.warn,
                  background: AppColors.warn08,
                ),
              ),
              SizedBox(width: TabletSpacingTokens.x4),
              Expanded(
                child: _SubsActionChip(
                  icon: Icons.settings_outlined,
                  label: 'Cài đặt',
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

class _SubsActionChip extends StatelessWidget {
  const _SubsActionChip({
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
            const SizedBox(width: TabletSpacingTokens.x4),
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

class _SubsInfoNote extends StatelessWidget {
  const _SubsInfoNote();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.primary,
            size: ProfileSpacingTokens.profileSubAccountInfoNoteIcon,
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Expanded(
            child: Text(
              'Mỗi tài khoản phụ có ví và API riêng biệt. Bạn có thể tạo tối đa '
              '20 tài khoản phụ. Tài khoản phụ thừa hưởng mức VIP của tài '
              'khoản chính.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _typeColor(String type) {
  return switch (type) {
    'spot' => AppColors.buy,
    'margin' => AppColors.warn,
    'futures' => AppColors.sell,
    _ => AppColors.primary,
  };
}

String _typeLabel(String type) {
  return switch (type) {
    'spot' => 'Spot',
    'margin' => 'Margin',
    'futures' => 'Futures',
    _ => 'Tất cả',
  };
}

Color _statusColor(String status) {
  return switch (status) {
    'frozen' => AppColors.warn,
    'pending' => AppColors.primary,
    _ => AppColors.buy,
  };
}

IconData _statusIcon(String status) {
  return switch (status) {
    'frozen' => Icons.ac_unit_rounded,
    'pending' => Icons.pause_circle_outline_rounded,
    _ => Icons.check_circle_outline_rounded,
  };
}

String _statusLabel(String status) {
  return switch (status) {
    'frozen' => 'Đóng băng',
    'pending' => 'Chờ duyệt',
    _ => 'Hoạt động',
  };
}

String _permissionLabel(String permission) {
  return switch (permission) {
    'spot_trade' => 'Spot',
    'margin_trade' => 'Margin',
    'futures_trade' => 'Futures',
    'transfer' => 'Chuyển',
    'withdraw' => 'Rút',
    'read' => 'Xem',
    _ => permission,
  };
}
