part of '../phone/pages/topic_hub_page.dart';

class _TopicRail extends StatelessWidget {
  const _TopicRail({
    required this.topics,
    required this.selectedTopicId,
    required this.onSelect,
  });

  final List<DiscoveryTopicDraft> topics;
  final String selectedTopicId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          key: TopicHubPage.topicRailKey,
          scrollDirection: Axis.horizontal,
          padding: LaunchpadSpacingTokens.discoveryRailPadding,
          child: Row(
            children: [
              for (final topic in topics) ...[
                _TopicChip(
                  topic: topic,
                  active: topic.id == selectedTopicId,
                  onTap: () => onSelect(topic.id),
                ),
                const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ),
        const Divider(
          height: AppSpacing.dividerHairline,
          thickness: AppSpacing.dividerHairline,
          color: AppColors.divider,
        ),
      ],
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.topic,
    required this.active,
    required this.onTap,
  });

  final DiscoveryTopicDraft topic;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForTopic(topic);
    return VitChoicePill(
      key: TopicHubPage.topicKey(topic.id),
      label: topic.label,
      selected: active,
      onTap: onTap,
      accentColor: accent,
      height: AppSpacing.buttonCompact + AppSpacing.x2,
      padding: LaunchpadSpacingTokens.discoveryChipHorizontalPadding,
    );
  }
}

List<Widget> _topicHubPageChildren({
  required TopicHubSnapshot snapshot,
  required VoidCallback onRetry,
}) {
  return switch (snapshot.currentState) {
    DiscoveryScreenState.loading => [
      const VitSkeletonList(key: TopicHubPage.loadingKey, rows: 5),
    ],
    DiscoveryScreenState.error => [
      VitErrorState(
        key: TopicHubPage.errorKey,
        title: 'Không tải được chủ đề',
        message: snapshot.staleMessage,
        actionLabel: 'Thử lại',
        onAction: onRetry,
      ),
    ],
    DiscoveryScreenState.empty when !snapshot.hasContent => [
      _TopicHero(snapshot: snapshot),
      VitEmptyState(
        title: 'Chưa có nội dung cho ${snapshot.selectedTopic.label}',
        message: 'Hãy quay lại sau hoặc chọn chủ đề khác',
        icon: Icons.search_rounded,
      ),
    ],
    _ => _topicHubReadySections(snapshot),
  };
}

List<Widget> _topicHubReadySections(TopicHubSnapshot snapshot) {
  return [
    _TopicHero(snapshot: snapshot),
    _PredictionSection(snapshot: snapshot),
    _ArenaRoomsSection(snapshot: snapshot),
    _ModesSection(snapshot: snapshot),
    _CreatorsSection(snapshot: snapshot),
    _CreateRoomCard(snapshot: snapshot),
    _DisclosureCard(notes: snapshot.contractNotes),
  ];
}

class _TopicHero extends StatelessWidget {
  const _TopicHero({required this.snapshot});

  final TopicHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final topic = snapshot.selectedTopic;
    final accent = _accentForTopic(topic);
    return VitCard(
      key: TopicHubPage.heroKey,
      variant: VitCardVariant.inner,
      padding: LaunchpadSpacingTokens.discoveryCardPadding,
      borderColor: accent.withValues(alpha: .22),
      child: Column(
        children: [
          Row(
            children: [
              VitAccentIconBox(icon: _iconForTopic(topic), color: accent),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topic.label, style: AppTextStyles.pageTitle),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      topic.summary,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
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
                child: _HeroStat(
                  value: snapshot.predictions.length,
                  label: 'Sự kiện',
                  color: AppModuleAccents.predictions,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  value: snapshot.arenaRooms.length,
                  label: 'Phòng',
                  color: AppModuleAccents.arena,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  value: snapshot.arenaModes.length,
                  label: 'Chế độ',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  value: snapshot.creators.length,
                  label: 'Nhà sáng tạo',
                  color: AppModuleAccents.markets,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.discoveryHeroStatPadding,
        child: Column(
          children: [
            Text(
              '$value',
              style: AppTextStyles.base.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}
