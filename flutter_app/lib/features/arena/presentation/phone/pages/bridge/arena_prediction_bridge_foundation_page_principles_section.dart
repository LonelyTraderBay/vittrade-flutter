part of 'arena_prediction_bridge_foundation_page.dart';

class _ArenaPredictionBridgeFoundationPageState
    extends ConsumerState<ArenaPredictionBridgeFoundationPage> {
  _BridgeSection _activeSection = _BridgeSection.principles;
  String? _selectedTopicId;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(arenaPredictionBridgeSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollEndPadding =
        navClearance +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? AppSpacing.x6 : AppSpacing.x4);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Nền tảng kết nối Arena và Dự đoán - nguyên tắc, ranh giới và ví dụ an toàn',
      semanticIdentifier: 'SC-207',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Bridge Foundation',
            subtitle: 'Kết nối · Prediction - Arena',
            showBack: true,
            onBack: () => _close(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: ArenaPredictionBridgeFoundationPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      scrollEndPadding,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được Bridge Foundation',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              arenaPredictionBridgeSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          const _BridgeHero(),
                          _SectionTabs(
                            active: _activeSection,
                            onChanged: (section) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _activeSection = section);
                            },
                          ),
                          _ActiveSection(
                            section: _activeSection,
                            snapshot: snapshot,
                            selectedTopicId: _selectedTopicId,
                            onTopicSelected: (id) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() {
                                _selectedTopicId = _selectedTopicId == id
                                    ? null
                                    : id;
                              });
                            },
                            onPredictionTap: () =>
                                _go(context, AppRoutePaths.profilePredictions),
                            onArenaTap: () =>
                                _go(context, AppRoutePaths.profileArena),
                          ),
                          _DisclosureFooter(text: snapshot.footerDisclosure),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context, String route) {
    unawaited(HapticFeedback.selectionClick());
    context.go(route);
  }

  void _close(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _BridgeHero extends StatelessWidget {
  const _BridgeHero();

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.link_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '09A - Arena × Predictions Bridge Foundation',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                    height: _bridgeHeroLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'Nền tảng bridge an toàn: chỉ topic/context — điểm Arena và ví Prediction tách biệt.',
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

class _SectionTabs extends StatelessWidget {
  const _SectionTabs({required this.active, required this.onChanged});

  final _BridgeSection active;
  final ValueChanged<_BridgeSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitScrollableTabHeader.pillRow(
      headerKey: ArenaPredictionBridgeFoundationPage.tabsKey,
      items: [
        for (final config in _sectionConfigs)
          VitStatusPill(
            key: ArenaPredictionBridgeFoundationPage.tabKey(config.id),
            label: config.label,
            icon: config.icon,
            status: config.section == active
                ? VitStatusPillStatus.info
                : VitStatusPillStatus.neutral,
            size: VitStatusPillSize.md,
            outline: config.section != active,
            onTap: () => onChanged(config.section),
          ),
      ],
    );
  }
}

class _ActiveSection extends StatelessWidget {
  const _ActiveSection({
    required this.section,
    required this.snapshot,
    required this.selectedTopicId,
    required this.onTopicSelected,
    required this.onPredictionTap,
    required this.onArenaTap,
  });

  final _BridgeSection section;
  final ArenaPredictionBridgeSnapshot snapshot;
  final String? selectedTopicId;
  final ValueChanged<String> onTopicSelected;
  final VoidCallback onPredictionTap;
  final VoidCallback onArenaTap;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      _BridgeSection.principles => _PrinciplesSection(snapshot: snapshot),
      _BridgeSection.topics => _TopicsSection(
        snapshot: snapshot,
        selectedTopicId: selectedTopicId,
        onTopicSelected: onTopicSelected,
      ),
      _BridgeSection.boundary => _BoundarySection(snapshot: snapshot),
      _BridgeSection.bridge => _BridgeComponentsSection(
        snapshot: snapshot,
        onPredictionTap: onPredictionTap,
        onArenaTap: onArenaTap,
      ),
      _BridgeSection.examples => _ExamplesSection(snapshot: snapshot),
    };
  }
}

class _PrinciplesSection extends StatelessWidget {
  const _PrinciplesSection({required this.snapshot});

  final ArenaPredictionBridgeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: '1 - Cross-Module Principles',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [
        Text(
          '6 nguyên tắc bắt buộc khi kết nối Arena - Prediction Markets. Vi phạm = reject trong code review.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: _bridgeIntroLineHeight,
          ),
        ),
        for (final principle in snapshot.principles)
          _PrincipleCard(principle: principle),
        VitPageSection(
          label: 'Allowed vs Not Allowed',
          accentColor: AppColors.buy,
          density: VitDensity.compact,
          children: [
            _RuleBoard(
              title: 'Allowed',
              icon: Icons.check_rounded,
              color: AppColors.buy,
              items: snapshot.allowedItems,
            ),
            _RuleBoard(
              title: 'Not Allowed',
              icon: Icons.close_rounded,
              color: AppColors.sell,
              items: snapshot.notAllowedItems,
            ),
          ],
        ),
      ],
    );
  }
}

class _PrincipleCard extends StatelessWidget {
  const _PrincipleCard({required this.principle});

  final ArenaBridgePrincipleDraft principle;

  @override
  Widget build(BuildContext context) {
    final tone = _toneColor(principle.tone);
    return VitCard(
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToneIcon(tone: principle.tone),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          ArenaSpacingTokens.arenaBridgePrincipleNumberPadding,
                      child: Text(
                        '#${principle.number}',
                        style: AppTextStyles.micro.copyWith(
                          color: tone,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        principle.title,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height: _bridgeTitleLineHeight,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  principle.description,
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

class _RuleBoard extends StatelessWidget {
  const _RuleBoard({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<ArenaBridgeRuleDraft> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: color.withValues(alpha: .25),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: ArenaSpacingTokens.arenaBridgeChipIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final item in items) ...[
            _RuleRow(item: item, color: color),
            if (item != items.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.item, required this.color});

  final ArenaBridgeRuleDraft item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          item.allowed ? Icons.check_rounded : Icons.close_rounded,
          color: color,
          size: ArenaSpacingTokens.arenaBridgeMicroIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: _bridgeMetricLineHeight,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: _bridgeBodyLineHeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
