import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Bộ lọc thị trường (SC-015): tìm kiếm + preset + chip sort
/// + bảng kết quả độ dày tablet. Query sống local như trang phone (STATE-S23
/// không áp dụng — snapshot family theo appliedQuery).
class MarketsScreenerPane extends ConsumerStatefulWidget {
  const MarketsScreenerPane({super.key});

  static const contentKey = Key('sc015_tablet_content');

  @override
  ConsumerState<MarketsScreenerPane> createState() =>
      _MarketsScreenerPaneState();
}

class _MarketsScreenerPaneState extends ConsumerState<MarketsScreenerPane> {
  final TextEditingController _searchController = TextEditingController();
  MarketScreenerQuery _query = MarketScreenerQuery.defaults;
  String? _activePresetId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyPreset(MarketScreenerPreset preset) {
    setState(() {
      _activePresetId = preset.id;
      _query = preset.query.copyWith(searchQuery: _searchController.text);
    });
  }

  void _toggleSort(MarketScreenerSort sort) {
    setState(() {
      final direction =
          _query.sortBy == sort &&
              _query.sortDirection == MarketSortDirection.desc
          ? MarketSortDirection.asc
          : MarketSortDirection.desc;
      _query = _query.copyWith(sortBy: sort, sortDirection: direction);
      _activePresetId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appliedQuery = _query.copyWith(searchQuery: _searchController.text);
    final screenerAsync = ref.watch(
      marketScreenerSnapshotProvider(appliedQuery),
    );

    return MarketsPaneScaffold(
      title: 'Bộ lọc thị trường',
      subtitle: 'Lọc token · Markets',
      scrollKey: MarketsScreenerPane.contentKey,
      onRefresh: () async {
        ref.invalidate(marketScreenerSnapshotProvider(appliedQuery));
        await ref.read(marketScreenerSnapshotProvider(appliedQuery).future);
      },
      children: screenerAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được bộ lọc thị trường',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(marketScreenerSnapshotProvider(appliedQuery)),
          ),
        ],
        data: (snapshot) => [
          VitSearchBar(
            controller: _searchController,
            placeholder: 'Tìm kiếm token...',
            onChanged: (_) => setState(() {}),
            onClear: () => setState(() {}),
          ),
          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x2,
            children: [
              for (final preset in snapshot.presets)
                VitFilterChip(
                  label: preset.name,
                  active: _activePresetId == preset.id,
                  onTap: () => _applyPreset(preset),
                  color: AppColors.primary,
                ),
            ],
          ),
          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x2,
            children: [
              for (final sort in MarketScreenerSort.values)
                VitFilterChip(
                  label: switch (sort) {
                    MarketScreenerSort.marketCap => 'Vốn hóa',
                    MarketScreenerSort.volume => 'Khối lượng',
                    MarketScreenerSort.change24h => 'Biến động 24h',
                    MarketScreenerSort.price => 'Giá',
                  },
                  active: _query.sortBy == sort,
                  onTap: () => _toggleSort(sort),
                  color: AppColors.primary,
                ),
            ],
          ),
          if (snapshot.marketPairs.isEmpty)
            const VitEmptyState(
              icon: Icons.filter_alt_off_outlined,
              title: 'Không có token phù hợp',
              message: 'Thử xóa bộ lọc hoặc tìm từ khóa khác.',
            )
          else
            _ScreenerTable(pairs: snapshot.marketPairs, sortBy: _query.sortBy),
        ],
      ),
    );
  }
}

class _ScreenerTable extends StatelessWidget {
  const _ScreenerTable({required this.pairs, required this.sortBy});

  final List<MarketPair> pairs;
  final MarketScreenerSort sortBy;

  @override
  Widget build(BuildContext context) {
    final sorted = [...pairs];
    switch (sortBy) {
      case MarketScreenerSort.volume:
        sorted.sort((a, b) => b.volume24h.compareTo(a.volume24h));
      case MarketScreenerSort.change24h:
        sorted.sort((a, b) => b.change24h.compareTo(a.change24h));
      case MarketScreenerSort.price:
        sorted.sort((a, b) => b.price.compareTo(a.price));
      case MarketScreenerSort.marketCap:
        sorted.sort((a, b) => b.marketCap.compareTo(a.marketCap));
    }
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < sorted.length; i++) ...[
            _ScreenerRow(pair: sorted[i]),
            if (i < sorted.length - 1)
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                thickness: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _ScreenerRow extends StatelessWidget {
  const _ScreenerRow({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    final change = pair.change24h;
    final changeColor = change >= 0 ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: TabletSpacingTokens.tableCellPadding,
      child: InkWell(
        onTap: () => context.go(AppRoutePaths.pairDetail(pair.id)),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                '${pair.symbol}/${pair.quoteAsset}',
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
                formatMarketPriceAdaptive(pair.price),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
                style: AppTextStyles.caption.copyWith(
                  color: changeColor,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                formatMarketCompact(pair.volume24h, prefix: '\$'),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                formatMarketCompact(pair.marketCap, prefix: '\$'),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
