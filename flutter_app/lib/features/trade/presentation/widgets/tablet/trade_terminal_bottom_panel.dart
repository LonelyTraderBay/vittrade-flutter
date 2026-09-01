import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_panel.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_segmented_tab_bar.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_tab_bar.dart';

/// Tab dưới chart của terminal (SC-048 tablet): Lệnh mở | Vị thế, và ở
/// tầng hẹp thêm Sổ lệnh — bảng dày đặc cuộn nội bộ, hấp thụ toàn bộ nội
/// dung cột secondary của dashboard cũ ("Tiếp theo" thừa, "Tài sản của
/// bạn" trùng Vị thế). Tab dùng `VitSegmentedTabBar` (segment pills tự vẽ
/// viền — không bọc thêm khung).
class TradeTerminalBottomPanel extends StatefulWidget {
  const TradeTerminalBottomPanel({
    super.key,
    required this.orders,
    required this.positions,
    required this.orderBook,
    required this.onViewAll,
    this.showBookTab = false,
  });

  final List<TradeOpenOrder> orders;
  final List<TradePosition> positions;
  final TradeOrderBook orderBook;

  /// Mở trang Lịch sử lệnh / Bảng vị thế (push route thật).
  final VoidCallback onViewAll;

  /// Tầng hẹp không có cột sổ lệnh riêng → hiển thị sổ lệnh như tab thứ 3.
  final bool showBookTab;

  @override
  State<TradeTerminalBottomPanel> createState() =>
      _TradeTerminalBottomPanelState();
}

class _TradeTerminalBottomPanelState extends State<TradeTerminalBottomPanel> {
  String _activeTab = 'orders';

  @override
  void didUpdateWidget(TradeTerminalBottomPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rời tầng hẹp (mất tab Sổ lệnh) về lại tab hợp lệ.
    if (!widget.showBookTab && _activeTab == 'book') {
      _activeTab = 'orders';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const VitTabItem(
        key: 'orders',
        label: 'Lệnh mở',
        widgetKey: Key('sc048_trade_bottom_tab_orders'),
      ),
      const VitTabItem(
        key: 'positions',
        label: 'Vị thế',
        widgetKey: Key('sc048_trade_bottom_tab_positions'),
      ),
      if (widget.showBookTab)
        const VitTabItem(
          key: 'book',
          label: 'Sổ lệnh',
          widgetKey: Key('sc048_trade_bottom_tab_book'),
        ),
    ];
    return TradeTerminalPanel(
      panelKey: TradeTabletKeys.bottomPanel,
      child: Padding(
        // Luật Base-8-derived 12dp: mép panel → tab; body chỉ inset ngang.
        padding: TradeSpacingTokens.tradeTerminalPanelBodyTopPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tabs trong Expanded: VitTabBar.segment dùng Expanded nội bộ
            // nên cần bề rộng giới hạn (Row cho con non-flex bề rộng vô
            // hạn — sẽ nổ layout).
            Row(
              children: [
                Expanded(
                  child: VitSegmentedTabBar(
                    tabs: tabs,
                    activeKey: _activeTab,
                    onChanged: (key) => setState(() => _activeTab = key),
                  ),
                ),
                const SizedBox(width: TabletSpacingTokens.x4),
                IconButton(
                  key: TradeTabletKeys.bottomTab('view_all'),
                  tooltip: 'Xem tất cả',
                  onPressed: widget.onViewAll,
                  icon: const Icon(
                    Icons.open_in_full_rounded,
                    size: TabletSpacingTokens.iconSm + TabletSpacingTokens.x2,
                  ),
                  color: AppColors.primary,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
            SizedBox(
              height: TradeSpacingTokens.tradeTerminalBottomTableHeight,
              child: switch (_activeTab) {
                'positions' => _PositionTable(positions: widget.positions),
                'book' => _BookTable(orderBook: widget.orderBook),
                _ => _OrderTable(orders: widget.orders),
              },
            ),
            const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
          ],
        ),
      ),
    );
  }
}

/// Bảng lệnh mở: cặp | loại | giá | khối lượng | đã khớp | thời gian.
class _OrderTable extends StatelessWidget {
  const _OrderTable({required this.orders});

  final List<TradeOpenOrder> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const _BottomEmpty(message: 'Chưa có lệnh mở');
    }
    return ListView.builder(
      itemCount: orders.length,
      itemExtent: TradeSpacingTokens.tradeTerminalTradeRowExtent,
      itemBuilder: (context, index) {
        final order = orders[index];
        final sideColor = order.side == TradeOrderSide.buy
            ? AppColors.buy
            : AppColors.sell;
        return Padding(
          padding: TradeSpacingTokens.tradeTerminalBottomRowPadding,
          child: Row(
            children: [
              SizedBox(
                width: TradeSpacingTokens.tradeTerminalSymbolColumnWidth,
                child: Text.rich(
                  TextSpan(
                    text: order.side == TradeOrderSide.buy ? 'MUA ' : 'BÁN ',
                    style: AppTextStyles.micro.copyWith(
                      color: sideColor,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                    children: [
                      TextSpan(
                        text: order.symbol,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  order.type == TradeOrderType.limit
                      ? 'Giới hạn'
                      : order.type == TradeOrderType.stop
                      ? 'Điểm dừng'
                      : 'Thị trường',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Expanded(
                child: Text(
                  order.price.toStringAsFixed(2),
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  order.amount.toStringAsFixed(3),
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  order.filled.toStringAsFixed(3),
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  order.createdAt,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Bảng vị thế Spot: cặp | hướng | giá trị | P/L (tabular, mũi tên theo
/// dấu).
class _PositionTable extends StatelessWidget {
  const _PositionTable({required this.positions});

  final List<TradePosition> positions;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return const _BottomEmpty(message: 'Chưa có vị thế');
    }
    return ListView.builder(
      itemCount: positions.length,
      itemExtent: TradeSpacingTokens.tradeTerminalTradeRowExtent,
      itemBuilder: (context, index) {
        final position = positions[index];
        final sideColor = position.side == TradeOrderSide.buy
            ? AppColors.buy
            : AppColors.sell;
        final positive = position.pnl >= 0;
        return Padding(
          padding: TradeSpacingTokens.tradeTerminalBottomRowPadding,
          child: Row(
            children: [
              SizedBox(
                width: TradeSpacingTokens.tradeTerminalSymbolColumnWidth,
                child: Text.rich(
                  TextSpan(
                    text: position.side == TradeOrderSide.buy ? 'MUA ' : 'BÁN ',
                    style: AppTextStyles.micro.copyWith(
                      color: sideColor,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                    children: [
                      TextSpan(
                        text: position.symbol,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  formatTradeMoney(position.notional),
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '${positive ? '▲' : '▼'} ${formatTradeSignedMoney(position.pnl)}',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(
                    color: positive ? AppColors.buy : AppColors.sell,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Sổ lệnh dạng compact cho tầng hẹp: 6 mức mỗi bên xếp dọc (ask trước,
/// bid sau) — cùng dữ liệu panel sổ lệnh nhưng nằm trong tab dưới chart.
class _BookTable extends StatelessWidget {
  const _BookTable({required this.orderBook});

  final TradeOrderBook orderBook;

  @override
  Widget build(BuildContext context) {
    final asks = orderBook.asks.take(6).toList();
    final bids = orderBook.bids.take(6).toList();
    if (asks.isEmpty || bids.isEmpty) {
      return const _BottomEmpty(message: 'Chưa có dữ liệu sổ lệnh');
    }
    final rows = <Widget>[];
    for (var i = 0; i < asks.length; i++) {
      rows.add(
        _BookPairRow(
          price: asks[i].price,
          amount: asks[i].amount,
          color: AppColors.sell,
        ),
      );
    }
    for (var i = 0; i < bids.length; i++) {
      rows.add(
        _BookPairRow(
          price: bids[i].price,
          amount: bids[i].amount,
          color: AppColors.buy,
        ),
      );
    }
    return SingleChildScrollView(child: Column(children: rows));
  }
}

class _BookPairRow extends StatelessWidget {
  const _BookPairRow({
    required this.price,
    required this.amount,
    required this.color,
  });

  final double price;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TradeSpacingTokens.tradeTerminalTradeRowExtent,
      child: Padding(
        padding: TradeSpacingTokens.tradeTerminalBottomRowPadding,
        child: Row(
          children: [
            Expanded(
              child: Text(
                price.toStringAsFixed(2),
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            Expanded(
              child: Text(
                amount.toStringAsFixed(3),
                textAlign: TextAlign.right,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
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

class _BottomEmpty extends StatelessWidget {
  const _BottomEmpty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        textAlign: TextAlign.center,
      ),
    );
  }
}
