part of '../../phone/pages/disclosures/regulatory_disclosures_page.dart';

class _LegalTabs extends StatelessWidget {
  const _LegalTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeRegulatoryTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeId,
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.id,
              label: tab.label,
              widgetKey: RegulatoryDisclosuresPage.tabKey(tab.id),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _LegalTabBody extends StatelessWidget {
  const _LegalTabBody({
    required this.snapshot,
    required this.activeTabId,
    required this.onNotice,
  });

  final TradeRegulatoryDisclosuresSnapshot snapshot;
  final String activeTabId;
  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) {
    return switch (activeTabId) {
      'protection' => _ProtectionTab(
        protection: snapshot.protection,
        onNotice: onNotice,
      ),
      'restrictions' => _RestrictionsTab(restrictions: snapshot.restrictions),
      'liability' => _LiabilityTab(liability: snapshot.liability),
      'contact' => _ContactTab(
        contacts: snapshot.contacts,
        whistleblower: snapshot.whistleblower,
        terms: snapshot.terms,
        onNotice: onNotice,
      ),
      _ => _MifidTab(snapshot: snapshot),
    };
  }
}
