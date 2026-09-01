import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
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

/// Bố cục tablet của Lịch sử lệnh (SC-050, 2026-08-31) — cùng route, cùng
/// [tradeOrdersHistoryControllerProvider] với trang phone, nhưng là BẢNG
/// DÀY ĐẶT độ rộng tablet (một hàng = toàn bộ trường của lệnh, không xếp
/// chồng 2 dòng kiểu mobile) + panel thống kê bên phải. Port theo R2: tái
/// dùng key/formatter của trang phone, không sửa file phone.
class OrdersHistoryTabletPage extends ConsumerStatefulWidget {
  const OrdersHistoryTabletPage({super.key});

  static const tableKey = Key('sc050_tablet_table');
  static const statsKey = Key('sc050_tablet_stats');

  // Key trùng chuỗi trang phone (sc050_*) — giữ local để không import
  // chéo phone page từ tablet (surface boundary guardrail).
  static const openTabKey = Key('sc050_open_tab');
  static const historyTabKey = Key('sc050_history_tab');
  static const cancelFirstOrderKey = Key('sc050_cancel_first_order');
  static Key filterKey(String id) => Key('sc050_filter_$id');
  static Key orderKey(String id) => Key('sc050_order_$id');

  @override
  ConsumerState<OrdersHistoryTabletPage> createState() =>
      _OrdersHistoryTabletPageState();
}

class _OrdersHistoryTabletPageState
    extends ConsumerState<OrdersHistoryTabletPage> {
  String _activeTab = 'open';
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(tradeOrdersHistoryControllerProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Lịch sử lệnh giao dịch',
      semanticIdentifier: 'SC-050',
      child: Column(
        children: [
          VitHeader(
            title: 'Lịch sử lệnh',
            subtitle: 'Lịch sử lệnh · Spot',
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
            child: controllerAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được lịch sử lệnh',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(tradeOrdersHistorySnapshotProvider),
                ),
              ),
              data: (controller) {
                final snapshot = controller.state.snapshot;
                return VitTwoColumnTabletDashboard(
                  onRefresh: () async {
                    ref.invalidate(tradeOrdersHistorySnapshotProvider);
                    await ref.read(tradeOrdersHistorySnapshotProvider.future);
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
                    _TradeTabletTabRow(
                      activeTab: _activeTab,
                      openCount: snapshot.openOrders.length,
                      historyCount: snapshot.historyOrders.length,
                      filter: _filter,
                      onTabChanged: (tab) => setState(() => _activeTab = tab),
                      onFilterChanged: (filter) =>
                          setState(() => _filter = filter),
                    ),
                    _OrdersTable(
                      orders: _visibleOrders(snapshot),
                      activeTab: _activeTab,
                      onCancel: _cancelOrder,
                    ),
                  ],
                  secondaryChildren: [
                    VitTradeSection(
                      innerGap: TabletSpacingTokens.x4,
                      title: 'Thống kê',
                      child: _OrderStatsCard(snapshot: snapshot),
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

  List<TradeHistoryOrder> _visibleOrders(TradeOrdersHistorySnapshot snapshot) {
    final source = _activeTab == 'open'
        ? snapshot.openOrders
        : snapshot.historyOrders;
    if (_filter == 'buy') {
      return source
          .where((order) => order.side == TradeOrderSide.buy)
          .toList(growable: false);
    }
    if (_filter == 'sell') {
      return source
          .where((order) => order.side == TradeOrderSide.sell)
          .toList(growable: false);
    }
    return source;
  }

  Future<void> _cancelOrder(String orderId) async {
    final controller = ref.read(tradeOrdersHistoryControllerProvider).value;
    if (controller == null) return;
    final result = await controller.cancelOrder(orderId);
    if (!mounted) return;
    await showVitNoticeSheet(
      context: context,
      title: 'Đã hủy lệnh',
      message: 'Đã hủy ${result.orderId}',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }
}

/// Hàng tab (Mở | Lịch sử) + lọc (Tất cả | Mua | Bán) — segment pills tự
/// vẽ viền, các chip lọc dùng `VitFilterChip` (Segment-Pill-Standard).
class _TradeTabletTabRow extends StatelessWidget {
  const _TradeTabletTabRow({
    required this.activeTab,
    required this.openCount,
    required this.historyCount,
    required this.filter,
    required this.onTabChanged,
    required this.onFilterChanged,
  });

  final String activeTab;
  final int openCount;
  final int historyCount;
  final String filter;
  final ValueChanged<String> onTabChanged;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitSegmentedTabBar(
            tabs: [
              VitTabItem(
                key: 'open',
                label: 'Đang mở ($openCount)',
                widgetKey: OrdersHistoryTabletPage.openTabKey,
              ),
              VitTabItem(
                key: 'history',
                label: 'Lịch sử ($historyCount)',
                widgetKey: OrdersHistoryTabletPage.historyTabKey,
              ),
            ],
            activeKey: activeTab,
            onChanged: onTabChanged,
          ),
        ),
        const SizedBox(width: TabletSpacingTokens.x4),
        for (final (id, label) in [
          ('all', 'Tất cả'),
          ('buy', 'Mua'),
          ('sell', 'Bán'),
        ]) ...[
          VitFilterChip(
            key: OrdersHistoryTabletPage.filterKey(id),
            label: label,
            active: filter == id,
            onTap: () => onFilterChanged(id),
            color: AppColors.primary,
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
        ],
      ],
    );
  }
}

/// Bảng lệnh một hàng đầy đủ trường: cặp | loại | giá | KL | đã khớp | phí
/// | trạng thái | thời gian | hành động — độ rộng tablet đủ cho 9 cột.
class _OrdersTable extends StatelessWidget {
  const _OrdersTable({
    required this.orders,
    required this.activeTab,
    required this.onCancel,
  });

  final List<TradeHistoryOrder> orders;
  final String activeTab;
  final void Function(String orderId) onCancel;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const VitEmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'Chưa có lệnh',
        message: 'Lệnh gửi từ terminal sẽ hiện tại đây.',
      );
    }
    return VitCard(
      key: OrdersHistoryTabletPage.tableKey,
      radius: VitCardRadius.tight,
      borderColor: AppColors.border,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        children: [
          const _OrdersTableHeader(),
          for (var i = 0; i < orders.length; i++) ...[
            _OrderTableRow(
              key: OrdersHistoryTabletPage.orderKey(orders[i].id),
              order: orders[i],
              isFirstOpen: activeTab == 'open' && i == 0,
              onCancel: () => onCancel(orders[i].id),
            ),
            if (i < orders.length - 1)
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

class _OrdersTableHeader extends StatelessWidget {
  const _OrdersTableHeader();

  static const _columnFlex = [3, 2, 2, 2, 2, 2, 2, 3];

  @override
  Widget build(BuildContext context) {
    final labels = [
      'Cặp · Loại',
      'Giá',
      'Khối lượng',
      'Đã khớp',
      'Phí',
      'Trạng thái',
      'Thời gian',
      'Hành động',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TabletSpacingTokens.x3,
        vertical: TabletSpacingTokens.x2,
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            Expanded(
              flex: _columnFlex[i],
              child: Text(
                labels[i],
                maxLines: 1,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderTableRow extends StatelessWidget {
  const _OrderTableRow({
    super.key,
    required this.order,
    required this.isFirstOpen,
    required this.onCancel,
  });

  final TradeHistoryOrder order;
  final bool isFirstOpen;
  final VoidCallback onCancel;

  static const _columnFlex = [3, 2, 2, 2, 2, 2, 3];

  String get _typeLabel => switch (order.type) {
    TradeOrderType.limit => 'Giới hạn',
    TradeOrderType.stop => 'Điểm dừng',
    TradeOrderType.market => 'Thị trường',
  };

  String get _statusLabel => switch (order.status) {
    TradeOrderStatus.open => 'Đang mở',
    TradeOrderStatus.partial => 'Khớp một phần',
    TradeOrderStatus.filled => 'Đã khớp',
    TradeOrderStatus.cancelled => 'Đã hủy',
  };

  @override
  Widget build(BuildContext context) {
    final sideColor = order.side == TradeOrderSide.buy
        ? AppColors.buy
        : AppColors.sell;
    final canCancel =
        order.status == TradeOrderStatus.open ||
        order.status == TradeOrderStatus.partial;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TabletSpacingTokens.x3,
        vertical: TabletSpacingTokens.x2,
      ),
      child: Row(
        children: [
          Expanded(
            flex: _columnFlex[0],
            child: Text.rich(
              TextSpan(
                text: order.side == TradeOrderSide.buy ? 'MUA ' : 'BÁN ',
                style: AppTextStyles.caption.copyWith(
                  color: sideColor,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
                children: [
                  TextSpan(
                    text: '${order.symbol} · $_typeLabel',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          for (final (index, value) in [
            order.price.toStringAsFixed(2),
            order.amount.toStringAsFixed(3),
            order.filled.toStringAsFixed(3),
            order.fee.toStringAsFixed(2),
          ].indexed)
            Expanded(
              flex: _columnFlex[index + 1],
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
            flex: _columnFlex[5],
            child: VitStatusPill(
              label: _statusLabel,
              status: order.status == TradeOrderStatus.filled
                  ? VitStatusPillStatus.success
                  : order.status == TradeOrderStatus.cancelled
                  ? VitStatusPillStatus.neutral
                  : VitStatusPillStatus.warning,
              size: VitStatusPillSize.sm,
            ),
          ),
          Expanded(
            flex: _columnFlex[6],
            child: Text(
              order.createdAt,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          if (canCancel)
            TextButton(
              key: isFirstOpen
                  ? OrdersHistoryTabletPage.cancelFirstOrderKey
                  : null,
              onPressed: onCancel,
              child: Text(
                'Hủy lệnh',
                style: AppTextStyles.caption.copyWith(color: AppColors.sell),
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

/// Panel thống kê: số lệnh theo trạng thái + tổng phí lịch sử.
class _OrderStatsCard extends StatelessWidget {
  const _OrderStatsCard({required this.snapshot});

  final TradeOrdersHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final filled = snapshot.historyOrders
        .where((order) => order.status == TradeOrderStatus.filled)
        .length;
    final cancelled = snapshot.historyOrders
        .where((order) => order.status == TradeOrderStatus.cancelled)
        .length;
    final totalFee = snapshot.historyOrders.fold<double>(
      0,
      (sum, order) => sum + order.fee,
    );
    return VitCard(
      key: OrdersHistoryTabletPage.statsKey,
      radius: VitCardRadius.tight,
      borderColor: AppColors.border,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (label, value, color) in [
            ('Lệnh đang mở', '${snapshot.openOrders.length}', AppColors.text1),
            ('Đã khớp', '$filled', AppColors.buy),
            ('Đã hủy', '$cancelled', AppColors.text3),
          ])
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TabletSpacingTokens.x2,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    value,
                    style: AppTextStyles.control.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
          const Divider(
            height: TabletSpacingTokens.dividerHairline,
            thickness: TabletSpacingTokens.dividerHairline,
            color: AppColors.divider,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: TabletSpacingTokens.x2,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Tổng phí đã trả',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                Text(
                  formatTradeMoney(totalFee),
                  style: AppTextStyles.control.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
