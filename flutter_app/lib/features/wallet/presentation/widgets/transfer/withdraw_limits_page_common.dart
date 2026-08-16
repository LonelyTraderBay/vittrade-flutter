part of '../../phone/pages/transfer/withdraw_limits_page.dart';

class _KycTierCard extends StatelessWidget {
  const _KycTierCard({required this.tier, required this.currentLevel});

  final WalletKycTier tier;
  final int currentLevel;

  @override
  Widget build(BuildContext context) {
    final tierColor = Color(tier.colorHex);
    final isCurrent = tier.level == currentLevel;
    final isCompleted = tier.level < currentLevel;
    final isLocked = tier.level > currentLevel;
    final stateLabel = isLocked
        ? 'C\u1EA7n KYC'
        : isCurrent
        ? 'HI\u1EC6N T\u1EA0I'
        : '\u0110\u00E3 m\u1EDF';
    final stateIcon = isLocked
        ? Icons.lock_outline_rounded
        : isCompleted
        ? Icons.check_circle_outline_rounded
        : Icons.star_border_rounded;
    final stateStatus = isLocked
        ? VitStatusPillStatus.warning
        : isCurrent
        ? VitStatusPillStatus.info
        : VitStatusPillStatus.success;

    return Semantics(
      button: isLocked,
      label:
          '$stateLabel Cấp KYC ${tier.level}, ${tier.name}, hạn mức ngày ${_formatUsd(tier.dailyLimit)}',
      child: VitCard(
        key: WithdrawLimitsPage.tierKey(tier.level),
        onTap: isLocked ? () => context.go(AppRoutePaths.profileKyc) : null,
        constraints: const BoxConstraints(
          minHeight: AppSpacing.inputHeight + AppSpacing.x5,
        ),
        density: VitDensity.compact,
        borderColor: isCurrent
            ? tierColor.withValues(alpha: .45)
            : AppColors.overlayStroke,
        child: Row(
          children: [
            // card-tile: allow-start — fixed surface, not horizontal strip tile
            VitCard(
              width: _limitsIconBox,
              height: _limitsIconBox,
              variant: VitCardVariant.ghost,
              radius: VitCardRadius.large,
              borderColor: tierColor.withValues(alpha: isCurrent ? .45 : .26),
              background: ColoredBox(
                color: tierColor.withValues(alpha: isCurrent ? .15 : .12),
              ),
              clip: true,
              alignment: Alignment.center,
              child: Icon(
                stateIcon,
                color: tierColor,
                size: WalletSpacingTokens.transferActionIcon,
              ),
            ),
            const SizedBox(width: _limitsInlineGap),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Level ${tier.level}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(width: _limitsTinyGap),
                      Flexible(
                        child: Text(
                          tier.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: tierColor,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: _limitsTinyGap),
                  Text(
                    tier.dailyLimit > 0
                        ? '${_formatUsd(tier.dailyLimit)}/ng\u00E0y'
                        : 'Kh\u00F4ng c\u00F3 h\u1EA1n m\u1EE9c',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: _limitsTinyGap),
            if (isLocked)
              VitStatusPill(
                key: WithdrawLimitsPage.upgradeKycKey,
                label: 'X\u00E1c minh KYC',
                icon: Icons.open_in_new_rounded,
                status: stateStatus,
                size: VitStatusPillSize.sm,
              )
            else
              VitStatusPill(
                label: stateLabel,
                icon: stateIcon,
                status: stateStatus,
                size: VitStatusPillSize.sm,
              ),
          ],
        ),
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.faqs});

  final List<WalletLimitFaq> faqs;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.overlayStroke,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: AlignmentDirectional.centerEnd,
            child: VitStatusPill(
              label: 'FAQ t\u0129nh',
              icon: Icons.article_outlined,
              status: VitStatusPillStatus.neutral,
              size: VitStatusPillSize.sm,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
          for (var i = 0; i < faqs.length; i++) ...[
            Text(
              faqs[i].question,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: _limitsTinyGap),
            Text(
              faqs[i].answer,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            if (i != faqs.length - 1) ...[
              const SizedBox(height: _limitsGap),
              const Divider(
                height: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
              const SizedBox(height: _limitsGap),
            ],
          ],
        ],
      ),
    );
  }
}

String _formatUsd(double value) => VitFormat.usd(value);
