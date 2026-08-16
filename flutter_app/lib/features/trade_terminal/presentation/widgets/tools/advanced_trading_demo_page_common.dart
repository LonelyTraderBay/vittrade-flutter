part of '../../phone/pages/tools/advanced_trading_demo_page.dart';

class _AnalyticsTab extends StatelessWidget {
  const _AnalyticsTab({required this.snapshot});

  final TradeAdvancedTradingDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MetricsCard(title: 'PnL Summary', metrics: snapshot.pnlSummary),
        const SizedBox(height: _advancedSpace),
        _MetricsCard(
          title: 'Performance Stats',
          metrics: snapshot.performanceMetrics,
        ),
      ],
    );
  }
}

class _MetricsCard extends StatelessWidget {
  const _MetricsCard({required this.title, required this.metrics});

  final String title;
  final List<TradeAdvancedDemoMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: TradeSpacingTokens.tradeToolRiskIntroPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _advancedSpace),
          for (final metric in metrics) ...[
            _advancedValueRow(
              label: metric.label,
              value: metric.value,
              tone: metric.tone,
            ),
            if (metric != metrics.last)
              const SizedBox(height: _advancedTinySpace),
          ],
        ],
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TradeSpacingTokens.tradeToolMetricRowPadding,
      variant: active ? VitCardVariant.standard : VitCardVariant.inner,
      radius: VitCardRadius.tight,
      borderColor: active ? AppColors.primary : null,
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: active ? AppColors.onAccent : AppColors.text2,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

Widget _advancedValueRow({
  required String label,
  required String value,
  TradeAdvancedMetricTone tone = TradeAdvancedMetricTone.neutral,
}) {
  return VitKeyValueRow(
    label: label,
    value: value,
    valueStyle: AppTextStyles.caption.copyWith(
      color: _toneColor(tone),
      fontWeight: AppTextStyles.bold,
      fontFeatures: AppTextStyles.tabularFigures,
    ),
  );
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      borderColor: AppColors.cardBorder,
      child: child,
    );
  }
}

class _DemoSheet extends StatelessWidget {
  const _DemoSheet({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final sheetClearance =
        _advancedSheetClearance + MediaQuery.paddingOf(context).bottom;
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.modalScrim,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              AppSpacing.contentPad,
              0,
              AppSpacing.contentPad,
              sheetClearance,
            ),
            child: VitSheetPanel(
              title: title,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Chỉ trạng thái demo. Thực thi backend vẫn ở chế độ nháp cho SC-088.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: _advancedSpace),
                    VitCtaButton(
                      onPressed: onClose,
                      height: _advancedSheetActionExtent,
                      density: VitDensity.tool,
                      child: Text(
                        'Đóng',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color _toneColor(TradeAdvancedMetricTone tone) {
  return switch (tone) {
    TradeAdvancedMetricTone.positive => _advancedGreen,
    TradeAdvancedMetricTone.negative => _advancedRed,
    TradeAdvancedMetricTone.warning => AppColors.warn,
    TradeAdvancedMetricTone.accent => _advancedPrimary,
    TradeAdvancedMetricTone.neutral => AppColors.text1,
  };
}
