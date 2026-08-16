import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';
part '../../../widgets/phone/watchlist_toolbar.dart';
part '../../../widgets/phone/watchlist_cards.dart';
part '../../../widgets/phone/watchlist_common_painter.dart';

const _marketPrimary = AppColors.primary;
const double _watchlistFramedScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x7;
const double _watchlistNativeScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x5;
const double _watchlistSparklineExtent =
    AppSpacing.buttonStandard + AppSpacing.x4;

class WatchlistPage extends ConsumerStatefulWidget {
  const WatchlistPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc012_watchlist_scroll_content');
  static const searchKey = Key('sc012_watchlist_search');
  static const addPairKey = Key('sc012_add_pair');

  static Key cardKey(String pairId) => Key('sc012_watchlist_card_$pairId');

  static Key tradeKey(String pairId) => Key('sc012_trade_$pairId');

  static Key pairLinkKey(String pairId) => Key('sc012_pair_link_$pairId');

  static Key noteKey(String entryId) => Key('sc012_note_$entryId');

  static Key removeKey(String entryId) => Key('sc012_remove_$entryId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends ConsumerState<WatchlistPage> {
  final _searchController = TextEditingController();

  // STATE-S23: entries sống ở MarketWatchlistStateController (một nguồn sự
  // thật) — hết `late List` seed từ ref.read + setState.

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_WatchlistItem> _filteredItems(
    MarketWatchlistSnapshot snapshot,
    List<MarketWatchlistEntry> entries,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    final items = <_WatchlistItem>[];
    for (final entry in entries) {
      final pair = _findPair(snapshot.marketPairs, entry.pairId);
      if (pair == null) continue;
      if (query.isNotEmpty &&
          !pair.symbol.toLowerCase().contains(query) &&
          !pair.baseAsset.toLowerCase().contains(query)) {
        continue;
      }
      items.add(_WatchlistItem(entry: entry, pair: pair));
    }
    return items;
  }

  void _removeEntry(String id) {
    ref.read(marketWatchlistStateControllerProvider.notifier).removeEntry(id);
  }

  Future<void> _editNote(MarketWatchlistEntry entry) async {
    final controller = TextEditingController(text: entry.note ?? '');
    final note = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            entry.note == null ? 'Thêm ghi chú' : 'Sửa ghi chú',
            style: AppTextStyles.baseMedium,
          ),
          content: VitInput(
            controller: controller,
            autofocus: true,
            semanticLabel: 'Ghi chú danh mục theo dõi',
            hintText: 'Nhap ghi chu',
          ),
          actions: [
            VitCtaButton(
              onPressed: () => Navigator.of(context).pop(),
              variant: VitCtaButtonVariant.ghost,
              fullWidth: false,
              density: VitDensity.compact,
              height: VitDensity.compact.controlHeight,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x3,
              ),
              child: const Text('Hủy'),
            ),
            VitCtaButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              fullWidth: false,
              density: VitDensity.compact,
              height: VitDensity.compact.controlHeight,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x3,
              ),
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (note == null) return;

    final trimmed = note.trim();
    ref
        .read(marketWatchlistStateControllerProvider.notifier)
        .setNote(entry.id, trimmed.isEmpty ? null : trimmed);
  }

  @override
  Widget build(BuildContext context) {
    // GD4-F3: trang gate qua marketWatchlistSnapshotProvider.when() (mục
    // 5+6) trước khi đọc marketWatchlistStateControllerProvider.
    final watchlistAsync = ref.watch(marketWatchlistSnapshotProvider);
    final viewState = ref.watch(marketWatchlistStateControllerProvider);
    final snapshot = viewState.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _watchlistFramedScrollClearance
            : _watchlistNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;
    final items = _filteredItems(snapshot, viewState.entries);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Danh sách theo dõi',
      semanticIdentifier: 'SC-012',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Danh sách theo dõi',
            subtitle:
                'Theo dõi cặp yêu thích · Cập nhật ${snapshot.lastUpdatedLabel}',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WatchlistToolbar(
                controller: _searchController,
                count: viewState.entries.length,
                onChanged: (_) => setState(() {}),
                onClear: () => setState(() {}),
                onAddPair: () => context.go(AppRoutePaths.markets),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: VitInsetScrollView(
                    key: WatchlistPage.contentKey,
                    bottomInset: scrollEndClearance,
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: watchlistAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được danh sách theo dõi',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(marketWatchlistSnapshotProvider),
                          ),
                        ],
                        data: (_) => [
                          items.isEmpty
                              ? _EmptyWatchlist(
                                  searchActive: _searchController.text
                                      .trim()
                                      .isNotEmpty,
                                  onAddPair: () =>
                                      context.go(AppRoutePaths.markets),
                                )
                              : Column(
                                  children: [
                                    for (var i = 0; i < items.length; i++)
                                      _WatchlistCard(
                                        item: items[i],
                                        onPairTap: () => context.go(
                                          AppRoutePaths.pairDetail(
                                            items[i].pair.id,
                                          ),
                                        ),
                                        onTradeTap: () => context.go(
                                          AppRoutePaths.tradePair(
                                            items[i].pair.id,
                                          ),
                                        ),
                                        onNoteTap: () =>
                                            _editNote(items[i].entry),
                                        onRemoveTap: () =>
                                            _removeEntry(items[i].entry.id),
                                      ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
