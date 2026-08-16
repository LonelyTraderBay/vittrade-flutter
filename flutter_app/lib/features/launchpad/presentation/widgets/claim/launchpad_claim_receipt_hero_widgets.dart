part of '../../phone/pages/claim/launchpad_claim_receipt_page.dart';

class _RewardHero extends StatelessWidget {
  const _RewardHero({required this.receipt});

  final LaunchpadRewardClaimReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final claimedPct = (receipt.claimedRatio * 100).round();
    final vestedPct = (receipt.vestedRatio * 100).round();

    return VitCard(
      key: LaunchpadClaimReceiptPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
      padding: LaunchpadSpacingTokens.launchpadPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _TokenAvatar(receipt: receipt),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receipt.projectName,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.portfolioTextMuted,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            _formatNumber(receipt.totalEarned),
                            key: LaunchpadClaimReceiptPage.heroAmountKey,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.pageTitle.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Padding(
                          padding:
                              LaunchpadSpacingTokens.launchpadBottomPaddingX1,
                          child: Text(
                            receipt.rewardToken,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '~${_formatUsd(receipt.totalEarned * receipt.rewardTokenPrice)} USD',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tiến độ mở khóa',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.portfolioTextMuted,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '$vestedPct%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: SizedBox(
              height: AppSpacing.pageRhythmStandardInnerGap,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: AppColors.surface3),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: receipt.vestedRatio.clamp(0, 1),
                    child: ColoredBox(color: receipt.accent.resolve()),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: receipt.claimedRatio.clamp(0, 1),
                    child: const ColoredBox(color: AppColors.buy),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đã nhận $claimedPct%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                'Đã mở $vestedPct%',
                style: AppTextStyles.micro.copyWith(
                  color: receipt.accent.resolve(),
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Đã nhận',
                  value: _formatNumber(receipt.totalClaimed),
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Chờ nhận',
                  value: _formatNumber(receipt.totalPending),
                  color: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Còn khóa',
                  value: _formatNumber(receipt.lockedAmount),
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TokenAvatar extends StatelessWidget {
  const _TokenAvatar({required this.receipt});

  final LaunchpadRewardClaimReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: receipt.projectSymbol,
      accentColor: receipt.accent.resolve(),
      size: LaunchpadSpacingTokens.launchpadBox48,
      radius: AppRadii.lgRadius,
      border: true,
      maxChars: 2,
      fillAlpha: .12,
      borderAlpha: .38,
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
