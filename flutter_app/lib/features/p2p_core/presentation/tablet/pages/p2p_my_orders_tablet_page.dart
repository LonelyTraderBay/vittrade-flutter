import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của Đơn hàng P2P của tôi (SC-281): chip tab trạng thái +
/// bảng đơn độ dày tablet (mã · loại · tài sản · giá trị · trạng thái · thời
/// gian), bấm hàng mở chi tiết.
class P2PMyOrdersTabletPage extends ConsumerStatefulWidget {
  const P2PMyOrdersTabletPage({super.key});

  static const contentKey = Key('sc281_tablet_content');

  @override
  ConsumerState<P2PMyOrdersTabletPage> createState() =>
      _P2PMyOrdersTabletPageState();
}

class _P2PMyOrdersTabletPageState extends ConsumerState<P2PMyOrdersTabletPage> {
  String? _activeTabId;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pMyOrdersProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Đơn hàng P2P của tôi',
      semanticIdentifier: 'SC-281',
      child: Column(
        children: [
          VitHeader(
            title: 'Đơn hàng của tôi',
            subtitle: 'Lệnh · Trạng thái · Lịch sử',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2p,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được đơn hàng',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(p2pMyOrdersProvider),
                ),
              ),
              data: (snapshot) {
                final activeTabId = _activeTabId ?? snapshot.defaultTab;
                final visibleOrders = [
                  for (final order in snapshot.orders)
                    if (order.status == activeTabId ||
                        snapshot.tabs
                            .where((tab) => tab.id == activeTabId)
                            .isEmpty)
                      order,
                ];
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: SingleChildScrollView(
                      key: P2PMyOrdersTabletPage.contentKey,
                      padding: const EdgeInsets.fromLTRB(
                        TabletSpacingTokens.x6,
                        TabletSpacingTokens.x4,
                        TabletSpacingTokens.x6,
                        TabletSpacingTokens.x6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            spacing: TabletSpacingTokens.x3,
                            runSpacing: TabletSpacingTokens.x2,
                            children: [
                              for (final tab in snapshot.tabs)
                                VitFilterChip(
                                  label: tab.label,
                                  active: activeTabId == tab.id,
                                  onTap: () => setState(() {
                                    _activeTabId = tab.id;
                                  }),
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          if (visibleOrders.isEmpty)
                            VitEmptyState(
                              icon: Icons.receipt_long_outlined,
                              title: snapshot.emptyTitle,
                              message: snapshot.searchHint,
                              actionLabel: 'Về chợ P2P',
                              onAction: () => context.go(AppRoutePaths.p2p),
                            )
                          else
                            VitCard(
                              radius: VitCardRadius.tight,
                              padding: TabletSpacingTokens.zeroInsets,
                              clip: true,
                              child: Column(
                                children: [
                                  for (
                                    var i = 0;
                                    i < visibleOrders.length;
                                    i++
                                  ) ...[
                                    _OrderRow(
                                      order: visibleOrders[i],
                                      onTap: () => context.go(
                                        AppRoutePaths.p2pOrder(
                                          visibleOrders[i].id,
                                        ),
                                      ),
                                    ),
                                    if (i < visibleOrders.length - 1)
                                      const Divider(
                                        height:
                                            TabletSpacingTokens.dividerHairline,
                                        thickness:
                                            TabletSpacingTokens.dividerHairline,
                                        color: AppColors.divider,
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          const SizedBox(height: TabletSpacingTokens.x3),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order, required this.onTap});

  final P2PMyOrderDraft order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isBuy = order.type == 'buy';
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: TabletSpacingTokens.tableCellPadding,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text.rich(
                TextSpan(
                  text: isBuy ? 'MUA ' : 'BÁN ',
                  style: AppTextStyles.caption.copyWith(
                    color: isBuy ? AppColors.buy : AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '${order.asset} · ${order.orderNumber}',
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
            Expanded(
              flex: 2,
              child: Text(
                formatP2PCrypto(order.amount),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                formatP2PVnd(order.total),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            SizedBox(
              width: TabletSpacingTokens.x7,
              child: VitStatusPill(
                label: order.status,
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
            ),
            SizedBox(
              width: TabletSpacingTokens.x7,
              child: Text(
                order.createdAt,
                textAlign: TextAlign.end,
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
      ),
    );
  }
}
