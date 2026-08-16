import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_backtest_page.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_backtest_common.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_backtest_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class AllocationCard extends StatelessWidget {
  const AllocationCard({
    super.key,
    required this.preset,
    required this.weightedApy,
    required this.amountUsd,
  });

  final SavingsBacktestPresetDraft preset;
  final double weightedApy;
  final int amountUsd;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsBacktestPage.allocationKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        children: [
          Row(
            children: [
              CustomPaint(
                size: const Size.square(
                  EarnSpacingTokens.savingsBacktestAllocationRing,
                ),
                painter: AllocationRingPainter(slots: preset.slots),
                child: SizedBox(
                  width: EarnSpacingTokens.savingsBacktestAllocationRing,
                  height: EarnSpacingTokens.savingsBacktestAllocationRing,
                  child: Center(
                    child: Text(
                      '${preset.slots.length}',
                      style: captionBoldStyle.copyWith(color: AppColors.text1),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  children: [
                    for (final slot in preset.slots) _AllocationRow(slot: slot),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  label: 'APY TB',
                  value: '${weightedApy.toStringAsFixed(1)}%',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SummaryTile(
                  label: 'Sản phẩm',
                  value: '${preset.slots.length}',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SummaryTile(
                  label: 'Dự kiến lãi/năm',
                  value: usd(amountUsd * weightedApy / 100),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({required this.slot});

  final SavingsBacktestSlotDraft slot;

  @override
  Widget build(BuildContext context) {
    final color = slotColor(slot.colorKey);
    return Padding(
      key: SavingsBacktestPage.slotKey(slot.id),
      padding: EarnSpacingTokens.earnBottomPaddingX1,
      child: Row(
        children: [
          DecoratedBox(
            decoration: ShapeDecoration(
              color: color,
              shape: const CircleBorder(),
            ),
            child: const SizedBox(
              width: EarnSpacingTokens.savingsBacktestLegendDot,
              height: EarnSpacingTokens.savingsBacktestLegendDot,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              slot.product,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: microBoldStyle.copyWith(color: AppColors.text1),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            '${slot.percentage}%',
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            '${slot.avgApy.toStringAsFixed(1)}%',
            style: AppTextStyles.micro.copyWith(color: AppColors.buy),
          ),
        ],
      ),
    );
  }
}

class ResultsTab extends StatelessWidget {
  const ResultsTab({
    super.key,
    required this.snapshot,
    required this.amountUsd,
    required this.period,
    required this.preset,
    required this.onReset,
    required this.onApply,
  });

  final SavingsBacktestSnapshot snapshot;
  final int amountUsd;
  final SavingsBacktestPeriodDraft period;
  final SavingsBacktestPresetDraft preset;
  final VoidCallback onReset;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final result = snapshot.result;
    return Column(
      key: SavingsBacktestPage.resultsKey,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          borderColor: AppColors.buy20,
          padding: EarnSpacingTokens.earnPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Hiệu suất tổng quan',
                    style: captionBoldStyle.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  Expanded(
                    child: _ResultTile(
                      label: 'Tổng lãi',
                      value: '+${usd(result.totalReturnUsd)}',
                      caption: '+${result.totalReturnPct.toStringAsFixed(2)}%',
                      color: AppColors.buy,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _ResultTile(
                      label: 'Giá trị cuối kỳ',
                      value: usd(result.finalValueUsd),
                      caption: period.label,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  Expanded(
                    child: _SummaryTile(
                      label: 'APY hiệu quả',
                      value:
                          '${result.annualizedReturnPct.toStringAsFixed(2)}%',
                      color: AppColors.buy,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _SummaryTile(
                      label: 'Max Drawdown',
                      value: '${result.maxDrawdownPct.toStringAsFixed(2)}%',
                      color: AppColors.warn,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _SummaryTile(
                      label: 'Sharpe',
                      value: result.sharpeRatio.toStringAsFixed(2),
                      color: AppColors.buy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        _GrowthChart(points: result.points, initialAmount: amountUsd),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Row(
          children: [
            Expanded(
              child: _ResultTile(
                label: 'Tháng dương',
                value: '${result.monthsPositive}',
                caption: 'Tốt nhất +${usd(result.bestMonthUsd)}',
                color: AppColors.buy,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _ResultTile(
                label: 'Tháng âm',
                value: '${result.monthsNegative}',
                caption: 'Tệ nhất ${usd(result.worstMonthUsd)}',
                color: result.monthsNegative > 0
                    ? AppColors.sell
                    : AppColors.text1,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Row(
          children: [
            Expanded(
              child: VitCtaButton(
                variant: VitCtaButtonVariant.secondary,
                onPressed: onReset,
                leading: const Icon(Icons.refresh_rounded),
                child: const Text('Chạy lại'),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                key: SavingsBacktestPage.applyKey,
                onPressed: onApply,
                leading: const Icon(Icons.auto_awesome_rounded),
                child: const Text('Áp dụng'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        EarnWarningBanner(
          text: snapshot.disclaimer,
          lineHeight: EarnSpacingTokens.savingsBacktestWarningLineHeight,
        ),
      ],
    );
  }
}

class _GrowthChart extends StatelessWidget {
  const _GrowthChart({required this.points, required this.initialAmount});

  final List<SavingsBacktestPointDraft> points;
  final int initialAmount;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.query_stats_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tăng trưởng tài sản',
                style: captionBoldStyle.copyWith(color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height: EarnSpacingTokens.savingsBacktestGrowthChartHeight,
            child: CustomPaint(
              painter: _GrowthPainter(
                points: points,
                initialAmount: initialAmount.toDouble(),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.label,
    required this.value,
    required this.caption,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final String caption;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(color: color),
          ),
          Text(caption, style: AppTextStyles.micro.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: captionBoldStyle.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _GrowthPainter extends CustomPainter {
  const _GrowthPainter({required this.points, required this.initialAmount});

  final List<SavingsBacktestPointDraft> points;
  final double initialAmount;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final minValue = points.map((p) => p.valueUsd).reduce(math.min);
    final maxValue = points.map((p) => p.valueUsd).reduce(math.max);
    final range = math.max(1, maxValue - minValue);
    final chartRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = chartRect.top + chartRect.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final baselineY =
        chartRect.bottom -
        ((initialAmount - minValue) / range) * chartRect.height;
    final baselinePaint = Paint()
      ..color = AppColors.warn
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(0, baselineY.clamp(0, size.height)),
      Offset(size.width, baselineY.clamp(0, size.height)),
      baselinePaint,
    );

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chartRect.left + chartRect.width * i / (points.length - 1);
      final y =
          chartRect.bottom -
          ((points[i].valueUsd - minValue) / range) * chartRect.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fill, Paint()..color = AppColors.buy10);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.buy
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _GrowthPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.initialAmount != initialAmount;
  }
}
