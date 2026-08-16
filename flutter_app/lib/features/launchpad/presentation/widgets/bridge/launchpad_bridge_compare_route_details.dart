part of '../../phone/pages/bridge/launchpad_bridge_compare_page.dart';

class _ExpandedRouteDetails extends StatelessWidget {
  const _ExpandedRouteDetails({required this.route, required this.comparison});

  final LaunchpadBridgeRouteOptionDraft route;
  final LaunchpadBridgeComparisonDraft comparison;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          Padding(
            padding: LaunchpadSpacingTokens.launchpadSheetHeaderPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Route path (${route.hops} hops)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final hop in route.path) ...[
                        _HopChip(label: hop.fromToken, subtitle: hop.chain),
                        const Padding(
                          padding: LaunchpadSpacingTokens
                              .launchpadHorizontalPaddingX1,
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.text3,
                            size: LaunchpadSpacingTokens.launchpadIconXs,
                          ),
                        ),
                        _HopChip(label: hop.dex, subtitle: 'DEX'),
                        const Padding(
                          padding: LaunchpadSpacingTokens
                              .launchpadHorizontalPaddingX1,
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.text3,
                            size: LaunchpadSpacingTokens.launchpadIconXs,
                          ),
                        ),
                        _HopChip(label: hop.toToken, subtitle: hop.chain),
                        const SizedBox(width: AppSpacing.x2),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                _DetailsRow(
                  label: 'Gas cost',
                  value: '\$${route.gasCost.toStringAsFixed(2)}',
                ),
                _DetailsRow(
                  label: 'Bridge fee',
                  value: '\$${route.bridgeFee.toStringAsFixed(2)}',
                ),
                _DetailsRow(
                  label: 'Price impact',
                  value: '${_trimDouble(route.priceImpact)}%',
                ),
                _DetailsRow(
                  label: 'Slippage tolerance',
                  value: '${_trimDouble(route.slippage)}%',
                ),
                _DetailsRow(
                  label: 'Liquidity depth',
                  value: route.liquidityDepth,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HopChip extends StatelessWidget {
  const _HopChip({required this.label, required this.subtitle});

  final String label;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadInlinePillPadding,
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              subtitle,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}
