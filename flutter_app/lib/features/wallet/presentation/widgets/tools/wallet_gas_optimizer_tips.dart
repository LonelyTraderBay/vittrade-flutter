part of '../../phone/pages/tools/wallet_gas_optimizer_page.dart';

class _TipsTab extends StatelessWidget {
  const _TipsTab({required this.snapshot, required this.onQuickAction});

  final WalletGasOptimizerSnapshot snapshot;
  final ValueChanged<String> onQuickAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: sectionChildren,
    );
  }

  List<Widget> get sectionChildren => [
    VitPageSection(
      label: 'Gas Optimization Tips',
      accentColor: _gasPrimary,
      innerGap: AppSpacing.pageRhythmStandardInnerGap,
      children: [
        for (var i = 0; i < snapshot.tips.length; i++)
          _TipCard(tip: snapshot.tips[i]),
        _QuickActionsCard(onAction: onQuickAction),
      ],
    ),
  ];
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final WalletGasTip tip;

  @override
  Widget build(BuildContext context) {
    final color = switch (tip.difficulty) {
      'easy' => _gasGreen,
      'medium' => _gasAmber,
      'advanced' => _gasRed,
      _ => AppColors.text3,
    };
    return VitCard(
      density: VitDensity.compact,
      borderColor: _gasBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            radius: VitCardRadius.standard,
            borderColor: _gasAmber.withValues(alpha: .20),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: _gasAmber,
              size: WalletSpacingTokens.walletGasTipIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tip.title,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    _SmallBadge(
                      label: tip.difficulty.toUpperCase(),
                      color: color,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  tip.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.28,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  children: [
                    VitAccentPill(
                      label: tip.category,
                      accentColor: AppColors.textSoftBlue,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.attach_money_rounded,
                              color: _gasGreen,
                              size: WalletSpacingTokens.walletGasSavingIcon,
                            ),
                            Text(
                              'Est. ${tip.potentialSaving}',
                              style: AppTextStyles.caption.copyWith(
                                color: _gasGreen,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({required this.onAction});

  final ValueChanged<String> onAction;
  static const _actions = [
    'Set Gas Price Alert',
    'Schedule Transaction',
    'View L2 Options',
  ];

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _gasBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Quick Actions',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (var i = 0; i < _actions.length; i++) ...[
            VitServiceTile(
              icon: Icons.bolt_outlined,
              label: _actions[i],
              accentColor: _gasPrimary,
              density: VitServiceTileDensity.compact,
              badgeLabel: 'Deferred',
              onTap: () => onAction(_actions[i]),
            ),
            if (i != _actions.length - 1)
              const SizedBox(
                height: WalletSpacingTokens.walletGasQuickActionBottomGap,
              ),
          ],
        ],
      ),
    );
  }
}

class _GasLineChartPainter extends CustomPainter {
  const _GasLineChartPainter({required this.points});

  final List<WalletGasHistoryPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final chart = Rect.fromLTWH(
      WalletSpacingTokens.walletGasLineChartInsetX,
      WalletSpacingTokens.walletGasLineChartInsetTop,
      size.width - WalletSpacingTokens.walletGasLineChartInsetX * 2,
      size.height - WalletSpacingTokens.walletGasLineChartInsetBottom,
    );
    _drawGasLine(canvas, chart, points.map((p) => p.slow).toList(), _gasGreen);
    _drawGasLine(
      canvas,
      chart,
      points.map((p) => p.standard).toList(),
      _gasAmber,
    );
    _drawGasLine(canvas, chart, points.map((p) => p.fast).toList(), _gasRed);
  }

  void _drawGasLine(Canvas canvas, Rect chart, List<int> values, Color color) {
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = math.max(1, maxValue - minValue);
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = chart.left + chart.width * i / (values.length - 1);
      final y = chart.bottom - ((values[i] - minValue) / range) * chart.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = color
      ..strokeWidth = WalletSpacingTokens.walletGasChartStroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GasLineChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _NetworkBarChartPainter extends CustomPainter {
  const _NetworkBarChartPainter({required this.points});

  final List<WalletNetworkActivityPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxTx = points.map((point) => point.txCount).reduce(math.max);
    final barWidth =
        size.width /
        (points.length * WalletSpacingTokens.walletGasNetworkBarWidthDivisor);
    final gap = barWidth * WalletSpacingTokens.walletGasNetworkBarGapMultiplier;
    final paint = Paint()..color = _gasPrimary;
    for (var i = 0; i < points.length; i++) {
      final barHeight =
          (points[i].txCount / maxTx) *
          (size.height - WalletSpacingTokens.walletGasNetworkBarHeightInset);
      final left =
          i * (barWidth + gap) +
          WalletSpacingTokens.walletGasNetworkBarLeftPadding;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, size.height - barHeight, barWidth, barHeight),
        AppRadii.statusBarCorner,
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NetworkBarChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

String _withCommas(String value) {
  final buffer = StringBuffer();
  for (var i = 0; i < value.length; i++) {
    final remaining = value.length - i;
    buffer.write(value[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
