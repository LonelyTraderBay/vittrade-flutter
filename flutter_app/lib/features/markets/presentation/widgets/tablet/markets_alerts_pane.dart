import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Cảnh báo giá (SC-014): chip lọc All/Active/Triggered +
/// bảng cảnh báo độ dày tablet (symbol · điều kiện · giá mục tiêu · hiện tại
/// · trạng thái · hành động), state alerts sống ở
/// [marketPriceAlertsStateControllerProvider] (STATE-S23).
class MarketsAlertsPane extends ConsumerStatefulWidget {
  const MarketsAlertsPane({super.key});

  static const contentKey = Key('sc014_tablet_content');

  @override
  ConsumerState<MarketsAlertsPane> createState() => _MarketsAlertsPaneState();
}

class _MarketsAlertsPaneState extends ConsumerState<MarketsAlertsPane> {
  String _filter = 'all';

  List<MarketPriceAlert> _filteredAlerts(List<MarketPriceAlert> alerts) {
    return switch (_filter) {
      'active' => [
        for (final alert in alerts)
          if (alert.isActive) alert,
      ],
      'triggered' => [
        for (final alert in alerts)
          if (!alert.isActive && alert.triggeredAt != null) alert,
      ],
      _ => alerts,
    };
  }

  @override
  Widget build(BuildContext context) {
    final alertsAsync = ref.watch(marketPriceAlertsSnapshotProvider);
    final viewState = ref.watch(marketPriceAlertsStateControllerProvider);
    final alerts = viewState.alerts;
    final filteredAlerts = _filteredAlerts(alerts);
    final activeCount = alerts.where((alert) => alert.isActive).length;
    final triggeredCount = alerts
        .where((alert) => !alert.isActive && alert.triggeredAt != null)
        .length;

    return MarketsPaneScaffold(
      title: 'Cảnh báo giá',
      subtitle: 'Alerts · Markets',
      scrollKey: MarketsAlertsPane.contentKey,
      onRefresh: () async {
        ref.invalidate(marketPriceAlertsSnapshotProvider);
        await ref.read(marketPriceAlertsSnapshotProvider.future);
      },
      children: alertsAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được cảnh báo giá',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(marketPriceAlertsSnapshotProvider),
          ),
        ],
        data: (_) => [
          Row(
            children: [
              Expanded(
                child: VitSegmentedTabBar(
                  tabs: [
                    VitTabItem(key: 'all', label: 'Tất cả (${alerts.length})'),
                    VitTabItem(
                      key: 'active',
                      label: 'Đang chạy ($activeCount)',
                    ),
                    VitTabItem(
                      key: 'triggered',
                      label: 'Đã kích hoạt ($triggeredCount)',
                    ),
                  ],
                  activeKey: _filter,
                  onChanged: (value) => setState(() => _filter = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          if (filteredAlerts.isEmpty)
            const VitEmptyState(
              icon: Icons.notifications_off_outlined,
              title: 'Không có cảnh báo phù hợp',
              message: 'Thêm cảnh báo giá từ trang chi tiết cặp.',
            )
          else
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.zeroInsets,
              clip: true,
              child: Column(
                children: [
                  for (var i = 0; i < filteredAlerts.length; i++) ...[
                    _AlertRow(alert: filteredAlerts[i]),
                    if (i < filteredAlerts.length - 1)
                      const Divider(
                        height: TabletSpacingTokens.dividerHairline,
                        thickness: TabletSpacingTokens.dividerHairline,
                        color: AppColors.divider,
                      ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AlertRow extends ConsumerWidget {
  const _AlertRow({required this.alert});

  final MarketPriceAlert alert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conditionLabel = alert.condition == MarketAlertCondition.above
        ? 'Trên'
        : 'Dưới';
    final triggered = !alert.isActive && alert.triggeredAt != null;
    return Padding(
      padding: TabletSpacingTokens.tableCellPadding,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              alert.symbol,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                color: AppColors.text1,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '$conditionLabel ${formatMarketPriceAdaptive(alert.targetPrice)}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatMarketPriceAdaptive(alert.currentPrice),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: VitStatusPill(
              label: triggered
                  ? 'Đã kích hoạt'
                  : alert.isActive
                  ? 'Đang chạy'
                  : 'Tạm dừng',
              status: triggered
                  ? VitStatusPillStatus.success
                  : alert.isActive
                  ? VitStatusPillStatus.info
                  : VitStatusPillStatus.neutral,
              size: VitStatusPillSize.sm,
            ),
          ),
          IconButton(
            tooltip: alert.isActive ? 'Tạm dừng' : 'Bật lại',
            onPressed: () => ref
                .read(marketPriceAlertsStateControllerProvider.notifier)
                .toggleAlert(alert.id),
            icon: Icon(
              alert.isActive
                  ? Icons.pause_circle_outline_rounded
                  : Icons.play_circle_outline_rounded,
              size: TabletSpacingTokens.iconMd,
              color: AppColors.text2,
            ),
          ),
          IconButton(
            tooltip: 'Xóa cảnh báo',
            onPressed: () => ref
                .read(marketPriceAlertsStateControllerProvider.notifier)
                .deleteAlert(alert.id),
            icon: const Icon(
              Icons.delete_outline_rounded,
              size: TabletSpacingTokens.iconMd,
              color: AppColors.text3,
            ),
          ),
        ],
      ),
    );
  }
}
