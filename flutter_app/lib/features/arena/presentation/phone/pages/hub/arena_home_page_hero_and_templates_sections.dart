part of 'arena_home_page.dart';

class _ArenaToolsSheet extends StatelessWidget {
  const _ArenaToolsSheet({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      key: ArenaHomePage.toolsSheetKey,
      title: 'Công cụ Arena',
      child: VitActionTileGrid(
        density: VitDensity.compact,
        crossAxisSpacing: AppSpacing.x3,
        mainAxisSpacing: AppSpacing.x3,
        physics: const ClampingScrollPhysics(),
        itemCount: _arenaHomeTools.length,
        itemBuilder: (context, index, density) {
          final tool = _arenaHomeTools[index];
          return VitServiceTile(
            key: ArenaHomePage.toolKey(tool.id),
            density: density,
            icon: tool.icon,
            label: tool.label,
            accentColor: _arenaAccent,
            onTap: () => onNavigate(tool.route),
          );
        },
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.count = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaHomeQuickChipGapPadding,
      child: IntrinsicWidth(
        child: VitCard(
          onTap: onTap,
          variant: VitCardVariant.inner,
          radius: VitCardRadius.standard,
          height: VitDensity.compact.controlHeight,
          contentAlign: VitCardContentAlign.center,
          padding: AppSpacing.cardTilePadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: AppColors.text2,
                size: ArenaSpacingTokens.arenaHomeQuickChipIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                  height: _arenaHomeCountBadgeLineHeight,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: AppSpacing.x2),
                _MiniCountBadge(count: count),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.pointsBalance,
    required this.activeChallenges,
    required this.onCreate,
    required this.onExplore,
  });

  final int pointsBalance;
  final int activeChallenges;
  final VoidCallback onCreate;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Thử thách cộng đồng',
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontWeight: AppTextStyles.heavy,
                    height: _arenaHomeHeroTitleLineHeight,
                  ),
                ),
              ),
              const VitStatusPill(
                label: 'Chỉ điểm Arena',
                status: VitStatusPillStatus.orange,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _ArenaHeroKpi(
                  label: 'Điểm Arena',
                  value: formatArenaPoints(pointsBalance),
                  valueStyle: AppTextStyles.heroNumber.copyWith(
                    color: AppColors.text1,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(
                width: 1,
                height: AppSpacing.x6,
                child: ColoredBox(color: AppColors.border),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.x3,
                  ),
                  child: _ArenaHeroKpi(
                    label: 'Đang mở',
                    value: '$activeChallenges',
                    valueStyle: AppTextStyles.heroNumber.copyWith(
                      color: _arenaAccent,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCtaButton(
            key: ArenaHomePage.createChallengeKey,
            onPressed: onCreate,
            density: VitDensity.compact,
            fullWidth: true,
            leading: const Icon(Icons.auto_awesome_rounded),
            child: const Text('Tạo thách đấu'),
          ),
          const SizedBox(height: AppSpacing.x1),
          Align(
            alignment: AlignmentDirectional.center,
            child: TextButton.icon(
              key: ArenaHomePage.exploreModeKey,
              onPressed: onExplore,
              icon: const Icon(Icons.search_rounded, size: AppSpacing.iconSm),
              label: const Text('Khám phá chế độ'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArenaHeroKpi extends StatelessWidget {
  const _ArenaHeroKpi({
    required this.label,
    required this.value,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(value, style: valueStyle),
      ],
    );
  }
}

class _TemplateSection extends StatelessWidget {
  const _TemplateSection({
    required this.anchorKey,
    required this.templates,
    required this.onTap,
  });

  final Key anchorKey;
  final List<ArenaTemplateDraft> templates;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    if (templates.isEmpty) {
      return VitPageSection(
        key: anchorKey,
        label: 'Mẫu thách đấu',
        accentColor: AppColors.accent,
        density: VitDensity.compact,
        children: const [
          VitEmptyState(
            icon: Icons.dashboard_customize_outlined,
            title: 'Chưa có mẫu thách đấu',
            message: 'Mẫu tạo thách đấu mới sẽ hiển thị tại đây.',
          ),
        ],
      );
    }

    return VitPageSection(
      key: anchorKey,
      label: 'Mẫu thách đấu',
      accentColor: AppColors.accent,
      density: VitDensity.compact,
      children: [
        Text(
          'Chọn mẫu để bắt đầu tạo thách đấu',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        GridView.builder(
          padding: const EdgeInsetsDirectional.all(AppSpacing.zero),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: templates.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ArenaSpacingTokens.arenaHomeTemplateColumns,
            crossAxisSpacing: AppSpacing.x2,
            mainAxisSpacing: AppSpacing.x2,
            mainAxisExtent: ArenaSpacingTokens.arenaHomeTemplateExtent,
          ),
          itemBuilder: (context, index) {
            final template = templates[index];
            final accent = _templateColor(template.kind);
            final tags = template.tags.take(2).join(' · ');
            return VitCard(
              key: ArenaHomePage.templateKey(template.id),
              onTap: () => onTap(template.id),
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _ActionIcon(
                        icon: _templateIcon(template.kind),
                        color: accent,
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Text(
                          template.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                            height: _arenaHomeTemplateTitleLineHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    template.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: _arenaHomeTemplateDescriptionLineHeight,
                    ),
                  ),
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      tags,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: accent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
