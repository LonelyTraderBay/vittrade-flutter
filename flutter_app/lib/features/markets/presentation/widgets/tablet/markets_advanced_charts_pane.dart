import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Biểu đồ nâng cao (SC-023): 3 tab Chỉ báo | Công cụ vẽ |
/// Tín hiệu, chip danh mục + danh sách bật/tắt indicator, query record
/// (indicatorCategory, drawingCategory) như trang phone.
class MarketsAdvancedChartsPane extends ConsumerStatefulWidget {
  const MarketsAdvancedChartsPane({super.key});

  static const contentKey = Key('sc023_tablet_content');

  @override
  ConsumerState<MarketsAdvancedChartsPane> createState() =>
      _MarketsAdvancedChartsPaneState();
}

class _MarketsAdvancedChartsPaneState
    extends ConsumerState<MarketsAdvancedChartsPane> {
  final String _tab = 'indicators';
  String _indicatorCategory = 'all';
  String _drawingCategory = 'all';
  final Set<String> _activeIndicatorIds = <String>{};

  void _toggleIndicator(String id) {
    setState(() {
      if (_activeIndicatorIds.contains(id)) {
        _activeIndicatorIds.remove(id);
      } else {
        _activeIndicatorIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = (
      indicatorCategory: _indicatorCategory,
      drawingCategory: _drawingCategory,
    );
    final chartsAsync = ref.watch(marketAdvancedChartsSnapshotProvider(query));

    return MarketsPaneScaffold(
      title: 'Biểu đồ nâng cao',
      subtitle: 'Chỉ báo · Công cụ vẽ',
      scrollKey: MarketsAdvancedChartsPane.contentKey,
      children: chartsAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được biểu đồ nâng cao',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(marketAdvancedChartsSnapshotProvider(query)),
          ),
        ],
        data: (snapshot) => [
          if (_tab == 'indicators') ...[
            Wrap(
              spacing: TabletSpacingTokens.x3,
              runSpacing: TabletSpacingTokens.x2,
              children: [
                for (final category in snapshot.indicatorCategories)
                  VitFilterChip(
                    label: category.label,
                    active: _indicatorCategory == category.id,
                    onTap: () => setState(() {
                      _indicatorCategory = category.id;
                    }),
                    color: AppColors.primary,
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            for (final indicator in snapshot.indicators.where(
              (item) =>
                  _indicatorCategory == 'all' ||
                  item.categoryId == _indicatorCategory,
            ))
              _IndicatorRow(
                indicator: indicator,
                active:
                    _activeIndicatorIds.contains(indicator.id) ||
                    snapshot.activeIndicatorIds.contains(indicator.id),
                onToggle: () => _toggleIndicator(indicator.id),
              ),
          ] else if (_tab == 'drawing') ...[
            Wrap(
              spacing: TabletSpacingTokens.x3,
              runSpacing: TabletSpacingTokens.x2,
              children: [
                for (final category in snapshot.drawingCategories)
                  VitFilterChip(
                    label: category.label,
                    active: _drawingCategory == category.id,
                    onTap: () => setState(() {
                      _drawingCategory = category.id;
                    }),
                    color: AppColors.primary,
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            Wrap(
              spacing: TabletSpacingTokens.x3,
              runSpacing: TabletSpacingTokens.x2,
              children: [
                for (final tool in snapshot.drawingTools.where(
                  (item) =>
                      _drawingCategory == 'all' ||
                      item.categoryId == _drawingCategory,
                ))
                  VitStatusPill(
                    label: tool.name,
                    status: VitStatusPillStatus.neutral,
                    size: VitStatusPillSize.sm,
                  ),
              ],
            ),
          ] else ...[
            for (final summary in snapshot.signalSummaries)
              _SignalSummaryRow(summary: summary),
          ],
        ],
      ),
    );
  }
}

class _IndicatorRow extends StatelessWidget {
  const _IndicatorRow({
    required this.indicator,
    required this.active,
    required this.onToggle,
  });

  final TechnicalIndicator indicator;
  final bool active;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TabletSpacingTokens.tableCellPaddingV,
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${indicator.name} (${indicator.shortName})',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          VitFilterChip(
            label: active ? 'Đang bật' : 'Tắt',
            active: active,
            onTap: onToggle,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _SignalSummaryRow extends StatelessWidget {
  const _SignalSummaryRow({required this.summary});

  final TechSignalSummaryDraft summary;

  String _signalLabel(TechSignal signal) => switch (signal) {
    TechSignal.strongBuy => 'Mua mạnh',
    TechSignal.buy => 'Mua',
    TechSignal.neutral => 'Trung tính',
    TechSignal.sell => 'Bán',
    TechSignal.strongSell => 'Bán mạnh',
  };

  Color _signalColor(TechSignal signal) => switch (signal) {
    TechSignal.strongBuy || TechSignal.buy => AppColors.buy,
    TechSignal.neutral => AppColors.text2,
    TechSignal.sell || TechSignal.strongSell => AppColors.sell,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TabletSpacingTokens.tableCellPadding,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '${summary.pair} · ${summary.timeframe}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                color: AppColors.text1,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Tổng: ${_signalLabel(summary.overallSignal)}',
              style: AppTextStyles.caption.copyWith(
                color: _signalColor(summary.overallSignal),
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'MA: ${_signalLabel(summary.maSummary)}',
              style: AppTextStyles.caption.copyWith(
                color: _signalColor(summary.maSummary),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'OSC: ${_signalLabel(summary.oscSummary)}',
              style: AppTextStyles.caption.copyWith(
                color: _signalColor(summary.oscSummary),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${summary.buyCount}/${summary.neutralCount}/${summary.sellCount}',
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
