part of 'connected_ecosystem_production_page.dart';

class _EcosystemHero extends StatelessWidget {
  const _EcosystemHero();

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TintIcon(
            icon: Icons.inventory_2_outlined,
            color: AppColors.primary,
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
                        'Connected Ecosystem',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const _StatusPill(
                      label: 'PRODUCTION',
                      color: AppColors.buy,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Consolidation 09A - 09D',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: _ecosystemMetricLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Text(
                  'Handoff nội bộ: bridge topic/context giữa Open Arena và Prediction Markets — điểm Arena và ví tách biệt hoàn toàn.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: _ecosystemBodyLineHeight,
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

  final _EcosystemSection active;
  final ValueChanged<_EcosystemSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitScrollableTabHeader.pillRow(
      headerKey: ConnectedEcosystemProductionPage.tabsKey,
      items: [
        for (final config in _sectionConfigs)
          VitStatusPill(
            key: ConnectedEcosystemProductionPage.tabKey(config.id),
            label: config.label,
            icon: config.icon,
            status: active == config.section
                ? VitStatusPillStatus.info
                : VitStatusPillStatus.neutral,
            size: VitStatusPillSize.md,
            outline: active != config.section,
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
    required this.activeHandoffBoard,
    required this.onHandoffBoardChanged,
    required this.onRoute,
  });

  final _EcosystemSection section;
  final ConnectedEcosystemProductionSnapshot snapshot;
  final String activeHandoffBoard;
  final ValueChanged<String> onHandoffBoardChanged;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      _EcosystemSection.canonical => _CanonicalSection(
        screens: snapshot.canonicalScreens,
        onRoute: onRoute,
      ),
      _EcosystemSection.states => _StatesSection(states: snapshot.bridgeStates),
      _EcosystemSection.flows => _FlowsSection(
        flows: snapshot.connectedFlows,
        onRoute: onRoute,
      ),
      _EcosystemSection.registry => _RegistrySection(
        sharedItems: snapshot.sharedItems,
        separateItems: snapshot.separateItems,
        forbiddenPatterns: snapshot.forbiddenPatterns,
      ),
      _EcosystemSection.handoff => _HandoffSection(
        snapshot: snapshot,
        activeBoard: activeHandoffBoard,
        onBoardChanged: onHandoffBoardChanged,
      ),
    };
  }
}

class _CanonicalSection extends StatelessWidget {
  const _CanonicalSection({required this.screens, required this.onRoute});

  final List<ConnectedScreenDraft> screens;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    final componentCount = screens
        .expand((screen) => screen.bridgeComponents)
        .toSet()
        .length;
    return VitPageSection(
      label: 'Canonical Connected Screens',
      accentColor: AppColors.buy,
      density: VitDensity.compact,
      children: [
        Text(
          '9 màn hình vFinal chứa bridge integration từ 09A-09D. Mỗi màn đã chọn canonical version tốt nhất.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: _ecosystemIntroLineHeight,
          ),
        ),
        for (final screen in screens)
          _CanonicalScreenCard(screen: screen, onRoute: onRoute),
        VitCard(
          borderColor: AppColors.buy.withValues(alpha: .22),
          density: VitDensity.compact,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.buy,
                    size: ArenaSpacingTokens.arenaEcosystemTabIcon,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Summary',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.buy,
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
                  _SummaryMetric(
                    label: 'vFinal',
                    value:
                        '${screens.where((s) => s.status == ConnectedEcosystemScreenStatus.vFinal).length}',
                  ),
                  _SummaryMetric(
                    label: 'Bridge components',
                    value: '$componentCount',
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

class _CanonicalScreenCard extends StatelessWidget {
  const _CanonicalScreenCard({required this.screen, required this.onRoute});

  final ConnectedScreenDraft screen;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ConnectedEcosystemProductionPage.screenKey(screen.name),
      onTap: screen.route == '/' ? null : () => onRoute(screen.route),
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
                    height: _ecosystemTitleLineHeight,
                  ),
                ),
              ),
              _StatusPill(
                label: _statusLabel(screen.status),
                color: _statusColor(screen.status),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              _MiniPill(
                label: screen.source,
                color: AppModuleAccents.predictions,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  screen.route,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            screen.notes,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: _ecosystemBodyLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final component in screen.bridgeComponents)
                _MiniPill(label: component, color: AppColors.primary),
            ],
          ),
          if (screen.route != '/') ...[
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
        ],
      ),
    );
  }
}

class _StatesSection extends StatelessWidget {
  const _StatesSection({required this.states});

  final List<ConnectedBridgeStateDraft> states;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Bridge State Matrix',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [
        Text(
          '8 bridge-specific states. Mỗi state định nghĩa behavior, affected screens và fallback UI.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: _ecosystemIntroLineHeight,
          ),
        ),
        for (final state in states) _StateCard(state: state),
      ],
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({required this.state});

  final ConnectedBridgeStateDraft state;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(state.tone);
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TintIcon(icon: _toneIcon(state.tone), color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.label,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    _MiniPill(label: state.id, color: color),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            state.description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: _ecosystemBodyLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _InfoLine(
            icon: Icons.layers_outlined,
            text: 'Screens: ${state.affectedScreens.join(', ')}',
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _InfoLine(
            icon: Icons.arrow_forward_rounded,
            text: 'Behavior: ${state.behavior}',
            color: color,
          ),
        ],
      ),
    );
  }
}

class _FlowsSection extends StatelessWidget {
  const _FlowsSection({required this.flows, required this.onRoute});

  final List<ConnectedFlowDraft> flows;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Connected E2E Flows',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [
        Text(
          '4 end-to-end flows kết nối 2 module. Bridge steps được đánh dấu bằng link icon.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: _ecosystemIntroLineHeight,
          ),
        ),
        for (final flow in flows) _FlowCard(flow: flow, onRoute: onRoute),
      ],
    );
  }
}
