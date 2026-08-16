part of '../../phone/pages/execution/market_data_analytics_page.dart';

class _MarketDataTab extends StatelessWidget {
  const _MarketDataTab({required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        _OpenInterestCard(
          pair: snapshot.selectedPair,
          data: snapshot.openInterest,
        ),
        _LongShortRatioCard(data: snapshot.longShortRatio),
        _TopTradersCard(data: snapshot.topTraders),
        _FundingRateCard(data: snapshot.fundingRate),
      ],
    );
  }
}

class _OpenInterestCard extends StatelessWidget {
  const _OpenInterestCard({required this.pair, required this.data});

  final String pair;
  final TradeMarketOpenInterest data;

  @override
  Widget build(BuildContext context) {
    return _AnalyticsCard(
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          _CardHeader(
            icon: Icons.show_chart_rounded,
            iconColor: _analyticsPrimary,
            title: 'Open Interest',
            trailing: '$pair >',
          ),
          Text(
            'Total Open Interest',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _formatMillions(data.current),
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              _SmallBadge(
                label: '+${data.change24hPct.toStringAsFixed(2)}%',
                color: _analyticsGreen,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _MetricBubble(
                  label: 'Change 24h',
                  value: '+${_formatMillions(data.change24h)}',
                  color: _analyticsGreen,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MetricBubble(
                  label: 'High 24h',
                  value: _formatMillions(data.high24h),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MetricBubble(
                  label: 'Low 24h',
                  value: _formatMillions(data.low24h),
                ),
              ),
            ],
          ),
          const _InfoStrip(
            text:
                'OI tang + gia tang = bullish strong. OI tang + gia giam = bearish momentum. OI giam = positions dong.',
          ),
        ],
      ),
    );
  }
}

class _LongShortRatioCard extends StatelessWidget {
  const _LongShortRatioCard({required this.data});

  final TradeMarketLongShortRatio data;

  @override
  Widget build(BuildContext context) {
    return _AnalyticsCard(
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          const _CardHeader(
            icon: Icons.groups_2_outlined,
            iconColor: _analyticsPurple,
            title: 'Long/Short Ratio',
            badge: 'Long',
          ),
          const _ToggleBar(left: 'By Accounts', right: 'By Volume'),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _PctLabel(
                      label: 'Long ${data.longPct.toStringAsFixed(1)}%',
                      color: _analyticsGreen,
                      icon: Icons.trending_up_rounded,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _PctLabel(
                      label: 'Short ${data.shortPct.toStringAsFixed(1)}%',
                      color: _analyticsRed,
                      icon: Icons.trending_down_rounded,
                      iconAfter: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          _RatioBar(longPct: data.longPct),
          Text(
            'Long/Short Ratio',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            data.ratio.toStringAsFixed(2),
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              color: _analyticsGreen,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _MetricBubble(
                  label: 'Long Accounts',
                  value: _formatInt(data.longAccounts),
                  color: _analyticsGreen,
                  bg: _analyticsGreen.withValues(alpha: .09),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MetricBubble(
                  label: 'Short Accounts',
                  value: _formatInt(data.shortAccounts),
                  color: _analyticsRed,
                  bg: _analyticsRed.withValues(alpha: .08),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
