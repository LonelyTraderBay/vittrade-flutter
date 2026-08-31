import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của Bảng vị thế (SC-053, 2026-08-31) — cùng route, cùng
/// [tradePositionsProvider] với trang phone, nhưng là BẢNG VỊ THẾ một hàng
/// đầy đủ trường (cặp · loại · hướng · khối lượng · giá vào · giá hiện tại
/// · P/L · P/L% · đòn bẩy/thanh lý) + panel Tổng quan & rủi ro bên phải.
/// Port theo R2; panel rủi ro copy tiếng Việt (bản phone đang nợ baseline
/// tiếng Anh — không sao chép sang tablet).
class PositionDashboardTabletPage extends ConsumerStatefulWidget {
  const PositionDashboardTabletPage({super.key});

  static const tableKey = Key('sc053_tablet_table');
  static const summaryKey = Key('sc053_tablet_summary');

  @override
  ConsumerState<PositionDashboardTabletPage> createState() =>
      _PositionDashboardTabletPageState();
}

class _PositionDashboardTabletPageState
    extends ConsumerState<PositionDashboardTabletPage> {
  String _activeTab = 'all';
  String _sortBy = 'pnl';

  @override
  Widget build(BuildContext context) {
    final positionsAsync = ref.watch(tradePositionsProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Vị thế đang mở',
      semanticIdentifier: 'SC-053',
      child: Column(
        children: [
          VitHeader(
            title: 'Vị thế đang mở',
            subtitle: 'Vị thế · Spot / Futures / Margin',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.trade,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
            backKey: TradeTabletKeys.back,
          ),
          Expanded(
            child: positionsAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được vị thế đang mở',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(tradePositionsProvider),
                ),
              ),
              data: (snapshot) {
                return VitTwoColumnTabletDashboard(
                  onRefresh: () async {
                    ref.invalidate(tradePositionsProvider);
                    await ref.read(tradePositionsProvider.future);
                  },
                  primaryChildren: [
                    ...tradeShellWithProductTabs(
                      context: context,
                      showProductTabs: true,
                      activeProductId: 'spot',
                      productPair: snapshot.trade.pair,
                      quickNavKey: TradeTabletKeys.quickNav,
                      navigationBuilder: buildTradeProductNavigation,
                      children: const [SizedBox.shrink()],
                    ),
                    _PositionControlsRow(
                      activeTab: _activeTab,
                      sortBy: _sortBy,
                      onTabChanged: (tab) => setState(() => _activeTab = tab),
                      onSortChanged: (sort) => setState(() => _sortBy = sort),
                    ),
                    _PositionTable(positions: _visiblePositions(snapshot)),
                  ],
                  secondaryChildren: [
                    VitTradeSection(
                      title: 'Tổng quan',
                      child: _PositionSummaryCard(
                        positions: snapshot.positions,
                      ),
                    ),
                    const VitTradeSection(
                      title: 'Đánh giá rủi ro',
                      child: VitCard(
                        variant: VitCardVariant.inner,
                        radius: VitCardRadius.tight,
                        padding: AppSpacing.cardPaddingCompact,
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          density: VitDensity.tool,
                          title: 'Xem lại rủi ro vị thế mở',
                          message:
                              'P/L, giá trị danh nghĩa, ký quỹ, đường đóng vị thế và phí được rà soát trước khi thao tác vị thế.',
                          contractId: 'position-dashboard-review',
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<TradeDashboardPosition> _visiblePositions(
    TradePositionsSnapshot snapshot,
  ) {
    final filtered = _activeTab == 'all'
        ? snapshot.positions
        : snapshot.positions
              .where((position) => position.type.name == _activeTab)
              .toList(growable: false);
    final sorted = filtered.toList(growable: false);
    sorted.sort((a, b) {
      if (_sortBy == 'pnlPct') return b.pnlPct.abs().compareTo(a.pnlPct.abs());
      if (_sortBy == 'size') return b.notional.compareTo(a.notional);
      return b.pnl.abs().compareTo(a.pnl.abs());
    });
    return sorted;
  }
}

/// Hàng lọc loại vị thế + sắp xếp — segment tabs + filter chips, không bọc
/// khung thêm (Segment-Pill-Standard).
class _PositionControlsRow extends StatelessWidget {
  const _PositionControlsRow({
    required this.activeTab,
    required this.sortBy,
    required this.onTabChanged,
    required this.onSortChanged,
  });

  final String activeTab;
  final String sortBy;
  final ValueChanged<String> onTabChanged;
  final ValueChanged<String> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitSegmentedTabBar(
            tabs: const [
              VitTabItem(
                key: 'all',
                label: 'Tất cả',
                widgetKey: Key('sc053_tablet_tab_all'),
              ),
              VitTabItem(
                key: 'spot',
                label: 'Spot',
                widgetKey: Key('sc053_tablet_tab_spot'),
              ),
              VitTabItem(
                key: 'futures',
                label: 'Futures',
                widgetKey: Key('sc053_tablet_tab_futures'),
              ),
              VitTabItem(
                key: 'margin',
                label: 'Margin',
                widgetKey: Key('sc053_tablet_tab_margin'),
              ),
            ],
            activeKey: activeTab,
            onChanged: onTabChanged,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        for (final (id, label) in [
          ('pnl', 'P/L'),
          ('pnlPct', '% P/L'),
          ('size', 'Giá trị'),
        ]) ...[
          VitFilterChip(
            key: Key('sc053_tablet_sort_$id'),
            label: label,
            active: sortBy == id,
            onTap: () => onSortChanged(id),
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.x4),
        ],
      ],
    );
  }
}

/// Bảng vị thế một hàng đầy đủ trường.
class _PositionTable extends StatelessWidget {
  const _PositionTable({required this.positions});

  final List<TradeDashboardPosition> positions;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return const VitEmptyState(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Chưa có vị thế',
        message: 'Vị thế mở từ terminal sẽ hiện tại đây.',
      );
    }
    return VitCard(
      key: PositionDashboardTabletPage.tableKey,
      radius: VitCardRadius.tight,
      borderColor: AppColors.border,
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          const _PositionTableHeader(),
          for (var i = 0; i < positions.length; i++) ...[
            _PositionTableRow(
              key: Key('sc053_tablet_row_${positions[i].id}'),
              position: positions[i],
            ),
            if (i < positions.length - 1)
              const Divider(
                height: AppSpacing.dividerHairline,
                thickness: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _PositionTableHeader extends StatelessWidget {
  const _PositionTableHeader();

  @override
  Widget build(BuildContext context) {
    final labels = [
      'Cặp · Loại · Hướng',
      'Khối lượng',
      'Giá vào',
      'Giá hiện tại',
      'Giá trị',
      'P/L',
      'P/L %',
      'Đòn bẩy',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Row(
        children: [
          for (final (index, label) in labels.indexed)
            Expanded(
              flex: index == 0 ? 3 : 2,
              child: Text(
                label,
                maxLines: 1,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PositionTableRow extends StatelessWidget {
  const _PositionTableRow({super.key, required this.position});

  final TradeDashboardPosition position;

  @override
  Widget build(BuildContext context) {
    final positive = position.pnl >= 0;
    final pnlColor = positive ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text.rich(
              TextSpan(
                text: position.symbol,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
                children: [
                  TextSpan(
                    text:
                        ' · ${position.type.name == 'spot'
                            ? 'Spot'
                            : position.type.name == 'futures'
                            ? 'Futures'
                            : 'Margin'}'
                        ' · ${position.side == TradePositionSide.long ? 'Long' : 'Short'}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          for (final (flex, value) in [
            (2, position.size.toStringAsFixed(3)),
            (2, position.entryPrice.toStringAsFixed(2)),
            (2, position.currentPrice.toStringAsFixed(2)),
            (2, formatTradeMoney(position.notional)),
          ])
            Expanded(
              flex: flex,
              child: Text(
                value,
                maxLines: 1,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          Expanded(
            flex: 2,
            child: Text(
              '${positive ? '▲' : '▼'} ${formatTradeSignedMoney(position.pnl)}',
              maxLines: 1,
              style: AppTextStyles.caption.copyWith(
                color: pnlColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${positive ? '+' : ''}${position.pnlPct.toStringAsFixed(2)}%',
              maxLines: 1,
              style: AppTextStyles.caption.copyWith(
                color: pnlColor,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              position.leverage == null
                  ? '—'
                  : '${position.leverage}x'
                        '${position.liquidPrice == null ? '' : ' · TL ${position.liquidPrice!.toStringAsFixed(0)}'}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Panel tổng quan: số vị thế + tổng P/L + giá trị danh nghĩa.
class _PositionSummaryCard extends StatelessWidget {
  const _PositionSummaryCard({required this.positions});

  final List<TradeDashboardPosition> positions;

  @override
  Widget build(BuildContext context) {
    final totalPnl = positions.fold<double>(0, (sum, p) => sum + p.pnl);
    final totalNotional = positions.fold<double>(
      0,
      (sum, p) => sum + p.notional,
    );
    final positive = totalPnl >= 0;
    return VitCard(
      key: PositionDashboardTabletPage.summaryKey,
      radius: VitCardRadius.tight,
      borderColor: AppColors.border,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitKeyValueRow(
            label: 'Số vị thế mở',
            value: '${positions.length}',
            labelStyle: AppTextStyles.caption.copyWith(color: AppColors.text2),
            valueStyle: AppTextStyles.control.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitKeyValueRow(
            label: 'Tổng giá trị danh nghĩa',
            value: formatTradeMoney(totalNotional),
            labelStyle: AppTextStyles.caption.copyWith(color: AppColors.text2),
            valueStyle: AppTextStyles.control.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitKeyValueRow(
            label: 'Tổng P/L chưa realise',
            value:
                '${positive ? '▲' : '▼'} ${formatTradeSignedMoney(totalPnl)}',
            labelStyle: AppTextStyles.caption.copyWith(color: AppColors.text2),
            valueStyle: AppTextStyles.control.copyWith(
              color: positive ? AppColors.buy : AppColors.sell,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
