part of '../../phone/pages/tools/portfolio_analytics_page.dart';

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({
    required this.snapshot,
    required this.activePeriod,
    required this.onPeriodChanged,
  });

  final WalletPortfolioAnalyticsSnapshot snapshot;
  final String activePeriod;
  final ValueChanged<String> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: sectionChildren,
    );
  }

  List<Widget> get sectionChildren => [
    _PeriodSelector(
      periods: snapshot.periods,
      active: activePeriod,
      onChanged: onPeriodChanged,
    ),
    VitPageSection(
      label: 'Bi\u1EC3u \u0111\u1ED3 danh m\u1EE5c',
      headerIcon: Icons.area_chart_rounded,
      headerIconColor: _analyticsGreen,
      accentColor: _analyticsGreen,
      innerGap: AppSpacing.pageRhythmStandardInnerGap,
      children: [_ChartCard(points: snapshot.history)],
    ),
    VitPageSection(
      label: 'Ch\u1EC9 s\u1ED1 hi\u1EC7u su\u1EA5t',
      headerIcon: Icons.speed_rounded,
      headerIconColor: _analyticsPrimary,
      accentColor: _analyticsPrimary,
      innerGap: AppSpacing.pageRhythmStandardInnerGap,
      children: [_MetricsCard(metrics: snapshot.metrics)],
    ),
    VitPageSection(
      label: 'V\u1ECB th\u1EBF hi\u1EC7n t\u1EA1i',
      headerIcon: Icons.account_balance_wallet_outlined,
      headerIconColor: _analyticsPrimary,
      accentColor: _analyticsPrimary,
      innerGap: AppSpacing.pageRhythmStandardInnerGap,
      children: [
        _AssetsCard(assets: snapshot.assets, totalUsd: snapshot.totalUsd),
      ],
    ),
  ];
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.periods,
    required this.active,
    required this.onChanged,
  });

  final List<String> periods;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      tabs: [
        for (final period in periods)
          VitTabItem(
            key: period,
            label: period,
            widgetKey: PortfolioAnalyticsPage.periodKey(period),
          ),
      ],
      activeKey: active,
      onChanged: onChanged,
      variant: VitTabBarVariant.segment,
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.points});

  final List<WalletPortfolioPoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      padding: WalletSpacingTokens.walletAnalyticsChartPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: WalletSpacingTokens.walletAnalyticsChartHeight,
            child: CustomPaint(
              painter: _PortfolioAreaPainter(points),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioAreaPainter extends CustomPainter {
  const _PortfolioAreaPainter(this.points);

  final List<WalletPortfolioPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final chart = Rect.fromLTWH(0, 8, size.width, size.height - 34);
    final minValue = points.map((p) => p.value).reduce(math.min);
    final maxValue = points.map((p) => p.value).reduce(math.max);
    final valueRange = math.max(1, maxValue - minValue);
    final mapped = <Offset>[];
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + (i / (points.length - 1)) * chart.width;
      final y =
          chart.bottom -
          ((points[i].value - minValue) / valueRange) * chart.height;
      mapped.add(Offset(x, y));
    }

    final linePath = Path()..moveTo(mapped.first.dx, mapped.first.dy);
    for (var i = 1; i < mapped.length; i++) {
      final previous = mapped[i - 1];
      final current = mapped[i];
      final controlX = (previous.dx + current.dx) / 2;
      linePath.cubicTo(
        controlX,
        previous.dy,
        controlX,
        current.dy,
        current.dx,
        current.dy,
      );
    }

    final fillPath = Path.from(linePath)
      ..lineTo(mapped.last.dx, chart.bottom)
      ..lineTo(mapped.first.dx, chart.bottom)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _analyticsGreen.withValues(alpha: .28),
            _analyticsGreen.withValues(alpha: .00),
          ],
        ).createShader(chart),
    );
    canvas.drawPath(
      linePath,
      Paint()
        ..color = _analyticsGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final labels = [
      '18/4',
      '23/4',
      '27/4',
      '1/5',
      '4/5',
      '7/5',
      '10/5',
      '18/5',
    ];
    final labelPaint = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    for (var i = 0; i < labels.length; i++) {
      final x = i / (labels.length - 1) * chart.width;
      labelPaint.text = TextSpan(
        text: labels[i],
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      );
      labelPaint.layout();
      labelPaint.paint(
        canvas,
        Offset(x - labelPaint.width / 2, size.height - 16),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PortfolioAreaPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
