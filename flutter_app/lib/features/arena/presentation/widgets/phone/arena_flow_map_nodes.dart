part of '../../phone/pages/hub/arena_flow_map_page.dart';

class _FlowGroupCard extends StatelessWidget {
  const _FlowGroupCard({required this.group, required this.onRoute});

  final ArenaFlowGroupDraft group;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    final color = _flowColor(group.kind);
    return Column(
      children: [
        VitSectionHeader(
          title: group.title,
          subtitle: group.subtitle,
          variant: VitSectionHeaderVariant.markerTitle,
          accentColor: color,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(
          padding: AppSpacing.zeroInsets,
          clip: true,
          child: Column(
            children: [
              for (final node in group.nodes) ...[
                _FlowNodeRow(node: node, onRoute: onRoute),
                if (node != group.nodes.last)
                  const Divider(
                    height: _flowMapDividerHeight,
                    color: AppColors.divider,
                  ),
              ],
              Padding(
                padding: _flowMapCardPadding,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.alt_route_rounded,
                      color: AppColors.text3,
                      size: _flowMapSmallIcon,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        group.connectionNote,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: _flowMapConnectionLineHeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FlowNodeRow extends StatelessWidget {
  const _FlowNodeRow({required this.node, required this.onRoute});

  final ArenaFlowNodeDraft node;
  final ValueChanged<String> onRoute;

  @override
  Widget build(BuildContext context) {
    final color = _flowColor(node.kind);
    final route = node.route;
    return Material(
      type: MaterialType.transparency,
      child: VitCard(
        key: ArenaFlowMapPage.nodeKey(node.label),
        onTap: route == null ? null : () => onRoute(route),
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        child: Padding(
          padding: _flowMapCardPadding,
          child: Row(
            children: [
              _FlowIcon(kind: node.kind),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      node.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      node.sublabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              if (node.stateLabel != null) ...[
                const SizedBox(width: AppSpacing.x2),
                VitStatusPill(
                  label: node.stateLabel!,
                  status: VitStatusPillStatus.info,
                  size: VitStatusPillSize.sm,
                ),
              ],
              if (route != null) ...[
                const SizedBox(width: AppSpacing.x2),
                Icon(
                  Icons.chevron_right_rounded,
                  color: color,
                  size: _flowMapInlineIcon,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SharedComponents extends StatelessWidget {
  const _SharedComponents({required this.components});

  final List<ArenaFlowComponentDraft> components;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const VitSectionHeader(
          title: 'Shared Components',
          variant: VitSectionHeaderVariant.markerTitle,
          accentColor: AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (final component in components) ...[
          VitCard(
            density: VitDensity.compact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const _FlowIcon(kind: ArenaFlowKind.verified),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Text(
                        component.file,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.accent,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  component.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final export in component.exports)
                      VitStatusPill(
                        label: export,
                        status: VitStatusPillStatus.neutral,
                        size: VitStatusPillSize.sm,
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (component != components.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _HandoffNotes extends StatelessWidget {
  const _HandoffNotes({required this.notes});

  final List<ArenaFlowNoteDraft> notes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final note in notes) ...[
          VitCard(
            density: VitDensity.compact,
            borderColor: _flowColor(note.kind).withValues(alpha: .22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FlowIcon(kind: note.kind),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        note.detail,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          height: _flowMapBodyLineHeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (note != notes.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}
