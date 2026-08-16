import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/execution/live_market_data_analytics_widgets.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';

class LiveMarketDataAnalyticsPage extends ConsumerStatefulWidget {
  const LiveMarketDataAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc091_live_market_analytics_content');
  static Key tabKey(String id) => Key('sc091_live_market_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LiveMarketDataAnalyticsPage> createState() =>
      _LiveMarketDataAnalyticsPageState();
}

class _LiveMarketDataAnalyticsPageState
    extends ConsumerState<LiveMarketDataAnalyticsPage> {
  String _tab = 'market';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeLiveMarketDataAnalyticsProvider);

    return VitTradeHubScaffold(
      title: 'Phân tích trực tiếp',
      subtitle: 'Dữ liệu realtime',
      semanticLabel:
          'Phân tích trực tiếp dữ liệu thị trường theo thời gian thực',
      semanticIdentifier: 'SC-091',
      contentKey: LiveMarketDataAnalyticsPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeMargin,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(tradeLiveMarketDataAnalyticsProvider),
          ),
        ],
        data: (snapshot) => [
          const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            density: VitDensity.tool,
            title: 'Xem lại rủi ro dữ liệu trực tiếp',
            message:
                'Luồng realtime có thể trễ hoặc ngắt khi biến động mạnh. Xác nhận thanh khoản, giới hạn và rủi ro khớp lệnh trước khi giao dịch.',
          ),
          LiveMarketPairCard(snapshot: snapshot),
          LiveMarketUnderlineTabs(
            activeId: _tab,
            onChanged: (id) => setState(() => _tab = id),
            keyBuilder: LiveMarketDataAnalyticsPage.tabKey,
          ),
          LiveMarketTabContent(activeTab: _tab, snapshot: snapshot),
        ],
      ),
    );
  }
}
