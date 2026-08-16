part of 'arena_production_ready_page.dart';

class _FlowCard extends StatelessWidget {
  const _FlowCard({required this.flow, required this.onRoute});

  final ArenaProductionFlowDraft flow;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    final color = _flowColor(flow.id);

    return VitCard(
      borderColor: color.withValues(alpha: .22),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TintIcon(icon: _flowIcon(flow.id), color: color, small: true),
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
              color: color,
              first: i == 0,
              last: i == flow.steps.length - 1,
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
    required this.color,
    required this.first,
    required this.last,
    required this.onRoute,
  });

  final String flowId;
  final ArenaProductionFlowStepDraft step;
  final Color color;
  final bool first;
  final bool last;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: ArenaSpacingTokens.arenaProductionFlowColumnWidth,
            child: Column(
              children: [
                SizedBox.square(
                  dimension: ArenaSpacingTokens.arenaProductionFlowDot,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: first
                          ? color.withValues(alpha: .18)
                          : AppColors.surface2,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: color,
                          width:
                              ArenaSpacingTokens.arenaProductionFlowBorderWidth,
                        ),
                      ),
                    ),
                  ),
                ),
                if (!last)
                  Expanded(
                    child: Padding(
                      padding: ArenaSpacingTokens
                          .arenaProductionFlowLineMarginPadding,
                      child: SizedBox(
                        width: ArenaSpacingTokens.arenaProductionFlowLineWidth,
                        child: ColoredBox(color: color.withValues(alpha: .30)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Material(
              key: ArenaProductionReadyPage.flowStepKey(flowId, step.label),
              color: AppColors.transparent,
              child: InkWell(
                onTap: () => onRoute(step.route),
                borderRadius: AppRadii.inputRadius,
                child: Padding(
                  padding: ArenaSpacingTokens.arenaProductionFlowStepPadding(
                    last,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        step.description,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height:
                              ArenaSpacingTokens.arenaProductionCheckLineHeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistrySection extends StatelessWidget {
  const _RegistrySection({required this.screens});

  final List<ArenaProductionScreenDraft> screens;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'D - Live vs Release-gated vs QA',
      accentColor: AppColors.buy,
      density: VitDensity.compact,
      children: [
        Text(
          'Clear labels: Live = implemented local UI, Release-gated = not user-available, QA = internal only.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: ArenaSpacingTokens.arenaProductionHeroLineHeight,
          ),
        ),
        VitCard(
          density: VitDensity.compact,
          child: Row(
            children: [
              for (final status in ArenaProductionScreenStatus.values) ...[
                Expanded(
                  child: _StatusMetric(status: status, screens: screens),
                ),
                if (status != ArenaProductionScreenStatus.values.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
        for (final status in ArenaProductionScreenStatus.values.where(
          (status) => screens.any((screen) => screen.status == status),
        ))
          _StatusGroup(status: status, screens: screens),
      ],
    );
  }
}

class _StatusMetric extends StatelessWidget {
  const _StatusMetric({required this.status, required this.screens});

  final ArenaProductionScreenStatus status;
  final List<ArenaProductionScreenDraft> screens;

  @override
  Widget build(BuildContext context) {
    final count = screens.where((screen) => screen.status == status).length;
    final color = _statusColor(status);

    return Column(
      children: [
        Text(
          '$count',
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            fontWeight: AppTextStyles.heavy,
            height: ArenaSpacingTokens.arenaProductionMetricLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          _statusLabel(status),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _StatusGroup extends StatelessWidget {
  const _StatusGroup({required this.status, required this.screens});

  final ArenaProductionScreenStatus status;
  final List<ArenaProductionScreenDraft> screens;

  @override
  Widget build(BuildContext context) {
    final items = screens.where((screen) => screen.status == status).toList();
    if (items.isEmpty) return const SizedBox.shrink();
    final color = _statusColor(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _TintIcon(icon: Icons.circle, color: color, small: true),
            const SizedBox(width: AppSpacing.x2),
            Text(
              '${_statusLabel(status)} (${items.length})',
              style: AppTextStyles.body.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(
          padding: AppSpacing.zeroInsets,
          borderColor: color.withValues(alpha: .18),
          density: VitDensity.compact,
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++)
                _RegistryRow(
                  screen: items[i],
                  color: color,
                  divider: i < items.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RegistryRow extends StatelessWidget {
  const _RegistryRow({
    required this.screen,
    required this.color,
    required this.divider,
  });

  final ArenaProductionScreenDraft screen;
  final Color color;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: ArenaSpacingTokens.arenaProductionRegistryRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  screen.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  screen.route,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            screen.version,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );

    if (!divider) return row;

    return Column(
      children: [
        row,
        const Divider(height: AppSpacing.dividerHairline),
      ],
    );
  }
}

class _HandoffSection extends StatelessWidget {
  const _HandoffSection({required this.snapshot});

  final ArenaProductionReadySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final allScreens = [
      ...snapshot.canonicalScreens,
      ...snapshot.supportingScreens,
    ];

    return VitPageSection(
      label: 'E - Dev Handoff Pack',
      accentColor: AppColors.sell,
      density: VitDensity.compact,
      children: [
        Text(
          '4 handoff boards: Route Registry, Component Registry, Trust & Governance Rules, Points Ledger / Resolution Dictionary.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            height: ArenaSpacingTokens.arenaProductionHeroLineHeight,
          ),
        ),
        _HandoffCard(
          icon: Icons.map_outlined,
          color: AppColors.accent,
          title: '1. Route Registry',
          subtitle: '${allScreens.length} routes',
          child: Column(
            children: [
              for (final screen in allScreens)
                _RouteRegistryLine(screen: screen),
            ],
          ),
        ),
        _HandoffCard(
          icon: Icons.layers_outlined,
          color: AppColors.primary,
          title: '2. Component Registry (${snapshot.components.length})',
          subtitle: 'Shared Arena UI components',
          child: Column(
            children: [
              for (final component in snapshot.components)
                _ComponentLine(component: component),
            ],
          ),
        ),
        for (final dictionary in snapshot.dictionaries)
          _DictionaryBoard(dictionary: dictionary),
        _HandoffCard(
          icon: Icons.check_circle_outline,
          color: AppColors.buy,
          title: 'QA Checklist - Pre-ship',
          subtitle: '${snapshot.qaItems.length} checks',
          child: Column(
            children: [
              for (final item in snapshot.qaItems) _ChecklistLine(label: item),
            ],
          ),
        ),
      ],
    );
  }
}

class _HandoffCard extends StatelessWidget {
  const _HandoffCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: color.withValues(alpha: .18),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TintIcon(icon: icon, color: color, small: true),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      subtitle,
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
          child,
        ],
      ),
    );
  }
}

class _RouteRegistryLine extends StatelessWidget {
  const _RouteRegistryLine({required this.screen});

  final ArenaProductionScreenDraft screen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaBottomPaddingX2,
      child: Row(
        children: [
          _StatusPill(status: screen.status),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              screen.route,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            screen.version,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
