part of '../../phone/pages/hub/p2p_guide_page.dart';

class _GuideTabs extends StatelessWidget {
  const _GuideTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<P2PGuideTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: P2PGuidePage.tabsKey,
      color: AppColors.surface,
      child: Padding(
        padding: P2PSpacingTokens.p2pGuideTabsPadding,
        child: VitTabBar(
          variant: VitTabBarVariant.underline,
          activeKey: active,
          onChanged: onChanged,
          tabs: [
            for (final tab in tabs)
              VitTabItem(
                key: tab.id,
                label: tab.label,
                widgetKey: P2PGuidePage.tabKey(tab.id),
              ),
          ],
        ),
      ),
    );
  }
}

class _FaqTab extends StatelessWidget {
  const _FaqTab({
    required this.snapshot,
    required this.expandedFaqId,
    required this.onFaqToggle,
  });

  final P2PGuideSnapshot snapshot;
  final String? expandedFaqId;
  final ValueChanged<String> onFaqToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PGuidePage.faqListKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Câu hỏi thường gặp', style: AppTextStyles.baseMedium),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '${snapshot.faqItems.length} câu hỏi',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (var index = 0; index < snapshot.faqItems.length; index++) ...[
          VitFaqAccordion(
            key: P2PGuidePage.faqKey(snapshot.faqItems[index].id),
            question: snapshot.faqItems[index].question,
            answer: snapshot.faqItems[index].answer,
            expanded: snapshot.faqItems[index].id == expandedFaqId,
            onTap: () => onFaqToggle(snapshot.faqItems[index].id),
            accentColor: AppModuleAccents.p2p,
            maxAnswerLines: 3,
          ),
          if (index != snapshot.faqItems.length - 1)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}
