part of '../../phone/pages/tools/launchpad_staking_page.dart';

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.snapshot});

  final LaunchpadStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.positions.isEmpty) {
      return VitCard(
        padding: LaunchpadSpacingTokens.launchpadPaddingX6,
        child: Column(
          children: [
            const Icon(
              Icons.currency_exchange_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconLg,
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            Text(
              'Chưa có vị trí nào',
              style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              'Bắt đầu stake vào pool để nhận phần thưởng token mới.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        VitCard(
          key: LaunchpadStakingPage.batchClaimKey,
          radius: VitCardRadius.large,
          borderColor: AppColors.buy20,
          padding: LaunchpadSpacingTokens.launchpadPaddingX4,
          onTap: () => context.go(snapshot.batchClaimRoute),
          child: Row(
            children: [
              const SizedBox(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.buy15,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.smRadius,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.bolt_rounded,
                      color: AppColors.buy,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nhận hàng loạt',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Nhận phần thưởng từ tất cả vị trí cùng lúc',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        for (final position in snapshot.positions) ...[
          _PositionCard(
            position: position,
            claimReceiptRoute: snapshot.claimReceiptRoute,
          ),
          if (position != snapshot.positions.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        ],
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({
    required this.position,
    required this.claimReceiptRoute,
  });

  final LaunchpadStakePositionDraft position;
  final String claimReceiptRoute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadStakingPage.positionKey(position.id),
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _LogoBadge(
                label: position.projectSymbol.length > 2
                    ? position.projectSymbol.substring(0, 2)
                    : position.projectSymbol,
                color: position.accent.resolve(),
                size: AppSpacing.x7,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      position.projectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.extraBold,
                      ),
                    ),
                    Text(
                      'Stake ${position.stakeToken} · Earn ${position.rewardToken}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const VitStatusPill(
                label: 'Đang stake',
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Số lượng stake',
                  value: _formatUsd(position.stakedAmount),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InfoTile(
                  label: 'APY',
                  value: '${_formatApy(position.apy)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Phần thưởng chờ',
                  value:
                      '${_formatToken(position.pendingRewards)} ${position.rewardToken}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InfoTile(
                  label: 'Đã nhận',
                  value:
                      '${_formatToken(position.claimedRewards)} ${position.rewardToken}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warn15,
            padding: LaunchpadSpacingTokens.launchpadPaddingX4,
            child: Row(
              children: [
                const Icon(
                  Icons.lock_clock_rounded,
                  color: AppColors.warn,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    'Khóa đến: ${position.lockUntil}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: LaunchpadStakingPage.claimKey(position.id),
                  variant: VitCtaButtonVariant.secondary,
                  height: AppSpacing.buttonCompact,
                  leading: const Icon(Icons.redeem_rounded),
                  onPressed: () => context.go(claimReceiptRoute),
                  child: const Text('Nhận thưởng'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Expanded(
                child: VitCtaButton(
                  variant: VitCtaButtonVariant.ghost,
                  height: AppSpacing.buttonCompact,
                  leading: Icon(Icons.lock_open_rounded),
                  onPressed: HapticFeedback.selectionClick,
                  child: Text('Unstake'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
