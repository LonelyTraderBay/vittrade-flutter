part of '../../phone/pages/provider/provider_governance_page.dart';

class _GovernanceTabs extends StatelessWidget {
  const _GovernanceTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeProviderGovernanceTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x1),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeId,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs)
            VitTabItem(
              key: tab.id,
              label: tab.label,
              widgetKey: ProviderGovernancePage.tabKey(tab.id),
            ),
        ],
      ),
    );
  }
}

class _ModificationsTab extends StatelessWidget {
  const _ModificationsTab({required this.snapshot, required this.onRequest});

  final TradeProviderGovernanceSnapshot snapshot;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      fullBleed: true,
      children: [
        _Notice(text: snapshot.warning),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppSpacing.x2),
          child: Text(
            'Strategy Modification Log',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        for (final modification in snapshot.modifications)
          _ModificationCard(modification: modification),
        _RequestButton(onPressed: onRequest),
      ],
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      borderColor: _governanceWarningBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _governanceWarning,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _governanceWarning,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
