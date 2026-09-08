import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_terminal_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của Công cụ nâng cao (SC-062): ba công cụ (thang giá · hủy
/// hàng loạt · phím tắt) mở dạng bảng inline trên cột chính thay vì sheet,
/// cột phụ là thẻ tính năng + checklist trạng thái.
class AdvancedToolsTabletPage extends ConsumerStatefulWidget {
  const AdvancedToolsTabletPage({super.key});

  static const contentKey = Key('sc062_tablet_content');
  static const ladderSubmitKey = Key('sc062_tablet_submit_ladder');
  static const bulkCancelKey = Key('sc062_tablet_cancel_bulk');
  static const shortcutTriggerKey = Key('sc062_tablet_trigger_shortcut');

  static Key tabKey(String id) => Key('sc062_tablet_tab_$id');

  @override
  ConsumerState<AdvancedToolsTabletPage> createState() =>
      _AdvancedToolsTabletPageState();
}

class _AdvancedToolsTabletPageState
    extends ConsumerState<AdvancedToolsTabletPage> {
  String _tab = 'ladder';

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(tradeAdvancedToolsControllerProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Công cụ nâng cao',
      semanticIdentifier: 'SC-062',
      child: Column(
        children: [
          VitHeader(
            title: 'Công cụ nâng cao',
            subtitle: 'Thang giá · Hàng loạt · Phím tắt',
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
                  title: 'Không tải được công cụ nâng cao',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(tradeAdvancedToolsSnapshotProvider),
                ),
              ),
              data: (controller) {
                final snapshot = controller.state.snapshot;
                return VitTwoColumnTabletDashboard(
                  onRefresh: () async {
                    ref.invalidate(tradeAdvancedToolsSnapshotProvider);
                    await ref.read(tradeAdvancedToolsSnapshotProvider.future);
                  },
                  primaryChildren: [
                    VitCard(
                      key: AdvancedToolsTabletPage.contentKey,
                      variant: VitCardVariant.inner,
                      radius: VitCardRadius.tight,
                      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xem lại công cụ lệnh nâng cao',
                            message:
                                'Thang giá, hủy hàng loạt và phím tắt giữ xem trước lệnh, xác nhận, số lệnh bị ảnh hưởng và bước tiếp theo trước khi thực thi.',
                            contractId: 'advanced-tools-tablet-review',
                            density: VitDensity.tool,
                          ),
                          const SizedBox(height: TabletSpacingTokens.x4),
                          const VitStatusPill(
                            label: 'Xem trước khi gửi lệnh',
                            status: VitStatusPillStatus.info,
                            size: VitStatusPillSize.sm,
                          ),
                          const SizedBox(height: TabletSpacingTokens.x4),
                          VitSegmentedTabBar(
                            tabs: [
                              VitTabItem(
                                key: 'ladder',
                                label: 'Thang giá',
                                widgetKey: AdvancedToolsTabletPage.tabKey(
                                  'ladder',
                                ),
                              ),
                              VitTabItem(
                                key: 'bulk',
                                label:
                                    'Hàng loạt (${snapshot.bulkOrders.length})',
                                widgetKey: AdvancedToolsTabletPage.tabKey(
                                  'bulk',
                                ),
                              ),
                              VitTabItem(
                                key: 'shortcuts',
                                label: 'Phím tắt',
                                widgetKey: AdvancedToolsTabletPage.tabKey(
                                  'shortcuts',
                                ),
                              ),
                            ],
                            activeKey: _tab,
                            onChanged: (tab) => setState(() => _tab = tab),
                          ),
                        ],
                      ),
                    ),
                    if (_tab == 'ladder')
                      _LadderCard(
                        orders: snapshot.ladderOrders,
                        onSubmit: _submitLadder,
                      )
                    else if (_tab == 'bulk')
                      _BulkCard(
                        orders: snapshot.bulkOrders,
                        onCancel: _cancelBulk,
                      )
                    else
                      _ShortcutsCard(
                        shortcuts: snapshot.shortcuts,
                        onTrigger: _triggerShortcut,
                      ),
                  ],
                  secondaryChildren: [
                    for (final feature in snapshot.features)
                      VitCard(
                        radius: VitCardRadius.tight,
                        borderColor: AppColors.border,
                        padding: const EdgeInsets.all(TabletSpacingTokens.x4),
                        child: Text(
                          feature.title,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                    VitCard(
                      radius: VitCardRadius.tight,
                      borderColor: AppColors.border,
                      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final item in snapshot.statusItems)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: TabletSpacingTokens.x2,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.text2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: TabletSpacingTokens.x2),
                                  Icon(
                                    item.complete
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    size: TabletSpacingTokens.iconSm,
                                    color: item.complete
                                        ? AppColors.buy
                                        : AppColors.text3,
                                  ),
                                ],
                              ),
                            ),
                        ],
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

  Future<void> _submitLadder() async {
    final controller = ref.read(tradeAdvancedToolsControllerProvider).value;
    if (controller == null) return;
    await controller.submitAction(
      const TradeAdvancedToolActionRequest(
        toolId: 'ladder',
        action: 'place-order',
      ),
    );
    if (!mounted) return;
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Đặt lệnh thành công',
        message: 'Đã đặt lệnh thang giá theo cầu đã chọn',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      ),
    );
  }

  Future<void> _cancelBulk() async {
    final controller = ref.read(tradeAdvancedToolsControllerProvider).value;
    if (controller == null) return;
    final orderIds = controller.state.snapshot.bulkOrders
        .map((order) => order.id)
        .toList(growable: false);
    final result = await controller.submitAction(
      TradeAdvancedToolActionRequest(
        toolId: 'bulk',
        action: 'cancel',
        orderIds: orderIds,
      ),
    );
    if (!mounted) return;
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Hủy lệnh thành công',
        message: 'Đã hủy ${result.affectedCount} lệnh',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      ),
    );
  }

  Future<void> _triggerShortcut() async {
    final controller = ref.read(tradeAdvancedToolsControllerProvider).value;
    if (controller == null) return;
    await controller.submitAction(
      const TradeAdvancedToolActionRequest(
        toolId: 'shortcuts',
        action: 'trigger',
      ),
    );
    if (!mounted) return;
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Kích hoạt thành công',
        message: 'Phím tắt · Quick Buy',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      ),
    );
  }
}

class _LadderCard extends StatelessWidget {
  const _LadderCard({required this.orders, required this.onSubmit});

  final List<TradeLadderOrder> orders;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(TabletSpacingTokens.x4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Thang giá · các bậc đã cấu hình',
                    style: AppTextStyles.control.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                ),
                VitCtaButton(
                  key: AdvancedToolsTabletPage.ladderSubmitKey,
                  fullWidth: false,
                  onPressed: onSubmit,
                  child: const Text('Đặt lệnh thang'),
                ),
              ],
            ),
          ),
          const Divider(
            height: TabletSpacingTokens.dividerHairline,
            thickness: TabletSpacingTokens.dividerHairline,
            color: AppColors.divider,
          ),
          for (var i = 0; i < orders.length; i++) ...[
            _LadderRow(order: orders[i]),
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

class _LadderRow extends StatelessWidget {
  const _LadderRow({required this.order});

  final TradeLadderOrder order;

  @override
  Widget build(BuildContext context) {
    final sideColor = order.side == TradeOrderSide.buy
        ? AppColors.buy
        : AppColors.sell;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TabletSpacingTokens.x4,
        vertical: TabletSpacingTokens.x3,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              order.side == TradeOrderSide.buy ? 'MUA' : 'BÁN',
              style: AppTextStyles.caption.copyWith(
                color: sideColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              formatTradePrice(order.price),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              order.amount.toStringAsFixed(3),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Khớp ${(order.filled * 100).toStringAsFixed(0)}%',
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

class _BulkCard extends StatelessWidget {
  const _BulkCard({required this.orders, required this.onCancel});

  final List<TradeBulkOrder> orders;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(TabletSpacingTokens.x4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Hủy hàng loạt · ${orders.length} lệnh đang mở',
                    style: AppTextStyles.control.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                ),
                VitCtaButton(
                  key: AdvancedToolsTabletPage.bulkCancelKey,
                  fullWidth: false,
                  variant: VitCtaButtonVariant.danger,
                  onPressed: orders.isEmpty ? null : onCancel,
                  child: const Text('Hủy tất cả'),
                ),
              ],
            ),
          ),
          const Divider(
            height: TabletSpacingTokens.dividerHairline,
            thickness: TabletSpacingTokens.dividerHairline,
            color: AppColors.divider,
          ),
          for (final order in orders)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TabletSpacingTokens.x4,
                vertical: TabletSpacingTokens.x2,
              ),
              child: _BulkOrderRow(order: order),
            ),
        ],
      ),
    );
  }
}

class _BulkOrderRow extends StatelessWidget {
  const _BulkOrderRow({required this.order});

  final TradeBulkOrder order;

  @override
  Widget build(BuildContext context) {
    final sideLabel = order.side == TradeOrderSide.buy ? 'MUA' : 'BÁN';
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            '$sideLabel ${order.symbol}',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            formatTradePrice(order.price),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            order.amount.toStringAsFixed(3),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _ShortcutsCard extends StatelessWidget {
  const _ShortcutsCard({required this.shortcuts, required this.onTrigger});

  final List<TradeShortcut> shortcuts;
  final VoidCallback onTrigger;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Phím tắt · tra cứu nhanh',
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
              ),
              VitCtaButton(
                key: AdvancedToolsTabletPage.shortcutTriggerKey,
                fullWidth: false,
                onPressed: onTrigger,
                child: const Text('Kích hoạt Quick Buy'),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          for (final shortcut in shortcuts)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TabletSpacingTokens.x2,
              ),
              child: Row(
                children: [
                  VitStatusPill(
                    label: shortcut.keys,
                    status: VitStatusPillStatus.neutral,
                    size: VitStatusPillSize.sm,
                  ),
                  const SizedBox(width: TabletSpacingTokens.x3),
                  Expanded(
                    child: Text(
                      '${shortcut.label} — ${shortcut.description}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
