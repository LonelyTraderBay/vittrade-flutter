part of '../../phone/pages/staking/staking_proof_of_reserves_page.dart';

const double _reserveTrendChartExtent = AppSpacing.x7 * 2;

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({
    required this.label,
    required this.value,
    this.color,
    this.alignEnd = false,
    this.suffix,
  });

  final String label;
  final String value;
  final Color? color;
  final bool alignEnd;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: color ?? AppColors.text1,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: AppSpacing.x1),
                Text(
                  suffix!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final StakingProofOfReservesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final overall = snapshot.overall;
    final surplus = overall.totalAssetsUsd - overall.totalLiabilitiesUsd;
    return Column(
      key: StakingProofOfReservesPage.overviewKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          key: StakingProofOfReservesPage.reserveStatusKey,
          label: 'Overall Reserve Status',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.large,
              density: VitDensity.compact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _SmallMetric(
                          label: 'Total Assets (USD)',
                          value: EarnFormatters.usd(overall.totalAssetsUsd),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                      Expanded(
                        child: _SmallMetric(
                          label: 'Reserve Ratio',
                          value: '${overall.reserveRatio.toStringAsFixed(1)}%',
                          color: AppColors.buy,
                          alignEnd: true,
                          suffix: '>= 100%',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Center(child: _ReserveProgress(ratio: overall.reserveRatio)),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Row(
                    children: [
                      Expanded(
                        child: _InnerMetric(
                          label: 'User Liabilities',
                          value: EarnFormatters.usd(
                            overall.totalLiabilitiesUsd,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: _InnerMetric(
                          label: 'Surplus',
                          value: EarnFormatters.usd(surplus),
                          valueColor: AppColors.buy,
                          subtleBuy: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Text(
                    'Last updated: ${overall.lastUpdated} - Live data',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          key: StakingProofOfReservesPage.trendKey,
          label: 'Reserve Ratio Trend (12 Months)',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.large,
              padding: EarnSpacingTokens.earnPaddingX3,
              child: Column(
                children: [
                  SizedBox(
                    height: _reserveTrendChartExtent,
                    child: CustomPaint(
                      painter: _ReserveTrendPainter(snapshot.history),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.trending_up_rounded,
                        color: AppColors.buy,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Text(
                        '+1.7% YoY',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                      const SizedBox(
                        width: AppSpacing.x1,
                        height: AppSpacing.x1,
                        child: Material(
                          color: AppColors.borderSolid,
                          shape: CircleBorder(),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                      Text(
                        'Always >= 100%',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          key: StakingProofOfReservesPage.auditsKey,
          label: 'Third-Party Audit Reports',
          accentColor: AppColors.primarySoft,
          children: [
            for (final report in snapshot.auditReports)
              _AuditReportCard(report: report),
          ],
        ),
      ],
    );
  }
}

class _AuditReportCard extends StatelessWidget {
  const _AuditReportCard({required this.report});

  final StakingReserveAuditReportDraft report;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.auditor, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      report.dateLabel,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              VitAccentPill(
                label: report.status,
                accentColor: AppColors.buy,
                semanticStatus: VitStatusPillStatus.success,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            report.findings,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.buttonCompact,
            onPressed: () {
              unawaited(HapticFeedback.selectionClick());
              unawaited(
                showVitNoticeSheet(
                  context: context,
                  title: 'Sẽ sớm ra mắt',
                  message: 'Tải báo cáo (PDF) sẽ sớm ra mắt',
                ),
              );
            },
            leading: const Icon(Icons.open_in_new_rounded),
            child: const Text('Download Report (PDF)'),
          ),
        ],
      ),
    );
  }
}
