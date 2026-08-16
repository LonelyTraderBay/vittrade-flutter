part of '../../phone/pages/savings/savings_what_if_page.dart';

class _StressTab extends StatelessWidget {
  const _StressTab({required this.snapshot});

  final SavingsWhatIfSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final results = [
      for (final scenario in snapshot.scenarios)
        if (scenario.id != SavingsWhatIfScenarioId.custom)
          _StressScenarioResult(
            scenario: scenario,
            result: _simulateScenario(
              snapshot.portfolio,
              scenario,
              snapshot.defaultCustomMultiplier,
              snapshot.defaultCustomVolatility,
            ),
          ),
    ]..sort((a, b) => b.result.difference.compareTo(a.result.difference));
    final worst = results.last;
    final best = results.first;
    final average =
        results.fold<double>(
          0,
          (sum, entry) => sum + entry.result.differencePct,
        ) /
        results.length;
    final score = math.max(0, math.min(100, 50 + average * 5)).round();
    final scoreColor = score >= 60
        ? AppColors.buy
        : score >= 40
        ? AppColors.warn
        : AppColors.sell;

    return Column(
      key: SavingsWhatIfPage.stressKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.stacked_line_chart_rounded,
                    color: AppColors.primary,
                    size: EarnSpacingTokens.savingsWhatIfInlineIcon,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Stress Test tổng hợp',
                    style: _captionBold.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              _StressBars(results: results),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const VitSectionHeader(
          title: 'Xếp hạng theo ảnh hưởng',
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: AppModuleAccents.earn,
          bottomGap: AppSpacing.x3,
        ),
        for (final entry in results) ...[
          _StressRankCard(entry: entry),
          if (entry != results.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnPaddingX4,
          borderColor: scoreColor.withValues(alpha: .35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: scoreColor,
                    size: EarnSpacingTokens.savingsWhatIfInlineIcon,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Đánh giá chống chịu',
                    style: _captionBold.copyWith(color: AppColors.text2),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Row(
                children: [
                  _ScoreRing(score: score, color: scoreColor),
                  const SizedBox(width: AppSpacing.x4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          score >= 60
                              ? 'Danh mục chống chịu tốt'
                              : score >= 40
                              ? 'Cần cải thiện'
                              : 'Rủi ro cao',
                          style: _captionBold.copyWith(color: AppColors.text1),
                        ),
                        const Padding(
                          padding: EarnSpacingTokens.earnTopPaddingX1,
                        ),
                        Text(
                          'Xấu nhất (${worst.scenario.label}): ${worst.result.differencePct.toStringAsFixed(1)}%. Tốt nhất (${best.scenario.label}): +${best.result.differencePct.toStringAsFixed(1)}%.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: 'TB ảnh hưởng',
                      value:
                          '${average >= 0 ? '+' : ''}${average.toStringAsFixed(1)}%',
                      color: average >= 0 ? AppColors.buy : AppColors.sell,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _MetricTile(
                      label: 'Xấu nhất',
                      value:
                          '${worst.result.differencePct.toStringAsFixed(1)}%',
                      color: AppColors.sell,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _MetricTile(
                      label: 'Tốt nhất',
                      value:
                          '+${best.result.differencePct.toStringAsFixed(1)}%',
                      color: AppColors.buy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const VitInfoCallout(
          icon: Icons.auto_awesome_rounded,
          accentColor: AppModuleAccents.earn,
          title: 'Gợi ý tăng kháng chịu',
          message:
              'Đa dạng hóa tài sản và pha trộn sản phẩm linh hoạt với cố định giúp giảm rủi ro trong kịch bản bất lợi. Cân nhắc tăng tỷ trọng stablecoin để hỗ trợ ổn định danh mục.',
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnPaddingX3,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        EarnWarningBanner(text: snapshot.stressDisclaimer),
      ],
    );
  }
}
