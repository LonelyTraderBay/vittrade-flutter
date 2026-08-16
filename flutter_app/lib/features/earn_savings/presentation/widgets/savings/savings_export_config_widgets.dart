part of '../../phone/pages/savings/savings_export_page.dart';

class _ExportHero extends StatelessWidget {
  const _ExportHero({required this.snapshot});

  final SavingsExportSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsExportPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.file_download_outlined,
                color: AppModuleAccents.earn,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.heroLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng báo cáo đã tạo',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      '${snapshot.createdReports}',
                      style: AppTextStyles.amountLg,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Loại báo cáo',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  Text(
                    snapshot.reportTypeCountLabel,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppModuleAccents.earn,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _HeroPill(
                  label: 'Định dạng',
                  value: snapshot.formatSummary,
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroPill(
                  label: 'Lưu trữ',
                  value: snapshot.retentionLabel,
                  color: AppModuleAccents.earn,
                  icon: Icons.shield_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({
    required this.label,
    required this.value,
    required this.color,
    this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: color, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x1),
              ],
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _captionBold.copyWith(color: color),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExportTabs extends StatelessWidget {
  const _ExportTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: active,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            icon: tab.id == 'create'
                ? Icons.note_add_outlined
                : Icons.history_rounded,
          ),
      ],
    );
  }
}

class _ReportTypeList extends StatelessWidget {
  const _ReportTypeList({
    required this.reports,
    required this.selected,
    required this.onChanged,
  });

  final List<SavingsExportReportDraft> reports;
  final SavingsExportReportType selected;
  final ValueChanged<SavingsExportReportType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsExportPage.reportTypesKey,
      children: [
        for (final report in reports) ...[
          _ReportTypeCard(
            report: report,
            selected: report.id == selected,
            onTap: () => onChanged(report.id),
          ),
          if (report != reports.last) const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _ReportTypeCard extends StatelessWidget {
  const _ReportTypeCard({
    required this.report,
    required this.selected,
    required this.onTap,
  });

  final SavingsExportReportDraft report;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppModuleAccents.earn : AppColors.text3;

    return VitCard(
      key: SavingsExportPage.reportTypeKey(report.id),
      variant: selected ? VitCardVariant.inner : VitCardVariant.standard,
      radius: VitCardRadius.large,
      borderColor: selected ? AppModuleAccents.earn : AppColors.cardBorder,
      onTap: onTap,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        children: [
          _RoundIcon(icon: _iconFor(report.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.title,
                  style: AppTextStyles.body.copyWith(
                    color: selected ? AppColors.text1 : AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  report.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: EarnSpacingTokens.earnExportDescriptionLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  report.rowsLabel,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _SelectionDot(selected: selected, color: color),
        ],
      ),
    );
  }
}
