part of '../../phone/pages/margin/margin_trading_hub_page.dart';

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final TradeMarginHubFeature feature;

  @override
  Widget build(BuildContext context) {
    final color = Color(feature.colorHex);
    return _HubCard(
      key: MarginTradingHubPage.featureKey(feature.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              VitCard(
                variant: VitCardVariant.inner,
                radius: VitCardRadius.tight,
                width: _hubIconTile,
                height: _hubIconTile,
                density: VitDensity.tool,
                padding: AppSpacing.zeroInsets,
                borderColor: color.withValues(alpha: .18),
                child: Icon(
                  _featureIcon(feature.id),
                  color: color,
                  size: AppSpacing.x5,
                ),
              ),
              const SizedBox(width: _hubSpace),
              Expanded(
                child: Text(
                  feature.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: _hubLineTight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: _hubSpace),
          for (final item in feature.items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: color,
                  size: AppSpacing.x4,
                ),
                const SizedBox(width: _hubTinySpace),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: _hubLineBody,
                    ),
                  ),
                ),
              ],
            ),
            if (item != feature.items.last)
              const SizedBox(height: _hubTinySpace),
          ],
        ],
      ),
    );
  }
}

class _ComplianceCard extends StatelessWidget {
  const _ComplianceCard({required this.compliance});

  final TradeMarginHubCompliance compliance;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _hubGreen.withValues(alpha: .24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: _hubGreen,
                size: _hubIconTile,
              ),
              const SizedBox(width: _hubSpace),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      compliance.title,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: _hubGreen,
                        fontWeight: AppTextStyles.bold,
                        height: _hubLineTight,
                      ),
                    ),
                    const SizedBox(height: _hubTinySpace),
                    Text(
                      compliance.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: _hubLineBody,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: _hubSpace),
          GridView.builder(
            itemCount: compliance.regulations.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _hubComplianceGridColumns,
              mainAxisExtent: _hubComplianceGridExtent,
              crossAxisSpacing: _hubTinySpace,
              mainAxisSpacing: _hubTinySpace,
            ),
            itemBuilder: (context, index) {
              return VitCard(
                variant: VitCardVariant.inner,
                radius: VitCardRadius.tight,
                alignment: Alignment.center,
                borderColor: _hubGreen.withValues(alpha: .24),
                child: Text(
                  '${compliance.regulations[index]} v',
                  style: AppTextStyles.caption.copyWith(
                    color: _hubGreen,
                    fontWeight: AppTextStyles.bold,
                    height: _hubLineTight,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HubCard extends StatelessWidget {
  const _HubCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _hubBorder.withValues(alpha: .68),
      child: child,
    );
  }
}

IconData _menuIcon(String id) {
  return switch (id) {
    'margin' => Icons.trending_up_rounded,
    'advanced-controls' => Icons.settings_outlined,
    'market-analytics' => Icons.show_chart_rounded,
    'ai-advanced' => Icons.school_outlined,
    _ => Icons.layers_outlined,
  };
}

IconData _featureIcon(String id) {
  return switch (id) {
    'safety' => Icons.shield_outlined,
    'controls' => Icons.settings_outlined,
    'analytics' => Icons.show_chart_rounded,
    _ => Icons.layers_outlined,
  };
}
