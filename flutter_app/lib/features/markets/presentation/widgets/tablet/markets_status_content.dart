import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Mirrors the loaded Markets terminal master-detail — master list: search +
/// chips + compact pair rows; overview pane: pulse strip card + movers,
/// tools, discover sections — so resolving data never reflows the page
/// shape (skeleton-mirrors-page discipline).
class MarketsLoadingContent extends StatelessWidget {
  const MarketsLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const VitInsetScrollView(
      child: VitPageContent(
        // Mirror trang đã load: tab root ⇒ compact (Page-Rhythm).
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.compact,
        // Mirror đúng trang đã load: gutter-flush + density compact (S6).
        density: VitDensity.compact,
        fullBleed: true,
        children: [
          _PulseStripSkeleton(),
          _MoverStripSkeleton(),
          _ToolsSkeleton(),
          _DiscoverSkeleton(),
        ],
      ),
    );
  }
}

/// Master-list skeleton: search bar + chips row + sort header + vài hàng
/// cặp compact — mirror đúng `MarketsMasterList` đã load.
class MarketsMasterSkeleton extends StatelessWidget {
  const MarketsMasterSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Cuộn được ngay trong khung loading: ở khung tablet hẹp, master share
    // (flex5) không đủ chỗ cho đủ 6 hàng skeleton — skeleton phải co chứ
    // không tràn (skeleton-mirrors-page discipline).
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(TabletSpacingTokens.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const VitSkeleton(
              width: double.infinity,
              height: TabletSpacingTokens.buttonCompact,
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            const VitSkeleton(
              width: TabletSpacingTokens.x4,
              height: TabletSpacingTokens.buttonCompact,
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            const VitSkeleton(
              width: TabletSpacingTokens.x4,
              height: TabletSpacingTokens.x4,
            ),
            ...List<Widget>.generate(6, (_) => const _MasterRowSkeleton()),
          ],
        ),
      ),
    );
  }
}

/// Một hàng cặp compact skeleton: khoảng cách dọc + hàng 4 cụm flex.
class _MasterRowSkeleton extends StatelessWidget {
  const _MasterRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: TabletSpacingTokens.x4),
        Row(
          children: [
            VitSkeleton(width: 16, height: 16),
            SizedBox(width: TabletSpacingTokens.x4),
            VitSkeleton(width: 28, height: 28),
            SizedBox(width: TabletSpacingTokens.x4),
            Expanded(flex: 5, child: VitSkeleton(width: 90, height: 24)),
            Expanded(flex: 4, child: VitSkeleton(width: 72, height: 14)),
            Expanded(flex: 3, child: VitSkeleton(width: 44, height: 18)),
            Expanded(flex: 4, child: VitSkeleton(width: 64, height: 14)),
          ],
        ),
      ],
    );
  }
}

/// Overview pane mang full error state; cột master chỉ cần giữ nguyên khung
/// và báo ngắn gọn — idiom `_MasterMenuError` của Profile master shell.
class MarketsMasterError extends StatelessWidget {
  const MarketsMasterError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: VitEmptyState(
        title: 'Không tải được danh sách cặp',
        message: 'Kéo để làm mới ở phần tổng quan.',
        icon: Icons.search_off_rounded,
      ),
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
        SizedBox(height: TabletSpacingTokens.x4),
        VitSkeleton(width: double.infinity, height: 16),
        SizedBox(height: TabletSpacingTokens.x4),
        VitSkeleton(width: double.infinity, height: 10),
      ],
    );
    return const VitCard(
      radius: VitCardRadius.standard,
      clip: true,
      // Mirror card pulse đã load: cùng 8dp đều (CB-R7 — tường minh padding).
      padding: EdgeInsetsDirectional.all(TabletSpacingTokens.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: block),
          SizedBox(width: TabletSpacingTokens.x4),
          Expanded(flex: 3, child: block),
          SizedBox(width: TabletSpacingTokens.x4),
          Expanded(flex: 2, child: block),
          SizedBox(width: TabletSpacingTokens.x4),
          Expanded(flex: 2, child: block),
          SizedBox(width: TabletSpacingTokens.x4),
          Expanded(flex: 2, child: block),
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSkeleton(width: 140, height: TabletSpacingTokens.x4),
        SizedBox(height: TabletSpacingTokens.x4),
        // Mirror movers strip đã load: card tight + 8dp đều.
        VitCard(
          radius: VitCardRadius.tight,
          padding: EdgeInsetsDirectional.all(TabletSpacingTokens.x3),
          child: VitSkeletonList(rows: 4),
        ),
      ],
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
        VitSkeleton(width: 120, height: TabletSpacingTokens.x4),
        SizedBox(height: TabletSpacingTokens.x4),
        VitCard(
          padding: TabletSpacingTokens.zeroInsets,
          child: VitSkeletonList(rows: 2),
        ),
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
        VitSkeleton(width: 140, height: TabletSpacingTokens.x4),
        SizedBox(height: TabletSpacingTokens.x4),
        // Mirror discover card đã load: khung clip zero-inset tường minh.
        VitCard(
          clip: true,
          padding: TabletSpacingTokens.zeroInsets,
          child: VitSkeletonList(rows: 2),
        ),
      ],
    );
  }
}
