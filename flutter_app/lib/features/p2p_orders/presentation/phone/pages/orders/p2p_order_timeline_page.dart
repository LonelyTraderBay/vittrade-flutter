import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

class P2POrderTimelinePage extends ConsumerWidget {
  const P2POrderTimelinePage({
    super.key,
    required this.orderId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc212_p2p_order_timeline_content');
  static const emptyKey = Key('sc212_p2p_order_timeline_empty');
  static const summaryKey = Key('sc212_p2p_order_timeline_summary');

  final String orderId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pOrderTimelineProvider(orderId));
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tiến trình đơn hàng P2P',
      semanticIdentifier: 'SC-212',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tiến trình #$orderId',
            subtitle: 'Đơn hàng - P2P',
            showBack: true,
            onBack: () => _close(context, orderId),
          ),
          child: snapshotAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pOrderTimelineProvider(orderId)),
            ),
            data: (snapshot) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: RefreshIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      onRefresh: () async {
                        unawaited(HapticFeedback.selectionClick());
                        await Future<void>.delayed(
                          const Duration(milliseconds: 80),
                        );
                      },
                      child: SingleChildScrollView(
                        key: contentKey,
                        physics: const ClampingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        padding:
                            P2PSpacingTokens.p2pOrderLifecycleScrollPadding(
                              bottomInset,
                            ),
                        child: snapshot.events.isEmpty
                            ? VitPageContent(
                                rhythm: VitPageRhythm.standard,
                                key: emptyKey,
                                padding: VitContentPadding.none,
                                children: [
                                  VitEmptyState(
                                    icon: Icons.timeline_rounded,
                                    title: snapshot.emptyTitle,
                                    message: snapshot.emptySubtitle,
                                  ),
                                ],
                              )
                            : VitPageContent(
                                padding: VitContentPadding.compact,
                                gap: VitContentGap.tight,
                                children: [
                                  const _TimelineHeroCard(),
                                  _TimelineSummary(
                                    key: P2POrderTimelinePage.summaryKey,
                                    snapshot: snapshot,
                                  ),
                                  if (snapshot.highRiskContractId != null)
                                    VitHighRiskStatePanel(
                                      state: VitHighRiskUiState.riskReview,
                                      title: 'Theo dõi an toàn giao dịch',
                                      message:
                                          'Escrow, số tiền và các mốc thanh toán của đơn được theo dõi trong hợp đồng P2P. Kiểm tra trạng thái trước khi thực hiện bước tiếp theo.',
                                      contractId: snapshot.highRiskContractId,
                                    ),
                                  _TimelineList(events: snapshot.events),
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
      ),
    );
  }

  static void _close(BuildContext context, String orderId) {
    unawaited(HapticFeedback.selectionClick());
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.p2pOrder(orderId),
      mode: BackNavigationMode.historyThenFallback,
    );
  }
}

class _TimelineHeroCard extends StatelessWidget {
  const _TimelineHeroCard();

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      child: Row(
        children: [
          const VitAccentIconBox(
            icon: Icons.schedule_rounded,
            color: AppColors.primary,
            boxSize: AppSpacing.x7,
            iconSize: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tiến trình đơn hàng',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Cập nhật trạng thái theo thời gian thực',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineSummary extends StatelessWidget {
  const _TimelineSummary({super.key, required this.snapshot});

  final P2POrderTimelineSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitMetricCard(
      label: 'Trạng thái hiện tại',
      value: _localizedOrderStatus(snapshot.order.status),
      accentColor: AppColors.primary,
      density: VitDensity.compact,
    );
  }
}

class _TimelineList extends StatelessWidget {
  const _TimelineList({required this.events});

  final List<P2POrderTimelineEventDraft> events;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          left: AppSpacing.x6 / 2,
          top: AppSpacing.x1,
          bottom: AppSpacing.x6,
          child: SizedBox(
            width: P2PSpacingTokens.p2pOrderTimelineConnectorWidth,
            child: ColoredBox(color: AppColors.borderSolid),
          ),
        ),
        Column(
          children: [
            for (var index = 0; index < events.length; index++)
              _TimelineRow(
                event: events[index],
                isLast: index == events.length - 1,
              ),
          ],
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.event, required this.isLast});

  final P2POrderTimelineEventDraft event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(event.status);
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: isLast ? 0 : AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: _statusBackground(event.status),
            shape: CircleBorder(
              side: BorderSide(
                color: color,
                width: P2PSpacingTokens.p2pOrderStepperConnectorHeight,
              ),
            ),
            child: SizedBox.square(
              dimension: AppSpacing.x6,
              child: Icon(
                _eventIcon(event.typeKey),
                color: color,
                size: P2PSpacingTokens.p2pOrderTimelineEventIcon,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitCard(
              padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      VitStatusPill(
                        label: event.statusLabel,
                        status: _pillStatus(event.status),
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Text(
                    'By: ${event.actor}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    event.time,
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

IconData _eventIcon(String typeKey) {
  return switch (typeKey) {
    'created' => Icons.schedule_rounded,
    'matched' => Icons.check_circle_outline,
    'locked' => Icons.attach_money_rounded,
    'payment' => Icons.chat_bubble_outline_rounded,
    'paid' => Icons.check_circle_outline,
    'confirming' => Icons.schedule_rounded,
    _ => Icons.error_outline,
  };
}

Color _statusColor(P2POrderTimelineStatus status) {
  return switch (status) {
    P2POrderTimelineStatus.completed => AppColors.buy,
    P2POrderTimelineStatus.pending => AppColors.warn,
    P2POrderTimelineStatus.failed => AppColors.sell,
  };
}

Color _statusBackground(P2POrderTimelineStatus status) {
  return switch (status) {
    P2POrderTimelineStatus.completed => AppColors.buy15,
    P2POrderTimelineStatus.pending => AppColors.warn15,
    P2POrderTimelineStatus.failed => AppColors.sell15,
  };
}

VitStatusPillStatus _pillStatus(P2POrderTimelineStatus status) {
  return switch (status) {
    P2POrderTimelineStatus.completed => VitStatusPillStatus.success,
    P2POrderTimelineStatus.pending => VitStatusPillStatus.warning,
    P2POrderTimelineStatus.failed => VitStatusPillStatus.error,
  };
}

String _localizedOrderStatus(String status) {
  return switch (status) {
    'awaiting_seller_confirmation' => 'Chờ người bán xác nhận',
    'payment_pending' => 'Chờ thanh toán',
    'completed' => 'Đã hoàn tất',
    'cancelled' => 'Đã hủy',
    _ => status,
  };
}
