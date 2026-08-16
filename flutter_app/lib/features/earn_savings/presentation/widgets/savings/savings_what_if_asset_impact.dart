part of '../../phone/pages/savings/savings_what_if_page.dart';

class _AssetImpactList extends StatelessWidget {
  const _AssetImpactList({required this.result});

  final _ScenarioResult result;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsWhatIfPage.assetImpactKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        children: [
          for (final impact in result.assetImpact) ...[
            Row(
              children: [
                _AssetBadge(asset: impact.asset, color: impact.color),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        impact.asset,
                        style: _captionBold.copyWith(color: AppColors.text1),
                      ),
                      Text(
                        'Baseline ${_money(impact.baseInterest)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${impact.diff >= 0 ? '+' : ''}${_money(impact.diff)}',
                  style: _captionBold.copyWith(
                    color: impact.diff >= 0 ? AppColors.buy : AppColors.sell,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            if (impact != result.assetImpact.last)
              const Divider(color: AppColors.divider, height: AppSpacing.x5),
          ],
        ],
      ),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: EarnSpacingTokens.savingsWhatIfAssetBadge,
      child: Material(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.lgRadius,
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              asset,
              style: AppTextStyles.chartLabelTiny.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
