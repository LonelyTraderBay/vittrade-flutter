part of '../phone/pages/route_checker_page.dart';

class _IntroBlock extends StatelessWidget {
  const _IntroBlock({required this.snapshot});

  final RouteCheckerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AdminSpacingTokens.devCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const VitAccentIconBox(
                icon: Icons.science_outlined,
                color: AppColors.buy,
                iconSize: AppSpacing.iconSm,
                bordered: false,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  snapshot.title,
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            snapshot.subtitle,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.testedCount, required this.totalCount});

  final int testedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final progress = totalCount == 0 ? 0.0 : testedCount / totalCount;

    return VitCard(
      padding: AdminSpacingTokens.devCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Testing Progress',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                '$testedCount / $totalCount',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: ColoredBox(
              color: AppColors.surface2,
              child: SizedBox(
                height: AppSpacing.pageRhythmStandardInnerGap,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress.clamp(0, 1),
                    child: const ColoredBox(color: AppColors.buy),
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

class _PhaseFilters extends StatelessWidget {
  const _PhaseFilters({
    required this.snapshot,
    required this.activePhase,
    required this.onChanged,
  });

  final RouteCheckerSnapshot snapshot;
  final int? activePhase;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: [
          _PhaseChip(
            key: RouteChecker.phaseKey(null),
            label: 'All (${snapshot.totalRoutes})',
            selected: activePhase == null,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: AppSpacing.x3),
          for (final phase in snapshot.phases) ...[
            _PhaseChip(
              key: RouteChecker.phaseKey(phase),
              label: 'Phase $phase (${snapshot.phaseTotal(phase)})',
              selected: activePhase == phase,
              onTap: () => onChanged(phase),
            ),
            if (phase != snapshot.phases.last)
              const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _PhaseChip extends StatelessWidget {
  const _PhaseChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: selected,
      onTap: onTap,
      accentColor: AppColors.primary,
      padding: AdminSpacingTokens.devWideChipPadding,
    );
  }
}

class _RouteList extends StatelessWidget {
  const _RouteList({
    required this.routes,
    required this.testedRoutes,
    required this.onTapRoute,
  });

  final List<DevRouteDraft> routes;
  final Set<String> testedRoutes;
  final ValueChanged<DevRouteDraft> onTapRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final route in routes) ...[
          _RouteCard(
            route: route,
            tested: testedRoutes.contains(route.path),
            onTap: () => onTapRoute(route),
          ),
          if (route != routes.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.route,
    required this.tested,
    required this.onTap,
  });

  final DevRouteDraft route;
  final bool tested;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: RouteChecker.routeKey(route.path),
      padding: AdminSpacingTokens.devCardPadding,
      radius: VitCardRadius.large,
      borderColor: tested ? AppColors.buy20 : AppColors.borderSolid,
      onTap: onTap,
      child: Row(
        children: [
          tested
              ? const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconMd,
                )
              : const SizedBox.square(
                  dimension: AppSpacing.iconMd,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      shape: CircleBorder(
                        side: BorderSide(color: AppColors.primary40),
                      ),
                    ),
                  ),
                ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  children: [
                    Text(
                      route.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    if (route.featured) const _FeaturedBadge(),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  route.path,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _PhaseBadge(phase: route.phase),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.open_in_new_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _FeaturedBadge extends StatelessWidget {
  const _FeaturedBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.warn10,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AdminSpacingTokens.devInlinePillPadding,
        child: Text(
          'FEATURED',
          style: AppTextStyles.chartLabelTiny.copyWith(
            color: AppColors.warn,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _PhaseBadge extends StatelessWidget {
  const _PhaseBadge({required this.phase});

  final int phase;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
      ),
      child: Padding(
        padding: AdminSpacingTokens.devChipPadding,
        child: Text(
          'Phase $phase',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ),
    );
  }
}
