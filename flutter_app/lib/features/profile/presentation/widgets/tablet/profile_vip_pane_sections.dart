part of 'profile_vip_pane.dart';

class _VipTierRow extends StatelessWidget {
  const _VipTierRow({required this.tier, required this.active});

  final ProfileVipTier tier;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final textColor = active
        ? _ProfileVipPaneState._vipAccent
        : AppColors.text1;
    return Material(
      key: ProfileTabletKeys.vipTier(tier.level),
      color: active ? AppColors.primary08 : AppColors.transparent,
      child: Padding(
        padding: ProfileSpacingTokens.profileVipTableRowPadding,
        child: Row(
          children: [
            _VipTableCell(
              flex: 28,
              child: Row(
                children: [
                  _TierIcon(tier: tier),
                  const SizedBox(width: TabletSpacingTokens.x4),
                  Flexible(
                    child: Text(
                      tier.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: textColor,
                        fontWeight: active
                            ? AppTextStyles.heavy
                            : AppTextStyles.bold,
                      ),
                    ),
                  ),
                  if (active) ...[
                    const SizedBox(width: TabletSpacingTokens.x4),
                    const SizedBox(
                      width: ProfileSpacingTokens.profileVipActiveDot,
                      height: ProfileSpacingTokens.profileVipActiveDot,
                      child: Material(
                        color: _ProfileVipPaneState._vipAccent,
                        shape: CircleBorder(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            _VipTableCell(
              flex: 26,
              child: Text(
                tier.monthlyVolume == 0
                    ? '-'
                    : _formatCompactUsd(tier.monthlyVolume),
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ),
            _VipTableCell(
              flex: 22,
              child: Text(_formatFee(tier.makerFee), style: _feeStyle(active)),
            ),
            _VipTableCell(
              flex: 22,
              child: Text(_formatFee(tier.takerFee), style: _feeStyle(active)),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _feeStyle(bool active) {
    return AppTextStyles.micro.copyWith(
      color: active ? _ProfileVipPaneState._vipSuccess : AppColors.text1,
      fontWeight: AppTextStyles.heavy,
      fontFeatures: AppTextStyles.tabularFigures,
    );
  }
}

class _VipTableCell extends StatelessWidget {
  const _VipTableCell({required this.flex, required this.child});

  final int flex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex, child: child);
  }
}

class _FeeSavingsCard extends StatelessWidget {
  const _FeeSavingsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _ProfileVipPaneState._vipSuccess.withValues(alpha: .22),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                color: _ProfileVipPaneState._vipSuccess,
                size: ProfileSpacingTokens.profileVipSavingsIcon,
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
              Text(
                'Tiết kiệm phí của bạn',
                style: AppTextStyles.body.copyWith(
                  color: _ProfileVipPaneState._vipSuccess,
                  fontWeight: AppTextStyles.heavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          const Row(
            children: [
              Expanded(
                child: _SavingBox(
                  label: 'Tháng này',
                  value: '\$12.45',
                  sub: 'vs. Standard rate',
                ),
              ),
              SizedBox(width: TabletSpacingTokens.x4),
              Expanded(
                child: _SavingBox(
                  label: 'Tổng tích lũy',
                  value: '\$89.30',
                  sub: 'từ 15/08/2023',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SavingBox extends StatelessWidget {
  const _SavingBox({
    required this.label,
    required this.value,
    required this.sub,
  });

  final String label;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: _ProfileVipPaneState._vipMuted,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Text(
            value,
            style: AppTextStyles.base.copyWith(
              color: _ProfileVipPaneState._vipSuccess,
              fontWeight: AppTextStyles.heavy,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Text(
            sub,
            style: AppTextStyles.micro.copyWith(
              color: _ProfileVipPaneState._vipMuted,
            ),
          ),
        ],
      ),
    );
  }
}

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
          const SizedBox(height: TabletSpacingTokens.cardGap),
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
    final accent = unlocked
        ? _ProfileVipPaneState._vipGold
        : _ProfileVipPaneState._vipProfileAccent;
    return Opacity(
      opacity: unlocked ? 1 : .68,
      child: VitCard(
        padding: TabletSpacingTokens.zeroInsets,
        borderColor: accent.withValues(alpha: unlocked ? .34 : .12),
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
                    const SizedBox(width: TabletSpacingTokens.x4),
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
                          const SizedBox(height: TabletSpacingTokens.x4),
                          Text(
                            'Volume >= ${_formatUsd(tier.monthlyVolume)}/tháng hoặc Tài sản >= ${_formatUsd(tier.assetHold)}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: _ProfileVipPaneState._vipMuted,
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
              height: TabletSpacingTokens.dividerHairline,
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
                      const SizedBox(height: TabletSpacingTokens.x4),
                  ],
                  const SizedBox(height: TabletSpacingTokens.x4),
                  const Divider(
                    height: TabletSpacingTokens.dividerHairline,
                    color: AppColors.divider,
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  Row(
                    children: [
                      _BenefitMetric(
                        label: 'Maker',
                        value: _formatFee(tier.makerFee),
                        active: unlocked,
                      ),
                      const SizedBox(width: TabletSpacingTokens.x4),
                      _BenefitMetric(
                        label: 'Taker',
                        value: _formatFee(tier.takerFee),
                        active: unlocked,
                      ),
                      const SizedBox(width: TabletSpacingTokens.x4),
                      Expanded(
                        child: _BenefitMetric(
                          label: 'Hạn mức rút',
                          value:
                              '${_formatCompactUsd(tier.withdrawLimit)}/ngày',
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
              color: unlocked ? accent : _ProfileVipPaneState._vipMuted,
              size: ProfileSpacingTokens.profileVipBenefitFeatureIcon,
            ),
          ),
        ),
        const SizedBox(width: TabletSpacingTokens.x4),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: unlocked
                  ? AppColors.text1
                  : _ProfileVipPaneState._vipMuted,
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
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: _ProfileVipPaneState._vipMuted,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? _ProfileVipPaneState._vipSuccess : AppColors.text2,
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
      borderColor: _ProfileVipPaneState._vipAccent.withValues(alpha: .22),
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
                color: _ProfileVipPaneState._vipAccent,
                size: ProfileSpacingTokens.profileVipUpgradeIcon,
              ),
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nâng cấp lên ${nextTier.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.heavy,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x4),
                Text(
                  'Tăng khối lượng giao dịch để tiết kiệm thêm',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          VitCtaButton(
            key: ProfileTabletKeys.vipTradeCta,
            onPressed: onTrade,
            fullWidth: false,
            density: VitDensity.compact,
            padding: ProfileSpacingTokens.profileVipUpgradeCtaPadding,
            child: Text(
              'Giao dịch',
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
  if (tier.level == 0) return _ProfileVipPaneState._vipProfileAccent;
  if (tier.level >= 4) return AppColors.accent;
  return _ProfileVipPaneState._vipGold;
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
  return VitFormat.percent(value);
}

String _formatUsd(double value) => VitFormat.usd(value);

String _formatCompactUsd(double value) =>
    VitFormat.compactSuffix(value, prefix: '\$', stripTrailingZero: true);
