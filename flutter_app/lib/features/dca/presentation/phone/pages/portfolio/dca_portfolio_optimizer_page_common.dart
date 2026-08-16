part of 'dca_portfolio_optimizer_page.dart';

class _BacktestChartPainter extends CustomPainter {
  const _BacktestChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(
      AppSpacing.x4,
      AppSpacing.x2,
      size.width - AppSpacing.x5,
      size.height - AppSpacing.x4,
    );
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;

    for (var i = 0; i <= 4; i++) {
      final y = chart.top + chart.height * i / 4;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }

    final dca = [8, 12, 16, 22, 24, 28, 34, 39, 46, 53, 57, 64];
    final hodl = [8, 11, 14, 19, 21, 25, 31, 36, 42, 47, 51, 56];
    _drawSeries(canvas, chart, dca, AppColors.buy);
    _drawSeries(canvas, chart, hodl, AppColors.warn);
  }

  void _drawSeries(Canvas canvas, Rect chart, List<int> values, Color color) {
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = chart.left + chart.width * i / (values.length - 1);
      final y = chart.bottom - chart.height * values[i] / 70;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _BacktestChartPainter oldDelegate) => false;
}

Color _assetColor(DcaPortfolioAssetAccent accent) {
  return switch (accent) {
    DcaPortfolioAssetAccent.btc => AppColors.primarySoft,
    DcaPortfolioAssetAccent.eth => AppColors.accent,
    DcaPortfolioAssetAccent.usdt => AppColors.buy,
    DcaPortfolioAssetAccent.sol => AppColors.accent,
    DcaPortfolioAssetAccent.bnb => AppColors.warn,
  };
}

String _tabLabel(_OptimizerTab tab) {
  return switch (tab) {
    _OptimizerTab.frontier => 'Frontier',
    _OptimizerTab.correlation => 'Tương quan',
    _OptimizerTab.backtest => 'Backtest',
    _OptimizerTab.risk => 'Rủi ro',
  };
}

IconData _tabIcon(_OptimizerTab tab) {
  return switch (tab) {
    _OptimizerTab.frontier => Icons.adjust_rounded,
    _OptimizerTab.correlation => Icons.hub_outlined,
    _OptimizerTab.backtest => Icons.bar_chart_rounded,
    _OptimizerTab.risk => Icons.shield_outlined,
  };
}
