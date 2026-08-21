import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/home_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_products_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

// Mirrors the loaded monitor-first dashboard — banner: KPI strip; primary:
// the dense watchlist; sidebar: notice line, next action, quick actions,
// recent, discovery — through the same shared scaffold, so resolving data
// never reflows the page shape (including the single-column → two-column
// switch at the dashboard's own threshold).
class HomeLoadingContent extends StatelessWidget {
  const HomeLoadingContent({super.key, this.onRefresh});

  final RefreshCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return VitTwoColumnTabletDashboard(
      banner: const HomeKpiStripSkeleton(),
      onRefresh: onRefresh,
      primaryChildren: const [HomeMarketSkeleton()],
      secondaryChildren: const [
        HomeAnnouncementSkeleton(),
        HomeNextActionSkeleton(),
        HomeProductsSkeleton(),
        HomeRecentProductsSkeleton(),
        HomeDiscoverySkeleton(),
      ],
      primaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
      secondaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
    );
  }
}

class HomeErrorContent extends StatelessWidget {
  const HomeErrorContent({super.key, required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return VitInsetScrollView(
      key: HomeTabletKeys.content,
      physics: const AlwaysScrollableScrollPhysics(),
      child: VitErrorState(
        title: 'Không tải được dữ liệu',
        message: 'Vui lòng kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: () => onRetry(),
      ),
    );
  }
}

/// Mirrors the loaded KPI strip banner: one wide card holding the four KPI
/// blocks (balance, PnL, 7-day trend, wallet breakdown) plus the trailing
/// Nạp/Rút/Ví action toolbar. Bars inside the flex blocks stretch
/// (`double.infinity`) so the skeleton never overflows the narrow
/// single-column fallback width.
class HomeKpiStripSkeleton extends StatelessWidget {
  const HomeKpiStripSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      padding: SharedSpacingTokens.homeCardPaddingDefault,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: _labelValuePair(valueHeight: AppSpacing.x6)),
          const SizedBox(width: AppSpacing.x3),
          Expanded(flex: 3, child: _labelValuePair(valueHeight: AppSpacing.x5)),
          const SizedBox(width: AppSpacing.x3),
          const Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VitSkeleton(
                  width: double.infinity,
                  height: HomeSpacingTokens.skeletonLineHeightLg,
                ),
                SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                VitSkeleton(
                  width: double.infinity,
                  height: SharedSpacingTokens.homeSparklineHeight,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VitSkeleton(
                  width: double.infinity,
                  height: HomeSpacingTokens.skeletonLineHeightLg,
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                for (var i = 0; i < 3; i++) ...[
                  const VitSkeleton(
                    width: double.infinity,
                    height: HomeSpacingTokens.skeletonLineHeightSm,
                  ),
                  if (i < 2)
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(width: HomeSpacingTokens.homePortfolioActionSpacing),
          const _KpiActionsSkeleton(),
        ],
      ),
    );
  }

  Widget _labelValuePair({required double valueHeight}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VitSkeleton(
          width: double.infinity,
          height: HomeSpacingTokens.skeletonLineHeightLg,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitSkeleton(width: double.infinity, height: valueHeight),
      ],
    );
  }
}

/// Three compact button ghosts — same count and height class as the loaded
/// strip's toolbar (`buttonCompact + x3`, see `HomeTabletKpiStrip`).
class _KpiActionsSkeleton extends StatelessWidget {
  const _KpiActionsSkeleton();

  @override
  Widget build(BuildContext context) {
    const buttonGhost = VitSkeleton(
      width: 64,
      height: AppSpacing.buttonCompact + AppSpacing.x3,
      borderRadius: AppRadii.cardRadius,
    );
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        buttonGhost,
        SizedBox(width: HomeSpacingTokens.homePortfolioActionSpacing),
        buttonGhost,
        SizedBox(width: HomeSpacingTokens.homePortfolioActionSpacing),
        buttonGhost,
      ],
    );
  }
}

class HomeNextActionSkeleton extends StatelessWidget {
  const HomeNextActionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSkeleton(
          width: HomeSpacingTokens.skeletonSubtitleWidth,
          height: AppSpacing.x4,
        ),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(
          padding: EdgeInsetsDirectional.all(
            SharedSpacingTokens.homeNextActionCardPadding,
          ),
          child: Row(
            children: [
              VitSkeleton(
                width: SharedSpacingTokens.homeNextActionIconContainer,
                height: SharedSpacingTokens.homeNextActionIconContainer,
                borderRadius: AppRadii.smRadius,
              ),
              SizedBox(width: SharedSpacingTokens.homeCommandRowSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VitSkeleton(
                      width: HomeSpacingTokens.skeletonTitleWidth,
                      height: HomeSpacingTokens.skeletonLineHeightLg,
                    ),
                    SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                    VitSkeleton(
                      width: HomeSpacingTokens.skeletonLineWidthLg,
                      height: HomeSpacingTokens.skeletonLineHeightSm,
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

/// Sidebar grid skeleton: mirrors the loaded 3-column × 3-row capacity.
class HomeProductsSkeleton extends StatelessWidget {
  const HomeProductsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSkeleton(
          width: HomeSpacingTokens.skeletonSubtitleWidth,
          height: AppSpacing.x4,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitActionTileGrid(
          density: VitDensity.standard,
          itemCount: HomeProductsSection.gridCapacity,
          crossAxisCount: 3,
          itemBuilder: (context, index, tileDensity) => const VitSkeleton(
            width: double.infinity,
            height: double.infinity,
            borderRadius: AppRadii.cardRadius,
          ),
        ),
      ],
    );
  }
}

/// Mirrors the loaded «Gần đây» card: three vertical icon rows (the mock
/// catalog's size), each an accent-icon box plus a two-line text column.
class HomeRecentProductsSkeleton extends StatelessWidget {
  const HomeRecentProductsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSkeleton(
          width: HomeSpacingTokens.skeletonSubtitleWidth,
          height: AppSpacing.x4,
        ),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(
          child: Column(
            children: [
              _HomeRecentProductRowSkeleton(),
              _HomeRecentProductRowSkeleton(),
              _HomeRecentProductRowSkeleton(),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeRecentProductRowSkeleton extends StatelessWidget {
  const _HomeRecentProductRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: HomeSpacingTokens.homeListRowPadding,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        children: [
          VitSkeleton(
            width: AppSpacing.accentIconBoxSize,
            height: AppSpacing.accentIconBoxSize,
            borderRadius: AppRadii.smRadius,
          ),
          SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VitSkeleton(
                  width: HomeSpacingTokens.skeletonTitleWidth,
                  height: HomeSpacingTokens.skeletonLineHeightLg,
                ),
                SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                VitSkeleton(
                  width: HomeSpacingTokens.skeletonSubtitleWidth,
                  height: HomeSpacingTokens.skeletonLineHeightSm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mirrors the compact announcement banner card (icon + single-line message
/// + dismiss affordance). The loaded banner's carousel-dots row (~one x3
/// gap tall) is intentionally not mirrored — that delta is absorbed by the
/// section gap.
class HomeAnnouncementSkeleton extends StatelessWidget {
  const HomeAnnouncementSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const VitCard(
      radius: VitCardRadius.standard,
      padding: SharedSpacingTokens.homeAnnouncementCardPaddingCompact,
      child: Row(
        children: [
          VitSkeleton(
            width: SharedSpacingTokens.homeAnnouncementIcon,
            height: SharedSpacingTokens.homeAnnouncementIcon,
            borderRadius: AppRadii.smRadius,
          ),
          SizedBox(width: SharedSpacingTokens.homeAnnouncementIconGap),
          Expanded(
            child: VitSkeleton(
              width: double.infinity,
              height: HomeSpacingTokens.skeletonLineHeightLg,
            ),
          ),
          SizedBox(width: SharedSpacingTokens.homeAnnouncementArrowGap),
          VitSkeleton(
            width: SharedSpacingTokens.homeAnnouncementChevron,
            height: SharedSpacingTokens.homeAnnouncementChevron,
            borderRadius: AppRadii.smRadius,
          ),
        ],
      ),
    );
  }
}

/// Mirrors the loaded discovery card: section header + ONE framed card
/// holding two discovery rows and the disclaimer line.
class HomeDiscoverySkeleton extends StatelessWidget {
  const HomeDiscoverySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSkeleton(
          width: HomeSpacingTokens.skeletonSubtitleWidth,
          height: AppSpacing.x4,
        ),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(
          child: Column(
            children: [
              _HomeDiscoveryRowSkeleton(),
              _HomeDiscoveryRowSkeleton(),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeDiscoveryRowSkeleton extends StatelessWidget {
  const _HomeDiscoveryRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: HomeSpacingTokens.homeListRowPadding,
        vertical: AppSpacing.x4,
      ),
      child: Row(
        children: [
          VitSkeleton(
            width: AppSpacing.accentIconBoxSize,
            height: AppSpacing.accentIconBoxSize,
            borderRadius: AppRadii.smRadius,
          ),
          SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VitSkeleton(
                  width: HomeSpacingTokens.skeletonSubtitleWidth,
                  height: HomeSpacingTokens.skeletonLineHeightLg,
                ),
                SizedBox(height: AppSpacing.x1),
                VitSkeleton(
                  width: HomeSpacingTokens.skeletonLineWidthLg,
                  height: HomeSpacingTokens.skeletonLineHeightSm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeMarketSkeleton extends StatelessWidget {
  const HomeMarketSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSkeleton(
          width: HomeSpacingTokens.skeletonSubtitleWidth,
          height: AppSpacing.x4,
        ),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitSkeletonList(rows: 3),
      ],
    );
  }
}
