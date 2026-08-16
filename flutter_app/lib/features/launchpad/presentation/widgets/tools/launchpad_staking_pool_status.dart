part of '../../phone/pages/tools/launchpad_staking_page.dart';

class _CapacityBar extends StatelessWidget {
  const _CapacityBar({required this.pool});

  final LaunchpoolPoolDraft pool;

  @override
  Widget build(BuildContext context) {
    final percentage = (pool.fillRatio * 100).clamp(0, 100).toDouble();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Dung lượng pool',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            minHeight: AppSpacing.x2,
            value: percentage / 100,
            backgroundColor: AppColors.surface3,
            valueColor: AlwaysStoppedAnimation<Color>(pool.accent.resolve()),
          ),
        ),
      ],
    );
  }
}

class _TierChip extends StatelessWidget {
  const _TierChip({required this.tier, required this.selected});

  final LaunchpadStakingTierDraft tier;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: selected
            ? tier.accent.resolve().withValues(alpha: .12)
            : AppColors.surface2,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: selected
                ? tier.accent.resolve().withValues(alpha: .34)
                : AppColors.cardBorder,
          ),
          borderRadius: AppRadii.smRadius,
        ),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadTierChipPadding,
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                tier.label,
                style: AppTextStyles.micro.copyWith(
                  color: tier.accent.resolve(),
                  fontWeight: AppTextStyles.bold,
                  height: LaunchpadSpacingTokens.launchpadLineHeightTight,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              '+${_formatApy(tier.apyBonus)}%',
              style: AppTextStyles.chartLabelXs.copyWith(
                color: AppColors.text2,
                height: LaunchpadSpacingTokens.launchpadLineHeightTight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserStakeSummary extends StatelessWidget {
  const _UserStakeSummary({required this.pool});

  final LaunchpoolPoolDraft pool;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: pool.accent.resolve().withValues(alpha: .18),
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Row(
        children: [
          Expanded(
            child: _SummaryText(
              label: 'Bạn đang stake',
              value: _formatUsd(pool.userStaked),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryText(
              label: 'Phần thưởng chờ',
              value: '${_formatToken(pool.userRewards)} ${pool.rewardToken}',
              alignEnd: true,
              valueColor: AppColors.warn,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryText extends StatelessWidget {
  const _SummaryText({
    required this.label,
    required this.value,
    this.alignEnd = false,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final bool alignEnd;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineStatus extends StatelessWidget {
  const _TimelineStatus({required this.status});

  final LaunchpoolPoolStatus status;

  @override
  Widget build(BuildContext context) {
    final (text, color, icon) = switch (status) {
      LaunchpoolPoolStatus.upcoming => (
        'Sắp mở',
        AppColors.warn,
        Icons.schedule_rounded,
      ),
      LaunchpoolPoolStatus.active => (
        'Đang diễn ra',
        AppColors.buy,
        Icons.check_circle_outline_rounded,
      ),
      LaunchpoolPoolStatus.ended => (
        'Đã kết thúc',
        AppColors.text2,
        Icons.check_circle_outline_rounded,
      ),
    };
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _PoolAction extends StatelessWidget {
  const _PoolAction({required this.pool});

  final LaunchpoolPoolDraft pool;

  @override
  Widget build(BuildContext context) {
    if (pool.status == LaunchpoolPoolStatus.upcoming) {
      return VitCard(
        variant: VitCardVariant.inner,
        borderColor: AppColors.warningBorder,
        padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.schedule_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Sắp mở',
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (pool.status == LaunchpoolPoolStatus.ended) {
      return const VitCtaButton(
        onPressed: null,
        leading: Icon(Icons.lock_outline_rounded),
        child: Text('Đã kết thúc'),
      );
    }

    return VitCtaButton(
      variant: VitCtaButtonVariant.primary,
      leading: const Icon(Icons.currency_exchange_rounded),
      onPressed: HapticFeedback.selectionClick,
      child: Text(pool.userStaked > 0 ? 'Stake thêm' : 'Bắt đầu stake'),
    );
  }
}
