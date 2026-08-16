part of '../../phone/pages/claim/launchpad_claim_receipt_page.dart';

class _ClaimableBanner extends StatelessWidget {
  const _ClaimableBanner({required this.receipt, required this.onClaim});

  final LaunchpadRewardClaimReceiptDraft receipt;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadClaimReceiptPage.claimableKey,
      radius: VitCardRadius.large,
      borderColor: AppColors.buy.withValues(alpha: .30),
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Row(
        children: [
          const SizedBox.square(
            dimension: LaunchpadSpacingTokens.launchpadBox36,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.buy15,
                shape: CircleBorder(),
              ),
              child: Center(
                child: Icon(
                  Icons.card_giftcard_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconMd,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Có thể nhận ngay',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                    height: LaunchpadSpacingTokens.launchpadLineHeightTight,
                  ),
                ),
                Text(
                  '${_formatNumber(receipt.claimableTotal)} ${receipt.rewardToken}',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: LaunchpadSpacingTokens.launchpadBox150,
            child: VitCtaButton(
              onPressed: onClaim,
              variant: VitCtaButtonVariant.success,
              child: const Text('Nhận'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextUnlockCard extends StatelessWidget {
  const _NextUnlockCard({required this.receipt});

  final LaunchpadRewardClaimReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Đợt mở khóa tiếp theo',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                _unlockStateText(receipt.nextUnlockDate),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReceiptDetailsCard extends StatelessWidget {
  const _ReceiptDetailsCard({required this.receipt});

  final LaunchpadRewardClaimReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _DetailRow('Quỹ', receipt.projectName),
      _DetailRow(
        'Token đã stake',
        '${_formatNumber(receipt.stakedAmount)} ${receipt.stakeToken}',
      ),
      _DetailRow(
        'APY',
        '${_formatNumber(receipt.poolApy)}%',
        color: AppColors.buy,
      ),
      _DetailRow('Token thưởng', receipt.rewardToken),
      _DetailRow('Giá token', _formatUsd(receipt.rewardTokenPrice)),
      _DetailRow(
        'Tổng đã nhận',
        '${_formatNumber(receipt.totalEarned)} ${receipt.rewardToken}',
      ),
      _DetailRow(
        'Giá trị đã nhận',
        _formatUsd(receipt.totalEarned * receipt.rewardTokenPrice),
      ),
      _DetailRow('Chuỗi', receipt.chain),
      _DetailRow('Hợp đồng', _truncateAddress(receipt.contractAddress)),
    ];

    return VitCard(
      key: LaunchpadClaimReceiptPage.detailsKey,
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Chi tiết vị trí',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final row in rows) _DetailLine(row: row),
        ],
      ),
    );
  }
}

class _VestingPreviewCard extends StatelessWidget {
  const _VestingPreviewCard({required this.receipt, required this.onOpenAll});

  final LaunchpadRewardClaimReceiptDraft receipt;
  final VoidCallback onOpenAll;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadClaimReceiptPage.vestingPreviewKey,
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.accent,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Lịch mở khóa',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              VitCtaButton(
                onPressed: onOpenAll,
                variant: VitCtaButtonVariant.ghost,
                fullWidth: false,
                height: AppSpacing.buttonCompact,
                child: const Text('Xem tất cả'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final entry in receipt.vestingSchedule.take(4))
            _VestingMiniRow(entry: entry),
          if (receipt.vestingSchedule.length > 4)
            Padding(
              padding: LaunchpadSpacingTokens.launchpadTopPaddingX2,
              child: Text(
                '+${receipt.vestingSchedule.length - 4} đợt nữa',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ),
        ],
      ),
    );
  }
}
