import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Mirrors the loaded Trade dashboard — banner: ticker strip; primary:
/// product tabs + order form + risk panel; sidebar: next-action nudge and
/// positions — through the same shared scaffold, so resolving data never
/// reflows the page shape (including the single-column → two-column switch
/// at the dashboard's own threshold).
class TradeLoadingContent extends StatelessWidget {
  const TradeLoadingContent({super.key, this.onRefresh});

  final RefreshCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return VitTwoColumnTabletDashboard(
      banner: const _TickerStripSkeleton(),
      onRefresh: onRefresh,
      primaryChildren: const [
        _ProductTabsSkeleton(),
        SizedBox(height: AppSpacing.pageRhythmCompactSectionGap),
        VitCard(child: _OrderFormSkeleton()),
        SizedBox(height: AppSpacing.pageRhythmCompactSectionGap),
        _RiskPanelSkeleton(),
      ],
      secondaryChildren: const [
        _SidebarHeadingSkeleton(),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(child: VitSkeletonList(rows: 2)),
        SizedBox(height: AppSpacing.pageRhythmCompactSectionGap),
        _SidebarHeadingSkeleton(),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(child: VitSkeletonList(rows: 3)),
      ],
      primaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
      secondaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
    );
  }
}

/// One wide card: symbol block + the price/metrics row + balance block.
class _TickerStripSkeleton extends StatelessWidget {
  const _TickerStripSkeleton();

  @override
  Widget build(BuildContext context) {
    const block = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VitSkeleton(width: double.infinity, height: 12),
        SizedBox(height: AppSpacing.x1),
        VitSkeleton(width: double.infinity, height: 16),
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
          Expanded(flex: 6, child: block),
          SizedBox(width: AppSpacing.x3),
          Expanded(flex: 3, child: block),
        ],
      ),
    );
  }
}

/// Mirrors the product-switch tab row the order column starts with.
class _ProductTabsSkeleton extends StatelessWidget {
  const _ProductTabsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        VitSkeleton(width: 96, height: AppSpacing.buttonCompact),
        SizedBox(width: AppSpacing.x2),
        VitSkeleton(width: 72, height: AppSpacing.buttonCompact),
        SizedBox(width: AppSpacing.x2),
        VitSkeleton(width: 72, height: AppSpacing.buttonCompact),
      ],
    );
  }
}

/// Side switch + amount field + percent row + submit button ghosts.
class _OrderFormSkeleton extends StatelessWidget {
  const _OrderFormSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: VitSkeleton(
                width: double.infinity,
                height: AppSpacing.buttonCompact,
              ),
            ),
            SizedBox(width: AppSpacing.x2),
            Expanded(
              child: VitSkeleton(
                width: double.infinity,
                height: AppSpacing.buttonCompact,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitSkeleton(width: double.infinity, height: AppSpacing.x7),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Row(
          children: [
            VitSkeleton(width: 56, height: AppSpacing.buttonCompact),
            SizedBox(width: AppSpacing.x2),
            VitSkeleton(width: 56, height: AppSpacing.buttonCompact),
            SizedBox(width: AppSpacing.x2),
            VitSkeleton(width: 56, height: AppSpacing.buttonCompact),
          ],
        ),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitSkeleton(
          width: double.infinity,
          height: AppSpacing.x6 + AppSpacing.x3,
        ),
      ],
    );
  }
}

/// Same card shape the «Đánh giá rủi ro» section renders into.
class _RiskPanelSkeleton extends StatelessWidget {
  const _RiskPanelSkeleton();

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

class _SidebarHeadingSkeleton extends StatelessWidget {
  const _SidebarHeadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return const VitSkeleton(width: 100, height: AppSpacing.x4);
  }
}
