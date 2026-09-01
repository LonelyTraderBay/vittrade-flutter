import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part '../../../widgets/phone/orders_history_page_sections.dart';
part '../../../widgets/phone/orders_history_page_common.dart';

const _tradePrimary = AppColors.primary;
const double _ordersStatusExtent = AppSpacing.buttonStandard + AppSpacing.x5;

class OrdersHistoryPage extends ConsumerStatefulWidget {
  const OrdersHistoryPage({super.key, this.shellRenderMode});

  static const openTabKey = Key('sc050_open_tab');
  static const historyTabKey = Key('sc050_history_tab');
  static const cancelFirstOrderKey = Key('sc050_cancel_first_order');
  static Key filterKey(String id) => Key('sc050_filter_$id');
  static Key orderKey(String id) => Key('sc050_order_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<OrdersHistoryPage> createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends ConsumerState<OrdersHistoryPage> {
  String _activeTab = 'open';
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(tradeOrdersHistoryControllerProvider);

    return VitTradeHubScaffold(
      title: 'Lịch sử lệnh',
      subtitle: 'Lịch sử lệnh · Spot',
      semanticLabel: 'Lịch sử lệnh giao dịch',
      semanticIdentifier: 'SC-050',
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      showProductTabs: true,
      navigationBuilder: buildTradeProductNavigation,
      children: controllerAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được lịch sử lệnh',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(tradeOrdersHistoryControllerProvider),
          ),
        ],
        data: (controller) {
          final snapshot = controller.state.snapshot;
          final orders = _visibleOrders(snapshot);
          return [
            _OrderTopTabs(
              active: _activeTab,
              openCount: snapshot.openOrders.length,
              historyCount: snapshot.historyOrders.length,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            _FilterRow(
              active: _filter,
              onChanged: (filter) => setState(() => _filter = filter),
            ),
            if (orders.isEmpty)
              _EmptyState(activeTab: _activeTab)
            else
              VitCard(
                clip: true,
                radius: VitCardRadius.tight,
                child: Column(
                  children: [
                    for (var i = 0; i < orders.length; i++) ...[
                      _OrderHistoryTile(
                        key: OrdersHistoryPage.orderKey(orders[i].id),
                        order: orders[i],
                        grouped: true,
                        actionKey: i == 0
                            ? OrdersHistoryPage.cancelFirstOrderKey
                            : null,
                        onCancel: () => _cancelOrder(orders[i].id),
                      ),
                      if (i < orders.length - 1)
                        const Divider(
                          height: AppSpacing.dividerHairline,
                          thickness: AppSpacing.dividerHairline,
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
