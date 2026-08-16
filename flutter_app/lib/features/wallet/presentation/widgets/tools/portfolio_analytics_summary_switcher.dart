part of '../../phone/pages/tools/portfolio_analytics_page.dart';

class _ValueSummary extends StatelessWidget {
  const _ValueSummary({required this.snapshot});

  final WalletPortfolioAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      borderColor: _analyticsPrimary.withValues(alpha: .32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'T\u1ED5ng gi\u00E1 tr\u1ECB danh m\u1EE5c',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          SizedBox(
            width: double.infinity,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                _formatUsd(snapshot.totalUsd),
                maxLines: 1,
                style: AppTextStyles.heroNumber.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              SizedBox(
                width: WalletSpacingTokens.walletAnalyticsReturnPillWidth,
                child: VitMetricDeltaPill(
                  label:
                      '+${_formatUsd(snapshot.totalReturnUsd, symbol: false)} (+${snapshot.totalReturnPct.toStringAsFixed(2)}%)',
                  tone: VitMetricDeltaTone.positive,
                  icon: Icons.trending_up_rounded,
                ),
              ),
              const SizedBox(
                width: WalletSpacingTokens.walletAnalyticsReturnMetaGap,
              ),
              Expanded(
                child: Text(
                  'so v\u1EDBi \u0111\u1EA7u k\u1EF3',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _QuickStat(
                  label: 'L\u1EE3i nhu\u1EADn t\u1ED1t nh\u1EA5t',
                  value: '+\$${_formatCompactMoney(snapshot.bestProfitUsd)}',
                  sub: snapshot.bestProfitAsset,
                  color: _analyticsGreen,
                ),
              ),
              const SizedBox(
                width: WalletSpacingTokens.walletAnalyticsQuickStatGap,
              ),
              Expanded(
                child: _QuickStat(
                  label: 'Thua l\u1ED7 nh\u1EA5t',
                  value:
                      '-\$${_formatCompactMoney(snapshot.worstLossUsd.abs())}',
                  sub: snapshot.worstLossAsset,
                  color: _analyticsRed,
                ),
              ),
              const SizedBox(
                width: WalletSpacingTokens.walletAnalyticsQuickStatGap,
              ),
              Expanded(
                child: _QuickStat(
                  label: 'T\u00E0i s\u1EA3n',
                  value: '${snapshot.assets.length}',
                  sub: 'lo\u1EA1i coin',
                  color: _analyticsPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  final String label;
  final String value;
  final String sub;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: WalletSpacingTokens.walletAnalyticsQuickStatPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            sub,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _ViewSwitcher extends StatelessWidget {
  const _ViewSwitcher({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      tabs: [
        VitTabItem(
          key: 'overview',
          label: 'T\u1ED5ng quan',
          icon: Icons.bar_chart_rounded,
          widgetKey: PortfolioAnalyticsPage.viewKey('overview'),
        ),
        VitTabItem(
          key: 'allocation',
          label: 'Ph\u00E2n b\u1ED5',
          icon: Icons.pie_chart_outline_rounded,
          widgetKey: PortfolioAnalyticsPage.viewKey('allocation'),
        ),
        VitTabItem(
          key: 'pnl',
          label: 'L\u00E3i/L\u1ED7',
          icon: Icons.trending_up_rounded,
          widgetKey: PortfolioAnalyticsPage.viewKey('pnl'),
        ),
      ],
      activeKey: active,
      onChanged: onChanged,
      variant: VitTabBarVariant.segment,
    );
  }
}
