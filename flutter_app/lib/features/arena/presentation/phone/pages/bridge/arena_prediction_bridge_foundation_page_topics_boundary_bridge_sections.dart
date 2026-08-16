part of 'arena_prediction_bridge_foundation_page.dart';

class _TopicsSection extends StatelessWidget {
  const _TopicsSection({
    required this.snapshot,
    required this.selectedTopicId,
    required this.onTopicSelected,
  });

  final ArenaPredictionBridgeSnapshot snapshot;
  final String? selectedTopicId;
  final ValueChanged<String> onTopicSelected;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: '2 - Shared Topic Taxonomy',
      accentColor: AppModuleAccents.arena,
      density: VitDensity.compact,
      children: [
        Text(
          '8 topics dùng chung cho cả Arena và Prediction Markets. Bridge chỉ qua topic, không qua value.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: _bridgeIntroLineHeight,
          ),
        ),
        VitCard(
          density: VitDensity.compact,
          child: Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final topic in snapshot.topics)
                _TopicChip(
                  topic: topic,
                  selected: selectedTopicId == topic.id,
                  onTap: () => onTopicSelected(topic.id),
                ),
            ],
          ),
        ),
        for (final topic in snapshot.topics.take(4))
          _TopicMappingCard(topic: topic),
      ],
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.topic,
    required this.selected,
    required this.onTap,
  });

  final ArenaBridgeTopicDraft topic;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      key: ArenaPredictionBridgeFoundationPage.topicKey(topic.id),
      label: topic.label,
      icon: _toneIcon(topic.tone),
      status: _toneStatus(topic.tone),
      size: VitStatusPillSize.md,
      outline: !selected,
      onTap: onTap,
    );
  }
}

class _TopicMappingCard extends StatelessWidget {
  const _TopicMappingCard({required this.topic});

  final ArenaBridgeTopicDraft topic;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InlineTitle(icon: Icons.topic_outlined, title: topic.label),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _MiniMetric(label: 'Prediction', value: topic.predictionUsage),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _MiniMetric(label: 'Arena', value: topic.arenaUsage),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _MiniMetric(label: 'Bridge', value: topic.bridgeUsage),
        ],
      ),
    );
  }
}

class _BoundarySection extends StatelessWidget {
  const _BoundarySection({required this.snapshot});

  final ArenaPredictionBridgeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: '3 - Module Boundary Components',
      accentColor: AppColors.sell,
      density: VitDensity.compact,
      children: [
        Text(
          'Banner, badge và info row bắt buộc khi hiển thị content cross-module.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: _bridgeIntroLineHeight,
          ),
        ),
        for (final banner in snapshot.boundaryBanners)
          _BoundaryBanner(banner: banner),
        VitCard(
          density: VitDensity.compact,
          child: Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final badge in snapshot.badges)
                _bridgeBadge(label: badge.label, tone: badge.tone),
            ],
          ),
        ),
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              for (final row in snapshot.infoRows) ...[
                _InfoRow(text: row.text, tone: row.tone),
                if (row != snapshot.infoRows.last)
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _BoundaryBanner extends StatelessWidget {
  const _BoundaryBanner({required this.banner});

  final ArenaBridgeBoundaryDraft banner;

  @override
  Widget build(BuildContext context) {
    final tone = _toneColor(banner.tone);
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: tone.withValues(alpha: .22),
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToneIcon(tone: banner.tone, small: true),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner.title,
                  style: AppTextStyles.micro.copyWith(
                    color: tone,
                    fontWeight: AppTextStyles.bold,
                    letterSpacing: ArenaSpacingTokens.arenaBridgeLetterSpacing,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  banner.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: _bridgeBodyLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BridgeComponentsSection extends StatelessWidget {
  const _BridgeComponentsSection({
    required this.snapshot,
    required this.onPredictionTap,
    required this.onArenaTap,
  });

  final ArenaPredictionBridgeSnapshot snapshot;
  final VoidCallback onPredictionTap;
  final VoidCallback onArenaTap;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: '4 - Bridge Components',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [
        Text(
          '4 reusable bridge components. Mỗi component đều có mandatory disclosure badge.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: _bridgeIntroLineHeight,
          ),
        ),
        for (final component in snapshot.bridgeComponents)
          _ComponentDemoCard(component: component),
        _DualStatsCard(
          stats: snapshot.dualStats,
          onPredictionTap: onPredictionTap,
          onArenaTap: onArenaTap,
        ),
      ],
    );
  }
}

class _ComponentDemoCard extends StatelessWidget {
  const _ComponentDemoCard({required this.component});

  final ArenaBridgeComponentDraft component;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  component.name,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _bridgeBadge(label: component.badgeLabel, tone: component.tone),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            component.description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _bridgeBodyLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _DemoFrame(
            title: component.sampleTitle,
            meta: component.sampleMeta,
            tone: component.tone,
          ),
        ],
      ),
    );
  }
}

class _DualStatsCard extends StatelessWidget {
  const _DualStatsCard({
    required this.stats,
    required this.onPredictionTap,
    required this.onArenaTap,
  });

  final ArenaBridgeDualStatsDraft stats;
  final VoidCallback onPredictionTap;
  final VoidCallback onArenaTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary.withValues(alpha: .24),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _InlineTitle(
            icon: Icons.account_tree_outlined,
            title: 'DualModuleStatCard - separated profile blocks',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _ModuleStatButton(
                  key: ArenaPredictionBridgeFoundationPage.predictionProfileKey,
                  label: 'Prediction',
                  value: '${stats.predictionPositions} positions',
                  detail: stats.predictionPnlLabel,
                  tone: ArenaBridgeTone.prediction,
                  onTap: onPredictionTap,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _ModuleStatButton(
                  key: ArenaPredictionBridgeFoundationPage.arenaProfileKey,
                  label: 'Open Arena',
                  value: stats.arenaPointsLabel,
                  detail: '${stats.arenaRooms} rooms',
                  tone: ArenaBridgeTone.arena,
                  onTap: onArenaTap,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const _InfoRow(
            text: 'Hai khối stats mở hai module riêng. Không tổng hợp số liệu.',
            tone: ArenaBridgeTone.disclosure,
          ),
        ],
      ),
    );
  }
}

class _ModuleStatButton extends StatelessWidget {
  const _ModuleStatButton({
    super.key,
    required this.label,
    required this.value,
    required this.detail,
    required this.tone,
    required this.onTap,
  });

  final String label;
  final String value;
  final String detail;
  final ArenaBridgeTone tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tone);
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: color.withValues(alpha: .06),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
              side: BorderSide(color: color.withValues(alpha: .20)),
            ),
          ),
          child: Padding(
            padding: VitDensity.compact.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _toneIcon(tone),
                  color: color,
                  size: ArenaSpacingTokens.arenaBridgeActionIcon,
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExamplesSection extends StatelessWidget {
  const _ExamplesSection({required this.snapshot});

  final ArenaPredictionBridgeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: '5 - Example Usage Frames',
      accentColor: AppColors.buy,
      density: VitDensity.compact,
      children: [
        Text(
          '4 frame demo: A-C là đúng cách, D là sai cách.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: _bridgeIntroLineHeight,
          ),
        ),
        for (final example in snapshot.examples) _ExampleCard(example: example),
      ],
    );
  }
}
