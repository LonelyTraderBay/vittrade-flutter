part of '../../phone/pages/tools/advanced_analytics_page.dart';

class _RiskAnalysisTab extends StatelessWidget {
  const _RiskAnalysisTab({required this.snapshot});

  final TradeAdvancedAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final risk = snapshot.risk;
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        _Card(
          child: VitPageContent(
            rhythm: VitPageRhythm.standard,
            padding: VitContentPadding.none,
            fullBleed: true,
            density: VitDensity.tool,
            children: [
              const _SectionHeader(
                icon: Icons.shield_outlined,
                color: _advancedAmber,
                title: 'Portfolio Risk Analyzer',
                subtitle: 'VaR, Sharpe Ratio, Max Drawdown, Beta',
              ),
              VitCard(
                variant: VitCardVariant.inner,
                density: VitDensity.tool,
                radius: VitCardRadius.tight,
                child: Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: _advancedAmber,
                      size: TradeSpacingTokens
                          .tradeBotClientCategoryHeroIconGlyph,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Risk Score',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            '${risk.riskLevel} risk',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${risk.riskScore}',
                      style: AppTextStyles.heroNumber.copyWith(
                        color: _advancedAmber,
                      ),
                    ),
                    Text(
                      '/100',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'VaR 95%',
                      value: '${risk.var95.toStringAsFixed(1)}%',
                      valueColor: _advancedAmber,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBox(
                      label: 'Sharpe',
                      value: risk.sharpeRatio.toStringAsFixed(2),
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBox(
                      label: 'Max DD',
                      value: '${risk.maxDrawdown.toStringAsFixed(1)}%',
                      valueColor: _advancedRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const _InfoCard(
          color: _advancedPrimary,
          icon: Icons.shield_outlined,
          title: 'Enterprise Risk Management',
          body:
              'VaR calculated using Monte Carlo simulation. Sharpe and Sortino ratios update daily with a 30-day rolling window.',
        ),
      ],
    );
  }
}

class _TradeJournalTab extends StatelessWidget {
  const _TradeJournalTab({required this.snapshot});

  final TradeAdvancedAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final journal = snapshot.journal;
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        _Card(
          child: VitPageContent(
            padding: VitContentPadding.none,
            fullBleed: true,
            density: VitDensity.tool,
            children: [
              const _SectionHeader(
                icon: Icons.menu_book_rounded,
                color: _advancedGreen,
                title: 'Trade Journal',
                subtitle: 'Detailed tracking and performance attribution',
              ),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'Win Rate',
                      value: '${journal.winRate.toStringAsFixed(1)}%',
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBox(
                      label: 'Trades',
                      value: '${journal.totalTrades}',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _MetricBox(
                      label: 'Total PnL',
                      value: '+\$${_formatCompact(journal.totalPnl)}',
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBox(
                      label: 'Avg Win',
                      value: '+\$${journal.avgWin.toStringAsFixed(0)}',
                      valueColor: _advancedGreen,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBox(
                      label: 'Avg Loss',
                      value: '-\$${journal.avgLoss.toStringAsFixed(0)}',
                      valueColor: _advancedRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const _InfoCard(
          color: _advancedGreen,
          icon: Icons.menu_book_rounded,
          title: 'Performance Attribution',
          body:
              'Automatic trade tagging, setup classification, pattern recognition and export-ready analytics.',
        ),
      ],
    );
  }
}
