part of '../../phone/pages/staking/staking_multi_chain_page.dart';

class _ChainPositionCard extends StatelessWidget {
  const _ChainPositionCard({
    required this.position,
    required this.dashboardRoute,
  });

  final StakingChainPositionDraft position;
  final String dashboardRoute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingMultiChainPage.chainKey(position.chainId),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: ShapeDecoration(
                  color: _chainTint(position.chainId),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.xlRadius,
                  ),
                ),
                child: SizedBox(
                  width: AppSpacing.ctaHeight,
                  height: AppSpacing.ctaHeight,
                  child: Icon(
                    _chainIcon(position.chainId),
                    color: AppColors.text1,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(position.chain, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${_formatAmount(position.staked)} ${position.asset}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    VitFormat.usdWhole(position.value),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  _ApyPill(value: '${position.apy}% APY'),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCtaButton(
            key: StakingMultiChainPage.manageKey(position.chainId),
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.buttonCompact,
            trailing: const Icon(Icons.arrow_forward_rounded),
            onPressed: () {
              unawaited(HapticFeedback.selectionClick());
              context.go(dashboardRoute);
            },
            child: const Text('Manage Position'),
          ),
        ],
      ),
    );
  }
}

class _ApyPill extends StatelessWidget {
  const _ApyPill({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.buy15,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingMultiChainPage.quickActionsKey,
      label: 'Quick Actions',
      accentColor: AppColors.primarySoft,
      children: [
        Row(
          children: [
            for (var i = 0; i < snapshot.quickActions.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.x4),
              Expanded(child: _ActionCard(action: snapshot.quickActions[i])),
            ],
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.action});

  final StakingMultiChainInfoDraft action;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _infoIcon(action.icon),
            color: action.icon == 'globe' ? AppColors.accent : AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Text(
            action.title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            action.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ApyComparison extends StatelessWidget {
  const _ApyComparison({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final sorted = snapshot.positions.toList()
      ..sort((a, b) => b.apy.compareTo(a.apy));

    return VitCard(
      key: StakingMultiChainPage.apyComparisonKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('APY Comparison', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          for (final position in sorted) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    position.chain,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                Text(
                  '${position.apy}%',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x1),
            ClipRRect(
              borderRadius: AppRadii.smRadius,
              child: LinearProgressIndicator(
                minHeight: AppSpacing.x2,
                value: position.apy / 12.5,
                backgroundColor: AppColors.surface3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _chainColor(position.chainId),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}

class _Benefits extends StatelessWidget {
  const _Benefits({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingMultiChainPage.benefitsKey,
      label: 'Why Multi-Chain?',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < snapshot.benefits.length; i++) ...[
                if (i > 0) const Divider(color: AppColors.borderSolid),
                Text(
                  snapshot.benefits[i].title,
                  style: AppTextStyles.baseMedium,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.benefits[i].description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TechnicalNote extends StatelessWidget {
  const _TechnicalNote({required this.snapshot});

  final StakingMultiChainSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingMultiChainPage.technicalNoteKey,
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              snapshot.technicalNote,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

Color _chainColor(StakingChainId id) {
  return switch (id) {
    StakingChainId.ethereum => AppColors.primarySoft,
    StakingChainId.polygon => AppColors.accent,
    StakingChainId.avalanche => AppColors.sell,
    StakingChainId.cosmos => AppColors.text3,
    StakingChainId.solana => AppColors.buy,
  };
}

Color _chainTint(StakingChainId id) {
  return switch (id) {
    StakingChainId.ethereum => AppColors.primary15,
    StakingChainId.polygon => AppColors.accent15,
    StakingChainId.avalanche => AppColors.sell15,
    StakingChainId.cosmos => AppColors.surface3,
    StakingChainId.solana => AppColors.buy15,
  };
}

IconData _chainIcon(StakingChainId id) {
  return switch (id) {
    StakingChainId.ethereum => Icons.diamond_outlined,
    StakingChainId.polygon => Icons.change_history_rounded,
    StakingChainId.avalanche => Icons.terrain_rounded,
    StakingChainId.cosmos => Icons.hub_outlined,
    StakingChainId.solana => Icons.radio_button_checked_rounded,
  };
}

IconData _infoIcon(String icon) {
  return switch (icon) {
    'trend' => Icons.trending_up_rounded,
    'globe' => Icons.public_rounded,
    'shield' => Icons.shield_outlined,
    'cost' => Icons.local_gas_station_outlined,
    _ => Icons.public_rounded,
  };
}

String _formatAmount(double value) {
  if (value >= 1000) {
    final whole = value.round().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(whole[i]);
    }
    return buffer.toString();
  }
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}
