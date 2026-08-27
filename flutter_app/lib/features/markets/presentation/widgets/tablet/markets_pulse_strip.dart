import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Market-pulse banner — section mở đầu của pane tổng quan SC-008 tablet
/// (section đầu trong danh sách children có nhịp của overview pane, terminal
/// master-detail). Aggregates the same `snapshot.marketPairs` the pair
/// table renders — total market cap, 24h volume, the gainers/losers split
/// and the session's top mover on each side — so the tablet opens with a
/// one-line market overview before the user scans the dense table below.
/// Same KPI-strip idiom as the Home tablet's portfolio banner: horizontal
/// metric blocks, hairline dividers, reflow to two rows below
/// [_compactBreakpoint] (the single-column fallback width).
class MarketsPulseStrip extends StatelessWidget {
  const MarketsPulseStrip({
    super.key,
    required this.pairs,
    required this.lastUpdatedLabel,
  });

  final List<MarketPair> pairs;
  final String lastUpdatedLabel;

  /// Below this width (the dashboard's single-column fallback territory)
  /// the strip reflows into two rows — breadth metrics first, top movers
  /// below — mirroring `HomeTabletKpiStrip`'s own compact reflow.
  static const double _compactBreakpoint = 760;

  @override
  Widget build(BuildContext context) {
    if (pairs.isEmpty) return const SizedBox.shrink();

    final aggregate = _aggregate(pairs);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < _compactBreakpoint;
        return _buildStrip(context, aggregate, compact: compact);
      },
    );
  }

  Widget _buildStrip(
    BuildContext context,
    _MarketPulse aggregate, {
    required bool compact,
  }) {
    final capBlock = Expanded(
      flex: 3,
      child: _PulseBlock(
        label: 'Vốn hóa thị trường',
        value: marketListFormatMarketCap(aggregate.marketCap),
        subline: 'Cập nhật $lastUpdatedLabel',
      ),
    );
    final volumeBlock = Expanded(
      flex: 3,
      child: _PulseBlock(
        label: 'Khối lượng 24h',
        value: marketListFormatVolume(aggregate.volume24h),
        subline: '${pairs.length} cặp đang niêm yết',
      ),
    );
    final breadthBlock = Expanded(
      flex: 2,
      child: _PulseBlock(
        label: 'Điểm tăng/giảm',
        value: '${aggregate.gainers}/${aggregate.losers}',
        subline: 'cặp tăng / giảm 24h',
      ),
    );
    final topGainerBlock = Expanded(
      flex: 2,
      child: _PulseMoverBlock(
        label: 'Tăng mạnh nhất',
        baseAsset: aggregate.topGainer.baseAsset,
        changeLabel: marketListFormatPct(aggregate.topGainer.change24h),
        positive: true,
      ),
    );
    final topLoserBlock = Expanded(
      flex: 2,
      child: _PulseMoverBlock(
        label: 'Giảm mạnh nhất',
        baseAsset: aggregate.topLoser.baseAsset,
        changeLabel: marketListFormatPct(aggregate.topLoser.change24h),
        positive: false,
      ),
    );

    if (compact) {
      return VitCard(
        radius: VitCardRadius.standard,
        clip: true,
        // Card KPI: 8dp đều (đồng bộ các card x3 cùng pane) — token
        // compact-header (12/0) là của sort header bảng pair, dọc 0 làm chữ
        // chạm viền card (Card-Border Rule 4: không dưới mặc định).
        padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  capBlock,
                  const _PulseDivider(),
                  volumeBlock,
                  const _PulseDivider(),
                  breadthBlock,
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  topGainerBlock,
                  const _PulseDivider(),
                  topLoserBlock,
                ],
              ),
            ),
          ],
        ),
      );
    }

    return VitCard(
      radius: VitCardRadius.standard,
      clip: true,
      // 8dp đều — xem nhánh compact ở trên.
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            capBlock,
            const _PulseDivider(),
            volumeBlock,
            const _PulseDivider(),
            breadthBlock,
            const _PulseDivider(),
            topGainerBlock,
            const _PulseDivider(),
            topLoserBlock,
          ],
        ),
      ),
    );
  }
}

_MarketPulse _aggregate(List<MarketPair> pairs) {
  var marketCap = 0.0;
  var volume24h = 0.0;
  var gainers = 0;
  var losers = 0;
  MarketPair? topGainer;
  MarketPair? topLoser;
  for (final pair in pairs) {
    marketCap += pair.marketCap;
    volume24h += pair.volume24h;
    if (pair.change24h >= 0) {
      gainers++;
    } else {
      losers++;
    }
    if (topGainer == null || pair.change24h > topGainer.change24h) {
      topGainer = pair;
    }
    if (topLoser == null || pair.change24h < topLoser.change24h) {
      topLoser = pair;
    }
  }
  return _MarketPulse(
    marketCap: marketCap,
    volume24h: volume24h,
    gainers: gainers,
    losers: losers,
    // `pairs` is non-empty at every call site (the strip shrinks otherwise).
    topGainer: topGainer!,
    topLoser: topLoser!,
  );
}

final class _MarketPulse {
  const _MarketPulse({
    required this.marketCap,
    required this.volume24h,
    required this.gainers,
    required this.losers,
    required this.topGainer,
    required this.topLoser,
  });

  final double marketCap;
  final double volume24h;
  final int gainers;
  final int losers;
  final MarketPair topGainer;
  final MarketPair topLoser;
}

class _PulseBlock extends StatelessWidget {
  const _PulseBlock({
    required this.label,
    required this.value,
    required this.subline,
    this.valueColor,
  });

  final String label;
  final String value;
  final String subline;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.base.copyWith(
            color: valueColor ?? AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          subline,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _PulseMoverBlock extends StatelessWidget {
  const _PulseMoverBlock({
    required this.label,
    required this.baseAsset,
    required this.changeLabel,
    required this.positive,
  });

  final String label;
  final String baseAsset;
  final String changeLabel;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final color = positive ? AppColors.buy : AppColors.sell;
    return _PulseBlock(
      label: label,
      value: '$baseAsset $changeLabel',
      subline: positive ? 'dẫn điểm tăng' : 'dẫn điểm giảm',
      valueColor: color,
    );
  }
}

class _PulseDivider extends StatelessWidget {
  const _PulseDivider();

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      thickness: AppSpacing.dividerHairline,
      width: AppSpacing.x3 * 2 + AppSpacing.dividerHairline,
      color: AppColors.divider,
    );
  }
}
