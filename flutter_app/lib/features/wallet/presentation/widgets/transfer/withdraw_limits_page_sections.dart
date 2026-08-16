part of '../../phone/pages/transfer/withdraw_limits_page.dart';

class _CurrentTierCard extends StatelessWidget {
  const _CurrentTierCard({required this.snapshot});

  final WalletWithdrawLimitsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final tier = snapshot.currentTier;
    final tierColor = Color(tier.colorHex);

    return VitCard(
      key: WithdrawLimitsPage.currentTierKey,
      density: VitDensity.compact,
      radius: VitCardRadius.large,
      borderColor: AppColors.primary20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              DecoratedBox(
                decoration: ShapeDecoration(
                  color: tierColor.withValues(alpha: .14),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.smRadius,
                    side: BorderSide(color: tierColor.withValues(alpha: .5)),
                  ),
                ),
                child: SizedBox(
                  width: _limitsIconBox,
                  height: _limitsIconBox,
                  child: Center(
                    child: Icon(
                      Icons.shield_outlined,
                      color: tierColor,
                      size: WalletSpacingTokens.walletTokenHeroIconGlyph,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: _limitsInlineGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'KYC Level ${tier.level}',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(width: _limitsInlineGap),
                        Flexible(
                          child: VitStatusPill(
                            label: tier.name,
                            icon: Icons.verified_user_outlined,
                            status: VitStatusPillStatus.success,
                            size: VitStatusPillSize.sm,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: _limitsTinyGap),
                    Text(
                      '\u0110\u00E3 x\u00E1c minh',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.check_circle_outline,
                color: tierColor,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
          const SizedBox(height: _limitsGap),
          _LimitProgress(
            key: WithdrawLimitsPage.dailyUsageKey,
            label: 'H\u1EA1n m\u1EE9c r\u00FAt/ng\u00E0y',
            used: snapshot.usedToday,
            limit: tier.dailyLimit,
            remaining: snapshot.dailyRemaining,
            percent: snapshot.dailyPercent,
          ),
          const SizedBox(height: _limitsGap),
          _LimitProgress(
            key: WithdrawLimitsPage.monthlyUsageKey,
            label: 'H\u1EA1n m\u1EE9c r\u00FAt/th\u00E1ng',
            used: snapshot.usedMonth,
            limit: tier.monthlyLimit,
            remaining: snapshot.monthlyRemaining,
            percent: snapshot.monthlyPercent,
          ),
        ],
      ),
    );
  }
}

class _LimitProgress extends StatelessWidget {
  const _LimitProgress({
    super.key,
    required this.label,
    required this.used,
    required this.limit,
    required this.remaining,
    required this.percent,
  });

  final String label;
  final double used;
  final double limit;
  final double remaining;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Flexible(
              child: Text(
                '${_formatUsd(used)} / ${_formatUsd(limit)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: _limitsTinyGap),
        ClipRRect(
          borderRadius: AppRadii.pillRadius,
          child: LinearProgressIndicator(
            minHeight: _limitsProgressHeight,
            value: (percent / 100).clamp(0, 1).toDouble(),
            color: AppColors.buy,
            backgroundColor: AppColors.surface3,
          ),
        ),
        const SizedBox(height: _limitsTinyGap),
        Row(
          children: [
            Expanded(
              child: Text(
                'C\u00F2n l\u1EA1i: ${_formatUsd(remaining)}',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            VitStatusPill(
              label: '${percent.toStringAsFixed(1)}% \u0111\u00E3 d\u00F9ng',
              icon: Icons.speed_rounded,
              status: percent >= 80
                  ? VitStatusPillStatus.warning
                  : VitStatusPillStatus.neutral,
              size: VitStatusPillSize.sm,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.tier});

  final WalletKycTier tier;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        label: 'R\u00FAt/ng\u00E0y t\u1ED1i \u0111a',
        value: _formatUsd(tier.dailyLimit),
        color: AppColors.primary,
        icon: Icons.calendar_today_outlined,
      ),
      (
        label: 'Giao d\u1ECBch \u0111\u01A1n',
        value: _formatUsd(tier.singleTxLimit),
        color: AppColors.buy,
        icon: Icons.receipt_long_outlined,
      ),
      (
        label: 'R\u00FAt/th\u00E1ng',
        value: _formatUsd(tier.monthlyLimit),
        color: AppColors.caution,
        icon: Icons.date_range_outlined,
      ),
    ];

    return Row(
      children: [
        for (final stat in stats) ...[
          Expanded(
            child: VitCard(
              variant: VitCardVariant.inner,
              density: VitDensity.compact,
              borderColor: AppColors.overlayStroke,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(stat.icon, color: stat.color, size: AppSpacing.iconSm),
                  const SizedBox(height: _limitsTinyGap),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      stat.value,
                      style: AppTextStyles.caption.copyWith(
                        color: stat.color,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  const SizedBox(height: _limitsTinyGap),
                  Text(
                    stat.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ),
          if (stat != stats.last) const SizedBox(width: _limitsTinyGap),
        ],
      ],
    );
  }
}

class _LimitWarning extends StatelessWidget {
  const _LimitWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.caution.withValues(alpha: .34),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.caution,
            size: WalletSpacingTokens.walletAddressAddIcon,
          ),
          const SizedBox(width: _limitsInlineGap),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text:
                        'Y\u00EAu c\u1EA7u r\u00FAt tr\u00EAn \$10,000.00 s\u1EBD c\u1EA7n xem x\u00E9t th\u1EE7 c\u00F4ng (l\u00EAn \u0111\u1EBFn 24 gi\u1EDD). ',
                  ),
                  TextSpan(
                    text:
                        'R\u00FAt tr\u00EAn \$50,000.00 c\u1EA7n x\u00E1c minh video call.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.caution,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              style: AppTextStyles.caption.copyWith(color: AppColors.caution),
            ),
          ),
        ],
      ),
    );
  }
}
