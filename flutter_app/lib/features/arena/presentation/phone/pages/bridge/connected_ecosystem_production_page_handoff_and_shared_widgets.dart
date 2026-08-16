part of 'connected_ecosystem_production_page.dart';

class _BridgeRules extends StatelessWidget {
  const _BridgeRules({required this.rules});

  final List<ConnectedBridgeRuleDraft> rules;

  @override
  Widget build(BuildContext context) {
    return _HandoffCard(
      title: 'Bridge Rules',
      subtitle: 'Allowed transfer fields vs forbidden financial fields',
      children: [
        for (final rule in rules)
          _HandoffRow(
            title: rule.field,
            subtitle: rule.reason,
            leading: Icon(
              rule.allowed ? Icons.check_rounded : Icons.close_rounded,
              color: rule.allowed ? AppColors.buy : AppColors.sell,
              size: ArenaSpacingTokens.arenaEcosystemInlineIcon,
            ),
          ),
      ],
    );
  }
}

class _QaChecklist extends StatelessWidget {
  const _QaChecklist({required this.items});

  final List<ConnectedQaCheckDraft> items;

  @override
  Widget build(BuildContext context) {
    return _HandoffCard(
      title: 'QA Checklist',
      subtitle: '${items.length} pre-ship checks',
      children: [
        for (final item in items)
          _HandoffRow(
            title: '${item.category} · ${item.id}',
            subtitle: item.check,
            trailing: _MiniPill(
              label: _qaSeverityLabel(item.severity),
              color: _qaSeverityColor(item.severity),
            ),
          ),
      ],
    );
  }
}

class _HandoffCard extends StatelessWidget {
  const _HandoffCard({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
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
          const SizedBox(height: AppSpacing.x1),
          Text(
            subtitle,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final child in children) ...[
            child,
            if (child != children.last)
              const Divider(height: AppSpacing.x4, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _HandoffRow extends StatelessWidget {
  const _HandoffRow({
    required this.title,
    required this.subtitle,
    this.leading,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: AppSpacing.x2),
        ],
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
                subtitle,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: _ecosystemCheckLineHeight,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.x2),
          trailing!,
        ],
      ],
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: color ?? AppColors.text3,
          size: ArenaSpacingTokens.arenaEcosystemCompactIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _ecosystemCheckLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: label,
      status: _semanticStatusForColor(color),
      size: VitStatusPillSize.sm,
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: label,
      accentColor: color,
      semanticStatus: _semanticStatusForColor(color),
    );
  }
}

class _TintIcon extends StatelessWidget {
  const _TintIcon({
    required this.icon,
    required this.color,
    this.small = false,
  });

  final IconData icon;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small
        ? ArenaSpacingTokens.arenaEcosystemTintIconBoxSmall
        : ArenaSpacingTokens.arenaEcosystemTintIconBox;
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .12),
          shape: RoundedRectangleBorder(
            borderRadius: small ? AppRadii.inputRadius : AppRadii.mdRadius,
            side: BorderSide(color: color.withValues(alpha: .20)),
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: small
              ? ArenaSpacingTokens.arenaEcosystemTintGlyphSmall
              : ArenaSpacingTokens.arenaEcosystemTintGlyph,
        ),
      ),
    );
  }
}

class _EcosystemFooter extends StatelessWidget {
  const _EcosystemFooter({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text3,
            size: ArenaSpacingTokens.arenaEcosystemSmallIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: _ecosystemBodyLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _SectionConfig {
  const _SectionConfig({
    required this.section,
    required this.id,
    required this.label,
    required this.icon,
  });

  final _EcosystemSection section;
  final String id;
  final String label;
  final IconData icon;
}

final class _HandoffBoard {
  const _HandoffBoard({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

const _sectionConfigs = [
  _SectionConfig(
    section: _EcosystemSection.canonical,
    id: 'canonical',
    label: 'Canonical',
    icon: Icons.layers_outlined,
  ),
  _SectionConfig(
    section: _EcosystemSection.states,
    id: 'states',
    label: 'States',
    icon: Icons.warning_amber_rounded,
  ),
  _SectionConfig(
    section: _EcosystemSection.flows,
    id: 'flows',
    label: 'E2E Flows',
    icon: Icons.map_outlined,
  ),
  _SectionConfig(
    section: _EcosystemSection.registry,
    id: 'registry',
    label: 'Registry',
    icon: Icons.inventory_2_outlined,
  ),
  _SectionConfig(
    section: _EcosystemSection.handoff,
    id: 'handoff',
    label: 'Handoff',
    icon: Icons.description_outlined,
  ),
];

const _handoffBoards = [
  _HandoffBoard(id: 'routes', label: 'Routes', icon: Icons.map_outlined),
  _HandoffBoard(
    id: 'components',
    label: 'Components',
    icon: Icons.inventory_2_outlined,
  ),
  _HandoffBoard(id: 'rules', label: 'Bridge Rules', icon: Icons.menu_book),
  _HandoffBoard(
    id: 'qa',
    label: 'QA Checklist',
    icon: Icons.check_circle_outline,
  ),
];

String _resolveConnectedRoute(String route) {
  return switch (route) {
    '/' => AppRoutePaths.home,
    '/markets/predictions/event/:id' => AppRoutePaths.marketsPredictionEvent(
      'pred-1',
    ),
    '/arena/challenge/:id' => AppRoutePaths.arenaChallenge('ch003'),
    '/arena/challenge/:challengeId' => AppRoutePaths.arenaChallenge('ch003'),
    '/arena/mode/:id' => AppRoutePaths.arenaMode('mode001'),
    '/profile/arena' => AppRoutePaths.profileArena,
    '/markets/predictions/portfolio' =>
      AppRoutePaths.marketsPredictionsPortfolio,
    _ => route,
  };
}

String _statusLabel(ConnectedEcosystemScreenStatus status) {
  return switch (status) {
    ConnectedEcosystemScreenStatus.vFinal => 'vFinal',
    ConnectedEcosystemScreenStatus.live => 'Live',
    ConnectedEcosystemScreenStatus.needsReview => 'Needs Review',
    ConnectedEcosystemScreenStatus.archived => 'Archived',
  };
}

Color _statusColor(ConnectedEcosystemScreenStatus status) {
  return switch (status) {
    ConnectedEcosystemScreenStatus.vFinal => AppColors.buy,
    ConnectedEcosystemScreenStatus.live => AppColors.primary,
    ConnectedEcosystemScreenStatus.needsReview => AppColors.warn,
    ConnectedEcosystemScreenStatus.archived => AppColors.text3,
  };
}

Color _toneColor(ArenaBridgeTone tone) {
  return switch (tone) {
    ArenaBridgeTone.content => AppColors.primary,
    ArenaBridgeTone.arena => AppModuleAccents.arena,
    ArenaBridgeTone.prediction => AppModuleAccents.predictions,
    ArenaBridgeTone.disclosure => AppColors.buy,
    ArenaBridgeTone.danger => AppColors.sell,
    ArenaBridgeTone.blocked => AppColors.sell,
    ArenaBridgeTone.neutral => AppColors.text2,
  };
}

VitStatusPillStatus _semanticStatusForColor(Color color) {
  if (color == AppColors.buy) {
    return VitStatusPillStatus.success;
  }
  if (color == AppColors.sell) {
    return VitStatusPillStatus.error;
  }
  if (color == AppColors.warn) {
    return VitStatusPillStatus.warning;
  }
  if (color == AppColors.primary) {
    return VitStatusPillStatus.info;
  }
  if (color == AppModuleAccents.arena) {
    return VitStatusPillStatus.orange;
  }
  if (color == AppModuleAccents.predictions) {
    return VitStatusPillStatus.purple;
  }
  return VitStatusPillStatus.neutral;
}

IconData _toneIcon(ArenaBridgeTone tone) {
  return switch (tone) {
    ArenaBridgeTone.content => Icons.link_rounded,
    ArenaBridgeTone.arena => Icons.sports_esports_outlined,
    ArenaBridgeTone.prediction => Icons.shield_outlined,
    ArenaBridgeTone.disclosure => Icons.check_circle_outline,
    ArenaBridgeTone.danger => Icons.warning_amber_rounded,
    ArenaBridgeTone.blocked => Icons.block_rounded,
    ArenaBridgeTone.neutral => Icons.info_outline_rounded,
  };
}

String _bridgeTypeLabel(ConnectedBridgeType type) {
  return switch (type) {
    ConnectedBridgeType.none => 'none',
    ConnectedBridgeType.source => 'source',
    ConnectedBridgeType.target => 'target',
    ConnectedBridgeType.bidirectional => 'bidirectional',
  };
}

Color _bridgeTypeColor(ConnectedBridgeType type) {
  return switch (type) {
    ConnectedBridgeType.none => AppColors.text3,
    ConnectedBridgeType.source => AppColors.primary,
    ConnectedBridgeType.target => AppModuleAccents.arena,
    ConnectedBridgeType.bidirectional => AppModuleAccents.predictions,
  };
}

String _severityLabel(ConnectedRuleSeverity severity) {
  return switch (severity) {
    ConnectedRuleSeverity.critical => 'CRITICAL',
    ConnectedRuleSeverity.high => 'HIGH',
    ConnectedRuleSeverity.medium => 'MEDIUM',
  };
}

Color _severityColor(ConnectedRuleSeverity severity) {
  return switch (severity) {
    ConnectedRuleSeverity.critical => AppColors.sell,
    ConnectedRuleSeverity.high => AppColors.warn,
    ConnectedRuleSeverity.medium => AppColors.primary,
  };
}

String _qaSeverityLabel(ConnectedQaSeverity severity) {
  return switch (severity) {
    ConnectedQaSeverity.must => 'MUST',
    ConnectedQaSeverity.should => 'SHOULD',
    ConnectedQaSeverity.may => 'MAY',
  };
}

Color _qaSeverityColor(ConnectedQaSeverity severity) {
  return switch (severity) {
    ConnectedQaSeverity.must => AppColors.sell,
    ConnectedQaSeverity.should => AppColors.warn,
    ConnectedQaSeverity.may => AppColors.text2,
  };
}
