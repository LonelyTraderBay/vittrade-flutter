part of '../../phone/pages/hub/dca_overview_demo.dart';

class _DemoSection extends StatelessWidget {
  const _DemoSection({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      gap: VitContentGap.tight,
      children: [
        VitModuleSectionHeader(
          title: title,
          accentColor: AppModuleAccents.trade,
        ),
        Text(
          description,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        child,
      ],
    );
  }
}

class _DcaOverviewCardPreview extends StatefulWidget {
  const _DcaOverviewCardPreview({
    required this.scenario,
    this.isLoading = false,
    this.compact = false,
  });

  final DcaOverviewDemoScenario scenario;
  final bool isLoading;
  final bool compact;

  @override
  State<_DcaOverviewCardPreview> createState() =>
      _DcaOverviewCardPreviewState();
}

class _DcaOverviewCardPreviewState extends State<_DcaOverviewCardPreview> {
  bool _balanceHidden = false;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DCAOverviewDemo.cardKey(widget.scenario.id),
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: widget.compact
          ? DcaSpacingTokens.dcaPaddingX4
          : DcaSpacingTokens.dcaContentPadding,
      child: widget.isLoading
          ? const _OverviewSkeleton()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderRow(
                  balanceHidden: _balanceHidden,
                  onToggle: () {
                    unawaited(HapticFeedback.selectionClick());
                    setState(() => _balanceHidden = !_balanceHidden);
                  },
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                _ValueRow(
                  data: widget.scenario.data,
                  sparkline: widget.scenario.sparkline,
                  balanceHidden: _balanceHidden,
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                _ProfitRow(
                  data: widget.scenario.data,
                  balanceHidden: _balanceHidden,
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
                _MetricGrid(
                  data: widget.scenario.data,
                  balanceHidden: _balanceHidden,
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
                _NextExecutionRow(data: widget.scenario.data),
                if (widget.scenario.showActions) ...[
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  _ActionRow(scenarioId: widget.scenario.id),
                ],
              ],
            ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.balanceHidden, required this.onToggle});

  final bool balanceHidden;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Tổng danh mục DCA (VND)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextDim,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        VitInlineIconAction(
          icon: balanceHidden
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          tooltip: balanceHidden ? 'Show balance' : 'Hide balance',
          onPressed: onToggle,
          color: AppColors.portfolioTextMuted,
          size: DcaSpacingTokens.dcaOverviewInlineIcon,
          padding: AppSpacing.x1,
        ),
      ],
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({
    required this.data,
    required this.sparkline,
    required this.balanceHidden,
  });

  final DcaOverviewDemoData data;
  final List<double> sparkline;
  final bool balanceHidden;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              balanceHidden
                  ? '••••••'
                  : '₫${_formatFullVnd(data.currentValueVnd)}',
              maxLines: 1,
              style: AppTextStyles.numericDisplay2xl.copyWith(
                fontWeight: AppTextStyles.heavy,
                height: DcaSpacingTokens.dcaOverviewHeroLineHeight,
                color: AppColors.text1,
              ),
            ),
          ),
        ),
        if (sparkline.length >= 2) ...[
          const SizedBox(width: AppSpacing.x4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: AppSpacing.buttonHero + AppSpacing.x3,
                height: AppSpacing.buttonCompact + AppSpacing.x2,
                child: CustomPaint(
                  painter: _SparklinePainter(
                    values: sparkline,
                    lineColor: data.isProfit ? AppColors.buy : AppColors.sell,
                    fillColor: data.isProfit
                        ? AppColors.buy15
                        : AppColors.sell15,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '90 ngày',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
