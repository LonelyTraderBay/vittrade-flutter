part of '../../phone/pages/event/prediction_event_detail_page.dart';

class _DetailTabs extends StatelessWidget {
  const _DetailTabs({required this.activeTab, required this.onChanged});

  final _DetailTab activeTab;
  final ValueChanged<_DetailTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.cardRadius,
      child: Padding(
        padding: PredictionsSpacingTokens.predictionDetailTabsPadding,
        child: VitTabBar(
          variant: VitTabBarVariant.segment,
          activeKey: activeTab.name,
          onChanged: (key) => onChanged(_DetailTab.values.byName(key)),
          tabs: const [
            VitTabItem(
              key: 'rules',
              label: 'Rules',
              widgetKey: PredictionEventDetailPage.rulesTabKey,
            ),
            VitTabItem(
              key: 'comments',
              label: 'Comments',
              widgetKey: PredictionEventDetailPage.commentsTabKey,
            ),
            VitTabItem(
              key: 'holders',
              label: 'Top Holders',
              widgetKey: PredictionEventDetailPage.holdersTabKey,
            ),
            VitTabItem(
              key: 'activity',
              label: 'Activity',
              widgetKey: PredictionEventDetailPage.activityTabKey,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabCard extends StatelessWidget {
  const _TabCard({required this.snapshot, required this.activeTab});

  final PredictionEventDetailSnapshot snapshot;
  final _DetailTab activeTab;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: switch (activeTab) {
        _DetailTab.rules => _RulesContent(snapshot: snapshot),
        _DetailTab.comments => const _CommentsContent(),
        _DetailTab.holders => _HoldersContent(snapshot: snapshot),
        _DetailTab.activity => _ActivityContent(snapshot: snapshot),
      },
    );
  }
}

class _RulesContent extends StatelessWidget {
  const _RulesContent({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _InfoBlock(
          icon: Icons.menu_book_rounded,
          title: 'Description',
          text:
              'This market will resolve to "Yes" if bitcoin reaches \$150K before July 2026 before the end date. Otherwise, it resolves to "No".',
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        const _InfoBox(
          icon: Icons.verified_user_outlined,
          title: 'Resolution Source',
          text: 'CoinGecko & CoinMarketCap (average)',
          color: _predictionPrimary,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _InfoBox(
          icon: Icons.calendar_month_outlined,
          title: 'End Date',
          text: '${_formatDate(snapshot.event.endDate)} at 23:59 UTC',
          color: AppColors.warn,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Text(
          'Market Rules',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (var index = 0; index < snapshot.rules.length; index += 1) ...[
          _RuleRow(index: index, text: snapshot.rules[index]),
          if (index != snapshot.rules.length - 1)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: PredictionsSpacingTokens.predictionDetailRuleNumberWidth,
          child: Text(
            '${index + 1}.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.text2,
              size: PredictionsSpacingTokens.predictionDetailInfoIcon,
            ),
            const SizedBox(
              width: PredictionsSpacingTokens.predictionDetailInfoIconGap,
            ),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.mdRadius,
      child: Padding(
        padding: PredictionsSpacingTokens.predictionDetailInfoBoxPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: PredictionsSpacingTokens.predictionDetailInfoBoxIcon,
            ),
            const SizedBox(
              width: PredictionsSpacingTokens.predictionDetailInfoBoxGap,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    text,
                    style: AppTextStyles.caption.copyWith(color: color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
