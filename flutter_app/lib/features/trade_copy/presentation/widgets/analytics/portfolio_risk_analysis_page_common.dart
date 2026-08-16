part of '../../phone/pages/analytics/portfolio_risk_analysis_page.dart';

class _PlaceholderPanel extends StatelessWidget {
  const _PlaceholderPanel({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotInnerPanelPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _riskSectionSpace),
          Text(
            description,
            style: AppTextStyles.navLabel.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.normal,
              height: _riskBodyLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _VarPanel extends StatelessWidget {
  const _VarPanel({required this.snapshot});

  final TradePortfolioRiskAnalysisSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _PlaceholderPanel(
      title: 'Value at Risk',
      description:
          'VaR 95% ${_formatUsd(snapshot.var95.abs())}; VaR 99% ${_formatUsd(snapshot.var99.abs())}.',
    );
  }
}

class _StressScenarioPanel extends StatelessWidget {
  const _StressScenarioPanel({required this.scenarios});

  final List<TradeStressScenario> scenarios;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final scenario in scenarios) ...[
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.tight,
            padding: TradeSpacingTokens.tradeBotInnerPanelPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    scenario.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Text(
                  _formatSignedUsd(scenario.impact),
                  style: AppTextStyles.numericCode.copyWith(
                    color: scenario.impact >= 0
                        ? AppColors.buy
                        : AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          if (scenario != scenarios.last)
            const SizedBox(height: _riskTinySpace),
        ],
      ],
    );
  }
}

class _ExposurePiePainter extends CustomPainter {
  const _ExposurePiePainter(this.assets);

  final List<TradeAssetExposure> assets;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    var start = 0.0;
    for (final asset in assets) {
      final sweep = -asset.percent / 100 * math.pi * 2;
      final fill = Paint()
        ..color = Color(asset.colorHex)
        ..style = PaintingStyle.fill;
      canvas.drawArc(rect, start, sweep, true, fill);
      final stroke = Paint()
        ..color = AppColors.onAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = TradeSpacingTokens.tradeBotHairline;
      canvas.drawArc(rect, start, sweep, true, stroke);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _ExposurePiePainter oldDelegate) {
    return oldDelegate.assets != assets;
  }
}

String _formatUsd(double value) => formatTradeUsdRounded(value);

String _formatSignedUsd(double value) => formatTradeSignedUsdRounded(value);

String _formatPercent(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}
