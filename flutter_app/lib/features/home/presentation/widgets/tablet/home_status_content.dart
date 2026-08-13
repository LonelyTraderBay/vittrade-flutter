import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/home_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

// Mirrors the loaded page's block order (portfolio, next action, products
// grid, recent products, market) so the first paint doesn't pop/reflow once
// data resolves.
class HomeLoadingContent extends StatelessWidget {
  const HomeLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const VitPageContent(
      padding: VitContentPadding.compact,
      rhythm: VitPageRhythm.compact,
      children: [
        HomePortfolioSkeleton(),
        HomeNextActionSkeleton(),
        HomeProductsSkeleton(),
        HomeRecentProductsSkeleton(),
        HomeMarketSkeleton(),
      ],
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

class HomePortfolioSkeleton extends StatelessWidget {
  const HomePortfolioSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const VitCard(
      radius: VitCardRadius.large,
      padding: SharedSpacingTokens.homeCardPaddingDefault,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitSkeleton(
            width: HomeSpacingTokens.skeletonTitleWidth,
            height: AppSpacing.x3,
          ),
          SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitSkeleton(width: double.infinity, height: AppSpacing.x6),
          SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitSkeleton(
            width: HomeSpacingTokens.skeletonSubtitleWidth,
            height: AppSpacing.x3,
          ),
        ],
      ),
    );
  }
}

class HomeNextActionSkeleton extends StatelessWidget {
  const HomeNextActionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const VitCard(
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
    );
  }
}

class HomeProductsSkeleton extends StatelessWidget {
  const HomeProductsSkeleton({
    super.key,
    this.crossAxisCount = AppSpacing.serviceTileCrossAxisCount,
  });

  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return VitActionTileGrid(
      density: VitDensity.compact,
      itemCount: HomeSpacingTokens.homeQuickActionCompactCount,
      crossAxisCount: crossAxisCount,
      itemBuilder: (context, index, tileDensity) => const VitSkeleton(
        width: double.infinity,
        height: double.infinity,
        borderRadius: AppRadii.cardRadius,
      ),
    );
  }
}

class HomeRecentProductsSkeleton extends StatelessWidget {
  const HomeRecentProductsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: SharedSpacingTokens.homeRecentProductHeight,
      child: Row(
        children: [
          Expanded(
            child: VitSkeleton(
              width: double.infinity,
              height: double.infinity,
              borderRadius: AppRadii.cardRadius,
            ),
          ),
          SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitSkeleton(
              width: double.infinity,
              height: double.infinity,
              borderRadius: AppRadii.cardRadius,
            ),
          ),
          SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitSkeleton(
              width: double.infinity,
              height: double.infinity,
              borderRadius: AppRadii.cardRadius,
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
