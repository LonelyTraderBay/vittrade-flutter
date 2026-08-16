part of '../../phone/pages/execution/best_execution_reports_page.dart';

class _ReportActions extends StatelessWidget {
  const _ReportActions({required this.onExport, required this.onPublish});

  final VoidCallback onExport;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      borderColor: _bestBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: AppSpacing.x4,
                backgroundColor: _bestPanel2,
                child: Icon(
                  Icons.description_outlined,
                  color: _bestPrimary,
                  size: 23,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Q1 2026 Best Execution Report',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Report period: Jan 1 - Mar 31, 2026. Due date: April 15, 2026. Status: Draft.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  key: BestExecutionReportsPage.exportKey,
                  label: 'Export PDF',
                  icon: Icons.download_rounded,
                  background: _bestPanel2,
                  foreground: AppColors.text1,
                  bordered: true,
                  onTap: onExport,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _ActionButton(
                  key: BestExecutionReportsPage.publishKey,
                  label: 'Publish Report',
                  icon: Icons.open_in_new_rounded,
                  background: _bestPrimary,
                  foreground: AppColors.onAccent,
                  onTap: onPublish,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArchiveReport extends StatelessWidget {
  const _ArchiveReport({required this.reports, required this.onExport});

  final List<TradeQuarterlyReport> reports;
  final ValueChanged<String> onExport;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Historical Reports',
      density: VitDensity.tool,
      children: [
        for (final report in reports)
          VitCard(
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            borderColor: _bestBorder.withValues(alpha: .72),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: AppSpacing.x3,
                  backgroundColor: _bestPanel2,
                  child: Icon(
                    Icons.calendar_today_outlined,
                    color: _bestPrimary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${report.quarter} ${report.year}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        report.period,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                _ReportStatus(status: report.status),
                const SizedBox(width: AppSpacing.x3),
                VitInlineIconAction(
                  icon: Icons.download_rounded,
                  tooltip: 'Export report',
                  onPressed: () => onExport(report.id),
                  color: AppColors.text3,
                  size: 16,
                  padding: AppSpacing.x1,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ReportStatus extends StatelessWidget {
  const _ReportStatus({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final published = status == 'published';
    return VitStatusPill(
      label: published ? 'Published' : 'Draft',
      status: published
          ? VitStatusPillStatus.success
          : VitStatusPillStatus.neutral,
      size: VitStatusPillSize.sm,
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.bordered = false,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: bordered
          ? VitCtaButtonVariant.secondary
          : VitCtaButtonVariant.primary,
      density: VitDensity.tool,
      leading: Icon(icon, color: foreground, size: 15),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: foreground,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

String _formatInt(num value) => formatTradeInt(value.round());

String _formatUsd(double value) => formatTradeUsdWhole(value);
