part of '../../phone/pages/hub/predictions_breaking_page.dart';

class _MovementSummary extends StatelessWidget {
  const _MovementSummary({required this.snapshot});

  final PredictionBreakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.inputRadius,
      child: Padding(
        padding: PredictionsSpacingTokens.predictionHomeCategoryPadding,
        child: Row(
          children: [
            const Icon(
              Icons.bolt_outlined,
              color: AppColors.warn,
              size: PredictionsSpacingTokens.predictionHomeHighlightIcon,
            ),
            const SizedBox(width: _breakingSpace),
            Expanded(
              child: Text(
                'Biến động 24h',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            _MovementCount(
              icon: Icons.trending_up_rounded,
              label: '${snapshot.upCount} tăng',
              color: AppColors.buy,
            ),
            const SizedBox(width: _breakingSpace),
            _MovementCount(
              icon: Icons.trending_down_rounded,
              label: '${snapshot.downCount} giảm',
              color: AppColors.sell,
            ),
          ],
        ),
      ),
    );
  }
}

class _MovementCount extends StatelessWidget {
  const _MovementCount({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSpacing.x3),
        const SizedBox(width: _breakingTinySpace),
        Text(
          label,
          style: AppTextStyles.badge.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String? activeCategory;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (id: null, label: 'Tất cả', key: PredictionsBreakingPage.allTabKey),
      for (final category in categories)
        (
          id: category,
          label: category == 'Live Crypto' ? 'Crypto' : category,
          key: category == 'Live Crypto'
              ? PredictionsBreakingPage.cryptoTabKey
              : Key('sc029_category_$category'),
        ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < tabs.length; index += 1) ...[
            _CategoryTabButton(
              key: tabs[index].key,
              label: tabs[index].label,
              active: activeCategory == tabs[index].id,
              onTap: () => onSelected(tabs[index].id),
            ),
            if (index != tabs.length - 1)
              const SizedBox(width: _breakingTinySpace),
          ],
        ],
      ),
    );
  }
}

class _CategoryTabButton extends StatelessWidget {
  const _CategoryTabButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: _predictionPrimary,
      padding: PredictionsSpacingTokens.predictionHomeCategoryPadding,
    );
  }
}

class _MoverCard extends StatelessWidget {
  const _MoverCard({
    super.key,
    required this.event,
    required this.rank,
    required this.onTap,
  });

  final PredictionEventDraft event;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final topOutcome = event.outcomes.first;
    final isUp = event.change24h > 0;
    final rankColor = switch (rank) {
      1 => AppColors.warn,
      2 => AppColors.medalSilverBlue,
      3 => AppColors.medalBronze,
      _ => AppColors.text3,
    };
    final changeColor = isUp ? AppColors.buy : AppColors.sell;

    return VitCard(
      onTap: onTap,
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: rank <= 3
                ? rankColor.withValues(alpha: .12)
                : AppColors.surface2,
            borderRadius: AppRadii.smRadius,
            child: SizedBox.square(
              dimension: _breakingRankBox,
              child: Center(
                child: Text(
                  '$rank',
                  style: AppTextStyles.caption.copyWith(
                    color: rankColor,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: _breakingSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _breakingTinySpace),
                Wrap(
                  spacing: _breakingTinySpace,
                  runSpacing: _breakingTinySpace,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Yes: ',
                        style: AppTextStyles.numericMicro.copyWith(
                          color: AppColors.text2,
                        ),
                        children: [
                          TextSpan(
                            text: '${topOutcome.chance}%',
                            style: AppTextStyles.numericMicro.copyWith(
                              color: topOutcome.chance >= 50
                                  ? AppColors.buy
                                  : AppColors.sell,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _ChangeBadge(value: event.change24h, color: changeColor),
                  ],
                ),
                const SizedBox(height: _breakingTinySpace),
                Wrap(
                  spacing: _breakingTinySpace,
                  runSpacing: _breakingTinySpace,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _TinyBadge(event.category),
                    _MetaIcon(
                      icon: Icons.bar_chart_rounded,
                      label: _formatVolume(event.volume24h),
                    ),
                    _MetaIcon(
                      icon: Icons.schedule_rounded,
                      label: predictionsTimeRemaining(event.endDate),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  const _ChangeBadge({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isUp = value > 0;
    return Material(
      color: color.withValues(alpha: .14),
      borderRadius: AppRadii.badgeRadius,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isUp ? Icons.arrow_outward_rounded : Icons.south_east_rounded,
              size: AppSpacing.x3,
              color: color,
            ),
            const SizedBox(width: _breakingTinySpace),
            Text(
              VitFormat.signedPercent(value),
              style: AppTextStyles.badge.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _predictionPrimary.withValues(alpha: .14),
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.numericMicro.copyWith(
            color: _predictionPrimary,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _MetaIcon extends StatelessWidget {
  const _MetaIcon({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.text3, size: AppSpacing.x3),
        const SizedBox(width: _breakingTinySpace),
        Text(
          label,
          style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}
