import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Mirrors the loaded Markets dashboard — banner: market pulse strip;
/// primary: search + category tabs + the pair table; sidebar: movers,
/// tools, discover — through the same shared scaffold, so resolving data
/// never reflows the page shape (including the single-column → two-column
/// switch at the dashboard's own threshold).
class MarketsLoadingContent extends StatelessWidget {
  const MarketsLoadingContent({super.key, this.onRefresh});

  final RefreshCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return VitTwoColumnTabletDashboard(
      banner: const _PulseStripSkeleton(),
      onRefresh: onRefresh,
      primaryChildren: const [
        VitSkeleton(width: double.infinity, height: AppSpacing.buttonCompact),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _PairTableSkeleton(),
      ],
      secondaryChildren: const [
        _MoverStripSkeleton(),
        SizedBox(height: AppSpacing.pageRhythmCompactSectionGap),
        _ToolsSkeleton(),
        SizedBox(height: AppSpacing.pageRhythmCompactSectionGap),
        _DiscoverSkeleton(),
      ],
      primaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
      secondaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
    );
  }
}

/// One wide card holding the five pulse metric blocks.
class _PulseStripSkeleton extends StatelessWidget {
  const _PulseStripSkeleton();

  @override
  Widget build(BuildContext context) {
    const block = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VitSkeleton(width: double.infinity, height: 14),
        SizedBox(height: AppSpacing.x1),
        VitSkeleton(width: double.infinity, height: 16),
        SizedBox(height: AppSpacing.x1),
        VitSkeleton(width: double.infinity, height: 10),
      ],
    );
    return const VitCard(
      radius: VitCardRadius.standard,
      clip: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: block),
          SizedBox(width: AppSpacing.x3),
          Expanded(flex: 3, child: block),
          SizedBox(width: AppSpacing.x3),
          Expanded(flex: 2, child: block),
          SizedBox(width: AppSpacing.x3),
          Expanded(flex: 2, child: block),
          SizedBox(width: AppSpacing.x3),
          Expanded(flex: 2, child: block),
        ],
      ),
    );
  }
}

/// Table header row + the first few pair rows, all in one clipped card.
class _PairTableSkeleton extends StatelessWidget {
  const _PairTableSkeleton();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x2,
            ),
            child: Row(
              children: [
                VitSkeleton(width: 16, height: 12),
                SizedBox(width: AppSpacing.x3),
                Expanded(flex: 5, child: VitSkeleton(width: 80, height: 12)),
                Expanded(flex: 4, child: VitSkeleton(width: 64, height: 12)),
                Expanded(flex: 3, child: VitSkeleton(width: 40, height: 12)),
                Expanded(flex: 4, child: VitSkeleton(width: 56, height: 12)),
                Expanded(flex: 3, child: VitSkeleton(width: 40, height: 12)),
                Expanded(flex: 3, child: VitSkeleton(width: 40, height: 12)),
                SizedBox(width: AppSpacing.x7),
              ],
            ),
          ),
          for (var i = 0; i < 6; i++) ...[
            const Divider(height: AppSpacing.dividerHairline),
            const Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x3,
              ),
              child: Row(
                children: [
                  VitSkeleton(width: 16, height: 16),
                  SizedBox(width: AppSpacing.x2),
                  VitSkeleton(width: 28, height: 28),
                  SizedBox(width: AppSpacing.x3),
                  Expanded(flex: 5, child: VitSkeleton(width: 90, height: 24)),
                  Expanded(flex: 4, child: VitSkeleton(width: 72, height: 14)),
                  Expanded(flex: 3, child: VitSkeleton(width: 44, height: 18)),
                  Expanded(flex: 4, child: VitSkeleton(width: 64, height: 14)),
                  Expanded(flex: 3, child: VitSkeleton(width: 48, height: 14)),
                  Expanded(flex: 3, child: VitSkeleton(width: 44, height: 14)),
                  SizedBox(
                    width: AppSpacing.x7,
                    height: AppSpacing.x5 + AppSpacing.x2,
                    child: VitSkeleton(
                      width: double.infinity,
                      height: AppSpacing.x5 + AppSpacing.x2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Mirrors the movers strip: one short card split by a center divider.
class _MoverStripSkeleton extends StatelessWidget {
  const _MoverStripSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppSpacing.buttonCompact,
      child: VitCard(
        child: VitSkeleton(
          width: double.infinity,
          height: AppSpacing.buttonCompact,
        ),
      ),
    );
  }
}

/// Section title + the wrapped tool chips block.
class _ToolsSkeleton extends StatelessWidget {
  const _ToolsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSkeleton(width: 120, height: AppSpacing.x4),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(child: VitSkeletonList(rows: 2)),
      ],
    );
  }
}

/// Section title + the two discovery rows card.
class _DiscoverSkeleton extends StatelessWidget {
  const _DiscoverSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSkeleton(width: 140, height: AppSpacing.x4),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(child: VitSkeletonList(rows: 2)),
      ],
    );
  }
}
