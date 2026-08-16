part of '../../phone/pages/hub/launchpad_performance_page.dart';

class _ChartTab extends StatelessWidget {
  const _ChartTab({required this.points});

  final List<LaunchpadPerformancePointDraft> points;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.standard,
          padding: _launchpadPerformanceCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ROI trung bình theo tháng (ATH)',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'Chỉ tính các tháng có dự án launch. Tháng không có dự án hiện 0%.',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _PointBars(
                points: points,
                valueFor: (point) => point.avgRoi.toDouble(),
                suffix: '%',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          radius: VitCardRadius.standard,
          padding: _launchpadPerformanceCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Khối lượng huy động theo tháng',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'Tổng số USDT huy động qua tất cả dự án trong tháng.',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _PointBars(
                points: points,
                valueFor: (point) => point.volume / 1000,
                suffix: 'K',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PointBars extends StatelessWidget {
  const _PointBars({
    required this.points,
    required this.valueFor,
    required this.suffix,
  });

  final List<LaunchpadPerformancePointDraft> points;
  final double Function(LaunchpadPerformancePointDraft point) valueFor;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final max = points.fold<double>(
      1,
      (largest, point) => valueFor(point) > largest ? valueFor(point) : largest,
    );
    return SizedBox(
      height: _launchpadPerformanceSparklineHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final point in points) ...[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${valueFor(point).round()}$suffix',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: _launchpadPerformanceLineHeightTight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Flexible(
                    child: FractionallySizedBox(
                      heightFactor: (valueFor(point) / max).clamp(.08, 1.0),
                      alignment: Alignment.bottomCenter,
                      child: const DecoratedBox(
                        decoration: ShapeDecoration(
                          color: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.mdRadius,
                          ),
                        ),
                        child: SizedBox.expand(),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Text(
                    point.month,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: _launchpadPerformanceLineHeightTight,
                    ),
                  ),
                ],
              ),
            ),
            if (point != points.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _PerformanceDisclaimer extends StatelessWidget {
  const _PerformanceDisclaimer();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: LaunchpadPerformancePage.disclaimerKey,
      decoration: const ShapeDecoration(
        color: AppColors.warn08,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.warningBorder),
          borderRadius: AppRadii.cardRadius,
        ),
      ),
      child: Padding(
        padding: _launchpadPerformanceCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                'Hiệu suất quá khứ không đảm bảo kết quả tương lai. Dữ liệu chỉ mang tính tham khảo. ROI được tính từ giá launch đến giá hiện tại hoặc ATH, chưa trừ phí và slippage. Nghiên cứu kỹ trước khi tham gia bất kỳ dự án nào.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: _launchpadPerformanceLineHeightReadable,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({required this.label, required this.status});

  final String label;
  final VitStatusPillStatus status;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: label,
      status: status,
      size: VitStatusPillSize.sm,
      outline: true,
    );
  }
}

enum _PerformanceTab {
  overview('overview', 'Tổng quan'),
  projects('projects', 'Dự án'),
  chart('chart', 'Biểu đồ');

  const _PerformanceTab(this.id, this.label);

  final String id;
  final String label;
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

String _formatPrice(double value) {
  if (value < .1) return value.toStringAsFixed(3);
  return value.toStringAsFixed(value < 1 ? 2 : 0);
}
