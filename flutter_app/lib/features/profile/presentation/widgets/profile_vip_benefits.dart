part of '../phone/pages/vip_page.dart';

class _BenefitsTab extends StatelessWidget {
  const _BenefitsTab({
    super.key,
    required this.snapshot,
    required this.onTrade,
  });

  final ProfileVipSnapshot snapshot;
  final VoidCallback onTrade;

  @override
  Widget build(BuildContext context) {
    final nextTier = snapshot.nextTier;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final tier in snapshot.tiers.where((tier) => tier.level > 0)) ...[
          _BenefitTierCard(
            tier: tier,
            unlocked: snapshot.currentLevel >= tier.level,
          ),
          SizedBox(height: VitDensity.compact.pageContentGap),
        ],
        if (nextTier != null) _UpgradeCta(nextTier: nextTier, onTrade: onTrade),
      ],
    );
  }
}

class _BenefitTierCard extends StatelessWidget {
  const _BenefitTierCard({required this.tier, required this.unlocked});

  final ProfileVipTier tier;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final accent = unlocked ? _vipGold : _vipProfileAccent;
    return Opacity(
      opacity: unlocked ? 1 : .68,
      child: VitCard(
        borderColor: accent.withValues(alpha: unlocked ? .34 : .14),
        clip: true,
        child: Column(
          children: [
            Material(
              color: accent.withValues(alpha: unlocked ? .12 : .04),
              child: Padding(
                padding: ProfileSpacingTokens.profileVipBenefitHeaderPadding,
                child: Row(
                  children: [
                    _TierIcon(tier: tier),
                    const SizedBox(
                      width: ProfileSpacingTokens.profileVipBenefitIconGap,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tier.name,
                            style: AppTextStyles.base.copyWith(
                              color: accent,
                              fontWeight: AppTextStyles.heavy,
                            ),
                          ),
                          const SizedBox(
                            height: AppSpacing.pageRhythmCompactInnerGap,
                          ),
                          Text(
                            'Volume >= ${_formatUsd(tier.monthlyVolume)}/th\u00E1ng ho\u1EB7c T\u00E0i s\u1EA3n >= ${_formatUsd(tier.assetHold)}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: _vipMuted,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      unlocked
                          ? Icons.check_circle_outline_rounded
                          : Icons.lock_outline_rounded,
                      color: accent,
                      size: ProfileSpacingTokens.profileVipBenefitStateIcon,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
            Padding(
              padding: ProfileSpacingTokens.profileVipBenefitBodyPadding,
              child: Column(
                children: [
                  for (final feature in tier.features) ...[
                    _FeatureLine(
                      text: feature,
                      accent: accent,
                      unlocked: unlocked,
                    ),
                    if (feature != tier.features.last)
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                  ],
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  const Divider(
                    height: AppSpacing.dividerHairline,
                    color: AppColors.divider,
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Row(
                    children: [
                      _BenefitMetric(
                        label: 'Maker',
                        value: _formatFee(tier.makerFee),
                        active: unlocked,
                      ),
                      const SizedBox(
                        width: ProfileSpacingTokens
                            .profileVipBenefitMetricColumnGap,
                      ),
                      _BenefitMetric(
                        label: 'Taker',
                        value: _formatFee(tier.takerFee),
                        active: unlocked,
                      ),
                      const SizedBox(
                        width: ProfileSpacingTokens
                            .profileVipBenefitMetricColumnGap,
                      ),
                      Expanded(
                        child: _BenefitMetric(
                          label: 'H\u1EA1n m\u1EE9c r\u00FAt',
                          value:
                              '${_formatCompactUsd(tier.withdrawLimit)}/ng\u00E0y',
                          active: unlocked,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureLine extends StatelessWidget {
  const _FeatureLine({
    required this.text,
    required this.accent,
    required this.unlocked,
  });

  final String text;
  final Color accent;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: ProfileSpacingTokens.profileVipBenefitFeatureIconBox,
          height: ProfileSpacingTokens.profileVipBenefitFeatureIconBox,
          child: Material(
            color: accent.withValues(alpha: unlocked ? .18 : .07),
            shape: const CircleBorder(),
            child: Icon(
              Icons.check_rounded,
              color: unlocked ? accent : _vipMuted,
              size: ProfileSpacingTokens.profileVipBenefitFeatureIcon,
            ),
          ),
        ),
        const SizedBox(
          width: ProfileSpacingTokens.profileVipBenefitFeatureIconGap,
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: unlocked ? AppColors.text1 : _vipMuted,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _BenefitMetric extends StatelessWidget {
  const _BenefitMetric({
    required this.label,
    required this.value,
    required this.active,
  });

  final String label;
  final String value;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.micro.copyWith(color: _vipMuted)),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? _vipSuccess : AppColors.text2,
            fontWeight: AppTextStyles.heavy,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _UpgradeCta extends StatelessWidget {
  const _UpgradeCta({required this.nextTier, required this.onTrade});

  final ProfileVipTier nextTier;
  final VoidCallback onTrade;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _vipAccent.withValues(alpha: .24),
      padding: ProfileSpacingTokens.profileVipUpgradePadding,
      child: Row(
        children: [
          const SizedBox(
            width: ProfileSpacingTokens.profileVipUpgradeIconBox,
            height: ProfileSpacingTokens.profileVipUpgradeIconBox,
            child: Material(
              color: AppColors.primary12,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
              child: Icon(
                Icons.workspace_premium_outlined,
                color: _vipAccent,
                size: ProfileSpacingTokens.profileVipUpgradeIcon,
              ),
            ),
          ),
          const SizedBox(width: ProfileSpacingTokens.profileVipUpgradeIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'N\u00E2ng c\u1EA5p l\u00EAn ${nextTier.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.heavy,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'T\u0103ng kh\u1ED1i l\u01B0\u1EE3ng giao d\u1ECBch \u0111\u1EC3 ti\u1EBFt ki\u1EC7m th\u00EAm',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const SizedBox(width: ProfileSpacingTokens.profileVipUpgradeCtaGap),
          VitCtaButton(
            key: VIPPage.tradeCtaKey,
            onPressed: onTrade,
            fullWidth: false,
            density: VitDensity.compact,
            padding: ProfileSpacingTokens.profileVipUpgradeCtaPadding,
            child: Text(
              'Giao d\u1ECBch',
              style: AppTextStyles.micro.copyWith(
                fontWeight: AppTextStyles.heavy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierIcon extends StatelessWidget {
  const _TierIcon({required this.tier, this.large = false});

  final ProfileVipTier tier;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large
        ? ProfileSpacingTokens.profileVipTierIconLarge
        : ProfileSpacingTokens.profileVipTierIconSmall;
    final iconSize = large
        ? ProfileSpacingTokens.profileVipTierIconGlyphLarge
        : ProfileSpacingTokens.profileVipTierIconGlyphSmall;
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: _tierAccent(tier).withValues(alpha: large ? .16 : .12),
        shape: RoundedRectangleBorder(
          borderRadius: large ? AppRadii.cardRadius : AppRadii.smRadius,
        ),
        child: Icon(
          _iconForTier(tier.iconKey),
          color: _tierAccent(tier),
          size: iconSize,
        ),
      ),
    );
  }
}

Color _tierAccent(ProfileVipTier tier) {
  if (tier.level == 0) return _vipProfileAccent;
  if (tier.level >= 4) return AppColors.accent;
  return _vipGold;
}

IconData _iconForTier(String key) {
  return switch (key) {
    'star' => Icons.star_rounded,
    'medal' => Icons.military_tech_rounded,
    'workspace' => Icons.workspace_premium_rounded,
    'diamond' => Icons.diamond_outlined,
    'rocket' => Icons.rocket_launch_rounded,
    _ => Icons.person_outline_rounded,
  };
}

String _formatFee(double value) {
  if (value == 0) return '0%';
  return '${value.toStringAsFixed(2)}%';
}

String _formatUsd(double value) => '\$${_formatNumber(value)}.00';

String _formatCompactUsd(double value) {
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(0)}M';
  }
  if (value >= 1000) {
    return '\$${(value / 1000).toStringAsFixed(0)}K';
  }
  return '\$${value.toStringAsFixed(0)}';
}

String _formatNumber(double value) => VitFormat.count(value.round());
