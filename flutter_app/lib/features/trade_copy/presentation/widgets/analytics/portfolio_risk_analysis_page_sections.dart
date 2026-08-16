part of '../../phone/pages/analytics/portfolio_risk_analysis_page.dart';

class _RiskSummaryGrid extends StatelessWidget {
  const _RiskSummaryGrid({required this.snapshot});

  final TradePortfolioRiskAnalysisSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _RiskSummaryCard(
                label: 'Total Exposure',
                value: _formatUsd(snapshot.totalExposure),
                caption: 'Across ${snapshot.assetExposures.length} assets',
              ),
            ),
            const SizedBox(width: _riskSectionSpace),
            Expanded(
              child: _RiskSummaryCard(
                label: 'VaR (95%, 1-day)',
                value: _formatUsd(snapshot.var95.abs()),
                valueColor: AppColors.sell,
                caption: 'Max loss @ 95%',
              ),
            ),
          ],
        ),
        const SizedBox(height: _riskSectionSpace),
        Row(
          children: [
            Expanded(
              child: _RiskSummaryCard(
                label: 'Diversification',
                value: '${snapshot.diversificationScore}/100',
                valueColor: AppColors.buy,
                caption: 'Good',
              ),
            ),
            const SizedBox(width: _riskSectionSpace),
            Expanded(
              child: _RiskSummaryCard(
                label: 'Risk Alerts',
                value: '${snapshot.riskAlerts.length}',
                valueColor: AppColors.sell,
                caption: 'Active warnings',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RiskSummaryCard extends StatelessWidget {
  const _RiskSummaryCard({
    required this.label,
    required this.value,
    required this.caption,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final String caption;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      radius: VitCardRadius.tight,
      height: _riskSummaryExtent,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _riskTinySpace),
          Text(
            value,
            style: AppTextStyles.amountSm.copyWith(
              color: valueColor,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: _riskTinySpace),
          Text(
            caption,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _RiskWarningPanel extends StatelessWidget {
  const _RiskWarningPanel({required this.alerts});

  final List<String> alerts;

  @override
  Widget build(BuildContext context) {
    return TradeCopyHeaderBodyCard(
      icon: Icons.warning_amber_rounded,
      iconColor: _riskWarningText,
      iconSize: TradeSpacingTokens.tradeBotSmallIcon,
      title: 'Cảnh báo rủi ro',
      titleStyle: AppTextStyles.baseMedium.copyWith(color: _riskWarningText),
      headerGap: _riskSectionSpace,
      variant: VitCardVariant.inner,
      padding: TradeSpacingTokens.tradeBotDisputeNoticePadding,
      borderColor: _riskWarningBorder,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final alert in alerts) ...[
            Text(
              '• $alert',
              style: AppTextStyles.micro.copyWith(
                color: _riskWarningText,
                fontWeight: AppTextStyles.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (alert != alerts.last) const SizedBox(height: _riskTinySpace),
          ],
        ],
      ),
    );
  }
}

class _RiskTabs extends StatelessWidget {
  const _RiskTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradePortfolioRiskTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedTabBar(
      activeKey: activeId,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            widgetKey: PortfolioRiskAnalysisPage.tabKey(tab.id),
          ),
      ],
      onChanged: onChanged,
    );
  }
}

class _ExposureTab extends StatelessWidget {
  const _ExposureTab({required this.snapshot});

  final TradePortfolioRiskAnalysisSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Asset Allocation',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        const SizedBox(height: _riskSectionSpace),
        SizedBox(
          height: _riskChartExtent,
          child: Center(
            child: CustomPaint(
              size: const Size(_riskRingExtent, _riskRingExtent),
              painter: _ExposurePiePainter(snapshot.assetExposures),
            ),
          ),
        ),
        const SizedBox(height: _riskSectionSpace),
        for (final asset in snapshot.assetExposures) ...[
          _AssetExposureRow(
            key: PortfolioRiskAnalysisPage.assetKey(asset.asset),
            asset: asset,
          ),
          if (asset != snapshot.assetExposures.last)
            const SizedBox(height: _riskTinySpace),
        ],
        const SizedBox(height: _riskSectionSpace),
        _DiversificationNote(score: snapshot.diversificationScore),
      ],
    );
  }
}

class _AssetExposureRow extends StatelessWidget {
  const _AssetExposureRow({super.key, required this.asset});

  final TradeAssetExposure asset;

  @override
  Widget build(BuildContext context) {
    final color = Color(asset.colorHex);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      height: _riskAssetRowExtent,
      padding: TradeSpacingTokens.tradeBotMetricBoxPadding,
      child: Row(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.tight,
            width: _riskSwatchExtent,
            height: _riskSwatchExtent,
            clip: true,
            background: ColoredBox(color: color),
            child: const SizedBox.shrink(),
          ),
          const SizedBox(width: _riskSectionSpace),
          Text(
            asset.asset,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.medium,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Expanded(child: SizedBox.shrink()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatUsd(asset.value),
                style: AppTextStyles.numericCode.copyWith(
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(height: _riskTinySpace),
              Text(
                '${_formatPercent(asset.percent)}%',
                style: AppTextStyles.numericMicro.copyWith(
                  color: AppColors.text3,
                  height: _riskCaptionLineHeight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiversificationNote extends StatelessWidget {
  const _DiversificationNote({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotDisputeNoticePadding,
      borderColor: _riskPrimary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _riskPrimary,
            size: TradeSpacingTokens.tradeBotMediumIcon,
          ),
          const SizedBox(width: _riskSectionSpace),
          Expanded(
            child: Text(
              'Diversification score $score/100. Khuyến nghị không để asset nào chiếm >30% portfolio.',
              style: AppTextStyles.caption.copyWith(color: _riskPrimary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
