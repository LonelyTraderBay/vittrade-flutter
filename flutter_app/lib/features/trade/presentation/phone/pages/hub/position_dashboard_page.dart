import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_body_review_widgets.dart';

part '../../../widgets/phone/position_dashboard_page_sections.dart';
part '../../../widgets/phone/position_dashboard_page_common.dart';

class PositionDashboardPage extends ConsumerStatefulWidget {
  const PositionDashboardPage({super.key, this.shellRenderMode});

  static Key tabKey(String id) => Key('sc053_tab_$id');
  static Key sortKey(String id) => Key('sc053_sort_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PositionDashboardPage> createState() =>
      _PositionDashboardPageState();
}

class _PositionDashboardPageState extends ConsumerState<PositionDashboardPage> {
  String _activeTab = 'all';
  String _sortBy = 'pnl';

  @override
  Widget build(BuildContext context) {
    final positionsAsync = ref.watch(tradePositionsProvider);

    return VitTradeHubScaffold(
      title: 'Vị thế đang mở',
      semanticLabel: 'Vị thế đang mở',
      semanticIdentifier: 'SC-053',
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      showProductTabs: true,
      navigationBuilder: buildTradeProductNavigation,
      children: positionsAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được vị thế đang mở',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradePositionsProvider),
          ),
        ],
        data: (snapshot) {
          final positions = _visiblePositions(snapshot.positions);
          return [
            VitTradeSection(
              title: 'Tổng quan',
              child: _SummaryCard(positions: snapshot.positions),
            ),
            const VitTradeSection(
              title: 'Đánh giá rủi ro',
              child: VitCard(
                variant: VitCardVariant.inner,
                radius: VitCardRadius.tight,
                padding: AppSpacing.cardPaddingCompact,
                child: VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  density: VitDensity.tool,
                  title: 'Open position risk review',
                  message:
                      'PnL, notional exposure, margin risk, close path, fees and next steps are reviewed before position actions.',
                  contractId: 'position-dashboard-review',
                ),
              ),
            ),
            VitTradeSection(
              title: 'Loại vị thế',
              child: _TypeTabs(
                active: _activeTab,
                positions: snapshot.positions,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
            ),
            VitTradeSection(
              title: 'Sắp xếp',
              child: _SortChips(
                active: _sortBy,
                onChanged: (sort) => setState(() => _sortBy = sort),
              ),
            ),
            VitTradeSection(
              title: 'Vị thế mở',
              child: positions.isEmpty
                  ? const _EmptyPositions()
                  : _PositionList(positions: positions),
            ),
            const TradeBodyReviewSection(
              title: 'Position body review',
              message: 'Position dashboard body reviewed',
              detail:
                  'Summary, risk, tabs, sort, empty, position rows, and result states stay visible.',
              primary: 'Risk review remains above open position actions.',
              secondary: 'Tabs and sort chips keep exposure scanning explicit.',
              tertiary:
                  'Position rows preserve PnL, notional, and margin context.',
            ),
          ];
        },
      ),
    );
  }

  List<TradeDashboardPosition> _visiblePositions(
    List<TradeDashboardPosition> source,
  ) {
    final filtered = _activeTab == 'all'
        ? source
        : source.where((position) => position.type.name == _activeTab);
    final sorted = filtered.toList(growable: false);
    sorted.sort((a, b) {
      if (_sortBy == 'pnlPct') return b.pnlPct.abs().compareTo(a.pnlPct.abs());
      if (_sortBy == 'size') return b.notional.compareTo(a.notional);
      return b.pnl.abs().compareTo(a.pnl.abs());
    });
    return sorted;
  }
}
