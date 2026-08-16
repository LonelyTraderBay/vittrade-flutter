part of '../../phone/pages/bridge/launchpad_bridge_compare_page.dart';

class _InputSummaryHero extends StatelessWidget {
  const _InputSummaryHero({required this.comparison});

  final LaunchpadBridgeComparisonDraft comparison;

  @override
  Widget build(BuildContext context) {
    final bestRoute = comparison.routes.firstWhere(
      (route) => route.id == comparison.bestOutput,
    );
    return VitCard(
      key: LaunchpadBridgeComparePage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .22),
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'So sánh route bridge',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${comparison.routes.length} route',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _ChainAmount(
                  chain: comparison.sourceChain,
                  token: comparison.inputToken,
                  amount: _formatNumber(comparison.inputAmount),
                  accent: AppModuleAccents.launchpad,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                children: [
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconMd,
                  ),
                  Text(
                    'bridge',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _ChainAmount(
                  chain: comparison.targetChain,
                  token: comparison.outputToken,
                  amount: '~${_formatNumber(bestRoute.outputAmount)}',
                  accent: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChainAmount extends StatelessWidget {
  const _ChainAmount({
    required this.chain,
    required this.token,
    required this.amount,
    required this.accent,
  });

  final String chain;
  final String token;
  final String amount;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProviderBadge(
          label: _chainLabel(chain),
          accent: accent,
          size: LaunchpadSpacingTokens.launchpadIconHuge,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          amount,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: accent == AppColors.buy ? AppColors.buy : AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        Text(
          token,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
