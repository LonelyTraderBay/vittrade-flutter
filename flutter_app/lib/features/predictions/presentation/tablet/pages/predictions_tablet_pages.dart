import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/tablet/prediction_event_card_tablet.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/portfolio/prediction_portfolio_common.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/portfolio/prediction_portfolio_summary.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/portfolio/prediction_portfolio_positions.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/portfolio/prediction_portfolio_orders.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/portfolio/prediction_portfolio_history.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/portfolio/predictions_portfolio_bridge_card.dart';

part 'predictions_tablet_pages_explore.dart';
part 'predictions_tablet_pages_social.dart';
part 'predictions_tablet_pages_discovery.dart';
part 'predictions_tablet_pages_breaking.dart';
part 'predictions_tablet_pages_rewards.dart';
part 'predictions_tablet_pages_leaderboard.dart';
part 'predictions_tablet_pages_tournaments.dart';
part 'predictions_tablet_pages_chart.dart';

String _pdmUsd(num v) => VitFormat.usd(v.toDouble());
Widget _pdmError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _pdmTinyBadge({
  required String label,
  required Color color,
  required Color background,
}) {
  return Material(
    color: background,
    borderRadius: AppRadii.badgeRadius,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TabletSpacingTokens.x2,
        vertical: TabletSpacingTokens.x1,
      ),
      child: Text(label, style: AppTextStyles.badge.copyWith(color: color)),
    ),
  );
}

Widget _pdmBody(String text) {
  return Text(
    text,
    style: AppTextStyles.caption.copyWith(color: AppColors.text2, height: 1.3),
  );
}

/// SC-212: Danh mục prediction trên tablet — tái composition theo phone
/// SC-031: hero tổng quan (ẩn/hiện giá trị), thông báo cổ phần, 3 tab
/// Đang mở / Đã đóng / Lịch sử, lệnh mở có hủy, cầu nối Arena. Toàn bộ
/// section tái dùng widget standalone của feature.
class PredictionsPortfolioTabletPage extends ConsumerStatefulWidget {
  const PredictionsPortfolioTabletPage({super.key});

  static const contentKey = Key('sc212_tablet_content');
  static const activeTabKey = Key('sc212_tab_active');
  static const closedTabKey = Key('sc212_tab_closed');
  static const historyTabKey = Key('sc212_tab_history');

  @override
  ConsumerState<PredictionsPortfolioTabletPage> createState() =>
      _PredictionsPortfolioTabletPageState();
}

class _PredictionsPortfolioTabletPageState
    extends ConsumerState<PredictionsPortfolioTabletPage> {
  PredictionPortfolioTab _activeTab = PredictionPortfolioTab.active;
  bool _isHidden = false;
  final Set<String> _cancelledOrderIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(predictionsPortfolioControllerProvider);

    return controllerAsync.when(
      loading: () => _frame(children: const [VitSkeletonList(rows: 6)]),
      error: (error, stackTrace) => _frame(
        children: [
          _pdmError(
            'Không tải được danh mục',
            () => ref.invalidate(predictionsPortfolioSnapshotProvider),
          ),
        ],
      ),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        final openOrders = controller.openOrdersExcluding(_cancelledOrderIds);
        return _frame(
          subtitle: 'Giá trị ${_pdmUsd(snapshot.totalCurrentValue)}',
          children: [
            VitCard(
              variant: VitCardVariant.hero,
              radius: VitCardRadius.large,
              clip: true,
              padding: TabletSpacingTokens.cardPaddingHero,
              background: const VitHeroGlow(),
              child: PredictionPortfolioSummaryCard(
                snapshot: snapshot,
                openOrderCount: openOrders.length,
                isHidden: _isHidden,
                onToggleHidden: () => setState(() {
                  _isHidden = !_isHidden;
                }),
              ),
            ),
            const VitAnnouncementBanner(
              message: predictionPortfolioSharesNoteMessage,
              icon: Icons.info_outline_rounded,
              accentColor: AppColors.primary,
              variant: VitAnnouncementBannerVariant.compact,
            ),
            VitTabBar(
              variant: VitTabBarVariant.segment,
              activeKey: _sc212TabKey(_activeTab),
              onChanged: (key) => setState(() {
                _activeTab = PredictionPortfolioTab.values.byName(key);
              }),
              tabs: const [
                VitTabItem(
                  key: 'active',
                  label: 'Đang mở',
                  widgetKey: PredictionsPortfolioTabletPage.activeTabKey,
                ),
                VitTabItem(
                  key: 'closed',
                  label: 'Đã đóng',
                  widgetKey: PredictionsPortfolioTabletPage.closedTabKey,
                ),
                VitTabItem(
                  key: 'history',
                  label: 'Lịch sử',
                  widgetKey: PredictionsPortfolioTabletPage.historyTabKey,
                ),
              ],
            ),
            if (_activeTab == PredictionPortfolioTab.active)
              PredictionPortfolioPositionsList(
                snapshot: snapshot,
                positions: snapshot.activePositions,
                emptyTitle: 'Chưa có vị thế đang mở',
                emptySubtitle: 'Bắt đầu giao dịch để xây danh mục',
              )
            else if (_activeTab == PredictionPortfolioTab.closed)
              PredictionPortfolioPositionsList(
                snapshot: snapshot,
                positions: snapshot.closedPositions,
                emptyTitle: 'Chưa có vị thế đã đóng',
                emptySubtitle: 'Vị thế đã đóng sẽ hiện ở đây',
              )
            else
              PredictionPortfolioHistorySection(snapshot: snapshot),
            if (_activeTab == PredictionPortfolioTab.active &&
                openOrders.isNotEmpty)
              PredictionPortfolioOpenOrdersSection(
                snapshot: snapshot,
                orders: openOrders,
                onCancel: (orderId) => setState(() {
                  _cancelledOrderIds.add(orderId);
                }),
              ),
            PredictionsPortfolioArenaBridgeCard(
              onTap: () => context.push(AppRoutePaths.arena),
            ),
          ],
        );
      },
    );
  }

  Widget _frame({required List<Widget> children, String? subtitle}) {
    return VitTabletSectionFrame(
      gutterFlush: true,
      semanticIdentifier: 'SC-212',
      semanticLabel: 'Danh mục prediction',
      title: 'Danh mục prediction',
      subtitle: subtitle ?? 'Vị thế · Lệnh · Lịch sử',
      contentKey: PredictionsPortfolioTabletPage.contentKey,
      backFallback: AppRoutePaths.marketsPredictions,
      children: children,
    );
  }
}

String _sc212TabKey(PredictionPortfolioTab tab) {
  return switch (tab) {
    PredictionPortfolioTab.active => 'active',
    PredictionPortfolioTab.closed => 'closed',
    PredictionPortfolioTab.history => 'history',
  };
}
