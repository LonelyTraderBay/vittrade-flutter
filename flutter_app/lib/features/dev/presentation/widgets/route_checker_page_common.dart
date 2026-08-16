part of '../phone/pages/route_checker_page.dart';

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({
    required this.testedCount,
    required this.totalCount,
    required this.onReset,
  });

  final int testedCount;
  final int totalCount;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final complete = testedCount == totalCount;

    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: RouteChecker.resetButtonKey,
            onPressed: onReset,
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.buttonCompact,
            padding: AdminSpacingTokens.devVerticalPaddingX4,
            child: const Text('Reset Tests', textAlign: TextAlign.center),
          ),
        ),
        if (complete) ...[
          const SizedBox(width: AppSpacing.x3),
          const Expanded(
            child: Center(
              child: VitAccentPill(
                label: 'All Routes Tested',
                accentColor: AppColors.buy,
                semanticStatus: VitStatusPillStatus.success,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PhaseStats extends StatelessWidget {
  const _PhaseStats({required this.snapshot, required this.testedRoutes});

  final RouteCheckerSnapshot snapshot;
  final Set<String> testedRoutes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AdminSpacingTokens.devCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stats by Phase',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          GridView.count(
            crossAxisCount: AdminSpacingTokens.devRouteGridColumns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.x3,
            crossAxisSpacing: AppSpacing.x3,
            childAspectRatio: AdminSpacingTokens.devRouteGridAspect,
            children: [
              for (final phase in snapshot.phases)
                _PhaseStatTile(
                  phase: phase,
                  total: snapshot.phaseTotal(phase),
                  tested: snapshot.routes
                      .where(
                        (route) =>
                            route.phase == phase &&
                            testedRoutes.contains(route.path),
                      )
                      .length,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhaseStatTile extends StatelessWidget {
  const _PhaseStatTile({
    required this.phase,
    required this.total,
    required this.tested,
  });

  final int phase;
  final int total;
  final int tested;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : tested / total;

    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: AdminSpacingTokens.devTinyPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Phase $phase',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              '$tested/$total',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            ClipRRect(
              borderRadius: AppRadii.xlRadius,
              child: ColoredBox(
                color: AppColors.bg,
                child: SizedBox(
                  height: AppSpacing.x1,
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
      ),
    );
  }
}

class _InternalNotice extends StatelessWidget {
  const _InternalNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AdminSpacingTokens.devCompactPadding,
      borderColor: AppColors.primary20,
      background: const ColoredBox(color: AppColors.primary08),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.admin_panel_settings_outlined,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}
