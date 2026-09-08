import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
part 'p2p_order_tablet_pages_sections.dart';

/// Khuôn dùng chung cho các trang lệnh P2P tablet (chi tiết / timeline /
/// đánh giá / hủy / bằng chứng): header + vùng nội dung 900dp + contract
/// notes. Mỗi trang tự dựng nội dung theo snapshot của mình.
Widget p2pOrderPageFrame({
  required BuildContext context,
  required String semanticIdentifier,
  required String semanticLabel,
  required String title,
  required String subtitle,
  required String contractNotes,
  required Widget body,
  Key? bodyKey,
}) {
  final showBack = context.canPop();
  return VitPageLayout(
    variant: VitPageVariant.flush,
    semanticLabel: semanticLabel,
    semanticIdentifier: semanticIdentifier,
    child: Column(
      children: [
        VitHeader(
          title: title,
          subtitle: subtitle,
          showBack: showBack,
          onBack: showBack
              ? () => goBackOrFallback(
                  context,
                  fallbackPath: AppRoutePaths.p2pMyOrders,
                  mode: BackNavigationMode.historyThenFallback,
                )
              : null,
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: SingleChildScrollView(
                key: bodyKey,
                padding: const EdgeInsets.fromLTRB(
                  TabletSpacingTokens.x6,
                  TabletSpacingTokens.x4,
                  TabletSpacingTokens.x6,
                  TabletSpacingTokens.x6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    body,
                    const SizedBox(height: TabletSpacingTokens.x3),
                    if (contractNotes.isNotEmpty)
                      Text(
                        contractNotes,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget p2pErrorBody({required String title, required VoidCallback onRetry}) {
  return VitErrorState(
    title: title,
    message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

/// Trang chi tiết lệnh P2P (SC-216): bảng tham số lệnh + thanh toán + cảnh
/// báo chuyển tiền + quick actions.
class P2POrderTabletPage extends ConsumerWidget {
  const P2POrderTabletPage({super.key, required this.orderId});

  static const contentKey = Key('sc216_tablet_content');

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pOrderProvider(orderId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => p2pOrderPageFrame(
        context: context,
        semanticIdentifier: 'SC-216',
        semanticLabel: 'Chi tiết lệnh P2P',
        title: 'Chi tiết lệnh',
        subtitle: orderId,
        contractNotes: '',
        body: p2pErrorBody(
          title: 'Không tải được chi tiết lệnh',
          onRetry: () => ref.invalidate(p2pOrderProvider(orderId)),
        ),
      ),
      data: (snapshot) => p2pOrderPageFrame(
        context: context,
        semanticIdentifier: 'SC-216',
        semanticLabel: 'Chi tiết lệnh P2P',
        title: 'Chi tiết lệnh ${snapshot.order.orderNumber}',
        subtitle: '${snapshot.order.typeLabel} · ${snapshot.order.statusLabel}',
        contractNotes: snapshot.contractNotes,
        bodyKey: P2POrderTabletPage.contentKey,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${snapshot.order.typeLabel} ${snapshot.order.asset}',
                          style: AppTextStyles.control.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      VitStatusPill(
                        label: snapshot.order.statusLabel,
                        status: VitStatusPillStatus.info,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ),
                  const SizedBox(height: TabletSpacingTokens.x1),
                  Text(
                    'Hết hạn sau: ${snapshot.order.countdownLabel}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.caution,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x3),
                  for (final (label, value) in [
                    (
                      'Số lượng',
                      '${formatP2PCrypto(snapshot.order.amount)} ${snapshot.order.asset}',
                    ),
                    ('Giá', formatP2PVnd(snapshot.order.priceVnd)),
                    ('Tổng', formatP2PVnd(snapshot.order.totalVnd)),
                    ('Merchant', snapshot.order.merchant),
                    ('Phí', snapshot.order.feeLabel),
                    ('Escrow', formatP2PVnd(snapshot.order.escrowAmount)),
                  ])
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingV,
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
                            style: AppTextStyles.caption.copyWith(
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
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.safetyTitle,
                    style: AppTextStyles.control.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x2),
                  for (final bullet in snapshot.safetyBullets)
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingV,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.zero,
                            child: Icon(
                              Icons.check_circle_outline_rounded,
                              size: TabletSpacingTokens.iconSm,
                              color: AppColors.buy,
                            ),
                          ),
                          const SizedBox(width: TabletSpacingTokens.x2),
                          Expanded(
                            child: Text(
                              bullet,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            if (snapshot.paymentFields.isNotEmpty)
              VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.cardPaddingCompact,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin thanh toán',
                      style: AppTextStyles.control.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: TabletSpacingTokens.x2),
                    for (final field in snapshot.paymentFields)
                      Padding(
                        padding: TabletSpacingTokens.tableCellPaddingV,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                field.label,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ),
                            Text(
                              field.value,
                              style: AppTextStyles.caption.copyWith(
                                color: field.emphasis
                                    ? AppColors.text1
                                    : AppColors.text2,
                                fontWeight: field.emphasis
                                    ? AppTextStyles.bold
                                    : AppTextStyles.normal,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: TabletSpacingTokens.x3),
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              density: VitDensity.tool,
              title: 'Chuyển tiền trong khung giờ',
              message:
                  'Chỉ chuyển khoản theo thông tin hiển thị trong lệnh. Ghi chú nội dung sai có thể làm chậm escrow.',
              contractId: 'p2p-order-tablet-transfer',
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            if (snapshot.quickActions.isNotEmpty)
              Wrap(
                spacing: TabletSpacingTokens.x3,
                runSpacing: TabletSpacingTokens.x2,
                children: [
                  for (final action in snapshot.quickActions)
                    VitCtaButton(
                      fullWidth: false,
                      variant: VitCtaButtonVariant.secondary,
                      onPressed: () => context.go(action.route),
                      child: Text(action.label),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Mixin hạn chế: các chuỗi fallback khai báo const để dùng trong const panel.

/// Dòng thời gian lệnh P2P (SC-212).
class P2POrderTimelineTabletPage extends ConsumerWidget {
  const P2POrderTimelineTabletPage({super.key, required this.orderId});

  static const contentKey = Key('sc212_tablet_content');

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pOrderTimelineProvider(orderId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => p2pOrderPageFrame(
        context: context,
        semanticIdentifier: 'SC-212',
        semanticLabel: 'Dòng thời gian lệnh P2P',
        title: 'Dòng thời gian',
        subtitle: orderId,
        contractNotes: '',
        body: p2pErrorBody(
          title: 'Không tải được dòng thời gian',
          onRetry: () => ref.invalidate(p2pOrderTimelineProvider(orderId)),
        ),
      ),
      data: (snapshot) => p2pOrderPageFrame(
        context: context,
        semanticIdentifier: 'SC-212',
        semanticLabel: 'Dòng thời gian lệnh P2P',
        title: 'Dòng thời gian lệnh',
        subtitle: '${snapshot.order.orderNumber} · ${snapshot.order.status}',
        contractNotes: snapshot.contractNotes,
        bodyKey: P2POrderTimelineTabletPage.contentKey,
        body: VitCard(
          radius: VitCardRadius.tight,
          padding: TabletSpacingTokens.cardPaddingCompact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < snapshot.events.length; i++) ...[
                _TimelineEventRow(
                  event: snapshot.events[i],
                  isLast: i == snapshot.events.length - 1,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineEventRow extends StatelessWidget {
  const _TimelineEventRow({required this.event, required this.isLast});

  final P2POrderTimelineEventDraft event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: TabletSpacingTokens.x7,
            child: Column(
              children: [
                const ClipOval(
                  child: ColoredBox(
                    color: AppColors.primary,
                    child: SizedBox(
                      width: TabletSpacingTokens.x2,
                      height: TabletSpacingTokens.x2,
                    ),
                  ),
                ),
                if (!isLast)
                  const Expanded(
                    child: SizedBox(
                      width: TabletSpacingTokens.dividerHairline,
                      child: ColoredBox(
                        color: AppColors.borderSolid,
                        child: SizedBox.expand(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                  Text(
                    '${event.time} · ${event.actor}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
