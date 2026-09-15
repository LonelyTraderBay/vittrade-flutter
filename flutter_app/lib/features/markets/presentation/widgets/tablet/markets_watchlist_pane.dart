import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Danh mục theo dõi (SC-012): ô tìm kiếm + bảng entry độ
/// dày tablet (cặp · giá · biến động · ghi chú · hành động), state entries
/// sống ở [marketWatchlistStateControllerProvider] (STATE-S23).
class MarketsWatchlistPane extends ConsumerStatefulWidget {
  const MarketsWatchlistPane({super.key});

  static const contentKey = Key('sc012_tablet_content');

  @override
  ConsumerState<MarketsWatchlistPane> createState() =>
      _MarketsWatchlistPaneState();
}

class _MarketsWatchlistPaneState extends ConsumerState<MarketsWatchlistPane> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(marketWatchlistSnapshotProvider);
    final viewState = ref.watch(marketWatchlistStateControllerProvider);

    return MarketsPaneScaffold(
      title: 'Danh mục theo dõi',
      subtitle: 'Watchlist · Markets',
      scrollKey: MarketsWatchlistPane.contentKey,
      onRefresh: () async {
        ref.invalidate(marketWatchlistSnapshotProvider);
        await ref.read(marketWatchlistSnapshotProvider.future);
      },
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được danh mục theo dõi',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(marketWatchlistSnapshotProvider),
          ),
        ],
        data: (snapshot) {
          final query = _searchController.text.trim().toLowerCase();
          final rows = <(_WatchRow, MarketPair)>[
            for (final entry in viewState.entries)
              for (final pair in snapshot.marketPairs)
                if (pair.id == entry.pairId)
                  if (query.isEmpty ||
                      pair.symbol.toLowerCase().contains(query) ||
                      pair.baseAsset.toLowerCase().contains(query))
                    (_WatchRow(entry: entry, pair: pair), pair),
          ];
          return [
            VitInput(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              semanticLabel: 'Tìm kiếm danh mục theo dõi',
              hintText: 'Tìm theo symbol hoặc tài sản',
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            if (rows.isEmpty)
              const VitEmptyState(
                icon: Icons.star_outline_rounded,
                title: 'Danh mục trống',
                message: 'Thêm cặp từ danh sách Markets để theo dõi tại đây.',
              )
            else
              VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.zeroInsets,
                clip: true,
                child: Column(
                  children: [
                    for (var i = 0; i < rows.length; i++) ...[
                      _WatchRowTile(
                        row: rows[i].$1,
                        pair: rows[i].$2,
                        onRemove: () => ref
                            .read(
                              marketWatchlistStateControllerProvider.notifier,
                            )
                            .removeEntry(rows[i].$1.entry.id),
                        onEditNote: () => _editNote(rows[i].$1.entry),
                      ),
                      if (i < rows.length - 1)
                        const Divider(
                          height: TabletSpacingTokens.dividerHairline,
                          thickness: TabletSpacingTokens.dividerHairline,
                          color: AppColors.divider,
                        ),
                    ],
                  ],
                ),
              ),
          ];
        },
      ),
    );
  }

  Future<void> _editNote(MarketWatchlistEntry entry) async {
    final controller = TextEditingController(text: entry.note ?? '');
    // Bottom sheet chuẩn (Bottom-Sheet-Standard): tablet không mở dialog
    // căn giữa; CTA Lưu/Hủy ghim footer, không cuộn theo input.
    final note = await showVitBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => VitSheetPanel(
        title: entry.note == null ? 'Thêm ghi chú' : 'Sửa ghi chú',
        footer: Row(
          children: [
            Expanded(
              child: VitCtaButton(
                onPressed: () => Navigator.of(sheetContext).pop(),
                variant: VitCtaButtonVariant.ghost,
                child: const Text('Hủy'),
              ),
            ),
            const SizedBox(width: TabletSpacingTokens.x4),
            Expanded(
              child: VitCtaButton(
                onPressed: () =>
                    Navigator.of(sheetContext).pop(controller.text),
                child: const Text('Lưu'),
              ),
            ),
          ],
        ),
        child: VitInput(
          controller: controller,
          autofocus: true,
          semanticLabel: 'Ghi chú danh mục theo dõi',
        ),
      ),
    );
    if (note == null) return;
    ref
        .read(marketWatchlistStateControllerProvider.notifier)
        .setNote(entry.id, note);
    // Đồng bộ ô tìm kiếm để bảng dựng lại ngay với ghi chú mới.
    if (mounted) setState(() {});
  }
}

class _WatchRow {
  const _WatchRow({required this.entry, required this.pair});

  final MarketWatchlistEntry entry;
  final MarketPair pair;
}

class _WatchRowTile extends StatelessWidget {
  const _WatchRowTile({
    required this.row,
    required this.pair,
    required this.onRemove,
    required this.onEditNote,
  });

  final _WatchRow row;
  final MarketPair pair;
  final VoidCallback onRemove;
  final VoidCallback onEditNote;

  @override
  Widget build(BuildContext context) {
    final change = pair.change24h;
    final changeColor = change >= 0 ? AppColors.buy : AppColors.sell;
    final note = row.entry.note;
    return Padding(
      padding: TabletSpacingTokens.tableCellPadding,
      child: Row(
        children: [
          Expanded(
            flex: 2,
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
            flex: 3,
            child: GestureDetector(
              onTap: onEditNote,
              child: Text(
                note == null || note.isEmpty ? 'Thêm ghi chú' : note,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: note == null || note.isEmpty
                      ? AppColors.text3
                      : AppColors.text2,
                  fontStyle: note == null || note.isEmpty
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Xóa khỏi danh mục',
            onPressed: onRemove,
            icon: const Icon(
              Icons.close_rounded,
              size: TabletSpacingTokens.iconMd,
              color: AppColors.text3,
            ),
          ),
        ],
      ),
    );
  }
}
