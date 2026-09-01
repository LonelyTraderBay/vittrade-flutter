import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/orders/p2p_my_orders_page_sections.dart';
part '../../../widgets/orders/p2p_my_orders_page_common.dart';

const double _p2pMyOrdersVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pMyOrdersNativeNavClearance =
    _p2pMyOrdersVisualNavClearance - AppSpacing.x4;
const double _p2pMyOrdersVisualClearance = AppSpacing.x3;
const double _p2pMyOrdersNativeClearance = AppSpacing.x2;
const double _p2pMyOrdersSectionGap = AppSpacing.x3;
const double _p2pMyOrdersTightGap = AppSpacing.x2;
const double _p2pMyOrdersDividerHeight = AppSpacing.dividerHairline;

enum _OrdersSort { date, amount }

class P2PMyOrdersPage extends ConsumerStatefulWidget {
  const P2PMyOrdersPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc281_p2p_my_orders_content');
  static const dashboardKey = Key('sc281_p2p_my_orders_dashboard');
  static const statsKey = Key('sc281_p2p_my_orders_stats');
  static const searchKey = Key('sc281_p2p_my_orders_search');
  static const sortKey = Key('sc281_p2p_my_orders_sort');
  static const emptyKey = Key('sc281_p2p_my_orders_empty');
  static const guideKey = Key('sc281_p2p_my_orders_guide');

  static Key tabKey(String id) => Key('sc281_p2p_my_orders_tab_$id');
  static Key orderKey(String id) => Key('sc281_p2p_my_orders_order_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PMyOrdersPage> createState() => _P2PMyOrdersPageState();
}

class _P2PMyOrdersPageState extends ConsumerState<P2PMyOrdersPage> {
  final TextEditingController _searchController = TextEditingController();
  late String _tab;
  String _query = '';
  _OrdersSort _sort = _OrdersSort.date;
  bool _initialized = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pMyOrdersProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pMyOrdersVisualNavClearance + _p2pMyOrdersVisualClearance
            : _p2pMyOrdersNativeNavClearance + _p2pMyOrdersNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Đơn P2P của tôi',
      semanticIdentifier: 'SC-281',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pMyOrdersProvider),
            ),
          ),
          data: (snapshot) {
            _ensureState(snapshot);
            final orders = _filteredOrders(snapshot.orders);
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                subtitle: snapshot.subtitle,
                showBack: true,
                onBack: () => context.go(snapshot.parentRoute),
                actions: [
                  VitHeaderActionItem(
                    key: P2PMyOrdersPage.dashboardKey,
                    type: VitHeaderActionType.analytics,
                    tooltip: 'P2P Dashboard',
                    onPressed: () => context.go(snapshot.dashboardRoute),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        key: P2PMyOrdersPage.contentKey,
                        physics: const ClampingScrollPhysics(),
                        padding: P2PSpacingTokens.p2pMyOrdersScrollPadding(
                          scrollEndPadding,
                        ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.standard,
                          padding: VitContentPadding.none,
                          fullBleed: true,
                          gap: VitContentGap.tight,
                          children: [
                            _StatsRow(snapshot: snapshot),
                            _OrderTabs(
                              snapshot: snapshot,
                              active: _tab,
                              onChanged: (value) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _tab = value);
                              },
                            ),
                            _SearchSortRow(
                              hint: snapshot.searchHint,
                              controller: _searchController,
                              sort: _sort,
                              onQueryChanged: (value) =>
                                  setState(() => _query = value),
                              onSort: () {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() {
                                  _sort = _sort == _OrdersSort.date
                                      ? _OrdersSort.amount
                                      : _OrdersSort.date;
                                });
                              },
                            ),
                            if (orders.isEmpty)
                              _EmptyOrders(snapshot: snapshot, activeTab: _tab)
                            else
                              for (final order in orders)
                                _OrderCard(
                                  order: order,
                                  onTap: () => _openOrder(context, order),
                                  onDispute: order.status == 'disputed'
                                      ? () => context.go(
                                          AppRoutePaths.p2pDisputeDetail(
                                            order.id,
                                          ),
                                        )
                                      : null,
                                ),
                            const VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Xem lại danh sách đơn P2P',
                              message:
                                  'Đơn chờ, hoàn tất và tranh chấp giữ trạng thái, số tiền, merchant, route chi tiết và bước thanh toán tiếp theo trước khi điều hướng.',
                              contractId: 'p2p-my-orders-review',
                            ),
                            Text(
                              snapshot.contractNotes,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _ensureState(P2PMyOrdersSnapshot snapshot) {
    if (_initialized) return;
    _tab = snapshot.defaultTab;
    _initialized = true;
  }

  List<P2PMyOrderDraft> _filteredOrders(List<P2PMyOrderDraft> orders) {
    final query = _query.trim().toLowerCase();
    final filtered = orders.where((order) {
      final inTab = switch (_tab) {
        'completed' =>
          order.status == 'released' || order.status == 'cancelled',
        'disputed' => order.status == 'disputed',
        _ => order.status == 'pending_payment' || order.status == 'paid',
      };
      if (!inTab) return false;
      if (query.isEmpty) return true;
      return order.id.toLowerCase().contains(query) ||
          order.orderNumber.toLowerCase().contains(query) ||
          order.merchant.toLowerCase().contains(query);
    }).toList();
    filtered.sort((a, b) {
      if (_sort == _OrdersSort.amount) return b.total.compareTo(a.total);
      return b.createdAt.compareTo(a.createdAt);
    });
    return filtered;
  }

  void _openOrder(BuildContext context, P2PMyOrderDraft order) {
    unawaited(HapticFeedback.selectionClick());
    if (order.status == 'disputed') {
      context.go(AppRoutePaths.p2pDisputeDetail(order.id));
      return;
    }
    context.go(AppRoutePaths.p2pOrder(order.id));
  }
}
