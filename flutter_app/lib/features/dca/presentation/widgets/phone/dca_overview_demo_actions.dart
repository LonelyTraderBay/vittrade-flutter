part of '../../phone/pages/hub/dca_overview_demo.dart';

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.scenarioId});

  final String scenarioId;

  @override
  Widget build(BuildContext context) {
    const actions = [
      _ActionSpec(
        'create',
        Icons.add_rounded,
        'Tạo mới',
        AppColors.buy,
        AppColors.buy15,
      ),
      _ActionSpec(
        'pause',
        Icons.pause_rounded,
        'Tạm dừng',
        AppColors.warn,
        AppColors.warn15,
      ),
      _ActionSpec(
        'chart',
        Icons.bar_chart_rounded,
        'Biểu đồ',
        AppColors.accent,
        AppColors.accent15,
      ),
      _ActionSpec(
        'history',
        Icons.format_list_bulleted_rounded,
        'Lịch sử',
        AppColors.text2,
        AppColors.hoverBg,
      ),
    ];
    return Row(
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          Expanded(
            child: _ActionButton(scenarioId: scenarioId, spec: actions[i]),
          ),
          if (i < actions.length - 1) const SizedBox(width: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.scenarioId, required this.spec});

  final String scenarioId;
  final _ActionSpec spec;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DCAOverviewDemo.actionKey(scenarioId, spec.id),
      onTap: HapticFeedback.selectionClick,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: EdgeInsets.zero,
      borderColor: AppColors.transparent,
      clip: true,
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.portfolioBtnGhost,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
        ),
        child: Padding(
          padding: DcaSpacingTokens.dcaOverviewActionButtonPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: ShapeDecoration(
                  color: spec.bg,
                  shape: const CircleBorder(),
                ),
                child: Padding(
                  padding: DcaSpacingTokens.dcaPaddingX3,
                  child: Icon(
                    spec.icon,
                    color: spec.color,
                    size: DcaSpacingTokens.dcaOverviewInlineIcon,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                spec.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextDim,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionSpec {
  const _ActionSpec(this.id, this.icon, this.label, this.color, this.bg);

  final String id;
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
}

class _OverviewSkeleton extends StatelessWidget {
  const _OverviewSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            VitSkeleton(
              width: DcaSpacingTokens.dcaOverviewSkeletonTitleWidth,
              height: DcaSpacingTokens.dcaOverviewSkeletonTitleHeight,
            ),
            Spacer(),
            VitSkeleton(
              width: DcaSpacingTokens.dcaOverviewSkeletonToggleSize,
              height: DcaSpacingTokens.dcaOverviewSkeletonToggleSize,
              borderRadius: AppRadii.xlRadius,
            ),
          ],
        ),
        SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitSkeleton(
          width: null,
          height: AppSpacing.x6,
          borderRadius: AppRadii.inputRadius,
        ),
        SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Row(
          children: [
            VitSkeleton(
              width: DcaSpacingTokens.dcaOverviewSkeletonChipWidth,
              height: AppSpacing.x5,
              borderRadius: AppRadii.smRadius,
            ),
            SizedBox(width: AppSpacing.x3),
            VitSkeleton(
              width: DcaSpacingTokens.dcaOverviewSkeletonMetaWidth,
              height: DcaSpacingTokens.dcaOverviewSkeletonMetaHeight,
            ),
          ],
        ),
        SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Row(
          children: [
            Expanded(
              child: VitSkeleton(
                width: null,
                height: AppSpacing.buttonHero,
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitSkeleton(
                width: null,
                height: AppSpacing.buttonHero,
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitSkeleton(
                width: null,
                height: AppSpacing.buttonHero,
                borderRadius: AppRadii.cardRadius,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitSkeleton(
          width: null,
          height: AppSpacing.x7,
          borderRadius: AppRadii.cardRadius,
        ),
        SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Row(
          children: [
            Expanded(
              child: VitSkeleton(
                width: null,
                height: AppSpacing.x7,
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitSkeleton(
                width: null,
                height: AppSpacing.x7,
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitSkeleton(
                width: null,
                height: AppSpacing.x7,
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitSkeleton(
                width: null,
                height: AppSpacing.x7,
                borderRadius: AppRadii.cardRadius,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DemoFooter extends StatelessWidget {
  const _DemoFooter({required this.snapshot});

  final DcaOverviewDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DCAOverviewDemo.footerKey,
      variant: VitCardVariant.inner,
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Text(
        'Component: ${snapshot.componentName} · Location: ${snapshot.componentLocation}',
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({
    required this.values,
    required this.lineColor,
    required this.fillColor,
  });

  final List<double> values;
  final Color lineColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2 || size.width <= 0 || size.height <= 0) return;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = max - min == 0 ? 1 : max - min;
    final points = <Offset>[
      for (var i = 0; i < values.length; i++)
        Offset(
          (i / (values.length - 1)) * size.width,
          AppSpacing.x1 +
              (size.height - AppSpacing.x2) -
              ((values[i] - min) / range) * (size.height - AppSpacing.x2),
        ),
    ];

    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      line.lineTo(points[i].dx, points[i].dy);
    }

    final area = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(area, Paint()..color = fillColor);
    canvas.drawPath(
      line,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(points.last, AppSpacing.x2, Paint()..color = lineColor);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}

// Delegates to the shared, sign-safe formatters in dca_currency_formatters.dart
// (see that file's doc comment for why the two former local implementations
// were consolidated, and why _formatPercent was relocated rather than merged
// with the other DCA screens' divergent percent formatters).
String _formatFullVnd(int amount) => formatFullVnd(amount);

String _formatCompactVnd(int amount) => formatCompactVnd(amount);

String _formatPercent(double value) => formatPercentSigned(value);
