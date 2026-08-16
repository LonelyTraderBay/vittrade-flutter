part of '../../phone/pages/tools/launchpad_notif_sound_page.dart';

class _CategorySoundSection extends StatelessWidget {
  const _CategorySoundSection({
    required this.snapshot,
    required this.masterEnabled,
    required this.categories,
    required this.expandedCategoryId,
    required this.playingPreviewId,
    required this.onToggleCategory,
    required this.onExpandCategory,
    required this.onSoundType,
    required this.onVolume,
    required this.onPreview,
  });

  final LaunchpadNotifSoundSnapshot snapshot;
  final bool masterEnabled;
  final Map<String, _CategoryState> categories;
  final String? expandedCategoryId;
  final String? playingPreviewId;
  final ValueChanged<String> onToggleCategory;
  final ValueChanged<String> onExpandCategory;
  final void Function(String id, String soundType) onSoundType;
  final void Function(String id, double volume) onVolume;
  final ValueChanged<String> onPreview;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: LaunchpadNotifSoundPage.categoriesKey,
      label: 'Âm thanh theo loại',
      accentColor: AppModuleAccents.launchpad,
      children: [
        Column(
          children: [
            for (var i = 0; i < snapshot.categories.length; i++) ...[
              _CategoryCard(
                category: snapshot.categories[i],
                soundTypes: snapshot.soundTypes,
                state: categories[snapshot.categories[i].id]!,
                masterEnabled: masterEnabled,
                expanded: expandedCategoryId == snapshot.categories[i].id,
                playingPreview: playingPreviewId == snapshot.categories[i].id,
                onToggle: () => onToggleCategory(snapshot.categories[i].id),
                onExpand: () => onExpandCategory(snapshot.categories[i].id),
                onSoundType: (soundType) =>
                    onSoundType(snapshot.categories[i].id, soundType),
                onVolume: (value) => onVolume(snapshot.categories[i].id, value),
                onPreview: () => onPreview(snapshot.categories[i].id),
              ),
              if (i != snapshot.categories.length - 1)
                const SizedBox(height: AppSpacing.rowGap),
            ],
          ],
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.soundTypes,
    required this.state,
    required this.masterEnabled,
    required this.expanded,
    required this.playingPreview,
    required this.onToggle,
    required this.onExpand,
    required this.onSoundType,
    required this.onVolume,
    required this.onPreview,
  });

  final LaunchpadNotifSoundCategoryDraft category;
  final List<LaunchpadSoundTypeDraft> soundTypes;
  final _CategoryState state;
  final bool masterEnabled;
  final bool expanded;
  final bool playingPreview;
  final VoidCallback onToggle;
  final VoidCallback onExpand;
  final ValueChanged<String> onSoundType;
  final ValueChanged<double> onVolume;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final enabled = state.enabled && masterEnabled;
    return VitCard(
      key: LaunchpadNotifSoundPage.categoryKey(category.id),
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          Padding(
            padding: LaunchpadSpacingTokens.launchpadPaddingX4,
            child: Row(
              children: [
                VitAccentIconBox(
                  icon: _categoryIcon(category.iconKey),
                  color: category.accent.resolve(),
                  iconSize: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.label,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        category.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                _SoundSwitch(
                  key: LaunchpadNotifSoundPage.toggleKey(category.id),
                  enabled: enabled,
                  onTap: onToggle,
                  small: true,
                ),
                const SizedBox(width: AppSpacing.x2),
                VitIconButton(
                  key: LaunchpadNotifSoundPage.expandKey(category.id),
                  onPressed: onExpand,
                  icon: expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  tooltip: expanded ? 'Thu gon danh muc' : 'Mo danh muc',
                  variant: VitIconButtonVariant.transparent,
                  size: VitIconButtonSize.sm,
                ),
              ],
            ),
          ),
          if (expanded)
            _ExpandedCategorySettings(
              category: category,
              soundTypes: soundTypes,
              state: state,
              playingPreview: playingPreview,
              onSoundType: onSoundType,
              onVolume: onVolume,
              onPreview: onPreview,
            ),
        ],
      ),
    );
  }
}

class _ExpandedCategorySettings extends StatelessWidget {
  const _ExpandedCategorySettings({
    required this.category,
    required this.soundTypes,
    required this.state,
    required this.playingPreview,
    required this.onSoundType,
    required this.onVolume,
    required this.onPreview,
  });

  final LaunchpadNotifSoundCategoryDraft category;
  final List<LaunchpadSoundTypeDraft> soundTypes;
  final _CategoryState state;
  final bool playingPreview;
  final ValueChanged<String> onSoundType;
  final ValueChanged<double> onVolume;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          height: AppSpacing.dividerHairline,
          thickness: AppSpacing.dividerHairline,
          color: AppColors.divider,
        ),
        Padding(
          padding: LaunchpadSpacingTokens.launchpadPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Kiểu âm thanh',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  for (final soundType in soundTypes)
                    _SoundTypeChip(
                      categoryId: category.id,
                      soundType: soundType,
                      active: state.soundType == soundType.value,
                      accent: category.accent.resolve(),
                      onTap: () => onSoundType(soundType.value),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Âm lượng',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                  Text(
                    '${state.volume.round()}%',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: category.accent.resolve(),
                  inactiveTrackColor: AppColors.surface2,
                  thumbColor: category.accent.resolve(),
                  overlayColor: category.accent.resolve().withValues(
                    alpha: .12,
                  ),
                  trackHeight: LaunchpadSpacingTokens.launchpadGapXxs,
                ),
                child: Slider(
                  value: state.volume,
                  min: 0,
                  max: 100,
                  onChanged: onVolume,
                ),
              ),
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              VitCard(
                key: LaunchpadNotifSoundPage.previewKey(category.id),
                onTap: onPreview,
                variant: VitCardVariant.inner,
                radius: VitCardRadius.standard,
                height: AppSpacing.buttonCompact,
                padding: LaunchpadSpacingTokens.launchpadPaddingX4,
                child: Row(
                  children: [
                    Icon(
                      playingPreview
                          ? Icons.check_circle_outline_rounded
                          : Icons.play_arrow_rounded,
                      color: playingPreview
                          ? AppColors.buy
                          : category.accent.resolve(),
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Text(
                      playingPreview ? 'Đang phát...' : 'Nghe thử',
                      style: AppTextStyles.caption.copyWith(
                        color: playingPreview ? AppColors.buy : AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    if (playingPreview) ...[
                      const SizedBox(width: AppSpacing.x3),
                      for (var i = 0; i < 4; i++) ...[
                        const SizedBox(width: AppSpacing.x1),
                        Builder(
                          builder: (context) {
                            final barHeight =
                                LaunchpadSpacingTokens
                                    .launchpadSoundBarBaseHeight +
                                i *
                                    LaunchpadSpacingTokens
                                        .launchpadSoundBarHeightStep;
                            return SizedBox(
                              width: LaunchpadSpacingTokens
                                  .launchpadVerticalMarkerWidth,
                              height: barHeight,
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                  color: category.accent.resolve(),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: AppRadii.xsRadius,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
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

class _SoundTypeChip extends StatelessWidget {
  const _SoundTypeChip({
    required this.categoryId,
    required this.soundType,
    required this.active,
    required this.accent,
    required this.onTap,
  });

  final String categoryId;
  final LaunchpadSoundTypeDraft soundType;
  final bool active;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: LaunchpadNotifSoundPage.soundTypeKey(categoryId, soundType.value),
      label: soundType.label,
      selected: active,
      onTap: onTap,
      accentColor: accent,
      padding: LaunchpadSpacingTokens.launchpadPillPadding,
    );
  }
}
