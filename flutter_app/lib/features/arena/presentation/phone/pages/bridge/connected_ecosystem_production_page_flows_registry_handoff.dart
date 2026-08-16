part of 'connected_ecosystem_production_page.dart';

class _FlowCard extends StatelessWidget {
  const _FlowCard({required this.flow, required this.onRoute});

  final ConnectedFlowDraft flow;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(flow.tone);
    return VitCard(
      borderColor: color.withValues(alpha: .22),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TintIcon(icon: Icons.map_outlined, color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flow.name,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      '${flow.steps.length} steps',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (var i = 0; i < flow.steps.length; i++)
            _FlowStepRow(
              flowId: flow.id,
              step: flow.steps[i],
              index: i,
              isLast: i == flow.steps.length - 1,
              color: color,
              onRoute: onRoute,
            ),
        ],
      ),
    );
  }
}

class _FlowStepRow extends StatelessWidget {
  const _FlowStepRow({
    required this.flowId,
    required this.step,
    required this.index,
    required this.isLast,
    required this.color,
    required this.onRoute,
  });

  final String flowId;
  final ConnectedFlowStepDraft step;
  final int index;
  final bool isLast;
  final Color color;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: ConnectedEcosystemProductionPage.flowStepKey(flowId, step.label),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(
              width: ArenaSpacingTokens.arenaEcosystemFlowDot,
              height: ArenaSpacingTokens.arenaEcosystemFlowDot,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: step.isBridge
                      ? color.withValues(alpha: .18)
                      : AppColors.surface2,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: step.isBridge ? color : AppColors.borderSolid,
                      width: ArenaSpacingTokens.arenaEcosystemFlowBorderWidth,
                    ),
                  ),
                ),
                child: Center(
                  child: step.isBridge
                      ? Icon(
                          Icons.link_rounded,
                          color: color,
                          size: ArenaSpacingTokens.arenaEcosystemFlowBridgeIcon,
                        )
                      : Text(
                          '${index + 1}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                ),
              ),
            ),
            if (!isLast)
              SizedBox(
                width: ArenaSpacingTokens.arenaEcosystemFlowLineWidth,
                height: _ecosystemFlowConnectorHeight,
                child: ColoredBox(
                  color: (step.isBridge ? color : AppColors.borderSolid)
                      .withValues(alpha: .35),
                ),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Padding(
            padding: isLast
                ? AppSpacing.zeroInsets
                : ArenaSpacingTokens.arenaBottomPaddingX3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        step.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (step.isBridge) ...[
                      const SizedBox(width: AppSpacing.x2),
                      _MiniPill(label: 'BRIDGE', color: color),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  step.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: _ecosystemCheckLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                VitCtaButton(
                  fullWidth: false,
                  height: VitDensity.compact.controlHeight,
                  variant: VitCtaButtonVariant.ghost,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.x2,
                  ),
                  leading: Icon(Icons.chevron_right_rounded, color: color),
                  onPressed: () => onRoute(step.route),
                  child: Text(
                    step.route,
                    style: AppTextStyles.micro.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RegistrySection extends StatelessWidget {
  const _RegistrySection({
    required this.sharedItems,
    required this.separateItems,
    required this.forbiddenPatterns,
  });

  final List<ConnectedRegistryItemDraft> sharedItems;
  final List<ConnectedRegistryItemDraft> separateItems;
  final List<ConnectedForbiddenPatternDraft> forbiddenPatterns;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Shared vs Separate Registry',
      accentColor: AppModuleAccents.predictions,
      density: VitDensity.compact,
      children: [
        Text(
          'Ranh giới rõ ràng: items nào được share, items nào phải tách biệt.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: _ecosystemIntroLineHeight,
          ),
        ),
        _RegistryBoard(
          title: 'Shared (Connect by Content)',
          items: sharedItems,
          color: AppColors.buy,
          icon: Icons.link_rounded,
        ),
        _RegistryBoard(
          title: 'Separate (Never Merge)',
          items: separateItems,
          color: AppColors.sell,
          icon: Icons.shield_outlined,
        ),
        VitPageSection(
          label: 'Forbidden UX Patterns',
          accentColor: AppColors.sell,
          density: VitDensity.compact,
          children: [
            for (final pattern in forbiddenPatterns)
              _ForbiddenPatternCard(pattern: pattern),
          ],
        ),
      ],
    );
  }
}

class _RegistryBoard extends StatelessWidget {
  const _RegistryBoard({
    required this.title,
    required this.items,
    required this.color,
    required this.icon,
  });

  final String title;
  final List<ConnectedRegistryItemDraft> items;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: color.withValues(alpha: .22),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TintIcon(icon: icon, color: color, small: true),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final item in items) ...[
            _RegistryItemRow(item: item, color: color),
            if (item != items.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _RegistryItemRow extends StatelessWidget {
  const _RegistryItemRow({required this.item, required this.color});

  final ConnectedRegistryItemDraft item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_rounded,
          color: color,
          size: ArenaSpacingTokens.arenaEcosystemCompactIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: _ecosystemCheckLineHeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ForbiddenPatternCard extends StatelessWidget {
  const _ForbiddenPatternCard({required this.pattern});

  final ConnectedForbiddenPatternDraft pattern;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(pattern.severity);
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: .20),
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.block_rounded,
            color: color,
            size: ArenaSpacingTokens.arenaEcosystemBlockIcon,
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
                        pattern.pattern,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    _MiniPill(
                      label: _severityLabel(pattern.severity),
                      color: color,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  pattern.reason,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: _ecosystemCheckLineHeight,
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

class _HandoffSection extends StatelessWidget {
  const _HandoffSection({
    required this.snapshot,
    required this.activeBoard,
    required this.onBoardChanged,
  });

  final ConnectedEcosystemProductionSnapshot snapshot;
  final String activeBoard;
  final ValueChanged<String> onBoardChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Dev / QA Handoff Pack',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              for (final board in _handoffBoards) ...[
                _BoardChip(
                  board: board,
                  active: activeBoard == board.id,
                  onTap: () => onBoardChanged(board.id),
                ),
                if (board != _handoffBoards.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
        if (activeBoard == 'routes')
          _RouteRegistry(routes: snapshot.routeRegistry)
        else if (activeBoard == 'components')
          _ComponentRegistry(components: snapshot.componentRegistry)
        else if (activeBoard == 'rules')
          _BridgeRules(rules: snapshot.bridgeRules)
        else
          _QaChecklist(items: snapshot.qaChecklist),
      ],
    );
  }
}

class _BoardChip extends StatelessWidget {
  const _BoardChip({
    required this.board,
    required this.active,
    required this.onTap,
  });

  final _HandoffBoard board;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      key: ConnectedEcosystemProductionPage.handoffKey(board.id),
      label: board.label,
      icon: board.icon,
      status: active ? VitStatusPillStatus.info : VitStatusPillStatus.neutral,
      size: VitStatusPillSize.md,
      outline: !active,
      onTap: onTap,
    );
  }
}

class _RouteRegistry extends StatelessWidget {
  const _RouteRegistry({required this.routes});

  final List<ConnectedRouteEntryDraft> routes;

  @override
  Widget build(BuildContext context) {
    return _HandoffCard(
      title: 'Route Registry',
      subtitle: '${routes.length} routes with bridge integration',
      children: [
        for (final route in routes)
          _HandoffRow(
            title: route.page,
            subtitle: route.route,
            trailing: _MiniPill(
              label: _bridgeTypeLabel(route.bridgeType),
              color: _bridgeTypeColor(route.bridgeType),
            ),
          ),
      ],
    );
  }
}

class _ComponentRegistry extends StatelessWidget {
  const _ComponentRegistry({required this.components});

  final List<ConnectedComponentEntryDraft> components;

  @override
  Widget build(BuildContext context) {
    return _HandoffCard(
      title: 'Component Registry',
      subtitle: '${components.length} shared bridge components',
      children: [
        for (final component in components)
          _HandoffRow(
            title: component.name,
            subtitle: '${component.file} · ${component.disclosure}',
            trailing: _MiniPill(
              label: component.module,
              color: AppColors.primary,
            ),
          ),
      ],
    );
  }
}
