part of '../../phone/pages/safety/safety_education_page.dart';

class _SafetyTabs extends StatelessWidget {
  const _SafetyTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeSafetyTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedTabBar(
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            widgetKey: SafetyEducationPage.tabKey(tab.id),
          ),
      ],
      activeKey: activeId,
      onChanged: onChanged,
    );
  }
}

class _ScamsTab extends StatelessWidget {
  const _ScamsTab({
    required this.scams,
    required this.expandedId,
    required this.onToggle,
  });

  final List<TradeSafetyScamType> scams;
  final String? expandedId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        Text(
          '${scams.length} loại scam phổ biến trong copy trading. Tap để xem chi tiết.',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        for (final scam in scams)
          _ScamCard(
            scam: scam,
            expanded: expandedId == scam.id,
            onTap: () => onToggle(scam.id),
          ),
      ],
    );
  }
}

class _ScamCard extends StatelessWidget {
  const _ScamCard({
    required this.scam,
    required this.expanded,
    required this.onTap,
  });

  final TradeSafetyScamType scam;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      borderColor: AppColors.cardBorder,
      density: VitDensity.tool,
      child: Column(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            key: SafetyEducationPage.scamKey(scam.id),
            onTap: onTap,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.tight,
            constraints: const BoxConstraints(
              minHeight: TradeSpacingTokens.tradeBotControlTall,
            ),
            density: VitDensity.tool,
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.sell,
                  size: TradeSpacingTokens.tradeBotActionIcon,
                ),
                const SizedBox(width: TradeSpacingTokens.tradeBotRowGap),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scam.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        scam.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: TradeSpacingTokens.tradeBotDisclosureGap),
                AnimatedRotation(
                  turns: expanded ? .5 : 0,
                  duration: const Duration(milliseconds: 120),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: TradeSpacingTokens.tradeBotMediumIcon,
                  ),
                ),
              ],
            ),
          ),
          if (expanded)
            _ScamExpandedContent(
              examples: scam.examples,
              howToAvoid: scam.howToAvoid,
            ),
        ],
      ),
    );
  }
}

class _ScamExpandedContent extends StatelessWidget {
  const _ScamExpandedContent({
    required this.examples,
    required this.howToAvoid,
  });

  final List<String> examples;
  final List<String> howToAvoid;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      width: double.infinity,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ExpandedList(
            title: 'Ví dụ:',
            items: examples,
            color: AppColors.text3,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _ExpandedList(
            title: 'Cách tránh:',
            items: howToAvoid,
            color: AppColors.buy,
            bullet: '✓',
          ),
        ],
      ),
    );
  }
}

class _ExpandedList extends StatelessWidget {
  const _ExpandedList({
    required this.title,
    required this.items,
    required this.color,
    this.bullet = '•',
  });

  final String title;
  final List<String> items;
  final Color color;
  final String bullet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        for (final item in items) ...[
          Text(
            '$bullet $item',
            style: AppTextStyles.micro.copyWith(color: color),
          ),
          if (item != items.last) const SizedBox(height: AppSpacing.x1),
        ],
      ],
    );
  }
}

class _RedFlagsTab extends StatelessWidget {
  const _RedFlagsTab({required this.flags});

  final List<TradeSafetyRedFlag> flags;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        Text(
          'Checklist để đánh giá provider trước khi copy. Nếu có ≥2 red flags nghiêm trọng, KHÔNG nên copy.',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        for (final severity in ['critical', 'warning', 'caution'])
          _SeveritySection(
            title: _severityTitle(severity),
            color: _severityColor(severity),
            flags: flags.where((flag) => flag.severity == severity).toList(),
          ),
      ],
    );
  }
}
