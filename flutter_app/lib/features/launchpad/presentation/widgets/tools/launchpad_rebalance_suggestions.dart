part of '../../phone/pages/tools/launchpad_rebalance_page.dart';

class LaunchpadRebalanceSuggestionsSection extends StatelessWidget {
  const LaunchpadRebalanceSuggestionsSection({
    super.key,
    required this.sectionKey,
    required this.suggestionKey,
    required this.suggestions,
  });

  final Key sectionKey;
  final Key Function(String id) suggestionKey;
  final List<RebalanceSuggestion> suggestions;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: sectionKey,
      child: VitPageSection(
        label: 'De xuat rebalance',
        accentColor: AppColors.warn,
        children: [
          for (final suggestion in suggestions)
            _SuggestionCard(
              cardKey: suggestionKey(suggestion.asset.id),
              suggestion: suggestion,
            ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.cardKey, required this.suggestion});

  final Key cardKey;
  final RebalanceSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final color = launchpadRebalanceActionColor(suggestion.action);
    return VitCard(
      key: cardKey,
      clip: true,
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              width: LaunchpadSpacingTokens.launchpadVerticalMarkerWidth,
              child: ColoredBox(color: color),
            ),
            Expanded(
              child: Padding(
                padding: LaunchpadSpacingTokens.launchpadPaddingX3,
                child: Row(
                  children: [
                    _AssetBadge(asset: suggestion.asset),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: AppSpacing.x2,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                suggestion.asset.symbol,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              _ActionPill(
                                action: suggestion.action,
                                color: color,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x1),
                          Text(
                            '${suggestion.currentPercent.toStringAsFixed(1)}% -> ${suggestion.targetPercent.toStringAsFixed(1)}%   ${suggestion.deviation > 0 ? '-' : '+'}${suggestion.deviation.abs().toStringAsFixed(1)}%',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (suggestion.action != LaunchpadRebalanceAction.hold)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${suggestion.suggestedValue.toStringAsFixed(0)}',
                            style: AppTextStyles.caption.copyWith(
                              color: color,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            '${launchpadRebalanceAmount(suggestion.suggestedAmount)} ${suggestion.asset.symbol}',
                            style: AppTextStyles.chartLabelXs.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset});

  final LaunchpadRebalanceAssetDraft asset;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: LaunchpadSpacingTokens.launchpadBox34,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: asset.accent.resolve().withValues(alpha: .14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Center(
          child: Text(
            asset.symbol.substring(0, math.min(2, asset.symbol.length)),
            style: AppTextStyles.micro.copyWith(
              color: asset.accent.resolve(),
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({required this.action, required this.color});

  final LaunchpadRebalanceAction action;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadCompactChipPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              launchpadRebalanceActionIcon(action),
              color: color,
              size: LaunchpadSpacingTokens.launchpadFontXs,
            ),
            const SizedBox(width: LaunchpadSpacingTokens.launchpadGapXs),
            Text(
              launchpadRebalanceActionLabel(action),
              style: AppTextStyles.chartLabelXs.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                height: LaunchpadSpacingTokens.launchpadLineHeightTight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
