part of '../../phone/pages/analytics/performance_attribution_page.dart';

class _DrawdownTab extends StatelessWidget {
  const _DrawdownTab({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      children: [
        const VitSectionHeader(
          title: 'Underwater Chart',
          titleColor: AppColors.text2,
          titleFontWeight: AppTextStyles.extraBold,
          titleLetterSpacing: .2,
          bottomGap: AppSpacing.pageRhythmCompactInnerGap,
        ),
        SizedBox(
          height: _attributionChartHeight,
          child: CustomPaint(
            painter: _DrawdownPainter(snapshot.drawdowns),
            child: const SizedBox.expand(),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: 'Max Drawdown',
                value: '${snapshot.maxDrawdownPct.toStringAsFixed(2)}%',
                caption: 'lowest point',
                valueColor: _attributionRed,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _MetricTile(
                label: 'Avg Drawdown',
                value: '${snapshot.avgDrawdownPct.toStringAsFixed(2)}%',
                caption: 'average',
                valueColor: AppColors.text1,
              ),
            ),
          ],
        ),
        const VitBanner(
          variant: VitBannerVariant.warning,
          icon: Icons.warning_amber_rounded,
          message:
              'Underwater chart hiển thị khoảng cách từ đỉnh lịch sử. Recovery dài có thể gây stress tâm lý.',
        ),
      ],
    );
  }
}

class _ProjectionTab extends StatelessWidget {
  const _ProjectionTab({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      children: [
        const VitSectionHeader(
          title: 'Monte Carlo Simulation (30 ngày)',
          titleColor: AppColors.text2,
          titleFontWeight: AppTextStyles.extraBold,
          titleLetterSpacing: .2,
          bottomGap: AppSpacing.pageRhythmCompactInnerGap,
        ),
        const VitBanner(
          variant: VitBannerVariant.info,
          icon: Icons.info_outline_rounded,
          message:
              '50 kịch bản ngẫu nhiên dựa trên volatility lịch sử. Vùng tím thể hiện khoảng xác suất tham khảo.',
        ),
        SizedBox(
          height: _attributionChartHeight,
          child: CustomPaint(
            painter: _ProjectionPainter(snapshot.monteCarloPaths),
            child: const SizedBox.expand(),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _ProjectionTile(
                label: '5th Percentile',
                value: snapshot.worstProjection,
                color: _attributionRed,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: _ProjectionTile(
                label: '50th Percentile',
                value: snapshot.medianProjection,
                color: _attributionPurple,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: _ProjectionTile(
                label: '95th Percentile',
                value: snapshot.bestProjection,
                color: _attributionGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CorrelationTab extends StatelessWidget {
  const _CorrelationTab({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      children: [
        const VitSectionHeader(
          title: 'Daily Returns Correlation',
          titleColor: AppColors.text2,
          titleFontWeight: AppTextStyles.extraBold,
          titleLetterSpacing: .2,
          bottomGap: AppSpacing.pageRhythmCompactInnerGap,
        ),
        SizedBox(
          height: _attributionChartHeight,
          child: CustomPaint(
            painter: _CorrelationPainter(snapshot.correlationPoints),
            child: const SizedBox.expand(),
          ),
        ),
        VitCard(
          radius: VitCardRadius.tight,
          density: VitDensity.tool,
          padding: AppSpacing.cardPaddingCompact,
          child: Column(
            children: [
              _KeyValueRow(
                label: 'Correlation coefficient (R)',
                value: math.sqrt(snapshot.rSquared).toStringAsFixed(2),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              _KeyValueRow(
                label: 'R² (explained variance)',
                value: '${(snapshot.rSquared * 100).toStringAsFixed(0)}%',
              ),
            ],
          ),
        ),
        const VitBanner(
          variant: VitBannerVariant.info,
          icon: Icons.info_outline_rounded,
          message:
              'R² cho biết bao nhiêu biến động của bạn được giải thích bởi thị trường; phần còn lại đến từ strategy riêng.',
        ),
      ],
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _attributionPrimary,
      background: ColoredBox(color: _attributionPrimary.withValues(alpha: .10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _attributionPrimary,
            size: AppSpacing.inputPrefixIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.micro.copyWith(color: _attributionPrimary),
                children: [
                  TextSpan(
                    text: 'Giải thích\n',
                    style: AppTextStyles.micro.copyWith(
                      color: _attributionPrimary,
                      fontWeight: AppTextStyles.extraBold,
                    ),
                  ),
                  const TextSpan(
                    text:
                        'Alpha: Phần lợi nhuận do kỹ năng provider. Beta: Phần lợi nhuận do thị trường chung tăng/giảm. ',
                  ),
                  TextSpan(
                    text:
                        'Beta ${snapshot.beta.toStringAsFixed(2)} nghĩa là khi thị trường +1%, bạn +${snapshot.beta.toStringAsFixed(2)}%.',
                    style: AppTextStyles.micro.copyWith(
                      color: _attributionPrimary,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContributionBar extends StatelessWidget {
  const _ContributionBar({
    required this.label,
    required this.value,
    required this.color,
    required this.ratio,
  });

  final String label;
  final double value;
  final Color color;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${value >= 0 ? '+' : ''}${value.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.heavy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ClipRRect(
            borderRadius: AppRadii.smRadius,
            child: LinearProgressIndicator(
              value: ratio.clamp(0, 1),
              minHeight: AppSpacing.x1,
              color: color,
              backgroundColor: AppColors.surface3,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectionTile extends StatelessWidget {
  const _ProjectionTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: color.withValues(alpha: .24),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: color),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '\$${value.toStringAsFixed(0)}',
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.heavy,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            fontWeight: AppTextStyles.heavy,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
