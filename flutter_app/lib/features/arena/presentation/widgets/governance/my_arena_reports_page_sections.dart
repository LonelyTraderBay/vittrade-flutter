part of '../../phone/pages/governance/my_arena_reports_page.dart';

class _ReportsSummary extends StatelessWidget {
  const _ReportsSummary({required this.summary});

  final MyArenaReportsSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return VitStatsGrid(
      radius: VitCardRadius.standard,
      padding: VitDensity.compact.cardPadding,
      gap: AppSpacing.x5,
      dividers: true,
      cells: [
        VitStatCell(
          label: 'Tổng cộng',
          value: '${summary.total}',
          valueColor: AppColors.text2,
        ),
        VitStatCell(
          label: 'Đang xử lý',
          value: '${summary.inReview}',
          valueColor: AppColors.warn,
        ),
        VitStatCell(
          label: 'Đã giải quyết',
          value: '${summary.resolved}',
          valueColor: AppColors.buy,
        ),
      ],
    );
  }
}

class _ReportsFilterRow extends StatelessWidget {
  const _ReportsFilterRow({
    required this.filters,
    required this.activeFilter,
    required this.onChanged,
  });

  final List<MyArenaReportsFilterDraft> filters;
  final String activeFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _reportsFilterExtent,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.x2),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final active = filter.id == activeFilter;
          return VitFilterChip(
            key: MyArenaReportsPage.filterKey(filter.id),
            label: filter.label,
            active: active,
            onTap: () => onChanged(filter.id),
            color: _filterColor(filter),
            count: filter.count > 0 ? filter.count : null,
            padding: ArenaSpacingTokens.myArenaReportsFilterPadding,
          );
        },
      ),
    );
  }
}

class _ProcessBanner extends StatelessWidget {
  const _ProcessBanner({required this.snapshot});

  final MyArenaReportsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ArenaSpacingTokens.myArenaReportsCardPadding,
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitAccentIconBox(
            icon: Icons.info_outline,
            color: AppColors.primary,
            boxSize: ArenaSpacingTokens.myArenaReportsIconBox,
            iconSize: ArenaSpacingTokens.myArenaReportsToneIcon,
            bordered: false,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.bannerTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.bannerDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _reportsBodyLineRatio,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportsCard extends StatelessWidget {
  const _ReportsCard({required this.reports});

  final List<ArenaReportCaseDraft> reports;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      padding: AppSpacing.zeroInsets,
      child: Column(
        children: [
          for (var index = 0; index < reports.length; index++)
            _ReportRow(
              key: MyArenaReportsPage.reportKey(reports[index].id),
              report: reports[index],
              isLast: index == reports.length - 1,
            ),
        ],
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  const _ReportRow({super.key, required this.report, required this.isLast});

  final ArenaReportCaseDraft report;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final accentColor = _targetColor(report.targetType);
    return Material(
      color: AppColors.transparent,
      child: Column(
        children: [
          VitCard(
            onTap: () {
              unawaited(HapticFeedback.selectionClick());
              context.go(AppRoutePaths.arenaReportCase(report.id));
            },
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            child: Padding(
              padding: ArenaSpacingTokens.myArenaReportsCardPadding,
              child: Row(
                children: [
                  _ReportIcon(
                    icon: _targetIcon(report.targetType),
                    color: accentColor,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                report.targetName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x2),
                            _ReportStatusPill(status: report.status),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          report.reason,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Wrap(
                          spacing: AppSpacing.x2,
                          runSpacing:
                              ArenaSpacingTokens.myArenaReportsWrapRunSpacing,
                          children: [
                            Text(
                              _targetLabel(report.targetType),
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                            Text(
                              '· Gửi ${report.createdAt}',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                            Text(
                              '· Cập nhật ${report.updatedAt}',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.text3,
                    size: ArenaSpacingTokens.myArenaReportsChevron,
                  ),
                ],
              ),
            ),
          ),
          if (!isLast)
            const Divider(
              height: _reportsDividerExtent,
              color: AppColors.divider,
            ),
        ],
      ),
    );
  }
}

class _ReportIcon extends StatelessWidget {
  const _ReportIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: ArenaSpacingTokens.myArenaReportsIconBox,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: 0.14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: ArenaSpacingTokens.myArenaReportsIcon,
          ),
        ),
      ),
    );
  }
}
