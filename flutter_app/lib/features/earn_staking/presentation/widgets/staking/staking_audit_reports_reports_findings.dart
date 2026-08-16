part of '../../phone/pages/staking/staking_audit_reports_page.dart';

class _ReportList extends StatelessWidget {
  const _ReportList({
    required this.reports,
    required this.onDownload,
    required this.onView,
  });

  final List<StakingAuditReportDraft> reports;
  final ValueChanged<StakingAuditReportDraft> onDownload;
  final ValueChanged<StakingAuditReportDraft> onView;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingAuditReportsPage.reportsListKey,
      children: [
        for (final report in reports) ...[
          _ReportCard(
            key: StakingAuditReportsPage.reportKey(report.id),
            report: report,
            onDownload: () => onDownload(report),
            onView: () => onView(report),
          ),
          if (report != reports.last) const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    super.key,
    required this.report,
    required this.onDownload,
    required this.onView,
  });

  final StakingAuditReportDraft report;
  final VoidCallback onDownload;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final typeColor = _reportTypeColor(report.type);
    final isPublished = report.status == StakingAuditReportStatus.published;

    return Opacity(
      opacity: isPublished ? 1 : 0.78,
      child: VitCard(
        radius: VitCardRadius.large,
        padding: EarnSpacingTokens.earnCardPaddingX4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RoundIcon(icon: Icons.description_outlined, color: typeColor),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              report.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.baseMedium,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x2),
                          Icon(
                            isPublished
                                ? Icons.check_circle_outline_rounded
                                : Icons.schedule_rounded,
                            color: isPublished ? AppColors.buy : AppColors.warn,
                            size: AppSpacing.iconSm,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        'By ${report.auditor} \u2022 ${report.dateLabel}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _SmallPill(
                          label: _reportTypeLabel(report.type),
                          color: typeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            Text(
              report.summary,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: EarnSpacingTokens.stakingAuditBodyLineHeight,
              ),
            ),
            if (isPublished && report.findings.resolvedFindings > 0) ...[
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              _FindingsSummary(findings: report.findings),
            ],
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            _ScopeList(scope: report.scope),
            if (isPublished && report.pdfUrl != null) ...[
              const SizedBox(height: AppSpacing.rowGap),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      key: StakingAuditReportsPage.downloadButtonKey(report.id),
                      label: 'Download PDF',
                      icon: Icons.download_rounded,
                      primary: true,
                      onTap: onDownload,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _ActionButton(
                      key: StakingAuditReportsPage.viewButtonKey(report.id),
                      label: 'View',
                      icon: Icons.open_in_new_rounded,
                      primary: false,
                      onTap: onView,
                    ),
                  ),
                ],
              ),
            ],
            if (!isPublished) ...[
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              _ProgressNote(report: report),
            ],
          ],
        ),
      ),
    );
  }
}

class _FindingsSummary extends StatelessWidget {
  const _FindingsSummary({required this.findings});

  final StakingAuditFindingsDraft findings;

  @override
  Widget build(BuildContext context) {
    final items = [
      _FindingItem('Critical', findings.critical, AppColors.sell),
      _FindingItem('High', findings.high, AppColors.warn),
      _FindingItem('Medium', findings.medium, AppColors.primarySoft),
      _FindingItem('Low', findings.low, AppColors.primary),
      _FindingItem('Info', findings.informational, AppColors.text3),
    ];

    return VitCard(
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Findings Summary',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(children: [for (final item in items) Expanded(child: item)]),
        ],
      ),
    );
  }
}

class _FindingItem extends StatelessWidget {
  const _FindingItem(this.label, this.value, this.color);

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$value', style: AppTextStyles.baseMedium.copyWith(color: color)),
        const SizedBox(height: AppSpacing.x1),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _ScopeList extends StatelessWidget {
  const _ScopeList({required this.scope});

  final List<String> scope;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scope',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final item in scope)
              _SmallPill(label: item, color: AppColors.text2),
          ],
        ),
      ],
    );
  }
}

class _ProgressNote extends StatelessWidget {
  const _ProgressNote({required this.report});

  final StakingAuditReportDraft report;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Audit in progress - Expected: ${report.dateLabel}',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
