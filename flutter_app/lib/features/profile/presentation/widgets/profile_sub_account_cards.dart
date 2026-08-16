part of '../phone/pages/sub_account_page.dart';

class _SubAccountCard extends StatelessWidget {
  const _SubAccountCard({
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
      key: SubAccountPage.accountCardKey(account.id),
      padding: AppSpacing.zeroInsets,
      borderColor: AppColors.cardBorder,
      clip: true,
      child: Column(
        children: [
          Material(
            color: AppColors.transparent,
            child: InkWell(
              key: SubAccountPage.expandKey(account.id),
              onTap: onTap,
              child: Padding(
                padding: ProfileSpacingTokens.profileSubAccountCardTapPadding,
                child: Row(
                  children: [
                    _AccountAvatar(
                      initial: account.name.isEmpty
                          ? '?'
                          : account.name.substring(0, 1),
                      color: typeColor,
                    ),
                    const SizedBox(
                      width: ProfileSpacingTokens.profileSubAccountAvatarGap,
                    ),
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
                              const SizedBox(
                                width: ProfileSpacingTokens
                                    .profileSubAccountTitlePillGap,
                              ),
                              VitAccentPill(
                                label: _typeLabel(account.type),
                                accentColor: typeColor,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: AppSpacing.pageRhythmCompactInnerGap,
                          ),
                          Row(
                            children: [
                              Icon(
                                _statusIcon(account.status),
                                color: statusColor,
                                size: ProfileSpacingTokens
                                    .profileSubAccountStatusIcon,
                              ),
                              const SizedBox(
                                width: ProfileSpacingTokens
                                    .profileSubAccountStatusIconGap,
                              ),
                              Text(
                                _statusLabel(account.status),
                                style: AppTextStyles.micro.copyWith(
                                  color: statusColor,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              const SizedBox(
                                width: ProfileSpacingTokens
                                    .profileSubAccountStatusMetaGap,
                              ),
                              Flexible(
                                child: Text(
                                  '\u00B7 ${account.lastActive}',
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
                    const SizedBox(
                      width: ProfileSpacingTokens.profileSubAccountTrailingGap,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isBalanceHidden
                              ? '\u2022\u2022\u2022\u2022'
                              : _formatUsd(account.balance),
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.extraBold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          isBalanceHidden
                              ? '\u2022\u2022'
                              : _formatSignedUsd(account.pnl30d),
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
          if (isExpanded)
            _SubAccountDetails(account: account, typeColor: typeColor),
        ],
      ),
    );
  }
}
