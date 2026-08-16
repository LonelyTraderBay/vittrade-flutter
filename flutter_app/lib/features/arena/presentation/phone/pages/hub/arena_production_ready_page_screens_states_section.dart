part of 'arena_production_ready_page.dart';

class _ArenaProductionReadyPageState
    extends ConsumerState<ArenaProductionReadyPage> {
  _ProductionSection _activeSection = _ProductionSection.screens;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(arenaProductionReadySnapshotProvider);
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
          'Tổng hợp mức độ sẵn sàng phát hành Open Arena - màn hình, trạng thái và tài liệu bàn giao nội bộ',
      semanticIdentifier: 'SC-206',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Release Readiness',
            subtitle: 'Internal handoff - Open Arena',
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
                    key: ArenaProductionReadyPage.contentKey,
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
                            title: 'Không tải được Release Readiness',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              arenaProductionReadySnapshotProvider,
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          const _ProductionHero(),
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
                            onRoute: (route) => _go(context, route),
                          ),
                          _InternalOnlyFooter(text: snapshot.disclaimer),
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
    context.go(_resolvedRoute(route));
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

class _ProductionHero extends StatelessWidget {
  const _ProductionHero();

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppModuleAccents.arena,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TintIcon(
            icon: Icons.shield_outlined,
            color: AppModuleAccents.arena,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '08 - Open Arena Release Readiness',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height:
                              ArenaSpacingTokens.arenaProductionTitleLineHeight,
                        ),
                      ),
                    ),
                    const VitStatusPill(
                      label: 'INTERNAL',
                      status: VitStatusPillStatus.info,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'QA/Dev handoff pack',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: ArenaSpacingTokens.arenaProductionMetricLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Text(
                  'QA/Dev handoff — kiểm tra release Open Arena. Chỉ điểm Arena, không phải claim production end-user.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: ArenaSpacingTokens.arenaProductionBodyLineHeight,
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

  final _ProductionSection active;
  final ValueChanged<_ProductionSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitScrollableTabHeader.pillRow(
      headerKey: ArenaProductionReadyPage.tabsKey,
      items: [
        for (final config in _sectionConfigs)
          VitStatusPill(
            key: ArenaProductionReadyPage.tabKey(config.id),
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

class _SectionConfig {
  const _SectionConfig({
    required this.section,
    required this.id,
    required this.label,
    required this.icon,
  });

  final _ProductionSection section;
  final String id;
  final String label;
  final IconData icon;
}

const _sectionConfigs = [
  _SectionConfig(
    section: _ProductionSection.screens,
    id: 'screens',
    label: 'Screens',
    icon: Icons.layers_outlined,
  ),
  _SectionConfig(
    section: _ProductionSection.states,
    id: 'states',
    label: 'States',
    icon: Icons.visibility_outlined,
  ),
  _SectionConfig(
    section: _ProductionSection.flows,
    id: 'flows',
    label: 'Flows',
    icon: Icons.map_outlined,
  ),
  _SectionConfig(
    section: _ProductionSection.registry,
    id: 'registry',
    label: 'Registry',
    icon: Icons.inventory_2_outlined,
  ),
  _SectionConfig(
    section: _ProductionSection.handoff,
    id: 'handoff',
    label: 'Handoff',
    icon: Icons.description_outlined,
  ),
];

class _ActiveSection extends StatelessWidget {
  const _ActiveSection({
    required this.section,
    required this.snapshot,
    required this.onRoute,
  });

  final _ProductionSection section;
  final ArenaProductionReadySnapshot snapshot;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      _ProductionSection.screens => _ScreensSection(
        screens: snapshot.canonicalScreens,
        onRoute: onRoute,
      ),
      _ProductionSection.states => _StatesSection(
        screens: snapshot.canonicalScreens,
      ),
      _ProductionSection.flows => _FlowsSection(
        flows: snapshot.flows,
        onRoute: onRoute,
      ),
      _ProductionSection.registry => _RegistrySection(
        screens: [...snapshot.canonicalScreens, ...snapshot.supportingScreens],
      ),
      _ProductionSection.handoff => _HandoffSection(snapshot: snapshot),
    };
  }
}

class _ScreensSection extends StatelessWidget {
  const _ScreensSection({required this.screens, required this.onRoute});

  final List<ArenaProductionScreenDraft> screens;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    final liveCount = screens
        .where((s) => s.status == ArenaProductionScreenStatus.live)
        .length;

    return VitPageSection(
      label: 'A - Canonical Screens (vFinal)',
      accentColor: AppModuleAccents.arena,
      density: VitDensity.compact,
      children: [
        Text(
          '7 core screens đã được consolidate thành bản vFinal. Mỗi screen đã audit: trust-first, accessibility, states đầy đủ.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: ArenaSpacingTokens.arenaProductionHeroLineHeight,
          ),
        ),
        for (final screen in screens)
          _ProductionScreenCard(screen: screen, onRoute: onRoute),
        VitCard(
          borderColor: AppModuleAccents.arena.withValues(alpha: .22),
          density: VitDensity.compact,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppModuleAccents.arena,
                    size: ArenaSpacingTokens.arenaProductionHandoffIcon,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Summary',
                      style: AppTextStyles.caption.copyWith(
                        color: AppModuleAccents.arena,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Row(
                children: [
                  _SummaryMetric(
                    label: 'Total screens',
                    value: '${screens.length}',
                  ),
                  _SummaryMetric(label: 'Implemented', value: '$liveCount'),
                  _SummaryMetric(
                    label: 'States covered',
                    value: '${ArenaProductionScreenState.values.length}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductionScreenCard extends StatelessWidget {
  const _ProductionScreenCard({required this.screen, required this.onRoute});

  final ArenaProductionScreenDraft screen;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaProductionReadyPage.screenKey(screen.name),
      onTap: () => onRoute(screen.route),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  screen.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: ArenaSpacingTokens.arenaProductionTitleLineHeight,
                  ),
                ),
              ),
              _StatusPill(status: screen.status),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              _MiniPill(label: screen.version, color: AppColors.accent),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  screen.route,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            screen.notes,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: ArenaSpacingTokens.arenaProductionBodyLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final state in screen.states)
                _StateMiniPill(label: _stateLabel(state)),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCtaButton(
            fullWidth: false,
            height: VitDensity.compact.controlHeight,
            variant: VitCtaButtonVariant.ghost,
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x2,
            ),
            leading: const Icon(
              Icons.open_in_new_rounded,
              color: AppColors.primary,
            ),
            onPressed: () => onRoute(screen.route),
            child: Text(
              'Mở trang',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatesSection extends StatelessWidget {
  const _StatesSection({required this.screens});

  final List<ArenaProductionScreenDraft> screens;

  @override
  Widget build(BuildContext context) {
    final states = ArenaProductionScreenState.values;

    return VitPageSection(
      label: 'B - State Matrix',
      accentColor: AppColors.warn,
      density: VitDensity.compact,
      children: [
        Text(
          'Lưới states cho từng core screen. Chỉ hiển thị states thực sự áp dụng.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: ArenaSpacingTokens.arenaProductionHeroLineHeight,
          ),
        ),
        VitCard(
          density: VitDensity.compact,
          child: Wrap(
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x2,
            children: [
              for (final state in states)
                _StateLegendItem(state: state, active: true),
            ],
          ),
        ),
        for (final screen in screens)
          VitCard(
            density: VitDensity.compact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  screen.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final state in states)
                      _StateMatrixPill(
                        state: state,
                        active: screen.states.contains(state),
                      ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FlowsSection extends StatelessWidget {
  const _FlowsSection({required this.flows, required this.onRoute});

  final List<ArenaProductionFlowDraft> flows;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'C - End-to-End Flows',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [
        Text(
          'Các flow chính có prototype link thật. Tap step để navigate bằng route canonical.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: ArenaSpacingTokens.arenaProductionHeroLineHeight,
          ),
        ),
        for (final flow in flows) _FlowCard(flow: flow, onRoute: onRoute),
      ],
    );
  }
}
