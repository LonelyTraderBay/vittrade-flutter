part of '../phone/pages/referral_history_page.dart';

class _FriendCard extends StatelessWidget {
  const _FriendCard({
    required this.friend,
    required this.reminded,
    required this.onOpen,
    required this.onRemind,
  });

  final ReferralFriendDraft friend;
  final bool reminded;
  final VoidCallback onOpen;
  final VoidCallback onRemind;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralHistoryPage.friendKey(friend.id),
      onTap: onOpen,
      padding: ReferralSpacingTokens.referralCardPadding,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(initial: friend.initial),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          friend.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        VitStatusPill(
                          label: _statusLabel(friend.status),
                          status: _statusPillStatus(friend.status),
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Tham gia: ${friend.joinedDate}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      friend.totalCommission > 0
                          ? '+${_formatUsd(friend.totalCommission)}'
                          : '—',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: friend.totalCommission > 0
                            ? AppColors.buy
                            : AppColors.text3,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    Text(
                      'Hoa hồng',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _FriendMetric(
                  label: 'KYC',
                  value: friend.kycCompleted ? 'Hoàn tất' : 'Đang chờ',
                  icon: friend.kycCompleted
                      ? Icons.check_circle_rounded
                      : Icons.schedule_rounded,
                  color: friend.kycCompleted ? AppColors.buy : AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _FriendMetric(
                  label: 'Khối lượng GD',
                  value: friend.totalVolume > 0
                      ? _formatUsd(friend.totalVolume)
                      : '—',
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _FriendMetric(
                  label: 'GD đầu tiên',
                  value: friend.firstTradeDate ?? '—',
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          if (friend.canRemindKyc) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            VitCtaButton(
              key: ReferralHistoryPage.remindKey(friend.id),
              onPressed: onRemind,
              variant: VitCtaButtonVariant.secondary,
              height: ReferralSpacingTokens.referralHistoryFilterHeight,
              leading: Icon(
                reminded ? Icons.check_rounded : Icons.send_rounded,
              ),
              child: Text(reminded ? 'Đã nhắc KYC' : 'Nhắc hoàn tất KYC'),
            ),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: initial,
      accentColor: AppColors.surface2,
      size: ReferralSpacingTokens.referralHistoryAvatarBox,
      radius: AppRadii.lgRadius,
      border: true,
      fillAlpha: 1,
      borderAlpha: 1,
      borderColor: AppColors.borderSolid,
      textStyle: AppTextStyles.baseMedium.copyWith(color: AppColors.text2),
    );
  }
}

class _FriendMetric extends StatelessWidget {
  const _FriendMetric({
    required this.label,
    required this.value,
    required this.color,
    this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: Padding(
        padding: ReferralSpacingTokens.referralInnerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: color,
                    size: ReferralSpacingTokens.referralHistoryIconSm,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                ],
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _ReferralStatusPalette {
  const _ReferralStatusPalette({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;
}

String _statusLabel(ReferralFriendStatus status) =>
    _statusPalette(status).label;

VitStatusPillStatus _statusPillStatus(ReferralFriendStatus status) {
  return switch (status) {
    ReferralFriendStatus.pendingKyc => VitStatusPillStatus.warning,
    ReferralFriendStatus.kycDone => VitStatusPillStatus.info,
    ReferralFriendStatus.activeTrader => VitStatusPillStatus.success,
    ReferralFriendStatus.inactive => VitStatusPillStatus.neutral,
  };
}

_ReferralStatusPalette _statusPalette(ReferralFriendStatus status) {
  return switch (status) {
    ReferralFriendStatus.pendingKyc => const _ReferralStatusPalette(
      label: 'Chờ KYC',
      color: AppColors.warn,
      background: AppColors.warn10,
    ),
    ReferralFriendStatus.kycDone => const _ReferralStatusPalette(
      label: 'Đã KYC',
      color: AppColors.primary,
      background: AppColors.primary12,
    ),
    ReferralFriendStatus.activeTrader => const _ReferralStatusPalette(
      label: 'Đang giao dịch',
      color: AppColors.buy,
      background: AppColors.buy10,
    ),
    ReferralFriendStatus.inactive => const _ReferralStatusPalette(
      label: 'Không hoạt động',
      color: AppColors.text3,
      background: AppColors.surface2,
    ),
  };
}

String _formatUsd(double value) => VitFormat.usd(value);
