import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_ladder_page.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_common.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_formatters.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_liquidity.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

const _disclaimerLineHeight = 1.22;

class AnalysisTab extends StatelessWidget {
  const AnalysisTab({
    super.key,
    required this.snapshot,
    required this.rungs,
    required this.amountUsd,
    required this.weightedApy,
    required this.annualInterest,
    required this.liquidityScore,
    required this.onEmptyCta,
  });

  final SavingsLadderSnapshot snapshot;
  final List<SavingsLadderRungDraft> rungs;
  final int amountUsd;
  final double weightedApy;
  final double annualInterest;
  final int liquidityScore;
  final VoidCallback onEmptyCta;

  @override
  Widget build(BuildContext context) {
    if (rungs.isEmpty) {
      return EmptyTab(
        icon: Icons.bar_chart_rounded,
        title: 'Tạo ladder để xem phân tích',
        cta: 'Bắt đầu xây',
        onCta: onEmptyCta,
      );
    }

    final avgLockDays =
        rungs.fold<int>(0, (total, rung) => total + rung.lockDays) ~/
        rungs.length;
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      key: SavingsLadderPage.analysisKey,
      padding: VitContentPadding.none,
      fullBleed: true,
      gap: VitContentGap.tight,
      children: [
        _MetricGrid(
          metrics: [
            _Metric(
              'APY bình quân',
              '${weightedApy.toStringAsFixed(2)}%',
              Icons.trending_up_rounded,
              AppColors.buy,
            ),
            _Metric(
              'Thanh khoản',
              '$liquidityScore/100',
              Icons.bolt_rounded,
              savingsLadderLiquidityColor(liquidityScore),
            ),
            _Metric(
              'Lock TB',
              '$avgLockDays ngày',
              Icons.lock_outline_rounded,
              AppColors.warn,
            ),
            _Metric(
              'Lãi dự kiến/năm',
              savingsLadderMoney(annualInterest),
              Icons.attach_money_rounded,
              AppColors.buy,
            ),
          ],
        ),
        const SectionTitle(label: 'Phân bổ theo tài sản'),
        _AssetBreakdown(rungs: rungs),
        const SectionTitle(label: 'Phân bổ theo thời hạn'),
        _DurationBreakdown(rungs: rungs),
        const SectionTitle(label: 'Đánh giá thanh khoản'),
        LiquidityCard(score: liquidityScore, rungs: rungs),
        OptimizationTip(
          weightedApy: weightedApy,
          liquidityScore: liquidityScore,
        ),
        EarnDisclaimerBanner(
          text: snapshot.disclaimer,
          lineHeight: _disclaimerLineHeight,
        ),
      ],
    );
  }
}

class _Metric {
  const _Metric(this.label, this.value, this.icon, this.color);

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<_Metric> metrics;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: EarnSpacingTokens.savingsLadderMetricGridColumns,
      childAspectRatio: EarnSpacingTokens.savingsLadderGridAspect,
      crossAxisSpacing: AppSpacing.x3,
      mainAxisSpacing: AppSpacing.x3,
      children: [
        for (final metric in metrics)
          VitCard(
            radius: VitCardRadius.large,
            density: VitDensity.compact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      metric.icon,
                      color: metric.color,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        metric.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  metric.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(
                    color: metric.color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AssetBreakdown extends StatelessWidget {
  const _AssetBreakdown({required this.rungs});

  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    final total = savingsLadderTotalAllocated(rungs);
    final byAsset = <String, _AssetBucket>{};
    for (final rung in rungs) {
      final current = byAsset[rung.asset] ?? _AssetBucket(rung.colorKey);
      byAsset[rung.asset] = current.add(rung);
    }
    return VitCard(
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      child: Column(
        children: [
          for (final entry in byAsset.entries) ...[
            _BreakdownRow(
              label: entry.key,
              caption: '${entry.value.count} bậc',
              value: savingsLadderMoney(entry.value.totalUsd),
              percent: total <= 0 ? 0 : entry.value.totalUsd / total,
              color: savingsLadderColorFor(entry.value.colorKey),
            ),
            if (entry.key != byAsset.keys.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}

class _AssetBucket {
  const _AssetBucket(this.colorKey, {this.totalUsd = 0, this.count = 0});

  final String colorKey;
  final double totalUsd;
  final int count;

  _AssetBucket add(SavingsLadderRungDraft rung) {
    return _AssetBucket(
      colorKey,
      totalUsd: totalUsd + rung.amountUsd,
      count: count + 1,
    );
  }
}

class _DurationBreakdown extends StatelessWidget {
  const _DurationBreakdown({required this.rungs});

  final List<SavingsLadderRungDraft> rungs;

  @override
  Widget build(BuildContext context) {
    final total = savingsLadderTotalAllocated(rungs);
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      gap: VitContentGap.tight,
      children: [
        for (final days in [30, 60, 90]) ...[
          if (rungs.any((rung) => rung.lockDays == days))
            _DurationTile(days: days, rungs: rungs, totalUsd: total),
        ],
      ],
    );
  }
}

class _DurationTile extends StatelessWidget {
  const _DurationTile({
    required this.days,
    required this.rungs,
    required this.totalUsd,
  });

  final int days;
  final List<SavingsLadderRungDraft> rungs;
  final double totalUsd;

  @override
  Widget build(BuildContext context) {
    final dayRungs = rungs.where((rung) => rung.lockDays == days).toList();
    final amount = savingsLadderTotalAllocated(dayRungs);
    final pct = totalUsd <= 0 ? 0.0 : amount / totalUsd;
    final avgApy = dayRungs.isEmpty
        ? 0.0
        : dayRungs.fold<double>(0, (total, rung) => total + rung.apyPct) /
              dayRungs.length;
    final color = days <= 30
        ? AppColors.buy
        : days <= 60
        ? AppColors.primary
        : AppColors.accent;
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      child: Row(
        children: [
          RoundIcon(icon: Icons.schedule_rounded, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dayRungs.length} bậc · ${(pct * 100).toStringAsFixed(0)}%',
                  style: savingsLadderCaptionBoldStyle.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                Text(
                  '${savingsLadderMoney(amount)} · APY TB: ${avgApy.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            '${avgApy.toStringAsFixed(1)}%',
            style: savingsLadderCaptionBoldStyle.copyWith(color: AppColors.buy),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.caption,
    required this.value,
    required this.percent,
    required this.color,
  });

  final String label;
  final String caption;
  final String value;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox.square(
              dimension: EarnSpacingTokens.savingsLadderBreakdownDot,
              child: Material(color: color, shape: const CircleBorder()),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: savingsLadderCaptionBoldStyle.copyWith(
                color: AppColors.text1,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(caption, style: AppTextStyles.micro),
            const Expanded(child: SizedBox.shrink()),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              '${(percent * 100).toStringAsFixed(0)}%',
              style: savingsLadderCaptionBoldStyle.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ClipRRect(
          borderRadius: AppRadii.pillRadius,
          child: LinearProgressIndicator(
            minHeight: AppSpacing.x1,
            value: percent.clamp(0.0, 1.0),
            color: color,
            backgroundColor: AppColors.surface3,
          ),
        ),
      ],
    );
  }
}
