part of '../phone/pages/referral_rules_page.dart';

class _ReferralRulesSection extends StatelessWidget {
  const _ReferralRulesSection({
    required this.title,
    required this.accentColor,
    this.subtitle,
  });

  final String title;
  final Color accentColor;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitModuleSectionHeader(
          title: title,
          accentColor: accentColor,
          density: VitDensity.compact,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            subtitle!,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ],
    );
  }
}

class _TierTable extends StatelessWidget {
  const _TierTable({required this.snapshot});

  final ReferralRulesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRulesPage.tierTableKey,
      clip: true,
      child: Column(
        children: [
          const _TierHeader(),
          for (var i = 0; i < snapshot.tiers.length; i++) ...[
            _TierRow(
              tier: snapshot.tiers[i],
              current: i == snapshot.currentTierIndex,
            ),
            if (i < snapshot.tiers.length - 1)
              const Divider(
                height: ReferralSpacingTokens.referralDividerHeight,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _TierHeader extends StatelessWidget {
  const _TierHeader();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface2,
      child: Padding(
        padding: ReferralSpacingTokens.referralLedgerHeaderPadding,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'Hạng',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Bạn bè',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Hoa hồng',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Thưởng KYC',
                textAlign: TextAlign.end,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
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

class _TierRow extends StatelessWidget {
  const _TierRow({required this.tier, required this.current});

  final ReferralTierRuleDraft tier;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final icon = switch (tier.id) {
      'bronze' => Icons.workspace_premium_rounded,
      'silver' => Icons.workspace_premium_rounded,
      'gold' => Icons.military_tech_rounded,
      'diamond' => Icons.diamond_rounded,
      _ => Icons.auto_awesome_rounded,
    };

    return ColoredBox(
      key: ReferralRulesPage.tierKey(tier.id),
      color: current ? AppColors.primary08 : AppColors.transparent,
      child: Padding(
        padding: ReferralSpacingTokens.referralLedgerHeaderPadding,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: current ? AppColors.primary : AppColors.text2,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tier.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: current
                                ? AppColors.primary
                                : AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        Text(
                          tier.nameEn,
                          style: AppTextStyles.micro.copyWith(
                            color: current
                                ? AppColors.primary
                                : AppColors.text3,
                          ),
                        ),
                        if (current)
                          Text(
                            'Hiện tại',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.primary,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                tier.minFriends == 0 ? '0' : '≥ ${tier.minFriends}',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${tier.commissionPercent}%',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                _formatUsd(tier.kycBonus),
                textAlign: TextAlign.end,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardTypes extends StatelessWidget {
  const _RewardTypes({required this.snapshot});

  final ReferralRulesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ReferralRulesPage.rewardTypesKey,
      children: [
        for (var i = 0; i < snapshot.rewardTypes.length; i++) ...[
          _RewardTypeCard(rule: snapshot.rewardTypes[i]),
          if (i < snapshot.rewardTypes.length - 1)
            const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _RewardTypeCard extends StatelessWidget {
  const _RewardTypeCard({required this.rule});

  final ReferralRewardTypeRuleDraft rule;

  @override
  Widget build(BuildContext context) {
    final isKyc = rule.id == 'kyc_bonus';
    final color = isKyc ? AppColors.primary : AppColors.buy;
    return VitCard(
      key: ReferralRulesPage.rewardTypeKey(rule.id),
      padding: ReferralSpacingTokens.referralCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: AppSpacing.iconLg + AppSpacing.x3,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: isKyc ? AppColors.primary12 : AppColors.buy10,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              child: Center(
                child: Icon(
                  isKyc
                      ? Icons.card_giftcard_rounded
                      : Icons.trending_up_rounded,
                  color: color,
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
                  rule.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  rule.body,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                VitAccentPill(
                  label: rule.highlight,
                  accentColor: color,
                  size: VitStatusPillSize.sm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
