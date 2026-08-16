part of 'tax_report_center_page.dart';

class _TaxReportCenterPageState extends ConsumerState<TaxReportCenterPage> {
  TaxReportTab _activeTab = TaxReportTab.generate;
  TaxExportFormat _format = TaxExportFormat.pdf;
  String _jurisdictionId = 'us';
  String _startDate = '01/01/2024';
  String _endDate = '12/31/2024';
  bool _includeArena = false;
  bool _exportQueued = false;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(taxReportControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;

    return controllerAsync.when(
      loading: () => CrossModuleTabbedPageShell(
        semanticLabel: 'Trung tâm báo cáo thuế',
        semanticIdentifier: 'SC-324',
        contentKey: TaxReportCenterPage.contentKey,
        title: 'Tax Report Center',
        onBack: () => context.go(AppRoutePaths.home),
        scrollEndClearance: scrollEndClearance,
        tabs: const SizedBox.shrink(),
        contentGap: VitContentGap.tight,
        body: const VitSkeletonList(),
      ),
      error: (error, stackTrace) => CrossModuleTabbedPageShell(
        semanticLabel: 'Trung tâm báo cáo thuế',
        semanticIdentifier: 'SC-324',
        contentKey: TaxReportCenterPage.contentKey,
        title: 'Tax Report Center',
        onBack: () => context.go(AppRoutePaths.home),
        scrollEndClearance: scrollEndClearance,
        tabs: const SizedBox.shrink(),
        contentGap: VitContentGap.tight,
        body: VitErrorState(
          title: 'Tax Report Center',
          message: 'Không tải được dữ liệu.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(taxReportSnapshotProvider),
        ),
      ),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        return CrossModuleTabbedPageShell(
          semanticLabel: 'Trung tâm báo cáo thuế',
          semanticIdentifier: 'SC-324',
          contentKey: TaxReportCenterPage.contentKey,
          title: snapshot.title,
          onBack: () => context.go(snapshot.backRoute),
          scrollEndClearance: scrollEndClearance,
          tabs: _TaxTabs(
            tabs: snapshot.tabs,
            active: _activeTab,
            onChanged: (tab) {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _activeTab = tab);
            },
          ),
          contentGap: VitContentGap.tight,
          body: _activeTab == TaxReportTab.generate
              ? _GenerateTaxReportTab(
                  snapshot: snapshot,
                  startDate: _startDate,
                  endDate: _endDate,
                  format: _format,
                  jurisdictionId: _jurisdictionId,
                  exportQueued: _exportQueued,
                  onPresetSelected: (start, end) {
                    unawaited(HapticFeedback.selectionClick());
                    setState(() {
                      _startDate = start;
                      _endDate = end;
                    });
                  },
                  onFormatChanged: (format) {
                    unawaited(HapticFeedback.selectionClick());
                    setState(() => _format = format);
                  },
                  onJurisdictionChanged: (id) {
                    unawaited(HapticFeedback.selectionClick());
                    setState(() => _jurisdictionId = id);
                  },
                  onGenerate: () {
                    unawaited(HapticFeedback.mediumImpact());
                    setState(() => _exportQueued = true);
                  },
                )
              : _activeTab == TaxReportTab.reports
              ? _ReportsTab(snapshot: snapshot)
              : _TaxSettingsTab(
                  includeArena: _includeArena,
                  onToggleArena: () {
                    unawaited(HapticFeedback.selectionClick());
                    setState(() => _includeArena = !_includeArena);
                  },
                ),
        );
      },
    );
  }
}

class _TaxTabs extends StatelessWidget {
  const _TaxTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<TaxReportTabDraft> tabs;
  final TaxReportTab active;
  final ValueChanged<TaxReportTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabItems = [
      for (final tab in tabs)
        VitTabItem(
          key: tab.tab.name,
          label: tab.label,
          widgetKey: TaxReportCenterPage.tabKey(tab.tab),
        ),
    ];

    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface,
        shape: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: CrossModuleSpacingTokens.crossModuleTabBarPadding,
        child: VitSegmentedTabBar(
          tabs: tabItems,
          activeKey: active.name,
          onChanged: (key) {
            final selected = tabs.firstWhere((tab) => tab.tab.name == key);
            onChanged(selected.tab);
          },
        ),
      ),
    );
  }
}

class _GenerateTaxReportTab extends StatelessWidget {
  const _GenerateTaxReportTab({
    required this.snapshot,
    required this.startDate,
    required this.endDate,
    required this.format,
    required this.jurisdictionId,
    required this.exportQueued,
    required this.onPresetSelected,
    required this.onFormatChanged,
    required this.onJurisdictionChanged,
    required this.onGenerate,
  });

  final TaxReportSnapshot snapshot;
  final String startDate;
  final String endDate;
  final TaxExportFormat format;
  final String jurisdictionId;
  final bool exportQueued;
  final void Function(String startDate, String endDate) onPresetSelected;
  final ValueChanged<TaxExportFormat> onFormatChanged;
  final ValueChanged<String> onJurisdictionChanged;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    final jurisdiction = snapshot.jurisdictions.firstWhere(
      (item) => item.id == jurisdictionId,
      orElse: () => snapshot.jurisdictions.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TaxSummaryCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _TaxPeriodCard(
          startDate: startDate,
          endDate: endDate,
          onPresetSelected: onPresetSelected,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPageSection(
          label: 'Module Breakdown',
          children: [
            for (final activity in snapshot.activities)
              _TaxActivityCard(activity: activity),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _ExportFormatCard(selected: format, onChanged: onFormatChanged),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _JurisdictionCard(
          jurisdiction: jurisdiction,
          jurisdictions: snapshot.jurisdictions,
          onChanged: onJurisdictionChanged,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _GenerateReportButton(
          format: format,
          queued: exportQueued,
          onTap: onGenerate,
        ),
        if (exportQueued) ...[
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const CrossModuleInfoPanel(
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            border: AppColors.buy20,
            text:
                'Export request queued locally. Production wiring will post to /exports with the selected period and format.',
          ),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const CrossModuleInfoPanel(
          icon: Icons.warning_amber_rounded,
          color: AppColors.warn,
          border: AppColors.warn15,
          text:
              'Tax reports are for reference only. Consult a tax professional for accurate filing. We are not tax advisors.',
        ),
      ],
    );
  }
}

class _TaxSummaryCard extends StatelessWidget {
  const _TaxSummaryCard({required this.snapshot});

  final TaxReportSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CrossModuleIconBadge(
                icon: Icons.description_outlined,
                color: AppColors.buy,
                background: AppColors.buy10,
                size: AppSpacing.inputHeight,
                iconSize: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tax Summary',
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'All taxable activities',
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
                child: _MetricBlock(
                  label: 'Total Gain/Loss',
                  value: _formatMoney(snapshot.totalGainLoss),
                  valueColor: AppColors.buy,
                ),
              ),
              Expanded(
                child: _MetricBlock(
                  label: 'Transactions',
                  value: _formatInteger(snapshot.totalTransactions),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _MetricBlock(
                  label: 'Taxable Modules',
                  value: '${snapshot.taxableModules}',
                  compact: true,
                ),
              ),
              Expanded(
                child: _MetricBlock(
                  label: 'Reports Generated',
                  value: '${snapshot.reports.length}',
                  compact: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.compact = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          value,
          style:
              (compact ? AppTextStyles.baseMedium : AppTextStyles.sectionTitle)
                  .copyWith(
                    color: valueColor,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
        ),
      ],
    );
  }
}

class _TaxPeriodCard extends StatelessWidget {
  const _TaxPeriodCard({
    required this.startDate,
    required this.endDate,
    required this.onPresetSelected,
  });

  final String startDate;
  final String endDate;
  final void Function(String startDate, String endDate) onPresetSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tax Period',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _DateField(label: 'Start Date', value: startDate),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _DateField(label: 'End Date', value: endDate),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              _PresetButton(
                label: '2024',
                onTap: () => onPresetSelected('01/01/2024', '12/31/2024'),
              ),
              const SizedBox(width: AppSpacing.x3),
              _PresetButton(
                label: 'Q4 2024',
                onTap: () => onPresetSelected('10/01/2024', '12/31/2024'),
              ),
              const SizedBox(width: AppSpacing.x3),
              _PresetButton(
                label: 'YTD',
                onTap: () => onPresetSelected('01/01/2024', '05/25/2026'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        DecoratedBox(
          decoration: const ShapeDecoration(
            color: AppColors.bg,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
          ),
          child: Padding(
            padding: CrossModuleSpacingTokens.crossModuleSelectorPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: AppSpacing.iconSm,
                  color: AppColors.text3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
