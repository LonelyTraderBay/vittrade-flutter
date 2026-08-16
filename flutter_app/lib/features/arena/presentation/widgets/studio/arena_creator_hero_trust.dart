part of '../../phone/pages/studio/arena_creator_page.dart';

class _CreatorHero extends StatelessWidget {
  const _CreatorHero({required this.creator, required this.onTrust});

  final ArenaCreatorProfileDraft creator;
  final VoidCallback onTrust;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      padding: ArenaSpacingTokens.arenaCreatorHeroPadding,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: ArenaSpacingTokens.arenaCreatorAvatar,
                height: ArenaSpacingTokens.arenaCreatorAvatar,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.surface2,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.cardRadius,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_rounded,
                      color: _arenaAccent,
                      size: ArenaSpacingTokens.arenaCreatorAvatarGlyph,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creator.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x2,
                      children: [
                        if (creator.fairPlayBadge)
                          const VitStatusPill(
                            label: 'Fair Play',
                            status: VitStatusPillStatus.success,
                            size: VitStatusPillSize.sm,
                            icon: Icons.shield_outlined,
                          ),
                        VitStatusPill(
                          label: creator.badge,
                          status: VitStatusPillStatus.orange,
                          size: VitStatusPillSize.sm,
                        ),
                        VitStatusPill(
                          label: 'Lv.${creator.level}',
                          status: VitStatusPillStatus.purple,
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          Row(
            children: [
              Expanded(
                child: _CreatorHeroKpi(
                  label: 'Trust',
                  value: '${creator.trustScore}%',
                  color: AppColors.warn,
                  onTap: onTrust,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _CreatorHeroKpi(
                  label: 'Phòng HT',
                  value: '${creator.completedRooms}',
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            '${creator.modesCreated} modes · ${creator.totalClones} clone',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _CreatorHeroKpi extends StatelessWidget {
  const _CreatorHeroKpi({
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.heroNumber.copyWith(
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      ],
    );

    if (onTap == null) return content;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Padding(
          padding: ArenaSpacingTokens.arenaCreatorStatPadding,
          child: content,
        ),
      ),
    );
  }
}

class _TrustSection extends StatelessWidget {
  const _TrustSection({required this.metrics, required this.onDetails});

  final List<ArenaCreatorTrustMetricDraft> metrics;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TrustHeader(onDetails: onDetails),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          padding: ArenaSpacingTokens.arenaCreatorCardPadding,
          child: Column(
            children: [
              for (var i = 0; i < metrics.length; i++) ...[
                _TrustMetricRow(metric: metrics[i]),
                if (i != metrics.length - 1)
                  const Divider(
                    color: AppColors.divider,
                    height: AppSpacing.x4,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TrustHeader extends StatelessWidget {
  const _TrustHeader({required this.onDetails});

  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: ArenaSpacingTokens.arenaCreatorSectionMarkerWidth,
          height: _creatorSectionMarkerExtent,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: AppColors.buy,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            'Chi tiết tin cậy',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: VitCard(
            key: ArenaCreatorPage.trustDetailKey,
            onTap: onDetails,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            child: Padding(
              padding: ArenaSpacingTokens.arenaCreatorTrustActionPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Xem chi tiết',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.buy,
                    size: ArenaSpacingTokens.arenaCreatorChevron,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrustMetricRow extends StatelessWidget {
  const _TrustMetricRow({required this.metric});

  final ArenaCreatorTrustMetricDraft metric;

  @override
  Widget build(BuildContext context) {
    final color = _metricColor(metric.kind);
    return Row(
      children: [
        SizedBox(
          width: ArenaSpacingTokens.arenaCreatorMetricIconBox,
          height: ArenaSpacingTokens.arenaCreatorMetricIconBox,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: color.withValues(alpha: .14),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.smRadius,
              ),
            ),
            child: Center(
              child: Icon(
                _metricIcon(metric.kind),
                color: color,
                size: ArenaSpacingTokens.arenaCreatorMetricGlyph,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            metric.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          metric.value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
