part of '../../phone/pages/hub/launchpad_portfolio_page.dart';

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.subscription,
    required this.receiptRoute,
  });

  final LaunchpadSubscriptionDraft subscription;
  final String receiptRoute;

  @override
  Widget build(BuildContext context) {
    final status = _subscriptionStatus(subscription.status);
    final hasClaimable =
        subscription.status == LaunchpadSubscriptionStatus.allocated ||
        subscription.status == LaunchpadSubscriptionStatus.partiallyAllocated;
    final hasRefund =
        subscription.refundAmount > 0 &&
        subscription.status == LaunchpadSubscriptionStatus.partiallyAllocated;

    return VitCard(
      key: LaunchpadPortfolioPage.subscriptionKey(subscription.id),
      radius: VitCardRadius.standard,
      padding: VitDensity.compact.cardPadding,
      onTap: () => context.go(receiptRoute),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SubscriptionAvatar(subscription: subscription),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.projectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: _launchpadPortfolioLineHeightLabel,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      subscription.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              VitStatusPill(
                label: status.label,
                status: status.pillStatus,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _KpiColumn(
                  label: 'Đã đầu tư',
                  value: _formatUsd(subscription.amount),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _KpiColumn(
                  label: 'Token phân bổ',
                  value:
                      '${_formatInt(subscription.tokensAllocated)} ${subscription.projectSymbol}',
                ),
              ),
            ],
          ),
          if (subscription.allocationRatio > 0 &&
              subscription.allocationRatio < 1) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            _InlineNotice(
              icon: Icons.info_outline_rounded,
              label:
                  'Phân bổ ${(subscription.allocationRatio * 100).round()}% — Hoàn lại: ${_formatUsd(subscription.refundAmount)}',
              color: AppColors.warn,
            ),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _VestingProgress(subscription: subscription),
          if (hasClaimable || hasRefund) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            if (hasClaimable)
              VitCtaButton(
                key: LaunchpadPortfolioPage.claimKey(subscription.id),
                density: VitDensity.compact,
                variant: VitCtaButtonVariant.success,
                leading: const Icon(Icons.lock_open_rounded),
                onPressed: HapticFeedback.selectionClick,
                child: const Text('Có token sẵn sàng nhận'),
              ),
            if (hasClaimable && hasRefund)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            if (hasRefund)
              VitCtaButton(
                key: LaunchpadPortfolioPage.refundKey(subscription.id),
                density: VitDensity.compact,
                variant: VitCtaButtonVariant.secondary,
                leading: const Icon(Icons.file_download_outlined),
                onPressed: HapticFeedback.selectionClick,
                child: Text(
                  'Nhận hoàn ${_formatUsd(subscription.refundAmount)} USDT',
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _SubscriptionAvatar extends StatelessWidget {
  const _SubscriptionAvatar({required this.subscription});

  final LaunchpadSubscriptionDraft subscription;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.x7,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: subscription.accent.resolve().withValues(alpha: .12),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.lgRadius,
            side: BorderSide(
              color: subscription.accent.resolve().withValues(alpha: .35),
            ),
          ),
        ),
        child: Center(
          child: Text(
            subscription.projectLogo,
            style: AppTextStyles.baseMedium.copyWith(
              color: subscription.accent.resolve(),
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _KpiColumn extends StatelessWidget {
  const _KpiColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _VestingProgress extends StatelessWidget {
  const _VestingProgress({required this.subscription});

  final LaunchpadSubscriptionDraft subscription;

  @override
  Widget build(BuildContext context) {
    final total = _formatInt(subscription.tokensAllocated);
    final claimed = _formatInt(subscription.tokensClaimed);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Lịch mở khóa',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              '$claimed / $total ${subscription.projectSymbol}',
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
          child: SizedBox(
            height: AppSpacing.pageRhythmCompactInnerGap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.surface3),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (subscription.vestingProgress / 100).clamp(
                    0.0,
                    1.0,
                  ),
                  child: const ColoredBox(color: AppModuleAccents.launchpad),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          '${subscription.vestingProgress}% đã mở khóa · Tiếp theo: ${subscription.nextUnlockDate}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _InlineNotice extends StatelessWidget {
  const _InlineNotice({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: LaunchpadSpacingTokens.launchpadLineHeightShort,
            ),
          ),
        ),
      ],
    );
  }
}
