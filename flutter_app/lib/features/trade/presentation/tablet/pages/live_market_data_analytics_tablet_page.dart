import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/execution/live_market_data_analytics_widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';

/// Port tablet của Phân tích trực tiếp (SC-091): nội dung tuyến tính một
/// cột (chuẩn Linear-detail), tái dùng nguyên khối widget public của trang
/// phone theo R2 — chỉ thay khung ngoài bằng VitHeader + nhịp tablet.
class LiveMarketDataAnalyticsTabletPage extends ConsumerStatefulWidget {
  const LiveMarketDataAnalyticsTabletPage({super.key});

  static const contentKey = Key('sc091_tablet_content');

  static Key tabKey(String id) => Key('sc091_tablet_tab_$id');

  @override
  ConsumerState<LiveMarketDataAnalyticsTabletPage> createState() =>
      _LiveMarketDataAnalyticsTabletPageState();
}

class _LiveMarketDataAnalyticsTabletPageState
    extends ConsumerState<LiveMarketDataAnalyticsTabletPage> {
  String _tab = 'market';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeLiveMarketDataAnalyticsProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Phân tích trực tiếp dữ liệu thị trường theo thời gian thực',
      semanticIdentifier: 'SC-091',
      child: Column(
        children: [
          VitHeader(
            title: 'Phân tích trực tiếp',
            subtitle: 'Dữ liệu realtime',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.tradeMargin,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
            backKey: TradeTabletKeys.back,
          ),
          Expanded(
            child: async.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được dữ liệu',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(tradeLiveMarketDataAnalyticsProvider),
                ),
              ),
              data: (snapshot) => VitTabletSectionBody(
                children: [
                  VitPageContent(
                    key: LiveMarketDataAnalyticsTabletPage.contentKey,
                    rhythm: VitPageRhythm.standard,
                    density: VitDensity.standard,
                    fullBleed: true,
                    children: [
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
                        keyBuilder: LiveMarketDataAnalyticsTabletPage.tabKey,
                      ),
                      LiveMarketTabContent(activeTab: _tab, snapshot: snapshot),
                    ],
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
