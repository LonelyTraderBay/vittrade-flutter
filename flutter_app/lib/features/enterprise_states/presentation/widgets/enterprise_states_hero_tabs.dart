part of '../phone/pages/enterprise_states_page.dart';

class _SectionTabs extends StatelessWidget {
  const _SectionTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<EnterpriseTabDraft> tabs;
  final EnterpriseStateSection active;
  final ValueChanged<EnterpriseStateSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedTabBar(
      activeKey: active.name,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.section.name,
            label: tab.label,
            widgetKey: EnterpriseStatesPage.sectionKey(tab.section),
          ),
      ],
      onChanged: (key) => onChanged(_sectionFromKey(key)),
    );
  }
}
