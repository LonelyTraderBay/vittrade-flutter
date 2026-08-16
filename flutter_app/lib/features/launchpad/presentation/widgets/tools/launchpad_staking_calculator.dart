part of '../../phone/pages/tools/launchpad_staking_page.dart';

class _ApyCalculator extends StatefulWidget {
  const _ApyCalculator({required this.pools});

  final List<LaunchpoolPoolDraft> pools;

  @override
  State<_ApyCalculator> createState() => _ApyCalculatorState();
}

class _ApyCalculatorState extends State<_ApyCalculator> {
  late String _poolId = widget.pools
      .firstWhere((pool) => pool.status == LaunchpoolPoolStatus.active)
      .id;
  var _amount = 1000.0;
  var _days = 30;

  @override
  Widget build(BuildContext context) {
    final pool = widget.pools.firstWhere(
      (candidate) => candidate.id == _poolId,
    );
    final tierBonus = _currentTier(pool.tiers, _amount)?.apyBonus ?? 0;
    final apy = pool.baseApy + tierBonus;
    final rewards = (_amount * apy / 100) / 365 * _days / pool.rewardTokenPrice;
    final nextTier = _nextTier(pool.tiers, _amount);

    final activePools = widget.pools
        .where((pool) => pool.status == LaunchpoolPoolStatus.active)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitTabBar(
          tabs: [
            for (final candidate in activePools)
              VitTabItem(key: candidate.id, label: candidate.projectSymbol),
          ],
          activeKey: _poolId,
          onChanged: (id) => setState(() => _poolId = id),
          variant: VitTabBarVariant.segment,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          key: LaunchpadStakingPage.calculatorKey,
          radius: VitCardRadius.large,
          padding: LaunchpadSpacingTokens.launchpadPaddingX5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calculate_outlined,
                    color: AppColors.primary,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      'Tính toán phần thưởng',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              _StepperField(
                label: 'Số tiền stake',
                value: _formatUsd(_amount),
                onMinus: () => setState(
                  () => _amount = (_amount - 500).clamp(100, 20000).toDouble(),
                ),
                onPlus: () => setState(
                  () => _amount = (_amount + 500).clamp(100, 20000).toDouble(),
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _StepperField(
                label: 'Thời gian',
                value: '$_days ngày',
                onMinus: () =>
                    setState(() => _days = (_days - 7).clamp(7, 90).toInt()),
                onPlus: () =>
                    setState(() => _days = (_days + 7).clamp(7, 90).toInt()),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              VitCard(
                variant: VitCardVariant.inner,
                borderColor: pool.accent.resolve().withValues(alpha: .24),
                padding: LaunchpadSpacingTokens.launchpadPaddingX4,
                child: Column(
                  children: [
                    _ResultRow(
                      label: 'APY hiệu lực',
                      value: '${_formatApy(apy)}%',
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    _ResultRow(
                      label: 'Phần thưởng ước tính',
                      value: '${_formatToken(rewards)} ${pool.rewardToken}',
                      valueColor: AppColors.warn,
                    ),
                    if (nextTier != null) ...[
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      Text(
                        'Stake thêm ${_formatUsd(nextTier.minStake - _amount)} để lên ${nextTier.label} (+${_formatApy(nextTier.apyBonus)}%).',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepperField extends StatelessWidget {
  const _StepperField({
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final String value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  value,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          _RoundIconButton(icon: Icons.remove_rounded, onTap: onMinus),
          const SizedBox(width: AppSpacing.x2),
          _RoundIconButton(icon: Icons.add_rounded, onTap: onPlus),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      onPressed: onTap,
      icon: icon,
      tooltip: icon == Icons.add_rounded ? 'Tang gia tri' : 'Giam gia tri',
      variant: VitIconButtonVariant.transparent,
      size: VitIconButtonSize.sm,
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
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
