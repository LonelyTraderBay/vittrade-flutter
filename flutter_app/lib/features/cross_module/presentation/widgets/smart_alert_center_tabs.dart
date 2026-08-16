part of '../phone/pages/smart_alert_center_page.dart';

class _SmartAlertTabs extends StatelessWidget {
  const _SmartAlertTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SmartAlertTabDraft> tabs;
  final SmartAlertTab active;
  final ValueChanged<SmartAlertTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabItems = [
      for (final tab in tabs)
        VitTabItem(
          key: tab.tab.name,
          label: tab.label,
          widgetKey: SmartAlertCenterPage.tabKey(tab.tab),
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

class _ActiveAlertsTab extends StatelessWidget {
  const _ActiveAlertsTab({required this.snapshot});

  final SmartAlertsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SmartAlertSummaryCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPageSection(
          label: 'Canh bao hoat dong',
          children: [
            for (final alert in snapshot.alerts) _SmartAlertCard(alert: alert),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const _CreateAlertButton(),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const CrossModuleInfoPanel(
          icon: Icons.info_outline_rounded,
          color: AppColors.primary,
          border: AppColors.primary20,
          text:
              'Smart alerts work across all modules. Set conditions and get notified via push, email, or SMS.',
        ),
      ],
    );
  }
}

class _SmartAlertSummaryCard extends StatelessWidget {
  const _SmartAlertSummaryCard({required this.snapshot});

  final SmartAlertsSnapshot snapshot;

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
                icon: Icons.notifications_none_rounded,
                color: AppColors.primary,
                background: AppColors.primary12,
                size: AppSpacing.inputHeight,
                iconSize: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.title,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      '${snapshot.alerts.length} total alerts',
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
                child: VitMetricColumn(
                  label: 'Active',
                  value: '${snapshot.activeCount}',
                  valueColor: AppColors.buy,
                  valueStyle: VitMetricValueStyle.sectionTitle,
                ),
              ),
              Expanded(
                child: VitMetricColumn(
                  label: 'Triggered',
                  value: '${snapshot.totalTriggers}',
                  valueStyle: VitMetricValueStyle.sectionTitle,
                ),
              ),
              Expanded(
                child: VitMetricColumn(
                  label: 'Modules',
                  value: '${snapshot.moduleCount}',
                  valueStyle: VitMetricValueStyle.sectionTitle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
